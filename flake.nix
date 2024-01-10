{ 
  description = "Minimal secure nixOs configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};

  };

  outputs = {
    self,
    nixpkgs,
		disko,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
		nixosConfigurations.nautilus = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
			];
			specialArgs = {inherit inputs outputs;};
		};
  };
}
