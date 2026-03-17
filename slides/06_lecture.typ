#import "fit.typ": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#show: fit-theme.with(
  footer-content: "NI-NLM – 06 – Lecture",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Lecture 6",
  subtitle: "Scaling laws, chain-of-thought, reasoning models",
  author: "Zdeněk Kasner",
  date: "24 Mar 2026",
)[]

#enable-handout-mode(true)


#section-slide(section: "Scaling laws")[Scaling laws]


#slide[
  = LLMs getting exponentially bigger

  Until 2021, it seemed that the way to improve the models is *adding  more parameters*:

  #set align(center + horizon)
  #image("img/lecture06/model_sizes.png", width: 550pt)

]


#slide[
  = LLM scaling laws

  #source-slide("https://arxiv.org/abs/2001.08361", title: "Kaplan et al. (2020)")

  #link("https://arxiv.org/abs/2001.08361")[Kaplan et al. (2020)] showed that language model *loss $L$ follows empirical laws*:

  #v(0.25em)


  #v(0.25em)
  $ L(N) approx (N_c / N)^(alpha_N), #h(1em) L(D) approx (D_c / D)^(alpha_D), #h(1em) L(C) approx (C_c / C)^(alpha_C) $
  $N$ = \# of parameters, $D$ = \# of training tokens, $C$ = compute budget (FLOPs).

  #set align(center + horizon)

  #image("img/lecture06/scaling_laws_simple_power_laws.png", width: 550pt)
]




#slide[
  = LLM scaling laws

  #source-slide("https://arxiv.org/abs/2001.08361", title: "Kaplan et al. (2020)")

  Kaplan et al.'s takeaway: for a *fixed compute budget*, it is better to train a *larger model on less data* (and stop early) than a smaller model on more data.

  #v(0.5em)

  #infobox(title: "Example")[
    Given a 10× increase in compute, Kaplan et al. suggest to increase model size $approx$ 5.5× but data only $approx$ 1.8×.
  ]


  → Large models like GPT-3 (175B) were trained on  limited data ($approx$ 300B tokens).

  #questionbox()[Which issues do you see with rapidly the number of model parameters?]
]


#slide[
  = LLM scaling laws: Chinchilla models

  #source-slide("https://arxiv.org/abs/2203.15556", title: "Hoffmann et al. (2022)")

  #link("https://arxiv.org/abs/2203.15556")[Hoffmann et al. (2022)] *challenged the Kaplan et al. scaling laws* by training models on a wider range of $N$ and $D$.
  They found that model size and data size should be scaled *equally*:
  #v(-1em)

  $ N_"opt" prop C^a, #h(2em) D_"opt" prop C^b, #h(2em) a approx b approx 0.5 $
  #v(0.5em)


  Their Chinchilla (70B, 1.4T tokens) model outperformed another model Gopher (280B, 300B tokens) with 4× fewer parameters.


  #v(0.25em)

  #infobox(title: "Chinchilla scaling law")[
    For compute-optimal training, the number of training tokens should be $approx$ 20× the number of parameters.
  ]

]

#slide[
  = LLM scaling laws: Chinchilla models

  #source-slide("https://arxiv.org/abs/2203.15556", title: "Hoffmann et al. (2022)")

  Most existing LLMs at the time (GPT-3, Gopher, Megatron) were * undertrained*:

  #set align(center + horizon)

  #image("img/lecture06/chinchilla_tokens_vs_params.png", width: 330pt)

]



#slide[
  = Mind the inference

  #source-slide("https://arxiv.org/abs/2401.00448", title: "Sardana & Frankle (2024)")

  If the model will be used for inference billions of times, it may be worth training *a smaller model on more data* to reduce inference cost.
  #set align(center + horizon)
  #v(-1em)

  #image("img/lecture06/screen-2026-03-17-13-45-31.png", width: 700pt)

  #set align(left)



  → This was embraced by the Llama and Mistral models: *overtrain smaller models* so that they are cheaper at inference.
]

