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

  Until 2021, it seemed that the way to improve the models (lower their loss/perplexity on the training set) is *adding  more parameters*:

  #set align(center + horizon)
  #image("img/lecture06/model_sizes.png", width: 500pt)
]

#slide[
  = LLM scaling laws

  #source-slide("https://arxiv.org/abs/2001.08361", title: "Kaplan et al. (2020)")


  This trend was supported by the research from OpenAI #link("https://arxiv.org/abs/2001.08361")[(Kaplan et al., 2020)], who showed that larger models *learn more efficiently and can attain lower loss*:

  #set align(center + horizon)

  #image("img/lecture06/kaplan_scaling_laws.png", width: 600pt)
]


#slide[
  = LLM scaling laws

  #source-slide("https://arxiv.org/abs/2001.08361", title: "Kaplan et al. (2020)")

  According to Kaplan et al., test *loss $L$*  can be predicted solely based on $N$ (\# of parameters), $D$ (\# of training tokens), and $C$ (compute budget in FLOPs).

  They derived the following *empirical laws*:
  #v(-1em)

  #set text(size: 18pt)
  #set align(center + horizon)

  #bordered-box(padding: 10pt)[
    #{
      set par(leading: 0.35em)
      $
        L(N) = (N_c "/" N)^(alpha_N); & #h(1em) alpha_N approx 0.076, & #h(1em) N_c approx 8.8 times 10^13 & #h(0.5em) "parameters" \
        L(D) = (D_c "/" D)^(alpha_D); & #h(1em) alpha_D approx 0.095, & #h(1em) D_c approx 5.4 times 10^13 & #h(0.5em) "tokens" \
        L(C) = (C_c "/" C)^(alpha_C); & #h(1em) alpha_C approx 0.050, & #h(1em) C_c approx 3.1 times 10^8 & #h(0.5em) "PFLOP-days"
      $
    }
  ]

  #show: later

  #set align(left)
  #set text(size: 20pt)

  #infobox(title: "Example consequence")[
    Given a 10× increase in compute, Kaplan et al. suggest to increase model size $approx$ 5.5× but data only $approx$ 1.8×.
  ]
]




#slide[
  = LLM scaling laws

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-reasoning-llms",
    title: "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-reasoning-llms",
  )
  #v(-1em)

  #set align(center + horizon)

  #image("img/lecture06/grootendorst_scaling_overview.jpg", width: 500pt)

  #set align(left)

  #show: later


  #quote(
    attribution: "Kaplan et al. 2020",
  )[As the computational budget C increases, it should be spent primarily on larger models, without dramatic increases in training time or dataset size.]

  #set align(center + horizon)

  #v(-0.5em)

  #set align(left)

  → These findings lead to large models like GPT-3 (175B) being trained on relatively limited data ($approx$ 300B tokens).




]


#slide[
  = LLM scaling laws: Chinchilla models

  #source-slide("https://arxiv.org/abs/2203.15556", title: "Hoffmann et al. (2022)")

  Research from DeepMind (#link("https://arxiv.org/abs/2203.15556")[Hoffmann et al., 2022]) *challenged the scaling laws*.

  They trained on a wider range of $N$ and $D$ and found that they should be scaled *equally* ($C$ is the compute budget):

  $ N_"opt" prop C^a, #h(2em) D_"opt" prop C^b, #h(2em) a approx b approx 0.5 $

  #show: later


  Their Chinchilla (70B, 1.4T tokens) model outperformed another model Gopher (280B, 300B tokens), having 4× fewer parameters.

  #show: later


  #v(0.25em)

  #infobox(title: "Chinchilla scaling law")[
    For compute-optimal training, the number of training tokens should be $approx$ 20× the number of parameters.
  ]

]

#slide[
  = LLM scaling laws: Chinchilla models

  #source-slide("https://arxiv.org/abs/2203.15556", title: "Hoffmann et al. (2022)")

  → According to their findings, most existing LLMs at the time (GPT-3, Gopher, Megatron) were * undertrained*:

  #set align(center + horizon)


  #image("img/lecture06/chinchilla_tokens_vs_params.png", width: 300pt)

]



#slide[
  = Mind the inference

  #source-slide("https://arxiv.org/abs/2401.00448", title: "Sardana et al. (2024)")

  It may be also worth training *a smaller model on more data* to reduce inference cost #link("https://arxiv.org/abs/2401.00448")[(Sardana et al., 2024)]:
  #set align(center + horizon)
  #v(-1em)

  #image("img/lecture06/sardana_inference_cost.png", width: 700pt)

  #set align(left)



  → This was embraced by the Llama and Mistral models: *overtrain smaller models* so that they are cheaper at inference.
]

