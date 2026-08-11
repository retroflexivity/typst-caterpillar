#import "/lib.typ": *
#import parsers: *


= match
#parse(test-not(string("this text")))[this _text_ is a test]

= match
#parse(test-not(exact[this _text_]))[this text is a test]

= no match
#parse(test-not(string("this")))[this _text_ is a test]