#slide[
  = The case of GPT-4.5

  #grid(
    columns: (1.3fr, 1fr),
    gutter: 1em,
    [
      #image("img/lecture06/screen-2026-03-17-13-54-43.png", width: 320pt)

      #source("https://x.com/sama/status/1895203654103351462")

    ],
    [
      #image("img/lecture06/screen-2026-03-17-13-56-45.png")
      #source("https://dev.to/aibyamdad/gpt-45-api-pricing-explained-is-it-really-worth-it-3fon", title: "dev.to")

      #image("img/lecture06/screen-2026-03-17-13-58-05.png")

      #source("https://developers.openai.com/api/docs/deprecations", title: "OpenAI")

    ],
  )
]

#slide[
  = What can we scale next?

  Scaling *pretraining* has its limits:
  - We are running out of *high-quality text data* (see Lecture 5).
  - Training compute costs are *enormous* (\$100M+ for frontier models).
  - Returns are *diminishing*: each 10× in compute yields smaller improvements.

  #questionbox()[Can you think of another ways to improve model performance?]

  #ideabox(title: "Idea")[
    "Squeeze out" more from the models during inference → test-time scaling.
  ]
]


// ============================================================
// SECTION 2: CHAIN-OF-THOUGHT
// ============================================================

#section-slide(section: "Chain-of-thought")[Chain-of-thought prompting]


#slide[
  = The origin story

  #source-slide("https://arxiv.org/abs/2201.11903", title: "Wei et al. (2022)")


  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    #link("https://arxiv.org/abs/2201.11903")[Wei et al. (2022)]: LLMs struggle with math and multi-step reasoning. What if we showed them *how to do intermediate reasoning steps*?

    #v(0.5em)

    *Chain-of-thought (CoT) prompting*: include step-by-step reasoning examples in the prompt.

    #v(0.5em)

    → Dramatic improvement on arithmetic, commonsense, and symbolic reasoning tasks.
  ][
    #image("img/lecture06/cot_meme_1.png")
  ]
]


#slide[
  = Chain-of-thought prompting: the idea

  #source-slide("https://arxiv.org/abs/2201.11903", title: "Wei et al. (2022)")

  #set align(center + horizon)

  #image("img/lecture06/cot_main_figure.png", width: 600pt)
]


#slide[
  = Zero-shot CoT: "Let's think step by step"

  #source-slide("https://arxiv.org/abs/2205.11916", title: "Kojima et al. (2022)")


  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    #link("https://arxiv.org/abs/2205.11916")[Kojima et al. (2022)]: Finding good examples is tricky. Do we need to do that at all?

    #v(0.5em)

    Simply appending *"Let's think step by step"* to the prompt is enough to trigger reasoning behavior.

    #v(0.5em)

    #image("img/lecture06/cot_kojima_example.png", width: 350pt)
  ][
    #set align(center + horizon)
    #image("img/lecture06/cot_meme_2.jpg", width: 200pt)
  ]
]


#slide[
  = CoT: standard prompting technique

  Chain-of-thought prompting is nowadays a *standard* prompting method:

  #v(0.5em)

  - Generally increases performance on problems requiring *multi-step reasoning*.
  - Does not require more than appending (a variant of) *"Think step-by-step"* to the prompt.
  - *Works best with larger models* -- small models can generate plausible-looking but incorrect reasoning chains.

  #v(0.5em)

  #set align(center + horizon)
  #image("img/lecture06/cot_meme_3.png", width: 200pt)
]


#slide[
  = Why does CoT work?

  #source-slide("https://arxiv.org/abs/2309.15402", title: "Feng et al. (2024)")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    Several hypotheses:

    - The "emergent" ability can be *learned from pretraining on code* data #link("https://arxiv.org/abs/2402.09567")[(Ma et al., 2024)]; #link("https://arxiv.org/abs/2411.01259")[(Puerto et al., 2024)].
    - The model may be using *extended inference time* to perform more computation #link("https://arxiv.org/abs/2407.01687")[(Pfau et al., 2024)].
    - CoT makes the model *break down complex problems* into simpler subproblems that are within its capabilities.

    #v(0.5em)

    #warnbox(title: "Faithfulness")[
      The reasoning chain may *not* reflect the actual computation inside the model. The model can arrive at the correct answer for wrong reasons.
    ]
  ][
    #image("img/lecture06/cot_why_works.png")
  ]
]


