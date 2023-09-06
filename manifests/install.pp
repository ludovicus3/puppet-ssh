# @api private
class ssh::install {
  if $ssh::manage_install {
    package { $ssh::package_names:
      ensure => $ssh::package_ensure,
    }
  }
}
