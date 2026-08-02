#!/usr/bin/env bash
# Fetch the fonts modern-cv expects into ./fonts/, which is gitignored.
# Distro packages are no help here: Source Sans 3 is not packaged and Debian's
# fonts-font-awesome is still 4.7, while modern-cv 0.10 needs Font Awesome 7.
set -euo pipefail

cd "$(dirname "$0")"
mkdir -p fonts
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

SOURCE_SANS_VERSION=3.052R
FONT_AWESOME_VERSION=7.3.1

curl -sSLf -o "$tmp/source-sans.zip" \
  "https://github.com/adobe-fonts/source-sans/releases/download/${SOURCE_SANS_VERSION}/OTF-source-sans-${SOURCE_SANS_VERSION}.zip"
unzip -oq "$tmp/source-sans.zip" -d "$tmp/source-sans"
for style in Regular It Bold BoldIt Medium MediumIt Light LightIt Semibold SemiboldIt; do
  cp "$tmp/source-sans/OTF/SourceSans3-$style.otf" fonts/
done

curl -sSLf -o "$tmp/font-awesome.zip" \
  "https://github.com/FortAwesome/Font-Awesome/releases/download/${FONT_AWESOME_VERSION}/fontawesome-free-${FONT_AWESOME_VERSION}-desktop.zip"
unzip -oq "$tmp/font-awesome.zip" -d "$tmp/font-awesome"
cp "$tmp/font-awesome/fontawesome-free-${FONT_AWESOME_VERSION}-desktop/otfs/"*.otf fonts/

# Roboto ships as a variable font everywhere except the Google Fonts CSS API,
# and Typst 0.14 cannot instance variable fonts — so pull the static cuts.
css=$(curl -sSLf -H 'User-Agent: Mozilla/4.0' \
  'https://fonts.googleapis.com/css2?family=Roboto:wght@200;400;700')
for pair in 200:ExtraLight 400:Regular 700:Bold; do
  weight=${pair%%:*}
  style=${pair##*:}
  url=$(printf '%s' "$css" \
    | awk -v w="$weight;" '/font-weight: /{fw=$2} /src: url\(/ && fw==w' \
    | grep -oE 'https://[^)]+\.ttf')
  curl -sSLf -o "fonts/Roboto-$style.ttf" "$url"
done

echo "Fonts installed into $(pwd)/fonts"
