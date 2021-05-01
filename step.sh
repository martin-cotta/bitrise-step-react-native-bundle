#!/bin/bash
set -e

entry_file="index.js"

echo
echo " Configs:"
echo "  - Platform: $platform"
echo "  - EntryFile: $entry_file"
echo "  - BundleOutput: $bundle_output"
echo "  - SourcemapOutput: $sourcemap_output"
echo "  - AssetsDest: $assets_dest"

platform="$(echo $platform | tr '[:upper:]' '[:lower:]')"

platforms=("ios"  "android")
[[ -z "${platform}" ]] && { echo; "Missing required input: platform"; exit 1; }
[[ ${platforms[@]} =~ ${platform} ]] || { echo "Invalid value for: platform"; exit 1; }
[[ -z "${entry_file}" ]] && { echo "Missing required input: entry_file"; exit 1; }
[[ ! -e "${entry_file}" ]] && { echo "File not exist at: ${entry_file}"; exit 1; }
[[ -z "${bundle_output}" ]] && { echo "Missing required input: bundle_output"; exit 1; }
[[ -z "${sourcemap_output}" ]] && { echo "Missing required input: sourcemap_output"; exit 1; }
[[ -z "${assets_dest}" ]] && { echo "Missing required input: assets_dest"; exit 1; }

[[ $bundle_output != /* ]] && bundle_output="$(pwd)/$bundle_output"
[[ $sourcemap_output != /* ]] && sourcemap_output="$(pwd)/$sourcemap_output"
[[ $assets_dest != /* ]] && assets_dest="$(pwd)/$assets_dest"

mkdir -p "$(dirname "${bundle_output}")"
mkdir -p "$(dirname "${sourcemap_output}")"
mkdir -p "$(dirname "${assets_dest}")"

echo
echo "npx version: $(npx --version)"
echo "react-native CLI version: $(npx react-native --version)"
echo

set -x

npx react-native bundle \
  --entry-file ${entry_file} \
  --platform ${platform} \
  --dev false \
  --reset-cache \
  --bundle-output "${bundle_output}" \
  --sourcemap-output "${sourcemap_output}" \
  --assets-dest "${assets_dest}"

{ set +x; } 2>/dev/null

# copy bundle & source map to deploy dir
cp "$bundle_output" "$BITRISE_DEPLOY_DIR/${bundle_output##*/}"
cp "$sourcemap_output" "$BITRISE_DEPLOY_DIR/${sourcemap_output##*/}"

envman add --key RN_BUNDLE_FILE_PATH --value "$bundle_output"
envman add --key RN_BUNDLE_SOURCEMAP_FILE_PATH --value "$sourcemap_output"
envman add --key RN_BUNDLE_ASSETS_PATH --value "$assets_dest"

echo
echo " Output:"
echo "  - RN_BUNDLE_FILE_PATH: $bundle_output"
echo "  - RN_BUNDLE_SOURCEMAP_FILE_PATH: $sourcemap_output"
echo "  - RN_BUNDLE_ASSETS_PATH: $assets_dest"
echo
