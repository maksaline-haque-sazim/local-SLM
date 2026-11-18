#!/bin/bash

# Flutter App Configuration Script
# Manages app name, bundle ID, and package name for Android and iOS
#
# Usage:
#   ./scripts/configure_app.sh              # Full configuration with app_config.json
#   ./scripts/configure_app.sh --fix        # Quick fix for Android package mismatch
#   ./scripts/configure_app.sh --help       # Show help

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_help() {
    echo "Flutter App Configuration Script"
    echo ""
    echo "Usage:"
    echo "  ./scripts/configure_app.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  (no args)          Full configuration using scripts/app_config.json"
    echo "  --fix              Quick fix for Android package mismatch only"
    echo "  --config FILE      Use custom config file (default: scripts/app_config.json)"
    echo "  --help, -h         Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./scripts/configure_app.sh                    # Full setup"
    echo "  ./scripts/configure_app.sh --fix              # Quick package fix"
    echo "  ./scripts/configure_app.sh --config my.json   # Custom config"
    echo ""
    exit 0
}

# Parse arguments
MODE="full"
CONFIG_FILE="scripts/app_config.json"

while [[ $# -gt 0 ]]; do
    case $1 in
        --fix)
            MODE="fix"
            shift
            ;;
        --config)
            CONFIG_FILE="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# ============================================================================
# QUICK FIX MODE - Just fix Android package mismatch
# ============================================================================

if [ "$MODE" = "fix" ]; then
    echo -e "${BLUE}🔧 Quick Fix Mode - Android Package Only${NC}"
    echo ""
    echo "🔍 Checking Android package configuration..."
    
    # Read current package from build.gradle
    GRADLE_FILE="$PROJECT_ROOT/android/app/build.gradle"
    if [ ! -f "$GRADLE_FILE" ]; then
        echo -e "${RED}❌ build.gradle not found at: $GRADLE_FILE${NC}"
        exit 1
    fi
    
    CURRENT_PACKAGE=$(grep "namespace = " "$GRADLE_FILE" | sed 's/.*namespace = "\(.*\)".*/\1/')
    
    if [ -z "$CURRENT_PACKAGE" ]; then
        echo -e "${RED}❌ Could not find namespace in build.gradle${NC}"
        exit 1
    fi
    
    echo -e "📦 Current package: ${GREEN}$CURRENT_PACKAGE${NC}"
    
    # Find MainActivity
    MAIN_ACTIVITY=$(find "$PROJECT_ROOT/android/app/src/main/kotlin" -name "MainActivity.kt" 2>/dev/null | head -n 1)
    
    if [ -z "$MAIN_ACTIVITY" ]; then
        echo -e "${RED}❌ MainActivity.kt not found!${NC}"
        exit 1
    fi
    
    echo "📍 Found MainActivity at: $MAIN_ACTIVITY"
    
    # Get old package from MainActivity
    OLD_PACKAGE=$(head -n 1 "$MAIN_ACTIVITY" | grep "package" | sed 's/package //' | tr -d ' ')
    
    echo -e "📝 MainActivity package: ${YELLOW}$OLD_PACKAGE${NC}"
    
    if [ "$OLD_PACKAGE" = "$CURRENT_PACKAGE" ]; then
        echo -e "${GREEN}✅ Package is already correct! No changes needed.${NC}"
        exit 0
    fi
    
    echo ""
    echo -e "${YELLOW}⚠️  Package mismatch detected!${NC}"
    echo "   build.gradle namespace: $CURRENT_PACKAGE"
    echo "   MainActivity package:   $OLD_PACKAGE"
    echo ""
    read -p "Fix this now? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Aborted."
        exit 1
    fi
    
    # Create new package directory
    NEW_PACKAGE_PATH=$(echo "$CURRENT_PACKAGE" | tr '.' '/')
    NEW_DIR="$PROJECT_ROOT/android/app/src/main/kotlin/$NEW_PACKAGE_PATH"
    
    echo "📁 Creating directory: $NEW_DIR"
    mkdir -p "$NEW_DIR"
    
    # Update MainActivity package declaration and copy to new location
    echo "📝 Updating MainActivity.kt..."
    sed "s/package $OLD_PACKAGE/package $CURRENT_PACKAGE/" "$MAIN_ACTIVITY" > "$NEW_DIR/MainActivity.kt"
    
    # Remove old directory structure if different
    if [ "$OLD_PACKAGE" != "$CURRENT_PACKAGE" ]; then
        OLD_TOP_PACKAGE=$(echo "$OLD_PACKAGE" | cut -d'.' -f1)
        OLD_BASE_DIR="$PROJECT_ROOT/android/app/src/main/kotlin"
        OLD_TOP_DIR="$OLD_BASE_DIR/$OLD_TOP_PACKAGE"
        
        NEW_TOP_PACKAGE=$(echo "$CURRENT_PACKAGE" | cut -d'.' -f1)
        
        if [ -d "$OLD_TOP_DIR" ] && [ "$OLD_TOP_PACKAGE" != "$NEW_TOP_PACKAGE" ]; then
            echo "🗑️  Removing old package directory: $OLD_TOP_DIR"
            rm -rf "$OLD_TOP_DIR"
        fi
    fi
    
    echo ""
    echo -e "${GREEN}✅ Fixed! MainActivity is now at:${NC}"
    echo "   $NEW_DIR/MainActivity.kt"
    echo ""
    echo "🧹 Cleaning build..."
    cd "$PROJECT_ROOT"
    flutter clean
    
    echo ""
    echo -e "${GREEN}✅ Done! Now try running your app:${NC}"
    echo "   ./build.sh .env.development run"
    echo ""
    exit 0
