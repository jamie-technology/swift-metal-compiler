#!/usr/bin/env bash
# Apply the swift-gpu patch to an apple/swift checkout.
# Usage: ./apply.sh /path/to/swift   (the `swift` repo inside your checkout)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SWIFT="${1:?usage: ./apply.sh /path/to/swift}"
BASE=83c32e02f71e4bbe5745f326cc1276f0c721e625

cd "$SWIFT"
HEAD=$(git rev-parse HEAD)
if [ "$HEAD" != "$BASE" ]; then
  echo "warning: $SWIFT is at $HEAD, not the pinned base $BASE" >&2
  echo "         the patch was generated against $BASE (snapshot 2026-06-24-a)." >&2
  echo "         checkout that commit for a clean apply, or expect fuzz/rejects." >&2
fi
git apply --check "$HERE/swift-gpu.patch"
git apply "$HERE/swift-gpu.patch"
echo "applied swift-gpu.patch to $SWIFT"
