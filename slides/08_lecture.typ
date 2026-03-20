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

    #set text(size: 15pt)
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

    #text(fill: luma(120))[$N dot D^2 +$] #box(
      fill: rgb("e1dbed"),
      outset: (x: 2.5pt, y: 5pt),
      radius: 3pt,
    )[$bold(N^2)$] $bold(dot D)$ #text(fill: luma(120))[$+ N dot V dot D$]

    #v(-0.5em)
    #set text(size: 14pt)
    #grid(
      columns: (1.2fr, 1fr),
      gutter: 5em,
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

  #v(0.5em)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    #set align(horizon)

    Computing *multi-head attention* becomes the main bottleneck when $N^2 >> D^2$ (long context).

    #v(0.5em)

    *Solution:* efficient attention, mixture of experts.
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

    #box(fill: rgb("fceebb"), outset: (x: 2.5pt, y: 5pt), radius: 3pt)[#text(fill: luma(120))[$V dot D$]] + $bold(D^2)$

    #v(-0.5em)
    #set text(size: 14pt)
    #grid(
      columns: (1.6fr, 1fr),
      gutter: 9.5em,
      align: (right, left),
      box(stroke: (dash: "dashed", paint: luma(120)), radius: 6pt, inset: 8pt, align(center)[
        stored \
        only once
      ]),
    )
  ]

  #v(0.5em)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    #set align(horizon)

    *MLPs* (→ $D^2$) typically take up the majority of model parameters – they are repeated in each layer, unlike the embedding matrix.

    #v(0.5em)

    *Solution:* parameter quantization, (Q)LoRA.
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
  = LLM bottlenecks: computational throughput

  #align(center)[
    #set text(size: 24pt)
    *Space complexity: activations 🧮*

    #box(
      fill: rgb("e1dbed"),
      outset: (x: 2.5pt, y: 5pt),
      radius: 3pt,
    )[$bold(N^2)$] #text(fill: luma(120))[$+ N dot D + N dot V$]

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

  #v(0.5em)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    #set align(horizon)

    For loading a model to GPU memory, we need to account for both model parameters (fixed) and computed activations (depend on the input context size).

    #v(0.5em)

    *Solution:* parameter quantization, (Q)LoRA.
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
  = LLM bottlenecks: training vs. inference

  In terms of resource requirements: *pre-training* $>>$ *finetuning* $>>$ *inference*. On the other hand, we typically want to run inference on consumer hardware.

  *Dataset size*

  - Pre-training: 10T tokens $approx$ 50 TB.
  - Finetuning: up to 100s GB.

  *Memory requirements*

  - *Inference*: 2 bytes per parameter → 14 GB for a 7B model.
  - *Training*: 2 bytes per parameter + 2 bytes per gradient + 12 bytes per optimizer state (Adam) → *112 GB* for a 7B model.


]


#slide[
  = Efficient algorithms: overview

  #set text(size: 17pt)
  #set align(center + horizon)


  #table(
    columns: 6,
    align: (left, left, center, center, center, center),
    table.header(
      [*Algorithm*], [*What it targets*], [*Train. memory*], [*Train. speed*], [*Inf. memory*], [*Inf. speed*]
    ),
    [Quantization], [Reducing param. size], [--], [--], [✓✓], [✓],
    [Distillation], [Model compression], [--], [--], [✓✓], [✓✓],
    [MoE], [Reducing active params.], [--], [✓✓], [--], [✓],
    [Linear attention], [Faster attention], [✓], [✓], [✓], [✓],
    [FlashAttention], [HW-optimized attention], [✓✓], [✓], [✓], [✓✓],
    [(Q)LoRA], [Efficient finetuning], [✓✓], [✓], [--], [--],
  )
]


// ============================================================
// SECTION 2: QUANTIZATION
// ============================================================

#section-slide(section: "Quantization")[Quantization]


#slide[
  = Parameter quantization

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
    - *float64* – native Python (typically not used on GPUs).
    - *float32* – baseline precision.
    - *float16* – half precision.

    #v(0.5em)

    For inference, float16 typically causes only little performance degradation.

    For training, float16 can lead to vanishing gradients → *mixed-precision training*.
  ][
    #set align(center + horizon)
    #image("img/lecture08/float_formats.png", width: 280pt)
  ]
]


