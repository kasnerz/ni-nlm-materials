#import "fit.typ": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#show: fit-theme.with(
  footer-content: "NI-NLM – 05 – Lecture",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Lecture 5",
  subtitle: "Data and evaluation",
  author: "Zdeněk Kasner",
  date: "17 Mar 2026",
)[]

#enable-handout-mode(false)


#section-slide(section: "Training data")[Training data for LLMs]


#slide[
  = Different stages require different data

  #source-slide("https://arxiv.org/abs/2402.18041", title: "Liu et al. (2024)")


  #v(0.5em)


  #set align(center + horizon)

  #image("img/lecture05/data_stages.svg", width: 100%)
]


#slide[
  = Classic sources of pretraining data

  Early pre-trained models relied on smaller, *curated datasets* such as:

  #v(0.5em)

  - *Wikipedia*: very clean data, multilingual ($approx$ 4B words in English)
  - *BooksCorpus* #link("https://arxiv.org/abs/1506.06724")[(Zhu et al., 2015)]: 7,000 self-published books
  - *Project Gutenberg*: over 70k public-domain books
  - *The Pile* #link("https://arxiv.org/abs/2101.00027")[(Gao et al., 2020)]: 800 GB from 22 sources (academic, legal, code, ...)

  #v(0.5em)

  #infobox("BERT & GPT-2")[
    BERT used Wikipedia + BooksCorpus ($approx$ 16 GB of text).
    GPT-2 used WebText ($approx$ 40 GB, outbound links from Reddit that received at least 3 upvotes).
  ]
]


