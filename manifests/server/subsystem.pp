# @summary Defines an external subsystem for the ssh server
#
# Configures an external subsystem (e.g. file transfer daemon). Arguments should
# be a subsystem name and a command (with optional arguments) to execute upon 
# subsystem request.
#
# The command sft-server implements the "sftp" file transfer subsystem.
#
# @param [String] subsystem
#   A name to identify the subsystem
#
# @param [Ssh::Server::Subsystem::Command] command
#   Command for the external subsystem
#
# @param [Optional[Variant[Array[String[1], 1], String[1]]]] arguments
#   Optional arguments for the subsystem
#
# @example
#   ssh::server::subsystem { 'sftp': 
#     command => 'sftp-system',
#   }
define ssh::server::subsystem (
  String $subsystem = $title,
  Ssh::Server::Subsystem::Command $command,
  Optional[Variant[Array[String[1], 1], String[1]]] $arguments = undef,
) {
  include 'ssh::server'

  if $ssh::server::manage_config {
    $_command = $arguments ? {
      Undef => [$command],
      Array => [$command] + $arguments,
      default => [$command, $arguments],
    }

    concat::fragment { "ssh::server::subsystem::${title}":
      target  => $ssh::server::config_file,
      content => "subsystem ${subsystem} ${_command.join(' ')}",
      order   => "2-${title}",
    }
  } else {
    fail("The sshd_config file is not being managed by Puppet. Cannot apply Ssh::Server::Subsystem[${title}].")
  }
}
