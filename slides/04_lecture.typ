#import "fit.typ": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#show: fit-theme.with(
  footer-content: "NI-NLM – 04 – Lecture",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Lecture 4",
  subtitle: "LLM inference",
  author: "Zdeněk Kasner",
  date: "10 Mar 2026",
)[]

#enable-handout-mode(false)


#section-slide(section: "Text generation")[From training to text generation]


// #slide[
//   = Today's learning outcomes

//   After today's lecture, you should be able to:

//   - Understand how to *generate text* with a Transformer-based language model.
//   - Explain differences between *decoding algorithms* and the role of decoding parameters.
//   - *Choose a suitable LLM* for your task.
//   - *Run a LLM* locally on your computer or computational cluster.
// ]


#slide[
  = Recap: training

  #set text(size: 15pt)

  // Helper: numbered circle badge
  #let step-circle(n) = {
    box(baseline: -0.15em, circle(
      fill: primary-color,
      radius: 0.6em,
    )[#set align(center + horizon)
      #text(fill: white, weight: "bold", size: 12pt)[#n]])
  }

  // Helper: gray rounded box for model stage labels
  #let stage-box(content) = {
    box(
      fill: rgb("#f0f0f0"),
      radius: 5pt,
      inset: (x: 0.8em, y: 0.45em),
    )[#set align(center)
      #text(size: 13pt)[#content]]
  }

  // Helper: proper grey filled block arrow pointing down
  #let down-arrow = {
    box(width: 1.4em, height: 1.1em, inset: 0pt)[
      #align(center + horizon)[
        #polygon(
          fill: rgb("#c0c0c0"),
          (20%, 0%),
          (80%, 0%),
          (80%, 40%),
          (100%, 40%),
          (50%, 100%),
          (0%, 40%),
          (20%, 40%),
        )
      ]
    ]
  }

  // Helper: colored underline matching the primary color
  #let punderline(body) = underline(stroke: 1.5pt + primary-color, offset: 2pt, body)

  #grid(
    columns: (1fr, 10pt, 1.8fr),
    gutter: 2em,
    [
      // ===== LEFT COLUMN: Model stages =====
      #set align(center)
      #text(size: 20pt, weight: "bold")[Model stages:]

      // Subslide 1: random neural network only
      #v(0.2em)
      #stage-box[random neural network]
      #v(-0.2em)

      // Subslide 3: circle 1 + arrow + autocomplete + hint (together)
      #uncover((beginning: 3))[
        #step-circle("1") #h(0.2em) #down-arrow
        #v(-0.2em)
        #stage-box["autocomplete on steroids"]

        #text(size: 11pt, style: "italic", fill: muted-color)[base / foundational model]
        #v(-0.2em)
      ]

      // Subslide 5: circle 2 + arrow + assistant + hint (together)
      #uncover((beginning: 5))[
        #step-circle("2") #h(0.2em) #down-arrow
        #v(-0.2em)
        #stage-box[assistant]

        #text(size: 11pt, style: "italic", fill: muted-color)[instruction-tuned model]
        #v(-0.2em)
      ]

      // Subslide 7: circle 3 + arrow + helpful assistant (together, last)
      #uncover((beginning: 7))[
        #step-circle("3") #h(0.2em) #down-arrow
        #v(-0.2em)
        #stage-box[helpful assistant]
      ]
    ],
    [
      // ===== DOTTED SEPARATOR =====
      #align(center)[
        #line(
          angle: 90deg,
          length: 100%,
          stroke: (paint: rgb("#cccccc"), thickness: 1pt, dash: "dotted"),
        )
      ]
    ],
    [
      // ===== RIGHT COLUMN: Training stages =====

      // Subslide 2: header + stage 1 (pre-training + example)
      #uncover((beginning: 2))[
        #text(size: 20pt, weight: "bold")[Training stages:]

        #v(0.2em)

        // --- Stage 1: Pre-training ---
        #grid(
          columns: (auto, 1fr),
          column-gutter: 0.4em,
          align: horizon,
          step-circle("1"), text(size: 18pt, weight: "bold")[Pre-training 🌍 ],
        )
        #v(0.1em)
        #down-arrow
        #h(0.2em) #punderline[*Prague is the capital of Czechia*] _(...)_
      ]

      // Subslide 4: stage 2 (instruction tuning + example)
      #uncover((beginning: 4))[
        #v(0.6em)

        // --- Stage 2: Instruction tuning ---
        #grid(
          columns: (auto, 1fr),
          column-gutter: 0.4em,
          align: horizon,
          step-circle("2"), text(size: 18pt, weight: "bold")[Instruction tuning 💬 ],
        )
        #v(0.1em)
        #down-arrow
        #h(0.2em)
        #box[
          user: What is the capital of Czechia? \
          assistant: #punderline[*Prague*]
        ]
      ]

      // Subslide 6: stage 3 (human preference optimization + example)
      #uncover((beginning: 6))[
        #v(0.6em)

        // --- Stage 3: Human preference optimization ---
        #grid(
          columns: (auto, 1fr),
          column-gutter: 0.4em,
          align: horizon,
          step-circle("3"), text(size: 18pt, weight: "bold")[Human preference optimization 🧑‍⚖️ ],
        )
        #v(0.1em)
        #pad(left: 1.4em)[
          #h(0.2em)
          #box[
            user: What is the capital of Czechia? \
            answer \#1: Prague. \
            #punderline[*answer \#2:*] The capital of Czechia is Prague. It is the largest (...)
          ]
        ]
      ]
    ],
  )
]


