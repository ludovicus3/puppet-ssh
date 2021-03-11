# @api private
class ssh::clients::config {
  if $ssh::clients::manage_config {
    ensure_resources('ssh::clients::hosts', $ssh::clients::hosts)
    ensure_resources('ssh::clients::matches', $ssh::clients::matches)
  }
}
