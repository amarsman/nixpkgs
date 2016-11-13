{ stdenv, fetchurl, pkgconfig, openssl, pcsclite }:

stdenv.mkDerivation rec {
  name = "yubico-piv-tool-1.3.0";

  src = fetchurl {
    url = "https://developers.yubico.com/yubico-piv-tool/Releases/${name}.tar.gz";
    sha256 = "0l9lkzwi2227y5y02i5g1d701bmlyaj8lffv72jks1w4mkh7q7qh";
  };

  buildInputs = [ pkgconfig openssl pcsclite ];

  configureFlags = [ "--with-backend=pcsc" ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/yubico-piv-tool/;
    description = ''
      Used for interacting with the Privilege and Identification Card (PIV)
      application on a YubiKey
    '';
    longDescription = ''
      The Yubico PIV tool is used for interacting with the Privilege and
      Identification Card (PIV) application on a YubiKey.
      With it you may generate keys on the device, importing keys and
      certificates, and create certificate requests, and other operations.
      A shared library and a command-line tool is included.
    '';
    maintainers = with maintainers; [ wkennington ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
