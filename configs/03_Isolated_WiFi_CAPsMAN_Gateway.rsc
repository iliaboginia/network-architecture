# 2026-07-21 15:48:23 by RouterOS 7.21.4
# software id = DAQX-50PQ
#
# model = RBcAPGi-5acD2nD
# serial number = DD340EC83619
/caps-man channel
add band=2ghz-g/n control-channel-width=20mhz extension-channel=disabled \
    frequency=2412,2437,2462 name=channels-2.4hz tx-power=20
add band=5ghz-n/ac control-channel-width=20mhz extension-channel=XX \
    frequency=5180,5220,5260,5300,5500,5540,5580 name=channels-5ghz tx-power=\
    20
/interface bridge
add admin-mac=2C:C8:1B:9B:E6:E5 auto-mac=no ingress-filtering=no name=\
    bridgeMain port-cost-mode=short vlan-filtering=yes
/interface wireless
# managed by CAPsMAN
# channel: 2412/20/gn(18dBm), SSID: Cniimf 2.4, local forwarding
set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=20/40mhz-XX \
    disabled=no distance=indoors frequency=auto installation=indoor mode=\
    ap-bridge ssid=MikroTik-9BE6E6 wireless-protocol=802.11
# managed by CAPsMAN
# channel: 5260/20-Ce/ac/DP(17dBm), SSID: Cniimf 5, local forwarding
set [ find default-name=wlan2 ] band=5ghz-a/n/ac channel-width=\
    20/40/80mhz-XXXX disabled=no distance=indoors frequency=auto \
    installation=indoor mode=ap-bridge ssid=MikroTik-9BE6E7 \
    wireless-protocol=802.11
/interface vlan
add interface=bridgeMain name=mgmt_network vlan-id=251
/caps-man datapath
add bridge=bridgeMain client-to-client-forwarding=yes name=datapath1
/caps-man security
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    name=security1
/caps-man configuration
add channel=channels-2.4hz channel.tx-power=20 country=russia datapath=\
    datapath1 datapath.local-forwarding=yes mode=ap name=cfg2 security=\
    security1 ssid="Cniimf 2.4"
add channel=channels-5ghz country=russia datapath=datapath1 \
    datapath.local-forwarding=yes mode=ap name=cfg5 security=security1 ssid=\
    "Cniimf 5"
add channel=channels-2.4hz channel.tx-power=20 datapath=datapath1 \
    datapath.local-forwarding=yes mode=ap name=cfg2_no_country security=\
    security1 ssid="Cniimf 2.4"
add channel=channels-5ghz datapath=datapath1 datapath.local-forwarding=yes \
    mode=ap name=cfg5_no_country security=security1 ssid="Cniimf 5"
/interface list
add name=WAN
add name=LAN
/interface lte apn
set [ find default=yes ] ip-type=ipv4 use-network-apn=no
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp ranges=192.168.88.130-192.168.88.254
add name=vpn ranges=192.168.89.2-192.168.89.255
/ip dhcp-server
add address-pool=dhcp interface=bridgeMain lease-time=10m name=dhcpMain
/ppp profile
set *FFFFFFFE local-address=192.168.89.1 remote-address=vpn
/queue simple
add comment="Unlimited for CAP1" max-limit=100M/100M name=Cap1_Unlimited \
    target=cap1
add comment="5Mbps for everything else" disabled=yes max-limit=5M/5M name=\
    Global_5M_Limit target=bridgeMain
/queue type
add kind=pcq name=50-down pcq-classifier=dst-address pcq-rate=50M
add kind=pcq name=50-up pcq-classifier=src-address pcq-rate=50M
add kind=pcq name=5-down pcq-classifier=dst-address pcq-dst-address-mask=24 \
    pcq-rate=5M pcq-src-address-mask=24
add kind=pcq name=5-up pcq-classifier=src-address pcq-dst-address-mask=24 \
    pcq-rate=5M pcq-src-address-mask=24
/caps-man manager
set enabled=yes
/caps-man manager interface
add forbid=yes interface=ether1
/caps-man provisioning
add action=create-dynamic-enabled master-configuration=cfg2_no_country \
    radio-mac=DC:2C:6E:29:AD:08
add action=create-dynamic-enabled master-configuration=cfg5_no_country \
    radio-mac=DC:2C:6E:29:AD:09
add action=create-dynamic-enabled master-configuration=cfg2_no_country \
    radio-mac=DC:2C:6E:27:3C:1D
add action=create-dynamic-enabled master-configuration=cfg5_no_country \
    radio-mac=DC:2C:6E:27:3C:1E
add action=create-dynamic-enabled master-configuration=cfg2_no_country \
    radio-mac=DC:2C:6E:27:3C:97
add action=create-dynamic-enabled master-configuration=cfg5_no_country \
    radio-mac=DC:2C:6E:27:3C:98
add action=create-dynamic-enabled hw-supported-modes=an master-configuration=\
    cfg5
add action=create-dynamic-enabled hw-supported-modes=gn master-configuration=\
    cfg2
/interface bridge port
add bridge=bridgeMain ingress-filtering=no interface=ether2 \
    internal-path-cost=10 path-cost=10
/ip firewall connection tracking
set udp-timeout=10s
/ip neighbor discovery-settings
set discover-interface-list=all
/ip settings
set max-neighbor-entries=8192
/ipv6 settings
set disable-ipv6=yes max-neighbor-entries=8192
/interface bridge vlan
add bridge=bridgeMain tagged=ether2,bridgeMain vlan-ids=251
/interface l2tp-server server
set enabled=yes use-ipsec=yes
/interface list member
add interface=bridgeMain list=LAN
add interface=ether1 list=WAN
add interface=mgmt_network list=LAN
add interface=ether2 list=LAN
/interface ovpn-server server
add auth=sha1,md5 mac-address=FE:AF:74:99:A8:FF name=ovpn-server1
/interface sstp-server server
set default-profile=default-encryption
/interface wifi cap
set discovery-interfaces=bridgeMain enabled=yes
/interface wifi capsman
set interfaces=bridgeMain package-path="" require-peer-certificate=no \
    upgrade-policy=none
