# Fictional RouterOS 7 lab adaptation of a distribution-switch pattern.
# Empty lab device; ether1=upstream DHCP-server side, ether2=downstream trunk.
# ether3=endpoint. Other switches must have higher RSTP bridge priorities.
/system identity
set name=LAB-DISTRIBUTION
/interface bridge
add name=br-lab protocol-mode=rstp priority=0x1000 dhcp-snooping=yes vlan-filtering=no
/interface bridge port
add bridge=br-lab interface=ether1 trusted=yes ingress-filtering=yes frame-types=admit-only-vlan-tagged
add bridge=br-lab interface=ether2 ingress-filtering=yes frame-types=admit-only-vlan-tagged
add bridge=br-lab interface=ether3 pvid=120 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged edge=yes bpdu-guard=yes
/interface bridge vlan
add bridge=br-lab vlan-ids=110 tagged=br-lab,ether1,ether2
add bridge=br-lab vlan-ids=120 tagged=ether1,ether2 untagged=ether3
add bridge=br-lab vlan-ids=130 tagged=ether1,ether2
/interface vlan
add name=lab-management interface=br-lab vlan-id=110
/ip address
add address=192.0.2.3/28 interface=lab-management
/ip route
add dst-address=0.0.0.0/0 gateway=192.0.2.1
/ip service
set ssh address=192.0.2.0/28
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
set winbox address=192.0.2.0/28
/interface bridge
set [find name=br-lab] vlan-filtering=yes
