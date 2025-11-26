# Reproduction
```sh
nix run github:gekoke/noshell-repro#nixosConfigurations.default.config.system.build.vmWithBootLoader
```

Login: `test`
Password: `password`

Reproduced if you see a plain `$` as prompt

# Expected

```sh
nix run github:gekoke/noshell-repro#nixosConfigurations.expected.config.system.build.vmWithBootLoader
```
