{ stdenv
, fetchurl
, fetchpatch
, openssl_1_1
, ...
}:
stdenv.mkDerivation rec {
  pname = "infineon-firmware-updater";
  version = "1.1.2459.0";
  src = fetchurl {
    url = "https://gsdview.appspot.com/chromeos-localmirror/distfiles/infineon-firmware-updater-${version}.tar.gz";
    hash = "sha256-d0/GwHtxYS8SpTy0/92/Bdf2pn/gwpXmKJVpTC7NKjA=";
  };
  buildInputs = [ openssl_1_1 ];
  sourceRoot = ".";

  patches =
    let
      fetchGooglePatch = { filename, hash }: fetchpatch {
        url = "https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/c346e0d325c0212aeb87bf8dd856a4defe94cadf/chromeos-base/infineon-firmware-updater/files/${filename}?format=TEXT";
        decode = "base64 -d";
        inherit hash;
      };
    in
    [
      (fetchGooglePatch {
        filename = "makefile-fixes.patch";
        hash = "sha256-bpO+XMKQiSVd054Utn1ZUIgzel2TuSmxmUvwv+no5oE=";
      })
      (fetchGooglePatch {
        filename = "unlimited-log-file-size.patch";
        hash = "sha256-O1kt0n7pQIDYqNAq6eRuUsGNQn94gyP7IWP0jjiHgMQ=";
      })
      (fetchGooglePatch {
        filename = "dry-run-option.patch";
        hash = "sha256-Zm97RtyRa/wuKd9B9glleWOhnVdLkK/Isjet8uQDbbI=";
      })
      (fetchGooglePatch {
        filename = "change_default_password.patch";
        hash = "sha256-IBI9OscwZM52K1Re1v4I5TkTfDSUVwMl/lh4UQutiyI=";
      })
      (fetchGooglePatch {
        filename = "retry-send-on-ebusy.patch";
        hash = "sha256-3F/EbgkNV2W0DMVQtCk0a8wz33q7DeHG2BVtJXB1AzE=";
      })
      (fetchGooglePatch {
        filename = "ignore-error-on-complete-option.patch";
        hash = "sha256-8m+0b3BXZrwsD1RsD98D2y5ZjQYunjixQ7DeQEpLo9A=";
      })
      (fetchGooglePatch {
        filename = "update-type-ownerauth.patch";
        hash = "sha256-deqNjv215ueo4HIQDDbXgc00ekyDWeF9qSMVlB5WiqA=";
      })
      (fetchGooglePatch {
        filename = "openssl-1.1.patch";
        hash = "sha256-WpKsK3X3ZUdY5leMqth9bnWk/faFj76uCscp8TyfaUs=";
      })
      ./makefile.patch
    ];

  makeFlags = [ "-C" "TPMFactoryUpd" ];

  installPhase = ''
    mkdir -p $out/bin
    cp TPMFactoryUpd/TPMFactoryUpd $out/bin/TPMFactoryUpd
  '';

}
