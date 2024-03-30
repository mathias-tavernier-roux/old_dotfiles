{ vfio, username }:
{ config, pkgs, lib, ... }:
if vfio != false
then {
  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "vfio_virqfd"
      "amdgpu"
    ];

    extraModprobeConfig = lib.concatStrings ([
      ''
        options kvm_intel kvm_amd modeset=1
      ''
      ] ++ lib.forEach vfio.pcies (pcie:
        if pcie.blacklistDriver then
          ''
            options ${pcie.driver} modeset=0
            blacklist ${pcie.driver}
          ''
        else
        ""
      ));
  };

  environment = {
    systemPackages = [
      (pkgs.callPackage ./winutils { })
    ];
  };

  systemd.services.libvirtd.preStart = let
    pcies = lib.forEach vfio.pcies (pcie: {
      pcie = "${pcie.pcie.bus}:${pcie.pcie.slot}.${pcie.pcie.function}";
      escapePcie = "${pcie.pcie.bus}\\:${pcie.pcie.slot}.${pcie.pcie.function}";
      vmBus = pcie.pcie.vmBus;
      bus = pcie.pcie.bus;
      slot = pcie.pcie.slot;
      function = pcie.pcie.function;
      driver = pcie.driver;
      blacklistDriver = pcie.blacklistDriver;
    });

    unbindList = lib.concatStrings (lib.forEach pcies (pcie: 
      if (! pcie.blacklistDriver) then ''
        echo 0000:${pcie.pcie} > /sys/bus/pci/devices/0000\:${pcie.escapePcie}/driver/unbind 2> /dev/null''
      else ""
    ));
    bindList = lib.concatStrings (lib.forEach pcies (pcie: 
      if (! pcie.blacklistDriver) then ''
        echo 0000:${pcie.pcie} > /sys/bus/pci/drivers/${pcie.driver}/bind 2> /dev/null''
      else ""
    ));

    restartDm =
      if vfio.restartDm
      then "systemctl restart display-manager.service"
      else "# disable restart dm";

    pciesXml = lib.concatStrings (
      lib.forEach pcies (pcie: ''
        <hostdev
          mode='subsystem'
          type='pci'
          managed='yes'
        >
          <source>
            <address
              domain='0x0000'
              bus='0x${pcie.bus}'
              slot='0x${pcie.slot}'
              function='0x${pcie.function}'
            />
          </source>
          <address
            type='pci'
            domain='0x0000'
            bus='0x${pcie.vmBus}'
            slot='0x${pcie.slot}'
            function='0x${pcie.function}'
          />
          <!-- multifunction='on' -->
        </hostdev>
      '')
    );

    qemuHook = pkgs.writeScript "qemu-hook" (
      builtins.replaceStrings [
        "{{ unbindList }}"
        "{{ bindList }}"
        "{{ restartDm }}"
        "{{ username }}"
      ] [
        unbindList
        bindList
        restartDm
        username
      ] (builtins.readFile ./src/qemuHook.sh)
    );
    win11Config = pkgs.writeScript "win11-config" (
      builtins.replaceStrings [
        "{{ vfio.memory }}"
        "{{ vfio.vcore }}"
        "{{ vfio.cores }}"
        "{{ vfio.threads }}"
        "{{ vfio.pcies }}"
      ] [
        (toString vfio.memory)
        (toString (vfio.cores * vfio.threads))
        (toString vfio.cores)
        (toString vfio.threads)
        pciesXml
      ] (builtins.readFile ./src/win11.xml)
    );
    win11NoGPUConfig = pkgs.writeScript "win11-no-gpu-config" (
      builtins.replaceStrings [
        "{{ vfio.memory }}"
        "{{ vfio.vcore }}"
        "{{ vfio.cores }}"
        "{{ vfio.threads }}"
        "{{ username }}"
      ] [
        (toString vfio.memory)
        (toString (vfio.cores * vfio.threads))
        (toString vfio.cores)
        (toString vfio.threads)
        (username)
      ] (builtins.readFile ./src/win11-no-gpu.xml)
    );
    pathISO = pkgs.writeScript "path-iso" (
      builtins.replaceStrings [
        "{{ username }}"
      ] [
        username
      ] (builtins.readFile ./src/ISO.xml)
    );

  in ''
    mkdir -p /var/lib/libvirt/{hooks,qemu,storage}
    chmod 755 /var/lib/libvirt/{hooks,qemu,storage}

    if [ ! -f /var/lib/libvirt/images/win11.qcow2 ]; then
      qemu-img create -f qcow2 /var/lib/libvirt/images/win11.qcow2 ${(toString vfio.diskSize)}G
    fi

    # Copy hook files
    ln -sf ${qemuHook} /var/lib/libvirt/hooks/qemu
    ln -sf ${pathISO} /var/lib/libvirt/storage/ISO.xml
    ln -sf ${win11Config} /var/lib/libvirt/qemu/win11.xml
    ln -sf ${win11NoGPUConfig} /var/lib/libvirt/qemu/win11-no-gpu.xml
  '';
}
else {
  boot.extraModprobeConfig = ''
    options kvm_intel kvm_amd modeset=1
  '';
}
