#import "fit.typ": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#show: fit-theme.with(
  footer-content: "NI-NLM – 08 – Lecture",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Lecture 8",
  subtitle: "Efficiency: quantization, distillation, low-rank adaptation, MoE.",
  author: "Zdeněk Kasner",
  date: "14 Apr 2026",
)[]

#enable-handout-mode(true)


#section-slide(section: "Efficiency")[Why efficiency matters]


#slide[
  = The cost of running LLMs

  Modern LLMs are expensive to *train*, *store*, and *run*:

  #v(0.5em)

  - *Training*: GPT-4 used an #link("https://hai.stanford.edu/ai-index/2024-ai-index-report")[estimated] \$78 million worth of compute to train.
  - *Memory*: a 70B model in `float32` (=4 bits per parameter) requires $approx$ 280 GB of GPU memory / disk space.
  - *Inference*: OpenAI #link("https://www.arcade.dev/blog/ai-inference-economics")[spent] \$8.67 billion on inference in the first nine months of 2025 (nearly double their revenue for the same period).


  #questionbox()[Can you think of ways how to make LLMs smaller, faster, and cheaper (without sacrificing too much performance?)]
]


#slide[
  = Transformer: algorithmic complexity



  *Variables*: hidden state dimension ($D$), sequence length ($N$), vocabulary size ($V$).

  #v(0.25em)

  #set text(size: 18pt)
  #set align(center)
  #set par(leading: 0.5em)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[

    #set text(size: 16pt)
    #table(
      columns: 3,
      align: (center + horizon, center + horizon, center + horizon),
      stroke: (thickness: 1pt, paint: black, dash: "dotted"),
      inset: (x: 18pt, y: 12pt),
      [], [*Time*], [*Space*],

      [final projection \ (unembedding)],
      [
        #v(6pt)
        $N dot V dot D$
        #place(center, dy: 6pt)[
          #set text(size: 8.5pt, fill: luma(50))
          #set par(leading: 0.25em)
          #set align(center)
          each state projected to \ logits over the vocabulary
        ]
        #v(20pt)
      ],
      [
        #v(6pt)
        #box(fill: rgb("fceebb"), outset: 2.5pt, radius: 3pt)[$V dot D$] $+ V dot N$
        #place(center, dx: -20pt, dy: 6pt)[
          #set text(size: 8.5pt, fill: luma(50))
          #set par(leading: 0.25em)
          #set align(center)
          (un)embedding \ matrix 📦
        ]
        #place(center, dx: 30pt, dy: 6pt)[
          #set text(size: 8.5pt, fill: luma(50))
          #set par(leading: 0.25em)
          #set align(center)
          output \ logits 🧮
        ]
        #v(20pt)
      ],

      [MLP],
      [
        #v(6pt)
        $N dot$ #box(fill: rgb("d2e5f5"), outset: 2.5pt, radius: 3pt)[$D^2$]
        #place(center, dx: 20pt, dy: 6pt)[
          #diagram(spacing: 1pt, edge((0, 0), (12, 12), "->", stroke: luma(150)))
        ]
        #place(center, dx: 70pt, dy: 15pt)[
          #set text(size: 8.5pt, fill: luma(50))
          #set par(leading: 0.25em)
          projection matrix 📦
        ]
        #v(20pt)
      ],
      [
        #v(6pt)
        #box(fill: rgb("d2e5f5"), outset: 2.5pt, radius: 3pt)[$D^2$] $+ N dot D$
        #place(center, dx: -45pt, dy: 3pt)[
          #diagram(spacing: 1pt, edge((12, 0), (0, 12), "->", stroke: luma(150)))
        ]
        #place(center, dx: 25pt, dy: 10pt)[
          #set text(size: 8.5pt, fill: luma(50))
          #set par(leading: 0.25em)
          activations 🧮
        ]
        #v(20pt)
      ],

      [multi-head \ attention],
      [
        #v(6pt)
        $N dot D^2 +$ #box(fill: rgb("e1dbed"), outset: 2.5pt, radius: 3pt)[$N^2$] $dot D$
        #place(center, dx: -35pt, dy: 8pt)[
          #set text(size: 8.5pt, fill: luma(50))
          #set par(leading: 0.25em)
          #set align(center)
          queries, keys, \ values
        ]
        #place(center, dx: 25pt, dy: 6pt)[
          #diagram(spacing: 1pt, edge((0, 0), (12, 12), "->", stroke: luma(150)))
        ]
        #place(center, dx: 72pt, dy: 18pt)[
          #set text(size: 8.5pt, fill: luma(50))
          #set par(leading: 0.25em)
          attention matrix 📦
        ]
        #v(22pt)
      ],
      [
        #v(6pt)
        #box(fill: rgb("e1dbed"), outset: 2.5pt, radius: 3pt)[$N^2$] $+ N dot D + D^2$
        #place(center, dx: -55pt, dy: 6pt)[
          #diagram(spacing: 1pt, edge((12, 0), (0, 12), "->", stroke: luma(150)))
        ]
        #place(center, dx: 0pt, dy: 10pt)[
          #set text(size: 8.5pt, fill: luma(50))
          #set par(leading: 0.25em)
          #set align(center)
          projected \ values 🧮
        ]
        #place(center, dx: 45pt, dy: 10pt)[
          #set text(size: 8.5pt, fill: luma(50))
          #set par(leading: 0.25em)
          #set align(center)
          Q, K, V \ matrices 📦
        ]
        #v(22pt)
      ],

      [embedding],
      [
        #v(6pt)
        $N dot D$
        #place(center, dy: 6pt)[
          #set text(size: 8.5pt, fill: luma(50))
          #set par(leading: 0.25em)
          each token is embedded
        ]
        #v(16pt)
      ],
      [
        #v(6pt)
        #box(fill: rgb("fceebb"), outset: 2.5pt, radius: 3pt)[$V dot D$] $+ N dot D$
        #place(center, dx: -28pt, dy: 6pt)[
          #set text(size: 8.5pt, fill: luma(50))
          #set par(leading: 0.25em)
          #set align(center)
          embedding \ matrix 📦
        ]
        #place(center, dx: 30pt, dy: 6pt)[
          #set text(size: 8.5pt, fill: luma(50))
          #set par(leading: 0.25em)
          embeddings 🧮
        ]
        #v(16pt)
      ],
    )
    #v(-0.5em)

    #text(size: 10pt, fill: luma(50))[📦 = model parameters, 🧮 = computed values]
  ][
    #v(0.5em)

    #set align(center + horizon)
    #image("img/lecture08/transformer_complexity.png", width: 211pt)

    #source("https://transformer-circuits.pub/2021/framework/index.html
", title: "Transformer circuits")
  ]
]


