{ 
  description = "Minimal secure nixOs configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		impermanence.url = "github:nix-community/impermanence";

		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};
  };

  outputs = {
    nixpkgs,
		disko,
    ...
  }: 
{
		nixosConfigurations.host = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				disko.nixosModules.disko
				./nixos/default.nix
			];
		};
  };
}
