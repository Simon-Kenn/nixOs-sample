# nixOs-sample

## Installation depuis l'installateur de NixOs
- `git clone https://Simon-Kenn/nixOs-sample.git`
- `cd nixOs-sample`
- `sudo nix --experimental-features 'nix-command flakes' build .#nixosConfigurations.hostname.config.system.build.diskoImagesScript`
- `sudo ./execute`
- `sudo nixos-install .#hostname`
