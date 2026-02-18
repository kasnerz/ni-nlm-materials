#import "fit.typ": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#show: fit-theme.with(
  footer-content: "NI-NLM – 01 – Lecture",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Lecture 1",
  subtitle: "Introduction to NLP with Neural Networks",
  author: "Zdeněk Kasner",
  date: "17 Feb 2026",
)[]

#enable-handout-mode(true)

#section-slide(section: "Course intro")[Course introduction]

#slide[
  = The teacher

  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,

    [=== Zdeněk Kasner

      Postdoctoral researcher at #link("https://ufal.mff.cuni.cz/zdenek-kasner")[*ÚFAL, MFF UK*]
      - Research on LLMs: controllable text generation, evaluation, reasoning.

      #v(0.5em)

      #uncover(2)[
        #infobox(title: "My academic path", icon: iconify("tabler", "school"))[
          - *FIT CTU*: Computer Science (Bc.)
          - *FEL CTU*: Artificial Intelligence (Ing.)
          - *MFF UK*: Computational Linguistics (Ph.D.)
        ]
      ]

    ],
    [
      #set align(center + horizon)

      #box(
        radius: 1000pt,
        clip: true,
        image("img/lecture01/teacher_photo.jpg", width: 150pt),
      )

    ],
  )

]

#slide[
  = What to expect from me?

  #item-by-item()[
    - I am also teaching *#link("https://ufal.mff.cuni.cz/courses/npfl140")[NPFL140 -- Large Language Models] at MFF UK* together with my colleagues (3rd year in a row).
      - Our course will be different (CZ, less people → more interactivity during lectures, tutorials with paper presentations).
    - The *first year* I am teaching this course here → there may be some hiccups.
    - My experience is in academic research →  I am curious to learn what you know better!
  ]

  #uncover("4-")[
    #warnbox(title: "Thesis supervision")[
      Sorry, I cannot supervise your thesis -- I am at full capacity now.
    ]
  ]
]

#slide[
  = What to expect from this course?
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,

    [#show: later
      #infobox(title: "Me: talking on LLMs", icon: iconify("mdi", "lecture"))[
        I will *present the topic*. The slides (in English) and other materials will be available on Course Pages.
      ]
    ],
    [#show: later
      #infobox(title: "Us: discussing LLMs", icon: iconify("healthicons", "group-discussion-meeting"))[
        I want *you to discuss and reason* about the things we learn (test-time scaling! 😉)
      ]
    ],

    [#show: later
      #infobox(title: "You: working on the project", icon: iconify("ant-design", "code-filled"))[
        *Semestral project* is the major part of the workload in this course → consultations during the tutorials.
      ]
    ],
    [#show: later
      #infobox(title: "You: presenting", icon: iconify("streamline-plump", "news-paper-solid"))[
        You can get extra points for the final test by *presenting a paper or your project* (→ tutorials).
      ]
    ],
  )


]

#slide[
  = About the course

  === Learning objectives
  + Help you understand *how LLMs work* on the architectural level.
  + Teach you *how to handle LLMs* in practice.
  + Teach you *how to work with AI/NLP scientific literature*.
  + Teach you *how to think about the broader context* of using LLMs.

  #show: later
  === What is expected from you?
  - You should be familiar with *Python + basics of deep learning*.
  - You should be *active during the lectures*.
  - You should be *enthusiastic about LLMs*! (at least somewhat 😎)
]


#slide[
  = Course requirements

  === How to get the assessment
  - You need to *work on the semestral project* and *submit the report* till 31 May 2026.
  - You also need achieve *50/100 points in the final test*.
    - In-person during the last lecture (12 May 2026) + one extra term during the exam period.

  #show: later
  === Course logistics
  - *1 lecture per week + 1 tutorial every two weeks (starting today)*
    - Attendance not mandatory, but highly recommended.

]

#slide[
  = Lectures -- T9:347

  === Outline:
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      1. Intro to NLP with neural networks
      2. Transformer architecture
      3. Training language models
      4. Text generation, decoding algorithms
      5. Data and evaluation
      6. Chain-of-thought, reasoning models
    ],
    [
      7. RAG, tool calling, agents
      8. Efficiency: quantization, LoRA
      9. Interpretability
      10. Multimodal models
      11. Applications, ethics, legal aspects
      12. Final test
    ],
  )
  #v(2em)


  \~ *60 minutes* of me talking, *30 minutes* of discussions and other activities

]

