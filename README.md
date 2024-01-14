# nixOs-sample

## Installation depuis l'installateur de NixOs
- `git clone https://Simon-Kenn/nixOs-sample.git`
- `cd nixOs-sample`
- `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko nixos/disk-config.nix`
- `sudo ./execute`
- `sudo nixos-install .#hostname`

`nix --experimental-features 'nix-command flakes" run github:nix-community/nixos-anywhere -- --flake github:Simon-Kenn/nixOs-sample#hostname nixos@192.168.1.51`