#slide[
  = LLM inference

  #grid(
    columns: (1fr, 1.15fr),
    gutter: 1em,
    [
      #set align(horizon)

      This lecture: *LLM inference* = we have a trained model and we want to *use it*.
    ],
    [
      #image("img/lecture04/shoggothhh_header.jpg", width: 400pt)
    ],
  )


  #set align(left)

  #show: later

  #questionbox()[What is the difference between inference, generation, and decoding?]

]

#slide[
  = LLM Inference

  #let clr-inference = rgb("#7B3FA0")
  #let clr-generation = rgb("#5B8DD9")
  #let clr-decoding = rgb("#E05060")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    align: horizon,
    [
      #text(fill: clr-inference, weight: "bold", size: 20pt)[Inference]   --   The concept of using a trained model for *making predictions* on new data (for classification, sequence tagging, text generation, ...).

      #v(0.5em)
      #text(fill: clr-generation, weight: "bold", size: 20pt)[Generation]  --    The process of using a trained model for *producing a sequence of tokens*.

      #v(0.5em)
      #text(fill: clr-decoding, weight: "bold", size: 20pt)[Decoding] -- The algorithm of *selecting the next token* using the model's internal representation.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture04/nested_circles.svg", width: 100%)
    ],
  )
]


#slide[
  = Training vs. inference


  #let mk-token(pos, lbl) = node(
    pos,
    text(font: font-mono, size: 12pt)[#lbl],
    stroke: none,
    fill: none,
  )

  #let training-fig = diagram(
    node-stroke: none,
    node-fill: none,
    spacing: (0em, 1.6em),

    // Input tokens (y=0)
    mk-token((0, 0), [Prague]),
    mk-token((1, 0), [is]),
    mk-token((2, 0), [the]),
    mk-token((3, 0), [capital]),
    mk-token((4, 0), [of]),
    mk-token((5, 0), [Czechia]),

    // Invisible connector nodes at y=1 (one per column, for vertical edges)
    ..for i in range(6) {
      (node((i, 1), [], width: 1pt, height: 1pt, stroke: none, fill: none),)
    },

    // Invisible anchors to set the width of the Transformer box
    node((-0.3, 1), [], width: 1pt, height: 1pt, stroke: none, fill: none, name: <tl>),
    node((5.3, 1), [], width: 1pt, height: 1pt, stroke: none, fill: none, name: <tr>),

    node(
      enclose: (<tl>, <tr>),
      text(fill: white, weight: "bold", size: 18pt)[Transformer],
      fill: primary-color,
      stroke: none,
      inset: 0.8em,
      name: <tf>,
    ),

    // Vertical edges: input → connector (into the transformer)
    ..for i in range(6) {
      (edge((i, 0), (i, 1), "->"),)
    },

    // Output tokens (y=2)
    mk-token((0, 2), [is]),
    mk-token((1, 2), [the]),
    mk-token((2, 2), [capital]),
    mk-token((3, 2), [of]),
    mk-token((4, 2), [Czechia]),
    mk-token((5, 2), [\<EOS\>]),

    // Vertical edges: connector → output (out of the transformer)
    ..for i in range(6) {
      (edge((i, 1), (i, 2), "->"),)
    },
  )

  #let inference-fig = diagram(
    node-stroke: none,
    node-fill: none,
    spacing: (0.1em, 1.1em),

    // Prompt at x=1 (left part of the transformer)
    node(
      (1, 0),
      align(left)[
        #text(font: font-mono, size: 12pt)[
          user: Who are you? \
          assistant:
        ]
      ],
      stroke: none,
      fill: none,
      name: <prompt>,
    ),

    // Invisible connector at (1, 1) for vertical edge routing
    node((1, 1), [], width: 1pt, height: 1pt, stroke: none, fill: none),

    // Same width anchors as training diagram
    node((-0.3, 1), [], width: 1pt, height: 1pt, stroke: none, fill: none, name: <tl2>),
    node((5.3, 1), [], width: 1pt, height: 1pt, stroke: none, fill: none, name: <tr2>),

    node(
      enclose: (<tl2>, <tr2>),
      text(fill: white, weight: "bold", size: 18pt)[Transformer],
      fill: primary-color,
      stroke: none,
      inset: 0.8em,
      name: <tf2>,
    ),

    edge((1, 0), (1, 1), "->"),

    node((1, 2), text(size: 24pt)[🤔], stroke: none, fill: none),

    edge((1, 1), (1, 2), "->"),
  )

  #grid(
    columns: (1fr, 10pt, 1fr),
    gutter: 1em,
    [
      #set align(center)
      === Training

      #v(0.5em)
      #training-fig

      #v(1em)

      *Teacher forcing:* We know what token should come next, so we use it to train the model.
    ],
    [
      #align(center)[
        #line(
          angle: 90deg,
          length: 100%,
          stroke: (paint: rgb("#cccccc"), thickness: 1pt, dash: "dotted"),
        )
      ]
    ],
    [
      #set align(center)
      === Inference
      #inference-fig
      #v(0.8em)

      *Decoding:* We need to _select_ what token should come next.
    ],
  )
]




