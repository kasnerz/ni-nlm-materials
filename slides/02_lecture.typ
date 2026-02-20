#import "fit.typ": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#show: fit-theme.with(
  footer-content: "NI-NLM – 02 – Lecture",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Lecture 2",
  subtitle: "Tokenization & the Transformer architecture",
  author: "Zdeněk Kasner",
  date: "24 Feb 2026",
)[]

#enable-handout-mode(true)

#section-slide(section: "Recap")[Recap & math refresher]

#slide[
  = Recap from last lecture

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      === Last time, we covered:
      - How to represent *language*?
      - What is language *modeling*?
      - How to process language with *neural networks*?
        - Also how to do language modeling with neural networks.
    ],
    [
      === Today, we will cover:

      How to process language in a more *efficient and scalable way*?

      (→ tokenization, attention, Transformer)


      #image("img/lecture01/attn.png", width: 100%)
      #source("https://cme295.stanford.edu/slides/fall25-cme295-lecture1.pdf", title: "Stanford CME295")
    ],
  )
]

#slide[
  = Matrix multiplication

  Given matrices $bold(A) in RR^(m times n)$ and $bold(B) in RR^(n times p)$, their product $bold(C) = bold(A) bold(B)$ is:

  $ C_(i,j) = sum_(k=1)^(n) A_(i,k) B_(k,j) $


  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    [

      *Example:* matrix-vector multiplication:
      #set align(center + horizon)
      $
        mat(a_(1,1), a_(1,2); a_(2,1), a_(2,2)) dot mat(b_1; b_2) = mat(a_(1,1) b_1 + a_(1,2) b_2; a_(2,1) b_1 + a_(2,2) b_2)
      $

      $ underbrace((2 times 2), bold(A)) dot underbrace((2 times 1), bold(b)) = underbrace((2 times 1), bold(c)) $
    ],
    [
      #image("img/lecture02/Matrix_multiplication_qtl1.svg")
      #source("https://en.wikipedia.org/wiki/Matrix_multiplication", title: "Wikipedia")

    ],
  )
]


#slide[
  = Single-layer feed-forward neural network

  A single-layer *feed-forward neural network* (FFNN) applies a linear transformation (using the matrix $bold(W)$ and bias $bold(b)$) followed by a non-linear function $sigma$ (ReLU, GELU, ...):

  $
    bold(y)_1 & = sigma(bold(W)_1 bold(x) + bold(b)_1) \
  $

  #v(0.5em)


  *Example:* FFNN with ReLU applied on a vector $bold(x)$:

  #set text(size: 16pt)

  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    [ $
      underbrace(mat(-0.38, 1.35; 0.70, 0.30; -1.03, -1.03), bold(W)_1 in RR^(3 times 2)) dot underbrace(mat(-0.88; 0.73), bold(x) in RR^2) + underbrace(mat(0.10; 0.21; -0.48), bold(b)_1 in RR^3) &= underbrace(mat(1.42; -0.19; -0.33), bold(z) in RR^3) \
      "ReLU"(mat(1.42; -0.19; -0.33)) &= underbrace(mat(1.42; 0.00; 0.00), bold(y)_1 in RR^3)
    $],
    [#image("img/lecture02/ReLU_and_GELU.svg", width: 190pt)

      #source("https://en.wikipedia.org/wiki/Rectified_linear_unit", title: "Wikipedia")
    ],
  )

]

#slide[
  = Softmax

  Given a vector $bold(x) in RR^d$, *softmax* ensures that $forall x_i >= 0$ and $sum(bold(x)) = 1$:

  $ "softmax"(x_i) = exp(x_i) / (sum_(j=1)^(K) exp(x_j)) $

  #infobox("How to think about softmax")[
    A convenient way how to transform any vector to a valid probability distribution.
  ]

  #v(0.5em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [*Example*:

      #set align(center + horizon)

      $bold(z) &= [2.0, 1.0, 0.1] \
      "softmax"(bold(z)) &= [0.659, 0.243, 0.099]$],
    [

      *Implementation in `numpy`*:
      ```python
      def softmax(x):
          return np.exp(x) / np.sum(np.exp(x))
      ```],
  )




]

