{
  description = "Flake of my personal scripts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      lib = pkgs.lib;

      # The python dependencies to embed
      python39-with-packages =
        pkgs.python39.withPackages (p: with p; [
          pykeepass
        ]);

      # The binary dependencies to append
      dep = with pkgs; [
        python39-with-packages
        coreutils
        kubectl
        bash
        yj
        jq
        xlibs.xset
        bat
        gawk
        nixfmt
	scrot
      ];

      scripts = with pkgs;
        stdenv.mkDerivation {
          name = "scripts";
          src = self;

          buildInputs = [ pkgs.makeWrapper ];

	  # I just wrap all the scripts with the paths from `dep` to make it easier
          installPhase = ''
                mkdir -p $out/bin

                for p in bin/*;
		do
        	makeWrapper $src/$p $out/$p \
                --prefix PATH : ${lib.makeBinPath dep} \
            	--set PYTHONPATH "${python39-with-packages}/${python39-with-packages.sitePackages}"
                done
          '';
        };

    in
    rec {
      packages."scripts" = scripts;

      defaultPackage.${system} = scripts;

      devShell.${system} = pkgs.mkShell { buildInputs = [ scripts ]; };
      #devShell.${system} = pkgs.mkShell { buildInputs = builtins.attrValues scripts;};

      overlay = final: prev: { scripts = scripts; };

    };

}

# (name: v: pkgs.writeScriptBin name (builtins.readFile (./bin + "/${name}") )) (lib.filterAttrs (dir: fileType: fileType == "regular") (builtins.readDir ./bin))
# nix-repl> map (x: pkgs.writeScriptBin x  (builtins.readFile (./bin + "/${x}")) ) (builtins.attrNames (lib.filterAttrs (dir: fileType: fileType == "regular") (builtins.readDir ./bin)))
