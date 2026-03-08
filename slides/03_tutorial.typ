#import "fit.typ": *
#import "@preview/cetz:0.3.1"
#import "@preview/ez-today:2.1.0"
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#prequery.fallback.update(true)

#enable-handout-mode(true)


// Helper functions for simple diagrams (replacing fletcher due to missing dependencies)
#let node-box(fill-color, label) = rect(
  fill: fill-color,
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  stroke: 1pt + rgb("#555555"),
  align(center, text(weight: "bold")[#label]),
)

#let connect-arrow(label) = align(center)[
  #text(size: 0.8em, fill: rgb("#666666"))[#label] \
  #v(-1.5em)
  #text(size: 1.5em, weight: "bold", fill: rgb("#555555"))[$arrow.b$]
]

#let connect-dbl-arrow(label) = align(center)[
  #text(size: 0.8em, fill: rgb("#666666"))[#label] \
  #v(-1.5em)
  #text(size: 1.5em, weight: "bold", fill: rgb("#555555"))[$arrow.t.b$]
]

#show: fit-theme.with(
  footer-content: "NI-NLM – 02 – Tutorial",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Tutorial 02",
  subtitle: "Semestral project – updates",
  author: "Zdeněk Kasner",
  date: "3 Mar 2026",
)[]

#slide[
  = New iteration of BabyLM is out... yay

  #set align(center + horizon)

  #image("img/lecture02/screen-2026-03-02-16-55-51.png")
  #source-slide("https://bsky.app/profile/lchoshen.bsky.social/post/3mg3kwrzwqc2h", title: "Bluesky")

]

#slide[
  = Updates -- overview



  - Our semestral project is based on the *#link("https://web.archive.org/web/20251230213017/https://babylm.github.io/index.html")[3rd iteration (2025)] of BabyLM Challenge*.
    - The materials and the evaluation pipeline are still available.
  - The new *#link("https://babylm.github.io")[4th iteration (2026)] of BabyLM Challenge* was recently announced.
    - 🔁 There are some changes to the tracks and datasets.
    - ✅ A workshop (for paper submissions) is planned for this new iteration.
    - ⚠ The evaluation pipeline is not ready yet.

  #infobox("TL;DR")[
    You can also work on the *updated version* of the BabyLM Challenge -- *if you wish*.
  ]

]

#slide[
  = What changed in BabyLM 2026?

  - 🔄 *Multimodal* and *Interaction* are no longer separate tracks.
    - Instead, multimodal data and teacher-model feedback are now *allowed within Strict / Strict-Small*.
  - 🌍 New *Multilingual* track was added.
    - Mixture of *English, Dutch, and Chinese*, budget *100M tokens*.
  - 🧹 *Datasets were detoxified*
    - Updated Strict (100M) and Strict-Small (10M) datasets.
]

#slide[
  = Updated tracks overview

  #grid(
    columns: (1fr, 1fr, 1.3fr),
    gutter: 1em,
    infobox(title: "Strict-small (recommended)")[
      - Budget: *10M words*, 10 epochs.
      - Text / multimodal / teacher feedback
    ],
    infobox(title: "Strict")[
      - Budget: *100M words*, 10 epochs.
      - Text / multimodal / teacher feedback.
    ],
    infobox(title: "Multilingual (new)")[
      - Budget: equivalent of *100M English words* (adjusted using "byte-premium" coefficientts).
      - primarily English + Dutch + Chinese.
    ],
  )


  Data: https://huggingface.co/collections/BabyLM-community/babylm-2026
]

#slide[
  = What does this mean for us?

  You are encouraged to work on the *new (2026) version*.

  #ideabox("📝 Bonus")[
    Your papers could actually be submitted to the workshop (EMNLP, Budapest, Oct 2026); deadline in July.
  ]


  #warnbox(title: "Evaluation pipeline not ready yet")[
    The 2026 evaluation pipeline is planned for *early April 2026*.
    Until then (and also as a permanent alternative), *working on the 2025 version is also allowed*.
  ]


  The #link("https://courses.fit.cvut.cz/NI-NLM/semestral-project.html")[Courses website] will be updated to reflect these changes.

]
