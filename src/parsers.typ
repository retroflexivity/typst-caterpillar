#import "utils.typ": *

// BASIC //

/// Parse a single piece of content that corresponds to a predicate.
///
/// (content -> bool) -> array(content) -> match-result(content)
///
/// ```typst
/// run-parser(predicate(it => it.func() == box))[#box[a box] and text]
/// ```
#let predicate(p) = cs => {
  if cs.len() > 0 and p(cs.first()) {
    (matched: true, match: cs.first(), rest: cs.slice(1))
  } else {
    break-match(rest: cs)
  }
}

/// Sequentially run a list of parsers.
/// *TIP*. This has syntactic sugar: just pass an array of parsers.
/// ```typc parse(multiple((p, q, r)))[...] == parse((p, q, r))[...]```
///
/// array(parser) -> array(content) -> match-result(array)
#let multiple(ps) = cs => {
  assert(type(ps) == array, message: "Array expected but got " + repr(ps))

  if ps.len() == 0 {
    return (matched: true, match: none, rest: cs)
  }
  // try the first parser,
  // fail if failed,
  // otherwise continue with the next on the rest
  let res = run-parser(ps.at(0))(cs)
  if res.matched {
    let next = multiple(ps.slice(1))(res.rest)
    (matched: next.matched, match: (res.match, ..next.match), rest: next.rest)
  } else {
    break-match(rest: cs)
  }
}

/// Parse the text that matches the parser string or regex exactly
/// from the beginning of the contents.
/// *TIP*. This has syntactic sugar: just pass a string or a regex.
/// ```typc parse(string("..."))[...] == parse("...")[...]```,
/// ```typc parse(string(regex(".*")))[...] == parse(regex(".*"))[...]```
///
/// str | regex -> array(content) -> match-result(content)
#let string(p) = cs => {
  if cs.len() > 0 and cs.first().has("text") and cs.first().text.starts-with(p) {
    let t = cs.first().text
    let (end,) = t.match(p)
    let rest = if t.len() > end {(text(t.slice(end)),)} else {none}
    (matched: true, match: text(t.slice(0, end)), rest: rest + cs.slice(1))
  } else {
    break-match(rest: cs)
  }
}

/// Parse possibly multipart content that matches the parser content exactly
/// or begins with it.
///
/// *TIP*. This has syntactic sugar: just pass pure content.
/// ```typc parse(exact[...])[...] == parse([...])[...]```
///
/// content -> array(content) -> match-result(content)
#let exact(p) = cs => {

  if p.has("children") {
    // try matching a slice of contents first
    let len = p.children.len()
    if cs.len() > len and cs.slice(0, len) == p.children {
      return (matched: true,
              match: cs.slice(0, len).join(),
              rest: cs.slice(len))
    }
    // then parse one by one
    let (matched, match, rest) = multiple(p.children)(cs)
    return (matched: matched,
            match: if type(match) == array {match.join()} else {match},
            rest: rest)
  }

  // match the first content precisely
  let full-res = predicate(it => it == p)(cs)
  if full-res.matched {
    return full-res
  }
  if p.has("text") {
    let str-res = string(p.text)(cs)
    if str-res.matched {
      return str-res
    }
  }

  break-match(rest: cs)
}

// COMBINATORS //

/// Fail if the parser fails,
/// otherwise succeed without consuming.
///
/// parser -> array(content) -> match-result(none)
#let test(p) = cs => {
  let res = run-parser(p)(cs)
  if res.matched {
    (matched: true, match: none, rest: cs)
  } else {
    break-match(rest: cs)
  }
}


/// Fail if the parser succeeds,
/// otherwise succeed without consuming.
///
/// parser -> array(content) -> match-result(none)
#let test-not(p) = cs => {
  let res = run-parser(p)(cs)
  if not res.matched {
    (matched: true, match: none, rest: cs)
  } else {
    break-match(rest: cs)
  }
}


/// Run a parser optionally,
/// returning an empty list instead of failing
/// when not matched.
///
/// parser -> array(content) -> match-result(content | none)
#let optional(p) = cs => {
  let res = run-parser(p)(cs)
  if res.matched {
    res
  } else {
    (matched: true, match: none, rest: cs)
  }
}


/// Try every parser until one succeeds.
///
/// ..parser -> array(content) -> match-result(any)
#let one-of(..ps) = cs => {
  let ps = ps.pos()
  if ps == () {
    return break-match(rest: cs)
  }

  let res = run-parser(ps.first())(cs)
  if res.matched {
    res
  } else {
    one-of(..ps.slice(1))(cs)
  }
}


/// Run all the parsers on the same content. If all succeed,
/// return the result of the first.
///
/// ..parser -> array(content) -> match-result(any)
#let all(..ps) = cs => {
  let ps = ps.pos()
  if ps == () {
    return (matched: true, match: none, rest: cs)
  }

  let res = run-parser(ps.first())(cs)
  if res.matched and all(..ps.slice(1))(cs).matched {
    res
  } else {
    break-match(rest: cs)
  }
}


/// Run the parser multiple times,
/// with the minimum and the maximum number of times
/// specified by `min` and `max` parameters.
/// If `max` <= 0, repeat ad infinum. If `min` > `max`, `min` is ignored.
///
/// (parser, min: int, max: int) -> match-result(array)
#let repeat(p, min: 0, max: -1) = cs => {
  // if max exhausted, stop
  if max == 0 {
    (matched: true, match: (), rest: cs)

  } else {
    let res = run-parser(p)(cs)

    // parse until failed
    if res.matched {
      let next = repeat(p, min: min - 1, max: max - 1)(res.rest)
      (matched: next.matched, match: (res.match, ..next.match), rest: next.rest)

    // in case of a fail, succeed if min is reached
    } else if min <= 0 {
      (matched: true, match: (), rest: cs)
    } else {
      break-match(rest: cs)
    }
  }
}


/// Continuously run the first parser
/// until the second succeeds.
/// Does not consume the match of the second parser.
///
/// (parser, parser) -> array(content) -> match-result(array)
#let until(p, end) = cs => {

  // run the end parser
  let end-res = run-parser(end)(cs)
  if end-res.matched {
    return (matched: true, match: (), rest: cs)
  }

  // otherwire run the second and continue
  let res = run-parser(p)(cs)
  if res.matched {
    let next = until(p, end)(res.rest)
    (matched: next.matched, match: (res.match, ..next.match), rest: next.rest)
  } else {
    break-match(rest: cs)
  }
}


// CONSTANTS //

/// Any piece of content.
/// Defined as `predicate(_ => true)`.
///
/// array(content) -> match-result(content)
#let anything = predicate(_ => true)

/// Any piece of content that doesn't have field `text`.
/// Defined as `predicate(c => not c.has("text"))`.
///
/// array(content) -> match-result(content)
#let non-text = predicate(c => not c.has("text"))

/// Either a space element or a " " string.
/// Defined as `one-of([ ], " ")`
///
/// array(content) -> match-result(content)
#let space = one-of([ ], " ")

/// Empty content.
///
/// array(content) -> match-result(none)
#let end = cs => {
  if cs == () {
    (matched: true, match: none, rest: cs)
  } else {
    break-match(rest: cs)
  }
}
