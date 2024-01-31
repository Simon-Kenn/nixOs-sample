{ config, lib, modulesPath, ... }:
{
	boot = {
		initrd = {
			availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
		};
		kernelModules = [ "kvm-intel" ];
	};

	#networking.useDHCP = lib.mkDefault true;

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
