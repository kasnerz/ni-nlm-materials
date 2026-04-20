#import "fit.typ": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#show: fit-theme.with(
  footer-content: "NI-NLM – 10 – Lecture",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Lecture 10",
  subtitle: "Multilinguality & multimodality.",
  author: "Zdeněk Kasner",
  date: "28 Apr 2026",
)[]

#enable-handout-mode(true)


#section-slide(section: "Multilinguality")[Multilinguality

  #place(
    top + right,
    dx: 1.5cm,
    dy: 8cm,
    text(
      size: 12pt,
      font: font-sans,
      fill: rgb("#ffffff"),
      weight: "regular",
    )[
      re-using some #link("https://ufal.mff.cuni.cz/~helcl/courses/npfl140/slides/2026/08-multilinguality.pdf")[#text(fill: rgb("#ffffff"))[NPFL140]] materials by Tomasz Limisiewicz and Jindřich Libovický],
  )
]

#slide[
  = Languages in the world

  #questionbox()[How many languages exist in the world? How many of them are spoken-only?]

  #show: later


  #grid(
    columns: (1.4fr, 1fr),
    gutter: 1em,
    [
      There are around *7,170 languages* today.
      - Out of these, *4,153 (58%)* have a writing system.
        - Remaining 3,011 languags are  spoken-only.
      - 94% of people speaks 6% of languages.
      - Roughly 44% of all languages are now endangered (\<1,000 users remaining).
    ],
    [
      #set align(center + horizon)

      #image("img/lecture10/screen-2026-04-20-10-49-08.png")
    ],
  )


  #place(
    top + right,
    dx: 0.3cm,
    dy: -2.2cm,
    text(
      size: 12pt,
      font: font-sans,
      fill: rgb("#ffffff"),
    )[
      sources:
      #link("https://education.nationalgeographic.org/resource/language-diversity-index-map/")[#text(
          fill: rgb("#ffffff"),
        )[National Geographic]
        #link("https://www.ethnologue.com/faq/how-many-languages-unwritten/")[#text(
          fill: rgb("#ffffff"),
        )[Ethnologue]]
      ]],
  )
]


#slide[
  = Languages differ

  Languages vary widely in their typological properties:

  - *Word order*: SVO (English), SOV (Japanese, Hindi), VSO (Irish, Arabic), ...
  - *Morphology*: isolating (Chinese) vs. agglutinative (Turkish) vs. fusional (Czech).
  - *Writing systems*: Latin, Cyrillic, Arabic, Devanagari, Chinese characters, ...

  #grid(
    columns: (2fr, 1fr),
    gutter: 2em,
    [
      #set align(right + horizon)

      #image("img/lecture10/wals_word_order.png", width: 350pt)
    ],
    [
      #set align(left + horizon)
      #image("img/lecture10/screen-2026-04-20-10-53-20.png", width: 80pt)

    ],
  )
  #source-slide("https://wals.info/", title: "WALS")
]


#slide[
  = Why multilingual LLMs

  #questionbox()[Why do we train multilingual LLMs?]
  #show: later

  #source-slide("https://osf.io/preprints/psyarxiv/5b26t_v1", title: "https://osf.io/preprints/psyarxiv/5b26t_v1")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      - *Accessibility* to non-English speakers.
      - Code-switching & *cross-lingual tasks*.
      - *More efficient* than training a specific model for each language.
      - Cross-lingual *transfer learning*.
      - *Localization* as opposed to translation only.
      - Instilling non-English-centric *cultural values*.
    ],
    [
      #image("img/lecture10/world_value_survey1.png", width: 280pt)
    ],
  )

]



#slide[
  = Cross-lingual transfer

  #ideabox()[Train a model on a *high-resource language* and apply it to a *low-resource* one.]

  #grid(
    columns: (1.2fr, 1fr),
    gutter: 1em,
    [
      - First explored with multilingual pretrained encoders (mBERT, XLM-R).
      - *Zero-shot cross-lingual transfer*: the models can perform tasks such as named-entity recognition *without any target-language training data*.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture10/cross_lingual_transfer.png", width: 220pt)

      #v(-1em)

      #source("https://arxiv.org/pdf/2205.04086v1", title: "Malkin et al. (2022)")
    ],
  )

  → Shared multilingual representations must have developed within the models.

  #source-slide("https://arxiv.org/abs/1911.02116", title: "Conneau et al. (2020)")
]

