#!/bin/bash
# flutterfire.config.sh
# Usage: ./flutterfire.config.sh <development|staging|production> [project-id]

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Error: No environment specified. Use 'development', 'staging', or 'production'."
  echo "Usage: $0 <environment> [project-id]"
  exit 1
fi

ENV="$1"
PACKAGE_BASE="com.maksaline.local_slm"

if [[ $# -lt 2 ]]; then
  echo "Enter Firebase project ID for $ENV environment:"
  read -r PROJECT_ID
else
  PROJECT_ID="$2"
fi

case "$ENV" in
  development)
    BUNDLE_ID="${PACKAGE_BASE}.dev"
    PACKAGE_NAME="${PACKAGE_BASE}.dev"
    ;;
  staging|stg)
    ENV=staging
    BUNDLE_ID="${PACKAGE_BASE}.stg"
    PACKAGE_NAME="${PACKAGE_BASE}.stg"
    ;;
  production|prod)
    ENV=production
    BUNDLE_ID="${PACKAGE_BASE}"
    PACKAGE_NAME="${PACKAGE_BASE}"
    ;;
  *)
    echo "Use development | staging | production"
    exit 1
    ;;
esac

mkdir -p "ios/flavors/$ENV" "android/app/src/$ENV"

echo "Configuring Firebase for $ENV (project: $PROJECT_ID)"
flutterfire config \
  --project="$PROJECT_ID" \
  --out="lib/firebase_options_${ENV}.dart" \
  --ios-bundle-id="$BUNDLE_ID" \
  --ios-out="ios/flavors/${ENV}/GoogleService-Info.plist" \
  --android-package-name="$PACKAGE_NAME" \
  --android-out="android/app/src/${ENV}/google-services.json"

echo "Verifying files for $ENV..."
for f in \
  "lib/firebase_options_${ENV}.dart" \
  "android/app/src/${ENV}/google-services.json" \
  "ios/flavors/${ENV}/GoogleService-Info.plist"
do
  if [[ -f "$f" ]]; then
    echo "✅ $f"
  else
    echo "❌ Missing: $f"
  fi
done

echo "Firebase configuration for $ENV completed."
echo "Next: uncomment firebase_options import in lib/main_${ENV}.dart"
