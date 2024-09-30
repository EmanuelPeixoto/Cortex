{
  nixpkgs.overlays = [
    (final: prev: {
      prismlauncher-unwrapped = prev.prismlauncher-unwrapped.overrideAttrs (oa: let
        crackedPatch = final.fetchurl {
          url = "https://github.com/Misterio77/PrismLauncher/commit/2051b0b886b70d4efa9fbebc22d7d2fbe1e89255.diff";
          hash = "sha256-9/yYOPUkcHD5kL2PN9Ri8TsuthwbhHj4erx0wrr2mPQ=";
        };
      in {patches = (oa.patches or [ ]) ++ [ crackedPatch ];}
      );
    })
  ];
}
