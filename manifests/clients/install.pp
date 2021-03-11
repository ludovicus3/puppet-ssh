# @api private
class ssh::clients::install {
  if $ssh::clients::manage_packages {
    ensure_packages($ssh::clients::package_names, { ensure => $ssh::clients::package_ensure })
  }
}
