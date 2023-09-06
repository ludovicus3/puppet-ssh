# @api private
class ssh::server::service {
  assert_private()

  if $ssh::server::manage_service {
    if $ssh::manage_install {
      $_notifiers = Package[$ssh::package_names]
    } else {
      $_notifiers = []
    }

    service { $ssh::server::service_name:
      ensure    => $ssh::server::service_ensure,
      enable    => $ssh::server::service_enable,
      subscribe => $_notifiers,
    }
  }
}
