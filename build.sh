#!/bin/bash
# Generic build script for macOS packages
# Reads pkgbuild.yaml and builds the package

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_NAME="$(basename "$SCRIPT_DIR")"

echo "=== Building $PACKAGE_NAME package ==="

# Check for required files
if [[ ! -f "pkgbuild.yaml" ]]; then
    echo "ERROR: pkgbuild.yaml not found"
    exit 1
fi

# Read package configuration
IDENTIFIER=$(grep "identifier:" pkgbuild.yaml | awk '{print $2}')
VERSION=$(grep "version:" pkgbuild.yaml | awk '{print $2}')
INSTALL_LOCATION=$(grep "install_location:" pkgbuild.yaml | awk '{print $2}')

if [[ -z "$IDENTIFIER" ]]; then
    echo "ERROR: identifier not found in pkgbuild.yaml"
    exit 1
fi

if [[ -z "$VERSION" ]]; then
    echo "ERROR: version not found in pkgbuild.yaml"
    exit 1
fi

echo "Identifier: $IDENTIFIER"
echo "Version: $VERSION"
echo "Install Location: ${INSTALL_LOCATION:-/}"

# Create build directory structure
BUILD_DIR="build"
PAYLOAD_DIR="$BUILD_DIR/payload"
SCRIPTS_DIR="$BUILD_DIR/scripts"

rm -rf "$BUILD_DIR"
mkdir -p "$PAYLOAD_DIR"

# Copy payload files if they exist
if [[ -d "payload" ]]; then
    echo "Copying payload files..."
    cp -R payload/* "$PAYLOAD_DIR/" 2>/dev/null || true
fi

# Copy scripts if they exist
if [[ -d "scripts" ]]; then
    echo "Preparing install scripts..."
    mkdir -p "$SCRIPTS_DIR"
    
    for script in preinstall postinstall; do
        if [[ -f "scripts/$script" ]]; then
            cp "scripts/$script" "$SCRIPTS_DIR/"
            chmod +x "$SCRIPTS_DIR/$script"
            echo "  Added: $script"
        fi
    done
fi

# Build pkgbuild command
PKGBUILD_CMD=(
    pkgbuild
    --root "$PAYLOAD_DIR"
    --identifier "$IDENTIFIER"
    --version "$VERSION"
    --install-location "${INSTALL_LOCATION:-/}"
)

# Add scripts directory if it exists and has files
if [[ -d "$SCRIPTS_DIR" ]] && [[ -n "$(ls -A "$SCRIPTS_DIR" 2>/dev/null)" ]]; then
    PKGBUILD_CMD+=(--scripts "$SCRIPTS_DIR")
fi

# Output filename
OUTPUT_PKG="${PACKAGE_NAME}.pkg"
PKGBUILD_CMD+=("$OUTPUT_PKG")

# Build the package
echo "Running pkgbuild..."
"${PKGBUILD_CMD[@]}"

echo ""
echo "=== Package built successfully ==="
echo "Output: $OUTPUT_PKG"
echo ""

# Show package info if available
if command -v pkgutil >/dev/null 2>&1; then
    echo "Package Info:"
    pkgutil --payload-files "$OUTPUT_PKG" 2>/dev/null | head -20 || true
fi
