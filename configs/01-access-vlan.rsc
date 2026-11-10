# Fictional RouterOS 7 lab adaptation of an access-switch pattern.
# Empty lab device; ether1=trunk, ether2=user, ether3=guest.
# Management gateway 192.0.2.1/28 must exist upstream. Console required.
/system identity
set name=LAB-ACCESS
/interface bridge
add name=br-lab protocol-mode=rstp vlan-filtering=no
/interface bridge port
add bridge=br-lab interface=ether1 ingress-filtering=yes frame-types=admit-only-vlan-tagged
add bridge=br-lab interface=ether2 pvid=120 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged edge=yes bpdu-guard=yes
add bridge=br-lab interface=ether3 pvid=130 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged edge=yes bpdu-guard=yes
/interface bridge vlan
add bridge=br-lab vlan-ids=110 tagged=br-lab,ether1
add bridge=br-lab vlan-ids=120 tagged=ether1 untagged=ether2
add bridge=br-lab vlan-ids=130 tagged=ether1 untagged=ether3
/interface vlan
add name=lab-management interface=br-lab vlan-id=110
/ip address
add address=192.0.2.2/28 interface=lab-management
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
