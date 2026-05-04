#import "fit.typ": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#show: fit-theme.with(
  footer-content: "NI-NLM – 11 – Lecture",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Lecture 11",
  subtitle: "Understanding in LLMs, legal aspects.",
  author: "Zdeněk Kasner",
  date: "05 May 2026",
)[]

#enable-handout-mode(true)


// ============================================================
// SECTION 1: Understanding
// ============================================================

#section-slide(section: "Understanding")[Do LLMs understand language?]


#slide[
  = What does "understanding" mean?

  #questionbox()[What does it mean to understand language? And can an LLM understand it?]

  #show: later


  #v(1em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #set align(center + horizon)

      === Skeptics

      LLMs are sophisticated pattern matchers -- they mimic understanding without actually having it.

    ],
    [
      #set align(center + horizon)

      === Optimists

      LLMs can achieve structural understanding in principle and current models demonstrate they have it.
    ],
  )
]


#slide[
  = Searle's Chinese room

  #source-slide("https://doi.org/10.1017/S0140525X00005756", title: "Searle (1980)")

  *Chinese room*: a thought experiment by philosopher John Searle (1980):

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 2em,
    [
      - A person sits in a room and answers requests in Chinese.
      - The person  does not understand a word of Chinese -- they just follow a rulebook step by step.
      - From outside, the room _appears_ to understand Chinese.

    ],
    [
      #set align(center + horizon)
      #image("img/lecture11/screen-2026-05-04-11-06-53.png")
    ],
  )
  → By manipulating symbols, a system may pass behavioral tests and still have *no understanding of the language semantics*.
]


#slide[
  = ELIZA

  #source-slide("https://doi.org/10.1145/365153.365168", title: "Weizenbaum (1966)")




  #grid(
    columns: (1.8fr, 1fr),
    gutter: 1em,
    [

      *ELIZA*: a terminal-based program from 1966:


      - Mimicked a Rogerian psychologist (=the therapist often reflects back the patient's words to the patient).

      - Simple pattern matching and scripted responses.
      → Users attributed understanding and empathy.


    ],
    [
      #set align(center + horizon)
      #image("img/lecture11/ELIZA_conversation.png")
    ],
  )


  #infobox(
    "The ELIZA effect",
  )[The tendency to attribute genuine mental states (understanding, empathy, intention, ...) to a system based on superficial linguistic cues in its output.]

]


#slide[
  = Stochastic parrots & the octopus test


  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      🦜*Stochastic parrots* #link("https://dl.acm.org/doi/abs/10.1145/3442188.3445922")[(Bender et al., 2020)]

      LLMs stitch together plausible-sounding text without grounding it in meaning.

      This illusion can be harmful → we should not continue scaling LLMs.
    ],
    [
      🐙 *The octopus test* #link("https://aclanthology.org/2020.acl-main.463.pdf")[(Bender and Koller, 2020)]


      LLMs learn only by "tapping our telephone line", listening to our outputs without knowing the real world → they cannot give us real-world advice.

    ],
  )
  #warnbox()[
    Their specific examples are mostly defeated with current LLMs (...although we can always move the goalposts). See e.g. Yoav Goldberg's #link("https://gist.github.com/yoavg/9fc9be2f98b47c189a513573d902fb27")[critique].]

]

#slide[
  = LLMs are smarter than octopuses

  #source-slide(
    "https://docs.google.com/presentation/d/e/2PACX-1vRSPOn_gWUEb5XZ9tI9mSm_-Hou9D3dCm8huh-e1IuZnG7g0ACWRk5dWvMa18PU5W_keMduVMven2Yp/pub?start=false&loop=false&delayms=30000#slide=id.p",
    title: "NPFL140 (Lecture 12)",
  )

  #set align(center + horizon)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #image("img/lecture11/screen-2026-05-04-13-14-47.png")

      #source("https://aclanthology.org/2020.acl-main.463.pdf", title: "Bender and Koller (2020)")

    ],
    [
      #image("img/lecture11/screen-2026-05-04-13-14-39.png")

      #source("https://chatgpt.com", title: "GPT-4o")

    ],
  )

]


