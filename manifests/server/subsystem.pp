# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @param [String] subsystem
#
# @param [String] command
#
# @param [Array, String] arguments
#
# @example
#   ssh::server::subsystem { 'namevar': }
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
