# @summary Type to match a subsystem command
type Ssh::Server::Subsystem::Command = Variant[
  Enum['sftp-server'],
  Stdlib::Absolutepath,
]
