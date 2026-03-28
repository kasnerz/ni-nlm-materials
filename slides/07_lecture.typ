#import "fit.typ": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#show: fit-theme.with(
  footer-content: "NI-NLM – 07 – Lecture",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Lecture 7",
  subtitle: "RAG, tool calling, structured outputs, agents.",
  author: "Zdeněk Kasner",
  date: "31 Mar 2026",
)[]

#enable-handout-mode(false)



#section-slide(section: "Retrieval-augmented generation")[Retrieval-augmented generation]

#slide[
  = Problems with LLM knowledge

  LLM knowledge is *static, lossy and incomplete*.

  #show: later

  #questionbox()[When this can become a problem?]

  #v(0.5em)

  When we need the model to access:
  - Up-to-date information (news, weather, timetables, ...).
  - Domain-specific knowledge (internal company docs, law / medical / ...).


  We may also want to access external knowledge *ourselves* to check the LLM's answers.

  #v(0.5em)



]


#slide[
  = Retrieval-augmented generation (RAG)

  #source-slide("https://arxiv.org/abs/2005.11401", title: "Lewis et al. (2020)")

  #ideabox(
    title: "Idea",
  )[Combine the LLM with a *retrieval system*: first retrieve relevant documents, then use them as context for generation → "retrieval augmented generation"]


  The idea was first introduced by #link("https://arxiv.org/abs/2005.11401")[Lewis et al. (2020)]:

  #set align(center + horizon)

  #image("img/lecture07/rag_lewis2020.png", width: 550pt)
]


#slide[
  = RAG pipeline

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents",
    title: "Maarten Grootendorst's blog",
  )

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      #uncover("1-")[
        === Phase \#1: Indexing
        + Split the documents into chunks.
        + Compute their embeddings.
        + Store them in a vector database.
      ]


      #uncover("2-")[
        === Phase \#2: Querying
        + Embed the user prompt.
        + Retrieve relevant chunks.
        + Concatenate them with the prompt.
        + Generate an answer.
      ]
    ],
    [
      #v(-1em)

      #uncover("1-")[
        #image("img/lecture07/rag_indexing.png", width: 250pt)]
      #uncover("2-")[#image("img/lecture07/rag_querying.png", width: 250pt)]
    ],
  )
]


#slide[
  = Indexing -- Step 1: Document chunking

  Raw documents need to be split into  chunks before indexing:

  #v(0.5em)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
  )[
    - *Fixed-size chunks*: split every $N$ tokens (simple, but can break context).
    - *Semantic chunking*: split at sentence/paragraph/section boundaries.
    - *Sliding-window with overlaps*: fixed-size chunks with some overlap to preserve context.
  ][
    #image("img/lecture07/chunking_strategies.png")
    #source(
      "https://masteringllm.medium.com/11-chunking-strategies-for-rag-simplified-visualized-df0dbec8e373",
      title: "Medium.com",
    )
  ]
  Good starting point: \~256--1024 tokens, with 10--20% overlap.

  Too small → loss of context. Too large → diluted relevance and noise.
]

#slide[
  = Indexing -- Step 2: Embedding

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents",
    title: "Maarten Grootendorst's blog",
  )

  Each chunk is converted to a dense vector (embedding).

  #set align(center)

  #image("img/lecture07/emb.png", width: 500pt)


  #set align(left)
  #v(0.5em)

  *Embedding models*:
  - encoder-based: finetuned BERT-like models, see the #link("https://sbert.net/index.html")[SentenceTransformers library].
  - decoder-based: OpenAI's `text-embedding-3`, `e5`, `qwen3-embedding`, ...

]

