#!/bin/bash
# Package-specific build tasks
# Add any custom build logic here before calling the generic build script

set -e

# Example: Copy files to payload
# mkdir -p payload/usr/local/bin
# cp my-script.sh payload/usr/local/bin/

# Run the generic build script
../build.sh
