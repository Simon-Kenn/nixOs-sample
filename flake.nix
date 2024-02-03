{ 
  description = "Minimal secure nixOs configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		impermanence.url = "github:nix-community/impermanence";
		sops-nix.url = "github:Mic92/sops-nix";

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
	in {
		inherit lib;

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
