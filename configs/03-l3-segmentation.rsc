# Fictional RouterOS 7 lab adaptation of VLAN gateways and firewall boundaries.
# Empty router: ether1=tagged switch trunk; ether2=upstream lab firewall.
# Upstream firewall 198.51.100.1/30 needs a return route for 192.0.2.0/26
# via 198.51.100.2 and an explicitly configured lab DNS service.
# Assumes software routing; no L3 hardware offload is enabled here.
/system identity
set name=LAB-CORE
/interface bridge
add name=br-lab vlan-filtering=no protocol-mode=rstp
/interface bridge port
add bridge=br-lab interface=ether1 ingress-filtering=yes frame-types=admit-only-vlan-tagged
/interface bridge vlan
add bridge=br-lab vlan-ids=110,120,130 tagged=br-lab,ether1
/interface vlan
add name=lab-management interface=br-lab vlan-id=110
add name=lab-users interface=br-lab vlan-id=120
add name=lab-guests interface=br-lab vlan-id=130
/ip address
add address=192.0.2.1/28 interface=lab-management
add address=192.0.2.17/28 interface=lab-users
add address=192.0.2.33/28 interface=lab-guests
add address=198.51.100.2/30 interface=ether2
/ip route
add dst-address=0.0.0.0/0 gateway=198.51.100.1
/ip pool
add name=lab-user-pool ranges=192.0.2.18-192.0.2.30
add name=lab-guest-pool ranges=192.0.2.34-192.0.2.46
/ip dhcp-server
add name=lab-user-dhcp address-pool=lab-user-pool interface=lab-users disabled=no
add name=lab-guest-dhcp address-pool=lab-guest-pool interface=lab-guests disabled=no
/ip dhcp-server network
add address=192.0.2.16/28 gateway=192.0.2.17 dns-server=198.51.100.1
add address=192.0.2.32/28 gateway=192.0.2.33 dns-server=198.51.100.1
/ip firewall filter
add chain=input action=accept connection-state=established,related
add chain=input action=drop connection-state=invalid
add chain=input action=accept protocol=icmp
add chain=input action=accept in-interface=lab-management src-address=192.0.2.0/28
add chain=input action=accept in-interface=lab-users protocol=udp dst-port=67
add chain=input action=accept in-interface=lab-guests protocol=udp dst-port=67
add chain=input action=drop
add chain=forward action=accept connection-state=established,related
add chain=forward action=drop connection-state=invalid
add chain=forward action=accept in-interface=lab-management src-address=192.0.2.0/28
add chain=forward action=accept in-interface=lab-users src-address=192.0.2.16/28 out-interface=ether2
add chain=forward action=accept in-interface=lab-guests src-address=192.0.2.32/28 out-interface=ether2
add chain=forward action=drop
/ip service
set ssh address=192.0.2.0/28
set winbox address=192.0.2.0/28
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/interface bridge
set [find name=br-lab] vlan-filtering=yes
