# nixOs-sample

## Installation depuis l'installateur de NixOs
- `git clone https://Simon-Kenn/nixOs-sample.git`
- `cd nixOs-sample`
- `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko nixos/encrypted-ephemeral-btrfs.nix`
- `cp -r . /mnt/persist/nixos-sample`
- `sudo nixos-install --flake .#host`
