#import "/lib.typ": *
#import parsers: *


= first match
#parse(one-of(exact[this], exact[these]))[this text is a test]

= second match
#parse(one-of(exact[this], exact[these]))[these texts are a test]

= both (first) match
#parse(one-of(exact[this], exact[th]))[this text is a test]

= no match
#parse(one-of(exact[these], exact[that]))[this text is a test]
