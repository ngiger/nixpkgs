{ stdenv, bash-completion, cmake, fetchFromGitHub, hidapi, libusb1, pkgconfig
, qtbase, qttranslations, qtsvg, wrapQtAppsHook, libgpgerror, git, libgcrypt,
zlib, xlibs, nx-libs, makeDesktopItem, qmake, qt5, qtcreator}:
stdenv.mkDerivation rec {
  pname = "signet-app";
  version = "0.9.17.1";

  src = fetchFromGitHub {
    owner = "nthdimtech";
    repo = "signet-client";
    rev = "0537aeb51d4022095b1b6925d8ea27e93a93f921";
    sha256 = "18xqjjahf179711m86iya6dv1mdia3whgsl5dpvr3i7hingi1wkj";
    fetchSubmodules = true;
  };

  buildInputs = [
      bash-completion
      git
      qt5.full
      qtcreator
      libgcrypt
      zlib.dev
      xlibs.libX11.dev
      nx-libs
      libgpgerror
  ];

  nativeBuildInputs = [
    qmake
    pkgconfig
    wrapQtAppsHook
  ];

  qmakeFlags = [ "client/client.pro" "CONFIG+=release" ];

  installPhase = ''
    # Install client application
    mkdir -p $out/bin
    cp signet $out/bin/
    # Install desktop file
    mkdir -p "$out/share/applications"
    cp "$desktopItem"/share/applications/* "$out/share/applications/"
  '';

  meta = with stdenv.lib; {
    description      = "Client app for Signet High-capacity";
    longDescription  = ''
       An all-in-one encrypted USB flash drive, two-factor authentication token,
       and password manager. Signet is a free and open source software and open
       hardware USB storage and encryption device that also acts as a password
       manager. Signet identifies as a USB keyboard allowing it to type your
       data when you need it.
       Signet High-Capacity features a high-speed USB interface, 32GB of
       encrypted mass storage, two-factor authentication, and new cryptographic
       features.
    '';
    homepage         = "https://www.nthdimtech.com/signet";
    repositories.git = "https://github.com/nthdimtech/signet-client";
    license          = licenses.gpl3;
    maintainers      = with maintainers; [ ngiger ];
  };

  desktopItem = makeDesktopItem {
    name = "Signet";
    exec = "signet %f";
    icon = ./signet.xcf;
    comment = " Signet is a free and opRen source software and open hardware USB storage and encryption device that also acts as a passwor        manager";
    desktopName = "Signet Desktop Client";
    genericName = "signet client";
    categories = "Security;Utility;System";
   # mimeType = "text/xml";
  };

}