/interface wireless cap
# 
set bridge=bridgeMain discovery-interfaces=bridgeMain enabled=yes interfaces=\
    wlan1,wlan2
/ip address
add address=192.168.88.1/24 interface=bridgeMain network=192.168.88.0
add address=/27 interface=ether1 network=XXX.XXX.XXX.XXX
add address=10.251.1.88/24 interface=mgmt_network network=10.251.1.0
/ip cloud
set ddns-enabled=yes
/ip dhcp-server network
add address=192.168.88.0/24 gateway=192.168.88.1
/ip dns
set servers=XXX.XXX.XXX.XXX,XXX.XXX.XXX.XXX
/ip dns static
add address=192.168.88.1 name=router.lan type=A
/ip firewall address-list
add address=XXX.XXX.XXX.XXX comment="Company addresses" list=corp_addresses
add address=XXX.XXX.XXX.XXX comment="Company addresses" list=corp_addresses
add address=XXX.XXX.XXX.XXX comment="Company addresses" list=corp_addresses
add address=XXX.XXX.XXX.XXX comment="Company addresses" list=corp_addresses
add address=XXX.XXX.XXX.XXX comment="Company addresses" list=corp_addresses
add address=XXX.XXX.XXX.XXX comment="Company addresses" list=corp_addresses
add address=XXX.XXX.XXX.XXX comment="Company addresses" list=corp_addresses
add address=XXX.XXX.XXX.XXX comment="Company addresses" list=corp_addresses
add address=XXX.XXX.XXX.XXX comment="Company addresses" list=corp_addresses
add address=XXX.XXX.XXX.XXX comment="Company addresses" list=corp_addresses
/ip firewall filter
add action=drop chain=input connection-state=new dst-address=XXX.XXX.XXX.XXX \
    dst-port=53 protocol=tcp
add action=drop chain=input connection-state=new dst-address=XXX.XXX.XXX.XXX \
    dst-port=53 protocol=udp
add action=accept chain=input comment=UnblockCapsman dst-address-type=local \
    src-address-type=local
add action=accept chain=input comment="accept established,related,untracked" \
    connection-state=established,related,untracked
add action=accept chain=input comment="allow IPsec NAT" dst-port=4500 \
    protocol=udp
add action=accept chain=input comment="allow IKE" dst-port=500 protocol=udp
add action=accept chain=input comment="allow l2tp" dst-port=1701 protocol=udp
add action=accept chain=input comment="allow sstp" dst-port=443 protocol=tcp
add action=drop chain=input comment="drop invalid" connection-state=invalid
add action=accept chain=input comment="accept ICMP" protocol=icmp
add action=accept chain=input comment=\
    "accept to local loopback (for CAPsMAN)" dst-address=127.0.0.1
add action=accept chain=input comment="Access INPUT-out from corp addresses" \
    in-interface=ether1 src-address-list=corp_addresses
add action=drop chain=input comment="drop all not coming from LAN" \
    in-interface-list=!LAN
add action=accept chain=forward comment="accept in ipsec policy" \
    ipsec-policy=in,ipsec
add action=accept chain=forward comment="accept out ipsec policy" \
    ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment=fasttrack \
    connection-state=established,related
add action=accept chain=forward comment=\
    "accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="drop invalid" connection-state=invalid
add action=drop chain=forward comment="Drop all from WAN not DSTNATed" \
    connection-nat-state=!dstnat connection-state=new in-interface-list=WAN
/ip firewall nat
add action=src-nat chain=srcnat comment="NAT for WAN" ipsec-policy=out,none \
    out-interface=ether1 out-interface-list=WAN to-addresses=XXX.XXX.XXX.XXX
add action=masquerade chain=srcnat comment="masq. vpn traffic" src-address=\
    192.168.89.0/24
/ip ipsec profile
set [ find default=yes ] dpd-interval=2m dpd-maximum-failures=5
/ip route
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=XXX.XXX.XXX.XXX \
    routing-table=main scope=30 target-scope=10
add disabled=no dst-address=192.168.0.0/23 gateway=10.251.1.1 routing-table=\
    main
add disabled=no distance=1 dst-address=192.168.11.0/24 gateway=10.251.1.1 \
    routing-table=main scope=30 target-scope=10
/ip service
set ftp disabled=yes
set telnet disabled=yes
set www disabled=yes
set ssh port=2077
set api disabled=yes
set api-ssl disabled=yes
set winbox port=9291
/ipv6 nd
set [ find default=yes ] advertise-dns=yes
/ppp secret
add name=vpn
add name=BIKshiprouter service=l2tp
/system clock
set time-zone-name=Europe/Moscow
/system identity
set name=AP-5-3
/system package update
set channel=long-term
/system routerboard mode-button
set enabled=yes on-event=dark-mode
/system script
add dont-require-permissions=no name=dark-mode owner=Admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="\
    \n   :if ([system leds settings get all-leds-off] = \"never\") do={\
    \n     /system leds settings set all-leds-off=immediate \
    \n   } else={\
    \n     /system leds settings set all-leds-off=never \
    \n   }\
    \n "
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
/tool sniffer
set filter-interface=all filter-src-ip-address=192.168.1.97/32
