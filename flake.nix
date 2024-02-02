{ 
  description = "Minimal secure nixOs configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		impermanence.url = "github:nix-community/impermanence";

		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
  };

  outputs = {
		self,
    nixpkgs,
		home-manager,
    ...
  } @inputs: let
		inherit (self) outputs;
	
		lib = nixpkgs.lib // home-manager.lib;
		systems = [
			"aarch64-linux"
			"i686-linux"
			"x86_64-linux"
			"aarch64-darwin"
			"x86_64-darwin"
		];
		pkgsFor = lib.genAttrs systems (system: import nixpkgs {
			inherit system;
			config.allowUnfree = true;
		});
		forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
	in {
		nixosConfigurations.host = lib.nixosSystem {
			system = "x86_64-linux";
			modules = [ ./nixos/default.nix ];
			specialArgs = { inherit inputs outputs; };
		};

		homeConfigurations = {
			"user@host" = lib.homeManagerConfiguration {
				modules = [ ./home ];
				pkgs = nixpkgs.legacyPackages.x86_64-linux;	
				extraSpecialArgs = { inherit inputs outputs; };
			};
		};
  };
}