#slide[
  = Pretraining data: web-scale corpora

  Current pretraining is dependent on filtered #link("https://commoncrawl.org")[Common Crawl] snapshots:
  // Modern LLMs train on data scraped from the *entire web*. The main pipeline starts with *Common Crawl* -- a nonprofit that crawls the web monthly since 2007.

  #v(0.5em)

  #set text(size: 16pt)

  #table(
    columns: (0.8fr, 0.5fr, 0.4fr, 0.7fr),
    inset: 0.5em,
    align: left,
    table.header[*Dataset*][*Provider*][*Size* (approx).][*Note*],
    [C4 #link("https://arxiv.org/abs/1910.10683")[(Raffel et al., 2019)]],
    [#link("https://www.tensorflow.org/datasets/catalog/c4")[Google] / #link("https://huggingface.co/datasets/allenai/c4")[AllenAI]],
    [806 GB],

    [English-only],

    [mC4 #link("https://arxiv.org/abs/1910.10683")[(Raffel et al., 2019)]],
    [#link("https://www.tensorflow.org/datasets/catalog/c4#c4multilingual")[Google] / #link("https://huggingface.co/datasets/allenai/c4")[AllenAI]],
    [38.5 TB],
    [101 languages],

    [RefinedWeb #link("https://arxiv.org/abs/2306.01116")[(Penedo et al., 2023)]],
    [#link("https://www.tii.ae")[TII]],
    [2.8 TB],
    [English-only],

    [RedPajama v2 #link("https://arxiv.org/abs/2411.12372")[(Weber et al., 2024)]],
    [#link("https://huggingface.co/datasets/togethercomputer/RedPajama-Data-V2")[Together.AI + univ.]],
    [170 TB],
    [5 languages (en,de,fr,es,it)],

    [Dolma #link("https://arxiv.org/abs/2402.00159")[(Soldaini et al., 2024)]],
    [#link("https://huggingface.co/datasets/allenai/dolma")[AllenAI]],
    [11 TB],

    [Mostly English],
    [FineWeb #link("https://arxiv.org/abs/2406.17557")[(Penedo et al., 2024)]],
    [#link("https://huggingface.co/datasets/HuggingFaceFW/fineweb")[Huggingface]],
    [50 TB],

    [English-only],
  )


  #set text(size: 20pt)

  #infobox("Common Crawl")[Nonprofit that crawls the web monthly since 2007, has PBs of data in total.]

]


#slide[
  = Open pretraining dataset: Dolma
  *Dolma:* 11 TB of cleaned data from 200 TB of raw text.

  #image("img/lecture05/dolma_dataset_composition.png")

  #source-slide("https://arxiv.org/pdf/2402.00159", title: "Soldaini et al. (2024)")
]


#slide[
  = Pretraining data processing

  #source-slide("https://arxiv.org/abs/2402.18041", title: "Liu et al. (2024)")

  #set align(center + horizon)

  #image("img/lecture05/pretraining_data_pipeline.png")
]


#slide[
  = Pretraining data processing
  #set align(horizon)

  #item-by-item()[
    + *URL filtering*: remove known low-quality domains, adult content, spam
    + *Language identification*: keep only the target language(s) (e.g. using fastText)
    + *Text extraction*: strip HTML, boilerplate, navigation, ads.
    + *Quality filtering*: remove short/repetitive/low-quality pages
      - Heuristic rules (perplexity filtering, character ratios, ...)
      - Classifier-based (train a model to distinguish "good" from "bad" text)
    + *Deduplication*: remove near-duplicate documents (MinHash, n-gram overlap, ...)
    + *PII removal*: redact emails, phone numbers, addresses
    + *Toxic content filtering*: remove hate speech, harmful content
  ]

]


#slide[
  = How much data is there?
  #set align(center + horizon)

  We are approaching the limits of *human-generated text data* -- estimated to be exhausted by $approx$ 2028 for high-quality text.

  #source-slide("https://arxiv.org/abs/2211.04325", title: "Villalobos et al. (2022)")

  #image("img/lecture05/data_exhaustion_timeline.png", width: 600pt)

]


#slide[
  = Instruction tuning & preference optimization


  #questionbox()[Where can we get the data for instruction tuning and preference optimization?]

  #show: later

  - *Human annotators*: companies like Scale AI, Surge AI, or in-house teams.
  - *Crowdsourcing*: Amazon Mechanical Turk, Prolific
  - *Existing open datasets*: FLAN #link("https://arxiv.org/abs/2301.13688")[(Chung et al., 2022)], Open Assistant, Dolly
  - *Synthetic*: Generate data using a stronger LLM.


  #infobox()[For InstructGPT, OpenAI used around 40 human annotators #link("https://arxiv.org/abs/2203.02155")[(Ouyang et al., 2022).]]

]


#slide[
  = OpenAI & human annotators
  #set align(center)
  #v(-1em)

  #image("img/lecture05/openai_human_annotators.png", width: 550pt)

  #grid(
    columns: (1fr, 3fr, 1fr),
    gutter: 1em,
    [

    ],
    [
      #grid(
        columns: (1fr, 1fr, 1fr),
        gutter: 1em,
        [#set align(left)

          #source(
            "https://www.theguardian.com/technology/2024/apr/16/techscape-ai-gadgest-humane-ai-pin-chatgpt",
            title: "The Guardian",
          )
        ],
        [
          #set align(left)

          #source("https://weafrica24.com/2025/02/07/the-crucial-role-of-african-data-annotat/", title: "WeAfrica24")
        ],

        [
          #set align(left)

          #source(
            "https://time.com/6247678/openai-chatgpt-kenya-workers/",
            title: "Time.com",
          )
        ],
      )
    ],
    [

    ],
  )
]