fi

# ============================================================================
# FULL CONFIGURATION MODE - Complete app renaming
# ============================================================================

echo -e "${BLUE}🎨 Full Configuration Mode${NC}"
echo ""

# Check if config file exists
if [ ! -f "$PROJECT_ROOT/$CONFIG_FILE" ]; then
    echo -e "${RED}❌ Config file not found: $CONFIG_FILE${NC}"
    echo ""
    echo "Create one at scripts/app_config.json with this format:"
    cat << 'EOF'
{
  "appName": {
    "development": "Your App Dev",
    "staging": "Your App Stg",
    "production": "Your App"
  },
  "android": {
    "packageName": "com.yourcompany.yourapp",
    "applicationIdSuffix": {
      "development": ".dev",
      "staging": ".stg",
      "production": ""
    }
  },
  "ios": {
    "bundleId": {
      "development": "com.yourcompany.yourapp.dev",
      "staging": "com.yourcompany.yourapp.stg",
      "production": "com.yourcompany.yourapp"
    }
  }
}
EOF
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}❌ jq is not installed. Please install it first:${NC}"
    echo "   Ubuntu/Debian: sudo apt-get install jq"
    echo "   macOS: brew install jq"
    echo ""
    echo "Or use quick fix mode: ./scripts/configure_app.sh --fix"
    exit 1
fi

echo "📦 Reading configuration from $CONFIG_FILE..."

# Read values from config
APP_NAME_DEV=$(jq -r '.appName.development' "$PROJECT_ROOT/$CONFIG_FILE")
APP_NAME_STG=$(jq -r '.appName.staging' "$PROJECT_ROOT/$CONFIG_FILE")
APP_NAME_PROD=$(jq -r '.appName.production' "$PROJECT_ROOT/$CONFIG_FILE")
ANDROID_PACKAGE=$(jq -r '.android.packageName' "$PROJECT_ROOT/$CONFIG_FILE")
ANDROID_SUFFIX_DEV=$(jq -r '.android.applicationIdSuffix.development // ".dev"' "$PROJECT_ROOT/$CONFIG_FILE")
ANDROID_SUFFIX_STG=$(jq -r '.android.applicationIdSuffix.staging // ".stg"' "$PROJECT_ROOT/$CONFIG_FILE")
ANDROID_SUFFIX_PROD=$(jq -r '.android.applicationIdSuffix.production // ""' "$PROJECT_ROOT/$CONFIG_FILE")
IOS_BUNDLE_DEV=$(jq -r '.ios.bundleId.development' "$PROJECT_ROOT/$CONFIG_FILE")
IOS_BUNDLE_STG=$(jq -r '.ios.bundleId.staging' "$PROJECT_ROOT/$CONFIG_FILE")
IOS_BUNDLE_PROD=$(jq -r '.ios.bundleId.production' "$PROJECT_ROOT/$CONFIG_FILE")

