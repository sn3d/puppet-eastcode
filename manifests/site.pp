node 'puppet.eastcode.sys'  {
  network::interface { 'enp0s3':
    enable_dhcp => true,
  }

  java::oracle{ 'jdk8':
    ensure => 'present',
    version => '8',
    java_se => 'jdk',
  }

  class { 'zookeeper':
    install_method => 'archive',
    archive_version => '3.4.11',
    service_provider => 'systemd',
    manage_service_file => true

  }
}

node 'agent1.eastcode.sys' {

  network::interface { 'enp0s3':
    enable_dhcp => true,
  }

  java::oracle{ 'jdk8':
    ensure => 'present',
    version => '8',
    java_se => 'jdk',
  }

  class { 'kafka':
    version => '0.11.0.2',
    scala_version => '2.12'
  }

  class { 'kafka::broker':
    config => {
      'broker.id' => '0',
      'zookeeper.connect' => '192.168.1.10:2181'
    }
  }

  kafka::topic {'eastcode_topic':
    ensure => 'present',
    zookeeper => '192.168.1.10:2181'
  }

}

node 'agent2.eastcode.sys' {
  network::interface { 'enp0s3':
    enable_dhcp => true,
  }

  java::oracle{ 'jdk8':
    ensure => 'present',
    version => '8',
    java_se => 'jdk',
  }

  class { 'kafka':
    version => '0.11.0.2',
    scala_version => '2.12'
  }
}