#slide[
  = Indexing -- Step 2: Embedding

  #source-slide("https://dspace.cuni.cz/handle/20.500.11956/206938", title: "Sajdoková (2026)")

  #warnbox()[
    Decoder embedding models perform much worse if not *prompted* properly.
  ]
  #grid(
    columns: (1fr, 1.25fr),
    gutter: 1em,
    [
      #set text(size: 16pt)
      ```python
      # Each query must come with a one-sentence instruction that describes the task
      task = 'Given a web search query, retrieve relevant passages that answer the query'
      ```
      #source(
        "https://huggingface.co/Qwen/Qwen3-Embedding-8B",
        title: "https://huggingface.co/Qwen/Qwen3-Embedding-8B",
      )
      #set text(size: 20pt)

      Note there is no actual retrieval → we just *"prime" the model* to build a good representation of the query.
    ],
    [
      #image("img/lecture07/embedding_prompt_comparison.png", width: 450pt)
    ],
  )
]


#slide[
  = Indexing -- Step 3: Vector database

  #source-slide(
    "https://qdrant.tech/articles/what-is-a-vector-database/",
    title: "https://qdrant.tech/articles/what-is-a-vector-database/",
  )

  The created embeddings are stored in a *vector database* (#link("https://qdrant.tech")[Qdrant], #link("https://www.trychroma.com")[Chroma], #link("https://faiss.ai")[FAISS], ...):

  #set align(center + horizon)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [ #set align(center + horizon)
      #image("img/lecture07/hnsw.png", width: 280pt)

    ],
    [
      #set align(center + horizon)
      #image("img/lecture07/simple-arquitecture.png", width: 280pt)

    ],
  )


]

#slide[
  = Querying -- Steps 1-2: Retrieval

  #source-slide(
    "https://cme295.stanford.edu/slides/fall25-cme295-lecture7.pdf",
    title: "CME295",
  )

  At *query time*, we embed the user query and find the most similar chunks:

  #set align(center + horizon)
  #image("img/lecture07/rag_retrieval_query.png", width: 500pt)


  #set align(left)

  Similarity is typically measured using *cosine similarity* or *dot product* between the query and document embeddings.
]

// #slide[
//   = Querying -- Steps 1-2: Retrieval

//   #source-slide(
//     "https://cme295.stanford.edu/slides/fall25-cme295-lecture7.pdf",
//     title: "CME295",
//   )

//   We can also apply a more expensive *re-ranker* (e.g., a Transformer encoder) on the *retrieved chunks* to achieve better accuracy:
//   #set align(center + horizon)

//   #grid(
//     columns: (1fr, 1fr),
//     gutter: 3em,
//     [
//       #image("img/lecture07/screen-2026-03-20-10-32-53.png", width: 300pt)
//     ],
//     [
//       #image("img/lecture07/screen-2026-03-20-10-27-23.png", width: 400pt)
//     ],
//   )


// ]


#slide[
  = Querying -- Steps 3-4: Generation

  The retrieved chunks are inserted into the prompt as *context*:

  #v(0.25em)

  #set text(size: 18pt)
  ```
  System: You are a helpful assistant. Answer based on the provided context.

  Context:
  [Chunk 1]: "The Transformer architecture was introduced by Vaswani et al. in 2017..."
  [Chunk 2]: "Self-attention allows the model to weigh different positions..."

  User: What is the key innovation of the Transformer?
  ```

  #set text(size: 20pt)

  #questionbox()[Can a RAG-based answer be _worse_ than without RAG?]
]


#slide[
  = Towards better RAG

  #source-slide("https://arxiv.org/abs/2312.10997", title: "Gao et al. (2024)")


  #grid(
    columns: (1.7fr, 1fr),
    gutter: 1em,
  )[
    The basic pipeline can be improved at every step:

    - We can apply *query rewriting* to rephrase the query for better retrieval.
    - We can use *hybrid search* -- combine dense retrieval with keyword-based search (e.g. BM25).
    - We can *rerank* the retrieved results e.g. using a cross-encoder (heavier, but more precise).
    - We can retrieve the documents *iteratively* (→ heading towards LLM agents).
  ][
    #set align(center + horizon)

    #image("img/lecture07/rag-paradigms.png", width: 250pt)
  ]
]


