# @summary Type to match a list of patterns
type Ssh::Patterns = Variant[
  Array[Ssh::Pattern],
  Ssh::Pattern,
]