#slide[
  = LLM bottlenecks: computational throughput

  #align(center)[
    #set text(size: 24pt)
    *Time complexity*

    #grid(
      columns: 5,
      column-gutter: 6pt,
      row-gutter: 10pt,
      align: center + bottom,
      text(size: 9pt, fill: luma(120), style: "italic")[MLP & projections],
      [],
      text(size: 9pt, fill: luma(120), style: "italic")[attention matrix],
      [],
      text(size: 9pt, fill: luma(120), style: "italic")[unembedding],

      text(fill: luma(120))[$N dot D^2$],
      text(fill: luma(120))[$+$],
      [#box(fill: rgb("e1dbed"), outset: (x: 2.5pt, y: 5pt), radius: 3pt)[$bold(N^2)$] $bold(dot D)$],
      text(fill: luma(120))[$+$],
      text(fill: luma(120))[$N dot V dot D$],
    )

    #v(-0.5em)
    #set text(size: 14pt)
    #grid(
      columns: (1.2fr, 1fr),
      gutter: 6em,
      align: (right, left),
      box(stroke: (dash: "dashed", paint: luma(120)), radius: 6pt, inset: 8pt, align(center)[
        long context \
        → $N^2 >> D^2$
      ]),
      box(stroke: (dash: "dashed", paint: luma(120)), radius: 6pt, inset: 8pt, align(center)[
        happens \
        only once
      ]),
    )
  ]


  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    #set align(horizon)

    Computing *multi-head attention* becomes the main bottleneck when $N^2 >> D^2$ (long context).

    #v(0.5em)

    *Solution:* efficient attention, MoE, distillation.
  ][


    #set text(size: 16pt)
    #set align(center + horizon)
    *Typical hyperparameter values:*

    #table(
      columns: 3,
      align: (left, right, right),
      table.header([*Param*], [*Min*], [*Max*]),
      [$N$], [512], [128,000+],
      [$D$], [768], [4,096+],
      [$V$], [30,000], [100,000+],
      [blocks], [8], [128+],
    )
  ]
]

#slide[
  = LLM bottlenecks: disk space

  #align(center)[
    #set text(size: 24pt)
    *Space complexity: model parameters 📦*

    #grid(
      columns: 3,
      column-gutter: 6pt,
      row-gutter: 10pt,
      align: center + bottom,
      text(size: 9pt, fill: luma(120), style: "italic")[embedding matrix],
      [],
      text(size: 9pt, fill: luma(120), style: "italic")[MLP & projections],

      [#box(fill: rgb("fceebb"), outset: (x: 2.5pt, y: 5pt), radius: 3pt)[#text(fill: luma(120))[$V dot D$]]],
      text(fill: luma(120))[$+$],
      [$bold(D^2)$],
    )

    #v(-0.5em)
    #set text(size: 14pt)
    #grid(
      columns: (1.6fr, 1fr),
      gutter: 12em,
      align: (right, left),
      box(stroke: (dash: "dashed", paint: luma(120)), radius: 6pt, inset: 8pt, align(center)[
        stored \
        only once
      ]),
    )
  ]


  #grid(
    columns: (1.7fr, 1fr),
    gutter: 1em,
  )[
    #set align(horizon)

    *MLPs* typically take up the majority of model parameters – they are repeated in each layer and the multiplicative factor is larger than for attention.


    *Solution:* parameter quantization, (Q)LoRA, distillation.
  ][


    #set text(size: 16pt)
    #set align(center + horizon)
    *Typical hyperparameter values:*

    #table(
      columns: 3,
      align: (left, right, right),
      table.header([*Param*], [*Min*], [*Max*]),
      [$N$], [512], [128,000+],
      [$D$], [768], [4,096+],
      [$V$], [30,000], [100,000+],
      [blocks], [8], [128+],
    )
  ]
]

