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


  tomcat7_rhel::tomcat_application { "my-web-application":
    application_root => "/opt",
    tomcat_user => "java",
    tomcat_port => "8080",
    jvm_envs => "-server -Xmx1024m -Xms128m -XX:MaxPermSize=256m -Dmy.java.opt=i_love_java -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=some.ip.address",
    tomcat_manager => true,
    tomcat_admin_user => "superuser",
    tomcat_admin_password => "secretpassword",
    smoke_test_path => "/health-check",
    jmx_registry_port => 10000,
    jmx_server_port => 10001,
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
