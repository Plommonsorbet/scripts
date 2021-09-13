{
  description = "Flake of my personal scripts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      scripts = pkgs.stdenv.mkDerivation {
        name = "scripts";
        src = self;
        installPhase = "install -Dm755 $src/bin/* -t $out/bin";
      };

    in rec {
      packages."scripts" = scripts;

      defaultPackage.${system} = scripts;

      devShell.${system} = pkgs.mkShell { buildInputs = [ scripts ]; };

      overlay = final: prev: {
      	plommonsorbet = packages;
      };

    };

}
