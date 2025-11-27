#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "🔨 Building NixOS installation ISO..."
nix build .#iso --impure

echo "✅ ISO built successfully!"
echo "📀 ISO location: $(readlink -f result)/iso/*.iso"