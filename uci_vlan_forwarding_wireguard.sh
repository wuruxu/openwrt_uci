#!/bin/sh
uci batch << EOF

set network.wglan=interface
set network.wglan.type='bridge'
set network.wglan.ifname='eth1.2'
set network.wglan.proto='static'
set network.wglan.netmask='255.255.255.0'
set network.wglan.ip6assign='60'
set network.wglan.ipaddr='192.168.28.1'

set network.@switch_vlan[0].ports='2 3 4 0t'
 
set network.@switch_vlan[-1]=switch_vlan
set network.@switch_vlan[-1].device='switch0'
set network.@switch_vlan[-1].vlan='2'
set network.@switch_vlan[-1].ports='1 0t'
 
set network.@rule[-1]=rule
set network.@rule[-1].src='192.168.28.0/24'
set network.@rule[-1].lookup='100'
set network.@rule[-1].priority='3'

commit network

set dhcp.wglan_dns=dnsmasq
set dhcp.wglan_dns.domainneeded='1'
set dhcp.wglan_dns.boguspriv='1'
set dhcp.wglan_dns.filterwin2k='0'
set dhcp.wglan_dns.localise_queries='1'
set dhcp.wglan_dns.rebind_protection='1'
set dhcp.wglan_dns.rebind_localhost='1'
set dhcp.wglan_dns.local='/wglan/'
set dhcp.wglan_dns.domain='wglan'
set dhcp.wglan_dns.expandhosts='1'
set dhcp.wglan_dns.nonegcache='0'
set dhcp.wglan_dns.authoritative='1'
set dhcp.wglan_dns.readethers='1'
set dhcp.wglan_dns.leasefile='/tmp/dhcp.leases.wglan'
set dhcp.wglan_dns.resolvfile='/tmp/rdsolv.conf.wglan'
set dhcp.wglan_dns.nonwildcard='1'
add_list dhcp.wglan_dns.interface='wglan'
add_list dhcp.wglan_dns.notinterface='loopback' 'lan' 'wgwifi'
set dhcp.wglan=dhcp
set dhcp.wglan.instance='wglan_dns'
set dhcp.wglan.interface='wglan'
set dhcp.wglan.start='50'
set dhcp.wglan.lhmit='150'
set dhcp.wglan.leasetime='24h'
add_list dhcp.wglan.dhcp_option='6,8.8.8.8,1.1.1.1' '3,192.168.28.1'

commit dhcp

set firewall.@zone[-1].name='wglan'
set firewall.@zone[-1].network='wglan'
set firewall.@zone[-1].input='ACCEPT'
set firewall.@zone[-1].output='ACCEPT'
set firewall.@zone[-1].forward='ACCEPT'

set firewall.@forwarding[-1]=forwarding
set firewall.@forwarding[-1].src='wglan'
set firewall.@forwarding[-1].dest='wireguard'

commit firewall

EOF
