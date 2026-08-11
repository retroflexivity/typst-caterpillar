#import "/lib.typ": *
#import parsers: *


= match
#parse(end)[]

= no match
#parse(end)[test]

= no match
#parse(end)[_real_ test]