ANDROID_ID_DEV="${ANDROID_PACKAGE}${ANDROID_SUFFIX_DEV}"
ANDROID_ID_STG="${ANDROID_PACKAGE}${ANDROID_SUFFIX_STG}"
ANDROID_ID_PROD="${ANDROID_PACKAGE}${ANDROID_SUFFIX_PROD}"

if [ "$ANDROID_ID_DEV" = "$ANDROID_ID_STG" ] || [ "$ANDROID_ID_DEV" = "$ANDROID_ID_PROD" ] || [ "$ANDROID_ID_STG" = "$ANDROID_ID_PROD" ]; then
    echo -e "${RED}❌ Android applicationIds must be unique across flavors for side-by-side install.${NC}"
    echo "   Got: $ANDROID_ID_DEV | $ANDROID_ID_STG | $ANDROID_ID_PROD"
    exit 1
fi

if [ "$IOS_BUNDLE_DEV" = "$IOS_BUNDLE_STG" ] || [ "$IOS_BUNDLE_DEV" = "$IOS_BUNDLE_PROD" ] || [ "$IOS_BUNDLE_STG" = "$IOS_BUNDLE_PROD" ]; then
    echo -e "${RED}❌ iOS bundleIds must be unique across flavors for side-by-side install.${NC}"
    echo "   Got: $IOS_BUNDLE_DEV | $IOS_BUNDLE_STG | $IOS_BUNDLE_PROD"
    exit 1
fi

echo ""
echo "Configuration:"
echo "  App Names:"
echo "    - Development: $APP_NAME_DEV"
echo "    - Staging: $APP_NAME_STG"
echo "    - Production: $APP_NAME_PROD"
echo "  Android applicationIds (side-by-side):"
echo "    - Development: $ANDROID_ID_DEV"
echo "    - Staging: $ANDROID_ID_STG"
echo "    - Production: $ANDROID_ID_PROD"
echo "  iOS Bundle IDs (side-by-side):"
echo "    - Development: $IOS_BUNDLE_DEV"
echo "    - Staging: $IOS_BUNDLE_STG"
echo "    - Production: $IOS_BUNDLE_PROD"
echo ""

read -p "Continue with these settings? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Aborted."
    exit 1
fi

echo ""
echo "🔧 Updating Android configuration..."

# Update Android build.gradle
GRADLE_FILE="$PROJECT_ROOT/android/app/build.gradle"
if [ -f "$GRADLE_FILE" ]; then
    # Backup
    cp "$GRADLE_FILE" "$GRADLE_FILE.bak"
    
    # Update applicationId (base) + namespace — flavor suffixes keep IDs unique
    sed -i.tmp "s/applicationId = \".*\"/applicationId = \"$ANDROID_PACKAGE\"/" "$GRADLE_FILE"
    rm -f "$GRADLE_FILE.tmp"

    sed -i.tmp "s/namespace = \".*\"/namespace = \"$ANDROID_PACKAGE\"/" "$GRADLE_FILE"
    rm -f "$GRADLE_FILE.tmp"

    # Update app names for each flavor (manifestPlaceholders.appName)
    sed -i.tmp "/development {/,/}/ s/appName: \".*\"/appName: \"$APP_NAME_DEV\"/" "$GRADLE_FILE"
    sed -i.tmp "/staging {/,/}/ s/appName: \".*\"/appName: \"$APP_NAME_STG\"/" "$GRADLE_FILE"
    sed -i.tmp "/production {/,/}/ s/appName: \".*\"/appName: \"$APP_NAME_PROD\"/" "$GRADLE_FILE"
    rm -f "$GRADLE_FILE.tmp"

    # Keep / restore applicationIdSuffix so flavors install as separate apps
    python3 << PY