#slide[
  = bfloat16

  #source-slide("https://en.wikipedia.org/wiki/Bfloat16_floating-point_format", title: "Wikipedia")

  Developed by Google Brain (→ "brain float").

  #v(0.5em)

  - A 16-bit float *optimized for ML models*.
  - Greater *dynamic range* than float16 (supports outlier weights) at the cost of lower precision.
  - Now the *standard format* for training and inference in most LLM frameworks.

  #set align(center + horizon)
  #image("img/lecture08/bfloat16.png", width: 350pt)
]


#slide[
  = Going further: int8

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization",
    title: "Grootendorst (2024)",
  )

  Can we go beyond 16-bit? *int8* is an 8-bit integer format – saving twice as much space compared to float16.

  #set align(center + horizon)
  #image("img/lecture08/int8_format.png", width: 400pt)

  #set align(left)

  But how do we squeeze floating-point weights into the $(-127, 127)$ range?
]


#slide[
  = Absmax quantization

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization",
    title: "Grootendorst (2024)",
  )

  We don't use the full float range – we only use the range of our actual model weights.

  We find the *maximum absolute value* and scale all weights proportionally:

  $ x_"quant" = "round"(127 / max(|bold(x)|) dot x) $

  #set align(center + horizon)
  #image("img/lecture08/absmax_quantization.png", width: 450pt)
]


#slide[
  = The outlier problem

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization",
    title: "Grootendorst (2024)",
  )

  What if some of the weights are *outliers*? This would map most of the weights to zero (or near zero):

  #set align(center + horizon)
  #image("img/lecture08/outlier_problem.png", width: 500pt)

  #set align(left)
  #v(0.5em)

  One solution: *clip the outliers*:
  #set align(center)
  #image("img/lecture08/outlier_clipping.png", width: 500pt)
]


#slide[
  = Dynamic quantization for activations

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization",
    title: "Grootendorst (2024)",
  )

  Model weights can be quantized offline, but *activations are dynamic* – they change with every input.

  #set align(center + horizon)
  #image("img/lecture08/dynamic_activations.png", width: 500pt)

  #set align(left)

  Solution: compute the quantization range *dynamically* at inference time:

  #set align(center)
  #image("img/lecture08/dynamic_quantization.png", width: 500pt)
]


#slide[
  = Extreme quantization: 1-bit models

  #source-slide("https://arxiv.org/abs/2310.11453", title: "Ma et al. (2024)")

  Can we go all the way down to *1-bit*? Each weight is either $-1$ or $+1$.

  #set align(center + horizon)
  #image("img/lecture08/1bit_quantization.png", width: 450pt)

  #set align(left)

  #v(0.5em)

  *BitNet* #link("https://arxiv.org/abs/2310.11453")[(Ma et al., 2024)] showed that 1-bit models can achieve competitive performance if trained from scratch with quantization in the loop.

  Multiplications become additions → massive speedup on specialized hardware.
]


#slide[
  = Quantization in practice

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-quantization",
    title: "Grootendorst (2024)",
  )

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    === GPTQ
    - Post-training quantization method.
    - Uses extra tricks to go robustly beyond 8-bit (6-bit, 4-bit, 2-bit).
    - Calibration on a small dataset.
  ][
    === GGUF
    - File format that performs *block-wise quantization*.
    - Enables offloading parts of the model to CPU.
    - Used by #link("https://github.com/ggml-ai/llama.cpp")[llama.cpp] and #link("https://ollama.com")[Ollama].
  ]

  #v(0.5em)

  #infobox(title: "Note")[Models in Ollama are quantized by default to 4-bit.]
]

#slide[
  = Quantization: summary

  #v(0.5em)

  #set text(size: 18pt)

  #table(
    columns: 4,
    align: (left, center, center, left),
    table.header([*Format*], [*Bits*], [*7B model size*], [*Notes*]),
    [float32], [32], [$approx$ 28 GB], [Baseline, rarely used],
    [float16], [16], [$approx$ 14 GB], [Standard for inference],
    [bfloat16], [16], [$approx$ 14 GB], [Preferred for training],
    [int8], [8], [$approx$ 7 GB], [Good accuracy, 2× savings],
    [int4], [4], [$approx$ 3.5 GB], [Popular for local deployment],
    [1-bit], [1], [$approx$ 0.9 GB], [Experimental, requires special training],
  )

  #set text(size: 20pt)
  #v(0.5em)

  The lower the precision, the more information we lose – but the savings can be dramatic.

  #warnbox(
    title: "Rule of thumb",
  )[Going from float16 to int4 reduces model size by $approx$ 4× with often less than 5% performance drop on standard benchmarks.]
]


