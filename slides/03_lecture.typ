#import "fit.typ": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#show: fit-theme.with(
  footer-content: "NI-NLM – 03 – Lecture",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Lecture 3",
  subtitle: "LLM Training",
  author: "Zdeněk Kasner",
  date: "3 Mar 2026",
)[]

#enable-handout-mode(true)

// ============================================================
// SECTION 1: Training neural networks
// ============================================================
#section-slide(section: "Training")[Training neural networks]

#slide[
  = Training neural networks

  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    [
      === 🧑‍🍳 Recipe for supervised training of NNs

      #v(1em)

      *Repeat* for each training example $(x, y)$:
      + Let the model *predict* $cal(M)(x,y) = hat(y)$.
      + Compute a *loss function* $cal(L)(hat(y), y)$: how wrong the model prediction $hat(y)$ is.
      + Compute *gradients*: how each parameter of the model $cal(M)$ contributed to the loss $cal(L)$.
      + Apply *backpropagation*: update the model $cal(M)$ parameters in the direction that reduces the loss $cal(L)$.
    ],
    [
      #set align(center + horizon)

      #image("img/lecture03/screen-2026-02-25-17-04-50.png", width: 130pt)
      #v(-1em)

      #set text(size: 24pt)
      ↓
      #v(-0.8em)

      #image("img/lecture03/screen-2026-02-25-17-04-39.png", width: 130pt)],
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
      #image("/assets/screen-2026-02-26-13-59-08.png", width: 162pt)
      #source("https://playground.tensorflow.org/", title: "https://playground.tensorflow.org")
    ],
    [#image("img/lecture03/lin_reg_mse_gradientdescent.png")
      #source("https://ml4a.github.io/ml4a/how_neural_networks_are_trained/", title: "https://ml4a.github.io")

    ],
    [#image("img/lecture03/20161110202746.png")
      #source("https://kaeken.hatenablog.com/entry/2016/11/10/203151", title: "https://kaeken.hatenablog.com/")
    ],
  )
]

#slide[
  = Training a language model -- closer look

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

  A *loss function* (or cost function) measures *how far off* the model's prediction is from the correct answer.

  *How do we measure that?* Depends on our problem.

  #questionbox()[Assume your model predicts a *real number*. How would you measure the error with respect to the ground truth value?]

  - `(true - predicted)`: bad idea, the errors may cancel out
  - `abs(true - predicted)`: ok, but non-differentiable at 0 → training issues
  - `(true - predicted)^2`: works well → smooth, penalizes large errors


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


  #infobox("Intuition about cross-entropy for language modeling")[
    - The model is supposed to predict the target token with *100% probability*.
    - Any difference between these probabilities is considered as an *error*.
    - The value of the loss is a *negative logarithm of the difference*. (why?)
    - We ignore model predictions for any other tokens. (why?)

  ]
]



#slide[
  = Cross-entropy in language models

  #set align(center + horizon)
  *Let's see it animated:*

  https://animatedllm.github.io/pretraining-simple
  #bordered-box(image("img/lecture03/screen-2026-02-26-16-40-13.png", width: 450pt))
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

        This simply says: we compute the steepest ascent direction ($nabla$) and go the opossite way.
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
  $ (partial cal(L))/(partial y_c) = cases(-1/y_c & "for the correct class", 0 & "for all other classes") $

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
  ...then apply the *chain rule* it in the backward direction:

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
  - *Mini-batch SGD*: we a take a batch of examples (e.g. 32 examples).


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
  - *Optimizers*: is there are more efficient approach than SGD?

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
        #image("img/lecture03/poster.png", width: 90pt)],
    )
  ]

]


// ============================================================
// SECTION 2: Pretraining
// ============================================================
#section-slide(section: "Pretraining")[Pretraining the Transformer]


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
  #image("img/lecture03/screen-2026-02-26-17-32-54.png", width: 500pt)

  #set align(left)

  - The training regime where the labels come from the input itself is called *self-supervised learning*.
  - We can use it for learning general language representations

    → ...maybe we will then need less data for the specific tasks?
]


