# iOS 16 Force Updater - Usage Guide

## Overview
This tool forces iOS 16 installation on iPhone 6s and iPhone 7 devices using spoofing methods to bypass Apple's compatibility checks.

## Installation

1. Clone the repository:
```bash
git clone https://github.com/kingofvids/ios-force-updater.git
cd ios-force-updater
```

2. Run setup script:
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

3. Build with Xcode:
```bash
xcodebuild -scheme ios-force-updater -configuration Release
```

## Methods Used

### 1. Device Model Spoofing
- Modifies User-Agent headers to report as iPhone 8+
- Injects custom device model identifiers
- Bypasses initial compatibility checks

### 2. System Version Override
- Overrides reported iOS version to 16.0
- Stores spoof in UserDefaults
- Persists across requests

### 3. Capability Mask Manipulation
- Spoofs device capabilities
- Reports A9 chip as compatible with iOS 16
- Bypasses RAM/storage checks

### 4. Firmware Signature Bypass
- Modifies firmware signature validation
- Allows installation of unsigned firmware
- Kernel-level modifications required

## Usage

### Command Line
```bash
./updater --device iPhone7,2 --target-version 16.0 --force-install
```

### Programmatic
```swift
let updater = ForceUpdater.shared
let result = updater.forceUpdateToiOS16(deviceModel: "iPhone7,2")

switch result {
case .success(let message):
    print(message)
case .failure(let error):
    print("Error: \(error)")
}
```

### Via App
1. Launch the app
2. Tap "Force Update to iOS 16"
3. Follow on-screen prompts
4. Device will restart and begin installation

## Configuration

Edit `config/update_config.json` to customize:
- Supported devices
- Target iOS version
- Update server URL
- Bypass options

## Troubleshooting

### Update Failed
- Ensure device has 5.9GB+ free storage
- Check internet connection
- Verify device is supported (iPhone 6s/7)
- Try force restart before retrying

### Spoofing Not Working
- Clear app cache and data
- Disable any VPN/proxy
- Ensure full device trust
- Check UserDefaults for conflicts

### Installation Stuck
- Force restart device (hold power + home)
- Connect to iTunes/Finder and restore
- Retry with updated firmware

## Advanced

### Kernel Bypass
For deeper system modifications, use kernel-level exploits in `exploits/KernelBypass.h`:

```c
bypass_device_tree_validation("iPhone7,2");
bypass_firmware_signature(firmware_data, firmware_size);
spoof_kernel_version(160000);
```

## Security Warning
This tool modifies system files and bypasses security checks. Use with caution and only on devices you own.