#slide[
  = Generating text: autoregressive decoding

  === 🧑‍🍳 Recipe: How to generate text autoregressively

  #item-by-item[
    + *Start with the context*: a sequence of tokens (a "prompt" if instruction-tuned).
    + *Feed the context* into the LLM.
    + *Select the next token* from the model-generated probability distribution.
    + *Append the selected token* to the sequence.
    + *Repeat* from (3) until the `EOS` (end-of-sequence) token is selected.
  ]
]


#slide[
  = What happens during LLM inference?

  #set align(center + horizon)

  === Inference for dummies 🐥

  #image("img/lecture04/screen-2026-03-03-09-27-17.png", width: 450pt)
  *#link("https://animatedllm.github.io/generation-simple")*
  #v(1em)
]

#slide[
  = What happens during LLM inference?

  #set align(center + horizon)

  === Advanced version 🎓


  #image("img/lecture04/screen-2026-03-03-09-57-20.png", width: 450pt)
  *#link("https://animatedllm.github.io/generation-model")*
  #v(1em)
]

#slide[
  = What happens during LLM inference?

  #set align(center + horizon)

  === Hardcore version 🤘

  #image("img/lecture04/screen-2026-03-03-09-23-44.png", width: 400pt)
  #v(0.5em)

  *#link("https://bbycroft.net/llm")*
  #v(1em)
]



#section-slide(section: "Decoding algorithms")[Decoding algorithms]

#slide[
  = Decoding the next token

  For each time step $t$, the decoder outputs *probability distribution* over the  tokens given the previous context $P(y_t | y_(1:t-1), X)$.
  #v(-0.5em)

  #set align(center + horizon)
  #image("img/lecture04/cross_entropy_model.svg")

  #set align(left)

  #v(1em)

  That is where the "job" of the Transformer decoder ends → it is up to us (or our decoding algorithm) to *use the distribution for decoding the next token*.

]

#slide[
  = Exact inference

  🏆 *Holy grail*: Find the most probable continuation to our prompt:
  #v(-1em)

  $ y^* = arg max_(y in cal(Y)) P(y) = arg max_(y in cal(Y)) product_(i=1)^(t) P(y_i | y_1, dots, y_(t-1)) $

  #questionbox()[
    Why is this not possible in practice?
  ]
  #show: later

  *Intractable* (exponential search space) → we need to approximate it.

  #show: later

  #questionbox()[
    And is it even our goal?
  ]

]



#slide[
  = Decoding algorithms

  #set align(center + horizon)

  Two approaches we typically combine in practice:
  #v(1em)


  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    [
      === Approximating the most probable sequence 🤔
      #v(1em)

      Greedy search / beam search
    ],
    [
      === Adding stochasticity 🎲
      #v(1em)


      Temperature / top-k sampling / nucleus (top-p) sampling
    ],
  )

]

