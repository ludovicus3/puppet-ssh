# @api private
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
