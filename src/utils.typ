/// MATCH-RESULT schema.
/// a match result is a dictionary 
#let is-match-result(v) = (
  type(v) == dictionary
  and v.has("matched") and type(v.matched) == bool
  and v.has("match")
  and v.has("rest")
)

#let break-match(matched: false, match: none, rest: none) = (matched: matched, match: match, rest: rest)


/// PARSER schema.
/// A parser is a singleton expression that gets compared to the content.
/// can be:
/// - content (compared to full )
/// - function `content -> match-result`
#let is-parser(v) = (
  type(v) in (function, content, string, regex, array)
)

/// Turn the polymorphic parser into a parser function,
/// to be run on an array of contents.
///
/// function | content -> function
#let run-parser(p) = {
  import "parsers.typ": exact, string, multiple
  let f = (
    function: p,
    content: exact(p),
    string: string(p),
    regex: string(p),
    array: multiple(p)
  ).at(str(type(p)), default: none)

  if f != none {
    return f
  } else {
    assert(is-parser(p), message: "A parser must be one of: function, content, string (regex), array, but got " + repr(p))
  }
}