// ============================================================
// SECTION 3: KNOWLEDGE DISTILLATION
// ============================================================

#section-slide(section: "Knowledge distillation")[Knowledge distillation]


#slide[
  = What is knowledge distillation?

  #source-slide("https://arxiv.org/abs/1503.02531", title: "Hinton et al. (2015)")

  #ideabox(
    title: "Idea",
  )[Train a small *student model* to mimic the behavior of a large *teacher model*, transferring the teacher's "knowledge" into a compact form.]

  #v(0.5em)

  Originally introduced by #link("https://arxiv.org/abs/1503.02531")[Hinton et al. (2015)] for classification models.

  #v(0.5em)

  - The student is *smaller and faster* than the teacher.
  - The student learns from the teacher's *soft outputs* (probability distributions), not just hard labels.
  - These soft outputs carry richer information about the relationships between classes.
]


#slide[
  = Teacher-student framework

  #source-slide("https://arxiv.org/abs/1503.02531", title: "Hinton et al. (2015)")

  The student is trained with a combination of two losses:

  #v(0.5em)

  + *Distillation loss*: KL divergence between the teacher's and student's output distributions (softened with a temperature $T$).
  + *Task loss*: standard cross-entropy loss with the ground truth labels.

  #v(-0.5em)

  $
    cal(L) = alpha dot underbrace(D_"KL" (p_T || p_S), "distillation loss") + (1 - alpha) dot underbrace(cal(L)_"CE" (y, p_S), "task loss")
  $

  #v(0.5em)

  The *temperature* $T$ controls how soft the distributions are:
  - $T = 1$: standard softmax.
  - $T > 1$: softer distributions → more information transferred.
]


#slide[
  = Why soft labels matter

  #source-slide("https://arxiv.org/abs/1503.02531", title: "Hinton et al. (2015)")

  Consider a classification example:

  #v(0.5em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    === Hard label
    - cat: *1.0*
    - dog: 0.0
    - car: 0.0
  ][
    === Soft label (teacher)
    - cat: *0.7*
    - dog: *0.2*
    - car: 0.1
  ]

  #v(0.5em)

  The soft label tells the student that "a cat is somewhat similar to a dog, but not to a car" – *the relationships between classes are preserved*.

  The same principle applies to LLMs: the teacher's token-level probability distribution carries much more signal than the argmax token alone.
]


#slide[
  = Distillation for LLMs

  In the context of LLMs, distillation is used in two main ways:

  #v(0.5em)

  + *White-box distillation*: we have access to the teacher's internal representations (logits, hidden states).
    - Train the student to match the teacher's output distribution at each token.
    - Can also match intermediate layer representations.

  #v(0.25em)

  + *Black-box distillation*: we only have access to the teacher's generated text.
    - Generate a large dataset using the teacher model.
    - Finetune the student on this synthetic dataset.
    - Much simpler, but less effective.

  #v(0.25em)

  #infobox(
    title: "Note",
  )[Black-box distillation is essentially what happens when smaller open models are trained on outputs from GPT-4 or Claude.]
]


#slide[
  = Distillation in practice

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    Distillation is widely used in production:

    - *DistilBERT*: 40% smaller, 60% faster, retaining 97% of BERT's performance.
    - *Alpaca*: LLaMA 7B finetuned on 52K GPT-3.5-generated instructions.
    - *DeepSeek-R1-Distill*: distilled reasoning model available in multiple sizes (1.5B–70B).

    #v(0.5em)

    #warnbox(
      title: "Caveat",
    )[Many model providers (OpenAI, Google) *prohibit distillation* from their models in their terms of service.]

  ][
    #set align(center + horizon)
    // TODO: add a figure showing distillation pipeline or DistilBERT comparison
    #rect(width: 200pt, height: 200pt, stroke: gray)[
      #set align(center + horizon)
      #set text(size: 14pt, fill: gray)
      _TODO: distillation pipeline figure_
    ]
  ]
]