#slide[
  = What is "understanding", anyway?

  #source-slide("https://arxiv.org/abs/2102.04310", title: "Sahlgren & Carlsson (2021)")


  Understanding can be defined in different ways:

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 1em,

    [
      #infobox("Referential", icon: iconify("ph", "globe"))[Mapping expressions to objects and situations in the world.]
    ],
    [
      #infobox("Pragmatic", icon: iconify(
        "ph",
        "handshake",
      ))[Interpreting the speaker's communicative intent and social goals.]
    ],
    [
      #infobox("Structural", icon: iconify(
        "ph",
        "tree-structure",
      ))[Knowing how words and expressions are used  within the language system.]
    ],
  )

  Since LLMs learn distributional regularities of symbols, they have genuine *structural understanding* of language.


]


#slide[
  = Language models as agent models

  #source-slide("https://arxiv.org/abs/2212.01681", title: "Andreas (2022)")

  #ideabox()[When predicting the next word, the LM is also implicitly asking: *who would write this, and why?*]

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      - By the ways of training LMs are *models of intentional agents*.

      - Even without direct access to those mental states, an LM can *infer* them from text context.


    ],
    [
      #set align(center + horizon)
      #image("img/lecture11/lm_agent_bdi.png", width: 230pt)
    ],
  )
]



#slide[
  = The AI effect
  #set align(horizon)

  #set text(size: 22pt)

  #quote()[The AI effect is a phenomenon in which advances in artificial intelligence lead to a redefinition of what is considered intelligence, such that capabilities achieved by AI systems are no longer regarded as examples of "real" intelligence.
  ]
  #source("https://en.wikipedia.org/wiki/AI_effect", title: "https://en.wikipedia.org/wiki/AI_effect")


  #set align(left)

  #v(1em)

  (Undestanding != intelligence, but it is partially a victim of the same effect.)
]


// ============================================================
// SECTION 2: Consciousness
// ============================================================

#section-slide(section: "Consciousness")[Are LLMs conscious?]


#slide[
  = What is consciousness?

  *Consciousness* is one of the hardest problems in philosophy and cognitive science.

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      Two aspects are usually distinguished:

      - *Functional (access) consciousness*: information is globally available for reasoning, reporting, and action.

        → can be technically achieved with agents.

      - *Phenomenal consciousness (qualia)*: there is _something it is like_ to be in that state (the "hard" problem of consciousness).

        → no viable way to check for that.


    ],
    [
      #set align(center + horizon)
      #image("img/lecture11/Consciousness_phenomenal-functional_(en).png", width: 250pt)
      #source(
        "https://en.wikiversity.org/wiki/Artificial_Consciousness",
        title: "https://en.wikiversity.org/wiki/Artificial_Consciousness",
      )

    ],
  )
]


#slide[
  = Dennett's view of consciousness

  #ideabox(
    "Dennett's implication",
  )[If consciousness is functional and there is no sharp threshold, then asking "is the LLM conscious?" may be a *category error*. The more productive question: what functional states does it have?]


]


#slide[
  = The AI consciousness debate

  #source-slide("https://www.nature.com/articles/s41599-024-03553-w", title: "Dung & Candiotto (2024)")

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      *Arguments that LLMs might be conscious*
      - They produce coherent reports about "inner states".
      - Complexity and integration of representations may approach conditions associated with consciousness.
      - No agreed-on threshold exists -- the same arguments used to deny LLM consciousness could deny consciousness in many animals.
    ],
    [
      *Arguments against*
      - No body, no sensorimotor loop -- missing key aspects of embodied consciousness.
      - "Reporting" inner states in text ≠ having them -- a mirror doesn't experience what it reflects.
      - Current LLMs have no persistent memory, no continuous experience.
      - Similarity to human language does not mean similarity to human minds.
    ],
  )

  #v(0.5em)
  #warnbox()[This is an *open question*. The scientific and philosophical communities are far from consensus. Treat strong claims (either way) with skepticism.]
]



#section-slide(section: "Legal aspects")[Legal aspects of AI]


#slide[
  = Why regulate AI?

  #questionbox()[Do you think we should regulate AI systems? Why?]

  AI systems can cause real harm, some of which are not covered by existing laws:

  - *Misinformation*: realistic generated text or images used to deceive.
  - *Surveillance*: biometric identification at scale.
  - *Discrimination*: biased hiring/credit/medical decisions.
  - *Accountability gap*: it is hard to know _why_ an AI made a decision.
  - *Labor market disruption*: displacement of jobs.
  - *Concentration of power*: a few large actors control key infrastructure.


]


