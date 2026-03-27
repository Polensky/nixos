{ pkgs }:
let 
  image = ./assets/a_forest_of_trees_with_fog.jpg;
  avatar = ./assets/avatar.jpg;
in pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "xCaptaiN09";
    repo = "pixie-sddm";
    rev = "12a5f459ebd6d699be42c188c10976c8bb7076d7";
    sha256 = "sha256-lmE/49ySuAZDh5xLochWqfSw9qWrIV+fYaK5T2Ckck8=";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    rm $out/assets/background.jpg
    rm $out/assets/avatar.jpg
    cp ${image} $out/assets/background.jpg
    cp ${avatar} $out/assets/avatar.jpg
  '';
}
