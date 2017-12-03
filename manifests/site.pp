node 'pi.eastcode.sys' {

  include dns::server

  dns::server::options { '/etc/bind/named.conf.options':
    forwarders => [ '8.8.8.8', '8.8.4.4' ]
  }

  dns::zone { 'eastcode.sys':
    soa         => 'ns1.eastcode.sys',
    soa_email   => 'admin.eastcode.sys',
    nameservers => ['ns1']
  }

  dns::zone { '2.168.192.IN-ADDR.ARPA':
    soa         => 'ns1.eastcode.sys',
    soa_email   => 'admin.eastcode.sys',
    nameservers => ['ns1']
  }

  dns::record::a { 'puppet':
    zone => 'eastcode.sys',
    data => ['192.168.2.1']
  }

  dns::record::a { 'agent1':
    zone => 'eastcode.sys',
    data => ['192.168.2.2']
  }

  dns::record::a { 'agent2':
    zone => 'eastcode.sys',
    data => ['192.168.2.3']
  }

  dns::record::a { 'pi':
    zone => 'eastcode.sys',
    data => ['192.168.2.4']
  }

  dns::record::cname { 'www':
    zone => 'eastcode.sys',
    data => 'agent1.eastcode.sys'
  }

  $dhcpd_netmask             = '255.255.0.0'
  $dhcpd_subnet              = '192.168.0.0'
  $dhcpd_routers             = '192.168.0.1'
  $dhcpd_domain_name_servers = '192.168.2.4,192.168.0.1'
  $dhcpd_range_start         = '1'
  $dhcpd_range_end           = '254'
  $dhcpd_default_lease_time  = '3600'
  $dhcpd_max_lease_time      = '21600'

  class { '::dhcpd':
    configcontent => template('dhcpd/dhcpd.conf-simple.erb'),
    ensure        => 'running',
  }

}
