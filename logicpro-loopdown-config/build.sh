#!/bin/bash
# Package-specific build tasks for loopdown-config

set -e

# The payload/ directory already contains the plist in the correct location
# Just run the generic build script
../build.sh

echo ""
echo "This package will:"
echo "  1. Install logicpro1120-custom.plist to /Library/Application Support/Loopdown/"
echo "  2. Check for loopdown and managed_python3"
echo "  3. Run loopdown to download and install the Logic Pro content"
echo ""
echo "Install with: sudo installer -pkg loopdown-config.pkg -target /"