#slide[
  = RAG in practice

  RAG is now a standard for building knowledge-intensive LLM applications (in combination with LLM agents):


  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      - *Company internal knowledge*: "talk to your knowledge base".
      - *Customer support bots* with access to the internal knowledge bases.
      - *Code assistants* that retrieve from documentation and codebase.
      - *Legal / medical AI*: retrieve from domain-specific corpora.
    ],
    [

      There are now many frameworks that facilitate RAG:

      #v(1em)


      #grid(
        columns: (1fr, 1fr),
        gutter: 1em,
        [
          #link("https://github.com/deepset-ai/haystack")[#image("img/lecture07/logo_haystack.png", width: 120pt)]
          #link("https://python.langchain.com/docs/modules/data_connection/")[#image(
            "img/lecture07/logo_langchain.svg",
            width: 150pt,
          )]
        ],
        [
          #link("https://docs.llamaindex.ai/en/stable/optimizing/production_rag/")[#image(
            "img/lecture07/logo_llamaindex.svg",
            width: 150pt,
          )]
          #link("https://github.com/infiniflow/ragflow")[#image("img/lecture07/logo_ragflow.svg", width: 150pt)]
        ],
      )

      (...and #link("https://github.com/Danielskry/Awesome-RAG?tab=readme-ov-file#-frameworks-that-facilitate-rag")[many more]).
    ],
  )




  // Frameworks: #link("https://www.langchain.com/")[LangChain], #link("https://www.llamaindex.ai/")[LlamaIndex], #link("https://haystack.deepset.ai/")[Haystack], ...


]


#section-slide(section: "Tool calling")[Tool calling]


#slide[
  = Tool use: the basic idea

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents",
    title: "Maarten Grootendorst's blog",
  )

  RAG works as long as the information can be fetched based on the user query.

  But what if LLMs need to access external resources *during generation*?


  #ideabox()[We give the LLM the capability to generate tool calls.]

  #set align(center + horizon)

  #image("img/lecture07/tool_json_call.png", width: 500pt)


]




#slide[
  = Toolformer

  *Toolformer* #link("https://arxiv.org/abs/2302.04761")[(Schick et al. 2023)]: one of the most influential *LLM tool-calling* papers.

  #source-slide("https://arxiv.org/abs/2302.04761", title: "Schick et al. (2023)")
  #grid(
    columns: (1.3fr, 1fr),
    gutter: 1em,
    [
      - An LLM finetuned on a corpus containing *examples of tool calls*.
      - The corpus built in a self-supervised way:
        - Another (few-shot prompted) LLM suggests tool calls.
        - The suggestions that reduce LM loss are inserted in the corpus.
      - *Tools:* QA system, Wikipedia search, calculator, calendar, MT system
    ],
    [
      #set align(center + horizon)

      #image("img/lecture07/example.png", width: 250pt)
    ],
  )

]

#slide[
  = How tool calling works

  #source-slide("https://rlhfbook.com/c/13-tools", title: "https://rlhfbook.com/c/13-tools")


  Once the model generates the tool call:

  + the *output is evaluated* using an external tool,
  + the *result is appended* to the generated text.

  #set align(center + horizon)
  #image("img/lecture07/tool_use_generation.png", width: 700pt)
  // #image("img/lecture07/toolformer_step3.png", width: 700pt)
]

#slide[
  = How to scale tool calling

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents",
    title: "Maarten Grootendorst's blog",
  )
  There are many tools that a model can potentially call → describing the interface of each of them can be cumbersome.

  #set align(center + horizon)
  #v(-1em)

  #image("img/lecture07/mcp_too_many_tools.png", width: 450pt)
]

#slide[
  = Welcome the MCP

  #source-slide(
    "https://modelcontextprotocol.io/docs/learn/server-concepts",
    title: "https://modelcontextprotocol.io/docs/learn/server-concepts",
  )


  *Model Context Protocol (MCP)*: standardized way to access tools based on JSON.

  #set text(size: 17pt)
  *Example tool specification*
  ```json
  {
    "name": "get_weather",
    "description": "Get current weather for a city",
    "inputSchema": {
      "type": "object",
      "properties": {
        "city": {"type": "string", "description": "City name"}},
      "required": ["city"]}
  }
  ```

  *Example: what the model returns*
  ```json
  {"name": "get_weather", "arguments": {"city": "Prague"}}
  ```

]



