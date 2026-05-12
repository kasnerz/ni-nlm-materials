#import "fit.typ": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#show: fit-theme.with(
  footer-content: "NI-NLM – 11 – Lecture",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Lecture 11",
  subtitle: "Philosophical and legal aspects of LLMs.",
  author: "Zdeněk Kasner",
  date: "05 May 2026",
)[]

#enable-handout-mode(true)


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
      - The person does not understand a word of Chinese -- they just follow a rulebook step by step.
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


      LLMs learn only by "tapping our telephone line", listening to our outputs without knowing the real world → they cannot give us good real-world advice.

    ],
  )
  #warnbox()[
    Their specific examples are already defeated with current LLMs (...although we can always move the goalposts). See also Yoav Goldberg's #link("https://gist.github.com/yoavg/9fc9be2f98b47c189a513573d902fb27")[critique].]

]

#slide[
  = LLMs are already smarter than octopuses

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
      ))[Knowing how words and expressions are used within the language system.]
    ],
  )
  #v(0.5em)


  → Since LLMs learn distributional regularities of symbols, they have genuine *structural understanding* of language in this view.
]


#slide[
  = Language models as agent models

  #source-slide("https://arxiv.org/abs/2212.01681", title: "Andreas (2022)")

  #ideabox()[When predicting the next word, the LM is also implicitly asking: *who would write this, and why?*]

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      - By the ways of training, LMs are *models of intentional agents*.

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

  Understanding in LLMs seems to be partially the victim of the "AI effect":

  #quote()[The *AI effect* is a phenomenon in which advances in artificial intelligence lead to a redefinition of what is considered intelligence, such that capabilities achieved by AI systems are no longer regarded as examples of "real" intelligence.
  ]
  #source("https://en.wikipedia.org/wiki/AI_effect", title: "https://en.wikipedia.org/wiki/AI_effect")


  #set align(left)

]


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

        → no good way to check for that.
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
  = Can LLMs achieve functional consciousness?


  From the talk of #link("https://arxiv.org/pdf/2303.07103")[David Chalmers (2023):]
  - There is no strong evidence that LLMs are conscious.
  - Any current evidence (self-reports, they "seem" conscious, intelligence, ...) is weak.
  - Arguments against: no embodiment, limited memory, no global workspace.
  - However, these limitations seem mostly temporary (see also #link("https://arxiv.org/pdf/2601.17060")[Shiller et al., 2026]).

  #show: later

  #infobox("Biological vs. silicon substrate")[
    If consciousness depends on having biological substrate, then LLM-based systems _cannot_ be conscious #link("https://www.nature.com/articles/s41599-024-03553-w")[(Overgaard & Kirkeby-Hinrup, 2024)]. There are some arguments for that (see e.g. #link("https://www.cambridge.org/core/journals/behavioral-and-brain-sciences/article/conscious-artificial-intelligence-and-biological-naturalism/C9912A5BE9D806012E3C8B3AF612E39A")[Seth (2025)]), but far from widely accepted.
  ]

]


#slide[
  = Can LLMs have at least a _degree_ of consciousness?

  Consciousness can have *various forms and degrees*. Some degree of consciousness #link("https://philiplow.foundation/consciousness/")[is attributed] also to mammals, birds, and other species including octopuses.

  #show: later

  #ideabox(
    "David Dennett's \"Intentional Stance\" (1987)",
  )[*Eliminativist view*: If something acts based upon intents, it needs to have a functional equivalent of consciousness. There may be nothing more to it.

    → LLMs may be already partially conscious according to this definition.]

  However, it can be argued that an LLM agent having an "intent" is not the same as being goal-directed by evolution in an environment, which leads to development of emotions, pain, etc.
]


#section-slide(section: "Legal aspects")[Legal aspects of AI]


#slide[
  = Why regulate AI?

  #questionbox()[Do you think we should regulate AI systems? Why?]
  #show: later


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
  = EU AI Act -- rules for generative AI

  #source-slide("https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32024R1689", title: "EUR-Lex")


  The most relevant parts for generative AI models are Articles 50 and 53:

  ==== Article 50: rules for generated content

  - Any chatbot that a user might mistake for a human *must identify itself as AI*.
  - Any image, audio, or video that is AI-generated *must be labeled* as such an output, including watermarking where technically feasible.

  #v(-0.5em)


  #show: later

  ==== Article 53: rules for general-purpose models
  - Providers need to *maintain and share up-to-date documentation* of the model training process and evaluation.
  - Providers need to *respect the EU copyright law* (including respecting opt-outs from the training process).
]




#slide[
  = AI Act: timeline

  #source-slide(
    "https://ai-act-service-desk.ec.europa.eu/en/ai-act/timeline/timeline-implementation-eu-ai-act",
    title: "European Commission",
  )


  The AI Act is being rolled out in phases:

  #grid(
    columns: (auto, 1fr),
    gutter: 1em,
    [*02/2025*], [Prohibitions on unacceptable-risk AI practices take effect.],
    [*08/2025*], [Rules for general-purpose AI models (including LLMs) take effect.],
    [*08/2026*],
    [Most AI Act rules take effect, including transparency obligations and rules for high-risk AI systems in Annex III.],

    [*08/2027*], [Rules for high-risk AI systems embedded in regulated products take effect.],
  )

  #v(0.5em)

  #infobox(
    "Digital Omnibus",
  )[Some of the rules can be delayed if the #link("https://digital-strategy.ec.europa.eu/en/library/digital-omnibus-regulation-proposal")[Digital Omnibus] suite of laws is accepted (the discussions are currently taking place).]
]


#section-slide(section: "Summary")[Summary]


#slide[
  = Summary

  *Understanding:*
  - There are some arguments that claim LLMs lack understanding.
  - However, LLMs can quite certainly possess _certain kinds_ of language understanding (namely structural).

  *Consciousness:*
  - Whether LLMs are conscious is far from being answered yet.

  *Legal aspects:*
  - EU AI Act: first comprehensive AI regulation world-wide, risk-based approach.
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
  - #link("https://arxiv.org/pdf/2303.07103")[Chalmers: Could a Large Language Model be Conscious? (2023)]
  - #link(
      "https://www.cambridge.org/core/journals/behavioral-and-brain-sciences/article/conscious-artificial-intelligence-and-biological-naturalism/C9912A5BE9D806012E3C8B3AF612E39A",
    )[Seth: Conscious Artificial Intelligence and Biological Naturalism (2025)]

  *Legal:*
  - #link("https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32024R1689")[Full text of the EU AI Act]
  - #link(
      "https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai",
    )[European Commission: AI Act overview]
  - #link(
      "https://ai-act-service-desk.ec.europa.eu/en/ai-act/timeline/timeline-implementation-eu-ai-act",
    )[European Commission: AI Act timeline]
]
