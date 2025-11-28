#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "🚀 Running interactive installer..."
nix run .#interactiveInstaller