#slide[
  = Tutorials -- T9:350

  *Today:* Semestral project, how to compute.

  *Next five tutorials*: #link("https://docs.google.com/spreadsheets/d/1SXHOzzc_GMTdEIiPSi8tGSjwmc-4MsqADEiAzo1Ndn4/edit?usp=sharing")[Paper presentations] + consultations

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [#uncover("2-")[
      #infobox(title: "Paper presentations")[
        - List of recommended papers (or propose yourselves)
        - *15 min presentation* → 5 points for the final test (only once per semester).
        - Sign up in the #link("https://docs.google.com/spreadsheets/d/1SXHOzzc_GMTdEIiPSi8tGSjwmc-4MsqADEiAzo1Ndn4/edit?usp=sharing")[spreadsheet].

      ]

    ]],
    [
      #uncover("3-")[
        #infobox(title: "Consultations")[
          - Help with the semestral project, *voluntary*.
          - After the paper presentations are over.
          - If there are too many papers, we can consult after the tutorial.
        ]]],
  )

]


#slide[
  = Questions for you

  #set align(horizon)

  #questionbox()[
    - What is your LLM expertise (if any)?
    - Why have you signed up for the course?
    - What do you expect to learn from this course?
  ]
  #show: later



]

#slide[
  = Questions for you

  #set align(horizon)

  #questionbox()[Could you explain the following terms to a friend?
    #v(0.5em)



    #grid(
      columns: (1fr, 1fr, 1fr),
      gutter: 1em,
      [
        #item-by-item(start: 3)[
          - vector
          - machine learning
          - neural networks
          - embedding
        ]

      ],
      [
        #item-by-item(start: 7)[
          - language modeling
          - Transformer
          - LLM
          - GPT
        ]

      ],
      [
        #item-by-item(start: 11)[
          - finetuning
          - RLHF
          - RAG
          - AI agent
        ]
      ],
    )
  ]
]




#section-slide(section: "Representing language")[How to represent language?]




#slide[
  = What is language?

  === Are these languages?
  #v(0.5em)


  ```
  The quick brown fox jumps over the lazy dog.
  ```

  // "I cannot hear very well" (inuit language)
  ```
  ᑐᓵᑦᓯᐊᕈᓐᓇᙱᑦᑐᐊᓘᔪᖓ
  ```

  ```python
  print("Hello, world!")
  ```

  ```brainfuck
  +++++++[>++++++++++<-]>+.
  ```

  ```dyck
  (())()(())
  ```

  ```
  efhiew nwjfksahfiahf asdkfa sfhasiofh
  ```
]

#slide[
  = What is language?

  Language is a *sequence of symbols*
  #show: later
  that conveys meaning.

  #v(1em)
  #show: later
  *It is discrete*
  - Made of distinct units (characters, words).
  → Sequence $w_1, w_2, ..., w_T$ from vocabulary $V$.
  #v(1em)
  #show: later
  *It is compositional*

  → Infinite sentences from finite vocabulary.
  - Meaning comes both from the units (words) and their structure.
]

#slide[
  = How to represent language?

  #set align(horizon)

  #questionbox()[

    Suggest 2-3 ways *how to represent a language sequence* in a computer.

    - How do you create the representation?
    - What are its advantages and disadvantages?
    - Is it suitable as an input for a neural network? Why?
  ]
]

#slide[
  = Text as byte sequences

  #grid(
    columns: (1.9fr, 1fr),
    gutter: 1em,
    [
      Text strings are represented as *byte sequences*.

      Various encodings: *ASCII* (8 bits),  *UTF-8*: variable-length, ...

      #v(1em)

      *Disadvantages:*
      - Misleading dependencies:
        - Character ids are arbitrary constants
        - \# of characters in the word
        - ...
      - No meaningful relationship between related words.
    ],
    [#set align(center + horizon)

      #set text(size: 17pt)
      #table(
        columns: (auto, auto, auto),
        align: center,
        table.header([*Char*], [*Dec*], [*Bin*]),
        [A], [65], [1000001],
        [B], [66], [1000010],
        [C], [67], [1000011],
        [...], [...], [...],
        [a], [97], [1100001],
        [b], [98], [1100010],
        [c], [99], [1100011],
      )
    ],
  )
]