#slide[
  = Self-consistency: sampling multiple paths

  #source-slide("https://arxiv.org/abs/2203.11171", title: "Wang et al. (2022)")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    CoT prompting generates a *single* reasoning path. But what if the model makes a wrong step?

    #v(0.5em)

    *Self-consistency* #link("https://arxiv.org/abs/2203.11171")[(Wang et al., 2022)]:
    + Generate *multiple* CoT reasoning paths for the same problem.
    + Use *majority voting* to select the final answer.

    #v(0.5em)

    → Uses more compute at test time, but substantially improves accuracy.
  ][
    #image("img/lecture06/self_consistency.png")
  ]
]


// ============================================================
// SECTION 3: TEST-TIME SCALING
// ============================================================

#section-slide(section: "Test-time scaling")[Test-time scaling]


#slide[
  = From pretraining scaling to test-time scaling

  #source-slide("https://arxiv.org/abs/2408.03314", title: "Snell et al. (2024)")

  CoT and self-consistency showed a new direction: *test-time compute scaling*.

  Instead of making the model bigger, give the model *more time to think* at inference.

  #v(0.5em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    === Pretraining scaling 📈
    - Bigger model
    - More data
    - More training compute
    - Fixed cost per query
  ][
    === Test-time scaling 🤔
    - Same model
    - More inference compute
    - *Variable* cost per query
    - Adaptive to problem difficulty
  ]

  #v(0.5em)

  #infobox()[Test-time compute scaling can be *more efficient* than pretraining scaling for hard problems #link("https://arxiv.org/abs/2408.03314")[(Snell et al., 2024)].]
]


#slide[
  = Test-time scaling strategies

  #source-slide("https://arxiv.org/abs/2408.03314", title: "Snell et al. (2024)")

  More advanced strategies involve *tree-like search* and *verification*:

  #set align(center + horizon)
  #image("img/lecture06/test_time_tree_search.png", width: 600pt)

  #set align(left)

  - *Best-of-N*: generate $N$ answers, pick the best using a verifier.
  - *Tree search*: explore multiple reasoning branches (beam search, MCTS).
  - *Verifiers*: reward models, code interpreters, or external tools for checking intermediate steps.
]


// ============================================================
// SECTION 4: REASONING MODELS
// ============================================================

#section-slide(section: "Reasoning models")[Large reasoning models]


#slide[
  = From prompting to training

  CoT works as a *prompting technique*, but the reasoning behaviour is not a part of the model itself.

  #v(0.5em)

  #questionbox()[What if we trained the model to *always reason* before answering?]

  #show: later

  #v(0.5em)

  *Large reasoning models (LRMs)*: models trained to produce detailed *reasoning traces* that include:
  - Problem decomposition
  - Intermediate reasoning steps
  - Self-correction and backtracking
  - Verification of intermediate results

  #v(0.5em)

  → The reasoning process is *internalized* into the model through training.
]


#slide[
  = Examples of reasoning models

  #set text(size: 16pt)

  #table(
    columns: (1fr, 0.5fr, 0.5fr, 1fr),
    inset: 0.5em,
    align: left,
    table.header[*Model*][*Provider*][*Year*][*Notes*],
    [o1, o3, o4-mini], [OpenAI], [2024--25], [Closed-source, first widely known LRMs],
    [DeepSeek-R1], [DeepSeek], [2025], [Open-source, 671B MoE + distilled variants],
    [Gemini 2.5 Pro/Flash], [Google], [2025], ["Thinking" mode],
    [Claude 3.7 Sonnet], [Anthropic], [2025], [Extended thinking],
    [QwQ, Qwen3], [Alibaba], [2025], [Open-source reasoning models],
    [GPT-OSS / Phi-4-reasoning], [Microsoft], [2025], [Open-source reasoning models],
  )

  #set text(size: 20pt)

  #v(0.5em)

  The key question: *how to train reasoning models?*
]


