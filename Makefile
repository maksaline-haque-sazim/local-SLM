.PHONY: help validate development staging production \
	build-dev build-staging build-prod \
	build-ios-dev build-ios-staging build-ios-prod

FLUTTER ?= fvm flutter

help:
	@echo "Flutter Flavor Commands"
	@echo ""
	@echo "  make development   - Run development flavor"
	@echo "  make staging       - Run staging flavor"
	@echo "  make production    - Run production flavor"
	@echo ""
	@echo "  make build-dev / build-staging / build-prod"
	@echo "  make build-ios-dev / build-ios-staging / build-ios-prod"
	@echo "  make validate      - Validate all .env.* files"

validate:
	@dart scripts/validate_env.dart .env.development
	@dart scripts/validate_env.dart .env.staging
	@dart scripts/validate_env.dart .env.production

development: validate
	$(FLUTTER) run --flavor development -t lib/main_development.dart

staging: validate
	$(FLUTTER) run --flavor staging -t lib/main_staging.dart

production: validate
	$(FLUTTER) run --flavor production -t lib/main_production.dart

build-dev: validate
	$(FLUTTER) build apk --flavor development -t lib/main_development.dart

build-staging: validate
	$(FLUTTER) build apk --flavor staging -t lib/main_staging.dart

build-prod: validate
	$(FLUTTER) build apk --flavor production -t lib/main_production.dart

build-ios-dev: validate
	$(FLUTTER) build ios --flavor development -t lib/main_development.dart

build-ios-staging: validate
	$(FLUTTER) build ios --flavor staging -t lib/main_staging.dart

build-ios-prod: validate
	$(FLUTTER) build ios --flavor production -t lib/main_production.dart
