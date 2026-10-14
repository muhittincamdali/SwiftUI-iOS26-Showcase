#!/usr/bin/env bash
# Captures the README screenshots from the example app running in the iOS Simulator.
#
# Usage: scripts/screenshots.sh [simulator-udid]
#
# Without a UDID the script creates (or reuses) a simulator named
# "SwiftUI iOS 26 Showcase" using the newest installed iOS runtime.
# Requires Xcode 26.1 or later. Images are written to docs/images/.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/docs/images"
DERIVED="${DERIVED_DATA:-$ROOT/.build/screenshots}"
BUNDLE_ID="io.github.muhittincamdali.ShowcaseApp"
DEVICE_NAME="SwiftUI iOS 26 Showcase"
DEVICE_TYPE="${DEVICE_TYPE:-com.apple.CoreSimulator.SimDeviceType.iPhone-17-Pro}"
WIDTH=400
SETTLE_SECONDS=4

udid="${1:-}"
if [[ -z "$udid" ]]; then
  udid="$(xcrun simctl list devices -j | /usr/bin/python3 -c '
import json, sys
name = sys.argv[1]
for runtime, devices in json.load(sys.stdin)["devices"].items():
    for device in devices:
        if device["name"] == name and device["isAvailable"]:
            print(device["udid"]); sys.exit()
' "$DEVICE_NAME")"
fi
if [[ -z "$udid" ]]; then
  runtime="$(xcrun simctl list runtimes -j | /usr/bin/python3 -c '
import json, sys
ios = [r for r in json.load(sys.stdin)["runtimes"] if r["platform"] == "iOS" and r["isAvailable"]]
print(ios[-1]["identifier"])
')"
  udid="$(xcrun simctl create "$DEVICE_NAME" "$DEVICE_TYPE" "$runtime")"
fi
echo "Simulator: $udid"

xcrun simctl boot "$udid" 2>/dev/null || true
xcrun simctl bootstatus "$udid" -b >/dev/null

xcodebuild \
  -project "$ROOT/Examples/ShowcaseApp/ShowcaseApp.xcodeproj" \
  -scheme ShowcaseApp \
  -destination "platform=iOS Simulator,id=$udid" \
  -derivedDataPath "$DERIVED" \
  -quiet build

xcrun simctl install "$udid" "$DERIVED/Build/Products/Debug-iphonesimulator/ShowcaseApp.app"
xcrun simctl status_bar "$udid" override --time 9:41 --batteryState charged --batteryLevel 100 \
  --cellularMode active --cellularBars 4 --wifiBars 3
mkdir -p "$OUT"

# capture <file name> <light|dark> [launch arguments...]
capture() {
  local name="$1" appearance="$2"; shift 2
  xcrun simctl ui "$udid" appearance "$appearance"
  xcrun simctl terminate "$udid" "$BUNDLE_ID" 2>/dev/null || true
  # Fixed language and region so numbers and dates look the same on every machine.
  xcrun simctl launch "$udid" "$BUNDLE_ID" -AppleLanguages "(en)" -AppleLocale en_US "$@" >/dev/null
  sleep "$SETTLE_SECONDS"
  local file="$OUT/$name.png"
  xcrun simctl io "$udid" screenshot --type=png "$file" >/dev/null
  sips --resampleWidth "$WIDTH" "$file" >/dev/null
  echo "Wrote ${file#"$ROOT"/}"
}

capture gallery-light light
capture gallery-dark dark
for demo in glassEffect glassMorphing glassButtons toolbarSpacer scrollEdgeEffect \
  backgroundExtension richTextEditor chart3D symbolDraw animatableMacro foundationModels; do
  capture "$demo" light -demo "$demo"
done

xcrun simctl status_bar "$udid" clear
xcrun simctl ui "$udid" appearance light
