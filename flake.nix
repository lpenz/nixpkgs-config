{
  description = "lpenz's home-manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    execpermfix.url = "github:lpenz/execpermfix";
    tuzue.url = "github:lpenz/tuzue";
  };

  outputs = { nixpkgs, home-manager, execpermfix, tuzue, ... }:
    let
      system = "x86_64-linux";
      user = "lpenz";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.lpenz = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            programs.home-manager.enable = true;
            home.stateVersion = "22.11";
            home.username = "${user}";
            home.homeDirectory = "/home/${user}";

            home.packages = [
              execpermfix.packages.${system}.default
              tuzue.packages.${system}.default

              pkgs.bat
              pkgs.fd
              pkgs.fzf
              pkgs.glibcLocales
              pkgs.ripgrep
              pkgs.topgrade
              pkgs.zsh

              # fish:
              pkgs.starship
              pkgs.fishPlugins.fzf-fish
            ];

            programs.emacs.enable = true;

            programs.fish = {
              enable = true;
              interactiveShellInit = ''
                # Commands to run in interactive sessions can go here
                set -gx EDITOR vim
                set -gx VISUAL vim
                fzf_configure_bindings
                starship init fish | source
              '';
            };
            xdg.configFile."starship.toml".text = ''
              [aws]
              disabled = true
            '';
          }
        ];
      };
    };
}
