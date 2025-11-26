{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";

    noshell.url = "github:viperML/noshell";
    noshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.home-manager.nixosModules.default
        inputs.noshell.nixosModules.default
        {
          # `stateVersion` I was running on, probably doesn't matter
          system.stateVersion = "24.11";

          boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
          };

          users = {
            users.test = {
              isNormalUser = true;
              initialPassword = "password";
              createHome = true;
            };
          };

          programs.noshell.enable = true;

          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;

            sharedModules = [
              (
                {
                  pkgs,
                  lib,
                  osConfig,
                  ...
                }:
                {
                  options.repro.enable = lib.mkEnableOption "";
                  config = {
                    home = { inherit (osConfig.system) stateVersion; };

                    xdg.configFile."shell".source = lib.getExe pkgs.zsh;

                    programs = {
                      zsh.enable = true;

                      # Reproduced if you *don't* see the Starship prompt
                      starship = {
                        enable = true;
                        enableZshIntegration = true;
                      };
                    };
                  };
                }
              )
            ];

            users.test.repro.enable = true;
          };
        }
      ];
    };

    nixosConfigurations.expected = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.home-manager.nixosModules.default
        (
          { pkgs, ... }:
          {
            # `stateVersion` I was running on, probably doesn't matter
            config = {
              system.stateVersion = "24.11";

              boot.loader = {
                systemd-boot.enable = true;
                efi.canTouchEfiVariables = true;
              };

              users = {
                users.test = {
                  isNormalUser = true;
                  initialPassword = "password";
                  createHome = true;
                  shell = pkgs.zsh;
                };
              };

              programs.zsh.enable = true;

              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;

                sharedModules = [
                  (
                    {
                      pkgs,
                      lib,
                      osConfig,
                      ...
                    }:
                    {
                      options.repro.enable = lib.mkEnableOption "";
                      config = {
                        home = { inherit (osConfig.system) stateVersion; };
                        programs = {
                          zsh.enable = true;

                          # Reproduced if you *don't* see the Starship prompt
                          starship = {
                            enable = true;
                            enableZshIntegration = true;
                          };
                        };
                      };
                    }
                  )
                ];

                users.test.repro.enable = true;
              };
            };
          }
        )
      ];
    };

    nixosConfigurations.maybefix = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.home-manager.nixosModules.default
        inputs.noshell.nixosModules.default
        {
          # `stateVersion` I was running on, probably doesn't matter
          system.stateVersion = "24.11";

          boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
          };

          users = {
            users.test = {
              isNormalUser = true;
              initialPassword = "password";
              createHome = true;
            };
          };

          programs.noshell.enable = true;
          programs.zsh.enable = true;

          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;

            sharedModules = [
              (
                {
                  pkgs,
                  lib,
                  osConfig,
                  ...
                }:
                {
                  options.repro.enable = lib.mkEnableOption "";
                  config = {
                    home = { inherit (osConfig.system) stateVersion; };

                    xdg.configFile."shell".source = lib.getExe pkgs.zsh;

                    programs = {
                      zsh.enable = true;

                      # Reproduced if you *don't* see the Starship prompt
                      starship = {
                        enable = true;
                        enableZshIntegration = true;
                      };
                    };
                  };
                }
              )
            ];

            users.test.repro.enable = true;
          };
        }
      ];
    };
  };
}
