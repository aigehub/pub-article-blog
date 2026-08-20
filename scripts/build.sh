#!/usr/bin/env bash
set -Eeuo pipefail

BLOG_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

"$BLOG_DIR/scripts/setup-theme.sh"
hugo --source "$BLOG_DIR" --gc --minify "$@"
