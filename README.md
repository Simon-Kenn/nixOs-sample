# nixOs-sample

## Installation depuis l'installateur de NixOs
- `git clone https://Simon-Kenn/nixOs-sample.git`
- `cd nixOs-sample`
- `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko nixos/disk-config.nix`
- `btrfs subvolume snapshot -r /mnt/root /mnt/root-blank`
- `sudo nixos-install --flake .#host`
