{
  description = "Bitcoin Core build environment (CMake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        name = "bitcoin-dev-env";

        buildInputs = with pkgs; [
          cmake
          boost
          libevent
          zeromq
          zlib
          pkg-config
          capnproto
          python3
          sqlite
        ];

        shellHook = ''
          export BOOST_ROOT=${pkgs.boost}
          export BOOST_INCLUDEDIR=${pkgs.boost}/include
          export BOOST_LIBRARYDIR=${pkgs.boost}/lib
        '';
      };
    };
}