#slide[
  = One-hot encoding


  #ideabox()[Let's get rid of any dependencies!]

  *One-hot encoding:* represent each word as a *binary vector* with a single 1.

  #set text(size: 15pt)
  #align(center)[
    #table(
      columns: (auto, auto, auto, auto, auto, auto, auto, auto),
      align: left,
      [*a*], [1], [0], [0], [0], [0], [...], [0],
      [*aardvark*], [0], [1], [0], [0], [0], [...], [0],
      [*abandon*], [0], [0], [1], [0], [0], [...], [0],
      [*...*], [...], [...], [...], [...], [...], [...], [...],
      [*zyzzyva*], [0], [0], [0], [0], [0], [...], [1],
    )
  ]
  #set text(size: 21pt)

  Each word $w_i$ gets a vector $bold(v) in {0, 1}^(|V|)$ where $|V|$ is the vocabulary size.
]

#slide[
  = Problems with one-hot encoding

  - *Large vectors:* natural languages may contain 100,000+ words → each vector needs to have 100,000+ dimensions.
  - *Extremely sparse:* most entries are 0.

  - *No similarity* between individual words:

  $ bold(v)_"Czechia" dot bold(v)_"Slovakia" = 0 $
  $ bold(v)_"Czechia" dot bold(v)_"computer" = 0 $


  #v(1em)

  → Despite all this, it was the standard *input representation for the early NLP* (Bayes classifiers, logistic regression, early feedforward neural networks, ...)

]

#slide[
  = Representing meaning

  #questionbox()[*What is meaning?* Can you think of a definition that we can  formalize, extract and represent?]

  #show: later
  #v(0.5em)
  - Referential semantics, prototype theories, use-based theories (Wittgenstein), ...
  - *Distributional semantics*: Words that appear in similar contexts have similar meanings
    - "You shall know a word by the company it keeps." (J. R. Firth, 1957)
]


#section-slide(section: "Embeddings")[Word embeddings]

#slide[
  = Word embeddings

  *Word embedding*: dense, low-dimensional vector representation of a word:

  $ "emb": V -> RR^d $

  where $d << |V|$ (think of $d$ between 300 to 10k, $V$ between 50k to 200k).

  #v(1em)

  #align(center)[
    #diagram(
      spacing: (0pt, 1.2em),
      node-stroke: 0.5pt,
      node((0, 0), $x_1$, shape: rect, width: 2.5em, height: 2.2em),
      node((1, 0), $x_2$, shape: rect, width: 2.5em, height: 2.2em),
      node((2, 0), $x_3$, shape: rect, width: 2.5em, height: 2.2em),
      node((3, 0), $dots.c$, stroke: none, width: 2em, height: 2.2em),
      node((4, 0), $x_(d-1)$, shape: rect, width: 3em, height: 2.2em),
      node((5, 0), $x_d$, shape: rect, width: 2.5em, height: 2.2em),
      edge((-1, 0.8), (6, 0.8), "<->", label: $d$, label-side: center),
    )
  ]

  #v(1em)

  *Our goal:* vectors of words with similar meaning are "similar" → close in the $d$\u{2011}dimensional vector space.
]

#slide[
  = How to compute similarity of vectors?

  #grid(
    columns: (1.3fr, 1fr),
    gutter: 0em,
    [

      Cosine similarity $approx$ angle between the vectors
      #block(
        $
          "sim"(bold(v)_1, bold(v)_2) = (bold(v)_1 dot bold(v)_2) / (||bold(v)_1|| ||bold(v)_2||) in angle.l -1, 1 angle.r
        $,
      )

      #v(0.5em)

      #infobox(title: text[Toy example  with $d=3$:])[
        #set text(size: 18pt)
        $bold(v)_"cat" = [0.9, 0.4, 0.1]$ \
        $bold(v)_"dog" = [0.8, 0.5, 0.1]$ \
        $bold(v)_"car" = [0.1, 0.9, -0.4]$,

        #v(0.3em)
        $"sim"(bold(v)_"cat", bold(v)_"dog") approx 0.99$ \
        $"sim"(bold(v)_"cat", bold(v)_"car") approx 0.42$
      ]
    ],
    [
      #image("img/lecture01/cosine_similarity_3d.svg", width: 350pt)

    ],
  )

]
#slide[
  = Cosine similarity -- detail
  *Detailed computation:*


  For $bold(v)_"cat"$ and $bold(v)_"dog"$:

  $
    bold(v)_"cat" dot bold(v)_"dog" & = 0.9 times 0.8 + 0.4 times 0.5 + 0.1 times 0.1 \
                                    & = 0.72 + 0.20 + 0.01 = 0.93
  $

  $
    ||bold(v)_"cat"|| & = sqrt(0.9^2 + 0.4^2 + 0.1^2) = sqrt(0.81 + 0.16 + 0.01) = sqrt(0.98) approx 0.99 \
    ||bold(v)_"dog"|| & = sqrt(0.8^2 + 0.5^2 + 0.1^2) = sqrt(0.64 + 0.25 + 0.01) = sqrt(0.90) approx 0.95
  $

  $
    "sim"(bold(v)_"cat", bold(v)_"dog") = 0.93 / (0.99 times 0.95) approx 0.93 / 0.94 approx 0.99
  $
]