#slide[
  = Finetuning for specific tasks

  #source-slide("https://arxiv.org/abs/2402.18041", title: "Liu et al. (2024)")

  Beyond instruction tuning, LLMs can be *finetuned on task-specific datasets* such as:


  #set text(size: 15pt)


  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 1em,
    rect(width: 100%, radius: 0.5em, fill: gray.lighten(90%), inset: 1em, align(center)[
      #iconify("ph", "question") *Question answering*\
      SQuAD, HotpotQA
    ]),
    rect(width: 100%, radius: 0.5em, fill: gray.lighten(90%), inset: 1em, align(center)[
      #iconify("ph", "article") *Summarization*\
      CNN/DailyMail, XSum
    ]),
    rect(width: 100%, radius: 0.5em, fill: gray.lighten(90%), inset: 1em, align(center)[
      #iconify("ph", "smiley") *Sentiment analysis*\
      SST-2, IMDB
    ]),

    rect(width: 100%, radius: 0.5em, fill: gray.lighten(90%), inset: 1em, align(center)[
      #iconify("ph", "scales") *Natural language inference*\
      MNLI, SNLI
    ]),
    rect(width: 100%, radius: 0.5em, fill: gray.lighten(90%), inset: 1em, align(center)[
      #iconify("ph", "translate") *Machine translation*\
      WMT datasets, FLORES
    ]),
    rect(width: 100%, radius: 0.5em, fill: gray.lighten(90%), inset: 1em, align(center)[
      #iconify("ph", "tag") *Named entity recognition*\
      CoNLL-2003, OntoNotes
    ]),

    rect(width: 100%, radius: 0.5em, fill: gray.lighten(90%), inset: 1em, align(center)[
      #iconify("ph", "folders") *Text classification*\
      AG News, DBpedia
    ]),
    rect(width: 100%, radius: 0.5em, fill: gray.lighten(90%), inset: 1em, align(center)[
      #iconify("ph", "arrows-merge") *Semantic similarity*\
      STS-B, QQP
    ]),
    rect(width: 100%, radius: 0.5em, fill: gray.lighten(90%), inset: 1em, align(center)[
      #iconify("ph", "chat-dots") *Task-oriented dialogue*\
      MultiWOZ, DailyDialog
    ]),
  )

  #set text(size: 20pt)

  Most task-specific datasets are now published at #link("https://huggingface.co/datasets")[HuggingFace Datasets].
]


#slide[
  = Synthetic data

  *Synthetic data* is becoming increasingly important:

  #v(0.5em)

  - *Pretraining data*: "textbook-quality" data → Phi models #link("https://arxiv.org/abs/2306.11644")[(Gunasekar et al., 2023)].
  - *Synthetic instruction data*: using LLM to generate instruction-response pairs.
  - *Synthetic preference data*: using LLM feedback instead of human feedback (RLAIF).
  - *Data augmentation*: paraphrasing, back-translation, perturbation.

  #v(0.5em)

  #infobox(
    title: "Model collapse",
  )[Training on synthetic data from previous model generations can lead to *model collapse* -- progressive degradation of quality #link("https://arxiv.org/abs/2305.17493")[(Shumailov et al., 2023)].]
]

#section-slide(section: "Model sources")[Where to find the LLMs?]



#slide[
  = HuggingFace: source of open LLMs

  *HuggingFace*: the largest repository of open LLMs.

  #show: later

  As of March 2026, it contains \~2.7M models (many of these are derivatives).

  #set align(center + horizon)

  #bordered-box(image("img/lecture04/screen-2026-03-08-14-51-25.png", width: 500pt))
  #source-slide("https://huggingface.co/models", title: "HuggingFace Models")
]

#slide[
  = Ollama: repository of quantized models

  *Ollama*: quantized variants of open LLMs.

  #set align(center + horizon)

  #bordered-box(image("img/lecture04/ollama_screenshot.png", width: 500pt))

  #source-slide("https://ollama.com/library", title: "Ollama")
]



#section-slide(section: "Evaluating LLMs")[Evaluating LLMs]


#slide[
  = Intrinsic vs. extrinsic evaluation

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    === #iconify("ph", "microscope") Intrinsic evaluation

    Evaluates a *specific quality of the model in isolation*.

    Can be measured automatically.

    #infobox("Examples")[
      - Perplexity
      - Accuracy on a benchmark
      - Fluency, grammaticality, ...
    ]

  ][
    === #iconify("ph", "users") Extrinsic evaluation

    Evaluates the model *in the context of a downstream system*.

    Usually requires users.

    #infobox("Examples")[
      - User satisfaction
      - Time to finish a task
      - Successful cases after deployment
    ]
  ]
]

#slide[
  = What we will cover

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      === #iconify("ph", "microscope") Intrinsic evaluation
      - *Perplexity*: how well can the model predict the next token
      - *Standard benchmarks*
        - *Accuracy / F1-score*: when we can match the answer exactly
        - *Text similarity metrics*: for comparing textual answers
        - *LLM-as-a-judge*: for flexible evaluation
    ],
    [
      === #iconify("ph", "users") Extrinsic evaluation

      - *Agentic benchmarks*: benchmarks based on completing tasks
      - *LM arenas*: human preference judgements on custom tasks
      - *Real-world traffic*: how people are actually using the models
    ],
  )
]