#slide[
  = LLM bottlenecks: memory

  #align(center)[
    #set text(size: 24pt)
    *Space complexity: activations 🧮*

    #grid(
      columns: 5,
      column-gutter: 6pt,
      row-gutter: 10pt,
      align: center + bottom,
      text(size: 9pt, fill: luma(120), style: "italic")[attention matrix],
      [],
      text(size: 9pt, fill: luma(120), style: "italic")[hidden states],
      [],
      text(size: 9pt, fill: luma(120), style: "italic")[logits],

      [#box(fill: rgb("e1dbed"), outset: (x: 2.5pt, y: 5pt), radius: 3pt)[$bold(N^2)$]],
      text(fill: luma(120))[$+$],
      text(fill: luma(120))[$N dot D$],
      text(fill: luma(120))[$+$],
      text(fill: luma(120))[$N dot V$],
    )

    #v(-0.5em)
    #set text(size: 14pt)
    #grid(
      columns: (1.6fr, 1fr),
      gutter: 9.5em,
      align: (right, left),
      box(stroke: (dash: "dashed", paint: luma(120)), radius: 6pt, inset: 8pt, align(center)[
        gets more important \
        with growing input context size
      ]),
    )
  ]


  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    #set align(horizon)

    Activations take extra space in GPU memory (alongside the model parameters) when the model is performing a computation.

    #v(0.5em)

    *Solution:* parameter quantization, (Q)LoRA, distillation
  ][


    #set text(size: 16pt)
    #set align(center + horizon)
    *Typical hyperparameter values:*

    #table(
      columns: 3,
      align: (left, right, right),
      table.header([*Param*], [*Min*], [*Max*]),
      [$N$], [512], [128,000+],
      [$D$], [768], [4,096+],
      [$V$], [30,000], [100,000+],
      [blocks], [8], [128+],
    )
  ]
]

#slide[
  = Building an intuition about sizes
  #questionbox()[How much memory does it approximately take to store a *7B model* (=7 billion parameters) in *`fp16` precision*, meaning each parameter is stored as a 16-bit floating point number?
  ]

  #show: later

  #v(0.5em)

  Each parameter takes 2 bytes (16 bits), so:


  7 billion parameters $dot$ 2 bytes per parameter = 14B bytes = *14 GB*.


]

#slide[
  = LLM bottlenecks: training vs. inference

  In terms of resource requirements: *pre-training* $>>$ *finetuning* $>>$ *inference*.

  However, unlike training, we typically want to run inference on consumer hardware.

  *Dataset size*

  - Pre-training: 10T tokens $approx$ 50 TB.
  - Finetuning: up to 100s GB.

  *Memory requirements*

  - Inference: 2 bytes per parameter → 14 GB for a 7B model.
  - Training / finetuning: 2 bytes per parameter + 2 bytes per gradient + 12 bytes per optimizer state (Adam) → *112 GB* for a 7B model.


]


#slide[
  = Efficient algorithms: overview

  Techniques we will cover:

  #set text(size: 17pt)
  #set align(center)


  #table(
    columns: 6,
    align: (left, left, center, center, center, center),
    table.header(
      [*Algorithm*], [*What it targets*], [*Train. memory*], [*Train. speed*], [*Inf. memory*], [*Inf. speed*]
    ),
    [Quantization], [Reducing param. size], [--], [--], [✓✓], [✓],
    [Distillation], [Reducing \# of params], [--], [--], [✓✓], [✓✓],
    [(Q)LoRA], [Efficient finetuning], [✓✓], [✓], [--], [--],
    [MoE], [Reducing active params], [--], [✓✓], [--], [✓],
    [Linear attention],
    [Faster attention using math tricks
    ],
    [✓],
    [✓],
    [✓],
    [✓],

    [FlashAttention], [Faster attention using HW optimizations], [✓✓], [✓], [✓], [✓✓],
  )
]


// ============================================================
// SECTION 2: QUANTIZATION
// ============================================================

#section-slide(section: "Quantization")[Quantization]


