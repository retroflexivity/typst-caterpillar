#import "/lib.typ": *
#import parsers: *


= full match
#parse(anything)[text]

= text match
#parse(anything)[text  text]

= emph match
#parse(anything)[_text_  text]

= space match
#parse(anything)[  text]

= no match
#parse(anything)[]
