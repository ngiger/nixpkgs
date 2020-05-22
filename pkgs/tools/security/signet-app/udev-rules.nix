{ stdenv, signet-app
, group ? "signet"
}:

stdenv.mkDerivation {
  name = "signet-udev-rules-${stdenv.lib.getVersion signet-app}";

  inherit (signet-app) src;

  dontBuild = true;

  patchPhase = ''
    substituteInPlace signet-base/signetdev/host/linux/50-signet.rules --replace plugdev "${group}"
  '';

  installPhase = ''
    mkdir -p $out/etc/udev/rules.d
    cp signet-base/signetdev/host/linux/50-signet.rules $out/etc/udev/rules.d
  '';

  meta = {
    description = "udev rules for Signet and Signet-HC";
    inherit (signet-app.meta) homepage license maintainers;
  };
}