#slide[
  = Greedy decoding

  #source-slide("https://huggingface.co/blog/how-to-generate", title: "HF Blog")

  #infobox("Algorithm")[
    In each step $t$, select the most probable token: $y_t = arg max_(y_t in cal(V)) P(y_t | y_1, dots, y_(t-1))$
  ]

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [

      - Very fast, often works satisfactorily (especially with LLMs).
      - Non-parametric (no hyperparameters to tune).
      - But: may produce sequences that are too generic.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture04/greedy_search_hf_blog.png", width: 280pt)
    ],
  )
]


#slide[
  = Beam search

  #source-slide("https://huggingface.co/blog/how-to-generate", title: "HF Blog")



  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [

      #infobox("Algorithm")[
        *Parameter $k$*: number of sequences (beams).

        Each step $t$:
        + Extend the sequences from step $t-1$ with all possible tokens.
        + Select the $k$ most probable sequences for step $t+1$.
      ]

    ],
    [
      #set align(center + horizon)
      #image("img/lecture04/beam_search_hf_blog.png", width: 300pt)
    ],
  )

  - $k=1$ → greedy decoding; larger $k$ → slower, but better approximation.
  - $k > 1$ allows re-ranking results.
]




#slide[
  = Adding stochasticity

  #source-slide("https://huggingface.co/blog/how-to-generate", title: "HF Blog")

  Instead of picking the most probable token, we can randomly sample the next token $y_t$ according to its conditional probability distribution:

  $ y_t tilde P(y_t | y_1, dots, y_(t-1)) $


  #set align(center + horizon)

  #image("img/lecture04/sampling_search_hf_blog.png", width: 400pt)

  #set align(left)

  #show: later

  #questionbox()[
    Why is this sampling from the entire vocabulary not a good idea?
  ]
]





#slide[
  = Top-k sampling

  #source-slide("https://huggingface.co/blog/how-to-generate", title: "HF Blog")

  Selecting the token in each step randomly from $k in {1, dots, |cal(V)|}$ most probable tokens. The truncated distribution is re-weighted using softmax.

  #v(0.5em)

  #set align(center + horizon)

  #image("img/lecture04/top_k_sampling_hf_blog.png", width: 500pt)

  #set align(left)

]


#slide[
  = Top-p (nucleus) sampling

  #source-slide("https://huggingface.co/blog/how-to-generate", title: "HF Blog")

  Sampling from the *nucleus*: set of the most probable tokens with combined probability summing to $p in (0, 1]$.

  Similar to top-k, but with a *variable* $k$ in each step.

  #v(0.5em)

  #set align(center + horizon)

  #image("img/lecture04/top_p_sampling_hf_blog.png", width: 500pt)

  #set align(left)
]

#slide[
  = Temperature

  The shape of the output distribution can be adjusted using the *temperature* $T$:

  $ "softmax"(z) = exp(z_t / T) / (sum_(j) exp(z_j / T)) $

  #set text(size: 18pt)

  #set align(center + horizon)

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 2em,
    [
      $T = 1$: *original distribution*
    ],
    [
      $T < 1$: *more peaked*

      ($T=0$ → greedy decoding)
    ],
    [
      $T > 1$: *more uniformly random*
    ],
  )
  #v(1em)

  #set align(center + horizon)

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 1em,
    [
      #image("img/lecture04/screen-2026-03-08-14-10-46.png")
    ],
    [
      #image("img/lecture04/screen-2026-03-08-14-10-22.png")
    ],
    [
      #image("img/lecture04/screen-2026-03-08-14-10-31.png")
    ],
  )

  #source-slide("https://cme295.stanford.edu/slides/fall25-cme295-lecture3.pdf", title: "CME295")
]

#slide[
  = Is greediness all you need?

  #set align(center + horizon)

  #v(-1em)

  #bordered-box(image("img/lecture04/greedy_meme.png", width: 600pt))

  #source(
    "https://www.reddit.com/r/MachineLearning/comments/1e42das/d_what_happened_to_creative_decoding_strategy/",
    title: "Reddit",
  )
]


// #section-slide(section: "Navigating the LLM zoo")[Navigating the LLM zoo]


// #slide[
//   = LLM size and capabilities

//   #source-slide(
//     "https://informationisbeautiful.net/visualizations/the-rise-of-generative-ai-large-language-models-llms-like-chatgpt/",
//     title: "informationisbeautiful.net",
//   )