#slide[
  = Why softmax?


  Given a vector $bold(x) in RR^d$, *softmax* ensures that $forall x_i >= 0$ and $sum(bold(x)) = 1$:
  ```python
  def softmax(x):
      return np.exp(x) / np.sum(np.exp(x))
  ```
  #set align(left)

  #v(0.5em)
  However, the same can be achieved with these two normalization functions:

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    ```python
    def l1_norm(x):
        return np.abs(x) / np.sum(np.abs(x))
    ```,
    ```python
    def min_sum_norm(x):
        x_norm = (x - np.min(x))
        return x_norm / np.sum(x_norm)
    ```,
  )

  #questionbox()[
    What are the specifics and (dis)advantages of each of these three functions?
  ]
]


// ============================================================
// SECTION 2: Tokenization
// ============================================================
#section-slide(section: "Tokenization")[Tokenization]

#slide[
  = From words to tokens

  *Tokenization* = splitting text into smaller units (*tokens*) that the model will process.

  We assumed that our input is a *sequence of words*. That sounds good in theory, but worse in practice:

  #v(0.5em)

  #questionbox()[
    How would you split these strings into meaningful units?
    - `Pneumonoultramicroscopicsilicovolcanoconiosis`
    - `大型语言模型`
    - `🤗❤🍾🥳`
  ]

]

#slide[
  = Why subword tokenization?

  #ideabox()[
    Keep the common words, split rare words into subwords.
  ]


  *Compare*:


  - Word-level:     `["unhappiness"]` → out of vocabulary
  - Character-level:     `["u","n","h","a","p","p","i","n","e","s","s"]`
  - Subword:     `["un", "happiness"]` ✓


  #questionbox()[How to decide where to split the subwords?]
]

#slide[
  = Byte pair encoding (BPE)

  #source-slide("https://arxiv.org/abs/1508.07909", title: "Sennrich et al. 2016")

  Originally a data compression algorithm, adapted for NLP tokenization.

  #v(0.5em)

  #infobox(title: "BPE algorithm")[
    1. Start with a vocabulary of all *individual characters* in the training corpus.
    2. Count all *adjacent pairs* of tokens in the corpus.
    3. *Merge* the most frequent pair into a new token.
    4. *Repeat* steps 2--3 until the desired vocabulary size is reached.
  ]

  #v(0.5em)

  The result is a *merge table* that defines how to tokenize any new text.

  #text(fill: rgb("#b10101"))[*📝 Exercise time!*]
]

#slide[
  = BPE -- step by step


  Corpus: `"aab baac aab baac caaba aac"` → initial vocabulary: `{a, b, c, ▁}`

  #v(0.5em)

  #table(
    columns: (auto, auto, auto),
    align: left,
    table.header([*Step*], [*Most frequent pair*], [*New token*]),
    [1], [`(a, a)` → 6 times], [`aa`],
    [2], [`(aa, b)` → 3 times], [`aab`],
    [3], [`(aa, c)` → 3 times], [`aac`],
    [4], [`(aab, ▁)` → 2 times], [`aab▁`],
  )

  #v(0.5em)

  Final vocabulary: `{▁, a, b, c, aa, aab, aac, aab▁}`

  #v(0.5em)

  Typical vocabulary sizes in practice: *50k--200k* tokens.
]

#slide[
  = Tokenizer playground

  #set align(center + horizon)

  How do real tokenizers split text?

  #v(0.5em)

  👉 #link("https://huggingface.co/spaces/Xenova/the-tokenizer-playground")

  #v(1em)
  #bordered-box(image("img/lecture02/screen-2026-02-20-15-39-10.png", width: 400pt))

  Notice the difference between languages.
]


// ============================================================
// SECTION 3: Attention in RNNs
// ============================================================
#section-slide(section: "Attention")[Attention mechanism]

#slide[
  = The seq2seq bottleneck

  #source-slide("https://arxiv.org/abs/1409.3215", title: "Sutskever et al. 2014")

  Remember: the encoder compresses the *entire input* into a single vector $bold(h)_N$.

  #v(0.5em)

  - Works OK for short sequences, but for longer inputs the *information gets lost*.
  - The decoder has no way to "look back" at specific parts of the input.

  #set align(center + horizon)

  #image("img/lecture01/seq2seq_diagram.png", width: 450pt)

  #source("https://ufal.mff.cuni.cz/~helcl/courses/npfl116/slides/03-sequence-to-sequence.pdf", title: "NPFL116")
]