#slide[
  = Bits per parameter

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization",
    title: "Maarten Grootendorst's blog",
  )

  Model parameters are floating point numbers. How do we store them? And can we store them more efficiently?

  #v(0.5em)

  #grid(
    columns: (1.2fr, 1fr),
    gutter: 1em,
  )[
    #set text(size: 17pt)
    #v(-1em)

    #infobox("Floating point numbers")[
      - `float64` – native Python (→64 bits).
      - `float32` – baseline precision (→32 bits).
      - `float16` – half precision (→16 bits).
    ]

    #set text(size: 20pt)

    - Inference: *little performance degradation* with `float16` → used with LLMs.
    - Training: `float16` can lead to vanishing gradients → *mixed-precision training*.
  ][
    #set align(center + horizon)
    #image("img/lecture08/float_formats.png", width: 350pt)
  ]
]


#slide[
  = bfloat16

  #source-slide("https://en.wikipedia.org/wiki/Bfloat16_floating-point_format", title: "Wikipedia")

  `bfloat16`: Developed by Google Brain (→ "brain float").

  #v(0.5em)

  #grid(
    columns: (1fr, 1.2fr),
    gutter: 1em,
    [
      - A 16-bit float *optimized for ML models*.
      - Greater *dynamic range* than float16 (supports outlier weights) at the cost of lower precision.
      - Now the *standard format* for training and inference in most LLM frameworks.


    ],
    [
      #set align(center + horizon)
      #image("img/lecture08/bfloat16.png", width: 400pt)
    ],
  )


]


#slide[
  = Parameter quantization

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization",
    title: "Maarten Grootendorst's blog",
  )

  Can we go beyond a 16-bit float?

  #ideabox()[Let's use `int8` having *8-bit per parameter* → we’ll save twice as much space.]

  #set align(center + horizon)
  #image("img/lecture08/int8_format.png", width: 400pt)

  #set align(left)

]


#slide[
  = Parameter quantization

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization",
    title: "Maarten Grootendorst's blog",
  )
  #questionbox()[The range of `int8` is $(-127, 127)$, while floats have a huge dynamic range ($approx$ $10^(-38)$ to $10^(38)$).
    How do we squeeze floating-point weights into the int range?]

  #grid(
    columns: (1.2fr, 1fr),
    gutter: 1em,
    [
      We can find the *maximum absolute value* and scale all weights proportionally:

      $ x_"quant" = "round"(127 / max(|bold(x)|) dot x) $

      We only use the range of our actual model weights → the range is not that wide.

    ],
    [
      #set align(center + horizon)
      #image("img/lecture08/absmax_quantization.png", width: 350pt)
    ],
  )
]


#slide[
  = Parameter quantization

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization",
    title: "Maarten Grootendorst's blog",
  )

  #questionbox()[
    What if some of the weights are *outliers*? This would map most of the weights to zero (or near zero):
    #v(-2em)
    #set align(center + horizon)

    #image("img/lecture08/outlier_problem.png", height: 2em)]

  #set align(left)

  Simple solution: *clip the outliers*:
  #set align(center)
  #image("img/lecture08/outlier_clipping.png", width: 400pt)
]


#slide[
  = Parameter quantization

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization",
    title: "Maarten Grootendorst's blog",
  )

  Model parameters can be quantized offline, but activations change with every input.

  #set align(center + horizon)
  #v(-1em)

  #image("img/lecture08/dynamic_activations.png", width: 250pt)

  #set align(left)

  Solution: compute the quantization range *dynamically* at inference time:

  #set align(center)
  #image("img/lecture08/dynamic_quantization.png", width: 300pt)



]


#slide[
  = Extreme quantization: 1-bit models

  #source-slide("https://arxiv.org/abs/2310.11453", title: "Ma et al. (2024)")

  Can we go all the way down to *1-bit*?

  #set align(center + horizon)
  #image("img/lecture08/1bit_quantization.png", width: 450pt)

  #set align(left)

  #v(0.5em)

  *BitNet* #link("https://arxiv.org/abs/2310.11453")[(Ma et al., 2024)]:  Each weight is either -1 or +1.

  Dot product reduced to addition → massive speedup on specialized hardware.
]


#slide[
  = Post-training quantization in practice


  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    === GPTQ #link("https://arxiv.org/abs/2210.17323")[(Frantar et al., 2022)]
    - Algorithm for layer-wise quantization.
    - Optimized for GPU inference.
    - More robust for extreme quantization (→ down to 2-bit).
    - Used with #link("https://huggingface.co/docs/transformers/quantization/gptq")[HF transformers].
  ][
    === GGUF
    - File format based on block-wise quantization.
    - Optimized for CPU inference.
    - Originally from #link("https://github.com/ggml-ai/llama.cpp")[llama.cpp], used by #link("https://ollama.com")[Ollama].
  ]

  #v(0.5em)

  #infobox(title: "Note")[Models in Ollama are quantized by default to 4-bit.]
]

