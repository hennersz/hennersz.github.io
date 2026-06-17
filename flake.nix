{
  inputs = {
    std-dev-env.url = "github:hennersz/std-dev-env";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    cache-nix-action = {
      url = "github:nix-community/cache-nix-action/v7";
      flake = false;
    };
  };

  outputs = { self, std-dev-env, nixpkgs, flake-utils, cache-nix-action, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        scripts = std-dev-env.lib.readScripts { dir = ./scripts; };

        site = pkgs.buildNpmPackage {
          pname = "mortinet";
          version = "1.0.0";

          src = ./.;

          npmDeps = pkgs.importNpmLock {
            npmRoot = ./.;
          };

          npmConfigHook = pkgs.importNpmLock.npmConfigHook;

          npmBuildScript = "build";

          installPhase = ''
            runHook preInstall

            mkdir -p "$out"
            cp -R dist/. "$out/"

            runHook postInstall
          '';
        };

        devShells.default = std-dev-env.lib.nix.devenv {
          inherit pkgs inputs scripts;

          tasks."node:install" = { exec = '' npm install ''; before = [ "devenv:enterShell" ]; };

          packages = with pkgs; [
            nodejs_24
          ];
        };

        saveFromGC =
          (import "${cache-nix-action}/saveFromGC.nix" {
            inherit pkgs inputs;
            inputsInclude = [
              "nixpkgs"
              "flake-utils"
              "std-dev-env"
            ];
            derivations = [
              devShells.default
              site
            ];
          }).package;
      in
      {
        inherit devShells;

        packages = {
          inherit site saveFromGC;
          default = site;
        };
      });
}
