# Independent fictional RouterOS 7 lab adaptation of source-based routing.
# Empty router: ether1=primary WAN, ether2=secondary WAN, ether3=lab LAN.
# All addresses are RFC 5737 examples. Upstream lab routers must be supplied.
# Gateway-only ping checks do not prove end-to-end Internet reachability.
/system identity
set name=LAB-EDGE
/ip address
add address=198.51.100.2/30 interface=ether1
add address=203.0.113.2/30 interface=ether2
add address=192.0.2.1/24 interface=ether3
/routing table
add name=lab-secondary fib
/ip route
add dst-address=0.0.0.0/0 gateway=198.51.100.1 distance=1 check-gateway=ping
add dst-address=0.0.0.0/0 gateway=203.0.113.1 distance=2 check-gateway=ping
add dst-address=0.0.0.0/0 gateway=203.0.113.1@main routing-table=lab-secondary distance=1 check-gateway=ping
add dst-address=0.0.0.0/0 gateway=198.51.100.1@main routing-table=lab-secondary distance=2 check-gateway=ping
/routing rule
add dst-address=192.0.2.0/24 action=lookup-only-in-table table=main
add dst-address=198.51.100.0/30 action=lookup-only-in-table table=main
add dst-address=203.0.113.0/30 action=lookup-only-in-table table=main
add src-address=192.0.2.64/26 action=lookup-only-in-table table=lab-secondary
/ip firewall nat
add chain=srcnat src-address=192.0.2.0/24 out-interface=ether1 action=masquerade
add chain=srcnat src-address=192.0.2.0/24 out-interface=ether2 action=masquerade
/ip firewall filter
add chain=input action=accept connection-state=established,related
add chain=input action=drop connection-state=invalid
add chain=input action=accept protocol=icmp
add chain=input action=accept in-interface=ether3 src-address=192.0.2.0/26
add chain=input action=drop
add chain=forward action=accept connection-state=established,related
add chain=forward action=drop connection-state=invalid
add chain=forward action=accept in-interface=ether3 src-address=192.0.2.0/24 out-interface=ether1
add chain=forward action=accept in-interface=ether3 src-address=192.0.2.0/24 out-interface=ether2
add chain=forward action=drop
/ip service
set ssh address=192.0.2.0/26
set winbox address=192.0.2.0/26
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
