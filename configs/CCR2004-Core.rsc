/system identity
set name=CR-01

/system clock
set time-zone-name=Europe/Moscow

/interface bridge
add name=bridgeMain vlan-filtering=yes comment="Main Core L2 Bridge"

/interface ethernet
set [ find default-name=ether1 ] name=ether1-Transit-to-FW comment="L3 Transit to Firewall"
set [ find default-name=sfp-sfpplus1 ] name=sfp1-DIST-F1-01 comment="Trunk to Distribution Switch 1"
set [ find default-name=sfp-sfpplus2 ] name=sfp2-DIST-F2-01 comment="Trunk to Distribution Switch 2"
set [ find default-name=sfp-sfpplus3 ] name=sfp3-C2 comment="L3 Point-to-Point Site C2"
set [ find default-name=sfp-sfpplus4 ] name=sfp4-L1 comment="L3 Point-to-Point Site L1"
set [ find default-name=sfp-sfpplus5 ] name=sfp5-SRV-BCKP comment="Backup Server Link 1"


/interface bridge port
add bridge=bridgeMain interface=sfp1-DIST-F1-01
add bridge=bridgeMain interface=sfp2-DIST-F2-01
add bridge=bridgeMain interface=sfp5-SRV-BCKP


/interface vlan
add interface=bridgeMain name=vlan2 vlan-id=2
add interface=bridgeMain name=vlan3 vlan-id=3
add interface=bridgeMain name=vlan4 vlan-id=4
add interface=bridgeMain name=vlan5 vlan-id=5
add interface=bridgeMain name=vlan6 vlan-id=6
add interface=bridgeMain name=vlan7 vlan-id=7
add interface=bridgeMain name=vlan8 vlan-id=8
add interface=bridgeMain name=vlan9 vlan-id=9
add interface=bridgeMain name=vlan10 vlan-id=10
add interface=bridgeMain name=vlan11 vlan-id=11
add interface=bridgeMain name=vlan13 vlan-id=13
add interface=bridgeMain name=vlan15 vlan-id=15
add interface=bridgeMain name=vlan16 vlan-id=16
add interface=bridgeMain name=vlan19 vlan-id=19
add interface=bridgeMain name=vlan77 vlan-id=77
add interface=bridgeMain name=vlan78 vlan-id=78
add interface=bridgeMain name=vlan251 vlan-id=251

/ip address
add address=10.10.10.2/24 interface=ether1-Transit-to-FW network=10.10.10.0 comment="Transit to Firewall"
add address=192.168.3.248/24 interface=sfp3-C2 network=192.168.3.0 comment="Site C2 Gateway"
add address=192.168.4.1/24 interface=sfp4-L1 network=192.168.4.0 comment="Site L1 Gateway"
add address=192.168.0.252/23 interface=bridgeMain network=192.168.0.0 comment="Legacy Gateway 1"
add address=192.168.0.10/23 interface=bridgeMain network=192.168.0.0 comment="Legacy Gateway 2"
add address=10.251.1.1/24 interface=vlan251
add address=192.168.7.2/24 interface=vlan10
add address=192.168.8.1/24 interface=vlan7
add address=192.168.10.1/24 interface=vlan5
add address=192.168.11.27/24 interface=vlan11
add address=192.168.15.1/24 interface=vlan15
add address=192.168.16.1/24 interface=vlan19
add address=192.168.50.2/24 interface=vlan9
add address=192.168.88.254/24 interface=vlan77

/ip route
add dst-address=0.0.0.0/0 gateway=10.10.10.1 comment="Default Route to Firewall"
add dst-address=172.16.1.0/24 gateway=192.168.0.3 comment="WireGuard VPN Subnet"
add dst-address=192.168.3.0/24 gateway=192.168.3.250 comment="Route to Site C2"
add dst-address=192.168.79.0/24 gateway=192.168.3.250 comment="Route to Site C2 (VLAN 79)"
add dst-address=192.168.4.0/24 gateway=192.168.4.28 comment="Route to Site L1"
add dst-address=192.168.26.0/24 gateway=192.168.4.28 comment="Route to Site L1 (VLAN 26)"

/caps-man channel
add band=2ghz-g/n control-channel-width=20mhz extension-channel=disabled frequency=2412,2437,2462 name=channels-2.4hz tx-power=20
add band=5ghz-n/ac control-channel-width=20mhz frequency=5180,5220,5260,5300,5500,5540,5580 name=channels-5ghz tx-power=20

/caps-man datapath
add bridge=bridgeMain vlan-id=77 vlan-mode=use-tag local-forwarding=no client-to-client-forwarding=yes name=datapath-vlan77

/caps-man security
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm name=security1

/caps-man configuration
add channel=channels-2.4hz country=russia datapath=datapath-vlan77 mode=ap name=cfg2 security=security1 ssid="Cniimf 2.4"
add channel=channels-5ghz country=russia datapath=datapath-vlan77 mode=ap name=cfg5 security=security1 ssid="Cniimf 5"

/caps-man manager
set enabled=yes

/caps-man provisioning
add action=create-dynamic-enabled hw-supported-modes=an master-configuration=cfg5
add action=create-dynamic-enabled hw-supported-modes=gn master-configuration=cfg2

/ip pool
add name=pool-wifi ranges=192.168.88.10-192.168.88.200

/ip dhcp-server
add address-pool=pool-wifi interface=vlan77 name=dhcp-wifi disabled=no

/ip dhcp-server network
add address=192.168.88.0/24 dns-server=8.8.8.8,192.168.0.2 gateway=192.168.88.254

/ip firewall filter
add action=accept chain=input connection-state=established,related,untracked comment="Allow established, related, untracked"
add action=accept chain=input protocol=icmp comment="Allow ICMP"
add action=accept chain=input src-address=192.168.0.0/23 comment="Allow Management from Local LAN"
add action=drop chain=input in-interface=ether1-Transit-to-FW comment="Drop invalid input from Transit link"
