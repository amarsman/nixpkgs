{ fetchurl, stdenv, pkgconfig, libgcrypt, libassuan, libksba, libiconv, npth
, gettext, texinfo, pcsclite

# Each of the dependencies below are optional.
# Gnupg can be built without them at the cost of reduced functionality.
, pinentry ? null, x11Support ? false 
, adns ? null, adnsSupport ? true
, gnutls ? null, gnutlsSupport ? false 
, libusb ? null, usbSupport ? true
, openldap ? null, openldapSupport ? true
, readline ? null, readlineSupport ? true
, zlib ? null, zlibSupport ? true
, bzip2 ? null, bzip2Support ? true
}:

with stdenv.lib;

assert x11Support -> pinentry != null;

stdenv.mkDerivation rec {
  name = "gnupg-${version}";

  version = "2.1.13";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "0xcn46vcb5x5qx0bc803vpzhzhnn6wfhp7x71w9n1ahx4ak877ag";
  };

  buildInputs = [
    pkgconfig libgcrypt libassuan libksba libiconv npth gettext texinfo ]
      ++ optional (adnsSupport) adns
      ++ optional (bzip2Support) bzip2
      ++ optional (gnutlsSupport) gnutls
      ++ optional (usbSupport) libusb
      ++ optional (openldapSupport) openldap
      ++ optional (readlineSupport) readline
      ++ optional (zlibSupport) zlib;

  postPatch = stdenv.lib.optionalString stdenv.isLinux ''
    sed -i 's,"libpcsclite\.so[^"]*","${pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
  ''; #" fix Emacs syntax highlighting :-(

  configureFlags = optional x11Support "--with-pinentry-pgm=${pinentry}/bin/pinentry";

  postConfigure = "substituteAllInPlace tools/gpgkey2ssh.c";

  meta = with stdenv.lib; {
    homepage = http://gnupg.org;
    description = "A complete and free implementation of the OpenPGP standard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wkennington peti fpletz vrthra ];
    platforms = platforms.all;
  };
}