#slide[
  = DeepSeek-R1: overview

  #source-slide("https://arxiv.org/abs/2501.12948", title: "DeepSeek-AI (2025)")

  *DeepSeek-R1* #link("https://arxiv.org/abs/2501.12948")[(DeepSeek-AI, 2025)]: one of the first open-source reasoning models, competitive with OpenAI o1.

  #v(0.5em)

  #set align(center + horizon)
  #image("img/lecture06/alammar_deepseek_r1_training.jpg", width: 600pt)

  #source("https://newsletter.languagemodels.co/p/the-illustrated-deepseek-r1", title: "Jay Alammar (2025)")
]


#slide[
  = DeepSeek-R1-Zero: pure RL

  #source-slide("https://arxiv.org/abs/2501.12948", title: "DeepSeek-AI (2025)")

  *Step 1*: Can we get reasoning behaviour from RL alone, *without any supervised data*?

  #v(0.5em)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    *DeepSeek-R1-Zero*:
    + Start from a base LLM (DeepSeek-V3, no SFT).
    + Train with RL using *accuracy rewards* (verifier for math/code) and *format rewards* (rule-based).
    + The model *naturally learns* to produce longer reasoning traces, self-verify, and backtrack.
  ][
    #image("img/lecture06/deepseek_r1_zero_rl.png")
  ]

  #v(0.5em)

  #infobox(title: "\"Aha moment\"")[
    During RL training, the model *spontaneously* learns to re-evaluate its reasoning and try alternative approaches -- without being explicitly taught to do so.
  ]
]


#slide[
  = DeepSeek-R1-Zero: emergent reasoning

  #source-slide("https://arxiv.org/abs/2501.12948", title: "DeepSeek-AI (2025)")

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    The model responses get *progressively longer* during RL training -- the model learns to "think more":

    #image("img/lecture06/deepseek_r1_response_length.png")
  ][
    #image("img/lecture06/deepseek_r1_zero_aha_moment.png")

    Self-reflection and backtracking emerge naturally.
  ]
]


#slide[
  = DeepSeek-R1-Zero: limitations

  #source-slide("https://arxiv.org/abs/2501.12948", title: "DeepSeek-AI (2025)")

  Pure RL training has issues:

  - *Unstable cold start*: early RL training is volatile without a good starting point.
  - *Poor readability*: the model mixes languages and produces messy formatting.
  - *Missing general capabilities*: good at math/code but struggles with general tasks.

  #v(0.5em)

  → We need a more structured training pipeline.
]


#slide[
  = DeepSeek-R1: full training pipeline

  #source-slide("https://arxiv.org/abs/2501.12948", title: "DeepSeek-AI (2025)")

  #set align(center + horizon)

  #image("img/lecture06/deepseek_r1_pipeline.png", width: 600pt)

  #set align(left)

  #set text(size: 16pt)
  + *Cold start SFT*: fine-tune on a small set of long CoT examples (curated from R1-Zero outputs + human annotation) to bootstrap reasoning.
  + *Reasoning-oriented RL*: train with accuracy and format rewards on math/code.
  + *Rejection sampling + SFT*: generate many outputs, keep the best, combine with general SFT data for a balanced model.
  + *Diverse RL*: final RL stage with both reasoning rewards and human preference rewards (helpfulness, safety).
]


#slide[
  = GRPO: Group Relative Policy Optimization

  #source-slide("https://arxiv.org/abs/2501.12948", title: "DeepSeek-AI (2025)")

  DeepSeek-R1 uses *GRPO* instead of PPO for RL training:

  #v(0.5em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    - Standard RLHF uses PPO with a separate *critic (value) model* -- expensive to train and serve.
    - GRPO estimates the *baseline from a group of sampled outputs* instead:
      + Sample $G$ outputs for each prompt.
      + Compute rewards for each.
      + Normalize rewards within the group.
      + Update the policy based on relative quality.
  ][
    #set align(center + horizon)
    #image("img/lecture06/deepseek_grpo.png")
  ]
]


