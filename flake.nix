{
  description = "tiny flake for hid_bootloader_cli";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mosh = {
      url = "github:mobile-shell/mosh";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@attrs:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          mosh = import ./default.nix {
            inherit pkgs;
            sources = attrs;
          };
          default = mosh;
        };
        apps.default = {
          type = "app";
          program = "${self.packages."${system}".mosh}/bin/mosh";
        };
      }) // {
        overlays.default = final: prev: {
          mosh = import ./default.nix {
            pkgs = prev;
            sources = attrs;
          };
        };
      };
}
