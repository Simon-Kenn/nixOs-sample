# nixOs-sample

This repo is an exemple configuration of a minimal nixos configuration.
The given gpg and ssh key are commited for test purpose do not use them 

username: user
disk / user / root password: password
gpg password: password123

## Feature
- Single and declarative (via disko) encrypted root btrfs with impermanence (root erase beetween reboot)
- Secrets like user password and wifi protected via sops using gpg (for editing the secret file) and age from ssh host key (for using the passwords)


## Installation depuis l'installateur de NixOs
- `cd nixOs-sample`

## Importing exemple private key
`gpg --import ~/Codes/nixos-sample/open-secrets/private.pgp`

## Installation process
- `git clone https://github.com/simon-kenn/nixos-sample && cd nixos-sample`

- `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko nixos/encrypted-ephemeral-btrfs.nix`

- `sudo nixos-install --flake .#host`
