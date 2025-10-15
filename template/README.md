# Package Template

This is a template for creating new packages. Copy this directory to create a new package.

## Quick Start

```bash
# Copy template to create a new package
cp -r template/ my-new-package/

# Edit configuration
cd my-new-package
nano pkgbuild.yaml

# Add your files to payload/
# Add install scripts to scripts/
# Customize build.sh if needed

# Build the package
./build.sh
```

## Structure

- `pkgbuild.yaml` - Package metadata (identifier, version, install location)
- `build.sh` - Package-specific build logic (calls generic `../build.sh`)
- `payload/` - Files to install (mirrors target filesystem structure)
- `scripts/` - Optional pre/post install scripts

## pkgbuild.yaml Format

```yaml
identifier: com.company.packagename
version: 1.0.0
install_location: /
```

## Payload Directory

Files in `payload/` will be installed relative to `install_location`. For example:

```
payload/
  usr/
    local/
      bin/
        my-script.sh
```

Will be installed to `/usr/local/bin/my-script.sh` (if install_location is `/`)

## Scripts

- `preinstall` - Runs before files are installed
- `postinstall` - Runs after files are installed

Both scripts must exit with code 0 for the package to install successfully.

## Build Process

1. Your `build.sh` prepares any custom payload files
2. It calls `../build.sh` (generic build script)
3. Generic script reads `pkgbuild.yaml` and calls `pkgbuild`
4. Package is created as `<directory-name>.pkg`