#slide[
  = Attention -- the idea

  #source-slide("https://arxiv.org/abs/1409.0473", title: "Bahdanau et al. 2015")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      #ideabox()[Instead of compressing everything into one vector, let the decoder *attend to all encoder hidden states* at each step.]

      #v(0.5em)

      At each decoding step $t$:
      1. Compute a *score* for each encoder state $bold(h)_i$.
      2. Normalize scores with *softmax* → attention weights $alpha_(t,i)$.
      3. Compute a *weighted sum* (context vector): $bold(c)_t = sum_i alpha_(t,i) bold(h)_i$
      4. Use $bold(c)_t$ together with the decoder state to predict the next token.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture02/encoder_decoder_attention.png", width: 100%)
      #source("https://lilianweng.github.io/posts/2018-06-24-attention/", title: "Lil'Log")
    ],
  )
]

#slide[
  = Bahdanau (additive) attention

  #source-slide("https://arxiv.org/abs/1409.0473", title: "Bahdanau et al. 2015")

  #grid(
    columns: (1.2fr, 1fr),
    gutter: 1em,
    [
      The score function uses a *learned feed-forward network*:

      $ e_(t,i) = bold(v)^top tanh(bold(W)_1 bold(s)_(t-1) + bold(W)_2 bold(h)_i) $

      $ alpha_(t,i) = "softmax"(e_(t,i)) = exp(e_(t,i)) / (sum_j exp(e_(t,j))) $

      $ bold(c)_t = sum_(i) alpha_(t,i) bold(h)_i $

      where $bold(s)_(t-1)$ is the decoder state and $bold(h)_i$ is the $i$-th encoder state.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture02/bahdanau_attention.png", width: 100%)
      #source("https://lilianweng.github.io/posts/2018-06-24-attention/", title: "Lil'Log")
    ],
  )
]

#slide[
  = Luong (dot-product) attention

  #source-slide("https://arxiv.org/abs/1508.04025", title: "Luong et al. 2015")

  Simpler: use the *dot product* to compute the score:

  $ e_(t,i) = bold(s)_t^top bold(h)_i $

  or a *general* (bilinear) variant:

  $ e_(t,i) = bold(s)_t^top bold(W) bold(h)_i $

  #v(0.5em)
  #infobox(title: "Key difference")[
    - *Bahdanau*: concat + learned layer → more expressive, slower.
    - *Luong*: dot product → simpler, faster, and it turns out to work just as well.
  ]
]

#slide[
  = Attention -- visualized

  The attention weights show *which input tokens the decoder focuses on* at each step.

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      For machine translation, the attention matrix often resembles a *soft alignment* between the source and target sentences.

      #v(0.5em)

      This was a major breakthrough: finally, the model could *learn alignments on its own*, without any external alignment tool.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture02/sentence_attention_example.png", width: 100%)
      #source("https://lilianweng.github.io/posts/2018-06-24-attention/", title: "Lil'Log")
    ],
  )
]

#slide[
  = From RNN attention to self-attention

  #set align(horizon)

  So far, attention was used *between* the encoder and decoder (cross-attention).

  #v(0.5em)

  #questionbox()[What if we use attention *within* a single sequence? Each word attending to every other word in the same sequence?]

  #show: later
  #v(0.5em)

  This is called *self-attention* -- and it is the key building block of the Transformer.

  #v(0.5em)

  #ideabox()[And what if we get rid of the RNN entirely and use *only* attention?]
]


// ============================================================
// SECTION 4: The Transformer
// ============================================================
#section-slide(section: "Transformer")[The Transformer]

#slide[
  = Attention is all you need

  #source-slide("https://arxiv.org/abs/1706.03762", title: "Vaswani et al. 2017")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      The paper that changed everything.

      #v(0.5em)

      *Key ideas:*
      - Replace RNNs entirely with *self-attention*.
      - Process all tokens *in parallel* (no sequential bottleneck).
      - Use *positional encoding* to inject position information.
      - Stack multiple layers of attention + feed-forward networks.

      #v(0.5em)

      Originally proposed for *machine translation*, but the architecture turned out to be universal.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture02/transformer_full.png", width: 200pt)
      #source("https://lilianweng.github.io/posts/2018-06-24-attention/", title: "Lil'Log")
    ],
  )
]

