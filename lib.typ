#import "src/utils.typ": *
#import "src/parsers.typ" as parsers

/// Run a parser on content.
///
/// parser, content -> match-result
#let parse(p, c) = {
  assert(type(c) == content, message: "Content expected, but got " + repr(c))
  let cs = if c.has("children") {c.children} else {(c,)}
  run-parser(p)(cs)
}

/// Parse a paragraph (or any content) trying every parser,
/// and apply the corresponding function to the first success,
/// otherwise keep the paragraph as is.
///
/// parser, content -> content
#let crawl(..prefs, par) = {
  for (parser, map) in prefs.pos() {
    let (matched, match, rest) = parse(parser, par.at("body", default: par))
    if matched {
      return map(match, rest)
    }
  }
  par
}
