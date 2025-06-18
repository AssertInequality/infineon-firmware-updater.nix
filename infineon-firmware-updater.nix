{ stdenv
, fetchgit
, openssl_1_1
, ...
}:
let
  version = "1.1.2459.0";
  source = fetchgit {
    url = "https://github.com/iavael/infineon-firmware-updater";
    hash = "sha256-K9Xujfnf0QSg8CGE0pvLF1vYvlDOyxsNlVnU8/zHiPw=";
  };
in
stdenv.mkDerivation {
  pname = "infineon-firmware-updater";
  inherit version;
  buildInputs = [ openssl_1_1 openssl_1_1.dev ];
  src = source;

  preBuild = ''
    makeFlagsArray+=(
      CPPFLAGS+="-Wimplicit-fallthrough=0"
      STRIP='strip $@'
    )
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp TPMFactoryUpd/TPMFactoryUpd $out/bin/TPMFactoryUpd
  '';

}