#slide[
  = Trained word embeddings

  #set align(center + horizon)

  👉 https://projector.tensorflow.org

  #image("img/lecture01/embedding_projector.png", width: 500pt)

]

#slide[
  = How to get word embeddings?

  #grid(
    columns: (1.6fr, 1fr),
    gutter: 3em,
    [#questionbox()[
        How to train word embeddings?

        *Hint:* can you recognize the image on the right?
      ]
      #uncover("2-")[
        *Autoencoder*:
        - Neural network acts as a dimensional bottleneck.
        - During training, it needs to learn an efficient representation of the object it encodes.
      ]
    ],
    [
      #set align(center + horizon)

      #image("img/lecture01/Autoencoder_schema.png")

      #source("https://en.wikipedia.org/wiki/Autoencoder", title: "Wikipedia")
    ],
  )
]

#slide[
  = Word2Vec

  #source-slide("https://arxiv.org/abs/1301.3781", title: "Mikolov et al. 2013")

  #grid(
    columns: (3.5fr, 1fr),
    gutter: 2em,
    [
      #infobox(title: "Word embeddings – training objectives")[
        Two variants proposed for *Word2Vec* (Mikolov et al., 2013)

        - Predict a _target word_ from its _context words_ (*CBOW*).
        - Predict _context words_ from a _target word_ (*skip-gram*).
      ]
      #v(1em)

      On the *input*, the words are encoded using one-hot encoding.

      On the *output*, we have a $V$-dimensional vector: a probability score for each word in vocabulary.
    ],
    [ #image("img/lecture01/cbow_and_skipgram.svg", width: 130pt)


      #source("https://ufal.mff.cuni.cz/~courses/npfl129/2526/slides.pdf/npfl129-2526-06.pdf", title: "NPFL129")
    ],
  )
]

#slide[
  = Word2Vec – CBOW

  #source-slide("https://lilianweng.github.io/posts/2017-10-15-word-embedding/", title: "Lil'Log")

  Given context words within a window of size $c$, predict the target word $w_t$:

  #set align(center + horizon)

  #v(-1em)

  #image("img/lecture01/word2vec-cbow.png", width: 45%)

  #set align(left)

  More stable (averaging the context smooths out the noise), faster.
]

#slide[
  = Word2Vec – skip-gram

  #source-slide("https://lilianweng.github.io/posts/2017-10-15-word-embedding/", title: "Lil'Log")

  Given a target word $w_t$, predict context words within a window of size $c$ (one by one):
  #set align(center + horizon)

  #v(-1em)


  #image("img/lecture01/word2vec-skip-gram.png", width: 50%)

  #set align(left)
  #v(1em)

  More efficient use of training data: each word generates $c$ examples.
]


#slide[
  = Word2Vec – how to generate skip-gram examples

  #set align(center + horizon)

  #source-slide("https://ufal.mff.cuni.cz/~courses/npfl129/2526/slides.pdf/npfl129-2526-06.pdf", title: "NPFL129")

  #image("img/lecture01/skipgram_sampling.svgz.svg", width: 100%)
]

#slide[
  = Word2Vec – interesting properties

  #v(0.5em)

  Learned embeddings seem to capture *linear relationships* between words.#text(fill: rgb("#FF0000"), size: 30pt)[\*]

  #align(center)[
    #image("img/lecture01/w2v_relations.svgz.svg", width: 500pt)
  ]

  #v(1em)

  #source-slide("https://ufal.mff.cuni.cz/~courses/npfl129/2526/slides.pdf/npfl129-2526-06.pdf", title: "NPFL129")

  #set text(size: 16pt)

  #text(fill: rgb("#FF0000"), size: 30pt)[\*] With a few caveats: (1) the quality of relationships depends on the training data, (2) the arithmetics does not always work as nicely as expected, (3) closest word is often the word itself.
]