#slide[
  = Perplexity

  #questionbox()[How would you measure how well LMs do language modeling itself?]

  #show: later

  *Perplexity*: Measures how "surprised" the model is by  the next word:

  $ "PPL" = exp(-1/N sum_(i=1)^(N) log P(x_i | x_1, dots, x_(i-1))) $

  - *Lower is better* -- the model assigns higher probability to the actual text.
  - Directly related to cross-entropy loss from training.
  - However, a model can have low perplexity and still not be very useful.
]


#slide[
  = How good _actually_ are the LLMs?

  *Artificial Analysis LLM Leaderboard*: the "Intelligence index" (→ aggregated performance on 10 benchmarks) + price, speed, latency...
  #v(-1em)

  #set align(center + horizon)
  #bordered-box(image("img/lecture04/screen-2026-03-08-14-55-00.png", width: 600pt))
  #source-slide("https://artificialanalysis.ai/leaderboards/models", title: "Artificial Analysis")

  #set align(left)

  → We will focus mostly on the "intelligence" part: how to evaluate *model outputs*.

]


#section-slide(section: "Benchmarks")[Benchmarks]


#slide[
  = Benchmarks

  *Benchmarks*: standardized test sets with ground-truth answers.

  Allow to compare models on a numerical scale based on evaluation metric results.
  #v(0.5em)

  *Example of benchmarks:*

  #set text(size: 16pt)

  #table(
    columns: (1fr, 1fr, 1fr),
    inset: 0.5em,
    align: left,
    table.header[*Benchmark*][*What it tests*][*Format / evaluation*],
    [MMLU #link("https://arxiv.org/abs/2009.03300")[(Hendrycks et al., 2021)]],
    [World knowledge (57 subjects)],
    [4-choice MCQA],

    [HellaSwag #link("https://arxiv.org/abs/1905.07830")[(Zellers et al., 2019)]],
    [Commonsense reasoning],
    [4-choice MCQA],

    [GSM8K #link("https://arxiv.org/abs/2110.14168")[(Cobbe et al., 2021)]], [Grade school math], [Free-form answers],
    [HumanEval #link("https://arxiv.org/abs/2107.03374")[(Chen et al., 2021)]], [Code generation], [Unit tests],
    [GPQA #link("https://arxiv.org/abs/2311.12022")[(Rein et al., 2023)]], [Graduate-level science QA], [MCQA],
    [SWE-bench #link("https://arxiv.org/abs/2310.06770")[(Jimenez et al., 2024)]],
    [Real-world SW engineering],
    [Unit tests],

    [HLE #link("https://arxiv.org/abs/2501.14249")[(Phan et al., 2025)]], [Expert-level questions], [Free-form answers],
  )
]

#slide[
  = Is our model "state-of-the-art"?


  #source-slide(
    "https://blog.google/products-and-platforms/products/gemini/gemini-3/#gemini-3",
    title: "A new era of intelligence with Gemini 3",
  )
  #set align(center + horizon)
  #v(-1em)

  #image("img/lecture05/gemini_3_table_final_HLE_Tools_on.gif")
]

#slide[
  = Evaluating MCQA benchmarks


  #questionbox()[How to extract the answer in multiple-choice question answering benchmarks?]

  #show: later

  #set text(size: 15pt)

  #grid(
    columns: (0.8fr, 1fr, 1fr),
    gutter: 0.7em,
  )[
    === 1) Generate a letter
    ```python
    prompt = f"""{question}
    A) {a} B) {b} C) {c} D) {d}
    Answer:"""

    response = llm.generate(prompt)
    answer = parse_letter(response)
    ```
  ][
    === 2) Highest logprob letter
    ```python
    prompt = f"""{question}
    A) {a} B) {b} C) {c} D) {d}
    Answer:"""

    logprobs = llm.logprobs(
      prompt, tokens=["A","B","C","D"])
    answer = argmax(logprobs)
    ```
  ][
    === 3) Highest logprob answer
    ```python
    answers = [
      f"{question}\nAnswer: {a}",
      f"{question}\nAnswer: {b}",
      f"{question}\nAnswer: {c}",
      f"{question}\nAnswer: {d}"]
    probs = [llm.score(a) for a in answers]
    answer = argmax(probs)
    ```
  ]

  #set text(size: 20pt)

  Experiments from #link("https://magazine.sebastianraschka.com/p/llm-evaluation-4-approaches")[Sebastian Raschka] on MMLU: (1) 21.48%, (2) 34.44%, (3) 31.85% acc.
]