#slide[
  = Pretraining a Transformer encoder

  #ideabox()[
    We know the text representation is built in the Transformer *encoder*. Can we start pretraning the encoder alone?]

  Good representations might help us with classification tasks:

  #v(-1em)

  #set align(center + horizon)

  #image("img/lecture03/BERT-classification-spam.png", width: 600pt)

  #source-slide("https://jalammar.github.io/illustrated-bert/", title: "Illustrated BERT")

]

#slide[
  = Pretraining a Transformer encoder
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [

      *Our goal:* Get a rich representation of the input text (one embedding per token).


      - The resulting word embedding should incorporate the full sentence context (both *left and right*).
      - Can we mask a word and let the model predict it?
        - Yes, but too slow → let's mask \~15% of words at a time.


    ],
    [
      #set align(center + horizon)

      #image("img/lecture03/BERT-language-modeling-masked-lm.png")

    ],
  )
  → the *masked language modeling* objective.
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

  How to pretrain a decoder? Using *causal language modeling*: what we already know as "language modeling" or "next-word prediction task":

  $ P(w_1, ..., w_T) = product_(t=1)^(T) P(w_t | w_1, ..., w_(t-1)) $

  #v(0.5em)

  #grid(
    columns: (2.7fr, 1fr),
    gutter: 2em,
    [
      #v(-0.5em)


      #infobox("Attention mask")[
        Masking the future tokens is what allows *parallel training*: we can compute the loss at all positions at once, even though each position "pretends" it cannot see the future.
      ]
    ],
    [
      #set align(center + horizon)

      #image("img/lecture03/self-attention-and-masked-self-attention.png", width: 190pt)],
  )
]


#slide[
  = GPT-2: Pre-trained Transformer decoder

  #source-slide(
    "https://cdn.openai.com/research-covers/language-unsupervised/language_understanding_paper.pdf",
    title: "Radford et al. 2018",
  )

  *Generative Pre-trained Transformer*

  - Transformer *decoder only*.
  - Pretrained with *causal language modeling* (next-word prediction).
  - GPT-1 (2018): 12 layers, 117M params. Finetuned for downstream tasks.

  #v(0.5em)

  #show: later

  *GPT-2* (2019): scaled up to *1.5B params*, trained on WebText (8M web pages).

  #source(
    "https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf",
    title: "Radford et al. 2019",
  )

  #v(0.5em)

  Key finding: the model can perform tasks *without any finetuning* -- just from the pretraining data. This is what later became known as *zero-shot* capabilities.

]



#slide[
  = Encoder-decoder pretraining

  #source-slide("https://arxiv.org/abs/1910.10683", title: "Raffel et al. 2020 (T5)")

  The encoder-decoder Transformer uses *span corruption* (denoising):

  #v(0.5em)

  - Replace random *contiguous spans* with sentinel tokens (`<extra_id_0>`, `<extra_id_1>`, ...).
  - The decoder generates only the *masked spans* (not the full text).

  #v(0.5em)

  *Example (T5):*

  #set text(size: 16pt)

  Input: `"The <X> brown <Y> over the lazy dog"`

  Target: `"<X> quick <Y> fox jumps"`

  #set text(size: 20pt)

  #v(0.5em)

  This combines the benefits of bidirectional encoding with autoregressive generation.
]


#slide[
  = T5

  #source-slide("https://arxiv.org/abs/1910.10683", title: "Raffel et al. 2020")

  *Text-to-Text Transfer Transformer*

  - *Encoder-decoder* architecture.
  - All tasks framed as *text-to-text*: input text → output text.

  #v(0.5em)

  *Example*:
  - Translation: `"translate English to German: That is good"` → `"Das ist gut"`
  - Summarization: `"summarize: ..."` → summary
  - Classification: `"sentiment: great movie"` → `"positive"`

  #v(0.5em)

  - Trained on C4 (Colossal Clean Crawled Corpus, ~750GB of text).
  - Various sizes: 60M to 11B parameters.
  - Systematically compared many design choices (architecture, objectives, data).
]