#slide[
  = Quantization: summary


  #set align(center + horizon)
  #set text(size: 17pt)

  #table(
    columns: 4,
    align: (left, center, center, left),
    table.header([*Format*], [*Bits*], [*7B model size*], [*Notes*]),
    [`float32`], [32], [$approx$ 28 GB], [Rarely used with LLMs],
    [`float16`], [16], [$approx$ 14 GB], [Inference with older GPUs (before $approx$2020, like V100s)],
    [`bfloat16`], [16], [$approx$ 14 GB], [*Standard for training & inference*],
    [`int8`], [8], [$approx$ 7 GB], [Good accuracy, 2× savings],
    [`int4`], [4], [$approx$ 3.5 GB], [Popular for local deployment],
    [`1-bit`], [1], [$approx$ 0.9 GB], [Experimental, requires special training],
  )

  #set align(left)
  #set text(size: 20pt)

  #infobox(
    title: "Rule of thumb",
  )[Going from `float16` to `int4` reduces model size by $approx$ 4× with #link("https://developers.redhat.com/articles/2024/10/17/we-ran-over-half-million-evaluations-quantized-llms")[negligible performance degradation] for larger models.]
]


#section-slide(section: "Knowledge distillation")[Knowledge distillation]


#slide[
  = What is knowledge distillation?

  #source-slide(
    "https://www.geeksforgeeks.org/nlp/what-is-llm-distillation/",
    title: "https://www.geeksforgeeks.org/nlp/what-is-llm-distillation/",
  )

  We have a *large model* and we want to make it more *efficient*.
  #ideabox(
    title: "Idea: knowledge distillation",
  )[We can train a smaller model (*"student"*) on the knowledge of the large model (*"teacher"*).]

  #set align(center + horizon)

  #image("img/lecture08/What-is-LLM-Distillation__.png", width: 350pt)
]

#slide[
  = What is knowledge distillation?

  #source-slide(
    "https://cme295.stanford.edu/slides/fall25-cme295-lecture6.pdf",
    title: "CME295",
  )

  #warnbox("Warning")["Knowledge distillation" has two distinct meanings in the context of LLMs.]
  #set align(center)
  #v(1em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      *1. Learning from teacher's distribution:*

      #image("img/lecture08/screen-2026-03-23-13-49-19.png", width: 250pt)

    ],
    [
      *2. Learning from teacher's outputs:*

      #image("img/lecture08/screen-2026-03-23-13-49-23.png")
    ],
  )


]

#slide[
  = Learning from teacher's distribution

  #source-slide(
    "https://cme295.stanford.edu/slides/fall25-cme295-lecture6.pdf",
    title: "CME295",
  )

  *Learning from teacher's distribution*: The "original" knowledge distillation introduced by #link("https://arxiv.org/abs/1503.02531")[Hinton et al. (2015)] for classification models.

  #set align(center + horizon)
  #v(-1em)

  #image("img/lecture08/screen-2026-03-23-13-53-38.png", width: 400pt)
  #set align(left)

  The student learns from the teacher's output probability distribution (*soft outputs*) that carry *richer information than hard labels*.

]
#slide[
  = Learning from teacher's distribution


  The student is trained using a *KL-divergence loss* between their distribution $hat(y)_S$ and the teacher's distribution $hat(y)_T$:

  $ "KL"(hat(y)_T || hat(y)_S) = sum_i hat(y)_T^((i)) log(hat(y)_T^((i)) / hat(y)_S^((i))) $

  #infobox("Example")[
    - Ground truth (*hard label*): [cat: $1.0$, dog: $0.0$, car: $0.0$]
    - Teacher's distribution (*soft label*): [cat: $0.7$, dog: $0.2$, car: $0.1$]

    The soft label carries more signal. It tells the student that "a cat is somewhat similar to a dog, but not to a car".
  ]

]

#slide[
  = Learning from teacher's outputs


  #source-slide(
    "https://cme295.stanford.edu/slides/fall25-cme295-lecture6.pdf",
    title: "CME295",
  )

  Sometimes we only have access to the teacher's generated text.

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      In that case, we still can:
      - *Generate a large dataset* using the teacher model.
      - *Finetune the student* on this synthetic dataset.

    ],
    [
      #image("img/lecture08/screen-2026-03-23-13-49-23.png")
    ],
  )


  #v(0.25em)

  #infobox(
    title: "Use in practice",
  )[This technique was used e.g. to make smaller DeepSeek-R1 models. Also used for training smaller open models on the outputs from larger commercial models.]
]


#section-slide(section: "Finetuning & LoRA")[Finetuning & low-rank adaptation]


#slide[
  = Finetuning and when it helps

  #questionbox()[In which cases we may want to finetune a model on our own?]

  #show: later

  → To get outputs in a *consistent format* without extensive prompting.

  → To make the model learn our own *domain or a private knowledge base*.

  → To get a *smaller, more efficient* model (→ knowledge distillation).

  #show: later

  #warnbox("But finetuning is computationally expensive")[
    We saw that finetuning a 7B model requires $approx$ *112 GB* of GPU memory. For reference, a single H100 (96GB GPU) costs around \$25,000.]

]

