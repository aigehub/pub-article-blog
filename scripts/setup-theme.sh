#!/usr/bin/env bash
set -Eeuo pipefail

BLOG_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
THEME_DIR="$BLOG_DIR/themes/PaperMod"
THEME_REPO=${PAPERMOD_REPOSITORY:-https://github.com/adityatelange/hugo-PaperMod.git}
THEME_REF=${PAPERMOD_REF:-d3768854d00ad003b0a8dbdba254ce9224377a01}

if [[ ! -d "$THEME_DIR/.git" ]]; then
  rm -rf -- "$THEME_DIR"
  mkdir -p -- "$(dirname -- "$THEME_DIR")"
  git clone --filter=blob:none --no-checkout "$THEME_REPO" "$THEME_DIR"
fi

git -C "$THEME_DIR" fetch --depth=1 origin "$THEME_REF"
git -C "$THEME_DIR" checkout --detach FETCH_HEAD