#slide[
  = DeepSeek-R1: results

  #source-slide("https://arxiv.org/abs/2501.12948", title: "DeepSeek-AI (2025)")

  DeepSeek-R1 achieves performance *competitive with OpenAI o1* across multiple benchmarks:

  #v(0.5em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    #image("img/lecture06/deepseek_aime_results.png")
  ][
    #image("img/lecture06/deepseek_math_performance.png")
  ]
]


#slide[
  = Distillation: smaller reasoning models

  #source-slide("https://arxiv.org/abs/2501.12948", title: "DeepSeek-AI (2025)")

  We don't always need a 671B model. *Distillation*: fine-tune smaller models on reasoning traces generated by DeepSeek-R1.

  #v(0.5em)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    #image("img/lecture06/deepseek_math_breakdown.png")
  ][
    Distilled models (1.5B--70B, based on Qwen and Llama) achieve strong results on math and coding tasks.

    #v(0.5em)

    #infobox()[
      Distillation is *much cheaper* than running the full RL pipeline -- but is limited by the teacher model's capabilities.
    ]
  ]
]


#slide[
  = Summary: three approaches to reasoning

  #source-slide("https://magazine.sebastianraschka.com/p/understanding-reasoning-llms", title: "Raschka (2025)")

  #set text(size: 16pt)

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.8em,
    rect(width: 100%, radius: 0.5em, fill: primary-color.lighten(95%), inset: 0.8em)[
      #text(weight: "bold", fill: primary-color)[Option 1: Pure RL]
      #v(0.3em)
      - Base LLM + RL with verifier rewards
      - Emergent reasoning
      - Unstable, poor readability
      - → DeepSeek-R1-Zero
    ],
    rect(width: 100%, radius: 0.5em, fill: primary-color.lighten(95%), inset: 0.8em)[
      #text(weight: "bold", fill: primary-color)[Option 2: SFT + RL]
      #v(0.3em)
      - SFT on reasoning traces, then RL
      - Stable training
      - Expensive
      - → DeepSeek-R1, OpenAI o1
    ],
    rect(width: 100%, radius: 0.5em, fill: primary-color.lighten(95%), inset: 0.8em)[
      #text(weight: "bold", fill: primary-color)[Option 3: Pure SFT]
      #v(0.3em)
      - SFT on distilled reasoning traces
      - Cheapest approach
      - Limited by teacher
      - → DeepSeek-R1-Distill, Sky-T1
    ],
  )

  #set text(size: 20pt)
]


#slide[
  = Three approaches: overview

  #source-slide("https://magazine.sebastianraschka.com/p/understanding-reasoning-llms", title: "Raschka (2025)")

  #set align(center + horizon)
  #image("img/lecture06/raschka_training_approaches.jpg", width: 550pt)
]


// ============================================================
// SECTION 5: FRONTIERS & PRACTICAL ASPECTS
// ============================================================

#section-slide(section: "Current frontiers")[Current frontiers]


#slide[
  = LLMs and math competitions

  Reasoning models have achieved remarkable results in mathematical competitions:

  #v(0.5em)

  - *AIME 2024*: OpenAI o3 scored in the top 0.1% of participants.
  - *International Mathematical Olympiad 2025*: both Google's Gemini and OpenAI models have started *solving IMO problems* at the gold-medal level.
  - *FrontierMath* #link("https://arxiv.org/abs/2411.04872")[(Glazer et al., 2024)]: benchmark of original, unpublished math problems -- initially \<2% solved, now approaching 25%+.

  #v(0.5em)

  #infobox()[
    These results were unthinkable just 2 years ago. Mathematical reasoning has been one of the biggest areas of improvement.
  ]
]


