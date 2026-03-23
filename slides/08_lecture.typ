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
  date: "31 Mar 2026",
)[]

#enable-handout-mode(true)


// ============================================================
// SECTION 1: WHY EFFICIENCY MATTERS
// ============================================================

#section-slide(section: "Efficiency")[Why efficiency matters]


#slide[
  = The cost of running LLMs

  Modern LLMs are expensive to *train*, *store*, and *run*:

  #v(0.5em)

  - *Training*: GPT-4 cost an estimated \$100M+ in compute.
  - *Inference*: serving billions of queries per day requires massive GPU clusters.
  - *Storage*: a 70B model in float32 takes $approx$ 280 GB of disk space.
  - *Memory*: loading even a 7B model requires $approx$ 14 GB of GPU memory.

  #v(0.5em)

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

  However, we typically want to run inference on consumer hardware → it also matters.

  *Dataset size*

  - Pre-training: 10T tokens $approx$ 50 TB.
  - Finetuning: up to 100s GB.

  *Memory requirements*

  - Inference: 2 bytes per parameter → 14 GB for a 7B model.
  - Training / finetuning: 2 bytes per parameter + 2 bytes per gradient + 12 bytes per optimizer state (Adam) → *112 GB* for a 7B model.


]


#slide[
  = Efficient algorithms: overview

  We will go over the following techniques:

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
    [MoE], [Reducing active params], [--], [✓✓], [--], [✓],
    [Linear attention],
    [Faster attention using math tricks
    ],
    [✓],
    [✓],
    [✓],
    [✓],

    [FlashAttention], [Faster attention using HW optimizations], [✓✓], [✓], [✓], [✓✓],
    [(Q)LoRA], [Efficient finetuning], [✓✓], [✓], [--], [--],
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
    title: "Grootendorst (2024)",
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
    title: "Grootendorst (2024)",
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
    title: "Grootendorst (2024)",
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
    title: "Grootendorst (2024)",
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
    title: "Grootendorst (2024)",
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
  )[Going from `float16` to `int4` reduces model size by $approx$ 4× with often less than 5% performance drop on standard benchmarks.]
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
    - *Hard label* (ground truth): [cat: $1.0$, dog: $0.0$, car: $0.0$]
    - *Soft label* (teacher distribution): [cat: $0.7$, dog: $0.2$, car: $0.1$]

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

  → To get outputs in a *consistent format* without extensive prompting.

  → To make the model learn our own *domain or a private knowledge base*.

  → To get a *smaller, more efficient* model (→ knowledge distillation).

  #warnbox("But finetuning is computationally expensive")[
    We saw that finetuning a 7B model requires $approx$ *112 GB* of GPU memory. For comparison, a single H100 (96GB GPU) costs around \$25,000.]

]

#slide[
  = Low-rank adaptation (LoRA)


  #source-slide("https://arxiv.org/abs/2106.09685", title: "Hu et al. (2021)")

  The issue is alleviated by *LoRA* (#link("https://arxiv.org/abs/2106.09685")[Hu et al., 2021]) : low-rank adaptation method.

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


#slide[
  = Other PEFT methods

  LoRA is not the only parameter-efficient finetuning method:

  #v(0.5em)

  - *Prefix tuning* #link("https://arxiv.org/abs/2101.00190")[(Li & Liang, 2021)]: prepend learnable "virtual tokens" to the input.
  - *Prompt tuning* #link("https://arxiv.org/abs/2104.08691")[(Lester et al., 2021)]: similar to prefix tuning, but only for the input layer.
  - *Adapters* #link("https://arxiv.org/abs/1902.00751")[(Houlsby et al., 2019)]: insert small bottleneck layers into each Transformer block.
  - *DoRA* #link("https://arxiv.org/abs/2402.09353")[(Liu et al., 2024)]: weight-decomposed LoRA – decomposes weight updates into magnitude and direction.

  #v(0.5em)

  #infobox(
    title: "In practice",
  )[LoRA and QLoRA remain the *most popular* PEFT methods by far, thanks to their simplicity and strong performance.]
]


