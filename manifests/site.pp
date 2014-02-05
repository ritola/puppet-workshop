node "app.vagrant.local" {
  class { "varnish_rhel":
    varnish_data_directory => "/var/lib/varnish",
    varnish_storage_size   => "10M",
    varnish_listen_port    => 80
  }
}