#slide[
  = Transformer -- high-level view

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  The Transformer follows the *encoder-decoder* pattern -- same as seq2seq, but without any recurrence.

  #set align(center + horizon)

  #image("img/lecture02/transformer_encoders_decoders.png", width: 400pt)

  #set align(left)

  - *Encoder*: reads the input sequence, produces a rich representation.
  - *Decoder*: generates the output sequence, one token at a time.
]

#slide[
  = The encoder-decoder stack

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  Both encoder and decoder are *stacks of identical layers* (blocks).

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      - The original Transformer uses *$N = 6$* layers for both.
      - Each layer refines the representation.
      - The output of the last encoder layer is passed to *every* decoder layer.

      #v(0.5em)
      #infobox(title: "Scaling up")[
        Modern LLMs use many more layers: GPT-3 has 96, LLaMA-70B has 80.
      ]
    ],
    [
      #set align(center + horizon)
      #image("img/lecture02/transformer_encoder_decoder_stack.png", width: 100%)
    ],
  )
]

#slide[
  = Inside an encoder block

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  Each encoder block has two sub-layers:

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      1. *Self-attention layer*
        - Each token looks at all other tokens.
        - Captures dependencies regardless of distance.

      2. *Feed-forward network (FFN)*
        - Applied to each token independently.
        - Same weights for every position.

      Both sub-layers have a *residual connection* and *layer normalization*.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture02/transformer_encoder_lillog.png", width: 100%)
      #source("https://lilianweng.github.io/posts/2018-06-24-attention/", title: "Lil'Log")
    ],
  )
]

// ============================================================
// Self-attention deep dive
// ============================================================
#slide[
  = Self-attention -- intuition

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      The goal of self-attention: for each token, compute a *new representation* that incorporates information from *all tokens* in the sequence.

      #v(0.5em)

      _"The animal didn't cross the street because *it* was too tired."_

      #v(0.5em)

      When processing _"it"_, the model should attend strongly to _"animal"_ (not _"street"_).
    ],
    [
      #set align(center + horizon)

      #image("img/lecture02/self_attention_visualization_2.png", width: 250pt)
    ],
  )
]

#slide[
  = Self-attention -- query, key, value

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  For each token embedding $bold(x)_i$, we compute three vectors:

  $ bold(q)_i = bold(W)^Q bold(x)_i, quad bold(k)_i = bold(W)^K bold(x)_i, quad bold(v)_i = bold(W)^V bold(x)_i $

  #set align(center + horizon)

  #image("img/lecture02/self_attention_vectors.png", width: 500pt)

  #set align(left)

  - *Query* ($bold(q)$): "what am I looking for?"
  - *Key* ($bold(k)$): "what do I contain?"
  - *Value* ($bold(v)$): "what information do I provide?"
]

#slide[
  = Self-attention -- computing scores

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  For a given query $bold(q)_i$:

  1. Compute the *dot product* $bold(q)_i dot bold(k)_j$ for all keys → raw scores.
  2. *Scale* by $1 / sqrt(d_k)$ (to keep gradients stable).
  3. Apply *softmax* to get attention weights.
  4. *Weighted sum* of value vectors.

  #set align(center + horizon)

  #image("img/lecture02/self_attention_score.png", width: 500pt)
]

#slide[
  = Self-attention -- softmax and output

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  #set align(center + horizon)

  #image("img/lecture02/self_attention_softmax.png", width: 450pt)

  #set align(left)
  #v(0.5em)

  The output for token $i$ is a *weighted mixture* of all value vectors. Tokens with higher attention weights contribute more.
]


