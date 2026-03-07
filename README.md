# bun-baseline-flake

Nix flake overlay that replaces `bun` with the [baseline build](https://bun.sh/docs/installation#baseline) — compiled without AVX/AVX2 instructions for older or low-power CPUs (e.g., Intel Gemini Lake, Celeron, some Atoms).

Hashes are auto-updated every 6 hours via GitHub Actions, so when nixpkgs bumps bun, the correct baseline hash is already available.

## Usage

Add as a flake input:

```nix
{
  inputs.bun-baseline.url = "github:mescam/bun-baseline-flake";

  outputs = { nixpkgs, bun-baseline, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        {
          nixpkgs.overlays = [ bun-baseline.overlays.default ];
        }
      ];
    };
  };
}
```

After applying the overlay, `pkgs.bun` is the baseline build. No other changes needed.

## How it works

The overlay uses `overrideAttrs` to swap `bun`'s `src` with the `-baseline` zip from the same GitHub release. The version is inherited from nixpkgs — only the binary variant changes.

`hashes.json` maps bun versions to SRI hashes for the baseline zip. The GitHub Actions workflow prefetches hashes for the 10 most recent bun releases, so the hash is ready before nixpkgs updates.

If your nixpkgs pin has a bun version not in `hashes.json`, the build will fail with instructions to run the update workflow or add the hash manually.
