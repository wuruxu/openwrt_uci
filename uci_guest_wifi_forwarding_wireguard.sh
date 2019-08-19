#!/bin/sh
uci batch << EOF

set wireless.radio0.disabled='0'

set wireless.wl0=wifi-iface
set wireless.wl0.device='radio0'
set wireless.wl0.network='lan'
set wireless.wl0.mode='ap'
set wireless.wl0.ssid='wuruxu'
set wireless.wl0.encryption='psk2+tkip+aes'
set wireless.wl0.key='******'

set wireless.wgwifi=wifi-iface
set wireless.wgwifi.device='radio0'
set wireless.wgwifi.mode='ap'
set wireless.wgwifi.network='wgwifi'
set wireless.wgwifi.ssid='wuruxu_WG'
set wireless.wgwifi.encryption='psk2+tkip+aes'
set wireless.wgwifi.key='******'
set wireless.wgwifi.isolate='0'

set network.wgwifi=interface
set network.wgwifi.proto='static'
set network.wgwifi.netmask='255.255.255.0'
set network.wgwifi.ipaddr='192.168.18.1'

set network.@rule[-1]=rule
set network.@rule[-1].src='192.168.18.0/24'
set network.@rule[-1].lookup='100'
set network.@rule[-1].priority='2'

set dhcp.wgwifi_dns=dnsmasq
set dhcp.wgwifi_dns.domainneeded='1'
set dhcp.wgwifi_dns.boguspriv='1'
set dhcp.wgwifi_dns.filterwin2k='0'
set dhcp.wgwifi_dns.localise_queries='1'
set dhcp.wgwifi_dns.rebind_protection='1'
set dhcp.wgwifi_dns.rebind_localhost='1'
set dhcp.wgwifi_dns.local='/wgwifi/'
set dhcp.wgwifi_dns.domain='wgwifi'
set dhcp.wgwifi_dns.expandhosts='1'
set dhcp.wgwifi_dns.nonegcache='0'
set dhcp.wgwifi_dns.authoritative='1'
set dhcp.wgwifi_dns.readethers='1'
set dhcp.wgwifi_dns.leasefile='/tmp/dhcp.leases.wgwifi'
set dhcp.wgwifi_dns.resolvfile='/tmp/resolv.conf.wgwifi'
set dhcp.wgwifi_dns.nonwildcard='1'
add_list dhcp.wgwifi_dns.interface='wgwifi'
add_list dhcp.wgwifi_dns.notinterface='loopback' 'lan' 'wglan'
set dhcp.wgwifi=dhcp
set dhcp.wgwifi.instance='wgwifi_dns'
set dhcp.wgwifi.interface='wgwifi'
set dhcp.wgwifi.start='50'
set dhcp.wgwifi.lhmit='150'
set dhcp.wgwifi.leasetime='24h'
add_list dhcp.wgwifi.dhcp_option='6,8.8.8.8,1.1.1.1' '3,192.168.18.1'

set firewall.@zone[-1]=zone
set firewall.@zone[-1].name='wgwifi'
set firewall.@zone[-1].network='wgwifi'
set firewall.@zone[-1].input='ACCEPT'
set firewall.@zone[-1].output='ACCEPT'
set firewall.@zone[-1].forward='ACCEPT'

set firewall.@forwarding[-1]=forwarding
set firewall.@forwarding[-1].src='wgwifi'
set firewall.@forwarding[-1].dest='wireguard'

EOF
