node 'puppet.eastcode.sys' {

  network::interface { 'eth0':
    ipaddress => '192.168.2.4',
    netmask   => '255.255.0.0',
    gateway   => '192.168.0.1'
  }

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

  class { 'dhcp':
    interfaces   => ['eth0']
  }

  dhcp::pool{ 'dc1.eastcode.sys':
    network     => '192.168.2.0',
    mask        => '255.255.0.0',
    range       => '192.168.2.10 192.168.2.200',
    gateway     => '192.168.2.1',
    nameservers => ['192.168.2.1', '192.168.0.1']
  }

}