#slide[
  = Low-rank adaptation (LoRA)


  #source-slide("https://arxiv.org/abs/2106.09685", title: "Hu et al. (2021)")

  The issue is alleviated by *LoRA* (#link("https://arxiv.org/abs/2106.09685")[Hu et al., 2021]) : low-rank adaptation method.

  #show: later

  #v(0.25em)

  #ideabox(title: "Key ideas of LoRA")[
    - Instead of updating model weights $W$ directly, we keep the $Delta W$ (the "diff") in a *separate matrix*.
    - We ensure that the $Delta W$ matrix has a *low rank* → it can be decomposed into two smaller matrices.
  ]

  #v(0.25em)

  $ W' = W + Delta W = W + B A $

  where $W in RR^(d times k)$, $B in RR^(d times r)$, $A in RR^(r times k)$, and $r << min(d, k)$.
]


#slide[
  = Low-rank adaptation (LoRA)
  #set align(center + horizon)
  #set text(size: 18pt)

  #grid(
    columns: (auto, auto, auto, auto, auto),
    align: (center + horizon, center + horizon, center + horizon, center + horizon, center + horizon),
    gutter: 1em,
    [
      #box(stroke: (dash: "dashed", paint: gray), inset: 0.75em, radius: 0.5em)[
        original\
        LLM (very\
        large)
      ]
    ],
    [
      $<-$
    ],
    [
      #image("img/lecture08/lora_diagram.png", width: 380pt)
    ],
    [
      #h(-3em)
      $->$
    ],
    [
      #box(stroke: (dash: "dashed", paint: gray), inset: 0.75em, radius: 0.5em)[
        LoRA weights:\
        (small, can be\
        stored as a\
        separate\
        "adapter")
      ]
    ],
  )


]

#slide[
  = Low-rank adaptation (LoRA)

  #source-slide("https://arxiv.org/abs/2106.09685", title: "Hu et al. (2021)")

  - The original model weights $W$ are *frozen* (no gradient updates), only the small matrices $A$ and $B$ are trained.
  - For inference, LoRA weights can be *merged* into the base model:
    $ W' = W + B A $
    → no additional latency at inference time.
  - The LoRA weights can be stored as a separate *adapter* (typically a few MB).
  #show: later

  #infobox()[
    For a rank $r = 8$ and $d = 4096$: LoRA adds only $2 times 4096 times 8 = 65,536$ parameters per layer instead of $4096^2 approx 16.7M$.
  ]
]


#slide[
  = QLoRA: finetuning quantized models

  #source-slide("https://arxiv.org/abs/2305.14314", title: "Dettmers et al. (2023)")

  #ideabox()[Can we combine *quantization* and *LoRA* for even higher efficiency?]
  #v(0.5em)

  #grid(
    columns: (1fr, 1.3fr),
    gutter: 1em,
  )[
    *QLoRA* #link("https://arxiv.org/abs/2305.14314")[(Dettmers et al., 2023)]:
    - Careful parameter quantization + optimizing CPU-GPU memory transfers.
    - Enables finetuning a 65B model on a single 48 GB GPU.
  ][
    #set align(center + horizon)
    #image("img/lecture08/qlora_diagram.png", width: 450pt)
  ]
]


#slide[
  = LoRA and QLoRA in practice

  All things being equal: *full finetuning > LoRA > QLoRA* in terms of model performance.

  → The goal is to make the most out of the memory you have.

  #v(-1em)


  #set text(size: 18pt)
  #set align(center + horizon)

  #table(
    columns: 3,
    align: (left, right, right),
    table.header([*Method*], [*Bits*], [*Memory (7B model)*]),
    [Full finetuning], [32], [$approx$ 120 GB],
    [Full finetuning], [16], [$approx$ 60 GB],
    [LoRA], [16], [$approx$ 16 GB],
    [QLoRA], [8], [$approx$ 10 GB],
    [QLoRA], [4], [$approx$ 6 GB],
  )

  #set text(size: 20pt)


  #source("https://github.com/hiyouga/LLaMA-Factory", title: "LLaMA-Factory")

  #set align(left)
  #v(-1em)

  Frameworks: #link("https://github.com/hiyouga/LLaMA-Factory")[LLaMA-Factory], #link("https://huggingface.co/docs/peft")[HuggingFace PEFT], #link("https://github.com/unslothai/unsloth")[Unsloth].
]



#section-slide(section: "Mixture of experts")[Mixture of experts]


#slide[
  = Mixture of experts (MoE)


  We need to re-run the full Transformer stack for every decoded token

  → Inference with large models can get very *slow*.

  #infobox()[For Llama 3.1 405B, Oracle got around #link("https://docs.oracle.com/en-us/iaas/Content/generative-ai/benchmark-meta-llama-3-1-405b-instruct.htm#:~:text=to%20100%20tokens.-,The%20meta.llama-3.1-405b-instruct%20model%20hosted")[27 tokens/sec] on a specialized HW.]

  But perhaps the model does not need _all_ of its parameters for _each_ token?

  #show: later


  #ideabox(
    title: "Idea",
  )[Let's (1) force the model to *specialize* subsets of its parameters for different tasks and (2) only *activate* the specific subset → Mixture of experts.]


]

