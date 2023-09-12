# @summary Type to match a sshd config match
type Ssh::Server::Match::Filter = Struct[{
    Optional['user'] => Ssh::Patterns,
    Optional['group'] => Ssh::Patterns,
    Optional['host'] => Ssh::Patterns,
    Optional['localaddress'] => Ssh::Patterns,
    Optional['localport'] => Ssh::Patterns,
    Optional['address'] => Ssh::Patterns,
}]