#slide[
  = Parsing matters more than you think

  #source-slide("https://arxiv.org/abs/2402.01781", title: "Alzahrani et al. (2024)")


  Changing the order or letters of answer options (A, B, C, D) can change the model ranking:

  #v(-2em)

  #set align(center + horizon)

  #bordered-box(image("img/lecture05/mcqa_answer_order_sensitivity.png", width: 500pt))
]


#slide[
  = Free-form evaluation

  No single correct answer with *open-ended outputs* (summarization, translation, ...)

  How to compare these?

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[

    #infobox("Reference-based metrics")[
      Compare the output against one or more *reference texts*.
      - Lexical / semantic similarity
      - LLM-as-a-judge
    ]

    (But is the reference good on its own?)
  ][
    #infobox("Reference-free metrics")[
      Evaluate the output *without* a reference.
      - LLM-as-a-judge
      - Human evaluation
    ]
    (But how to standardize this eval?)
  ]
]

#slide[
  = Reference-based metrics: lexical overlap


  *Lexical similarity*: compares how much the output and reference are similar in terms of word/character-level n-grams.

  #v(0.25em)

  *Example:* #link("https://dl.acm.org/doi/10.3115/1073083.1073135")[BLEU] score= exp(weighted average of *n-gram precisions*)  ×  brevity penalty


  #grid(columns: (1fr, 1fr), gutter: 1em)[
    ```
    Ref: "the capital of france is paris"
    Hyp: "paris is the capital of france"
    ```
  ][
    #set align(center + horizon)

    →  #link("https://mathewshen.me/bleuscore/")[BLEU-2] (up to 2-grams): 77.4%
  ]

  #v(0.25em)

  *Other metrics*: #link("https://aclanthology.org/W04-1013/")[ROUGE] (recall-focused), #link("https://aclanthology.org/W05-0909/")[METEOR] (synonyms), #link("https://aclanthology.org/W15-3049/")[chrF] (character-level), ...


  - These metrics are fast and (somehow) explainable.
  - Worked when the outputs from the models were below human quality.
  - Nowadays considered mostly obsolete for benchmark eval.



]

#slide[
  = Reference-based metrics: semantic overlap



  *Semantic similarity*: compares the similarity of output vs. reference contextual embeddings as computed by a specific encoder-based model.

  #v(0.25em)

  *Example:* #link("https://arxiv.org/abs/1904.09675")[BERTScore]: embeddings computed by BERT:

  #image("img/lecture05/bertscore_illustration.png")
  #v(-2.1em)

  #source("https://arxiv.org/pdf/1904.09675", title: "Zhang et al. (2020)")
  #v(0.5em)


  *Other metrics:* #link("https://arxiv.org/abs/2004.04696")[BLEURT] (also based on BERT), #link("https://arxiv.org/abs/2009.09025")[COMET] (used for MT), ...

  → Slower, but suitable for standardized reference-based matching.
]


#slide[
  = LLM-as-a-judge

  #source-slide("https://arxiv.org/abs/2306.05685", title: "Zheng et al. (2023)")

  Use a strong LLM to *evaluate the quality* of another model's output.


  ```m
  You are a fair evaluator. Rate the following answer on a scale 1-5 for accuracy, relevance, and completeness.

  Question: {question}
  Reference: {reference}
  Model answer: {answer}

  Respond with JSON: {"accuracy": <1-5>, "relevance": <1-5>, "completeness": <1-5>}
  ```


  \+ Scalable, flexible, cheaper than human evaluation, can be referenceless.

  #v(-0.25em)

  \- Non-standardized, hard to replicate, many biases.
]