#slide[
  = MCP architecture

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents",
    title: "Maarten Grootendorst's blog",
  )

  MCP describes not just the JSON format, but the entire tool-calling architecture:

  - *MCP client*: the application managing the LLM (VSCode, Claude Code, ...)
  - *MCP server*: the application that can be managed with tools (Github, database, ...)

  #set align(center + horizon)
  #image("img/lecture07/mcp_architecture.png", width: 450pt)
]




#slide[
  = Issues with MCP

  MCP tool descriptions can use up a lot of input tokens:
  #set align(center + horizon)

  #v(-1em)

  #image("img/lecture07/mcp_toomanytools_02.png", width: 500pt)

  #set align(left)

  → This is currently an open issue.

  Can be mitigated with #link("https://cursor.com/blog/dynamic-context-discovery#")[dynamic content discovery] or replacing MCP with #link("https://claude.com/skills")[skills] (`.md` files that include description of the tool's CLI) instead.

  #source-slide(
    "https://demiliani.com/2025/09/04/model-context-protocol-and-the-too-many-tools-problem/",
    title: "https://demiliani.com/2025/09/04/model-context-protocol-and-the-too-many-tools-problem/",
  )
]

#section-slide(section: "Structured outputs")[Structured outputs]

#slide[
  = Enforcing output format

  There is no guarantee whatsoever on how the LLM output will look like.

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
  )[
    #set text(size: 16pt)

    === Expected output:
    ```json
    {
      "companies": [
        {"name": "Apple", "revenue": 365},
        {"name": "Microsoft", "revenue": 168}
      ]
    }
    ```
  ][
    #set text(size: 16pt)

    === Actual output:
    ````
    Sure! Here's the information you requested:
    ```json
    {
      "companies": [
        {"name": "Apple", "revenue": 365},
    ...
    ```
    I hope this helps!
    ````
  ]
  #questionbox()[How might we enforce that the output will look exactly as required?]
]


#slide[
  = Basic ways to control LLM output

  === Solution #1: Answer prefix

  Prefix model's answer to guide its response.

  === Prompt:
  ```json
  {
    "user" : "Generate a single-paragraph weather forecast based on the data: [data]"
    "assistant": "Sure, here is the required forecast: \n\""
  }
  ```

  → Very simple cases only.
]


#slide[
  = Basic ways to control LLM output

  === Solution #2: Prompt specifications + few-shot prompting

  Describe the desired output format *very precisely* (+ include examples).

  #grid(gutter: 2em, columns: (1fr, 1fr))[
    #set text(size: 16pt)

    === Prompt:
    ```
    CRITICAL: You MUST respond in EXACTLY the specified format with no additional text, explanations, or commentary. Do NOT include any introductory phrases, reasoning, or extra content. Any deviation from this exact format will cause system failure.
    ```
  ][
    #set text(size: 20pt)

    #v(60pt)

    #align(center)[#image("img/lecture07/llm_format_prompt_tweet.png", width: 100%)
      #source("https://xcancel.com/ChatGPTapp/status/1768486286527173049", title: "@ChatGPTapp")]

  ]
  #v(10pt)
  → But how much pleading is enough? 🤔
]

#slide[
  = Basic ways to control LLM output

  === Solution #3: Prompt chaining

  1. Ask the model to *extract relevant facts:*
  ```
  List all companies mentioned in the text along with their reported revenue and year.
  ```

  2. Ask the model to *format those facts*:
  ```
  Format the extracted information as a JSON array with fields: name, revenue, and year.
  ```
  3. Ask the model to *validate the output*:
  ```
  Check that all values in the JSON are correctly formatted.
  ```
  #set text(size: 20pt)

  → More robust, but can run into the same issues as previous approaches.
]

#slide[
  = (Less) basic ways to control LLM output

  === Solution #4: Model finetuning

  Finetune a small model to generate only the output in the desired format → use it to post-process the output from the large LLM.

  #align(center)[#image("img/lecture07/structured_output_finetuning.png", width: 400pt)]
  #source-slide("https://arxiv.org/abs/2505.04016v1", title: "Wang et al. (2025)")
]

