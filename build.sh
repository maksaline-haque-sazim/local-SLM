#!/bin/bash
# Convenience wrapper matching: flutter run --flavor <flavor> -t lib/main_<flavor>.dart
# Usage: ./build.sh <development|staging|production> [run|build] [extra flutter args...]

set -euo pipefail

FLAVOR="${1:-development}"
COMMAND="${2:-run}"
shift $(( $# > 0 ? 1 : 0 ))
shift $(( $# > 0 ? 1 : 0 )) || true

case "$FLAVOR" in
  development|dev) FLAVOR="development" ;;
  staging|stg) FLAVOR="staging" ;;
  production|prod) FLAVOR="production" ;;
  --help|-h)
    echo "Usage: ./build.sh <development|staging|production> [run|build] [flutter args...]"
    exit 0
    ;;
  *)
    echo "Unknown flavor: $FLAVOR"
    exit 1
    ;;
esac

ENV_FILE=".env.${FLAVOR}"
MAIN_DART="lib/main_${FLAVOR}.dart"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ Environment file '$ENV_FILE' not found."
  exit 1
fi

echo "Validating $ENV_FILE..."
dart run scripts/validate_env.dart "$ENV_FILE"

if [[ -d "ios/Scripts" ]]; then
  bash ios/Scripts/read_env.sh "$ENV_FILE"
fi

echo "Using flavor: $FLAVOR and entry point: $MAIN_DART"
flutter "$COMMAND" "$@" --flavor "$FLAVOR" -t "$MAIN_DART"
