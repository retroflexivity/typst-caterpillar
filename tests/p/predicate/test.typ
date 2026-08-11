#import "/lib.typ": *
#import parsers: *

= text matched
#parse(predicate(it => it.has("text")))[a piece of text]

= emph matched
#parse(predicate(it => it.func() == emph))[_emphasis *with bold*_ and a piece of text]

= no match
#parse(predicate(it => it.func() == emph))[not _emphasis_ at all!]

= no match
#parse(predicate(it => it.func() == emph))[]

= no match
#parse(predicate(it => it.func() == emph))[text]