#slide[
  = Constrained decoding

  #ideabox()[Instead of hoping the model produces valid output, we  *force it* during decoding.]

  #grid(
    columns: (1fr, 1.5fr),
    gutter: 1em,
    [
      How? *Token masking!*

      → At each step, we allow *only the tokens that are valid* according to our constraints.
    ],
    [
      #set align(center + horizon)

      #image("img/lecture07/token-masking-diagram.png", width: 350pt)
    ],
  )

  #source-slide("https://blog.dataiku.com/your-guide-to-structured-text-generation", title: "dataiku.com")
]


#slide[
  = How to specify the constraints?
  #set align(horizon)


  #questionbox()[
    Imagine we want to force the model output to be one of the following:
    + A valid *number* or *e-mail address*.
    + A *JSON object* with specific fields.
    + A *text string* with placeholders (numbers, multiple choice, etc.) infilled.

    #v(30pt)
    How to specify each of these options?]
]


#slide[
  = How to specify the constraints?

  #set text(size: 18pt)


  #toolbox.side-by-side(gutter: 1em, columns: (1fr, 1.3fr, 1.3fr))[
    === Number / email:
    Regular expressions

    ```python
    # positive decimal
    r"(^[1-9][0-9]*$)"

    # e-mail address (simple version)
    r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)"
    ```
  ][
    #uncover("2-")[
      === JSON object:
      Pydantic models
      ```python
      class Company(BaseModel):
          name: str
          revenue: float
          year: int = 2021

      class Response(BaseModel):
          companies: List[Company]
          total_count: int
      ```
    ]
  ][
    #uncover("3-")[
      === Text string:
      Generative constructs
      ```python
      "The answer is "
      +
      GENERATE(regex=r"\d+")
      +
      " with confidence "
      +
      GENERATE(choices=["high","med",
      "low"])
      ```
    ]
  ]
]


#slide[
  = JSON schema vs Pydantic models

  #toolbox.side-by-side(gutter: 1em, columns: (1fr, 1fr))[
    *Pydantic models*
    #v(-0.5em)

    ```python
    class Company(BaseModel):
        name: str
        revenue: float
        year: int = 2021

    class Response(BaseModel):
        companies: List[Company]
        total_count: int
    ```
  ][
    *JSON schema (equivalent)*
    #set text(size: 10pt)
    #v(-0.5em)

    ```json
    {
      "$schema": "http://json-schema.org/draft-07/schema#",
      "title": "Response",
      "type": "object",
      "properties": {
        "companies": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "name": { "type": "string" },
              "revenue": { "type": "number" },
              "year": {
                "type": "integer",
                "default": 2021
              }
            },
            "required": ["name", "revenue", "year"]
          }
        },
        "total_count": { "type": "integer" }
      },
      "required": ["companies", "total_count"]
    }

    ```
  ]


]


#slide[
  = How to intervene on the generation process?

  We can convert any regular expression to a *finite-state machine (FSM)* and use it to determine which tokens are valid at each step.

  #v(0.5em)

  #bordered-box(padding: 10pt)[
    #grid(
      columns: (1fr, 1fr),
      gutter: 1em,
    )[
      *Regular expression*

      (positive integer)

      #set text(size: 18pt)
      ```python
      r"[1-9][0-9]*"
      ```
    ][
      *Finite-state machine*
      #image("img/lecture07/finite-state-machine-regex.png", width: 250pt)
    ]
  ]
  - During decoding, we move along the edges in the FSM and keep track of the state.
  - *Allowed tokens* = outgoing edges from the state we are currently in.
]


#slide[
  = How to intervene on the generation process?

  What about *JSON schemas* or *interleaved generative constructs*?

  → We can convert them to a regular expression (and that to a FSM).

  #v(-1em)

  #align(center + horizon)[
    #image("img/lecture07/lmsys-fsm-comparison.png", width: 70%)
    #image("img/lecture07/fsm-comparison-chart.png", width: 70%)
    #source-slide("https://lmsys.org/blog/2024-02-05-compressed-fsm/", title: "https://lmsys.org")
  ]
]



