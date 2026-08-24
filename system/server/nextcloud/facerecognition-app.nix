{ lib, buildNpmPackage, fetchFromGitHub, fetchurl }:

let
  autocompleteJs = fetchurl {
    url = "https://raw.githubusercontent.com/realsuayip/autocomplete/master/dist/autocomplete.js";
    hash = "sha256-54kOGkNbYtk8d0nmig4aYcPfRyDufs1bihACHmaScak=";
  };
  eggJs = fetchurl {
    url = "https://raw.githubusercontent.com/mikeflynn/egg.js/master/egg.js";
    hash = "sha256-DjaYC8g2JUvrCzwTJWbNiqTOiHpEKetOPIMlpZrbgto=";
  };
in
buildNpmPackage {
  pname = "nextcloud-facerecognition";
  version = "0.9.95";

  src = fetchFromGitHub {
    owner = "matiasdelellis";
    repo = "facerecognition";
    rev = "b6451bb58e18167c987084399c875cd81dd6e98b";
    hash = "sha256-ES6IaxlJNUhOHWM2BU/Y4C6Pqh824sHxwGNJDspPOiA=";
  };

  npmDepsHash = "sha256-0ZapLtm85T7vYZZ7q8tAR5wmejAEqWUDnwBQZK15d1Q=";

  # After webpack builds the JS bundles, vendor the small JS helpers and
  # compile the Handlebars templates exactly like the upstream `make` does.
  postBuild = ''
    mkdir -p js/vendor
    cp node_modules/handlebars/dist/handlebars.js js/vendor/handlebars.js
    cp node_modules/lozad/dist/lozad.js js/vendor/lozad.js
    cp ${autocompleteJs} js/vendor/autocomplete.js
    cp ${eggJs} js/vendor/egg.js
    node_modules/handlebars/bin/handlebars src/templates -f js/facerecognition-templates.js
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r appinfo css img l10n lib templates js "$out/"
    cp composer.json package.json "$out/" 2>/dev/null || true
    rm -f "$out"/js/*.map
    runHook postInstall
  '';

  meta = with lib; {
    description = "Nextcloud Face Recognition app";
    homepage = "https://github.com/matiasdelellis/facerecognition";
    license = licenses.agpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
