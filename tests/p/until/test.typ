#import "/lib.typ": *
#import parsers: *


= match
#parse(until(string(regex("\w")), string("e")))[abcdefgh]

= match
#parse(until(string(regex("\w")), string(" ")))[abcd fgh]

= empty match
#parse(until(string(regex("\w")), string("a")))[abcdefgh]

= no match
#parse(until(string(regex("\w")), string(" ")))[abcd1fgh]

= no match (end)
#parse(until(string(regex("\w")), string(" ")))[abcd]
