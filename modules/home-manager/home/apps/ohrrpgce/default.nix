{
  pkgs ? import <nixpkgs> { },
}:

let
  # Collect all necessary libraries
  runtimeLibs = with pkgs; [
    SDL2
    SDL2_mixer
    xorg.libX11
    xorg.libXext
    xorg.libXpm
    xorg.libXrandr
    xorg.libXrender
    xorg.libXinerama
    alsa-lib
    libpulseaudio
  ];
in

pkgs.stdenv.mkDerivation rec {
  pname = "ohrrpgce";
  version = "ichorescent";

  src = pkgs.fetchurl {
    url = "https://hamsterrepublic.com/dl/ohrrpgce-linux-x86_64.tar.bz2";
    sha256 = "sha256-iWH8E1yTvfhaSmA0DyRvxbtOIleAn9zufV9aCPLTYu8=";
  };

  nativeBuildInputs = [
    pkgs.makeWrapper
  ];

  unpackPhase = ''
    tar -xjf $src
  '';

  installPhase = ''
    mkdir -p $out/opt/ohrrpgce
    cp -r * $out/opt/ohrrpgce

    # Ensure the executables have the correct permissions
    chmod +x $out/opt/ohrrpgce/ohrrpgce/ohrrpgce-game
    chmod +x $out/opt/ohrrpgce/ohrrpgce/ohrrpgce-custom

    # Create symlinks to the executables in the bin directory with steam-run wrappers
    mkdir -p $out/bin
    for prog in ohrrpgce-game ohrrpgce-custom; do
      makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/$prog \
        --add-flags "$out/opt/ohrrpgce/ohrrpgce/$prog" \
        --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"
    done
  '';

  meta = with pkgs.lib; {
    description = "Official Hampster Republic Role Playing Game Construction Engine";
    homepage = "https://hamsterrepublic.com/";
    license = with licenses; [
      mit
      gpl2
    ];
    platforms = platforms.linux;
  };
}
