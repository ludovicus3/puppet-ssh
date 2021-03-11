# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include ssh::server
class ssh::server (
  Boolean $manage_packages = true,
  Variant[Array[String], String] $package_names,
  String $package_ensure = present,

  Boolean $manage_config = true,
  Stdlib::Absolutepath $config_file = '/etc/ssh/sshd_config',
  Hash $settings = {},
  Hash $subsystems = {},
  Hash $matches = {},

  Boolean $manage_service = true,
  String $service_name,
  Stdlib::Ensure::Service $service_ensure = running,
  Boolean $service_enable = true,
) {
  contain 'ssh::server::install'
  contain 'ssh::server::config'
  contain 'ssh::server::service'

  Class['ssh::server::install']
  -> Class['ssh::server::config']
  ~> Class['ssh::server::service']
}