#slide[
  = Other static word embeddings

  - #link("https://nlp.stanford.edu/projects/glove/")[GloVe (Global Vectors)]: Constructs a word co-occurence matrix → factorizes it to get the embeddings.
  - #link("https://fasttext.cc")[FastText]: Word embedding is a sum of substring embeddings → can generate embeddings  of unseen words.
  - #link("https://arxiv.org/abs/2305.16765")[Backpack Language Models (Hewitt et al., 2023)]: combining multiple sense vectors for each word.

  #v(1em)

  #questionbox()[
    What are the limitations of static word embeddings?
  ]
]

#slide[
  = Limitations of static embeddings

  Static embeddings = *a single vector* per word, regardless of context.

  - The word *"bank"* has the same vector whether it means a _financial institution_ or the _side of a river_.
  - (No embedding for unseen words → solved by FastText)

  #ideabox()[Let's compute the embedding of each word on-the-fly!

    #h(0.5em) \+ The embedding will depend on the current context.

    #h(0.5em) \- Cannot pre-compute and pre-download.
  ]
]

#section-slide(section: "Language modeling")[Intermezzo: Language modeling]

#slide[
  = Language modeling

  A *language model* assigns a probability to a sequence of words: $P(w_1, w_2, ..., w_t)$

  #v(0.5em)
  #show: later

  #questionbox[Why can it be useful to know a probability of a sequence of words?]

  #v(0.5em)
  #show: later
  Tells us which sequences of words are more likely than others:
  - First used for *automatic speech recognition (IBM, 1980s)* for disambiguating acoustically similar sequences.
  - Other uses in *machine translation* (→ which translation to choose), spelling correction (→ what is likely grammatically correct), ...
]

#slide[
  = Language modeling for word prediction

  What if we want to use $P(w_1, w_2, ..., w_t)$ to predict the probability of the next word?

  #v(1em)

  Using the *chain rule of probability*, we can decompose this as:

  $
    P(w_1, ..., w_t) & = product_(k=1)^(t) P(w_t | w_1, ..., w_(k-1)) \
                     & = P(w_1) P(w_2 | w_1) P(w_3 | w_1, w_2) ... P(w_t | w_1, ..., w_(k-1))
  $

  #v(1em)

  To predict the *probability of the next word* $v$ in timestep $t$:

  $ P(w_t = v | w_1, ..., w_(t-1)) = (P(w_1, ..., w_(t-1), v))/(P(w_1, ..., w_(t-1))) $
]

#slide[
  = Estimating the n-gram probabilities

  How to estimate $P(w_1, ..., w_t)$?
  #ideabox[
    - Count the occurences of each n-gram $(w_1, ..., w_t)$ for $n in angle.l 1, 2, dots, infinity )$ in our dataset to build a table: $(w_1, ..., w_t)$ → `n_occurences`.
    - Divide `n_occurences` by the total number of occurences to get a probability distribution.
  ]
  #show: later

  #questionbox[Do you see an issue with this approach?]
]

#slide[
  = N-gram language models
  We can relax the problem: approximate $P(w_1, ..., w_t)$ with the last $n-1$ words:

  $ P(w_t | w_1, ..., w_(t-1)) approx P(w_t | w_(t-n+1), ..., w_(t-1)) $

  #v(0.5em)

  → we get an *n-gram language model* (used e.g. in early autocomplete systems).

  #v(0.5em)

  #show: later

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      *Problems:*
      - Most $n$-grams never appear.
      - No dependencies between the individual n-grams.
      - Gets infeasible for $n gt 7$.
    ],
    [

      #infobox(title: "How large are the n-gram tables?")[
        - approx. tens of MB for 2-grams
        - approx. tens to hundreds of GB for 7-grams

        #set text(size: 16pt)
        (depends on training corpus)

      ]
    ],
  )
]


#section-slide(section: "RNNs")[Recurrent neural networks (RNNs)]