#slide[
  = Scaled dot-product attention -- matrix form

  #source-slide("https://arxiv.org/abs/1706.03762", title: "Vaswani et al. 2017")

  In practice, we compute everything in *one matrix operation*:

  $ "Attention"(bold(Q), bold(K), bold(V)) = "softmax"((bold(Q) bold(K)^top) / sqrt(d_k)) bold(V) $

  where $bold(Q) in RR^(n times d_k)$, $bold(K) in RR^(n times d_k)$, $bold(V) in RR^(n times d_v)$.

  #set align(center + horizon)
  #image("img/lecture02/self_attention_matrix_calculation_2.png", width: 500pt)
]

// ============================================================
// Multi-head attention
// ============================================================
#slide[
  = Multi-head attention -- why?

  #source-slide("https://arxiv.org/abs/1706.03762", title: "Vaswani et al. 2017")

  A single attention head captures *one type of relationship*. But words relate to each other in many ways:
  - syntactic (subject–verb),
  - semantic (co-reference),
  - positional (adjacent words),
  - ...

  #v(0.5em)

  #ideabox()[Run *multiple attention heads in parallel*, each with its own $bold(W)^Q$, $bold(W)^K$, $bold(W)^V$ -- and let each head learn a different pattern.]
]

#slide[
  = Multi-head attention -- how it works

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      With $h$ heads and model dimension $d$:
      - Each head uses $d_k = d_v = d / h$.
      - Each head computes its own Q, K, V and produces an output $bold(Z)_i$.

      $ "head"_i = "Attention"(bold(Q)_i, bold(K)_i, bold(V)_i) $

      The heads are *concatenated* and projected:

      $ "MultiHead" = [bold(Z)_1; ...; bold(Z)_h] bold(W)^O $

      where $bold(W)^O in RR^(h d_v times d)$.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture02/multi_head_attention.png", width: 100%)
      #source("https://lilianweng.github.io/posts/2018-06-24-attention/", title: "Lil'Log")
    ],
  )
]

#slide[
  = Multi-head attention -- visualization

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  #set align(center + horizon)
  #image("img/lecture02/multihead_recap.png", width: 550pt)

  #set align(left)

  Each head produces its own attention output → they are concatenated → multiplied by $bold(W)^O$ to get the final output.
]


// ============================================================
// Residual connections, layer norm, FFN
// ============================================================
#slide[
  = Residual connections & layer normalization

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      Each sub-layer (attention or FFN) is wrapped in:

      $ "LayerNorm"(bold(x) + "SubLayer"(bold(x))) $

      #v(0.5em)

      *Residual connection* ($bold(x) +$ ...):
      - Helps gradients flow through deep networks.
      - The layer only needs to learn the *"delta"*.

      #v(0.5em)
      *Layer normalization*:
      - Normalizes across features (not across batch).
      - Stabilizes training.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture02/residual_layernorm_2.png", width: 100%)
    ],
  )
]

#slide[
  = Position-wise feed-forward network

  Applied to *each token independently* (same weights, different inputs):

  $ "FFN"(bold(x)) = bold(W)_2 dot "ReLU"(bold(W)_1 bold(x) + bold(b)_1) + bold(b)_2 $

  where $bold(W)_1 in RR^(d times d_"ff")$, $bold(W)_2 in RR^(d_"ff" times d)$.

  #v(0.5em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #infobox(title: "Dimensions")[
        In the original Transformer:
        - $d = 512$ (model dimension)
        - $d_"ff" = 2048$ (inner dimension, 4$times$ larger)
      ]
    ],
    [
      #infobox(title: "What does the FFN do?")[
        No interaction between positions -- that is the job of self-attention. The FFN processes each token *on its own*, acting as a *per-token memory* storing factual knowledge.
      ]
    ],
  )
]

// ============================================================
// Positional encoding
// ============================================================
#slide[
  = Positional encoding -- why do we need it?

  Self-attention is *permutation-invariant*: if we shuffle the input tokens, the attention scores would be the same (up to the same permutation).

  #v(0.5em)

  #questionbox()[
    Why is that a problem? _"The cat sat on the mat"_ and _"mat the on sat cat the"_ should be different!
  ]

  #show: later
  #v(0.5em)

  #ideabox()[
    We need to *inject position information* into the input embeddings so that the model can distinguish token order.
  ]
]

