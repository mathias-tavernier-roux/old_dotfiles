{ vms, username }:
{ config, pkgs, lib, ... }:
if vms != false
then {
  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "amdgpu"
    ];

        extraModprobeConfig = lib.concatStrings ([
      ''
        options kvm_intel kvm_amd modeset=1
      ''
    ] ++ (builtins.map (vm:

      (if (vm.blacklistPcie != false)
      then ''
          options vfio-pci ids=${vm.blacklistPcie}
        ''
      else "")

    ) vms) ++ (builtins.map (vm:
      lib.concatStrings (if vm.pcies != false
      then lib.forEach vm.pcies (pcie:

        if pcie.blacklistDriver
        then ''
            options ${pcie.driver} modeset=0
            blacklist ${pcie.driver}
          ''
        else ""

      ) else [])) vms)
    );

    kernelParams = [
      "intel_iommu=on"
      "amd_iommu=on"
      "iommu=pt"
      "video=efifb:off"
    ];
  };

  environment.systemPackages = [
    (pkgs.callPackage ./rofi-vm { })
  ];
  
  services = {
    samba = {
      openFirewall = true;
      enable = true;
      securityType = "user";
      ### --------------------------------------------------------- ###
      shares = {
        home = {
          path = "/home/${username}";
          browseable = "yes";
          writeable = "yes";
          "acl allow execute always" = true;
          "read only" = "no";
          "valid users" = "${username}";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "${username}";
          "force group" = "users";
        };
        #### ----------------------------------------------------- ####
        media = {
          path = "/run/media/${username}";
          browseable = "yes";
          writeable = "yes";
          "acl allow execute always" = true;
          "read only" = "no";
          "valid users" = "${username}";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "${username}";
          "force group" = "users";
        };
      };
    };
  };

  systemd.services.libvirtd.preStart = lib.concatStrings (builtins.map (vm:
    let
      pcies = if vm.pcies != false
      then builtins.map (pcie: {
        pcie = "${pcie.pcie.bus}:${pcie.pcie.slot}.${pcie.pcie.function}";
        escapePcie = "${pcie.pcie.bus}\\:${pcie.pcie.slot}.${pcie.pcie.function}";
        vmBus = pcie.pcie.vmBus;
        bus = pcie.pcie.bus;
        slot = pcie.pcie.slot;
        function = pcie.pcie.function;
        driver = pcie.driver;
        blacklistDriver = pcie.blacklistDriver;
        blacklistPcie = pcie.blacklistPcie;
      }) vm.pcies
      else false;

      unbindList = if pcies != false
      then lib.concatStrings (builtins.map (pcie: 
        if (! pcie.blacklistDriver && ! pcie.blacklistPcie)
        then ''
          echo 0000:${pcie.pcie} > /sys/bus/pci/devices/0000\:${pcie.escapePcie}/driver/unbind 2> /dev/null
        ''
        else ""
      ) pcies)
      else "";

      bindList = if pcies != false
      then lib.concatStrings (builtins.map (pcie: 
        if (! pcie.blacklistDriver && ! pcie.blacklistPcie)
        then ''
          echo 0000:${pcie.pcie} > /sys/bus/pci/drivers/${pcie.driver}/bind 2> /dev/null
        ''
        else ""
      ) pcies)
      else "";

      restartDmFormated = if vm.restartDm
      then "systemctl restart display-manager.service"
      else "";

      pciesXml = if pcies != false
      then lib.concatStrings (builtins.map (pcie: ''
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
      '') pcies)
      else "";

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
      ''
      else ''
        <model type='none'/>
      '';

      graphicsVirtio = if vm.videoVirtio != false
      then ''
        <graphics type='spice'>
          <listen type="none"/>
          <image compression="off"/>
          <gl enable="no"/>
        </graphics>
      ''
      else ''
        <graphics type="spice" port="-1" autoport="no">
          <listen type="address"/>
          <image compression="off"/>
          <gl enable="no"/>
        </graphics>
      '';

      ssdEmulation = if vm.ssdEmulation
      then ''
        <qemu:override>
          <qemu:device alias="scsi0-0-0-0">
            <qemu:frontend>
              <qemu:property name="rotation_rate" type="unsigned" value="1"/>
            </qemu:frontend>
          </qemu:device>
        </qemu:override>
      ''
      else "";

      virtioIso = if vm.os == "win11"
      then ''
        <disk type='file' device='cdrom'>
          <driver name='qemu' type='raw'/>
          <source file='/home/${username}/VM/ISO/virtio-win.iso'/>
          <target dev='sdc' bus='sata'/>
          <readonly/>
          <address type='drive' controller='0' bus='0' target='0' unit='2'/>
        </disk>
      ''
      else "";

      osUrl = if vm.os == "linux"
      then "http://libosinfo.org/linux/2022"
      else "http://microsoft.com/win/11";

      qemuHook = pkgs.writeScript "qemu-hook" (
        builtins.replaceStrings [
          "{{ unbindList }}"
          "{{ bindList }}"
          "{{ restartDm }}"
          "{{ username }}"
        ] [
          unbindList
          bindList
          restartDmFormated
          username
        ] (builtins.readFile ./src/qemuHook.sh)
      );

      templateConfig = pkgs.writeScript "template-config" (
        builtins.replaceStrings [
          "{{ vm.memory }}"
          "{{ vm.vcore }}"
          "{{ vm.cores }}"
          "{{ vm.threads }}"
          "{{ vm.pcies }}"
          "{{ vm.diskPath }}"
          "{{ videoVirtio }}"
          "{{ graphicsVirtio }}"
          "{{ vm.name }}"
          "{{ ssdEmulation }}"
          "{{ osUrl }}"
        ] [
          (toString vm.memory)
          (toString (vm.cores * vm.threads))
          (toString vm.cores)
          (toString vm.threads)
          pciesXml
          vm.diskPath
          videoVirtio
          graphicsVirtio
          vm.name
          ssdEmulation
          osUrl
        ] (builtins.readFile ./src/template.xml)
      );

      templateSetupConfig = pkgs.writeScript "template-setup-config" (
        builtins.replaceStrings [
          "{{ vm.memory }}"
          "{{ vm.vcore }}"
          "{{ vm.cores }}"
          "{{ vm.threads }}"
          "{{ username }}"
          "{{ vm.diskPath }}"
          "{{ vm.name }}"
          "{{ ssdEmulation }}"
          "{{ virtioIso }}"
          "{{ osUrl }}"
          "{{ vm.isoName }}"
        ] [
          (toString vm.memory)
          (toString (vm.cores * vm.threads))
          (toString vm.cores)
          (toString vm.threads)
          username
          vm.diskPath
          vm.name
          ssdEmulation
          virtioIso
          osUrl
          vm.isoName
        ] (builtins.readFile ./src/template-setup.xml)
      );

      pathISO = pkgs.writeScript "path-iso" (
        builtins.replaceStrings [
          "{{ username }}"
        ] [
          username
        ] (builtins.readFile ./src/ISO.xml)
      );
    in
      ''
        mkdir -p /var/lib/libvirt/{hooks,qemu,storage}
        chmod 755 /var/lib/libvirt/{hooks,qemu,storage}

        if [ ! -f ${vm.diskPath}/${vm.name}.qcow2 ]; then
          # qemu-img create \
          #  -f qcow2 ${vm.diskPath}/${vm.name}.qcow2 \
          #  ${(toString vm.diskSize)}G

          echo "test"
        fi

        # Copy hook files
        ln -sf ${qemuHook} /var/lib/libvirt/hooks/qemu.d/${vm.name}
        ln -sf ${pathISO} /var/lib/libvirt/storage/ISO.xml
        ln -sf ${templateConfig} /var/lib/libvirt/qemu/${vm.name}.xml
        ln -sf ${templateSetupConfig} /var/lib/libvirt/qemu/${vm.name}-setup.xml
      ''
  ) vms);
}
else {
  boot.extraModprobeConfig = ''
    options kvm_intel kvm_amd modeset=1
  '';
}
