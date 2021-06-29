{
  description = "Flake of my personal scripts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils  }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        scripts = pkgs.stdenv.mkDerivation {
          name = "plommonsorbet-scripts";
          src = self;
          installPhase = ''
            mkdir -p $out/bin
              install -Dm755 $src/bin/* -t $out/bin
              '';
        };
      in rec {
        packages = {
          "plommonsorbet-scripts" = scripts;
        };

        # By default run the dev version
        defaultPackage = self.packages.${system}.plommonsorbet-scripts;

        devShell = pkgs.mkShell {
          buildInputs = [ scripts ];
        };
      });

}