#slide[
  = Positional encoding -- sinusoidal

  #source-slide("https://arxiv.org/abs/1706.03762", title: "Vaswani et al. 2017")

  The original Transformer uses *fixed sinusoidal functions*, added to the token embeddings:

  $ bold(x)_i = "Embed"(w_i) + "PE"(i) $

  $ "PE"(p, 2i) & = sin(p / 10000^(2i \/ d)), quad "PE"(p, 2i+1) = cos(p / 10000^(2i \/ d)) $

  where $p$ is the position and $i$ is the dimension index.

  #v(0.5em)
  - Each position gets a *unique encoding*.
  - Nearby positions have *similar encodings*.
  - The model can learn to attend to *relative positions*.

  #set text(size: 17pt)
  Modern models often use *learned* positional embeddings or *rotary positional encoding* (RoPE) instead.
]

#slide[
  = Positional encoding -- visualization

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  #set align(center + horizon)

  #image("img/lecture02/positional_encoding_large.png", width: 550pt)

  #set align(left)
  #v(0.5em)

  #set text(size: 17pt)
  Each row is a positional encoding vector. The pattern changes across dimensions: low-frequency sinusoids on the left, high-frequency on the right.
]

// ============================================================
// The decoder
// ============================================================
#slide[
  = The decoder

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      The decoder has *three sub-layers* per block:

      1. *Masked self-attention*
        - Each token can only attend to previous tokens (no peeking into the future).

      2. *Encoder-decoder (cross) attention*
        - Queries come from the decoder, keys and values come from the encoder output.

      3. *FFN*
        - Same as in the encoder.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture02/transformer_decoder_lillog.png", width: 200pt)
      #source("https://lilianweng.github.io/posts/2018-06-24-attention/", title: "Lil'Log")
    ],
  )
]

#slide[
  = Masked self-attention

  #source-slide("https://arxiv.org/abs/1706.03762", title: "Vaswani et al. 2017")

  During training, we know the full target sequence. But we must prevent the decoder from *looking ahead*.

  #v(0.5em)

  We apply a *mask* to the attention scores before softmax:

  $ "MaskedAttention"(bold(Q), bold(K), bold(V)) = "softmax"((bold(Q) bold(K)^top) / sqrt(d_k) + bold(M)) bold(V) $

  where $bold(M)$ is a matrix with $0$ for allowed positions and $-infinity$ for future positions.

  #v(0.5em)

  #infobox(title: "Effect")[
    $exp(-infinity) = 0$ → after softmax, future tokens get zero attention weight. Token $t$ can only attend to tokens $1, ..., t$.
  ]
]

#slide[
  = Encoder-decoder attention

  In the cross-attention sub-layer:
  - *Queries* come from the decoder (previous sub-layer).
  - *Keys* and *values* come from the *encoder output*.

  #v(0.5em)

  $ "CrossAttention"(bold(Q)_"dec", bold(K)_"enc", bold(V)_"enc") $

  #v(0.5em)

  This allows every decoder position to attend over *all positions in the input* -- just like the attention mechanism in the RNN seq2seq, but more powerful.

  #v(0.5em)

  #infobox(title: "This is the bridge")[
    Cross-attention is what connects the encoder and decoder. Without it, the decoder would have no access to the source sequence.
  ]
]

// ============================================================
// Output and training
// ============================================================
#slide[
  = Output layer

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  The final decoder output is projected to vocabulary size and passed through *softmax*:

  $ P(w_t | w_1, ..., w_(t-1), bold(x)) = "softmax"(bold(W)_"out" bold(h)_t + bold(b)) $

  #set align(center + horizon)

  #image("img/lecture02/decoder_output_softmax.png", width: 400pt)

  #set align(left)
  Same idea as neural language modeling from Lecture 1 -- but now the hidden state $bold(h)_t$ is much richer thanks to attention.
]

#slide[
  = Training the Transformer

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      *Objective:* maximize the probability of the correct target tokens.

      → *Cross-entropy loss* between predicted distribution and one-hot target:

      $ cal(L) = - sum_(t=1)^T log P(w_t^* | w_1^*, ..., w_(t-1)^*, bold(x)) $

      #v(0.5em)

      Thanks to masking, we can compute the loss for *all positions in parallel* during training (unlike RNNs!).

      → *Teacher forcing*: use the ground-truth tokens as decoder input.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture02/transformer_training_loss.png", width: 100%)
    ],
  )
]