//   #set align(center + horizon)
//   #image("img/lecture04/screen-2026-03-08-15-19-31.png", width: 800pt)
// ]


// #slide[
//   = HuggingFace: source of open LLMs

//   *HuggingFace*: the largest repository of open LLMs. As of March 2026, it contains ~2.7M models (many of these are derivatives).

//   #set align(center + horizon)

//   #bordered-box(image("img/lecture04/screen-2026-03-08-14-51-25.png", width: 500pt))
//   #source-slide("https://huggingface.co/models", title: "HuggingFace Models")
// ]


// #slide[
//   = Model sources and leaderboards

//   *Arena.ai*: Elo rating of LLMs: for a pair of answers from different models, users decide which is better.
//   #v(-0.5em)

//   #set align(center + horizon)
//   #bordered-box(image("img/lecture04/screen-2026-03-03-10-13-59.png", width: 450pt))

//   #source-slide("https://arena.ai/leaderboard", title: "Arena.ai")
// ]

// #slide[
//   = Model sources and leaderboards

//   *OpenRouter*: routing traffic to various LLM providers, tracks real model usage through their proxy.
//   #v(-0.5em)

//   #set align(center + horizon)
//   #bordered-box(image("img/lecture04/screen-2026-03-08-14-52-53.png", width: 650pt))
//   #source-slide("https://openrouter.ai/rankings", title: "OpenRouter")
// ]

// #slide[
//   = Model sources and leaderboards

//   *Artificial Analysis LLM Leaderboard*: rating LLMs across many dimensions (context, window size, price, speed, performance...).

//   Model performance is grouped under a single #link("https://artificialanalysis.ai/evaluations/artificial-analysis-intelligence-index")["Intelligence index"] (=combined score from 10 benchmarks).
//   #v(-0.5em)
//   #set align(center + horizon)
//   #bordered-box(image("img/lecture04/screen-2026-03-08-14-55-00.png", width: 550pt))
//   #source-slide("https://artificialanalysis.ai/leaderboards/models", title: "Artificial Analysis")
// ]


#section-slide(section: "Running LLMs locally")[Running LLMs locally]

#slide[
  = How to use LLMs
  #set align(center + horizon)

  #image("img/lecture04/screen-2026-03-08-14-59-33.png")
]

#slide[
  = How to use LLMs

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      === Proprietary APIs
      - OpenAI (ChatGPT, GPT-4o)
      - Anthropic (Claude)
      - Google (Gemini)
      - ...

      ✅ Easy to use, no hardware needed \
      ❌ Paid, no control over the model
    ],
    [
      === Open models (local)
      - Meta (Llama)
      - Mistral
      - Qwen
      - ...

      ✅ Free, full control \
      ❌ Requires hardware (GPU)
    ],
  )
]


#slide[
  = Frameworks for running open LLMs

  *HuggingFace transformers*: Python library for loading models from the HuggingFace model repository.

  #set align(center + horizon)

  #bordered-box(image("img/lecture04/hf_transformers_code.png", width: 650pt))

  #source-slide("https://huggingface.co/docs/transformers/llm_tutorial", title: "HF Transformers")
]


#slide[
  = Frameworks for running open LLMs

  *Ollama*: running LLMs locally, easy to use, focus on quantized models.

  #set align(center + horizon)

  #bordered-box(image("img/lecture04/ollama_screenshot.png", width: 500pt))

  #source-slide("https://ollama.com", title: "Ollama")
]


#slide[
  = Frameworks for running open LLMs

  *vLLM*: efficient library for serving of LLMs at scale.

  #set align(center + horizon)

  #bordered-box(image("img/lecture04/vllm_screenshot.png", width: 600pt))

  #source-slide("https://vllm.ai", title: "vLLM")
]

#slide[
  = Text generation

  #set align(center + horizon)

  #set text(size: 26pt)

  == Hands-on session 🧑‍💻


  http://tiny.cc/nlm-gen
]

// #slide[
//   = Text generation

//   #set align(center + horizon)

//   == Demo time 🧑‍💻

//   #v(1em)

//   👉 #link("https://huggingface.co/docs/transformers/llm_tutorial")[HuggingFace LLM tutorial]

//   👉 #link("https://mlabonne.github.io/blog/posts/2023-06-07-Decoding_strategies.html")[Decoding strategies tutorial]
// ]


#section-slide(section: "Summary")[Summary]


