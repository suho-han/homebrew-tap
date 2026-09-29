#!/usr/bin/env bash
# Bump Formula/oct.rb to the latest stable GitHub Release of one-click-ai-tools.
#
# "Stable" means whatever the /releases/latest endpoint returns: it never
# points at prereleases or drafts, so -beta.N tags stay on the install.sh
# channel and never reach the formula. The four tarball sha256 values are
# taken from the release's own checksums.txt, then re-checked against the
# actual asset bytes; anything missing or inconsistent fails the run without
# touching the formula.
#
# Used by .github/workflows/update-formula.yml (cron / dispatch). Safe to run
# locally: with no new release it exits 0 as a no-op.
#
# Environment:
#   OCT_REPO   source repository (default: suho-han/one-click-ai-tools)
#   GH_TOKEN   optional; only needed in CI to avoid API rate limits

set -euo pipefail

OCT_REPO="${OCT_REPO:-suho-han/one-click-ai-tools}"
FORMULA="Formula/oct.rb"
TARBALLS=(
  one-click-ai-tools_darwin_amd64.tar.gz
  one-click-ai-tools_darwin_arm64.tar.gz
  one-click-ai-tools_linux_amd64.tar.gz
  one-click-ai-tools_linux_arm64.tar.gz
)

die() { echo "ERROR: $*" >&2; exit 1; }

# --- Latest stable release -------------------------------------------------
release_json="$(gh api "repos/${OCT_REPO}/releases/latest")"
tag="$(jq -r '.tag_name' <<<"$release_json")"
[[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z.-]+)?$ ]] ||
  die "unexpected tag from releases/latest: '${tag}'"
jq -e '.prerelease == false and .draft == false' <<<"$release_json" >/dev/null ||
  die "releases/latest returned a prerelease/draft (${tag}); refusing to publish it to the formula"

# --- Compare with the version the formula currently pins --------------------
current_tag="$(sed -n 's|.*releases/download/\([^/]*\)/.*|\1|p' "$FORMULA" | head -n1)"
[[ -n "$current_tag" ]] || die "could not find a releases/download tag in ${FORMULA}"
if [[ "$current_tag" == "$tag" ]]; then
  echo "Formula already tracks ${tag}; nothing to do."
  exit 0
fi
echo "Bumping formula: ${current_tag} -> ${tag}"

# --- Fail-closed asset and checksum checks ----------------------------------
assets="$(jq -r '.assets[].name' <<<"$release_json")"
for tarball in "${TARBALLS[@]}"; do
  grep -Fxq "$tarball" <<<"$assets" ||
    die "${tag} is missing release asset ${tarball}; formula would 404"
done

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
gh release download "$tag" -R "$OCT_REPO" -p checksums.txt -D "$tmp" --clobber

declare -A sha=()
for tarball in "${TARBALLS[@]}"; do
  hash="$(awk -v f="$tarball" '$2 == f {print $1}' "${tmp}/checksums.txt")"
  [[ "$hash" =~ ^[0-9a-f]{64}$ ]] ||
    die "no valid sha256 for ${tarball} in ${tag}'s checksums.txt"
  sha["$tarball"]="$hash"
done

# --- Verify the checksums against the actual asset bytes --------------------
# The formula pins these shas, so they must match what GitHub actually
# serves, not just what the release's checksums.txt claims.
hash_file() {
  sha256sum "$1" 2>/dev/null | cut -d' ' -f1 || shasum -a 256 "$1" | cut -d' ' -f1
}
mkdir -p "${tmp}/assets"
gh release download "$tag" -R "$OCT_REPO" \
  -p "${TARBALLS[0]}" -p "${TARBALLS[1]}" \
  -p "${TARBALLS[2]}" -p "${TARBALLS[3]}" \
  -D "${tmp}/assets" --clobber
for tarball in "${TARBALLS[@]}"; do
  actual="$(hash_file "${tmp}/assets/${tarball}")"
  [[ "$actual" == "${sha[${tarball}]}" ]] ||
    die "sha256 mismatch for ${tarball}: checksums.txt says ${sha[${tarball}]}, asset bytes are ${actual}"
  echo "OK: ${tarball} sha256 verified"
done

# --- Regenerate the formula (structure identical to the v0.1.5 original) ----
cat >"${tmp}/oct.rb" <<EOF
class Oct < Formula
  desc "One binary that organizes your AI coding CLIs — update, quota watch, maintenance"
  homepage "https://github.com/${OCT_REPO}"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/${OCT_REPO}/releases/download/${tag}/one-click-ai-tools_darwin_arm64.tar.gz"
      sha256 "${sha[one-click-ai-tools_darwin_arm64.tar.gz]}"
    else
      url "https://github.com/${OCT_REPO}/releases/download/${tag}/one-click-ai-tools_darwin_amd64.tar.gz"
      sha256 "${sha[one-click-ai-tools_darwin_amd64.tar.gz]}"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/${OCT_REPO}/releases/download/${tag}/one-click-ai-tools_linux_arm64.tar.gz"
      sha256 "${sha[one-click-ai-tools_linux_arm64.tar.gz]}"
    else
      url "https://github.com/${OCT_REPO}/releases/download/${tag}/one-click-ai-tools_linux_amd64.tar.gz"
      sha256 "${sha[one-click-ai-tools_linux_amd64.tar.gz]}"
    end
  end

  def install
    bin.install "oct"
  end

  def caveats
    <<~EOS
      oct is also distributed via the install.sh channel, which installs to
      ~/.local/bin/oct. If both are installed, \`which oct\` decides which one
      runs. Keep only one if that matters to you.
    EOS
  end

  test do
    assert_match "oct version #{version}", shell_output("#{bin}/oct --version")
  end
end
EOF

if command -v ruby >/dev/null 2>&1; then
  ruby -c "${tmp}/oct.rb" >/dev/null || die "generated formula has a Ruby syntax error"
fi
[[ "$(grep -c 'releases/download/' "${tmp}/oct.rb")" == 4 ]] ||
  die "generated formula does not contain exactly 4 download URLs"
[[ "$(grep -c '  sha256 "' "${tmp}/oct.rb")" == 4 ]] ||
  die "generated formula does not contain exactly 4 sha256 lines"

mv "${tmp}/oct.rb" "$FORMULA"
echo "OK: ${FORMULA} now pins ${tag}"
