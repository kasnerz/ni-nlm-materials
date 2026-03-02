#import "fit.typ": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#show: fit-theme.with(
  footer-content: "NI-NLM – 03 – Lecture",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Lecture 3",
  subtitle: "Training language models",
  author: "Zdeněk Kasner",
  date: "3 Mar 2026",
)[]

#enable-handout-mode(true)

// ============================================================
// SECTION 1: Training neural networks
// ============================================================
#section-slide(section: "Training neural networks")[Training neural networks]

#slide[
  = Training neural networks

  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    [
      === 🧑‍🍳 Recipe for supervised training of NNs

      #v(1em)

      *Repeat* for each training example $(x, y)$:
      + Let the model *predict* $cal(M)(x) = hat(y)$.
      + Compute a *loss function* $cal(L)(hat(y), y)$: how wrong the model prediction $hat(y)$ is.
      + Compute *gradients*: how each parameter of the model $cal(M)$ contributed to the loss $cal(L)$.
      + Apply *backpropagation*: update the model $cal(M)$ parameters in the direction that reduces the loss $cal(L)$.
    ],
    [
      #set align(center + horizon)

      #image("img/lecture03/tf_playground_before.png", width: 130pt)
      #v(-1em)

      #set text(size: 24pt)
      ↓
      #v(-0.8em)

      #image("img/lecture03/tf_playground_after.png", width: 130pt)],
  )
  #source-slide("https://playground.tensorflow.org/", title: "https://playground.tensorflow.org")

]

#slide[
  = How does training a neural network look like?

  #set align(center + horizon)

  #grid(
    columns: (1fr, 1fr, 1.12fr),
    gutter: 1em,
    [
      #image("img/lecture03/tf_playground_training.png", width: 162pt)
      #source("https://playground.tensorflow.org/", title: "https://playground.tensorflow.org")
    ],
    [#image("img/lecture03/lin_reg_mse_gradientdescent.png")
      #source("https://ml4a.github.io/ml4a/how_neural_networks_are_trained/", title: "https://ml4a.github.io")

    ],
    [#image("img/lecture03/loss_landscape_3d.png")
      #source("https://kaeken.hatenablog.com/entry/2016/11/10/203151", title: "https://kaeken.hatenablog.com/")
    ],
  )
]

