# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @param [String] host
# @param [Integer, String] order
# @param [Hash] settings
# @param [String] user
#
# @example
#   ssh::client::host { 'namevar': }
define ssh::client::host (
  Ssh::Pattern $host = $title,
  Variant[Integer, String[1]] $order = '10',
  Ssh::Settings $settings,
  Optional[String] $user = undef,
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
