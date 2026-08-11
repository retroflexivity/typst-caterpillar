#import "/lib.typ": *
#import parsers: *


= match
#parse(optional(exact[this]))[this _text_ is a test]

= empty match
#parse(optional(exact[this]))[_this_ text is a test]
