#import "/lib.typ": *
#import parsers: *


= full match
#parse(exact[this])[this _text_ is a test]

= full match
#parse(exact[this _text_])[this _text_ is a test]

= prefix match
#parse(exact[this])[this text is a test]

= prefix match
#parse(exact[this _text_ is])[this _text_ is a test]

= no match
#parse(exact[this _text_])[this text is a test]

= no match
#parse(exact[this text])[this _text_ is a test]

= no match
#parse(exact[this _text_])[this *text* is a test]
