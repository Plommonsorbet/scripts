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

        linux-scripts = pkgs.stdenv.mkDerivation {
          name = "linux-scripts";
          src = self;
          installPhase = ''
		find $src/bin -type f -maxdepth 1  | xargs -I _ install -Dm755 _ -t $out/bin
		find $src/bin/linux -type f -maxdepth 1  | xargs -I _ install -Dm755 _ -t $out/bin
              '';
        };
        darwin-scripts = pkgs.stdenv.mkDerivation {
          name = "darwin-scripts";
          src = self;
          installPhase = ''
		find $src/bin -type f -maxdepth 1  | xargs -I _ install -Dm755 _ -t $out/bin
		find $src/bin/darwin -type f -maxdepth 1  | xargs -I _ install -Dm755 _ -t $out/bin
              '';
        };
        common-scripts = pkgs.stdenv.mkDerivation {
          name = "common-scripts";
          src = self;
          installPhase = ''
		find $src/bin -type f -maxdepth 1  | xargs -I _ install -Dm755 _ -t $out/bin
              '';
        };

        all-scripts = pkgs.stdenv.mkDerivation {
          name = "common-scripts";
          src = self;
          installPhase = ''
		find $src/bin -type f  | xargs -I _ install -Dm755 _ -t $out/bin
              '';
        };

      in rec {
        packages = {
          "linux-scripts" = linux-scripts;
          "darwin-scripts" = darwin-scripts;
          "common-scripts" = common-scripts;
        };

        # By default run the dev version
        defaultPackage = self.packages.${system}.common-scripts;

        devShell = pkgs.mkShell {
          buildInputs = [ all-scripts ];
        };

	my-overlay = final: prev: {
		plommonsorbet-scripts = prev.defaultPackage;
	};
      });

}

