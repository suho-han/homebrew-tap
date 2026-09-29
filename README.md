# homebrew-tap

Homebrew tap for [oct](https://github.com/suho-han/one-click-ai-tools) — one binary that organizes your AI coding CLIs (update them all, watch every quota plan, schedule the maintenance).

## Install

```bash
brew install suho-han/tap/oct
```

The formula tracks the latest **stable** GitHub Release. The prerelease
channel (`-beta.N` tags) and the `install.sh` installer (`~/.local/bin/oct`)
are unaffected; see the caveats when both channels are installed.

## Updates

The formula is bumped automatically: a GitHub Actions workflow
([`.github/workflows/update-formula.yml`](.github/workflows/update-formula.yml))
checks the latest **stable** GitHub Release once a day (and on manual
dispatch) and pushes a formula bump via
[`scripts/update-formula.sh`](scripts/update-formula.sh), which fails closed
if any tarball asset or checksum is missing. Prereleases are never picked up.