from pathlib import Path
import re

path = Path("$GRADLE_FILE")
text = path.read_text()
suffixes = {
    "development": "$ANDROID_SUFFIX_DEV",
    "staging": "$ANDROID_SUFFIX_STG",
    "production": "$ANDROID_SUFFIX_PROD",
}

def patch_flavor(src: str, flavor: str, suffix: str) -> str:
    pattern = rf"(productFlavors\s*\{{.*?{flavor}\s*\{{)(.*?)(\n\s*\}})"
    match = re.search(pattern, src, flags=re.DOTALL)
    if not match:
        raise SystemExit(f"Could not find productFlavor '{flavor}' in build.gradle")
    head, body, tail = match.group(1), match.group(2), match.group(3)
    if suffix:
        if re.search(r'applicationIdSuffix\s+"[^"]*"', body):
            body = re.sub(r'applicationIdSuffix\s+"[^"]*"', f'applicationIdSuffix "{suffix}"', body, count=1)
        else:
            body = body.replace(
                'dimension "default"',
                f'dimension "default"\n            applicationIdSuffix "{suffix}"',
                1,
            )
    else:
        body = re.sub(r'\n\s*applicationIdSuffix\s+"[^"]*"', "", body)
    return src[: match.start()] + head + body + tail + src[match.end() :]

for flavor, suffix in suffixes.items():
    text = patch_flavor(text, flavor, suffix)

path.write_text(text)
print("  ✅ Restored applicationIdSuffix per flavor")
PY

    echo "  ✅ Updated android/app/build.gradle"
else
    echo "  ⚠️  android/app/build.gradle not found"
fi

# Handle MainActivity relocation
KOTLIN_BASE="$PROJECT_ROOT/android/app/src/main/kotlin"

