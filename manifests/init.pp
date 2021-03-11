# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include ssh
class ssh (
  Boolean $manage_packages = true,
  Variant[Array[String], String] $package_names,
  String $package_ensure = present,
  # Client Settings
  Boolean $manage_clients = true,
  Boolean $clients_manage_packages = true,
  Variant[Array[String], String] $clients_package_names,
  String $clients_package_ensure = present,
  Boolean $clients_manage_config = true,
  Stdlib::Absolutepath $clients_config_file = '/etc/ssh/ssh_config',
  Hash $clients_hosts = {},
  Hash $clients_matches = {},
  # Server Settings
  Boolean $manage_server = true,
  Boolean $server_manage_packages = true,
  Variant[Array[String], String] $server_package_names,
  String $server_package_ensure = present,
  Boolean $server_manage_config = true,
  Stdlib::Absolutepath $server_config_file = '/etc/ssh/sshd_config',
  Hash $server_settings = {},
  Hash $server_subsystems = {},
  Hash $server_matches = {},
  Boolean $server_manage_service = true,
  String $server_service_name,
  Stdlib::Ensure::Service $server_service_ensure = running,
  Boolean $server_service_enable = true,
) {
  contain 'ssh::install'

  if $manage_clients {
    class { 'ssh::clients':
      manage_packages => $clients_manage_packages,
      package_names   => $clients_package_names,
      package_ensure  => $clients_package_ensure,
      manage_config   => $clients_manage_config,
      config_file     => $clients_config_file,
      hosts           => $clients_hosts,
      matches         => $clients_matches,
      require         => Class['ssh::install'],
    }
  }

  if $manage_server {
    class { 'ssh::server':
      manage_packages => $server_manage_packages,
      package_names   => $server_package_names,
      package_ensure  => $server_package_ensure,
      manage_config   => $server_manage_config,
      config_file     => $server_config_file,
      settings        => $server_settings,
      subsystems      => $server_subsystems,
      matches         => $server_matches,
      manage_service  => $server_manage_service,
      service_name    => $server_service_name,
      service_ensure  => $server_service_ensure,
      service_enable  => $server_service_enable,
      require         => Class['ssh::install'],
    }
  }
}
