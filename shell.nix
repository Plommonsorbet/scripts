with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "scripts-dev-shell";
  #buildInputs = [ ];
  shellHook = ''
            export PATH="$(git rev-parse --show-toplevel)/bin:$PATH"
  '';
}