#slide[
  = GPT-3

  #source-slide("https://arxiv.org/abs/2005.14165", title: "Brown et al. 2020")

  *175B parameters*, trained on a mix of Common Crawl, books, Wikipedia.

  #v(0.5em)

  Key contribution: *in-context learning* -- the model can learn from a few examples provided in the input prompt, without any gradient updates.

  #v(0.5em)

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.5em,
    [
      === Zero-shot
      Task description only, no examples.
    ],
    [
      === One-shot
      Task description + one example.
    ],
    [
      === Few-shot
      Task description + a few examples.
    ],
  )

  #v(0.5em)

  #infobox()[
    GPT-3 demonstrated that *scale alone* can unlock new capabilities. This was the starting point of the "scaling era" of LLMs.
  ]
]





#slide[
  = The LLM evolutionary tree (up to 2023)

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



#slide[
  = Finetuning -- how it works

  #v(0.5em)

  + Start from a *pretrained checkpoint* (e.g. LLaMA-3-8B).
  + Prepare a dataset of *(input, output) pairs* for the target task.
  + Continue training with the *same objective* (cross-entropy on the output tokens).
  + Use a *lower learning rate* than pretraining (the model is already close to a good solution).

  #v(0.5em)

  #show: later

  #ideabox(title: "Why does this work?")[
    The pretrained model has already learned rich language representations. Finetuning only needs to *slightly adjust* the parameters to fit the new task. This is much more data-efficient than training from scratch.
  ]
]


#slide[
  = Instruction tuning

  #source-slide("https://arxiv.org/abs/2109.01652", title: "Wei et al. 2022 (FLAN)")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      A special form of finetuning: train the model to *follow instructions*.

      #v(0.5em)

      Training data format:
      - *Instruction*: a natural language description of the task.
      - *Input*: the actual input for the task (optional).
      - *Output*: the expected response.

      #v(0.5em)

      *Example*:
      - Instruction: "Translate the following sentence to French."
      - Input: "How are you?"
      - Output: "Comment allez-vous?"
    ],
    [
      #set align(center + horizon)
      #image("img/lecture03/instruction_tuning.png", width: 100%)
    ],
  )
]

#slide[
  = Parameter-efficient finetuning (PEFT)

  #source-slide("https://arxiv.org/abs/2106.09685", title: "Hu et al. 2021 (LoRA)")

  Finetuning *all parameters* of a large model is expensive. Can we finetune only *a few*?

  #v(0.5em)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      *LoRA* (Low-Rank Adaptation):
      - Add two small matrices $A in RR^(d times r)$ and $B in RR^(r times d)$ parallel to each weight matrix.
      - Only train $A$ and $B$ (where $r << d$).
      - The update $Delta W = B A$ is added to the original weights.
      - Much fewer trainable parameters: $2 times r times d$ instead of $d^2$.

      #v(0.5em)

      *QLoRA*: LoRA + 4-bit quantization → finetune a 65B model on a single GPU.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture03/lora_diagram.png", width: 100%)

      #source("https://arxiv.org/abs/2305.14314", title: "Dettmers et al. 2023")
    ],
  )
]


// ============================================================
// SECTION 5: Alignment
// ============================================================
#section-slide(section: "Alignment")[Alignment]

#slide[
  = The alignment problem

  A pretrained (or instruction-tuned) model can generate fluent text, but it may still:

  - *Hallucinate* facts.
  - Produce *harmful or toxic* content.
  - Be *unhelpful* or refuse reasonable requests.
  - Not follow the user's *intent*.

  #v(0.5em)

  #ideabox(title: "Alignment")[
    Make the model *helpful, harmless, and honest* -- aligned with human preferences.
  ]

  #v(0.5em)

  #show: later

  The key idea: use *human feedback* to teach the model what "good" output looks like, beyond what can be captured by next-token prediction.
]