#slide[
  = The case of GPT-4.5

  #grid(
    columns: (1.3fr, 1fr),
    gutter: 1em,
    [
      #image("img/lecture06/gpt45_sam_altman_tweet.png", width: 320pt)

      #source("https://x.com/sama/status/1895203654103351462")

    ],
    [
      #image("img/lecture06/gpt45_api_pricing.png")
      #source("https://dev.to/aibyamdad/gpt-45-api-pricing-explained-is-it-really-worth-it-3fon", title: "dev.to")

      #image("img/lecture06/gpt45_openai_deprecations.png")

      #source("https://developers.openai.com/api/docs/deprecations", title: "OpenAI")

    ],
  )
]

#slide[
  = What can we scale next?

  Scaling *pretraining* has its limits:
  - We are running out of high-quality text data (see Lecture 5).
  - Training compute costs are enormous (\$100M+ for frontier models).
  - *Diminishing returns*: each 10× increase in compute yields smaller improvements.

  #questionbox()[Can you think of another way to improve model performance?]

  #show: later


  #ideabox(title: "Idea")[
    "Squeeze out" more from the models during inference → *test-time scaling.*
  ]
]


#section-slide(section: "Chain-of-thought")[Chain-of-thought prompting]

#slide[
  = Chain-of-thought (CoT) prompting

  #source-slide("https://arxiv.org/abs/2201.11903", title: "Wei et al. (2022)")
  #v(-0.5em)

  #ideabox()[#link("https://arxiv.org/abs/2201.11903")[Wei et al. (2022)]: LLMs struggle with math and multi-step reasoning. What if we showed them *how to do intermediate reasoning steps*?]

  #show: later


  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    #set align(center + horizon)

    #image("img/lecture06/cot_main_figure.png", width: 350pt)
  ][
    #set align(center + horizon)

    #image("img/lecture06/cot_meme_1.png", width: 150pt)
  ]

  → Dramatic improvement on arithmetic, commonsense, and symbolic reasoning.
]




#slide[
  = Zero-shot CoT: "Let's think step by step"

  #source-slide("https://arxiv.org/abs/2205.11916", title: "Kojima et al. (2022)")

  #v(-0.5em)

  #ideabox[#link("https://arxiv.org/abs/2205.11916")[Kojima et al. (2022)]: Writing out the steps is difficult. Do we need to do it at all?]

  #show: later

  #grid(
    columns: (1fr, 1.5fr),
    gutter: 1em,
  )[
    #set align(center + horizon)

    #image("img/lecture06/cot_meme_2.jpg", width: 200pt)

  ][
    #set align(center + horizon)
    #image("img/lecture06/cot_kojima_example.png", width: 400pt)
  ]

  → Prompting with *"Let's think step by step"* is enough to trigger reasoning behavior.
]


#slide[
  = Chain-of-thought (CoT) prompting
  #set align(horizon)


  #grid(
    columns: (1.8fr, 1fr),
    gutter: 1em,
    [

      - Can be applied to any instruction-tuned model.
        - Does not require more than appending (a variant of) "Think step-by-step" to the prompt.
      - Generally increases performance on problems requiring *multi-step reasoning*
        - Helps to break down complex problems into simpler subproblems.
      - Nowadays falling out of favor compared to *large reasoning models* trained to reason explicitly.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture06/cot_meme_3.png", width: 230pt)
    ],
  )
]


#slide[
  = Why does CoT work?

  #source-slide("https://arxiv.org/abs/2309.15402", title: "Chu et al. (2023)")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    Several hypotheses:
    - The "emergent" ability can be *learned from pretraining on code* data (#link("https://openreview.net/pdf?id=KIPJKST4gw")[Ma et al., 2024]\; #link("https://aclanthology.org/2024.emnlp-main.629.pdf")[Puerto et al., 2024]).
    - However, the model may be also just using *extended inference time* to perform more computation #link("https://openreview.net/forum?id=NikbrdtYvG")[(Pfau et al., 2024)].


  ][
    #image("img/lecture06/cot_why_works.png", width: 250pt)
  ]
  #warnbox(title: "CoT as an explanation?")[
    Research also shows that CoT may *not* reflect what is happening inside models.
  ]
]