#slide[
  = EU AI Act

  #source-slide(
    "https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai",
    title: "European Commission",
  )

  The *EU AI Act* is the first comprehensive AI law worldwide.
  #grid(
    columns: (1.6fr, 1fr),
    gutter: 1em,
    [
      *Categories of risk:*
      - *Unacceptable risk* -- banned outright (e.g., social scoring, real-time biometric surveillance).
      - *High risk* -- strict requirements  (e.g., AI in hiring, credit, medical devices, critical infrastructure).
      - *Limited risk* -- transparency obligations (e.g., chatbots must disclose they are AI).
      - *Minimal or no risk* -- no special rules (e.g., spam filters, video games).
    ],
    [
      #set align(center + horizon)
      #image("img/lecture11/eu_ai_act_pyramid.jpg", width: 220pt)
    ],
  )
]



#slide[
  = General-purpose AI (GPAI) models

  #source-slide(
    "https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai",
    title: "European Commission",
  )

  LLMs are typically *general-purpose AI models* -- they can be integrated into many downstream systems.

  The AI Act has *specific rules for GPAI providers* (in force since August 2025):

  - *Transparency*: publish a summary of training data.
  - *Copyright*: comply with EU copyright law; allow rights holders to opt out.
  - *Technical documentation*: detailed documentation for downstream deployers.

  For GPAI models with *systemic risk* (very large compute, wide deployment):
  - Adversarial testing and red-teaming.
  - Serious incident reporting.
  - Cybersecurity measures.

]


#slide[
  = AI Act: timeline

  #source-slide(
    "https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai",
    title: "European Commission",
  )


  The AI Act is being rolled out in phases:

  #grid(
    columns: (auto, 1fr),
    gutter: (1em, 0.5em),
    [*02/2025*], [Prohibitions on unacceptable-risk AI practices take effect.],
    [*08/2025*], [Rules for *GPAI models* (including LLMs) take effect.],
    [*08/2026*], [Rules for *high-risk AI* systems (Annex I) and transparency obligations take effect.],
    [*08/2027*], [Rules for additional high-risk AI systems (Annex II) take effect.],
  )

  #v(0.5em)

  #infobox(
    "What this means for LLM providers",
  )[If you train or deploy a general-purpose AI model for use in the EU, you need to comply with GPAI rules now. Downstream systems built on top of LLMs may also fall into high-risk categories.]
]


#section-slide(section: "Summary")[Summary]


#slide[
  = Summary

  *Understanding:*
  - The Chinese Room and Stochastic Parrots arguments claim LLMs lack real understanding.
  - The Singleton Fallacy and LMs-as-Agent-Models papers push back: understanding is not binary, and LLMs do represent structural and intentional aspects of language.

  *Consciousness:*
  - Whether LLMs are conscious is philosophically murky and practically unanswered.
  - Dennett's functionalist view makes the question harder to answer -- and possibly less important than asking what functional states the model has.

  *Legal aspects:*
  - The EU AI Act introduces the first comprehensive AI law worldwide.
  - Risk-based: unacceptable → banned, high risk → strict rules, GPAI → transparency and documentation.
  - GPAI rules (covering LLMs) are already in effect since August 2025.
]


#slide[
  = Links and resources

  #set text(size: 16pt)

  *Understanding:*
  - #link("https://doi.org/10.1017/S0140525X00005756")[Searle: Minds, brains, and programs (1980)]
  - #link(
      "https://dl.acm.org/doi/10.1145/3442188.3445922",
    )[Bender et al.: On the Dangers of Stochastic Parrots (FAccT 2021)]
  - #link("https://arxiv.org/abs/2102.04310")[Sahlgren & Carlsson: The Singleton Fallacy (2021)]
  - #link("https://arxiv.org/abs/2212.01681")[Andreas: Language Models as Agent Models (EMNLP 2022)]

  *Consciousness:*
  - #link("https://www.nature.com/articles/s41599-024-03553-w")[Dung & Candiotto: AI consciousness and Dennett (2024)]
  - #link("https://philpapers.org/archive/LERTAF.pdf")[Lerike: Towards a Framework for AI Consciousness (2021)]

  *Legal:*
  - #link("https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32024R1689")[Full text of the EU AI Act]
  - #link(
      "https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai",
    )[European Commission: AI Act overview]
  - #link("https://ai-act-service-desk.ec.europa.eu/en")[AI Act Single Information Platform (FAQ)]
]
