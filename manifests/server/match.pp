# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @param [Hash] settings
#   Settings that should be applied to the match
#
# @param [String, Integer] order
#   Priority of the match, lowest goes first
#
# @param [Hash] filter
#   Hash of the filter settings
#
# @example
#   ssh::server::match { 'namevar': }
define ssh::server::match (
  Ssh::Settings $settings,
  Variant[Integer[1], String[1]] $order = 10,
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
