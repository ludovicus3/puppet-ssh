# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @param [Ssh::Pattern] host
# @param [Variant[Integer[0], String[1]]] order
# @param [Ssh::Settings] settings
# @param [Optional[String[1]]] user
#
# @example
#   ssh::client::host { 'namevar': }
define ssh::client::host (
  Ssh::Pattern $host = $title,
  Variant[Integer[0], String[1]] $order = '10',
  Ssh::Settings $settings,
  Optional[String[1]] $user = undef,
) {
  include 'ssh::client'

  if $user and defined(User[$user]) {
    $_requirements = User[$user]
  } else {
    $_requirements = []
  }

  $_target = $user ? {
    undef => $ssh::client::config_file,
    default => ssh::user_config_path($user),
  }

  if !defined(Concat[$_target]) {
    concat { $_target:
      ensure         => present,
      owner          => $user,
      mode           => '0640',
      warn           => true,
      show_diff      => true,
      ensure_newline => true,
      require        => $_requirements,
    }
  }

  $_content = ["host ${host}", ssh::format_settings($settings)].join("\n\t")

  concat::fragment { "${_target}::${title}":
    target  => $_target,
    content => $_content,
    order   => $order,
  }
}
