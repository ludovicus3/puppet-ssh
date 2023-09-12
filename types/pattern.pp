# @summary Type to match a pattern for host and matches
type Ssh::Pattern = Pattern[/\A!?((%[%CdhiLlnpru])|[^%[:space:]])+\Z/]
