#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
)

#set text(
  font: "Fira Sans",
  size: 11pt,
)

#set par(justify: true, leading: 0.65em)

// Title
#align(center)[
  #text(size: 16pt, weight: "bold")[NI-NLM -- Exercise: Byte Pair Encoding (BPE)]
]

#v(1.5em)

= Algorithm

The BPE tokenization algorithm works as follows:

+ Start with a vocabulary of all *individual characters* in the training corpus.
+ Count all *adjacent pairs* of tokens in the corpus.
+ *Merge* the most frequent pair into a new token.
+ *Repeat* steps 2--3 until the desired vocabulary size is reached.

The result is a *merge table* that defines how to tokenize any new text.

#v(1em)

= Exercise

Apply the BPE algorithm to the following toy corpus:

#v(0.5em)

#align(left)[
  #block(
    fill: luma(240),
    inset: 0.8em,
    radius: 4pt,
    width: 100%,
  )[
    #text(font: "Consolas", size: 11pt)[`aab baac aab baac caaba aac`]
  ]
]

#v(0.5em)

The *initial vocabulary* (size 4) is: `{▁, a, b, c}`, where `▁` represents a space.

The *target vocabulary size* is *8*.

#v(0.3em)

*Hint:* In case of a tie in the number of occurrences of candidate pairs, prefer the *leftmost* candidate (i.e., the one that appears earliest in the corpus).

#v(1em)

Fill in the merge table below:

#v(0.5em)

#table(
  columns: (2cm, 4cm, 3cm, 7cm),
  align: (center, left, left, left),
  inset: 0.75em,
  table.header([*Step*], [*Most frequent pair*], [*New token*], [*New corpus tokenization*]),
  [1], [], [], [],
  [2], [], [], [],
  [3], [], [], [],
  [4], [], [], [],
)

#v(1.5em)

*Final vocabulary* (a list of 8 elements):

#v(0.3em)

#block(
  stroke: 0.5pt + luma(180),
  inset: 0.8em,
  radius: 4pt,
  width: 100%,
  height: 2em,
)[]
