#import "/lib.typ": *
#import parsers: *


= long match
#parse(all(exact[this], exact[th]))[this text is a test]

= short match
#parse(all(exact[th], exact[this], exact[this text]))[this text is a test]

= no match (first failed)
#parse(all(exact[these], exact[th]))[this text is a test]

= no match (second failed)
#parse(all([th], [these], [and]))[this text is a test]
