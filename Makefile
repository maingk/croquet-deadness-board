# Croquet Deadness Board - Development Makefile

.PHONY: help setup clean build test lint format ios tvos run-ios run-tvos

# Default target
help:
	@echo "Croquet Deadness Board - Available commands:"
	@echo ""
	@echo "Setup & Dependencies:"
	@echo "  setup           Setup development environment"
	@echo "  clean           Clean build artifacts"
	@echo ""
	@echo "Build & Test:"
	@echo "  build           Build all targets"
	@echo "  test            Run all tests"
	@echo "  ios             Build iOS app"
	@echo "  tvos            Build tvOS app"
	@echo ""
	@echo "Development:"
	@echo "  run-ios         Run iOS app in simulator"
	@echo "  run-tvos        Run tvOS app in simulator"
	@echo "  lint            Run SwiftLint"
	@echo "  format          Format code with SwiftFormat"
	@echo ""
	@echo "Documentation:"
	@echo "  docs            Generate documentation"
	@echo "  serve-docs      Serve documentation locally"

# Setup development environment
setup:
	@echo "Setting up development environment..."
	@echo "Resolving Swift Package Manager dependencies..."
	swift package resolve
	@echo "Setup complete!"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	swift package clean
	rm -rf .build
	rm -rf DerivedData
	@echo "Clean complete!"

# Build all targets
build:
	@echo "Building all targets..."
	swift build

# Run tests
test:
	@echo "Running tests..."
	swift test --verbose

# Build iOS specific (requires Xcode)
ios:
	@echo "Building iOS app..."
	@echo "Note: iOS builds require Xcode. Open the project in Xcode to build iOS target."

# Build tvOS specific (requires Xcode)
tvos:
	@echo "Building tvOS app..."
	@echo "Note: tvOS builds require Xcode. Open the project in Xcode to build tvOS target."

# Run iOS app in simulator (requires Xcode)
run-ios:
	@echo "Running iOS app in simulator..."
	@echo "Note: Use Xcode to run iOS app in simulator."

# Run tvOS app in simulator (requires Xcode)
run-tvos:
	@echo "Running tvOS app in simulator..."
	@echo "Note: Use Xcode to run tvOS app in simulator."

# Lint code (if SwiftLint is installed)
lint:
	@if command -v swiftlint >/dev/null 2>&1; then \
		echo "Running SwiftLint..."; \
		swiftlint lint; \
	else \
		echo "SwiftLint not installed. Install with: brew install swiftlint"; \
	fi

# Format code (if SwiftFormat is installed)
format:
	@if command -v swiftformat >/dev/null 2>&1; then \
		echo "Running SwiftFormat..."; \
		swiftformat . --swiftversion 5.8; \
	else \
		echo "SwiftFormat not installed. Install with: brew install swiftformat"; \
	fi

# Generate documentation
docs:
	@if command -v swift-doc >/dev/null 2>&1; then \
		echo "Generating documentation..."; \
		swift-doc generate Shared/Models Shared/Services --module-name CroquetDeadnessBoard --output docs/api; \
	else \
		echo "swift-doc not installed. Install with: brew install swiftdocorg/formulae/swift-doc"; \
	fi

# Serve documentation locally
serve-docs:
	@if [ -d "docs/api" ]; then \
		echo "Serving documentation at http://localhost:8000"; \
		cd docs/api && python3 -m http.server 8000; \
	else \
		echo "Documentation not found. Run 'make docs' first."; \
	fi

# Development shortcuts
dev-setup: setup
	@echo "Installing development tools..."
	@echo "Installing SwiftLint and SwiftFormat via Homebrew (if available)..."
	@if command -v brew >/dev/null 2>&1; then \
		brew install swiftlint swiftformat; \
	else \
		echo "Homebrew not found. Please install SwiftLint and SwiftFormat manually."; \
	fi

# Continuous Integration commands
ci-test: clean build test lint

# Release preparation
release-check:
	@echo "Running release checks..."
	make clean
	make build
	make test
	make lint
	@echo "Release checks complete!"

# Quick commands for common tasks
quick-test:
	swift test --filter GameTests

quick-build:
	swift build --target SharedModels SharedServices