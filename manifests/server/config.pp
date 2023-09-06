# @api private
class ssh::server::config {
  assert_private()

  if $ssh::server::manage_config {
    if $ssh::manage_install {
      $_requirements = Package[$ssh::package_names]
    } else {
      $_requirements = []
    }

    if $ssh::server::manage_service {
      $_subscribers = Service[$ssh::server::service_name]
    } else {
      $_subscribers = []
    }

    concat { $ssh::server::config_file:
      ensure         => present,
      owner          => $ssh::server::config_file_owner,
      group          => $ssh::server::config_file_group,
      mode           => $ssh::server::config_file_mode,
      warn           => true,
      show_diff      => true,
      ensure_newline => true,
      require        => $_requirements,
    }

    exec { 'ssh::server::config::test':
      command     => [$ssh::server::executable, '-t', '-f', $ssh::server::config_file],
      subscribe   => Concat[$ssh::server::config_file],
      refreshonly => true,
      notify      => $_subscribers,
    }

    concat::fragment { 'ssh::server::global':
      target  => $ssh::server::config_file,
      content => ssh::format_settings($ssh::server::settings).join("\n"),
      order   => '1',
    }

    create_resources('ssh::server::subsystem', $ssh::server::subsystems)

    create_resources('ssh::server::match', $ssh::server::matches)
  }
}