#section-slide(section: "Mixture of experts")[Mixture of experts]


#slide[
  = Mixture of experts (MoE)

  #source-slide("https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-moe", title: "Grootendorst (2024)")

  #ideabox(
    title: "Idea",
  )[Replace the single feed-forward network (MLP) in each Transformer layer with *multiple experts*. A *router* selects which experts to use for each token.]

  #set align(center + horizon)
  #image("img/lecture08/moe_architecture.png", width: 450pt)
]


#slide[
  = MoE routing

  #source-slide("https://arxiv.org/abs/2401.04088", title: "Fedus et al. (2024)")

  We can choose a *different expert at each layer* and a *different set of experts for each token*:

  #set align(center + horizon)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    #image("img/lecture08/moe_routing_layers.png", width: 350pt)
  ][
    #image("img/lecture08/moe_routing_tokens.png", width: 250pt)
  ]
]


#slide[
  = Why MoE works

  #source-slide("https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-moe", title: "Grootendorst (2024)")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    Why is this a good idea?

    - Individual experts can *specialize* to solving certain kinds of problems.
    - *Faster training* for the same number of total parameters (we only backpropagate through selected experts).
    - *Faster inference* (although we still need to load the full model into memory).

    #v(0.25em)

    Example: Mixtral 8×7B → 8 expert MLPs, approximately equivalent to a *47B dense model* (not 56B, since attention layers and embeddings are shared).
  ][
    #set align(center + horizon)
    #image("img/lecture08/moe_specialization.png", width: 230pt)
  ]
]


#slide[
  = The router

  #source-slide("https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-moe", title: "Grootendorst (2024)")

  The *router* (or "gating network") is a small learned network that decides which experts to activate:

  $ G(x) = "softmax"("TopK"(x dot W_g)) $

  - $W_g$ is a learnable weight matrix.
  - *TopK*: only the top $K$ experts (typically $K = 1$ or $K = 2$) are activated.
  - The router outputs *weights* for combining expert outputs.

  #v(0.5em)

  #warnbox(
    title: "Load balancing",
  )[If the router always picks the same experts, some experts are underutilized. MoE models use *auxiliary losses* to encourage balanced expert utilization.]
]


#slide[
  = MoE models in practice

  MoE has become a very popular architecture for recent LLMs:

  #v(0.5em)

  #set text(size: 18pt)

  #table(
    columns: 4,
    align: (left, center, center, center),
    table.header([*Model*], [*Total params*], [*Active params*], [*Experts*]),
    [Mixtral 8×7B], [46.7B], [12.9B], [8 (top-2)],
    [Mixtral 8×22B], [176B], [39B], [8 (top-2)],
    [DeepSeek-V3], [671B], [37B], [256 (top-8)],
    [Qwen3-235B], [235B], [22B], [128 (top-8)],
    [GPT-4 (rumored)], [$approx$ 1.8T], [$approx$ 220B], [16 (top-2)],
  )

  #set text(size: 20pt)

  #v(0.25em)

  #infobox(
    title: "Key insight",
  )[MoE models can be much larger in *total* parameters while keeping the *active* parameter count (and thus inference cost) comparable to smaller dense models.]
]


#slide[
  = MoE: tradeoffs

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    === Advantages
    - Faster training and inference for a given quality level.
    - Experts can specialize.
    - Scales well with more experts.
  ][
    === Disadvantages
    - *Memory*: the full model must be loaded (all experts), even though only a few are active.
    - *Load balancing*: uneven expert utilization wastes capacity.
    - *Communication overhead*: in distributed settings, tokens need to be routed across devices.
  ]

  #v(0.5em)

  #questionbox()[MoE models are often paired with *quantization* to address the memory issue. Why does this make sense?]
]


// ============================================================
// SECTION 6: EFFICIENT ATTENTION
// ============================================================

#section-slide(section: "Efficient attention")[Efficient attention]