#slide[
  = Typological similarity helps



  #source-slide("https://arxiv.org/pdf/1911.03310", title: "https://arxiv.org/pdf/1911.03310")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      Cross-lingual transfer works better between *similar languages*:

      - Languages with *similar word order and morphology* share more representational structure.
      - *Shared writing script* also helps the knowledge transfer, especially with respect to tokenization.
      The transfer does not have to be zero-shot: any amount of data from the target language helps.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture10/typological_transfer.png", width: 250pt)
    ],
  )




]



#slide[
  = Data availability

  The amount of available text data varies enormously across languages:

  #set align(center + horizon)
  #v(-1em)

  #image("img/lecture10/data_availability.png", width: 400pt)

  #source-slide("https://arxiv.org/pdf/2004.09095", title: "https://arxiv.org/pdf/2004.09095")

  → Many languages have virtually no usable training data (both unlabeled & labeled).
]

#slide[
  = Data availability

  #source-slide("https://arxiv.org/pdf/2004.09095", title: "https://arxiv.org/pdf/2004.09095")

  #set align(center + horizon)

  // decrease line height

  #set text(size: 19pt)

  #table(
    columns: (auto, auto, 1fr, auto),
    align: (center, center, left, left + horizon),
    inset: (x: 0.8em, y: 0.3em),
    table.header(
      [*Group*], [*Speakers*], [*Examples of languages*],
      table.cell(stroke: none)[],
    ),
    [5], [2.5 B], [English, Spanish, German, French, Arabic, Mandarin],
    table.cell(stroke: none)[],
    [4], [1.6 B], [Russian, Hungarian, Vietnamese, Czech, Polish, Persian, Hindi, ...],
    table.cell(stroke: none)[],
    [3], [1.1 B], [Indonesian, Ukrainian, Hebrew, Cebuano, Slovak, ...],
    table.cell(stroke: none)[],
    [2], [300 M], [Irish, Maltese, Lao, Zulu, Amharic, ...],
    table.cell(rowspan: 3, stroke: none)[
      #grid(
        columns: (auto, auto),
        column-gutter: 0.5em,
        align: (right + horizon, left + horizon),
        text(size: 100pt, weight: "light")[}], text(size: 0.85em)[Approx. 30% of\ world population],
      )
    ],
    [1], [1 B], [Cherokee, Fijian, Greenlandic, Navajo, Macedonian, ...],
    [0], [1 B], [Dhalo, Warlpiri, Popoloca, Wallisian, Bora, ...],
  )
]

#slide[
  = Training multilingual LLMs

  How do we handle the data imbalance?

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      - *Naive approach*: train on all data proportionally → the model mostly learns English.
      - *Temperature-based sampling*: oversample low-resource, undersample high-resource languages.
      - Still a trade-off: oversampling low-resource data can hurt high-resource performance.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture10/data_balancing.png", width: 320pt)
    ],
  )
]


#slide[
  = The more balanced the better?

  #source-slide("https://arxiv.org/abs/2211.05100", title: "BigScience (2023)")

  An effort to train a *large multilingual LLM* with careful data curation.

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      - 176B parameters, trained on *46 languages*.
      - Special attention to balancing languages.
      - One of the first fully open large-scale multilingual models.

      → Performed subpar compared to SotA models.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture10/thumbnail-112021460.png", width: 300pt)
    ],
  )

  #warnbox(
    "Curse of multilinguality",
  )[A model has fixed capacity. Adding more languages forces it to share that capacity, hurting per-language performance.]
]


#slide[
  = Knowledge might be language-specific

  Facts from local Wikipedia pages are often *not accessible* in other languages:

  #source-slide("https://arxiv.org/abs/2502.21228", title: "https://arxiv.org/abs/2502.21228")

  #set align(horizon)


  #grid(
    columns: (1fr, 1.5fr),
    gutter: 3em,
    [
      #set align(right)

      #image("img/lecture10/screen-2026-04-20-11-48-42.png", width: 150pt)
    ],
    [
      #set align(left)
      #image("img/lecture10/knowledge_language_specific.png", width: 300pt)
    ],
  )

]