#section-slide(section: "Test-time scaling")[Test-time scaling]


#slide[
  = Test-time scaling

  #source-slide("https://arxiv.org/abs/2203.11171", title: "Wang et al. (2022)")


  #ideabox(
    "Idea: test-time scaling",
  )[Can we make use of the reasoning capability to improve model performance without further training, solely at *inference time*?]

  #show: later

  #grid(
    columns: (1fr, 1.3fr),
    gutter: 1em,
  )[
    The simplest example of *test-time scaling*:

    - Generate multiple CoT paths for the given problem.
    - Use majority voting to select the final answer.

  ][
    #image("img/lecture06/self_consistency.png")
  ]
]

#slide[
  = Test-time scaling strategies

  #source-slide("https://arxiv.org/abs/2408.03314", title: "Snell et al. (2024)")

  More advanced extensions involve *tree search* and a verifying the solution with a *verifier model* (e.g., code interpreter):


  #set align(center + horizon)
  #image("img/lecture06/test_time_tree_search.png", width: 480pt)

]


#section-slide(section: "Reasoning models")[Large reasoning models]


#slide[
  = LLMs → LRMs

  #source-slide(
    "https://newsletter.languagemodels.co/p/the-illustrated-deepseek-r1",
    title: "https://newsletter.languagemodels.co/p/the-illustrated-deepseek-r1",
  )

  #ideabox()[What if we trained the model to *always produce the reasoning trace* before answering?]

  #show: later

  #set align(center)


  #image("img/lecture06/alammar_lrm_overview.png", width: 500pt)

  #set align(left)

  #v(1em)

  We call such a model a *large reasoning model (LRM)*.
]

#slide[
  = LLMs with CoT → LRMs

  #questionbox()[Why not just use the chain-of-thought prompting?]

  #show: later

  → Chain-of-thought reasoning is *not a robust capability*. It is largely an artifact of training data (most likely code data, #link("https://arxiv.org/pdf/2309.16298")[Ma et al., 2023]).
  #v(0.5em)

  → It is also *too simple*. Ideally, we would like to automate test-time scaling. That means giving the model the ability to:

  - Decompose the problem into subproblems.
  - Follow multiple reasoning paths.
  - Back-track from invalid paths.

]

#slide[
  = DeepSeek-R1: overview

  #source-slide("https://arxiv.org/abs/2501.12948", title: "DeepSeek-AI (2025)")

  *DeepSeek-R1* #link("https://arxiv.org/abs/2501.12948")[(DeepSeek-AI, 2025)]: the first *open* reasoning model. 671B parameters, competitive with OpenAI o1.

  Their recipe on how to build a strong reasoning model:
  #v(0.5em)


  #grid(
    columns: (1.2fr, 1fr),
    gutter: 1em,
    [


      1. Take a *base model* (they took their `deepseek-v3-base`).
      2. *Finetune* the model on a dataset of reasoning traces.
      3. Improve the reasoning process using *reinforcement learning*.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture06/alammar_deepseek_r1_recipe.png", width: 400pt)
      #source("https://newsletter.languagemodels.co/p/the-illustrated-deepseek-r1", title: "Jay Alammar (2025)")

    ],
  )
]


#slide[
  = DeepSeek-R1-Zero


  #questionbox()[Where to get the dataset with reasoning traces for Step 2?]

  #show: later

  #grid(
    columns: (1fr, 1.2fr),
    gutter: 1em,
    [
      Recipe of DeepSeek-R1-Zero:
      1. Apply the model with a *regular CoT prompting* on difficult problems.
      2. Automatically *verify the solutions*.
      3. *Reward* the model for good solutions with using RL.
    ],
    [
      #image("img/lecture06/deepseek_r1_zero_rl.png", width: 400pt)

    ],
  )

]

#slide[
  = DeepSeek-R1-Zero

  #source-slide("https://arxiv.org/abs/2501.12948", title: "DeepSeek-AI (2025)")

  During RL training, the model *spontaneously* learns to re-evaluate its reasoning and try alternative approaches:

  #set align(center)

  #image("img/lecture06/deepseek_r1_zero_aha_moment.jpg", width: 400pt)
]


#slide[
  = DeepSeek-R1-Zero: limitations

  #source-slide("https://arxiv.org/abs/2501.12948", title: "DeepSeek-AI (2025)")

  #questionbox()[Can we just use DeepSeek-R1-Zero as _the_ reasoning model?]

  Pure RL training has issues:

  - Early RL training is unstable and hard to get going.
  - The model mixes languages and produces messy formatting.
  - The model gets good at math/code but struggles with general tasks.

  #v(0.5em)


  → However, we can still use the model to *generate a dataset of reasoning traces* for the finetuning step.
]

