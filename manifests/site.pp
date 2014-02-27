node "app.vagrant.local" {
  class { "varnish_rhel":
    varnish_data_directory => "/var/lib/varnish",
    varnish_storage_size   => "10M",
    varnish_listen_port    => 80
  }

  user { "java":
  	comment => "Java User",
  	home => "/home/java",
  	ensure => present,
  }

  tomcat7_rhel::tomcat_application { "example-servlet":
    application_root => "/opt",
    tomcat_user => "java",
    tomcat_port => "8080",
    jvm_envs => "-server -Xmx1024m -XX:MaxPermSize=64m -Driak_ip=10.10.10.11",
    tomcat_manager => true,
    tomcat_admin_user => "java",
    tomcat_admin_password => "secretpassword",
    smoke_test_path => "/health-check",
    require => User["java"]
  }
}

node "riak1.vagrant.local", "riak2.vagrant.local", "riak3.vagrant.local" {
  if $::fqdn == "riak1.vagrant.local" {
    class { "riak": riak_control => true}
  } else {
    class { "riak": join_ip => "10.10.10.11" }
  }
}
