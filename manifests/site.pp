node 'pi.eastcode.sys' {

  ##############################################################################
  # DNS
  ##############################################################################

  include dns::server

  dns::server::options { '/etc/bind/named.conf.options':
    forwarders => [ '8.8.8.8', '8.8.4.4' ]
  }

  dns::zone { 'eastcode.sys':
    soa         => 'ns1.eastcode.sys',
    soa_email   => 'admin.eastcode.sys',
    nameservers => ['ns1']
  }

  dns::record::a { 'pi':
    zone => 'eastcode.sys',
    data => ['192.168.1.1']
  }

  dns::record::a { 'puppet':
    zone => 'eastcode.sys',
    data => ['192.168.1.10']
  }

  dns::record::a { 'agent1':
    zone => 'eastcode.sys',
    data => ['192.168.1.11']
  }

  dns::record::a { 'agent2':
    zone => 'eastcode.sys',
    data => ['192.168.1.12']
  }

  dns::record::cname { 'www':
    zone => 'eastcode.sys',
    data => 'agent1.eastcode.sys',
  }

  ##############################################################################
  # DHCP
  ############################################################################
  class { 'dhcp':
    interfaces   => ['eth0'],
    dnsdomain => ["eastcode.sys"]
  }

  dhcp::pool {  'eastcode.sys':
    network     => '192.168.1.0',
    mask        => '255.255.255.0',
    range       => '192.168.1.50 192.168.1.200',
    gateway     => '192.168.1.1',
    nameservers => ['192.168.1.1', '8.8.8.8']
  }

  dhcp::host {
    'puppet': mac => "08:00:27:6B:02:01", ip => "192.168.1.10";
    'agent1': mac => "08:00:27:6B:02:02", ip => "192.168.1.11";
    'agent2': mac => "08:00:27:6B:02:03", ip => "192.168.1.12";
  }
}
