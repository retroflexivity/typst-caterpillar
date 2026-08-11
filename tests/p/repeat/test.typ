#import "/lib.typ": *
#import parsers: *


= match
#parse(repeat(exact[>]))[>>>>  text]

= match
#parse(repeat(exact[>]))[>>>>text]

= match
#parse(repeat(exact[>], min: 4, max: 4))[>>>>text]

= limited match
#parse(repeat(exact[>], max: 3))[>>>>text]

= empty match
#parse(repeat(exact[>]))[text]

= no match (not enough)
#parse(repeat(exact[>], min: 5))[>>>>text]
