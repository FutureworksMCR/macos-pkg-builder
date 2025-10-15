# Logic Pro Loopdown Configuration Package

Installs a predefined Logic Pro audio content configuration and automatically downloads the content using loopdown.

## What it does

1. Installs a custom `logicproxxxx.plist` directly to `/Library/Application Support/Loopdown/`
2. Postinstall script checks for required tools (loopdown and managed_python3)
3. Postinstall runs loopdown to download and install all audio content specified in the plist

## Requirements

- loopdown must be installed at `/usr/local/bin/loopdown`
- Python 3 must be installed at `/usr/local/bin/managed_python3`

If either requirement is missing, the package will fail with a clear error message.

## Building

```bash
cd logicpro-loopdown-config
./build.sh
```

This creates `logicpro-loopdown-config.pkg`

## Installing

```bash
sudo installer -pkg logicpro-loopdown-config.pkg -target /
```

Monitor the installation with:
```bash
# Package installation log
tail -f /var/log/logicpro-loopdown-config-install.log

# Detailed loopdown logs
tail -f /Users/Shared/loopdown/*.log
```

## Configuration

Edit `payload/Library/Application Support/Loopdown/logicproxxxx-custom.plist` to change which content packages are downloaded.

To discover available plists:
```bash
loopdown --discover-plists
```

To download a specific plist from Apple:
```bash
curl -O https://audiocontentdownload.apple.com/lp10_ms3_content_2016/<plist-name>.plist
```

Example:
```bash
curl -O https://audiocontentdownload.apple.com/lp10_ms3_content_2016/logicpro1120.plist
```

## Package Mirror

This package is hardcoded to use a local package mirror.

To change this, edit `scripts/postinstall` and modify the `PKG_SERVER` variable:
- Set to your mirror URL to use a local server
- Set to empty string `PKG_SERVER=""` to use Apple's CDN directly

## Notes

- Package installation log: `/var/log/logicpro-loopdown-config-install.log`
- Detailed loopdown logs: `/Users/Shared/loopdown/`