#slide[
  = ARC-AGI: pattern recognition challenge

  #source-slide("https://arcprize.org/", title: "ARC Prize")

  *ARC-AGI* #link("https://arxiv.org/abs/1911.01547")[(Chollet, 2019)]: a benchmark for abstract reasoning, designed to resist memorization.

  #v(0.5em)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    - Each task is a unique visual pattern puzzle with very few examples.
    - Humans solve $tilde$85% of tasks, LLMs historically struggled ($<$5%).
    - *ARC-AGI-1 is now close to saturation*: OpenAI o3 reached 87.5% in December 2024.
    - ARC-AGI-2 has been released as a harder successor.
  ][
    #todo[Insert ARC-AGI task example figure]
  ]
]


#slide[
  = Benchmark saturation revisited

  Reasoning models have *rapidly saturated* many benchmarks:

  #v(0.5em)

  #set text(size: 16pt)

  #table(
    columns: (1fr, 0.5fr, 0.5fr, 0.7fr),
    inset: 0.4em,
    align: left,
    table.header[*Benchmark*][*2023 SOTA*][*2025 SOTA*][*Status*],
    [MATH], [$approx$50%], [97.3%], [✅ Saturated],
    [GSM8K], [$approx$80%], [99%+], [✅ Saturated],
    [GPQA Diamond], [$approx$36%], [79.7%], [⚠ Close],
    [AIME 2024], [$approx$10%], [87%], [⚠ Close],
    [ARC-AGI-1], [$approx$5%], [87.5%], [⚠ Close],
    [SWE-bench Verified], [$approx$20%], [72%], [❌ Active],
    [HLE], [--], [53.1%], [❌ Active],
    [FrontierMath], [--], [$approx$25%], [❌ Active],
  )

  #set text(size: 20pt)

  #v(0.5em)

  → The community keeps releasing *harder benchmarks*: HLE #link("https://arxiv.org/abs/2501.14249")[(Phan et al., 2025)], FrontierMath, ARC-AGI-2, ...
]


#slide[
  = Open-source reasoning models

  The release of DeepSeek-R1 has catalyzed an *open-source reasoning ecosystem*:

  #v(0.5em)

  - *QwQ / Qwen3* (Alibaba): open-source reasoning models, various sizes.
  - *Phi-4-reasoning* (Microsoft): compact reasoning model based on Phi-4.
  - *Sky-T1* (NovaSky): trained with only 17k SFT samples for $tilde$\$450.
  - *Open-R1* (HuggingFace): community effort to reproduce DeepSeek-R1 training.
  - *LIMO* #link("https://arxiv.org/abs/2502.03387")[(Ye et al., 2025)]: reasoning with only 817 curated training examples.

  #v(0.5em)

  #infobox()[
    The barrier to training reasoning models is *rapidly dropping*. The key ingredients are public: RL algorithms (GRPO), open base models, and distillation from strong models.
  ]
]


#section-slide(section: "Practical aspects")[Practical aspects]


#slide[
  = What does reasoning look like in practice?

  Reasoning models produce *structured thinking traces* wrapped in `<think>` tags:

  #v(0.25em)

  #set text(size: 13pt)

  ```
  User: How many r's are in "strawberry"?

  <think>
  Let me count the r's in "strawberry" letter by letter.
  s-t-r-a-w-b-e-r-r-y
  r at position 3 → count: 1
  r at position 8 → count: 2
  r at position 9 → count: 3
  So there are 3 r's.
  </think>

  There are 3 r's in "strawberry".
  ```

  #set text(size: 20pt)

  The thinking part is typically *hidden* from the user in chat interfaces but *exposed through the API*.
]


#slide[
  = Accessing reasoning in APIs

  Most LLM APIs now expose reasoning content separately:

  #v(0.5em)

  #set text(size: 13pt)

  ```python
  from openai import OpenAI
  client = OpenAI()

  response = client.chat.completions.create(
      model="o4-mini",
      messages=[{"role": "user", "content": "How many r's in strawberry?"}]
  )

  # Reasoning trace (the "thinking" part)
  print(response.choices[0].message.reasoning_content)

  # Final answer
  print(response.choices[0].message.content)
  ```

  #set text(size: 20pt)

  #v(0.5em)

  The `reasoning_content` field (or equivalent) is available in OpenAI, Anthropic, and other APIs. Open models use `<think>...</think>` tags in the raw output.
]


