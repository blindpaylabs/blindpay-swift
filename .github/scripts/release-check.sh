#!/usr/bin/env bash
# Decides whether the current checkout needs a release.
#
# Reads BlindPaySDK.version (the single source of the release version) and
# checks whether tag v<version> already exists on the remote; the Actions
# checkout has no tags, so the local tag list can't answer that.
#
# Prints "release v<version>" or "skip: <reason>". Under GitHub Actions it
# also writes release=true|false, version and tag to $GITHUB_OUTPUT.
set -euo pipefail

version_file="${VERSION_FILE:-Sources/BlindPay/Core/Version.swift}"
remote="${REMOTE:-origin}"

output() {
  if [ -n "${GITHUB_OUTPUT:-}" ]; then echo "$1" >> "$GITHUB_OUTPUT"; fi
}

version=""
if [ -f "$version_file" ]; then
  version=$(sed -nE 's/^[[:space:]]*public static let version = "([0-9]+\.[0-9]+\.[0-9]+)".*/\1/p' "$version_file" | head -n 1)
fi
if [ -z "$version" ]; then
  echo "skip: no BlindPaySDK.version constant in $version_file"
  output "release=false"
  exit 0
fi

tag="v$version"
output "version=$version"
output "tag=$tag"

set +e
git ls-remote --exit-code --tags "$remote" "refs/tags/$tag" > /dev/null
status=$?
set -e
case "$status" in
  0)
    echo "skip: $tag already exists on $remote"
    output "release=false"
    ;;
  2)
    echo "release $tag"
    output "release=true"
    ;;
  *)
    echo "error: git ls-remote $remote failed (exit $status)" >&2
    exit "$status"
    ;;
esac
