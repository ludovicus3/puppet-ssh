# @api private
class ssh::server (
  Boolean $manage_config,
  Stdlib::Absolutepath $config_file,
  Stdlib::Filemode $config_file_mode,
  String $config_file_owner,
  String $config_file_group,

  Ssh::Settings $settings,
  Hash $subsystems,
  Hash $matches,

  Boolean $manage_service,
  Stdlib::Absolutepath $executable,
  String $service_name,
  Stdlib::Ensure::Service $service_ensure,
  Boolean $service_enable,
) {
  contain 'ssh::server::config'
  contain 'ssh::server::service'

  Class['ssh::server::config']
  ~> Class['ssh::server::service']
}