#slide[
  = LLM-as-a-judge biases: self-preference



  Models tend to prefer (or disprefer!) their own outputs:
  #v(-1em)

  #set align(center + horizon)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #image("img/lecture05/llm_judge_self_recognition.png", width: 300pt)
      #v(-1em)

      #source("https://arxiv.org/abs/2404.13076", title: "Panickssery et al. (2024)")

      #set text(size: 18pt)
      #v(1em)

      Self-recognition correlates with self-preference.

    ],
    [
      #image("img/lecture05/llm_judge_family_preference.png")

      #source("https://arxiv.org/pdf/2508.06709", title: "Spiliopoulou et al. (2025)")

      #set text(size: 18pt)
      #v(1em)

      Preferences can be traced to model families.

    ],
  )




  #set align(left)

]


#slide[
  = LLM-as-a-judge biases: score calibration

  #source-slide("https://arxiv.org/abs/2405.01724", title: "Stureborg et al. (2024)")

  LLMs are *bad at assigning numerical scores*. They tend to reflect the training data distribution and are hard to calibrate:

  #v(-1em)

  #set align(center + horizon)
  #image("img/lecture05/llm_judge_score_calibration.png", width: 300pt)

  #set align(left)

  #set text(size: 19pt)

  → In the experiments on evaluation summarization (1-100), scores like 90 and 95 appeared far more often than 92 or 19, much of the range (1-60) was ignored.
]


#slide[
  = LLM-as-a-judge biases

  #source-slide("https://arxiv.org/abs/2410.02736", title: "Ye et al. (2024)")

  *Many more types of biases* of LLM-as-a-judge:

  #set align(center + horizon)
  #image("img/lecture05/llm_judge_biases_1.png", width: 700pt)
]

#slide()[
  = LLM-as-a-judge biases

  #source-slide("https://arxiv.org/abs/2410.02736", title: "Ye et al. (2024)")

  (continued...)
  #image("img/lecture05/llm_judge_biases_2.png")
]

#slide[
  = LLM-as-a-judge: explanations


]

#slide[
  = LLM-as-a-judge: best practices

  #source-slide("https://cme295.stanford.edu/slides/fall25-cme295-lecture8.pdf", title: "CME295")

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.8em,
    rect(width: 100%, radius: 0.5em, fill: white, inset: 0.6em)[
      #align(center)[
        #stack(dir: ttb, spacing: 1em, iconify("ph", "pencil-line", height: 2em), text(weight: "bold")[Prompt], text(
          size: 0.85em,
        )[Write clear and detailed guidelines.])
      ]
    ],
    rect(width: 100%, radius: 0.5em, fill: white, inset: 0.6em)[
      #align(center)[
        #stack(
          dir: ttb,
          spacing: 1em,
          iconify("ph", "sliders", height: 2em),
          text(weight: "bold")[Rating scale],
          text(size: 0.85em)[Avoid numerical ratings, use binary scale where possible.],
        )
      ]
    ],
    rect(width: 100%, radius: 0.5em, fill: white, inset: 0.6em)[
      #align(center)[
        #stack(dir: ttb, spacing: 1em, iconify("ph", "chat-text", height: 2em), text(weight: "bold")[Output], text(
          size: 0.85em,
        )[Let the model write an explanation for the score.])
      ]
    ],

    rect(width: 100%, radius: 0.5em, fill: white, inset: 0.6em)[
      #align(center)[
        #stack(
          dir: ttb,
          spacing: 1em,
          iconify("ph", "warning", height: 2em),
          text(weight: "bold")[Biases],
          text(size: 0.85em)[Mind the biases when interpreting the results.],
        )
      ]
    ],
    rect(width: 100%, radius: 0.5em, fill: white, inset: 0.6em)[
      #align(center)[
        #stack(
          dir: ttb,
          spacing: 1em,
          iconify("ph", "check-circle", height: 2em),
          text(weight: "bold")[Sanity check],
          text(size: 0.85em)[Make sure model outputs fit human judgements.],
        )
      ]
    ],
    rect(width: 100%, radius: 0.5em, fill: white, inset: 0.6em)[
      #align(center)[
        #stack(
          dir: ttb,
          spacing: 1em,
          iconify("ph", "arrows-clockwise", height: 2em),
          text(weight: "bold")[Reproducibility],
          text(size: 0.85em)[Disable sampling or use fixed random seed.],
        )
      ]
    ],
  )
]
#slide[
  = Agent benchmarks

  #questionbox()[How can we evaluate LLM agents?]

  #show: later
  *SWE-bench* #link("https://arxiv.org/abs/2310.06770")[(Jimenez et al., 2024)]: software-engineering benchmark.

  *Goal*: resolving real GitHub issues, the code needs to pass unit tests.

  #set align(center + horizon)

  #image("img/lecture05/swebench_overview.png", width: 500pt)
]



