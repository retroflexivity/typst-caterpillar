#import "/lib.typ": *
#import parsers: *


= match
#parse(test(string("this")))[this _text_ is a test]

= match
#parse(test(exact[this _text_]))[this _text_ is a test]

= no match
#parse(test(exact[this _text_]))[this text is a test]
