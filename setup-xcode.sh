#!/bin/bash
set -e

echo "🚀 Setting up Croquet Deadness Board Xcode Projects"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_ROOT="$(pwd)"

echo -e "${BLUE}Step 1: Generate Xcode project from Package.swift${NC}"
swift package generate-xcodeproj

if [ -f "CroquetDeadnessBoard.xcodeproj/project.pbxproj" ]; then
    echo -e "${GREEN}✓ Xcode project generated successfully${NC}"
else
    echo -e "${RED}✗ Failed to generate Xcode project${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Step 2: Open project in Xcode${NC}"
echo ""
echo "You can now:"
echo "  1. Open CroquetDeadnessBoard.xcodeproj in Xcode"
echo "  2. Select the iOS or tvOS scheme"
echo "  3. Build and run (⌘R)"
echo ""
echo -e "${GREEN}✓ Setup complete!${NC}"
echo ""
echo "To open in Xcode:"
echo "  open CroquetDeadnessBoard.xcodeproj"