#slide[
  = Mixture of experts (MoE)


  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-mixture-of-experts",
    title: "Maarten Grootendorst's blog",
  )
  *"Experts"* = multiple feed-forward networks in each MLP layer of the Transformer.

  #set align(center + horizon)
  #image("img/lecture08/moe_architecture.png", width: 500pt)

]

#slide[
  = Mixture of experts (MoE)

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-mixture-of-experts",
    title: "Maarten Grootendorst's blog",
  )

  #v(3em)

  #set align(center)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    We can choose a different expert at each *layer*...
    #image("img/lecture08/moe_routing_layers.png", width: 350pt)
  ][

    and a different set of experts for each *token*:
    #v(1em)

    #image("img/lecture08/moe_routing_tokens.png", width: 250pt)
  ]
]


#slide[
  = Mixture of experts (MoE)

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-mixture-of-experts",
    title: "Maarten Grootendorst's blog",
  )

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    Why is this a good idea?

    - Individual experts can *specialize* to solving certain kinds of problems.
    - *Faster training* for the same number of total parameters (we only backpropagate through selected experts).
    - *Faster inference* (although we still need to load the full model into memory).



  ][
    #set align(center + horizon)
    #image("img/lecture08/moe_specialization.png", width: 400pt)
  ]


]

#slide[
  = MoE: Mixtral


  *Example*: Mixtral 8×7B → 8 expert MLPs, approximately equivalent to a 47B dense model (not 56B, since attention layers and embeddings are shared).

  #grid(
    columns: (1.3fr, 1fr),
    gutter: 1em,
    [
      #set align(center + horizon)

      #image("img/lecture08/cc3d48d5-8afc-4477-af98-5817b1a145ae_1376x988.png", width: 370pt)
    ],
    [
      #set align(center + horizon)

      #image("img/lecture08/1dfd20b4-d3b7-433b-8072-2e67fc70afaa_1376x544.png")
    ],
  )

]


#section-slide(section: "Efficient attention")[Efficient attention]


#slide[
  = Linear attention

  #source-slide(
    "https://haileyschoelkopf.github.io/blog/2024/linear-attn/
",
    title: "https://haileyschoelkopf.github.io/blog/2024/linear-attn/
",
  )

  Let's revisit the $O(#box(fill: rgb("#e1d5f2"), outset: (x: 2.5pt, y: 5pt), radius: 3pt)[$N^2$])$ attention. Can we do better?


  #text(size: 24pt)[$ "Attention"(Q, K, V) = "softmax" (Q K^top)V $]

  Let's zoom in! 🕵️

  #set align(center)

  #set text(size: 24pt)


  #diagram(
    node(
      (0, 0),
      $
        "softmax" (Q K^top)V = (#box(stroke: red + 3pt, radius: 4pt, outset: 6pt)[$exp(Q K^top)$]) / (sum_(i=1)^L #box(stroke: red + 3pt, radius: 4pt, outset: 6pt)[$exp(Q K_i^top)$]) V
      $,
      name: <eq>,
      stroke: none,
    ),
    node(
      (1, -0.3),
      align(center)[#text(size: 14pt)[very expensive \ way to measure \ similarity between \ queries and keys]],
      width: 140pt,
      stroke: (dash: "dashed", paint: gray),
      corner-radius: 5pt,
      name: <box>,
    ),
    edge(<box>, (0.4, -0.2), "-|>", stroke: gray + 1pt),
    edge(<box>, (0.3, 0.1), "-|>", stroke: gray + 1pt),
  )
]