#slide[
  = DeepSeek-R1: Full training pipeline


  #set align(center + horizon)
  #v(-1em)

  #image("img/lecture06/deepseek_r1_pipeline_full.png", width: 700pt)
]


#slide[
  = Distillation: smaller reasoning models

  #source-slide("https://arxiv.org/abs/2501.12948", title: "DeepSeek-AI (2025)")

  #ideabox()[Now we have a _strong_ reasoning model. Can we use its outputs to get a high-quality dataset of reasoning traces?]

  #show: later


  Yes: we can *finetune a model directly on the reasoning traces* of DeepSeek-R1-671B.

  → This idea lead to *distilled models* based on Llama and Qwen (between 1.5B to 70B).

  #show: later


  #infobox("Why distillation?")[
    Distillation -- in this context -- means finetuning a smaller model ("student") on the reasoning traces generated by a larger model ("teacher").
  ]
]


#slide[
  = Summary: how to build a reasoning model

  #source-slide("https://magazine.sebastianraschka.com/p/understanding-reasoning-llms", title: "Raschka (2025)")

  #set align(horizon)


  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.8em,
    rect(width: 100%, radius: 0.5em, fill: primary-color.lighten(95%), inset: 0.8em)[
      #text(weight: "bold", fill: primary-color)[Option 1: Pure RL]
      #v(0.3em)
      - Base LLM + RL with verifier rewards
      - Emergent reasoning
      - Unstable, poor readability

      → DeepSeek-R1-Zero
    ],
    uncover("2-")[
      #rect(width: 100%, radius: 0.5em, fill: primary-color.lighten(95%), inset: 0.8em)[
        #text(weight: "bold", fill: primary-color)[Option 2: SFT + RL]
        #v(0.3em)
        - SFT on reasoning traces, then RL
        - Stable training
        - Expensive

        → DeepSeek-R1, current frontier LRMs
      ]
    ],
    uncover("3-")[
      #rect(width: 100%, radius: 0.5em, fill: primary-color.lighten(95%), inset: 0.8em)[
        #text(weight: "bold", fill: primary-color)[Option 3: Pure SFT]
        #v(0.3em)
        - SFT on reasoning traces distilled  from the teacher model
        - Cheapest approach
        - Limited performance

        → distilled LRMs
      ]
    ],
  )

  #set text(size: 18pt)
  #v(0.5em)

  RL = reinforcement learning, SFT = supervised finetuning
]

#slide[
  = "Thoughtology"
  #source-slide("https://arxiv.org/abs/2504.07128", title: "Marjanović et al. (2025)")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      Many properties of reasoning models are *yet to be properly investigated*, such as:
      - How well does the trace reflect the internal thinking process?
      - What is the optimal length of the trace? Can we enforce certain length?
      - etc.
    ],
    [
      #set align(center + horizon)

      #v(-1.5em)
      #image("img/lecture06/thoughtology_paper.png", width: 300pt)
    ],
  )

  #set align(center + horizon)

  #v(-1.5em)
  #image("img/lecture06/thoughtology_overview.png", width: 500pt)
]

#slide[
  = When to use reasoning models

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    === Makes sense:
    - Math and logic problems
    - Complex coding tasks
    - Multi-step planning
  ][
    === A bit of an overkill:
    - Simple Q&A
    - Factual retrieval
    - Text summarization
  ]

  #v(0.5em)

  #warnbox(title: "Why not use reasoning models for all the tasks")[
    Reasoning models use *significantly more tokens* (→ cost and time), possibly up to 10--100× the output length of a regular instruction-tuned model.
  ]
]


#section-slide(section: "Practical aspects")[Practical aspects]


#slide[
  = What does reasoning look like in practice?

  Reasoning models typically wrap their *thinking traces* in `<think>` tags:

  #v(0.25em)

  #set text(size: 15pt)

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

  The thinking part is typically hidden from the user in chat interfaces.
]


