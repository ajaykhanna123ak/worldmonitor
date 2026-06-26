#!/usr/bin/env bash
#
# Repoint Aperture's PUBLIC site URLs to your own domain in one command.
#
#   ./scripts/set-domain.sh aperture.example.com
#
# Swaps the marketing/canonical/social host only:
#     www.worldmonitor.app  ->  www.<your-domain>
#     https://worldmonitor.app -> https://<your-domain>
#
# It deliberately does NOT touch backend/infra hosts (api., clerk., abacus.,
# tech./finance./… variants). Those are configured separately via your
# deployment env + the Content-Security-Policy in index.html.
#
set -euo pipefail

NEW="${1:-}"
if [[ -z "$NEW" ]]; then
  echo "usage: $0 <your-domain.com>" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Files that carry public-facing URLs (index.html + TS sources). node_modules excluded.
mapfile -t FILES < <(grep -rl -E "www\.worldmonitor\.app|https://worldmonitor\.app" \
  "$ROOT/index.html" "$ROOT/src" 2>/dev/null || true)

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "No public worldmonitor.app URLs found (already repointed?)."
  exit 0
fi

for f in "${FILES[@]}"; do
  # BSD/GNU-compatible in-place edit. Order matters: www. first.
  sed -i.bak \
    -e "s#www\.worldmonitor\.app#www.${NEW}#g" \
    -e "s#https://worldmonitor\.app#https://${NEW}#g" \
    "$f"
  rm -f "$f.bak"
done

echo "Repointed public host -> ${NEW} in ${#FILES[@]} file(s)."
echo "Next: update the Content-Security-Policy hosts in index.html and your"
echo "Clerk / API / Sentry env if you self-host those services."
