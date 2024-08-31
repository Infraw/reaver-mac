# Reaver MAC Address Changer Script

This script automates the process of changing the MAC address of a wireless interface and running the `reaver` tool for WPS (Wi-Fi Protected Setup) attacks.

## Features

- Changes the MAC address of a specified wireless interface.
- Runs `reaver` with user-defined options.
- Configurable number of reaver pin attempts before changing the MAC address.

## Requirements

- `reaver`
- `macchanger`
- `sudo` (for changing MAC address and running `reaver`)

## Usage

```bash
./script.sh -i <interface> -b <BSSID> -c <channel> [-r <reaver_options>] [-a <attempts>]
