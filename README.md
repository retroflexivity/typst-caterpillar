# Inline movement arrows in Typst, clever and customizable

The package is still in development.

## Using the package

Drawing arrows over a sentence consists of two actions:

- Wrap any number of words with `to` and `from`, providing a number from 0 to 9 as an argument;
- Surround it all with `move`.

```typst
#move[#to(9)[Points], lines go from #from(9)[$t$] and to #from(9)[$t$]].
```

```typst
#move[
  #to(1)Some] #from(2)[#to(4)[complex]] #from(1)[arrow] #to(2)[#from(4)[system]] (#to(3)[and] #from(3)[more])
]

```

The package will:
- find all you `from`s and `to`s and draw arrows between those with the same ids;
- understand automatically where to place the arrow to avoid collapsing;
- add margins around the block;

### Using with `eggs`

It so happens that movement arrows are usually placed on linguistic examples. The package has been tested to work with `eggs` 0.7.0 and above (earlier versions may have non-convergence problems).

**Caveat.** `eggs` aligns the example number by the upper border. Arrows above examples will cause misalignment of the example number and the example text. The solution is to wrap the whole example in `move`, like this:

```typst
#move[#example[
  #from(0)[from] #to(1)[to] #to(0)[to] #from(1)[from]
]]
```

### What this package doesn't do (yet)

- put labels on the arrows
- allow for tip customization (gotta connect tiptoe)
- support arrows wrapping over lines