#slide[
  = Summary

  - *Terms*:
    - *inference* = using a trained model for predictions
    - *generation* = producing a sequence of tokens
    - *decoding* = selecting the next token.
  - *Greedy decoding* is the simplest approach
  - *beam search* improves it by keeping $k$ hypotheses.
  - *Stochastic methods* (top-k, top-p, temperature) add randomness to avoid repetitive and dull outputs.
  - Open LLMs can be run locally using *HuggingFace transformers*, *Ollama*, or *vLLM*.
]

#slide[
  = Links and resources

  #set text(size: 18pt)

  - #link("https://huggingface.co/models")[HuggingFace models]
  - #link("https://github.com/Hannibal046/Awesome-LLM")[Awesome LLM: curated list of resources]
  - #link("https://bbycroft.net/llm")[Transformer inference: 3D visualization]
  - #link("https://huggingface.co/blog/how-to-generate")[HuggingFace decoding algorithms overview]
  - #link("https://huggingface.co/docs/transformers/generation_strategies")[HuggingFace text generation strategies]
  - #link("https://huggingface.co/blog/common-generation-pitfalls")[Common pitfalls when generating text with LLMs]
  - #link("https://mlabonne.github.io/blog/posts/2023-06-07-Decoding_strategies.html")[Visualizing decoding strategies]
  - #link("https://arxiv.org/abs/2504.02115")[Minimum Bayes Risk decoding]
]

#slide[
  = Further reading

  - #link("https://aclanthology.org/D19-1331/")[*On NMT Search Errors and Model Errors: Cat Got Your Tongue?* (Stahlberg and Byrne, 2019)] -- what happens if one manages to approximate exact inference
  - #link("https://aclanthology.org/2022.tacl-1.58/")[*On decoding strategies for neural text generators* (Wiher et al., 2022)] -- language generation tasks vs. decoding strategies.
  - #link("https://aclanthology.org/2020.emnlp-main.170")[*If beam search is the answer, what was the question?* (Meister et al., 2020)] -- why does beam search work so well?
  - #link("https://aclanthology.org/2021.acl-long.22/")[*Understanding the properties of Minimum Bayes Risk decoding in neural machine translation* (Müller and Sennrich, 2021)] -- when can MBR be useful?
]




#section-slide(section: "Bonus: extra decoding algorithms")[Bonus: extra decoding algorithms]


#slide[
  = Minimum Bayes Risk (MBR) decoding

  #source-slide("https://arxiv.org/abs/2504.02115", title: "Minimum Bayes Risk Decoding")

  Selecting the sequence *most similar to other sequences* = "consensus decoding":

  $ y^* = arg max_(y_k in cal(Y)) sum_(y_ell in cal(Y) without {y_k}) "sim"(y_k, y_ell) $

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      #set align(horizon)

      - Useful for minimizing pathological behavior.
      - Intractable → we need a sampling algorithm.
      - Application in ASR and machine translation.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture04/mbr_decoding.jpg", width: 350pt)
    ],
  )



]


#slide[
  = Mirostat

  #source-slide("https://openreview.net/pdf?id=W1G1JZEIy5_", title: "Basu et al. (2021)")

  Aims to eliminate *repetition and incoherent text* in stochastic algorithms.


  #grid(
    columns: (0.7fr, 1fr),
    gutter: 1em,
    [


      Adapting the $k$ parameter based on the desired text perplexity.

      *Parameters*:
      - $tau$ -- the target perplexity
      - $eta$ -- learning rate
    ],
    [
      #set align(center + horizon)
      #image("img/lecture04/mirostat.png", width: 400pt)
    ],
  )

  #infobox("Mirostat")[

    "mirum" = surprise, "stat" = control
  ]

]


#slide[
  = (Locally) typical sampling

  #source-slide("https://aclanthology.org/2023.tacl-1.7/", title: "Meister et al. (2023)")




  Similar to Mirostat, but *dynamic*: the perplexity is not pre-specified.

  Ensures that in each  decoding step, text perplexity is *close to the model perplexity*.
  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [


      #v(0.5em)

      #infobox("Example: coin toss")[
        $p(H) = 0.75$, $p(T) = 0.25$:
        - $H H H H$ → most probable sequence
        - $H T H H$ → typical sequence
      ]
    ],
    [
      #set align(center + horizon)
      #image("img/lecture04/typical_sampling_plot.png", width: 100%)
    ],
  )
  Originates from the information theory: *typical messages* are the messages that we would expect from the process.
]





