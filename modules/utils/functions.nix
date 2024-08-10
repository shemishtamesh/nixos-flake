{ pkgs, lib }:

{
  importYaml =
    file: builtins.fromJSON (
      builtins.readFile (
        pkgs.runCommandNoCC "converted-yaml.json" { } ''
          ${pkgs.yj}/bin/yj < "${file}" > "$out"
        ''
      )
    );
  rgba = palette: color: opacity:
    let
      r = palette."${color}-rgb-r";
      g = palette."${color}-rgb-g";
      b = palette."${color}-rgb-b";
    in
    "rgba(${r}, ${g}, ${b}, ${opacity})";
  imagesFromScheme =
    { screenWidth, screenHeight, scheme }:
    let
      palette = scheme.palette;
    in
    {
      rebootIcon =
        pkgs.stdenv.mkDerivation {
          name = "generated-nix-rebootIcon.png";
          src = pkgs.writeTextFile {
            name = "template.svg";
            text = lib.strings.fileContents "${pkgs.wlogout}/share/wlogout/assets/reboot.svg";
              # text = /* svg */ ''
              #   <?xml version="1.0" encoding="utf-8"?>
              #   <!-- Svg Vector Icons : http://www.onlinewebfonts.com/icon -->
              #   <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
              #   <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 1000 1000" enable-background="new 0 0 1000 1000" xml:space="preserve">
              #   <metadata> Svg Vector Icons : http://www.onlinewebfonts.com/icon </metadata>
              #   <path fill="#${palette.base0C}" d="M500,10C229.4,10,10,229.4,10,500s219.4,490,490,490s490-219.4,490-490S770.6,10,500,10z M500,885.1c-212.7,0-385.1-172.4-385.1-385.1S287.3,114.9,500,114.9S885.1,287.3,885.1,500S712.7,885.1,500,885.1z M576.5,308.7v382.4c0,42.2-34.2,76.5-76.5,76.5c-42.3,0-76.5-34.2-76.5-76.5V308.7c0-42.2,34.2-76.5,76.5-76.5C542.2,232.3,576.5,266.5,576.5,308.7z"/>
              #   </svg>
              # '';
          };
          buildInputs = with pkgs; [ inkscape ];
          unpackPhase = "true";
          buildPhase = ''
            inkscape --export-type="png" $src -w ${toString screenHeight} -h ${
              toString screenHeight
            } -o rebootIcon.png
          '';
          installPhase = "install -Dm0644 rebootIcon.png $out";
        };
      wallpaper =
        let
          logoScale = 8;
        in
        pkgs.stdenv.mkDerivation {
          name = "generated-nix-wallpaper.png";
          src = pkgs.writeTextFile {
            name = "template.svg";
            text = /* svg */ ''
              <?xml version="1.0" encoding="UTF-8" standalone="no"?>
              <svg
                 width="${toString screenWidth}"
                 height="${toString screenHeight}"
                 version="1.1"
                 id="svg4"
                 xmlns="http://www.w3.org/2000/svg"
                 xmlns:svg="http://www.w3.org/2000/svg">
                <defs
                   id="defs4" />
                <rect
                   width="${toString screenWidth}"
                   height="${toString screenHeight}"
                   fill="#${palette.base00}"
                   id="rect1" />
                <svg
                   x="${toString (screenWidth / 2 - (logoScale * 50))}"
                   y="${toString (screenHeight / 2 - (logoScale * 50))}"
                   version="1.1"
                   id="svg3">
                  <g
                     transform="scale(${toString logoScale})"
                     id="g3">
                    <g
                       transform="matrix(.19936 0 0 .19936 80.161 27.828)"
                       id="g2">
                      <path
                         d="m -249.0175,116.584 122.2,211.68 -56.157,0.5268 -32.624,-56.869 -32.856,56.565 -27.902,-0.011 -14.291,-24.69 46.81,-80.49 -33.229,-57.826 z"
                         fill="#${palette.base08}"
                         style="display:inline;isolation:auto;mix-blend-mode:normal"
                         id="path1" />
                      <path
                         d="m -204.9102,29.388 -122.22,211.67 -28.535,-48.37 32.938,-56.688 -65.415,-0.1717 -13.942,-24.169 14.237,-24.721 93.111,0.2937 33.464,-57.69 z"
                         fill="#${palette.base09}"
                         id="path2"
                         style="display:inline" />
                      <path
                         d="m -195.535,198.588 244.42,0.012 -27.622,48.897 -65.562,-0.1813 32.559,56.737 -13.961,24.158 -28.528,0.031 -46.301,-80.784 -66.693,-0.1359 z"
                         fill="#${palette.base0A}"
                         id="path3"
                         style="display:inline" />
                      <path
                         d="m -53.275,105.84 -122.2,-211.68 56.157,-0.5268 32.624,56.869 32.856,-56.565 27.902,0.011 14.291,24.69 -46.81,80.49 33.229,57.826 z"
                         fill="#${palette.base0B}"
                         id="path4"
                         style="display:inline" />
                      <path
                         d="m -97.659,193.01 122.22,-211.67 28.535,48.37 -32.938,56.688 65.415,0.1716 13.941,24.169 -14.237,24.721 -93.111,-0.2937 -33.464,57.69 z"
                         fill="#${palette.base0C}"
                         style="display:inline;isolation:auto;mix-blend-mode:normal"
                         id="path5" />
                      <path
                         d="m -107.2575,23.36 -244.42,-0.012 27.622,-48.897 65.562,0.1813 -32.559,-56.737 13.961,-24.158 28.528,-0.031 46.301,80.784 66.693,0.1359 z"
                         fill="#${palette.base0D}"
                         style="display:inline;isolation:auto;mix-blend-mode:normal"
                         id="path6" />
                    </g>
                  </g>
                </svg>
              </svg>
            '';
          };
          buildInputs = with pkgs; [ inkscape ];
          unpackPhase = "true";
          buildPhase = ''
            inkscape --export-type="png" $src -w ${toString screenWidth} -h ${
              toString screenHeight
            } -o wallpaper.png
          '';
          installPhase = "install -Dm0644 wallpaper.png $out";
        };
    };
}