#slide[
  = Can we go deeper?

  For arbitrarily nested structures (JSON with arbitrary nesting, HTML, code), we need *context-free grammars (CFGs)* and *pushdown automata*:

  #set align(center + horizon)
  #image("img/lecture07/cfg-pushdown-automaton.png", width: 600pt)

  #set align(left)
]


#slide[
  = Structured outputs & libraries

  Libraries for *local open models* support JSON mode, enums, regexes, CFGs, ...:


  #set text(size: 17pt)

  #table(
    columns: (0.7fr, 1.2fr, 1fr),
    inset: 0.5em,
    align: left,
    table.header[*Level*][*Frameworks*][*Note*],
    [*API frameworks*], [vLLM, llama.cpp, SGLang, Ollama], [API -- use `response_format`],
    [*Libraries*], [Outlines, XGrammar, Guidance, BAML], [For custom integration],
    [*Low-level*], [HF Transformers `LogitsProcessor`], [Low-level implementation],
  )
  #v(0.5em)

  #set text(size: 20pt)

  *Commercial providers* (OpenAI, Gemini, Claude) support primarily JSON outputs:

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #image("img/lecture07/openai_structured_outputs_docs.png")
      #source("https://developers.openai.com/api/docs/guides/structured-outputs", title: "OpenAI docs")

    ],
    [
      #image("img/lecture07/claude_structured_outputs_docs.png")
      #source("https://platform.claude.com/docs/en/build-with-claude/structured-outputs", title: "Claude docs")

    ],
  )
]


#slide[
  = Why constrained decoding can be tricky

  #source-slide("https://www.aidancooper.co.uk/constrained-decoding/", title: "Cooper (2024)")

  #quote(
    attribution: "aidancooper.co.uk",
  )[Most constrained decoding pitfalls are due to misalignment between what the model *wants* to output and what it is *forced* to output.]


  *Main issues:*
  #item-by-item()[
    + The model may perform worse if forced to output a *JSON instead of a "natural format"* (e.g., plain text, code diffs).
    + Some libraries still do not support *separating structured content from reasoning* → reasoning may be prevented with structured outputs.
    + *Token boundaries* do not match the FSM states based on characters (e.g., the sequence #text(fill: rgb("#FF0000"))[{"name":"] can be a single token)
  ]
]



#slide[
  = Pitfall: tokenization and FSMs

  #source-slide("https://blog.dottxt.ai/coalescence.html", title: "blog.dottxt.ai")

  The constraints are defined on the character level, but the model works with tokens.

  The FSM must be *adapted to the tokenizer's vocabulary*:


  #set align(center + horizon)

  #v(-2em)

  #image("img/lecture07/fsm-json-token-level.png", width: 700pt)

  #set align(left)


  Preprocessing is quite slow and the resulting FSM can be much larger (but this is now optimized using libraries like #link("https://github.com/guidance-ai/llguidance")[llguidance]).
]


#section-slide(section: "Agents")[LLM agents]


#slide[
  = Reasoning and acting

  So far, we considered reasoning and acting (=tool calling) to be separate processes:

  #set align(center + horizon)

  #image("img/lecture07/react_separate_steps.png", width: 700pt)


  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents",
    title: "Maarten Grootendorst's blog",
  )
]

#slide[
  = Reasoning and acting

  *ReAct:* #link("https://arxiv.org/abs/2210.03629")[Yao et al. (2023)]: combining *reasoning* and *acting* in a single loop.

  → A base paradigm for what is now called "LLM agents."

  #image("img/lecture07/react_combined_steps.png")

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents",
    title: "Maarten Grootendorst's blog",
  )
]



#slide[
  = The ReAct framework

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents",
    title: "Maarten Grootendorst's blog",
  )
  The agent in ReAct iterates through the *thought* → *action* → *observation* loop  until it reaches a final answer:

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      - *Thought*: reasoning about the current situation.
      - *Action*: executing a tool.
      - *Observation*: observing the result of the action.
    ],
    [
      #set align(center + horizon)
      #image("img/lecture07/react_prompt.png", width: 450pt)
    ],
  )
]



