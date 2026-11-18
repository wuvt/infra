# infra

Repo for managing our infrastructure and deploying services

## Adding a master key
```sh
# answer no when it offers an identity file
age-plugin-fido2-hmac -g -pq

# add the pub key to keys/masters/<name>.pub

./scripts/rekey.sh
```

## Issuing a host key
```sh
mkdir -p hosts/<host>/keys
ssh-keygen -q -t ed25519 -N '' -C root@<host>.wuvt.vt.edu -f /tmp/key
mv /tmp/key.pub hosts/<host>/keys/ssh_host_ed25519_key.pub
agenix -e hosts/<host>/keys/ssh_host_ed25519_key.age < /tmp/key
rm -f /tmp/key*

./scripts/rekey.sh
```

## Building the iso
```sh
nix build .#iso
```

## Installing from the iso
```sh
mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount -o umask=0077 /dev/disk/by-label/BOOT /mnt/boot

mkdir /mnt/etc
age -d -j fido2-hmac /iso/infra/secrets/iso-id.age > /mnt/etc/iso-id
chmod 400 /mnt/etc/iso-id
nixos-install --no-root-password --flake 'github:wuvt/infra#<hostname>'
#or
nixos-install --no-root-password --flake 'git+https://github.com/wuvt/infra#<hostname>'
#or
nixos-install --no-root-password --flake 'git+ssh://git@github.com/wuvt/infra#<hostname>'
```
