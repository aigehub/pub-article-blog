#!/usr/bin/env bash
set -Eeuo pipefail

HUGO_VERSION=${HUGO_VERSION:-0.165.0}
INSTALL_DIR=${HUGO_INSTALL_DIR:-"$HOME/.local/bin"}
ARCH=$(uname -m)
case "$ARCH" in
  x86_64|amd64) HUGO_ARCH=amd64 ;;
  aarch64|arm64) HUGO_ARCH=arm64 ;;
  *)
    printf 'Unsupported architecture: %s\n' "$ARCH" >&2
    exit 1
    ;;
esac

mkdir -p -- "$INSTALL_DIR"
TMP=$(mktemp -d)
trap 'rm -rf -- "$TMP"' EXIT

TARBALL="hugo_extended_${HUGO_VERSION}_linux-${HUGO_ARCH}.tar.gz"
URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${TARBALL}"

curl -fsSL "$URL" -o "$TMP/$TARBALL"
tar -xzf "$TMP/$TARBALL" -C "$TMP" hugo
install -m 0755 "$TMP/hugo" "$INSTALL_DIR/hugo"

if ! command -v hugo >/dev/null || [[ "$(command -v hugo)" != "$INSTALL_DIR/hugo" ]]; then
  printf 'Installed %s/hugo. If `hugo` is not found, add this to PATH:\n  export PATH="%s:$PATH"\n' \
    "$INSTALL_DIR" "$INSTALL_DIR" >&2
fi

hugo version
