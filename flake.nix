{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        config = {
          permittedInsecurePackages = [
            "openssl-1.1.1w"
          ];
        };
        inherit system;
      };
    in
    {
      packages.${system} = {
        default = pkgs.callPackage ./infineon-firmware-updater.nix { };
      };
    };
}