#slide[
  = Knowledge might also be shared

  However, LLMs can develop *language agnostic concepts*:

  #set align(center + horizon)

  #image("img/lecture10/language_agnostic_concepts.png", width: 600pt)

  #source-slide(
    "https://transformer-circuits.pub/2025/attribution-graphs/biology.html#dives-multilingual ",
    title: "Anthropic (2025)",
  )

]



#slide[
  = Choosing the right model

  #questionbox()[How would you pick the right model for a specific language?]

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      - Check the model card if the authors *claim to support it* (#link("https://huggingface.co/CohereLabs/aya-expanse-8b#supported-languages")[example])
      - Check if the language was included in the *training or fine-tuning data*.
      - Check data for similar *languages*.
      - Check *tokenization*.
      - Check *benchmarks*.
    ],
    [
      #set align(center + horizon)

      #v(-0.5em)

      #image("img/lecture10/screen-2026-04-20-12-31-40.png", width: 200pt)
      #v(-0.5em)
      #source("https://arxiv.org/pdf/2305.13707", title: "Ahia et al. (2023)")

    ],
  )
]


#slide[
  = UTF-8 encoding

  One *grapheme* (visible character) can span *multiple UTF-8 bytes*:

  #let accent = rgb("#e07828")
  #let box-fill = rgb("#ebebeb")

  #let utf8-box(range, label, pattern, n-bytes, n-points) = block(
    fill: box-fill,
    radius: 8pt,
    inset: (x: 1em, y: 0.5em),
    width: 100%,
  )[
    #set text(font: font-sans, size: 0.9em)
    #text(weight: "bold")[#range] #h(0.3em) #text(size: 0.76em, fill: rgb("#555555"))[(#label)] \
    #v(-0.5em)
    #text(font: font-mono, size: 0.88em)[#pattern]
    #v(-0.5em)
    #text(size: 0.82em)[#n-bytes #if n-bytes == 1 [byte] else [bytes] · #n-points code points]
  ]

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #utf8-box("U+0000 – U+007F", "ASCII", [#text(fill: accent)[0]xxxxxxx], 1, "128")
      #v(-1em)
      #utf8-box(
        "U+0080 – U+07FF",
        "Latin, Arabic, Hebrew…",
        [#text(fill: accent)[110]xxxxx #h(0.4em) #text(fill: accent)[10]xxxxxx],
        2,
        "1,920",
      )
    ],
    [
      #set align(horizon)
      #utf8-box(
        "U+0800 – U+FFFF",
        "CJK, Devanagari…",
        [#text(fill: accent)[1110]xxxx #h(0.4em) #text(fill: accent)[10]xxxxxx #h(0.4em) #text(fill: accent)[10]xxxxxx],
        3,
        "63,488",
      )
      #v(-1em)
      #utf8-box(
        "U+10000 – U+10FFFF",
        "emoji, rare scripts",
        [#text(fill: accent)[11110]xxx #h(0.4em) #text(fill: accent)[10]xxxxxx #h(0.4em) #text(fill: accent)[10]xxxxxx #h(0.4em) #text(fill: accent)[10]xxxxxx],
        4,
        "1,048,576",
      )


    ],
  )


  #set text(size: 14pt)

  #table(
    columns: (1fr, 1.2fr, 1.2fr, 1.2fr),
    align: (left + horizon, center + horizon, center + horizon, center + horizon),
    stroke: none,
    inset: (x: 1em, y: 0.55em),
    table.hline(),
    table.header(
      table.cell(stroke: none)[],
      [*Tamil*], [*Sinhala*], [*Hindi*],
    ),
    table.hline(),
    [Grapheme],
    text(size: 1.5em)[ன்],
    text(size: 1.5em)[ශ්],
    text(size: 1.5em)[वा],
    [Unicode characters],
    [ன + ்],
    [ශ + ්],
    [व + ा],
    [Unicode codepoints],
    [U+0BA9, U+0BCD],
    [U+0DC3, U+0DCA],
    [U+0935, U+093E],
    [UTF-8 bytes],
    text(font: font-mono)[e0 ae a9 e0 af 8d],
    text(font: font-mono)[e0 b7 83 e0 b7 8a],
    text(font: font-mono)[e0 a4 b5 e0 a4 be],
    table.hline(),
  )

  #source-slide(
    "https://ufal.mff.cuni.cz/~helcl/courses/npfl140/slides/2026/08-multilinguality.pdf",
    title: "NPFL140 - Lecture 8",
  )

]


