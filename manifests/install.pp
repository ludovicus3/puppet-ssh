# @api private
class ssh::install {
  if $ssh::manage_packages {
    ensure_packages($ssh::package_names, { ensure => $ssh::package_ensure })
  }
}
