#!/usr/bin/env bash
# Build swift-frontend after applying the patch.
# Assumes a standard apple/swift Ninja build tree (adjust BUILD if yours differs).
set -euo pipefail
BUILD="${BUILD:-$HOME/Developer/swift-gpu-fork/build/Ninja-RelWithDebInfoAssert+swift-DebugAssert/swift-macosx-arm64}"
ninja -C "$BUILD" bin/swift-frontend
echo "built: $BUILD/bin/swift-frontend"
