{
  description = "A Nix-flake-based C/C++ development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
  inputs.nixpkgs_boost.url = "github:nixos/nixpkgs/35e296f5e55a85a815ae22fb81259edb3a2d28d1";

  outputs = inputs:
    let
      supportedSystems = [ "x86_64-linux" ];
      forEachSupportedSystem = f: inputs.nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import inputs.nixpkgs {
		inherit system;
		overlays = [
			(final: prev: {
          pin-boost = import inputs.nixpkgs_boost {
            inherit (final) system;
            config.allowUnfree = true;
          };
		})
		];
      };});
      rootOfShell = "./";
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }:
      let
          mkWrapper = ({cmd, pkg}: pkgs.writeShellScriptBin "${cmd}" ''
            ${pkgs.direnv}/bin/direnv exec ${rootOfShell} ${pkg}/bin/${cmd} "$@"
          '');
          wrappers = [
              (mkWrapper {cmd = "cmake"; pkg = pkgs.cmake;})
              (mkWrapper {cmd = "ninja"; pkg = pkgs.ninja;})
              (mkWrapper {cmd = "gcc"; pkg = pkgs.gcc;})
              (mkWrapper {cmd = "g++"; pkg = pkgs.gcc;})
              (mkWrapper {cmd = "gdb"; pkg = pkgs.gdb;})
              (mkWrapper {cmd = "valgrind"; pkg = pkgs.valgrind;})
          ];
      in {
        default = pkgs.mkShell.override
          {
            # Override stdenv in order to change compiler:
            # stdenv = pkgs.clangStdenv;
          }
          {
            packages = wrappers ++ (with pkgs; [
              clang-tools
              codespell
              conan
              cppcheck
              doxygen
              gtest
              lcov
              vcpkg
              vcpkg-tool
	      pipewire.dev
              fftwFloat
	      pkgconf
	      pin-boost.boost173.dev
              sqlite.dev
              libevent.dev
              miniupnpc
	      libnatpmp
              qrencode
            ]);
           CMAKE_PREFIX_PATH = "${pkgs.pin-boost.boost173.dev}";
           BOOST_ROOT = "${pkgs.pin-boost.boost173.dev}";
          };
      });
    };

  
}
