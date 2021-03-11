# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include ssh::client
class ssh::clients (
  Boolean $manage_packages = true,
  Variant[Array[String], String] $package_names,
  String $package_ensure = present,

  Boolean $manage_config = true,
  Stdlib::Absolutepath $config_file = '/etc/ssh/ssh_config',
  Hash $hosts = {},
  Hash $matches = {},
) {
  contain 'ssh::clients::install'
  contain 'ssh::clients::config'

  Class['ssh::clients::install']
  -> Class['ssh::clients::config']
}