#slide[
  = Thinking with Ollama

  For open reasoning models run locally, e.g. using Ollama:

  #v(0.5em)

  #set text(size: 13pt)

  ```python
  import ollama

  response = ollama.chat(
      model='deepseek-r1:8b',
      messages=[{'role': 'user', 'content': 'How many r\'s in strawberry?'}],
  )
  # Response includes <think>...</think> tags in the content
  print(response['message']['content'])
  ```

  #set text(size: 20pt)

  #v(0.5em)

  #infobox(title: "Thinking effort / budget")[
    Some APIs allow controlling the *thinking budget* -- how many tokens the model can use for reasoning. More thinking = better results but higher cost and latency.
  ]
]


#slide[
  = When to use reasoning models

  Reasoning models are *not always* the best choice:

  #v(0.5em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    === ✅ Good fit
    - Math and logic problems
    - Complex coding tasks
    - Multi-step planning
    - Scientific reasoning
    - Tasks requiring self-verification
  ][
    === ❌ Overkill
    - Simple Q&A / factual retrieval
    - Text summarization
    - Translation
    - Creative writing
    - Latency-sensitive applications
  ]

  #v(0.5em)

  #warnbox(title: "Cost")[
    Reasoning models use *significantly more tokens* (and thus cost and time) per query. The "thinking" tokens can be 10--100× the output length.
  ]
]


// ============================================================
// SUMMARY
// ============================================================

#section-slide(section: "Summary")[Summary]


#slide[
  = Summary

  - *Scaling laws*: LLM performance follows predictable power laws in model size, data size, and compute.
  - *Chinchilla*: model size and data should be scaled equally; most early LLMs were undertrained.
  - *Inference-aware scaling*: overtrain smaller models to reduce inference cost.
  - *Chain-of-thought*: prompting with intermediate reasoning steps dramatically improves multi-step reasoning.
  - *Test-time scaling*: using more compute at inference can be more efficient than scaling pretraining.
  - *Reasoning models* (o1/o3, DeepSeek-R1, ...): train models to produce reasoning traces using RL and/or SFT.
  - *DeepSeek-R1*: open-source reasoning model trained via cold-start SFT → RL → rejection sampling → diverse RL.
  - Reasoning abilities are *rapidly improving*: math olympiad results, ARC-AGI saturation.
]


#slide[
  = Links and resources

  #set text(size: 16pt)

  - #link("https://arxiv.org/abs/2001.08361")[Kaplan et al. (2020): Scaling Laws for Neural Language Models]
  - #link(
      "https://arxiv.org/abs/2203.15556",
    )[Hoffmann et al. (2022): Training Compute-Optimal Large Language Models (Chinchilla)]
  - #link("https://arxiv.org/abs/2401.00448")[Sardana & Frankle (2024): Beyond Chinchilla-Optimal]
  - #link("https://arxiv.org/abs/2201.11903")[Wei et al. (2022): Chain-of-Thought Prompting]
  - #link("https://arxiv.org/abs/2205.11916")[Kojima et al. (2022): Zero-shot CoT]
  - #link("https://arxiv.org/abs/2203.11171")[Wang et al. (2022): Self-Consistency]
  - #link("https://arxiv.org/abs/2408.03314")[Snell et al. (2024): Scaling LLM Test-Time Compute]
  - #link("https://arxiv.org/abs/2501.12948")[DeepSeek-AI (2025): DeepSeek-R1]
  - #link(
      "https://newsletter.languagemodels.co/p/the-illustrated-deepseek-r1",
    )[Jay Alammar: The Illustrated DeepSeek-R1]
  - #link(
      "https://magazine.sebastianraschka.com/p/understanding-reasoning-llms",
    )[Sebastian Raschka: Understanding Reasoning LLMs]
  - #link("https://github.com/hijkzzz/Awesome-LLM-Strawberry")[Awesome LLM Strawberry: reasoning model resources]
]
