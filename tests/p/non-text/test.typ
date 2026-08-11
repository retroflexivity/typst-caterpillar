#import "/lib.typ": *
#import parsers: *


= space match
#parse(non-text)[ text]

= quote match
#parse(non-text)['cause?]

= emph match
#parse(non-text)[_text_  text]

= no match
#parse(non-text)[but  why?]

= no match
#parse(non-text)[]
