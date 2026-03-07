{
  description = "Nix overlay providing bun with baseline (non-AVX) binaries";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      # Read the current hash from the tracked file
      hashes = builtins.fromJSON (builtins.readFile ./hashes.json);
    in
    {
      overlays.default = final: prev: {
        bun = prev.bun.overrideAttrs (oldAttrs: {
          src = prev.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${oldAttrs.version}/bun-linux-x64-baseline.zip";
            hash = hashes.${oldAttrs.version} or (throw ''
              bun-baseline-flake: no hash for bun v${oldAttrs.version}.
              Run the update workflow or add the hash to hashes.json.
              URL: https://github.com/oven-sh/bun/releases/download/bun-v${oldAttrs.version}/bun-linux-x64-baseline.zip
            '');
          };
        });
      };
    };
}
