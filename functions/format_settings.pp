# See https://puppet.com/docs/puppet/latest/lang_write_functions_in_puppet.html
# for more information on native puppet functions.
function ssh::format_settings(
  Hash $settings
) >> Array[String] {
  $settings.map |$key, $value| {
    $value ? {
      Array => $value.map |$item| {
        "${key} ${String.new($item)}"
      },
      Boolean => "${key} ${String.new($value, '%y')}",
      default => "${key} ${String.new($value)}",
    }
  }.flatten
}
