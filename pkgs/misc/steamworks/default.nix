# Nix recipe for ARPA2 Steamworks.

{ pkgs, stdenv, fetchurl, cmake, openldap, sqlite, log4cpp, fcgi,
  pkgconfig, flex, flexcpp, bison, nginx
}:

let
  pname = "steamworks";
  version = "20160704";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";
  src = ./../../../../steamworks/. ;

  propagatedBuildInputs = [ ];
  buildInputs = [ pkgconfig openldap sqlite cmake flex bison flexcpp log4cpp nginx ];

  dontUseCmakeBuildDir = true;
  dontFixCmake = true;

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    make build
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/sbin $out/man $out/share/steamworks
    cd build
    cp crank/crank pulley/pulley shaft/shaft $out/bin
    cp common/lib* $out/lib
    '';

  meta = with stdenv.lib; {
    description = "Configuration information distributed over LDAP in near realtime";
    license = licenses.bsd2;
    homepage = https://www.arpa2.net;
    maintainers = with maintainers; [ leenaars ];
  };
}
