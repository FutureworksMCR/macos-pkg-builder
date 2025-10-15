# macOS Package Builder

Simple, modular system for building macOS packages via GitHub Actions.

## Quick Start

### Create a New Package

```bash
# Copy the template
cp -r template/ my-new-package/

# Edit configuration
cd my-new-package
nano pkgbuild.yaml

# Add files to payload/ and scripts/
# Then build
./build.sh
```

### Build System

Each package directory contains:
- `pkgbuild.yaml` - Package metadata (identifier, version, install location)
- `build.sh` - Package-specific build logic
- `payload/` - Files to install (optional)
- `scripts/` - Pre/post install scripts (optional)

The **generic `build.sh`** at the root handles the actual package building. Each package's `build.sh` does package-specific prep work and then calls `../build.sh`.

## GitHub Actions

### Build Workflow

The build workflow automatically:
1. Discovers all packages (any directory with `pkgbuild.yaml`, excluding `template/`)
2. Builds them in parallel using a matrix strategy
3. Uploads built packages as artifacts (30-day retention)

Push to main or create a PR to trigger builds.

### Release Workflow

To create a GitHub Release for a package:

1. Go to **Actions** → **Release Package**
2. Click **Run workflow**
3. Enter the package name (e.g., `logicpro-loopdown-config`)
4. Optionally specify a version (or leave empty to use version from `pkgbuild.yaml`)
5. Click **Run workflow**

## Template

See [template/README.md](template/README.md) for the package template guide.

## License

MIT - see LICENSE