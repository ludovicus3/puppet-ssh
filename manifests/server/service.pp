# @api private
class ssh::server::service {
  if $ssh::server::manage_service {
    service {$ssh::server::service_name:
      ensure => $ssh::server::service_ensure,
      enable => $ssh::server::service_enable,
    }
  }
}