#slide[
  = How does training a neural network look like  in Python?

  #set text(size: 11pt)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [```python
    # Repeat in sequence
    num_steps = 1000 # number of training steps
    for step in range(num_steps):

        # Take single document, tokenize it, surround it with BOS special token on both sides
        doc = docs[step % len(docs)]
        tokens = [BOS] + [uchars.index(ch) for ch in doc] + [BOS]
        n = min(block_size, len(tokens) - 1)

        # Forward the token sequence through the model, building up the computation graph all the way to the loss
        keys, values = [[] for _ in range(n_layer)], [[] for _ in range(n_layer)]
        losses = []
        for pos_id in range(n):
            token_id, target_id = tokens[pos_id], tokens[pos_id + 1]
            logits = gpt(token_id, pos_id, keys, values)
            probs = softmax(logits)
            loss_t = -probs[target_id].log()
            losses.append(loss_t)
        loss = (1 / n) * sum(losses) # final average loss over the document sequence. May yours be low.
    ```],
    [
      ```python
          # Backward the loss, calculating the gradients with respect to all model parameters
          loss.backward()

          # Adam optimizer update: update the model parameters based on the corresponding gradients
          lr_t = learning_rate * (1 - step / num_steps) # linear learning rate decay
          for i, p in enumerate(params):
              m[i] = beta1 * m[i] + (1 - beta1) * p.grad
              v[i] = beta2 * v[i] + (1 - beta2) * p.grad ** 2
              m_hat = m[i] / (1 - beta1 ** (step + 1))
              v_hat = v[i] / (1 - beta2 ** (step + 1))
              p.data -= lr_t * m_hat / (v_hat ** 0.5 + eps_adam)
              p.grad = 0

          print(f"step {step+1:4d} / {num_steps:4d} | loss {loss.data:.4f}", end='\r')

      ```


    ],
  )
  #source-slide("https://gist.github.com/karpathy/8627fe009c40f57531cb18360106ce95", title: "Karpathy's microgpt")

]

#slide[
  = Loss function

  A *loss function* measures *how far off* the model's prediction is from the correct answer.

  *How do we measure that?* Depends on our problem.

  #questionbox()[Assume your model predicts a *real number*. How would you measure the error with respect to the ground truth value?]

  - `(true - predicted)`: bad idea, the errors may cancel out
  - `abs(true - predicted)`: ok, but non-differentiable at 0 → training issues
  - `(true - predicted)^2`: works well → smooth, penalizes outliers


]

#slide[
  = Loss function: language modeling

  #questionbox()[Assume your model predicts a *probability distribution for the next word*. How would you measure the error with respect to the ground truth value?]

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 1em,
    [
      #set align(center + horizon)

      #set text(size: 16pt)

      *Model prediction*
      #image("img/lecture03/cross_entropy_model.svg")


    ],
    [
      #set align(center + horizon)

      #set text(size: 16pt)

      *Ground truth*
      #image("img/lecture03/cross_entropy_gt.svg")],

    [
      #set align(center + horizon)

      #set text(size: 16pt)

      *Model error*
      #image("img/lecture03/cross_entropy_overlay.svg")],
  )

]

#slide[
  = Loss function: language modeling


  #set align(center + horizon)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      *What we train for:*
      #image("img/lecture03/output_target_probability_distributions.png")],
    [
      *What we hope to get:*
      #image("img/lecture03/output_trained_model_probability_distributions.png")],
  )

  #source-slide("https://jalammar.github.io/illustrated-transformer/", title: "The Illustrated Transformer")

]

#slide[
  = Cross-entropy loss
  The loss function used for the next word prediction task is called *cross-entropy*:

  $ cal(L) = - sum_(c=1)^(C) y_c dot log(hat(y)_c) $

  where $y_c$ is the true label (one-hot) and $hat(y)_c$ is the predicted probability.

  #v(0.5em)

  #show: later

  #set text(size: 20pt)

  #infobox("Intuition about cross-entropy for language modeling")[
    - The model is supposed to predict the target token with *100% probability* and other tokens with 0% probability → any difference counts as an error.
    - The loss is the *negative log of the predicted target token probability* (why?)
  ]
]

#slide[
  = Loss gradient -- softmax input

  The gradient with respect the softmax input:

  #source-slide(
    "https://ufal.mff.cuni.cz/~straka/courses/npfl138/2425/slides.pdf/npfl138-2425-03.pdf",
    title: "NPFL138",
  )
  #v(-3em)

  #set align(center + horizon)

  #image("img/lecture03/loss_gradient_softmax.png", width: 600pt)
]


#slide[
  = Cross-entropy in language models

  #set align(center + horizon)
  *Let's see it animated:*

  https://animatedllm.github.io/pretraining-simple
  #bordered-box(image("img/lecture03/cross_entropy_animated_llm.png", width: 450pt))
]


#slide[
  = Descending the loss landscape


  #source-slide("https://hackernoon.com/gradient-descent-aynk-7cbe95a778da", title: "Hackernoon")

  Our goal is to *minimize the loss* by iteratively *updating the model parameters $theta$* in the direction that reduces the loss $cal(L)$:

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      #infobox("Gradient descent as a math formula")[$theta <- theta - eta nabla cal(L)(theta)$

        This simply says: we compute the steepest ascent direction ($nabla$) and go the opposite way.
        - $nabla$ is  the *gradient*  of the loss w.r.t. each parameter.

        - $eta$ is the *learning rate*.
      ]
    ],
    [
      #set align(center + horizon)
      #image("img/lecture03/gradient_descent.jpg", width: 100%)
    ],
  )
]

#slide[
  = Computing gradient

  #questionbox()[
    We ended the forward pass by computing the loss. How do we get the gradient?
  ]
  #set align(center + horizon)

  #v(-1em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [#image("img/lecture03/node_forward.svg")], [#image("img/lecture03/node_backward.svg")],
  )

  #source-slide(
    "https://ufal.mff.cuni.cz/~straka/courses/npfl138/2526/slides.pdf/npfl138-2526-02.pdf",
    title: "NPFL138",
  )

  #set align(left)
  We start by computing $(partial cal(L))/(partial y)$  → *the derivative of the loss with respect to the model's output probabilities* (the softmax outputs).

]

#slide[
  = Computing gradient

  Since our loss is computed as:

  $ cal(L) = -log y_"correct", $  then:
  $ (partial cal(L))/(partial hat(y)_c) = cases(-1/hat(y)_c & "for the correct class", 0 & "for all other classes") $

  #v(1em)

  #infobox(
    "Gradient vs. derivative",
  )[Gradient ($nabla$) is how a (partial) *derivative* $partial$ is called for multivariate functions (= functions operating on multi-dimensional inputs).]
]

#slide[
  = Backpropagation

  *Backpropagation* = repeated application of the *chain rule* of derivatives for $f(g(x))$:

  $ (partial f)/(partial x) = (partial f)/(partial g) dot (partial g)/(partial x) $
  #v(0.5em)


  How to apply it? First, build a *computation graph* (example for a simple FFNN):
  #set align(center + horizon)
  #image("img/lecture03/backprob_orig.svg", width: 500pt)

  #source-slide("https://ufal.mff.cuni.cz/~courses/npfl129/2526/slides.pdf/npfl129-2526-05.pdf", title: "NPFL129")


]

#slide[
  = Backpropagation
  ...then apply the *chain rule* in the backward direction:

  #set align(center + horizon)
  #image("img/lecture03/backprob.svg", width: 500pt)

  #set align(left)

  #infobox("Computing the gradient in practice")[
    Modern deep learning frameworks (PyTorch, TensorFlow) have built-in *autograd* functionality that automatically computes gradients for us.

  ]


]


#slide[
  = Stochastic gradient descent

  Computing the gradient over the *entire dataset* at once is #strike[expensive] impossible.


  #ideabox()[
    Instead of using all training examples, we iteratively compute the gradient on *small random subsets* of the training examples.
  ]


  - *Stochastic gradient descent (SGD)*: our subset is of size 1 (=a single example).
  - *Mini-batch SGD*: we take a batch of examples (e.g. 32 examples).


  #show: later

  #questionbox()[
    Is it useful to introduce some stochasticity into the training process?
  ]
]


#slide[
  = Learning rate

  #source-slide("http://cs231n.github.io/neural-networks-3/", title: "CS231n")

  The *learning rate* $eta$ controls how big the parameter update steps are.

  #v(0.5em)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      #infobox("Intuition about learning rate")[
        - *Too high* → may overshoot the minimum, training diverges.
        - *Too low* → converges very slowly, may get stuck in a bad local minimum.
        - It is usually a small multiplier: 0.01, 0.001, ...
      ]
    ],
    [
      #set align(center + horizon)
      #image("img/lecture03/learning_rate.jpg", width: 100%)
    ],
  )
]




#slide[
  = Into the depths of deep learning


  There are other concepts for NN training that we do not cover here, such as:
  - *Weight initialization*: how do we initialize the model weights before training?
  - *Regularization*: how do we prevent the model from overfitting to training data?
  - *Optimizers, momentum*: is there a more efficient approach than SGD?

  #v(0.5em)

  #infobox("If you want to learn more...")[
    #grid(
      columns: (2.5fr, 1fr),
      gutter: 1em,
      [
        See the MFF UK *Deep Learning course* (lectures 1-3, lecture recordings available):

        https://ufal.mff.cuni.cz/courses/npfl138/2526-summer],
      [
        #set align(center + horizon)
        #v(-1.5em)
        #image("img/lecture03/npfl138_poster.png", width: 90pt)],
    )
  ]

]


// ============================================================
// SECTION 2: Pretraining
// ============================================================
#section-slide(section: "Pretraining and pretrained models")[Pretraining the Transformer]


#slide[
  = Supervised training?

  #source-slide("https://arxiv.org/abs/1706.03762", title: "Vaswani et al. (2017)")

  The original Transformer was trained *fully supervised on machine translation*:

  - English → German (WMT 2014, 4.5M sentence pairs)
  - English → French (WMT 2014, 36M sentence pairs)

  #questionbox()[
    Where can we get that much data for other tasks?
  ]

  We *do not have* that much data for other tasks 🥲

  → However, much of what the model was learning during the training was the *structure of the language* itself.
]


#slide[
  = Self-supervised pretraining

  #ideabox()[
    If we train the model for predicting the words in a text, *any text is training data*!

  ]

  #set align(center)
  #image("img/lecture03/self_supervised_pretraining.png", width: 500pt)

  #set align(left)

  - The training regime where the labels come from the input itself is called *self-supervised learning*.
  - We can use it for learning general language representations

    → ...maybe we will then need less data for the specific tasks?
]


#slide[
  = Pretraining a Transformer encoder

  #ideabox()[
    We know the text representation is built in the Transformer *encoder*. Can we start pretraning the encoder alone?]

  We can put classifier on top of the encoded representations to perform classification tasks:

  #v(-2em)

  #set align(center + horizon)

  #image("img/lecture03/BERT-classification-spam.png", width: 600pt)

  #source-slide("https://jalammar.github.io/illustrated-bert/", title: "Illustrated BERT")

]

#slide[
  = Pretraining a Transformer encoder

  *Goal:* Get a rich representation of the input → one _contextual_ embedding per token.

  Each embedding should incorporate the full sentence context (both *left and right*).

  #set align(center + horizon)

  #image("img/lecture03/BERT-language-modeling-masked-lm.png", width: 400pt)


]

#slide[
  = Masked language modeling

  #ideabox()[
    Let's mask some portion (15%? or 30%?) of words  and let the model predict it.]

  The masked language modeling (MLM) objective:
  $ cal(L)_"MLM" = - sum_(t in cal(M)) log P(x_t | bold(x)_(without cal(M))), $

  where $cal(M)$ is the set of masked positions and $bold(x)_(without cal(M))$ is the input sequence with masked tokens replaced by a special [MASK] token.


]

#slide[
  = Masked language modeling


  #set align(center + horizon)

  #v(-1em)

  #image("img/lecture03/bert_mlm_transformations.png", width: 450pt)

  #source-slide(
    "https://www.amazon.com/Super-Study-Guide-Transformers-Language/dp/B0DC4NYLTN",
    title: "Super Study Guide: Transformers & Large Language Models",
  )

  #set align(left)

  #infobox()[The original BERT model also used other transformations (replacing tokens, next sentence prediction), but these were dropped in follow-up models.]

]

#slide[
  = Pretraining a Transformer encoder

  Our setup:
  #v(-1em)

  #set align(center + horizon)

  #v(-1em)

  #image("img/lecture03/bert-transfer-learning.png", width: 550pt)
]


#slide[
  = BERT: Pre-trained Transformer encoder
  *BERT: Pre-training of Deep Bidirectional Transformers for
  Language Understanding* #link("https://arxiv.org/pdf/1810.04805")[(Devlin et al., 2019)] → breakthrough approach for many NLP tasks.


  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [#infobox()[
      The results BERT was getting were very cool -- anything using BERT was suddenly *state-of-the-art*. No one was sure why.


      This started a whole new research field called "#link("https://arxiv.org/abs/2002.12327")[BERTology]".
    ]],
    [
      #set align(center + horizon)

      #image("img/lecture03/bert_pretraining_finetuning.png", width: 280pt)],
  )
]

#slide[
  = The Sesame Street family

  #set text(size: 16pt)

  #grid(
    columns: (1fr, 2.5fr),
    gutter: 2em,
    [#image("img/lecture03/sesame_street_muppets.png", width: 220pt)
      #source("https://muppet.fandom.com/wiki/Sesame_Street")
    ],
    [


      #grid(
        columns: (1fr, 1fr),
        gutter: 1em,
        [
          #bordered-box(image("img/lecture03/elmo_paper.png", width: 250pt))
          #source("https://arxiv.org/pdf/1802.05365", title: "https://arxiv.org/pdf/1802.05365")

          #bordered-box(image("img/lecture03/bert_paper.png", width: 250pt))

          #source("https://arxiv.org/pdf/1810.04805", title: "https://arxiv.org/pdf/1810.04805")


        ],
        [
          #set align(center + horizon)

          #bordered-box(image("img/lecture03/deberta_paper.png", width: 260pt))
          #source("https://arxiv.org/pdf/2007.14062", title: "https://arxiv.org/pdf/2007.14062")

          #bordered-box(image("img/lecture03/xlnet_paper.png"))
          #source("https://arxiv.org/pdf/1905.07129", title: "https://arxiv.org/pdf/1905.07129")


        ],
      )

    ],
  )




]

#slide[
  = Pretraining a Transformer decoder

  #ideabox(
    "Meanwhile in OpenAI...",
  )[The encoder seems kind of useless. The *decoder* can represent the text on its own -- and it can also *generate text*! Can we have more of that, please?]

  #set align(center + horizon)
  #v(-1em)

  #image("img/lecture03/gpt2-sizes-hyperparameters-3.png", width: 400pt)

  #source-slide("https://jalammar.github.io/illustrated-gpt2/", title: "Illustrated GPT-2")
]

#slide[
  = Pretraining a Transformer decoder
  *Decoder-only block*: only masked self-attention & FFNN, no encoder-decoder attention.

  #v(-1em)

  #set align(center + horizon)

  #image("img/lecture03/transformer-decoder-intro.png", width: 600pt)

  #source-slide("https://jalammar.github.io/illustrated-gpt2/", title: "Illustrated GPT-2")


]

#slide[
  = Causal language modeling

  How to pretrain a decoder? Using the *causal language modeling* objective: what we already know as "language modeling" or "next-word prediction task":
  $ cal(L) = - sum_(t=1)^(T) log P(x_t | x_1, ..., x_(t-1)) $

  where $x_t$ is the token at position $t$.

  #set align(center + horizon)

  #image("img/lecture03/causal_lm_objective.png", width: 500pt)
  #source-slide("https://cme295.stanford.edu/slides/fall25-cme295-lecture4.pdf", title: "CME295")

]

#slide[
  = Attention mask


  *Recall*: The attention mechanism in the decoder uses an *attention mask*.


  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    [
      - In practice, we apply a triangular mask during the matrix multiplications:

        → we can train all positions in parallel.

      - The model learns to attend only to the left context.
    ],
    [
      #set align(center + horizon)

      #image("img/lecture03/attention_mask_triangular.png")
    ],
  )

  #source-slide(
    "https://www.amazon.com/Super-Study-Guide-Transformers-Language/dp/B0DC4NYLTN",
    title: "Super Study Guide: Transformers & Large Language Models",
  )

  #questionbox()[
    Why we do *not* need the attention mask in the encoder? And does it mean the encoder "understands" the text better?
  ]
]


#slide[
  = GPT: Pre-trained Transformer decoder

  #source-slide(
    "https://cdn.openai.com/research-covers/language-unsupervised/language_understanding_paper.pdf",
    title: "Radford et al. 2018",
  )
  *The "GPT-1" paper* (#link("https://cdn.openai.com/research-covers/language-unsupervised/language_understanding_paper.pdf")[Improving Language Understanding by Generative Pre-Training (Radford et al., 2018)])
  - 12 layers, 117M params, good results on downstream tasks.
  - Published (pre-print + blogpost) in June 2018 (immediately overshadowed by BERT in October 2018).

  #set align(center + horizon)

  #v(-1em)

  #image("img/lecture03/gpt1_paper.png", width: 400pt)
]

#slide[
  = GPT: Pre-trained Transformer decoder

  *GPT-2:* #link("https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf")[Language Models are Unsupervised Multitask Learners (Radford et al., 2019)]

  Published as a pre-print and a blogpost on the OpenAI website in February 2019:
  #set align(center + horizon)

  #image("img/lecture03/gpt2_blog.png", width: 500pt)


  #source-slide("https://openai.com/index/better-language-models/", title: "OpenAI blog")

]

#slide[
  = GPT: Pre-trained Transformer decoder
  Examples of astounding (back then!) *consistency of text over several paragraphs*:

  #set text(size: 16pt)

  #source-slide("https://openai.com/index/better-language-models/", title: "OpenAI blog")


  #quote()[
    #grid(
      columns: (1fr, 5fr),
      gutter: 1em,
      [
        #set text(size: 12pt)

        System Prompt (human-written)
      ],
      [
        In a shocking finding, scientist discovered a herd of unicorns living in a remote, previously unexplored valley, in the Andes Mountains. Even more surprising to the researchers was the fact that the unicorns spoke perfect English.
      ],
    )
  ]

  #quote()[
    #grid(
      columns: (1fr, 5fr),
      gutter: 1em,
      [
        #set text(size: 12pt)

        Model Completion (machine-written, 10 tries)
      ],
      [
        The scientist named the population, after their distinctive horn, Ovid’s Unicorn. These four-horned, silver-white unicorns were previously unknown to science.


        (...7 more paragraphs...)

        However, Pérez also pointed out that it is likely that the only way of knowing for sure if unicorns are indeed the descendants of a lost alien race is through DNA. “But they seem to be able to communicate in English quite well, which I believe is a sign of evolution, or at least a change in social organization,” said the scientist.
      ],
    )
  ]
]


#slide[
  = GPT: Pre-trained Transformer decoder

  #infobox("GPT-2 release strategy")[
    At first, OpenAI decided to release only the *smallest model* version _"due to concerns about large language models being used to generate deceptive, biased, or abusive language at scale"_. They released all the models within \~6 months.
  ]

  #set align(center + horizon)

  #image("img/lecture03/gpt2-sizes.png", width: 450pt)
]




#slide[
  = Encoder-decoder pretraining

  #questionbox()[
    Can we also *pre-train* the full encoder decoder model?
  ]

  #source-slide("https://arxiv.org/abs/1910.10683", title: "Raffel et al. (2020)")

  #grid(
    columns: (1.2fr, 1fr),
    gutter: 1em,
    [
      *Span corruption* (→ the "denoising" objective):
      - The model needs to predict continuous spans in the sequence.
      - Combines the benefits of bidirectional encoding with autoregressive generation.
    ],
    [
      #image("img/lecture03/span_corruption_t5.png")
    ],
  )
]


#slide[

  #set align(horizon)

  = T5 & BART: Pre-trained Transformer encoder-decoders


  #grid(
    columns: (1.2fr, 1fr),
    gutter: 1em,
    [
      *#link("https://arxiv.org/pdf/1910.10683")[T5 (Raffel et al., 2019)] - Google:*

      #image("img/lecture03/t5_paper.png")
    ],
    [

      *#link("https://arxiv.org/pdf/1910.13461")[BART (Lewis et al., 2019)] - Facebook*:

      #set align(center + horizon)
      #image("img/lecture03/bart_paper.png", width: 300pt)
    ],
  )

  #v(1em)


  - Very similar models (slightly different training objectives & training data).
  - State-of-the-art on *seq2seq tasks* until the rise of large language models.
]

#slide[
  = What we covered
  Three variants of pre-trained Transformer models:

  #source-slide("https://drive.google.com/file/d/1kUvE_zaFC-9jZ_pyp8bXo7gWBwuH5Mo0/view", title: "CSE 517 / CSE 447")

  #set align(center)
  #v(2em)

  #grid(
    columns: (1fr, 1fr, 1.2fr),
    gutter: 1em,
    [
      *Encoder-only (BERT)*
      #image("img/lecture03/encoder_only_architecture.png", width: 180pt)
    ],
    [
      *Decoder-only (GPT)*
      #image("img/lecture03/decoder_only_architecture.png", width: 180pt)
    ],
    [

      *Encoder-decoder (T5, BART)*
      #image("img/lecture03/encoder_decoder_architecture.png", width: 180pt)
    ],
  )

]




#slide[
  = GPT-3

  #ideabox("Meanwhile in OpenAI...")[
    GPT-2 was kinda good. Let's see what happens if we make it *100x as big*!
  ]
  #set align(center + horizon)

  #image("img/lecture03/gpt3_visualization.png", width: 350pt)
  #source("https://bbycroft.net/llm", title: "llm-vis")

]

#slide[
  = GPT-3


  #source-slide("https://arxiv.org/abs/2005.14165", title: "Brown et al. 2020")

  *GPT-3:* #link("https://arxiv.org/abs/2005.14165")[Language Models are Few-Shot Learners (Brown et al. 2020)]
  - *175B parameters* (the largest GPT-2 model was 1.5B parameters)
  - Trained on a mix of Common Crawl, books, Wikipedia.


  #infobox("Biggest surprise: In-context learning")[
    The model could suddenly learn a task from a few examples provided in the input prompt (without any gradient updates).

    - _Zero-shot_: Task description only, no examples.
    - _Few-shot_: Task description + a few examples.
  ]

]



#slide[
  = The LLM evolutionary tree: how it continued

  #source-slide("https://arxiv.org/abs/2304.13712", title: "Yang et al. 2023")

  #grid(
    columns: (2.5fr, 1fr),
    gutter: 0em,
    [
      #set align(center + horizon)
      #image("img/lecture03/llm_evolutionary_tree.png", width: 480pt)
    ],
    [
      #set text(size: 16pt)
      #set align(horizon)

      *Legend:*

      #box(circle(fill: rgb("#F2A3B4"), width: 0.7em, height: 0.7em)) #text(fill: rgb("#F2A3B4"))[*Encoder models*]

      #box(circle(fill: rgb("#74B889"), width: 0.7em, height: 0.7em)) #text(
        fill: rgb("#74B889"),
      )[*Encoder-decoder models*]

      #box(circle(fill: rgb("#8194B0"), width: 0.7em, height: 0.7em)) #text(fill: rgb("#8194B0"))[*Decoder models*]

    ],
  )
]

#section-slide(section: "Finetuning and alignment")[Finetuning and alignment]


#slide[
  = Where are we?

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

      #v(0.2em)
      #stage-box[random neural network]
      #v(-0.2em)
      #step-circle("1") #h(0.2em) #down-arrow
      #v(-0.2em)
      #stage-box["autocomplete on steroids"]

      #text(size: 11pt, style: "italic", fill: muted-color)[base / foundational model]
      #v(-0.2em)
      #step-circle("2") #h(0.2em) #down-arrow
      #v(-0.2em)
      #stage-box[assistant]

      #text(size: 11pt, style: "italic", fill: muted-color)[instruction-tuned model]
      #v(-0.2em)
      #step-circle("3") #h(0.2em) #down-arrow
      #v(-0.2em)
      #stage-box[helpful assistant]
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
    ],
  )
]

#slide[
  = Problems with base models

  Base models are just an *"autocomplete on steroids"* → the following can happen:

  #set text(size: 19pt)


  #grid(
    columns: (1fr, 3.5fr),
    gutter: 1em,
    [
      #set align(horizon)

      *Input*
    ],
    [
      #quote[Explain the moon landing to a 6 year old.]
    ],
  )

  #grid(
    columns: (1fr, 3.5fr),
    gutter: 1em,
    [
      #set align(horizon)

      *Pre-trained model*
    ],
    [
      #quote[Explain why the sky is blue to a 6 year old. Explain why planes can fly to a 6 year old. Explain how to build a car to a 6 year old (...)]
    ],
  )

  #grid(
    columns: (1fr, 3.5fr),
    gutter: 1em,
    [
      #set align(horizon)

      *What we want instead*
    ],
    [
      #quote[Many years ago, people wanted to explore the Moon. So they built a huge rocket called Saturn V and sent astronauts in it. (...)]
    ],
  )
  #set text(size: 20pt)

  #v(0.5em)

  #questionbox()[
    Can this problem be fixed with few-shot prompting?
  ]

]


#slide[
  = Finetuning

  === 🧑‍🍳 Recipe for finetuning a language model:

  + Start from a *pretrained "base" language model*.
  + Prepare a dataset of *(input, output) pairs* for the target task.
  + Continue training with the *same objective* (cross-entropy on the output tokens).

  #v(0.5em)

  #show: later

  #infobox(title: "Why does this work?")[
    The pretrained model has already learned rich language representations. Finetuning only needs to *slightly adjust* the parameters to fit the new task. This is much more data-efficient than training from scratch.
  ]
]



#slide[
  = Instruction tuning

  #source-slide("https://arxiv.org/abs/2109.01652", title: "Wei et al. 2022 (FLAN)")

  *Instruction-tuning:* finetuning the model to *follow instructions*:
  - *Input*: a natural language description of the task + the actual input.
  - *Output*: the expected response.


  #set align(center + horizon)
  #image("img/lecture03/instruction_tuning.png", width: 550pt)

]

#slide[
  = InstructGPT
  *InstructGPT*: #link("https://arxiv.org/pdf/2203.02155")[Training language models to follow instructions with human feedback (Ouyang et al., 2022)] → released \~6 months before ChatGPT.
  #set align(center + horizon)

  #image("img/lecture03/instructgpt_training_overview.png", width: 450pt)
]

#slide[
  = Problems with instruction-tuned models

  Even the instruction-tuned model may still produce *harmful or toxic* content, be *unhelpful*, or refuse reasonable requests.
  #image("img/lecture03/llama_refuses_kill_process.png")
  #v(-0.5em)

  #source(
    "https://www.reddit.com/r/LocalLLaMA/comments/15442iy/totally_useless_llama_70b_refuses_to_kill_a/",
    title: "Reddit.com",
  )

  → We want to find steer the model from unhelpful answers in a fine-grained way.

  #questionbox()[Can we just apply supervised finetuning again?]
]

#slide[
  = Reinforcement learning from human feedback (RLHF)

  🧑‍⚖️ *Step 0 -- Gather human annotators*.


  ⚖️ *Step 1 -- Collect pairwise rankings*:

  #pad(left: 2em)[
    - Generate two outputs $(y_1, y_2)$ for the same prompt $x$.
    - Have annotators rank them: $r(x, y)$.
  ]


  ⚙️ *Step 2 -- Align the model using reinforcement learning*

  #pad(left: 2em)[
    - Optimize the LLM using the ranking $r(x, y)$ as a reward signal.
      - Include a penalty to prevent  drifting too far from the original model:
    $ cal(L)_"RLHF" = -EE[r(x, y)] + beta dot "KL"(pi_theta || pi_"ref") $

  ]
]


#slide[
  = RLHF - Reward model (→RLAIF)

  #ideabox()[
    Human annotators are costly and slow. Can we replace them with a *model*?
  ]

  Yes: we can train a *reward model* on the collected human feedback:
  #set align(center + horizon)

  #v(-1em)

  #image("img/lecture03/reward-model.png", width: 280pt)

  #source-slide("https://huggingface.co/blog/rlhf", title: "HF blog")

]

#slide[
  = RLHF - Reward model (→RLAIF)

  ...and then *replace human annotators* with the reward model:

  #set align(center + horizon)

  #image("img/lecture03/rlhf_hf.png", width: 350pt)

]





#slide[
  = Direct preference optimization (DPO)

  #source-slide("https://arxiv.org/abs/2305.18290", title: "Rafailov et al. 2023")

  *DPO* skips the reward model and RL entirely.

  #v(0.5em)

  Given pairs of (preferred, dispreferred) responses, DPO directly optimizes a *special loss function* (where $y_w$ = preferred response, $y_l$ = dispreferred response):

  $
    cal(L)_"DPO" = -log sigma (beta log (pi_theta (y_w | x)) / (pi_"ref" (y_w | x)) - beta log (pi_theta (y_l | x)) / (pi_"ref" (y_l | x)))
  $

  #set align(center + horizon)

  #image("img/lecture03/dpo_diagram.jpg", width: 600pt)
]


// ============================================================
// SUMMARY
// ============================================================
#section-slide(section: "Summary")[Summary]

#slide[
  = Summary

  #infobox(title: "What we covered today")[
    - *Training NNs*: loss functions, gradient descent, SGD, backpropagation, learning rate.
    - *Pretraining*: self-supervised objectives (CLM, MLM, span corruption).
    - *Pretrained models*: BERT, GPT, T5 and their variants; the LLM timeline.
    - *Supervised finetuning*: adapting pretrained models to specific tasks; instruction tuning.
    - *Alignment*: RLHF, DPO -- making models helpful and safe.
  ]
]

#slide[
  = Links

  - #link("https://arxiv.org/abs/1810.04805")[BERT: Pre-training of deep bidirectional Transformers] -- Devlin et al. (2019)
  - #link("https://arxiv.org/abs/2005.14165")[Language models are few-shot learners (GPT-3)] -- Brown et al. (2020)
  - #link("https://arxiv.org/abs/1910.10683")[Exploring the limits of transfer learning (T5)] -- Raffel et al. (2020)
  - #link("https://arxiv.org/abs/2203.02155")[Training language models to follow instructions (InstructGPT)] -- Ouyang et al. (2022)
  - #link("https://arxiv.org/abs/2305.18290")[Direct preference optimization (DPO)] -- Rafailov et al. (2023)
  - #link("https://huggingface.co/blog/rlhf")[Illustrating RLHF] -- Hugging Face blog
  - #link("https://ruder.io/optimizing-gradient-descent/")[An overview of gradient descent optimization algorithms] -- Ruder (2016)
  - #link("https://jalammar.github.io/illustrated-bert/")[The Illustrated BERT] -- Jay Alammar
]
