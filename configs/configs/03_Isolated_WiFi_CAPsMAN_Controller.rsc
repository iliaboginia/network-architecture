# 2026-07-21 15:49:26 by RouterOS 7.21.4
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
/caps-man datapath
add bridge=bridgeMain client-to-client-forwarding=yes name=datapath1
/caps-man security
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm \
    name=security1
/caps-man configuration
add channel=channels-2.4hz channel.tx-power=20 country=russia datapath=\
    datapath1 datapath.local-forwarding=yes mode=ap name=cfg2 security=\
    security1 ssid="XXX 2.4"
add channel=channels-5ghz country=russia datapath=datapath1 \
    datapath.local-forwarding=yes mode=ap name=cfg5 security=security1 ssid=\
    "XXX 5"
add channel=channels-2.4hz channel.tx-power=20 datapath=datapath1 \
    datapath.local-forwarding=yes mode=ap name=cfg2_no_country security=\
    security1 ssid="XXX 2.4"
add channel=channels-5ghz datapath=datapath1 datapath.local-forwarding=yes \
    mode=ap name=cfg5_no_country security=security1 ssid="XXX 5"
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