#slide[
  = Models are more expensive for some languages

  #image("img/lecture10/screen-2026-04-20-12-49-31.png")


  #source-slide(
    "https://ufal.mff.cuni.cz/~helcl/courses/npfl140/slides/2026/08-multilinguality.pdf",
    title: "NPFL140 - Lecture 8",
  )
]


#slide[
  = Where to get multilingual benchmarks?

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      *Option \#1: Translate the English benchmarks.*

      ✅All benchmark items are *equivalent* across languages


      → allows quantifying that language X is better than language Y

      ⛔ Traces of "translationese", may not be properly localized.
    ],
    [
      *Option \#2: Collect  benchmarks directly in the specific languages.*

      ✅ Better reflects actual language use, cultural values etc.

      ⛔ Hard to compare across langauges.

      ⛔ Getting local expert annotators is difficult.
    ],
  )
]

#slide[
  = Localization is _not_ translation

  #v(3em)

  #set text(size: 23pt)


  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #set align(horizon)

      *de*: Er ist ein typischer SPD-Wähler.

      *cs*: Je to typický volič SPD.

      *en*: He is a typical voter of SPD.
    ],
    [
      #set align(center + horizon)

      #image("img/lecture10/screen-2026-04-20-12-21-09.png", width: 200pt)
    ],
  )


  #source-slide(
    "https://ufal.mff.cuni.cz/~helcl/courses/npfl140/slides/2026/08-multilinguality.pdf",
    title: "NPFL140 - Lecture 8",
  )

]

#slide[
  = INCLUDE vs. MMLU

  #source-slide("https://arxiv.org/abs/2411.19799", title: "https://arxiv.org/abs/2411.19799")

  *INCLUDE*: Authentic questions local education systems
  #grid(
    columns: (1fr, 1.3fr),
    gutter: 2em,
    [
      - 55 countries, 44 languages, 15 scripts
      - Still, major model releases prefer M-MMLU
        - Heavily US-centric, several multilingual version
        - Multilingual versions combine human and machine translation

    ],
    [


      #set align(center + horizon)


      #image("img/lecture10/screen-2026-04-20-13-20-32.png")
    ],
  )
]

#slide[
  = Belebele

  #source-slide("https://arxiv.org/abs/2308.16884", title: "Bandarkar et al. (2023)")

  *Belebele:* Multiple-choice questions about a text, spanning *122 languages*.

  Questions are naturally written by native speakers (not just translated from English).

  #set align(center + horizon)

  #image("img/lecture10/belebele.png", width: 550pt)
]

#slide[
  = MultiLoKo

  #source-slide("https://arxiv.org/abs/2504.10356v2", title: "https://arxiv.org/abs/2504.10356v2")

  *MultiLoKo*: A benchmark for multilingual local knowledge: facts that are specific to certain languages and cultures.

  #set align(center + horizon)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      #set align(center + horizon)

      #image("img/lecture10/multiloko1.png", width: 400pt)
    ],
    [
      #set align(center + horizon)
      #image("img/lecture10/multiloko2.png", width: 280pt)
    ],
  )

]


#slide[
  = LLMs for machine translation

  LLMs are increasingly competitive with dedicated machine translation systems.


  #grid(
    columns: (2fr, 1fr),
    gutter: 3em,
    [

      *WMT24*:

      #set align(center + horizon)
      #v(-1em)

      #image("img/lecture10/screen-2026-04-20-13-34-22.png", width: 500pt)
      #v(-1em)

      #source("https://ufal.mff.cuni.dcz/~helcl/courses/npfl140/slides/2026/08-multilinguality.pdf", title: "NPFL140")

    ],
    [
      *WMT25:*

      #image("img/lecture10/wmt25_results.png", width: 200pt)
    ],
  )


  #source-slide("https://aclanthology.org/2025.wmt-1.22/", title: "https://aclanthology.org/2025.wmt-1.22/")


]


#slide[
  = Finetuned LLMs for MT
  Smaller LLMs can be competitive with larger models when finetuned for MT.

  #set align(center + horizon)

  #image("img/lecture10/instruction_tuned_mt.png", width: 600pt)

  #source-slide("https://arxiv.org/pdf/2402.17733", title: "https://arxiv.org/pdf/2402.17733")

]