#slide[
  = What is an LLM agent?

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents",
    title: "Maarten Grootendorst's blog",
  )

  To a degree, the LLM agents follow the classical AI agent definitions.

  They can *observe* the environment (→input), *plan* (→reasoning), and *act* (→tools):

  #set align(center + horizon)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      #image("img/lecture07/agent_framework.png", width: 400pt)
    ],
    [
      #image("img/lecture07/agent_definition.png")
    ],
  )

  #set align(left)

]


#slide[
  = LLM agents in code assistants

  #set align(center + horizon)

  #image("img/lecture07/agent_code_assistant.png")
]


#slide[
  = Multi-agent systems

  #source-slide(
    "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents",
    title: "Maarten Grootendorst's blog",
  )

  *Multi-agent systems*: multiple specialized agents, each with their own tools and memory, coordinated by a supervisor:

  #set align(center + horizon)
  #image("img/lecture07/multi_agent.png", width: 400pt)
]

#slide[
  = OpenClaw

  #set align(center + horizon)

  #grid(
    columns: (1.4fr, 1fr),
    gutter: 1em,
    [
      #image("img/lecture07/openclaw_website.png")
      #source("https://openclaw.ai", title: "https://openclaw.ai")
    ],
    [
      #image("img/lecture07/claw_singularity.png")
      #source("https://a16z.com/100-gen-ai-apps-6/", title: "https://a16z.com/100-gen-ai-apps-6/")

    ],
  )



]


#slide[
  = OpenClaw

  #source-slide("https://github.com/openclaw-ai/openclaw", title: "OpenClaw (2025)")

  *OpenClaw* can integrate any LLM with various  applications (Whatsapp, Spotify, Gmail, ...) via *MCPs*, making agents very useful and super dangerous at the same time 😈

  #set align(center + horizon)



  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #image("img/lecture07/openclaw_demo_1.jpeg")
    ],
    [
      #image("img/lecture07/openclaw_demo_2.jpeg")

      #source(
        "https://x.com/JFPuget/status/2025877071939911791/photo/1",
        title: "https://x.com/JFPuget/status/2025877071939911791/photo/1",
      )
    ],
  )

  #v(-0.5em)




]

#section-slide(section: "Summary")[Summary]


#slide[
  = Summary

  - *RAG*: retrieve relevant documents and use them as context for generation. The de facto standard for knowledge-intensive LLM apps.
  - *Tool calling*: LLMs can use external tools (APIs, code, search). Pioneered by Toolformer, now a standard feature.
  - *MCP*: an open protocol for standardizing tool access across LLM applications.
  - *Structured outputs*: constrained decoding forces valid output formats (JSON, regex, CFG) during generation.
  - *Agents*: Reasoning LLMs equipped with tools, applying these in a loop to achieve a goal.
]


#slide[
  = Links and resources

  #set text(size: 15pt)

  - #link(
      "https://arxiv.org/abs/2005.11401",
    )[Lewis et al. (2020): Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks]
  - #link(
      "https://arxiv.org/abs/2312.10997",
    )[Gao et al. (2024): Retrieval-Augmented Generation for Large Language Models: A Survey]
  - #link(
      "https://arxiv.org/abs/2302.04761",
    )[Schick et al. (2023): Toolformer: Language Models Can Teach Themselves to Use Tools]
  - #link("https://modelcontextprotocol.io")[Anthropic: Model Context Protocol (MCP)]
  - #link(
      "https://arxiv.org/abs/2307.09702",
    )[Willard & Louf (2023): Efficient Guided Generation for Large Language Models (Outlines)]
  - #link("https://openai.com/index/introducing-structured-outputs-in-the-api/")[OpenAI: Structured Outputs in the API]
  - #link(
      "https://arxiv.org/abs/2210.03629",
    )[Yao et al. (2023): ReAct: Synergizing Reasoning and Acting in Language Models]
  - #link(
      "https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-llm-agents",
    )[Maarten Grootendorst's blog: A Visual Guide to LLM Agents]
]
