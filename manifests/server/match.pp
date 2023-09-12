# @summary Configures conditional settings for the ssh server
#
# Introduces a conditional block. If all the criteria of the match are satisfied, the
# settings override those set in the global section of the config file.
#
# The arguments to match are one or more criteria-pattern pairs. The criteria are user,
# group, host, and address. The patterns may consist of single entries or and array of entries.
#
# @param [Ssh::Settings] settings
#   Settings that should be applied to the match
#
# @param [Variant[Integer[0], String[1]]] order
#   Priority of the match, lowest goes first
#
# @param [Optional[Ssh::Server::Match::Filter]] filter
#   Used to define a filter using a hash format. If not defined, the title is used as the match filter.
#
# @example
#   ssh::server::match { 'namevar': 
#     filter => {
#       user => 'test',
#     },
#     settings => {
#       banner => '/etc/issue.test'
#     },
#   }
define ssh::server::match (
  Ssh::Settings $settings,
  Variant[Integer[0], String[1]] $order = 10,
  Optional[Ssh::Server::Match::Filter] $filter = undef,
) {
  include 'ssh::server'

  if $ssh::server::manage_config {
    if $filter {
      $_match = $filter.reduce('') |$result, $kv| {
        $value = $kv[1] ? {
          Array => $kv[1].join(','),
          String => $kv[1],
        }

        "${result} ${kv[0]} ${value}"
      }
    } else {
      $_match = $title
    }

    $_content = $settings.reduce([$_match]) |$memo, $kv| {
      $next = $kv[1] ? {
        Array => $kv[1].map |$v| {
          "${$kv[0]} ${v}"
        },
        Boolean => "${kv[0]} ${String.new($kv[1], '%y')}",
        default => "${kv[0]} ${kv[1]}",
      }

      $memo + [$next]
    }.flatten.join("\n\t")

    concat::fragment { $_match:
      target  => $ssh::server::config_file,
      content => $_content,
      order   => "3-${order}-${title}",
    }
  } else {
    fail("The sshd_config file is not being managed by Puppet. Cannot apply Ssh::Server::Match[${title}].")
  }
}
