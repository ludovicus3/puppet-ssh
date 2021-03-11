# @api private
class ssh::server::install {
  if $ssh::server::manage_packages {
    ensure_packages($ssh::server::package_names, { ensure => $ssh::server::package_ensure })
  }
}