// ═══════════════════════════════════════════════════════════
// PART 2: MULTIMODALITY
// ═══════════════════════════════════════════════════════════

#section-slide(section: "Multimodality")[Multimodal models]

#slide[
  = Beyond text

  Modern LLMs are being extended to handle *images, audio, and video*.

  #questionbox()[How would you represent non-text modalities so that a language model can process them?]

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      Two main ingredients:
      + A pretrained *modality encoder* (e.g. vision encoder for images).
      + A *projection mechanism* to align representations with the LLM.
    ],
    [
      #image("img/lecture10/0d76dab1-362f-45b6-9b12-a12ac131edc5_1600x944.jpg", width: 250pt)
      #v(-1em)

      #source(
        "https://magazine.sebastianraschka.com/p/understanding-multimodal-llms",
        title: "Understanding Multimodal LLMs",
      )

    ],
  )


]

#slide[
  = Vision Transformer

  #source-slide("https://arxiv.org/abs/2010.11929", title: "Dosovitskiy et al. (2021)")

  #ideabox()[We can *encode an image similarly to text* if we split it into patches = "tokens".]

  *Vision Transformer* (ViT):

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      + Split the image into fixed-size patches (e.g. 16x16 pixels).
      + Project the patch through a linear layer → "embedding".
      + Process with a Transformer encoder same as we would for the text.

    ],
    [

      #set align(center + horizon)

      #image("img/lecture10/screen-2026-04-20-14-41-33.png", width: 400pt)
    ],
  )



]

#slide[
  = CLIP: contrastive language-image pretraining

  #source-slide("https://arxiv.org/abs/2103.00020", title: "Radford et al. (2021)")

  With ViT, the embedding space for the text and for the images can be vastly different.

  #ideabox()[Train two encoders (image + text) so that matching pairs end up close in a shared embedding space.]


  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      *CLIP*: trained on 400M image-text pairs.
      - Uses *contrastive loss*: maximizing similarity of matching pairs + maximizing dissimilarity of non-matching pairs.
      - Enables zero-shot image classification.
    ],
    [
      #image("img/lecture10/screen-2026-04-20-14-47-57.png", width: 250pt)
    ],
  )

]


#section-slide(section: "VLMs")[Vision-language models (VLMs)]

#slide[
  = Option A: unified embedding decoder


  The simplest VLM architecture,  used by LLaVA, Molmo, Qwen2-VL, Pixtral, ...

  + Encode the image into a sequence of *visual tokens* (using ViT + projector).
  + *Concatenate* visual tokens with text tokens.
  + Feed everything through a standard *decoder-only Transformer*.



  #set align(center + horizon)

  #image("img/lecture10/architecture.png", width: 500pt)

]

#slide[
  = Option B: cross-modality attention


  #grid(
    columns: (1.3fr, 1fr),
    gutter: 1em,
    [
      Visual features are injected via *cross-attention layer*:

      + The LLM has additional cross-attention layers that attend to visual features.
      + The LLM's original self-attention weights can remain *frozen*.
      + Visual features are processed separately and "read" by the LLM on demand.

      #v(1em)

      Used by: Flamingo, Llama 3.2 Vision, ...

    ],
    [
      #image("img/lecture10/d9c06055-b959-45d1-87b2-1f4e90ceaf2d_1296x1338.jpg")
    ],
  )

  #source-slide(
    "https://magazine.sebastianraschka.com/p/understanding-multimodal-llms",
    title: "Understanding Multimodal LLMs",
  )
]

#slide[
  = Training a vision-language model

  VLM training typically has *two stages*:

  #v(0.5em)

  1. *Alignment pretraining*
    - Freeze both image encoder and LLM.
    - Only train the *projector* (linear layer or MLP).
    - Goal: align visual representations with the LLM's embedding space.

  #v(0.3em)

  2. *Visual instruction tuning*
    - Unfreeze the LLM (and optionally the image encoder).
    - Train on visual instruction-following data.
    - The model learns to answer questions about images, describe scenes, etc.

]