#slide[
  = Linear attention

  #source-slide("https://haileyschoelkopf.github.io/blog/2024/linear-attn/", title: "Schoelkopf (2024)")

  Standard attention has $O(N^2)$ complexity due to the softmax over all pairs of queries and keys:

  #set align(center + horizon)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    #image("img/lecture08/attention_softmax.png", width: 250pt)
    Very expensive similarity computation
  ][
    #image("img/lecture08/attention_formula.png", width: 280pt)
    Standard attention formula
  ]

  #set align(left)

  #questionbox()[Can we find a cheaper way to compute attention?]
]


#slide[
  = Linear attention: rearranging the computation

  #source-slide("https://haileyschoelkopf.github.io/blog/2024/linear-attn/", title: "Schoelkopf (2024)")

  We can replace softmax with a cheaper kernel function $phi$:

  $ "Attention"(Q, K, V) = phi(Q) (phi(K)^top V) $

  #v(0.25em)

  This allows us to *rearrange* matrix multiplications:

  #set align(center + horizon)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.5em,
  )[
    Standard: $Q K^top in RR^(N times N)$

    → $O(N^2 dot D)$
  ][
    Linear: $K^top V in RR^(D times D)$

    → $O(N dot D^2)$
  ]

  #set align(left)

  #v(0.25em)

  The resulting operations are $O(N dot D^2)$, which is *linear in sequence length*.
]


#slide[
  = Linear attention: does it work?

  #source-slide("https://haileyschoelkopf.github.io/blog/2024/linear-attn/", title: "Schoelkopf (2024)")

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    In theory, linear attention is very attractive (linear vs. quadratic).

    In practice, performance *degrades* compared to full softmax attention.

    #v(0.5em)

    Recent models like *Mamba* (#link("https://arxiv.org/abs/2312.00752")[Gu & Dao, 2023]) and *RWKV* use variants of linear attention with additional tricks to close the gap.
  ][
    #set align(center + horizon)
    #image("img/lecture08/linear_attn_perf.jpg", width: 250pt)
  ]
]


#slide[
  = FlashAttention

  #source-slide("https://arxiv.org/abs/2205.14135", title: "Dao et al. (2022)")

  Approximations like linear attention can degrade performance. Meanwhile, *hardware optimizations* of the full attention mechanism can go a long way.

  #set align(center + horizon)
  #image("img/lecture08/flashattention.png", width: 550pt)
]


#slide[
  = FlashAttention: how it works

  #source-slide("https://arxiv.org/abs/2205.14135", title: "Dao et al. (2022)")

  FlashAttention re-arranges the attention computation to better use the *GPU memory hierarchy*:

  #v(0.5em)

  - Uses *tiling* to break the attention computation into small blocks that fit in fast GPU SRAM.
  - Avoids materializing the full $N times N$ attention matrix in slow GPU HBM.

  #v(0.5em)

  Properties:
  - *Fast*: 2--3× faster than standard attention.
  - *Memory-efficient*: linear in sequence length.
  - *Exact*: uses no approximations (unlike linear attention).
  - Now *commonly implemented* in all major LLM frameworks (PyTorch, HuggingFace, vLLM, ...).
]


// ============================================================
// SECTION 7: SUMMARY
// ============================================================

#section-slide(section: "Summary")[Summary]


#slide[
  = Summary

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    === Quantization
    - Reduce precision (float16 → int8 → int4).
    - Huge memory savings with small accuracy loss.
    - GPTQ, GGUF for practical deployment.

    === Distillation
    - Train a small student from a large teacher.
    - Soft labels transfer more knowledge.
    - White-box vs. black-box approaches.
  ][
    === LoRA / QLoRA
    - Freeze base model, train low-rank adapters.
    - Dramatic reduction in finetuning memory.
    - Can be combined with quantization (QLoRA).

    === Mixture of experts
    - Multiple expert MLPs, only a few active.
    - More capacity without proportional compute.
    - Used in Mixtral, DeepSeek, Qwen3.
  ]
]


#slide[
  = Next lecture

  // TODO: fill in the next lecture topic

  #v(2em)

  *Questions?*
]

