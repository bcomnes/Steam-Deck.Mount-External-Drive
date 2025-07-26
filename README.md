# Steam Deck Additional NVME Mount - Minimal Version

A minimal extension to add support for additional NVME drives (nvme1n1, nvme2n1, etc.) on Steam Deck and SteamOS.

**This works alongside Valve's existing automount system** - it doesn't replace or override anything, just adds support for additional NVME drives that Valve's system doesn't handle.

## What This Does

- Adds a single udev rule to detect additional NVME drives (nvme1n1, nvme2n1, etc.)
- Uses Valve's existing `/usr/lib/hwsupport/block-device-event.sh` script
- Supports ext4 filesystem (what Steam prefers for game libraries)
- Installs as higher priority (100) so it runs after Valve's rules (99)
- Does NOT interfere with Valve's handling of SD cards, USB drives, or nvme0n1

## Supported Devices

- `nvme1n1`, `nvme2n1`, etc. (whole additional NVME devices)
- `nvme1n1p1`, `nvme2n1p5`, etc. (any partitions on additional NVME drives)

## Supported Filesystems

- **ext4** - Full support with automatic Steam library integration
- **Other filesystems** - Will be rejected by Valve's script (use the full-featured version if needed)

## Installation

### Via Curl (One Line Install)

In Konsole type:
```bash
curl -sSL https://raw.githubusercontent.com/bcomnes/Steam-Deck.Mount-External-Drive/minimal/curl_install.sh | bash
```

A `sudo` password is required (run `passwd` if required first).

## How It Works

1. Adds a single udev rule file: `/etc/udev/rules.d/100-additional-nvme-automount.rules`
2. When you plug in an additional NVME drive with ext4, it triggers Valve's existing automount system
3. The drive gets mounted to `/run/media/deck/[LABEL]` just like any other external drive
4. Steam automatically detects and adds it as a game library location
5. No custom scripts, no systemd services - just extends what's already there

## Operation

Additional NVME drives will be auto-mounted to `/run/media/deck/[LABEL]` (e.g., `/run/media/deck/GameDrive/`). If the device has no label, the device's UUID will be used (e.g., `/run/media/deck/a12332-12bf-a33ab-eef/`).

## Uninstall

```bash
sudo rm /etc/udev/rules.d/100-additional-nvme-automount.rules
sudo udevadm control --reload
```

## Why Minimal?

- **Safety**: Doesn't replace or modify Valve's existing system
- **Compatibility**: Works with future SteamOS updates
- **Simplicity**: Just one small rule file
- **Focused**: Only adds what's needed for additional NVME drives
- **Reliable**: Uses Valve's own mounting logic

## Differences from Full-Featured Versions

This minimal version:
- ✅ Supports additional NVME drives (nvme1n1+) with ext4
- ✅ Works alongside Valve's system without conflicts
- ✅ No custom scripts or services to maintain
- ✅ Uses Valve's Steam library integration
- ❌ Doesn't support NTFS/BTRFS/exFAT (use ext4 instead)
- ❌ Doesn't override Valve's USB/SD handling
- ❌ No custom mounting logic

## Troubleshooting

1. **Check if rule is installed:**
   ```bash
   ls -la /etc/udev/rules.d/100-additional-nvme-automount.rules
   ```

2. **Test udev detection:**
   ```bash
   sudo udevadm monitor --property
   # Then plug in your drive
   ```

3. **Manual trigger:**
   ```bash
   sudo udevadm trigger --action=add --name-match=nvme1n1p1
   ```

4. **Check if drive is detected:**
   ```bash
   lsblk
   ```

## Format Recommendation

For best compatibility with Steam, format your additional NVME drive as ext4:

```bash
# Example: Format nvme1n1 as ext4 with label "GameDrive"
sudo mkfs.ext4 -L GameDrive /dev/nvme1n1
```

## License

DBAD - https://github.com/bcomnes/Steam-Deck.Mount-External-Drive/blob/main/LICENSE.md

## Issues

Report bugs at: https://github.com/bcomnes/Steam-Deck.Mount-External-Drive/issues