#slide[
  = Linear attention: rearranging the computation

  We can use a cheaper way of computing similarity:

  #v(1em)

  #set align(center)

  #diagram(
    node((0, 0), $ ("sim"(Q, K)) / (sum_(i=1)^L "sim"(Q, K_i)) V $, stroke: none),
    node(
      (1.5, 0),
      $
        "sim"(Q, K) = #box(stroke: green.darken(20%) + 2pt, radius: 4pt, inset: 4pt)[$phi(Q) dot phi(K)$] = phi(Q)phi(K)^top
      $,
      stroke: none,
    ),
    node(
      (1.5, 0.5),
      align(center)[#text(size: 14pt)[$phi$ = optional dimensionality \ mapping, can be also identity]],
      width: 280pt,
      stroke: (dash: "dashed", paint: gray),
      corner-radius: 5pt,
    ),
  )

  #set align(left)

  This also allows us to re-arrange matrix multiplications:

  #v(1em)

  #set align(center)

  #diagram(
    node(
      (-0.9, 0),
      align(center)[#set par(leading: 0.8em); #v(0.5em) $Q dot K in$ \ $RR^(N times N)$ #v(0.5em)],
      width: 120pt,
      stroke: (dash: "dashed", paint: gray),
      corner-radius: 5pt,
    ),
    node(
      (0, 0),
      $
        ( #box(stroke: red + 2pt, radius: 4pt, inset: 4pt)[$phi(Q)phi(K)^top$] ) / (sum_(i=1)^L phi(Q)phi(K_i)^top) V = ( phi(Q) #box(stroke: green.darken(20%) + 2pt, radius: 4pt, inset: 4pt)[$phi(K)^top V$] ) / (phi(Q) sum_(i=1)^L phi(K_i)^top)
      $,
      stroke: none,
    ),
    node(
      (0.9, 0),
      align(center)[#set par(leading: 0.8em); #v(0.5em) $K dot V in$ \ $RR^(D times D)$ #v(0.5em)],
      width: 120pt,
      stroke: (dash: "dashed", paint: gray),
      corner-radius: 5pt,
    ),
  )
]


#slide[
  = Linear attention

  The resulting operations are $O(N dot D^2)$, which is linear in sequence length.


  Wo-hoo! 🎉
  #v(1em)

  #grid(
    columns: (1fr, 1.5fr),
    gutter: 1em,
    [
      #set align(center + horizon)

      #image("img/lecture08/linear_attn_perf.jpg", width: 250pt)
      #v(1.5em)

    ],
    [
      #set align(center + horizon)

      #bordered-box[#image("img/lecture08/screen-2026-03-23-15-38-59.png")]
      #source(
        "https://www.reddit.com/r/MachineLearning/comments/10eolfl/d_why_arent_we_all_using_linear_transformers/",
        title: "Reddit",
      )

    ],
  )

]


#slide[
  = FlashAttention

  #source-slide("https://arxiv.org/abs/2205.14135", title: "Dao et al. (2022)")

  Approximations like linear attention can degrade performance.

  Meanwhile, *hardware optimizations* of the full attention mechanism can go a long way.

  #v(-1em)

  #set align(center + horizon)
  #image("img/lecture08/flashattention.png", width: 400pt)
]


#slide[
  = FlashAttention

  #source-slide("https://arxiv.org/abs/2205.14135", title: "Dao et al. (2022)")


  *FlashAttention* re-arranges the operations to use the GPU memory more efficiently.

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      It is:
      - *Fast*: 2-3x faster than baselines.
      - *Memory-efficient*: linear in sequence length.
      - *Exact*: uses no approximations.

      It is now implemented in major LLM frameworks (PyTorch, HuggingFace, vLLM, ...)

    ],
    [
      #set align(center + horizon)

      #image("img/lecture08/flashattention2.png", width: 200pt)
    ],
  )
]


#section-slide(section: "Summary")[Summary]


#slide[
  = Summary

  - *Quantization*: reducing the precision of model weights to save memory and speed up inference with minimal quality loss.
  - *Knowledge distillation*: training a *student* model to mimic a *teacher* model.
  - *LoRA*: low-rank adaptation; efficient approach for finetuning LLMs.
  - *QLoRA* combines quantization with LoRA for even higher efficiency.
  - *Mixture of Experts (MoE)*: only a subset of model parameters (*experts*) is activated per token, enabling faster inference with large total parameter counts.
  - *Efficient attention*: linear attention reduces complexity from $O(N^2)$ to $O(N)$.
  - *FlashAttention* provides exact attention with hardware-optimized memory access.
]


#slide[
  = Links and resources

  #set text(size: 15pt)

  - #link("https://huggingface.co/docs/transformers/quantization/overview")[HuggingFace: Quantization overview]
  - #link("https://arxiv.org/abs/2208.07339")[Dettmers et al. (2022): LLM.int8() -- 8-bit Matrix Multiplication]
  - #link("https://arxiv.org/abs/2310.11453")[Ma et al. (2024): The Era of 1-bit LLMs (BitNet)]
  - #link("https://arxiv.org/abs/1503.02531")[Hinton et al. (2015): Distilling the Knowledge in a Neural Network]
  - #link("https://arxiv.org/abs/2106.09685")[Hu et al. (2021): LoRA: Low-Rank Adaptation of Large Language Models]
  - #link(
      "https://arxiv.org/abs/2305.14314",
    )[Dettmers et al. (2023): QLoRA: Efficient Finetuning of Quantized Language Models]
  - #link("https://arxiv.org/abs/2401.04088")[Jiang et al. (2024): Mixtral of Experts]
  - #link(
      "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-mixture-of-experts",
    )[Maarten Grootendorst's blog: A Visual Guide to Mixture of Experts]
  - #link("https://arxiv.org/abs/2205.14135")[Dao et al. (2022): FlashAttention]
  - #link("https://haileyschoelkopf.github.io/blog/2024/linear-attn/")[Schoelkopf (2024): Linear Attention]
  - #link("https://github.com/hiyouga/LLaMA-Factory")[LLaMA-Factory: finetuning framework]
  - #link("https://huggingface.co/docs/peft")[HuggingFace PEFT: Parameter-Efficient Fine-Tuning]
]

