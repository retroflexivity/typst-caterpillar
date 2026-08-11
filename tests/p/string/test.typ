#import "/lib.typ": *
#import parsers: *

= string matched
#parse(string("a piece"))[a piece of text]

= regex matched
#parse(string(regex("\w+")))[a piece of text]

= no match
#parse(string("a piece"))[a _piece_ of text]

= no match
#parse(string(regex("\w+")))[_a_ piece of text]