if [ -d "$KOTLIN_BASE" ]; then
    MAIN_ACTIVITY=$(find "$KOTLIN_BASE" -name "MainActivity.kt" 2>/dev/null | head -n 1)
    
    if [ -n "$MAIN_ACTIVITY" ]; then
        OLD_PACKAGE=$(head -n 1 "$MAIN_ACTIVITY" | grep "package" | sed 's/package //' | tr -d ' ' | tr -d '\n' | tr -d '\r')
        echo "  📝 Found old package: $OLD_PACKAGE"
        
        # Save MainActivity content
        MAIN_ACTIVITY_CONTENT=$(cat "$MAIN_ACTIVITY")
        
        # Clean entire kotlin directory to avoid nested paths
        echo "  🧹 Cleaning kotlin directory..."
        rm -rf "$KOTLIN_BASE"/*
        
        # Create new package directory structure
        NEW_PACKAGE_PATH=$(echo "$ANDROID_PACKAGE" | tr '.' '/')
        NEW_DIR="$KOTLIN_BASE/$NEW_PACKAGE_PATH"
        
        mkdir -p "$NEW_DIR"
        
        # Create MainActivity with correct package
        cat > "$NEW_DIR/MainActivity.kt" << EOF
package $ANDROID_PACKAGE

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()
EOF
        
        echo "  ✅ Created MainActivity at $NEW_PACKAGE_PATH/MainActivity.kt"
    else
        # No MainActivity found, create a new one
        echo "  📝 MainActivity not found, creating new one..."
        
        # Clean and create new
        rm -rf "$KOTLIN_BASE"/*
        NEW_PACKAGE_PATH=$(echo "$ANDROID_PACKAGE" | tr '.' '/')
        NEW_DIR="$KOTLIN_BASE/$NEW_PACKAGE_PATH"
        mkdir -p "$NEW_DIR"
        
        cat > "$NEW_DIR/MainActivity.kt" << EOF
package $ANDROID_PACKAGE

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()
EOF
        
        echo "  ✅ Created MainActivity at $NEW_PACKAGE_PATH/MainActivity.kt"
    fi
else
    echo "  ⚠️  android/app/src/main/kotlin directory not found"
fi

echo ""
echo "🍎 Updating iOS configuration..."

# Update iOS project.pbxproj (Python: scoped per-flavor, avoids collapsing .dev/.stg → production)
PBXPROJ_FILE="$PROJECT_ROOT/ios/Runner.xcodeproj/project.pbxproj"
if [ -f "$PBXPROJ_FILE" ]; then
    cp "$PBXPROJ_FILE" "$PBXPROJ_FILE.bak"

    APP_NAME_DEV="$APP_NAME_DEV" \
    APP_NAME_STG="$APP_NAME_STG" \
    APP_NAME_PROD="$APP_NAME_PROD" \
    IOS_BUNDLE_DEV="$IOS_BUNDLE_DEV" \
    IOS_BUNDLE_STG="$IOS_BUNDLE_STG" \
    IOS_BUNDLE_PROD="$IOS_BUNDLE_PROD" \
    PBXPROJ_FILE="$PBXPROJ_FILE" \
    python3 << 'PY'
import os
import re
from pathlib import Path

path = Path(os.environ["PBXPROJ_FILE"])
content = path.read_text()

flavors = {
    "development": (os.environ["IOS_BUNDLE_DEV"], os.environ["APP_NAME_DEV"]),
    "staging": (os.environ["IOS_BUNDLE_STG"], os.environ["APP_NAME_STG"]),
    "production": (os.environ["IOS_BUNDLE_PROD"], os.environ["APP_NAME_PROD"]),
}
tests_bundle = f'{os.environ["IOS_BUNDLE_PROD"]}.RunnerTests'

# Preserve the 24-char Xcode object ID before /* Name */.
block_re = re.compile(
    r"(?P<uuid>[A-F0-9]{24} )/\* (?P<name>[^*]+) \*/ = \{\n"
    r"\t\t\tisa = XCBuildConfiguration;\n"
    r"(?P<body>.*?)\n"
    r"\t\t\};",
    re.DOTALL,
)

def update_setting(body: str, key: str, value: str) -> str:
    pattern = rf'({re.escape(key)} = )[^;]+;'
    if re.search(pattern, body):
        return re.sub(pattern, rf'\g<1>{value};', body, count=1)
    return body

updated = 0

def transform_safe(match: re.Match) -> str:
    global updated
    name = match.group("name").strip()
    body = match.group("body")
    full = match.group(0)
    uuid = match.group("uuid")

    flavor = None
    for candidate in ("development", "staging", "production"):
        if re.search(rf"(^|-)({candidate})$", name):
            flavor = candidate
            break
    if flavor is None:
        return full

    bundle_id, app_name = flavors[flavor]

    if "BUNDLE_LOADER =" in body:
        body = update_setting(body, "PRODUCT_BUNDLE_IDENTIFIER", tests_bundle)
    elif "APP_NAME =" in body:
        # Escape quotes in display names for pbxproj string literals.
        safe_name = app_name.replace('"', '\\"')
        body = update_setting(body, "APP_NAME", f'"{safe_name}"')
        body = update_setting(body, "PRODUCT_BUNDLE_IDENTIFIER", bundle_id)
    else:
        return full

    updated += 1
    return (
        f"{uuid}/* {match.group('name')} */ = {{\n"
        f"\t\t\tisa = XCBuildConfiguration;\n"
        f"{body}\n"
        f"\t\t}};"
    )

new_content, matched = block_re.subn(transform_safe, content)
if matched == 0:
    raise SystemExit("No XCBuildConfiguration blocks matched in project.pbxproj")
if updated == 0:
    raise SystemExit("Matched configs but updated none (missing APP_NAME / BUNDLE_LOADER?)")

