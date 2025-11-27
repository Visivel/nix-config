{ lib }:

with lib;

{
  mkDevPackages = languages:
    let
      languagePackages = {
        python = [ "python3" "python3Packages.pip" ];
        nodejs = [ "nodejs_24" "nodePackages.npm" ];
        bun = [ "bun" ];
      };
    in
    flatten (map (lang: languagePackages.${lang} or []) languages);
}
