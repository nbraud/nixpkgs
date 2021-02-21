{ python3Packages, fetchurl, lib,
  bubblewrap, cairo, exiftool, ffmpeg, gdk_pixbuf, librsvg, poppler_gi }:

python3Packages.buildPythonPackage rec {
  pname = "mat2";
  version = "0.12.0";

  # TODO: Verify upstream's signature, to ensure maintainers get an authentic
  #  archive when importing a new version and setting its hash.
  # #43233 mentions adding support in Nix's tooling, but nothing seems to exist.
  srcs = fetchurl {
    url = "${meta.homepage}/-/archive/${version}/${pname}-${version}.tar.gz";
    sha256 = "185shmq35y2qj8ydy9l6v53flv536b8hrmv35b6ly22bczfs99yj";
  };

  propagatedBuildInputs = with python3Packages; [
    # Python deps
    mutagen
    pygobject3

    # Deps called through GObject
    gdk_pixbuf
    librsvg
    poppler_gi

    # External binaries called
    bubblewrap
    cairo
    exiftool
    ffmpeg
  ];

  # Ensures mat2 is executed with the right interpreter.
  patchPhase = "patchShebangs ./mat2";

  # TODO: Figure out why the testsuite fails with bwrap present
  checkInputs = [ exiftool ffmpeg ];
  preCheck = "python3 ./mat2 --check-dependencies";

  meta = with lib; {
    homepage = "https://0xacab.org/jvoisin/${pname}";
    description = "Metadata Anonymisation Toolkit — remove metadata from various media formats";

    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nicoo ];
  };
}