#slide[
  = Training a vision-language model
  #image("img/lecture10/24a12032-d32e-41f6-b390-4e321e1ea29f_1600x770.jpg")

  #source-slide(
    "https://magazine.sebastianraschka.com/p/understanding-multimodal-llms",
    title: "Understanding Multimodal LLMs",
  )
]

#slide[
  = Vision-language tasks

  What can VLMs do?

  #let task-card(title, subtitle) = rect(width: 100%, radius: 0.3em, fill: white, inset: 0.4em, align(center)[
    *#title* \
    #text(size: 0.85em)[#subtitle]
  ])

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.8em,
    task-card("Visual QA", [Answer questions about images]),
    task-card("Image captioning", [Generate text descriptions]),
    task-card("Visual reasoning", [Multi-step inference over images]),
  )
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.8em,
    task-card("OCR / document parsing", [Read text from images]),
    task-card("Grounding", [Localize objects by description]),
    task-card("Image generation", [Generate images from text]),
  )
]


// ═══════════════════════════════════════════════════════════
// Speech & video
// ═══════════════════════════════════════════════════════════

#section-slide(section: "Speech & video")[Speech & video]

#slide[
  = Speech representations

  How do we represent audio for neural models?

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      *Traditional: MFCCs*
      - Extract spectral features from short audio frames.
      - Hand-engineered, lossy.
    ],
    [
      *Modern: self-supervised models*
      - *wav2vec 2.0*: learn representations directly from raw waveform.
      - Pretrained on large amounts of _unlabeled_ audio.
    ],
  )

  #source-slide("https://arxiv.org/abs/2006.11477", title: "Baevski et al. (2020)")

  Just like BERT for text, we can pretrain on speech and fine-tune for downstream tasks.
]

#slide[
  = Whisper

  #source-slide("https://arxiv.org/abs/2212.04356", title: "Radford et al. (2023)")

  An encoder-decoder Transformer for automatic speech recognition.

  #todo("Add figure: Whisper architecture (audio spectrogram → encoder → decoder → text)")

  - Trained on *680,000 hours* of labeled audio from the web.
  - Multi-task: *ASR, translation, language identification, timestamps*.
  - Works well across many languages out of the box.
  - The "scaling + web data" recipe applied to speech.
]

#slide[
  = Plugging speech into LLMs

  #ideabox()[Use the same pattern as for vision: *speech encoder → adapter → LLM*.]

  #todo("Add figure: speech encoder + length adapter + LLM pipeline")

  - Speech sequences are *much longer* than text → need a *length adapter* (e.g. downsampling convolutions).
  - Enables voice assistants, spoken dialogue, audio understanding.
  - Examples: Gemini and GPT-4o process audio natively alongside text and images.
]

#slide[
  = Video understanding

  Video adds the *temporal dimension*: a sequence of image frames.

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      Approaches:
      - *Sample frames* at regular intervals and encode each with a vision encoder.
      - Concatenate frame tokens → very long sequences.
      - Need efficient attention mechanisms for *hour-long* videos.

      Recent models: Gemini 1.5, GPT-4o, Vidi.
    ],
    [
      #todo("Add figure: video frame sampling for VLMs")
    ],
  )
]

#slide[
  = Emerging video capabilities

  #source-slide("https://video-zero-shot.github.io/", title: "Google DeepMind (2025)")

  Recent video generation models (e.g. Veo 3) show surprising *emergent zero-shot capabilities*:

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.5em,
    [
      - Edge detection
      - Segmentation
      - Depth estimation
    ],
    [
      - Style transfer
      - Object tracking
      - Optical flow
    ],
    [
      - Maze solving
      - Physics simulation
      - Scene understanding
    ],
  )

  #v(0.5em)

  Video models may be on a path to becoming *vision foundation models*, not just generators.
]


// ═══════════════════════════════════════════════════════════
// Summary
// ═══════════════════════════════════════════════════════════

#slide[
  = Summary

  *Multilinguality*
  - ~7,000 languages, but most NLP research focuses on a handful.
  - Multilingual models enable cross-lingual transfer but face the curse of multilinguality.
  - LLMs are increasingly competitive for machine translation.

  #v(0.5em)

  *Multimodality*
  - Vision Transformers and CLIP bridge the gap between images and text.
  - VLMs combine a vision encoder with an LLM via a projector (or cross-attention).
  - The same pattern extends to speech and video understanding.
]