#slide[
  = Why is the Transformer better than RNNs?

  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    [
      === RNNs
      - Sequential processing → *slow*.
      - Information must pass through *all intermediate states*.
      - Gradient vanishing over long distances.
      - Hidden state is a *bottleneck*.
    ],
    [
      === Transformer
      - Parallel processing → *fast*.
      - Any token can directly attend to *any other token* (path length = 1).
      - Stable gradients with residual connections.
      - No bottleneck: information distributed across *all positions*.
    ],
  )

  #v(0.5em)

  #infobox(title: "Computational cost")[
    Self-attention is $O(n^2 dot d)$ per layer. For very long sequences, this can be expensive -- but there are efficient attention variants (→ later lectures).
  ]
]

// ============================================================
// Transformer variants
// ============================================================
#slide[
  = Transformer variants

  The original Transformer is encoder-decoder. But there are *three main variants*:

  #v(0.5em)

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 1em,
    [
      #infobox(title: "Encoder-only")[
        BERT, RoBERTa

        - Bidirectional context.
        - Good for *classification*, *NER*, *retrieval*.
        - Cannot generate text.
      ]
    ],
    [
      #infobox(title: "Decoder-only")[
        GPT, LLaMA, Gemma

        - Autoregressive (left-to-right).
        - Good for *text generation*, *language modeling*.
        - The dominant LLM architecture today.
      ]
    ],
    [
      #infobox(title: "Encoder-decoder")[
        T5, BART, mBART

        - Full seq2seq.
        - Good for *translation*, *summarization*.
        - Less common now in large-scale LLMs.
      ]
    ],
  )
]

#slide[
  = The decoder-only Transformer

  Most modern LLMs (GPT-4, Claude, LLaMA, ...) are *decoder-only*:
  - No encoder, no cross-attention.
  - The input and output are *one single sequence*.
  - Uses *masked (causal) self-attention* throughout.

  #v(0.5em)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      For each position $t$, the model predicts the next token:

      $ P(w_(t+1) | w_1, ..., w_t) $

      At inference, we generate tokens *autoregressively* -- feeding each generated token back as input.
    ],
    [
      #infobox(title: "Why decoder-only?")[
        - Simpler architecture.
        - Scales well.
        - Unifies many tasks under "generate the answer".
      ]
    ],
  )
]

// ============================================================
// Transformer at scale
// ============================================================
// ============================================================
// Summary
// ============================================================
#section-slide(section: "Summary")[Summary]

#slide[
  = Summary

  #infobox(title: "What we covered today")[
    - *Refresher*: matrix multiplication, FFNNs, softmax.
    - *Tokenization*: subword tokenization with BPE.
    - *Attention*: solving the seq2seq bottleneck (Bahdanau, Luong).
    - *The Transformer*:
      - Self-attention with Q, K, V → scaled dot-product attention.
      - Multi-head attention → multiple parallel attention heads.
      - Positional encoding → injecting position information.
      - Residual connections + layer normalization.
      - Encoder-decoder architecture + decoder-only variants.
  ]

  #v(0.5em)
  *Next time:* pre-training objectives, training data, finetuning, RLHF.
]

#slide[
  = Links

  - #link("https://jalammar.github.io/illustrated-transformer/")[The Illustrated Transformer] -- Jay Alammar
  - #link("https://lilianweng.github.io/posts/2018-06-24-attention/")[Attention? Attention!] -- Lil'Log
  - #link("https://nlp.seas.harvard.edu/annotated-transformer/")[The Annotated Transformer] -- Harvard NLP
  - #link("https://arxiv.org/abs/1706.03762")[Attention is all you need] -- Vaswani et al. 2017
  - #link("https://arxiv.org/abs/1409.0473")[Neural machine translation by jointly learning to align and translate] -- Bahdanau et al. 2015
  - #link("https://arxiv.org/abs/1508.07909")[Neural machine translation of rare words with subword units] -- Sennrich et al. 2016
  - #link("https://huggingface.co/spaces/Xenova/the-tokenizer-playground")[Tokenizer playground] -- Hugging Face
]