# Guard: Runner flavor bundle IDs must remain distinct after rewrite.
runner_ids = set(
    re.findall(
        r'APP_NAME = .*?\n.*?PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);',
        new_content,
        flags=re.DOTALL,
    )
)
expected = {
    os.environ["IOS_BUNDLE_DEV"],
    os.environ["IOS_BUNDLE_STG"],
    os.environ["IOS_BUNDLE_PROD"],
}
if not expected.issubset(runner_ids):
    raise SystemExit(
        f"iOS bundle IDs not applied correctly.\n"
        f"  expected subset of: {sorted(expected)}\n"
        f"  found runner IDs: {sorted(runner_ids)}"
    )
if len(expected) < 3:
    raise SystemExit("iOS bundle IDs must be unique across the three flavors")

path.write_text(new_content)
print(f"  updated {updated} Runner/Tests configuration blocks (matched {matched})")
PY

    echo "  ✅ Updated ios/Runner.xcodeproj/project.pbxproj"
else
    echo "  ⚠️  ios/Runner.xcodeproj/project.pbxproj not found"
fi

echo ""
echo "🎯 Updating Dart flavor entrypoints..."

update_dart_app_name() {
    local file="$1"
    local app_name="$2"
    if [ -f "$file" ]; then
        # Portable in-place edit (macOS + Linux)
        sed -i.tmp "s/appName: '.*'/appName: '$app_name'/" "$file"
        rm -f "$file.tmp"
        echo "  ✅ Updated $(basename "$file") → $app_name"
    else
        echo "  ⚠️  $file not found"
    fi
}

update_dart_app_name "$PROJECT_ROOT/lib/main_development.dart" "$APP_NAME_DEV"
update_dart_app_name "$PROJECT_ROOT/lib/main_staging.dart" "$APP_NAME_STG"
update_dart_app_name "$PROJECT_ROOT/lib/main_production.dart" "$APP_NAME_PROD"

echo ""
echo "🔥 Updating Firebase configuration script..."

# Update flutterfire.config.sh with new bundle IDs
FIREBASE_CONFIG="$PROJECT_ROOT/flutterfire.config.sh"
if [ -f "$FIREBASE_CONFIG" ]; then
    # Backup
    cp "$FIREBASE_CONFIG" "$FIREBASE_CONFIG.bak"

    sed -i.tmp "s|PACKAGE_BASE=\".*\"|PACKAGE_BASE=\"$ANDROID_PACKAGE\"|" "$FIREBASE_CONFIG"
    rm -f "$FIREBASE_CONFIG.tmp"

    echo "  ✅ Updated flutterfire.config.sh PACKAGE_BASE=$ANDROID_PACKAGE"
else
    echo "  ⚠️  flutterfire.config.sh not found (skip if not using Firebase)"
fi

echo ""
echo -e "${GREEN}✅ App configuration completed!${NC}"
echo ""
echo "Side-by-side install IDs (must all differ):"
echo "  Android: $ANDROID_ID_DEV | $ANDROID_ID_STG | $ANDROID_ID_PROD"
echo "  iOS:     $IOS_BUNDLE_DEV | $IOS_BUNDLE_STG | $IOS_BUNDLE_PROD"
echo ""
echo "Next steps:"
echo "  1. Review the changes"
echo "  2. flutter pub get"
echo "  3. Install each flavor separately (do not expect one run to replace another):"
echo "       make development   # installs $ANDROID_ID_DEV / $IOS_BUNDLE_DEV"
echo "       make staging       # installs $ANDROID_ID_STG / $IOS_BUNDLE_STG"
echo "       make production    # installs $ANDROID_ID_PROD / $IOS_BUNDLE_PROD"
echo "  4. On the device/simulator home screen you should see three app icons with different names"
echo ""
echo "📦 Backup files created (*.bak) - delete them once verified"
echo ""
echo "💡 If using Firebase:"
echo "   Run: ./flutterfire.config.sh <environment> <project-id>"
echo "   Then uncomment firebase_options in lib/main_<flavor>.dart"
echo ""


