{ stdenv
, fetchurl
, openssl_1_1
, ...
}:
let
  version = "1.1.2459.0";
  sources = {
    main = fetchurl {
      url = "https://gsdview.appspot.com/chromeos-localmirror/distfiles/infineon-firmware-updater-1.1.2459.0.tar.gz";
      hash = "sha256-d0/GwHtxYS8SpTy0/92/Bdf2pn/gwpXmKJVpTC7NKjA=";
    };
    googlePatch = fetchurl {
      url = "https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+archive/master/chromeos-base/infineon-firmware-updater/files.tar.gz";
      hash = "sha256-NVSRp7T/Va3jklFMJWP+CjQoJlP7ftcHy0rhDOJuuHE=";
    };
    makefilePatch = ./makefile.patch;
    # makefileEntry = ./Makefile;
  };
in
stdenv.mkDerivation {
  pname = "infineon-firmware-updater";
  inherit version;
  buildInputs = [ openssl_1_1 openssl_1_1.dev ];
  srcs = with sources; [
    main
    googlePatch
    makefilePatch
    # makefileEntry
  ];

  setSourceRoot = "sourceRoot=$(pwd)";
  # setSourceRoot = "sourceRoot=$(pwd)/build";
  preUnpack = "mkdir build";
  unpackCmd = ''
    tar -xzf $curSrc -C $(pwd)/build 2>/dev/null ||\
    cp $curSrc $(pwd)/build/makefile.patch
  '';
  postUnpack = "cd build";

  patches = [
    "makefile-fixes.patch"
    "unlimited-log-file-size.patch"
    "dry-run-option.patch"
    "change_default_password.patch"
    "retry-send-on-ebusy.patch"
    "ignore-error-on-complete-option.patch"
    "update-type-ownerauth.patch"
    "openssl-1.1.patch"
    "makefile.patch"
  ];
  postPatch = ''
    cat > Makefile<<EOF
    .PHONY: build

    build:
    ''\tmake -C TPMFactoryUpd all
    EOF
  '';

  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin
    cp TPMFactoryUpd/TPMFactoryUpd $out/bin/TPMFactoryUpd
  '';

}