#slide[
  = Agent benchmarks
  *WebArena* #link("https://arxiv.org/abs/2307.13854")[(Zhou et al., 2024)]: completing tasks on real websites.

  *Tasks:* Shopping, booking, information retrieval, ...

  #set align(center)

  #image("img/lecture05/webarena_tasks.png", width: 500pt)

  #set align(left)

  #infobox("Evaluation issues")[
    Static vs. live data, steps vs. task completion, which metrics to use.
  ]

]
#slide[
  = Agents can cheat

  #set align(horizon)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #bordered-box(image("img/lecture05/swebench_agent_cheating.png"))

      #source("https://bayes.net/swebench-hack/")

    ],
    [
      #bordered-box(image("img/lecture05/agent_cheating_nist.png"))

      #source("https://www.nist.gov/blogs/caisi-research-blog/cheating-ai-agent-evaluations", title: "NIST website")

    ],
  )
  #v(1em)


  - Cheating on *coding benchmarks* by looking up more recent code versions, disabling assertions, and adding test-specific logic.
  - Finding walkthroughs and answers for *cyber CTF challenges* online.
  - Launching *DDoS attacks* to crash servers instead of exploiting vulnerabilities.



]



#slide[
  = Data contamination


  The first rule of machine learning: *Do not train on your test data*.

  #set align(center)

  #v(-0.5em)
  #image("img/lecture05/train_test_split.png", width: 400pt)

  #set align(left)
  #v(-0.5em)

  → Commonly violated with LLMs.

  #warnbox(title: "Data contamination")[
    LLMs train on most of the internet → *test data can leak into training data*. Moreover, commercial providers do not disclose their training data sources.
  ]
]


#slide[
  = Data contamination


  *Benchmark scores are commonly inflated* due to data contamination:


  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #image("img/lecture05/data_contamination_examples.png", width: 300pt)
      #v(-0.5em)

      #source(
        "https://github.com/lyy1994/awesome-data-contamination",
        title: "https://github.com/lyy1994/awesome-data-contamination",
      )

      #image("img/lecture05/data_contamination_balloccu.png", width: 300pt)
      #v(-0.5em)

      #source("https://arxiv.org/abs/2402.03927", title: "Balloccu et al. (2024)")

    ],
    [
      #image("img/lecture05/data_contamination_scale_ai.png", width: 350pt)
      #source("https://arxiv.org/pdf/2405.00332", title: "Scale AI (2024)")


    ],
  )


  #set align(center + horizon)



  #set align(left)

  #v(0.5em)

]


