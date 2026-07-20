# Enterprise Campus Network Architecture (Baseline)

A reference L2/L3 network architecture designed for an office building/campus environment. This project demonstrates a structured approach to network segmentation, wireless management, and perimeter security using a combination of MikroTik and OPNsense hardware.

## 🏗️ Architecture Overview
The network is built on a classic multi-tier model (Core, Distribution, Access) focusing on isolation, performance, and scalability.

**Key Features:**
*   **Perimeter Security:** OPNsense acts as the Next-Generation Firewall (NGFW), handling internet gateways, NAT, and external threat mitigation.
*   **L2/L3 Segmentation:** Strict VLAN segregation separates User traffic, Management interfaces, Guest Wi-Fi, and Third-party Tenants.
*   **Centralized Wireless:** MikroTik CAPsMAN is deployed to centrally provision and manage access points across the facility.
*   **Hardware Efficiency:** Architecture relies on MikroTik CRS3xx series switches (CRS354/CRS317), utilizing L3 Hardware Offloading for wire-speed inter-VLAN routing where applicable.

## 🗺️ Network Topologies
All diagrams were created using draw.io. Source XML files and high-resolution images are available in the `/diagrams` folder.

### 1. High-Level Core Architecture
*(Logical separation between ISPs, NGFW, and Core/Distribution layers)*
![High Level Diagram](./diagram/svg/high-level-diagram.drawio.svg)

### 2. Core Routing & VLANs
*(IP addressing schema, L3 Transit links, and VLAN gateways)*
![Core Network](./diagram/svg/core-network.drawio.svg)

### 3. Access Layer & Wireless
*(Physical port allocations, CAPsMAN management, and isolated Guest networks)*
![Floor Network](./diagram/svg/floor-network.drawio.svg)
![Wireless Network](./diagram/svg/wifi-network.drawio.svg)

## ⚙️ Baseline Configurations
Sanitized configuration snippets are provided in the `/configs` directory to demonstrate implementation details:
*   `core-router-baseline.rsc` - Base interfaces and static routing logic.
*   `access-switch-vlan.rsc` - Bridge VLAN filtering setup.
*   `capsman-controller.rsc` - Wireless provisioning rules and datapath isolation.
