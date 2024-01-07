{ 
  description = "Minimal secure nixOs configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		sops-nix = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};

  };

  outputs = {
    self,
    nixpkgs,
		home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

		systems = [
			"aarch64-linux"
			"i686-linux"
			"x86_64-linux"
			"aarch64-darwin"
			"x86_64-darwin"
		];

		forAllSystems = nixpkgs.lib.genAttrs systems;
  in {

		packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
		formater = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
		overlays = import ./overlays {inherit inputs;};

		nixosModules = import ./modules/nixos;
		homeManagerModules = import ./modules/home-manager;

		nixosConfigurations = {
			# Personal laptop
			nautilus = nixpkgs.lib.nixosSystem {
				modules = [./hosts/nautilus];
				specialArgs = {inherit inputs outputs;};
			};
		};

		homeConfigurations = {
			"misterio@nautilus" = home-manager.lib.homeManagerConfiguration {
				modules = [./home];
				pkgs = nixpkgs.legacyPackages.x86_64-linux;
				extraSpecialArgs = {inherit inputs outputs;};
			};
		};
  };
}
