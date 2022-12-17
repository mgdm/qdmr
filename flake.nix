{
  description = "A flake for building qdmr on x86_64 Linux";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };

      stdenv.mkDerivation {
        name = "qdmr";
        src = fetchFromGitHub {
          owner = "hmatuschek";
          repo = "qdmr";
          rev = "v0.10.4";
          sha256 = "iYL2hf3eGDQEmDlwSOSKOVEaQZBged6CF7pbXZZrfes=";
        };

        buildInputs = [ libsForQt5.qt5.qtbase libsForQt5.qt5.qttools libsForQt5.qt5.qtserialport libsForQt5.qt5.qtlocation libyamlcpp libusb1 ];
        nativeBuildInputs = [ cmake libsForQt5.qt5.wrapQtAppsHook ];

        cmakeFlags = [
            "-DINSTALL_UDEV_RULES=OFF"
        ];

        postInstall = ''
            mkdir -p $out/lib/udev/rules.d
            cp $src/dist/99-qdmr.rules $out/lib/udev/rules.d/
        '';
      };

  };
}