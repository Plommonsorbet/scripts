{
  description = "Flake of my personal scripts";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-20.09;

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };

      stdenv.mkDerivation {
        name = "plommonsorbet-scripts";
        src = self;
        installPhase = ''
          mkdir -p $out/bin
            install -Dm755 $src/bin/* -t $out/bin
            '';
      };

  };
}