#slide[
  = Neural architecture for language processing

  Language strings are *variable-length sequences*.

  #v(0.5em)

  #questionbox[Can we use a feed-forward network for language processing?]

  #show: later

  Sure! We did that to compute the static word embeddings:

  #set align(center + horizon)

  #image("img/lecture01/CBOW_word2vec_as_an_autoencoder.svg", width: 200pt)
  #source-slide("https://en.wikipedia.org/wiki/Word2vec", title: "Wikipedia")
]

#slide[
  = Recurrent neural networks (RNNs)
  However, sometimes we really want to *process the full sequence* to capture long-distance dependencies.

  #source-slide("https://colah.github.io/posts/2015-08-Understanding-LSTMs/", title: "Colah's blog")
  #show: later
  #set align(horizon)
  #ideabox()[
    Let's create a `for`-like loop, processing input of length `N` in `N` steps
  ]

  #set align(center)

  #image("img/lecture01/RNN-unrolled.png", width: 80%)

]
#slide[
  = Recurrent neural networks (RNNs)

  #source-slide("https://colah.github.io/posts/2015-08-Understanding-LSTMs/", title: "Colah's blog")

  - At each time step $t$, the RNN takes an input $x_t$ and updates its hidden state $h_t$.
  - The hidden state $h_t$ accumulates context from all previous words.
  - The *same weights* are shared across all time steps (→ it is essentially a FFNN applied to a single word in a loop.)

  #set align(center + horizon)

  #image("img/lecture01/RNN-unrolled.png", width: 80%)
]



#slide[
  = Issues with RNNs

  #source-slide("https://colah.github.io/posts/2015-08-Understanding-LSTMs/", title: "Colah's blog")
  In theory, RNNs can process sequences of any length.
  #v(1em)

  #show: later

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 3em,
    [
      In practice:
      - *Hidden state is a bottleneck*: all the information about the sequence must be compressed into a single vector $h_t$ with several hundreds of parameters.
      - *Gradients are vanishing*: limited numerical precision make repeated backpropagation over many steps infeasible.
    ],
    [
      #set align(center + horizon)

      #image("img/lecture01/RNN-longtermdependencies.png", width: 100%)
    ],
  )
]


#slide[
  = Solutions: LSTM & GRU

  #source-slide("https://colah.github.io/posts/2015-08-Understanding-LSTMs/", title: "Colah's blog")

  More complex RNN architectures: workaround for these issues until 2018.
  #v(0.5em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    [
      === Long short-term memory (LSTM)

      #set text(size: 16pt)
      #link("https://www.bioinf.jku.at/publications/older/2604.pdf")[Hochreiter & Schmidhuber (1997)]

      - *Forget gate*: what to discard.
      - *Input gate*: what new info to store.
      - *Output gate*: what to output.

      #set align(center + horizon)
      #image("img/lecture01/LSTM3-chain.png", width: 300pt)
    ],
    [
      === Gated recurrent unit (GRU)
      #set text(size: 16pt)
      #link("https://arxiv.org/abs/1406.1078")[Cho et al. (2014)], simplified LSTM variant.

      - *Reset gate*: how much past info to forget.
      - *Update gate*: balance between old and new.

      #set align(center + horizon)

      #image("img/lecture01/LSTM3-var-GRU.png", width: 200pt)
    ],
  )
]

#slide[
  = What to do with the hidden state(s)?

  1. *Classify the final state*: feed $h_N$ to a classifier → prob. distr. over $k$ classes.

    $
      bold(p)(c | w_1, ..., w_N) =
      "softmax"(bold(W) bold(h)_N + bold(b))
    $

    #set align(center + horizon)

    where $bold(W) in RR^(k times d), quad bold(b) in RR^k , quad "softmax"(z_i) = exp(z_i) / (sum_j exp(z_j))$

  #show: later

  Examples:
  - _Sentiment analysis_: This movie rocks! → 👍
  - _Spam detection_: Buy cheap meds online! → ⛔


  #questionbox[Can we use this approach for language modeling?]
]

#slide[
  = Neural language modeling as a classification task

  *Goal:* estimate $P(w_t | w_1, ..., w_(t-1))$ using an RNN.


  #ideabox[We classify the final state into $k$ classes, where $k = |V|$ is the size of our vocabulary.]

  Once again, we classify $bold(h)_N$ with a *linear layer + softmax*:

  $ bold(p)(w_(t+1) | w_1, ..., w_t) = "softmax"(bold(W) bold(h)_N + bold(b)) $
  #set align(center)
  where $bold(W) in RR^(|V| times d), quad bold(b) in RR^(|V|)$


  #set align(left)

  #v(1em)

  → We can estimate the probability more efficiently than with n-gram models.
]

