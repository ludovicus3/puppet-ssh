# @api private
class ssh::client (
  Boolean $manage_config,
  Stdlib::Absolutepath $config_file,
  String $config_file_owner,
  String $config_file_group,
  Stdlib::Filemode $config_file_mode,
  Hash[String, Hash] $hosts,
) {
  if $manage_config {
    if $ssh::manage_install {
      $_requirements = Package[$ssh::package_names]
    } else {
      $_requirements = []
    }

    concat { $config_file:
      ensure         => present,
      owner          => $config_file_owner,
      group          => $config_file_group,
      mode           => $config_file_mode,
      warn           => true,
      show_diff      => true,
      ensure_newline => true,
      require        => $_requirements,
    }

    create_resources('ssh::client::host', $hosts)
  }
}
