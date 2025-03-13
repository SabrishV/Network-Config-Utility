# Network Configuration Utility

A cool and powerful Windows batch script to automate switching between DHCP (automatic) and static (manual) network configurations. Easily manage your Ethernet or Wi‑Fi settings with custom **Home** and **Office** profiles!

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [License](#license)
- [Disclaimer](#disclaimer)

---

## Features

- **Dual Interface Support:**  
  Choose between configuring your Ethernet or Wi‑Fi interface.

- **Real-Time Status:**  
  View your current IP address, subnet mask, gateway, and DNS details at a glance.

- **Enhanced Wi‑Fi Information:**  
  When selecting Wi‑Fi, additional details like SSID, BSSID, and signal strength are displayed.

- **Flexible Configuration Options:**  
  Quickly switch to:
  - **DHCP (Automatic)**
  - **Home Static IP**
  - **Office Static IP**

- **Automatic Elevation:**  
  The script checks for administrative privileges and auto-relaunches with elevated rights if necessary.

- **Customizable & Modular:**  
  All network-specific details are abstracted as placeholders for easy customization.

---

## Getting Started

### Prerequisites

- **Operating System:** Windows 7 or later.
- **Command Prompt:** The script runs in Windows Command Prompt.
- **Admin Rights:** The script requires administrative privileges (it will auto-elevate if needed).

### Clone the Repository

Clone the repository using Git:

```bash
git clone https://github.com/SabrishV/Network-Config-Utility.git
cd Network-Config-Utility 
```

## Usage

Run the `sabnetwork_config.bat` file by either double-clicking it or executing it from an elevated Command Prompt. The script will guide you through the following steps:

### Select an Interface:
Choose between Ethernet or Wi‑Fi for configuration.

![Interface Selection](https://github.com/SabrishV/Network-Config-Utility/blob/main/UI%20Images/Screenshot%202025-03-08%20180425.png)

### View Current Settings:
The script displays the current network configuration details such as IP address, subnet mask, gateway, and DNS servers. When Wi‑Fi is selected, additional details like SSID, BSSID, and signal strength are shown.

### Apply a Configuration:
You can choose to:
- Switch to **DHCP (Automatic)**
- Set a **Home Static IP** configuration
- Set an **Office Static IP** configuration
  
![Config](https://github.com/SabrishV/Network-Config-Utility/blob/main/UI%20Images/Screenshot%202025-03-08%20180526.png)


### Refresh or Change:
Refresh the displayed status or change the interface selection as needed.

---

## Configuration

Before using the script, open the `sabnetwork_config.bat` file in your preferred text editor and customize the placeholders with your actual network settings:

### For Home Static IP:
- `<HOME_STATIC_IP>`: Your Home static IP address.
- `<HOME_SUBNET_MASK>`: Your Home subnet mask.
- `<HOME_GATEWAY>`: Your Home default gateway.
- `<HOME_DNS_SERVER>`: Your Home DNS server.

### For Office Static IP:
- `<OFFICE_STATIC_IP>`: Your Office static IP address.
- `<OFFICE_SUBNET_MASK>`: Your Office subnet mask.
- `<OFFICE_GATEWAY>`: Your Office default gateway.
- `<OFFICE_DNS_SERVER>`: Your Office DNS server.

---

## Project Structure

```plaintext
.
├── LICENSE           #The MIT Licensing
├── README.md           # This documentation file
└── sabnetwork_config.bat  # Main batch script for network configuration
```

## License

This project is licensed under the MIT License.

## Disclaimer

This script is provided "as-is" without any warranty. Use it at your own risk—the author is not responsible for any network disruptions or issues that may arise from using this script.