#slide[
  = Benchmark saturation and Goodhart's law

  #source-slide("https://arxiv.org/abs/2502.14318", title: "Fodor (2025)")

  Even training on *similar / related examples* can inflate benchmark scores.

  #set text(size: 16pt)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    #table(
      columns: (1fr, 0.5fr, 0.7fr),
      inset: 0.4em,
      align: left,
      table.header[*Benchmark*][*Top score*][*Saturated?*],
      [GSM8K], [99%], [✅ Yes],
      [MMLU], [93%], [✅ Yes],
      [HellaSwag], [95%+], [✅ Yes],
      [GPQA Diamond], [94.3%], [⚠ Close],
      [SWE-bench], [80.8%], [❌ Not yet],
      [HLE], [53.1%], [❌ Not yet],
    )

    #source("https://www.lxt.ai/blog/llm-benchmarks/", title: "https://www.lxt.ai/blog/llm-benchmarks/")

  ][
    #bordered-box(image("img/lecture05/benchmark_saturation.png", width: 250pt))
    #source(
      "https://huggingface.co/spaces/open-llm-leaderboard-old/open_llm_leaderboard",
      title: "Open LLM Leaderboard",
    )
  ]

  #set text(size: 20pt)


  #quote(attribution: [Charles Goodhart (1975)])[
    When a measure becomes a target, it ceases to be a good measure.
  ]
]

#section-slide(section: "Other evaluation methods")[Other evaluation methods]
#slide[
  = LM arenas

  #source-slide("https://arxiv.org/abs/2403.04132", title: "(Chiang et al., 2024)")

  #link("Arena.ai")[*Arena.ai*]: users compare *anonymous* responses from two models and pick the better one → Elo ratings.

  #set align(center + horizon)

  #v(-1em)

  #bordered-box(image("img/lecture05/arena_ai_leaderboard.png", width: 450pt))
]


#slide[
  = OpenRouter

  *OpenRouter*: routing traffic to various LLM providers, tracks model usage through their proxy:
  #v(-1em)

  #set align(center + horizon)
  #bordered-box(image("img/lecture04/screen-2026-03-08-14-52-53.png", width: 650pt))
  #source-slide("https://openrouter.ai/rankings", title: "OpenRouter")
]

#slide[
  = Vibe checks

  #source-slide("https://arxiv.org/pdf/2410.12851", title: "Dunlap et al. (2024)")

  For the aspects that any formal methodology misses:

  #set align(center + horizon)

  #image("img/lecture05/vibe_check_example.png", width: 500pt)

]

#section-slide(section: "Summary")[Summary]


#slide[
  = Summary

  - *Pretraining data*: web-scale corpora based on Common Crawl.
  - *Instruction tuning data*: human-written/synthetic instruction-response pairs.
  - *RLHF/preference data*: human/synthetic preference of model outputs.
  - *Synthetic data* is increasingly important, but can lead to model collapse.
  - *Intrinsic metrics* (perplexity) vs. *extrinsic metrics* (user satisfaction).
  - *Benchmarks* (MMLU, GSM8K, SWE-bench, ...) are useful but have *many pitfalls*:
    - Answer parsing, score calibration, data contamination, saturation.
  - *Data contamination* makes LLM benchmark scores often inflated.
]


#slide[
  = Links and resources

  #set text(size: 16pt)

  - #link(
      "https://arxiv.org/abs/2402.18041",
    )[Datasets for Large Language Models: A Comprehensive Survey (Liu et al., 2024)]
  - #link("https://arxiv.org/abs/2406.17557")[FineWeb (Penedo et al., 2024)]
  - #link(
      "https://arxiv.org/abs/2203.02155",
    )[Training language models to follow instructions with human feedback (Ouyang et al., 2022)]
  - #link(
      "https://arxiv.org/abs/2306.05685",
    )[Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena (Zheng et al., 2023)]
  - #link(
      "https://arxiv.org/abs/2402.01781",
    )[Benchmarks on a Diet: MCQA answer-choice sensitivity (Alzahrani et al., 2024)]
  - #link("https://arxiv.org/abs/2404.13076")[LLM evaluators recognize self-generated text (Panickssery et al., 2024)]
  - #link("https://arxiv.org/abs/2402.03927")[Contamination in LLM benchmarks (Balloccu et al., 2024)]
  - #link("https://arxiv.org/abs/2504.20879")[The Leaderboard Illusion (Singh et al., 2025)]
  - #link("https://arxiv.org/abs/2505.08253")[SWE-bench agent cheating (Miller & Tang, 2025)]
  - #link(
      "https://magazine.sebastianraschka.com/p/llm-evaluation-4-approaches",
    )[LLM evaluation: 4 approaches (Raschka, 2024)]
]



