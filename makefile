chrome:
	@echo "Starting Flutter in Chrome with .env variables..."

	@dart_defines=""; \
	while IFS='=' read -r key value; do \
		case "$$key" in \
			''|\#*) continue ;; \
		esac; \
		key=$$(echo "$$key" | xargs); \
		value=$$(echo "$$value" | xargs); \
		dart_defines="$$dart_defines --dart-define=$$key=$$value"; \
	done < .env; \
	echo "👉 Running: flutter run -d chrome $$dart_defines"; \
	eval flutter run -d chrome $$dart_defines
