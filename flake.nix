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

      #scripts = pkgs.stdenv.mkDerivation {
      #  name = "scripts";
      #  src = self;
      #  installPhase = "install -Dm755 $src/bin/* -t $out/bin";
      #  buildInputs = with pkgs; [ coreutils ripgrep fd ];
      #  #checkPhase = ''
      #  #  patchShebangs $src/bin
      #  #'';
      #};
#lib.mapAttrsToList (name: v: pkgs.writeScriptBin name (builtins.readFile (./bin + "/${name}")))

      lib = pkgs.lib;

      #dep = with pkgs; [ coreutils bat ripgrep fd ];
      mkScriptPackage = name: pkgs.writeShellScriptBin "${name}" (builtins.readFile (./bin + "/${name}"));
      #scripts = pkgs.lib.mapAttrs (name: v: ) (pkgs.lib.filterAttrs (dir: fileType: fileType == "regular") (builtins.readDir ./bin));

#      scripts = { 
#      	"hell-to-me" = mkScriptPackage "hell-to-me";
#	"which-cat" = mkScriptPackage "which-cat";
#	"x-dim-screens" = mkScriptPackage "x-dim-screens";
#
#	};

        #buildInputs = with pkgs; [ coreutils ripgrep fd (mkScriptPackage "hell-to-me") (mkScriptPackage "which-cat") (mkScriptPackage "x-dim-screens") ];
        #nativeBuildInputs = with pkgs; [ripgrep coreutils fd ];
      #scripts = pkgs.stdenv.mkDerivation {
      #  name = "scripts";
      #  src = self;
      #  installPhase = "install -Dm755 $src/bin/* -t $out/bin";
      #  postFixup = ''
      #  	for file in $(ls $out/bin/);
      #  	do 
      #  		wrapProgram $file \
      #				--set PATH ${lib.makeBinPath [ 
      #  			coreutils ripgrep mawk 
      #  		]}
      #  	done
      #  '';
      #  #checkPhase = ''
      #  #  patchShebangs $src/bin
      #  #'';
      #};
      

      #scripts = pkgs.writeScriptBin "hello" ''
      #  echo hello
      #'';

      scripts = pkgs.stdenv.mkDerivation {
      	name = "scripts";
	src = self;
	buildInputs = [ (pkgs.writeShellScriptBin "my-shell-script.sh" ''
		cat - | rg lolcat
	'')];
      };



    in rec {
      packages."scripts" = scripts;

      defaultPackage.${system} = scripts;

      devShell.${system} = pkgs.mkShell { buildInputs = [scripts];};
      #devShell.${system} = pkgs.mkShell { buildInputs = builtins.attrValues scripts;};

      overlay = final: prev: {
      	scripts = scripts;
      };

    };

}

# (name: v: pkgs.writeScriptBin name (builtins.readFile (./bin + "/${name}") )) (lib.filterAttrs (dir: fileType: fileType == "regular") (builtins.readDir ./bin))
# nix-repl> map (x: pkgs.writeScriptBin x  (builtins.readFile (./bin + "/${x}")) ) (builtins.attrNames (lib.filterAttrs (dir: fileType: fileType == "regular") (builtins.readDir ./bin)))