#slide[
  = Accessing reasoning in APIs

  Open LLM APIs expose the reasoning content in a separate field.

  Example: vLLM (https://docs.vllm.ai/en/latest/features/reasoning_outputs):

  #set text(size: 14pt)
  ```python
  messages = [{"role": "user", "content": "9.11 and 9.8, which is greater?"}]
  response = client.chat.completions.create(model=model, messages=messages)

  reasoning = response.choices[0].message.reasoning
  content = response.choices[0].message.content
  ```


  #set text(size: 20pt)

  #warnbox(title: "Warning")[
    Full reasoning traces are typically *not* available with commercial models.

    For example, Google only offers so called "thinking summaries": https://ai.google.dev/gemini-api/docs/thinking

  ]
]

#slide[
  = Where to get LRMs
  Now there is quite a lot of open LRMs to choose from:

  #set align(center + horizon)

  #image("img/lecture06/vllm_supported_models.png", width: 350pt)
  #source-slide("https://docs.vllm.ai/en/latest/features/reasoning_outputs/#supported-models", title: "vLLM docs")

]

#section-slide(section: "LRMs and current frontiers")[LRMs and current frontiers]

#slide[
  = LRMs and current frontiers


  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #set align(center + horizon)

      #bordered-box[#image("img/lecture06/frontier_models_1.png", width: 320pt)]
      #bordered-box[#image("img/lecture06/frontier_models_2.png", width: 320pt)]

    ],
    [
      #set align(center + horizon)

      #bordered-box[#image("img/lecture06/frontier_models_3.png", width: 320pt)]
      #bordered-box[#image("img/lecture06/frontier_models_4.png", width: 320pt)]
    ],
  )

]

#slide[
  = LRMs and current frontiers
  #set align(center + horizon)

  #source-slide("https://agi.safe.ai", title: "https://agi.safe.ai")

  #image("img/lecture06/agi_safe_benchmarks.png")
]


#slide[
  = LRMs and current frontiers

  Reasoning models are the main driver of the remarkable results of LLMs in mathematical competitions and other difficult benchmarks:

  #v(0.5em)

  - *AIME 2024* (math olympiad difficulty-level problems): OpenAI o3 #link("https://openai.com/index/introducing-o3-and-o4-mini/")[scored 91.6%].
  - *International Mathematical Olympiad 2025*: both #link("https://deepmind.google/blog/advanced-version-of-gemini-with-deep-think-officially-achieves-gold-medal-standard-at-the-international-mathematical-olympiad/")[Google's Gemini] and #link("https://x.com/OpenAI/status/1946594928945148246")[OpenAI] models have started solving IMO problems at the gold-medal level.
  - *ARC-AGI:* benchmark for abstract reasoning, even its successor (ARC-AGI-2) is now #link("https://arcprize.org/leaderboard")[approaching saturation] (83.3% for GPT-5.4).
  - *Humanity's Last Exam (HLE)*: benchmark of questions that LLMs were not able to solve in 2024 → as of 03/26, #link("https://agi.safe.ai")[the best models have above 40%]
]


#slide[
  = Midterm feedback

  #set align(center + horizon)


  #set text(size: 24pt)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [

      #image("img/lecture06/feedback_form_icon.png", width: 50pt)

      Please fill in! 👇

      *#link("https://forms.gle/5vK6HhgPBhKHQAtB7")[https://forms.gle/5vK6HhgPBhKHQAtB7]*
    ],
    [
      #image("img/lecture06/feedback_form_qr.png", width: 300pt)
    ],
  )
]

#section-slide(section: "Summary")[Summary]

#slide[
  = Summary

  - *Scaling laws*: LLM performance follows predictable empirical laws based on model size, data size, and compute.
  - *Chain-of-thought*: prompting with intermediate reasoning steps dramatically improves multi-step reasoning.
  - *Test-time scaling*: using more compute at inference can be more efficient than scaling pretraining.
  - *Large reasoning models* (o1/o3, DeepSeek-R1, ...): train models to produce reasoning traces using RL and/or SFT.
  - Reasoning abilities are *rapidly improving*: math olympiad results, ARC-AGI saturation.
]


#slide[
  = Links and resources

  #set text(size: 16pt)

  - #link("https://arxiv.org/abs/2001.08361")[Kaplan et al. (2020): Scaling Laws for Neural Language Models]
  - #link(
      "https://arxiv.org/abs/2203.15556",
    )[Hoffmann et al. (2022): Training Compute-Optimal Large Language Models (Chinchilla)]
  - #link("https://arxiv.org/abs/2401.00448")[Sardana et al. (2024): Beyond Chinchilla-Optimal]
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
  - #link(
      "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-reasoning-llms",
    )[Maarten Grootendorst: A Visual Guide to Reasoning LLMs]
]
