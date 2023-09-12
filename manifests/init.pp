# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @param [Boolean] manage_install
# @param [Variant[Array[String[1], 1], String[1]]] package_names
# @param [Stdlib::Ensure::Package] package_ensure
# @param [Boolean] manage_ssh_config
# @param [Stdlib::Absolutepath] ssh_config_file
# @param [String] ssh_config_file_owner
# @param [String] ssh_config_file_group
# @param [Stdlib::Filemode] ssh_config_file_mode
# @param [Hash] ssh_hosts
# @param [Boolean] manage_sshd_config
# @param [Stdlib::Absolutepath] sshd_config_file
# @param [String] sshd_config_file_owner
# @param [String] sshd_config_file_group
# @param [Stdlib::Filemode] sshd_config_file_mode
# @param [Ssh::Settings] sshd_settings
# @param [Hash] sshd_subsystems
# @param [Hash] sshd_matches
# @param [Boolean] manage_service
# @param [Stdlib::Absolutepath] executable
# @param [String] service_name
# @param [Stdlib::Ensure::Service] service_ensure
# @param [Boolean] service_enable
#
# @example
#   include ssh
class ssh (
  Boolean $manage_install = true,
  Variant[Array[String[1], 1], String[1]] $package_names = 'openssh',
  Stdlib::Ensure::Package $package_ensure = installed,

  Boolean $manage_ssh_config = true,
  Stdlib::Absolutepath $ssh_config_file = '/etc/ssh/ssh_config',
  String $ssh_config_file_owner = 'root',
  String $ssh_config_file_group = 'root',
  Stdlib::Filemode $ssh_config_file_mode = '0644',
  Hash[String, Hash] $ssh_hosts = {
    '*' => {
      'order' => 99,
      'settings' => {
        'GSSAPIAuthentication' => true,
        'GSSAPIKeyExchange' => true,
        'GSSAPIDelegateCredentials' => true,
        'SendEnv' => 'LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE \
        LC_MEASUREMENT LC_IDENTIFICATION LC_ALL LANGUAGE XMODIFIERS',
      },
    },
  },

  Boolean $manage_sshd_config = true,
  Stdlib::Absolutepath $sshd_config_file = '/etc/ssh/sshd_config',
  String $sshd_config_file_owner = 'root',
  String $sshd_config_file_group = 'root',
  Stdlib::Filemode $sshd_config_file_mode = '0640',
  Ssh::Settings $sshd_settings = {},
  Hash[String, Hash] $sshd_subsystems = {
    'sftp' => {
      command => '/usr/libexec/openssh/sftp-server',
    },
  },
  Hash[String, Hash] $sshd_matches = {},

  Boolean $manage_service = true,
  Stdlib::Absolutepath $executable = '/usr/sbin/sshd',
  String $service_name = 'sshd',
  Stdlib::Ensure::Service $service_ensure = running,
  Boolean $service_enable = true,
) {
  contain 'ssh::install'

  class { 'ssh::client':
    manage_config     => $manage_ssh_config,
    config_file       => $ssh_config_file,
    config_file_owner => $ssh_config_file_owner,
    config_file_group => $ssh_config_file_group,
    config_file_mode  => $ssh_config_file_mode,
    hosts             => $ssh_hosts,
    require           => Class['ssh::install'],
  }

  class { 'ssh::server':
    manage_config     => $manage_sshd_config,
    config_file       => $sshd_config_file,
    config_file_owner => $sshd_config_file_owner,
    config_file_group => $sshd_config_file_group,
    config_file_mode  => $sshd_config_file_mode,
    settings          => $sshd_settings,
    subsystems        => $sshd_subsystems,
    matches           => $sshd_matches,
    manage_service    => $manage_service,
    executable        => $executable,
    service_name      => $service_name,
    service_ensure    => $service_ensure,
    service_enable    => $service_enable,
    require           => Class['ssh::install'],
  }
}