#slide[
  = LLM training pipeline

  The standard training pipeline for modern LLMs has *three stages*:

  #v(1em)

  #set text(size: 18pt)

  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 1em,
    [
      === 1. Pretraining
      - Self-supervised on massive text data.
      - Learn general language knowledge.
      - Trillions of tokens.
      - Hundreds of GPUs for weeks/months.
    ],
    [
      === 2. Supervised finetuning
      - Instruction-following data.
      - Learn to be helpful and follow instructions.
      - Thousands to millions of examples.
      - Much cheaper than pretraining.
    ],
    [
      === 3. Alignment
      - Human preference data.
      - Learn to produce outputs humans prefer.
      - RLHF, DPO, or variants.
      - The "secret sauce" of ChatGPT.
    ],
  )
]


#slide[
  = Reinforcement learning from human feedback (RLHF)

  #source-slide("https://arxiv.org/abs/2203.02155", title: "Ouyang et al. 2022 (InstructGPT)")

  *RLHF* was the key technique behind InstructGPT and ChatGPT.

  #v(0.5em)

  #set align(center + horizon)
  #image("img/lecture03/rlhf_hf.png", width: 500pt)

  #source("https://huggingface.co/blog/rlhf", title: "Hugging Face RLHF blog")
]


#slide[
  = RLHF -- step by step

  #source-slide("https://arxiv.org/abs/2203.02155", title: "Ouyang et al. 2022")

  #set text(size: 18pt)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      *Step 1: Collect comparison data*
      - Generate multiple outputs for the same prompt.
      - Have humans *rank* them (which output is better?).

      #v(0.5em)

      *Step 2: Train a reward model*
      - A separate model that takes (prompt, response) → score.
      - Trained on human preference data.
      - Learns to predict which response humans would prefer.
    ],
    [
      *Step 3: Optimize the policy with RL*
      - Use the reward model as a signal.
      - Optimize the LLM to produce outputs that get high reward.
      - Usually with *PPO* (Proximal Policy Optimization).
      - Include a *KL divergence penalty* to prevent the model from drifting too far from the SFT model.

      $ cal(L)_"RLHF" = -EE[r(x, y)] + beta dot "KL"(pi_theta || pi_"ref") $
    ],
  )
]


#slide[
  = InstructGPT / ChatGPT

  #source-slide("https://arxiv.org/abs/2203.02155", title: "Ouyang et al. 2022")

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      *InstructGPT* = GPT-3 finetuned with RLHF:

      + Start from GPT-3.
      + SFT on human-written demonstrations.
      + Train a reward model on human comparisons.
      + Optimize with PPO using the reward model.

      #v(0.5em)

      Key result: InstructGPT (1.3B) was *preferred by humans* over the much larger GPT-3 (175B).

      #v(0.5em)

      *ChatGPT* (Nov 2022) used the same approach, applied to GPT-3.5.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture03/instructgpt_overview.jpg", width: 100%)
    ],
  )
]


#slide[
  = Direct preference optimization (DPO)

  #source-slide("https://arxiv.org/abs/2305.18290", title: "Rafailov et al. 2023")

  RLHF works but is *complex*: three models, unstable PPO, reward hacking. Can we do better?

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      *DPO* skips the reward model and RL entirely.

      #v(0.5em)

      Given pairs of (preferred, dispreferred) responses, DPO directly optimizes a *special loss function*:

      $
        cal(L)_"DPO" = -log sigma (beta log (pi_theta (y_w | x)) / (pi_"ref" (y_w | x)) - beta log (pi_theta (y_l | x)) / (pi_"ref" (y_l | x)))
      $

      where $y_w$ = preferred response, $y_l$ = dispreferred response.

      #v(0.5em)

      - *Increases* probability of preferred responses.
      - *Decreases* probability of dispreferred responses.
      - The reference model $pi_"ref"$ prevents too large updates.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture03/dpo_diagram.jpg", width: 100%)
    ],
  )
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