// ============================================================
// SECTION 4: FINETUNING & LOW-RANK ADAPTATION
// ============================================================

#section-slide(section: "Finetuning & LoRA")[Finetuning & low-rank adaptation]


#slide[
  = The finetuning problem

  We saw that training a 7B model requires $approx$ *112 GB* of GPU memory (weights + gradients + optimizer states).

  #v(0.5em)

  This is a lot, even for a single GPU with 80 GB of VRAM (A100).

  #v(0.5em)

  #questionbox()[Can we finetune the model without updating *all* the parameters?]

  #v(0.5em)

  The general idea: *parameter-efficient finetuning (PEFT)* – update only a small number of parameters while keeping most of the model frozen.
]


#slide[
  = Low-rank adaptation (LoRA)

  #source-slide("https://arxiv.org/abs/2106.09685", title: "Hu et al. (2021)")

  #link("https://arxiv.org/abs/2106.09685")[Hu et al. (2021)] proposed *LoRA*: low-rank adaptation of large language models.

  #v(0.25em)

  #ideabox(title: "Key ideas")[
    - Instead of updating model weights $W$ directly, keep the update $Delta W$ in a *separate matrix*.
    - The $Delta W$ matrix has a *low rank* → it can be decomposed into two smaller matrices.
  ]

  #v(0.25em)

  $ W' = W + Delta W = W + B A $

  where $W in RR^(d times k)$, $B in RR^(d times r)$, $A in RR^(r times k)$, and $r << min(d, k)$.
]


#slide[
  = LoRA: how it works

  #source-slide("https://arxiv.org/abs/2106.09685", title: "Hu et al. (2021)")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    - The original model weights $W$ are *frozen* (no gradient updates).
    - Only the small matrices $A$ and $B$ are trained.
    - For a rank $r = 8$ and $d = 4096$: LoRA adds only $2 times 4096 times 8 = 65,536$ parameters per layer instead of $4096^2 approx 16.7M$.

    #v(0.5em)

    For inference, LoRA weights can be *merged* into the base model:
    $ W' = W + B A $
    → no additional latency at inference time.

    The LoRA weights can be stored as a separate *adapter* (typically a few MB).
  ][
    #set align(center + horizon)
    #image("img/lecture08/lora_diagram.png", width: 200pt)
  ]
]


#slide[
  = QLoRA: finetuning quantized models

  #source-slide("https://arxiv.org/abs/2305.14314", title: "Dettmers et al. (2023)")

  #ideabox()[Can we combine *quantization* and *LoRA* for even higher efficiency?]

  #grid(
    columns: (1.3fr, 1fr),
    gutter: 1em,
  )[
    *QLoRA* #link("https://arxiv.org/abs/2305.14314")[(Dettmers et al., 2023)]:
    - Quantize the base model to 4-bit (*NF4* – NormalFloat4).
    - Apply LoRA adapters in higher precision (bfloat16).
    - Optimize CPU-GPU memory transfers with *paged optimizers*.

    #v(0.25em)

    → Enables finetuning a *65B model on a single 48 GB GPU*.
  ][
    #set align(center + horizon)
    #image("img/lecture08/qlora_diagram.png", width: 300pt)
  ]
]


#slide[
  = LoRA and QLoRA in practice

  All things being equal: *full finetuning > LoRA > QLoRA* in terms of model performance.

  → The goal is to make the most out of the memory you have.

  #v(0.25em)

  #set text(size: 18pt)

  #table(
    columns: 3,
    align: (left, center, right),
    table.header([*Method*], [*Bits*], [*Memory (7B model)*]),
    [Full finetuning], [32], [$approx$ 120 GB],
    [Full finetuning], [16], [$approx$ 60 GB],
    [LoRA], [16], [$approx$ 16 GB],
    [QLoRA], [8], [$approx$ 10 GB],
    [QLoRA], [4], [$approx$ 6 GB],
  )

  #set text(size: 20pt)

  #source("https://github.com/hiyouga/LLaMA-Factory", title: "LLaMA-Factory")

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


// ============================================================
// SECTION 5: MIXTURE OF EXPERTS
// ============================================================

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

