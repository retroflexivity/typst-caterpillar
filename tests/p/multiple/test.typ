#import "/lib.typ": *
#import parsers: *


= match
#parse(multiple([this], space, predicate(it => it.func() == emph)))[this _text_ is a test]

= match
#parse(multiple([this], space, [text]))[this text is a test]

= no match
#parse(multiple([this], space, predicate(it => it.func() == emph)))[_this_ text is a test]

= no match
#parse(multiple([this], space, predicate(it => it.func() == emph)))[this text is a test]

= no match
#parse(multiple(predicate(it => it.func() == emph), [text]))[_this_ text is a test]