#slide[
  = What to do with the hidden state(s)? – contd.

  2. *Classify each state*: feed $h_t$ at each time step to a classifier → prob. distr. over $k$ classes per word.

  #v(0.5em)

  #show: later

  Examples:
  - _Part-of-speech tagging_: #text(weight: "bold", fill: rgb("#0866c5"))[#underline[Time]#super[NOUN]] #text(weight: "bold", fill: rgb("#ff4500"))[#underline[flies]#super[VERB]] #text(weight: "bold", fill: rgb("#9a32cd"))[#underline[like]#super[ADP]] #text(weight: "bold", fill: rgb("#505050"))[#underline[an]#super[DET]] #text(weight: "bold", fill: rgb("#0866c5"))[#underline[arrow]#super[NOUN]].
  - _Named entity recognition_: #text(weight: "bold", fill: rgb("#207e04"))[#underline[Alan]#super[PER]] #text(weight: "bold", fill: rgb("#207e04"))[#underline[Turing]#super[PER]] #text(weight: "bold", fill: rgb("#808080"))[#underline[was]#super[O]] #text(weight: "bold", fill: rgb("#808080"))[#underline[born]#super[O]] #text(weight: "bold", fill: rgb("#808080"))[#underline[in]#super[O]] #text(weight: "bold", fill: rgb("#c49105"))[#underline[London]#super[LOC]].

  #v(0.5em)

  #infobox(title: "What is different here?")[
    We classify each state separately instead of classifying just the final state.
  ]
]


#slide[
  = What to do with the hidden state(s)? – contd.

  3. *Generate a sequence*: use $h_T$ as an initial state for another RNN (=seq2seq).

  #show: later

  #v(0.5em)

  Examples:
  - _Machine translation_: Language models → Jazykové modely
  - _Summarization_: [...long detailed article...] → AI will destroy humanity.
  - _Question answering_: Why to use LLMs? → To answer all your questions.

  #v(0.5em)

  #questionbox[
    How would you implement that?
  ]
]

#section-slide(section: "Seq2Seq")[Sequence-to-sequence models]

#slide[
  = Sequence-to-sequence (seq2seq) architecture

  #source-slide("https://arxiv.org/abs/1409.3215", title: "Sutskever et al. 2014")

  1. The *encoder* encodes the input $x_1, dots, x_N$ into the *hidden state* $h_N$.

  2. The *decoder* starts with $h_N$ and generates the sequence $y_1, dots, y_M$, at each time step conditioning on the hidden state $h_(t-1)$ and the generated token $y_(t-1)$.


  #set align(center + horizon)

  #image("img/lecture01/seq2seq_diagram.png", width: 500pt)

  #source("https://ufal.mff.cuni.cz/~helcl/courses/npfl116/slides/03-sequence-to-sequence.pdf", title: "NPFL116")

]

#slide[
  = Up next: Can we solve the hidden state bottleneck?
  The entire input is compressed into a *single fixed-size vector* $bold(h)$.

  #questionbox(title: "Question for the next time")[Can we get around this issue?]

  #set align(center + horizon)

  #image("img/lecture01/attn.png", width: 550pt)

  #source-slide("https://cme295.stanford.edu/slides/fall25-cme295-lecture1.pdf", title: "Stanford CME295")

]

#section-slide(section: "Summary")[Summary]

#slide[
  = Summary

  #infobox(title: "Takeaways from today")[

    #item-by-item()[
      - For processing language:
        - We first need to represent it efficiently → *word embeddings*.
        - We then need a way to process variable-length sequences → *RNNs*.
      - The goal of *language modeling* is predicting the probability of a sequence of words
        - We can perform language modeling with RNNs by formulating it as a classification task.
    ]
  ]
]


#slide[
  = Links
  - #link("https://colah.github.io/posts/2015-08-Understanding-LSTMs/")[Understanding LSTM networks] -- Colah's blog
  - #link("https://jalammar.github.io/illustrated-word2vec/")[Illustrated Word2Vec] -- Jay Alammar
  - #link("https://lilianweng.github.io/posts/2017-10-15-word-embedding/")[Learning word embedding] -- Lil'Log
]
