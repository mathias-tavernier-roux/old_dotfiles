{ vm, username }:
{ config, pkgs, lib, ... }:
if vm != false
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
        (if (vm.blacklistPcie != false) then ''
          options vfio-pci ids=${vm.blacklistPcie}
        '' else "")
      ] ++ (if vm.pcies != false
      then lib.forEach vm.pcies (pcie:
        if pcie.blacklistDriver then
          ''
            options ${pcie.driver} modeset=0
            blacklist ${pcie.driver}
          ''
        else ""
      ) else []));

    kernelParams = [
      "intel_iommu=on"
      "amd_iommu=on"
      "iommu=pt"
      "video=efifb:off"
    ];
  };

  environment = {
    systemPackages = [
      (pkgs.callPackage ./winutils {
        virtGl = vm.virtGl;
        inherit username;
        diskPath = vm.diskPath;
      })
    ];
  };

  systemd.services.libvirtd.preStart = let
    pcies = if vm.pcies != false
    then lib.forEach vm.pcies (pcie: {
      pcie = "${pcie.pcie.bus}:${pcie.pcie.slot}.${pcie.pcie.function}";
      escapePcie = "${pcie.pcie.bus}\\:${pcie.pcie.slot}.${pcie.pcie.function}";
      vmBus = pcie.pcie.vmBus;
      bus = pcie.pcie.bus;
      slot = pcie.pcie.slot;
      function = pcie.pcie.function;
      driver = pcie.driver;
      blacklistDriver = pcie.blacklistDriver;
      blacklistPcie = pcie.blacklistPcie;
      diskPath = vm.diskPath;
    }) else false;

    unbindList = if pcies != false
    then lib.concatStrings (lib.forEach pcies (pcie: 
      if (! pcie.blacklistDriver && ! pcie.blacklistPcie) then ''
        echo 0000:${pcie.pcie} > /sys/bus/pci/devices/0000\:${pcie.escapePcie}/driver/unbind 2> /dev/null
        '' else ""
    )) else "";
    bindList = if pcies != false
    then lib.concatStrings (lib.forEach pcies (pcie: 
      if (! pcie.blacklistDriver && ! pcie.blacklistPcie) then ''
        echo 0000:${pcie.pcie} > /sys/bus/pci/drivers/${pcie.driver}/bind 2> /dev/null
        '' else ""
    )) else "";

    restartDm =
      if vm.restartDm
      then "systemctl restart display-manager.service"
      else "# disable restart dm";

    pciesXml = if pcies != false
    then lib.concatStrings (
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
    ) else "";

    videoVirtio = if vm.videoVirtio != false
    then ''
      <model type="virtio" heads="1" primary="yes">
        <acceleration accel3d="no"/>
      </model>
      <address
        type="pci"
        domain="0x0000"
        bus="0x00"
        slot="0x01"
        function="0x0"
      />
    '' else ''
      <model type='none'/>
    '';

    graphicsVirtio = if vm.videoVirtio != false
    then ''
      <graphics type='spice'>
        <listen type="none"/>
        <image compression="off"/>
        <gl enable="no"/>
      </graphics>
    '' else ''
      <graphics type="spice" port="-1" autoport="no">
        <listen type="address"/>
        <image compression="off"/>
        <gl enable="no"/>
      </graphics>
    '';

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
        "{{ vm.memory }}"
        "{{ vm.vcore }}"
        "{{ vm.cores }}"
        "{{ vm.threads }}"
        "{{ vm.pcies }}"
        "{{ vm.diskPath }}"
        "{{ videoVirtio }}"
        "{{ graphicsVirtio }}"
      ] [
        (toString vm.memory)
        (toString (vm.cores * vm.threads))
        (toString vm.cores)
        (toString vm.threads)
        pciesXml
        vm.diskPath
        videoVirtio
        graphicsVirtio
      ] (builtins.readFile ./src/win11.xml)
    );
    win11NoGPUConfig = pkgs.writeScript "win11-no-gpu-config" (
      builtins.replaceStrings [
        "{{ vm.memory }}"
        "{{ vm.vcore }}"
        "{{ vm.cores }}"
        "{{ vm.threads }}"
        "{{ username }}"
        "{{ vm.diskPath }}"
      ] [
        (toString vm.memory)
        (toString (vm.cores * vm.threads))
        (toString vm.cores)
        (toString vm.threads)
        username
        vm.diskPath
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

    if [ ! -f ${vm.diskPath}/win11.qcow2 ]; then
      qemu-img create -f qcow2 ${vm.diskPath}/win11.qcow2 ${(toString vm.diskSize)}G
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
