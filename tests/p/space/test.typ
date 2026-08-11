#import "/lib.typ": *
#import parsers: *


= content match
#parse(space)[ text]

= string match
#parse(multiple(([but], space)))[but why?]

= emph match
#parse(space)[_text_  text]

= no match
#parse(space)[but  why?]

= no match
#parse(space)[]
