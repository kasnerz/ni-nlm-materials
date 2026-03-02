#import "fit.typ": *
#import "@preview/cetz:0.3.1"
#import "@preview/ez-today:2.1.0"
#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#prequery.fallback.update(true)

#enable-handout-mode(true)


// Helper functions for simple diagrams (replacing fletcher due to missing dependencies)
#let node-box(fill-color, label) = rect(
  fill: fill-color,
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  stroke: 1pt + rgb("#555555"),
  align(center, text(weight: "bold")[#label]),
)

#let connect-arrow(label) = align(center)[
  #text(size: 0.8em, fill: rgb("#666666"))[#label] \
  #v(-1.5em)
  #text(size: 1.5em, weight: "bold", fill: rgb("#555555"))[$arrow.b$]
]

#let connect-dbl-arrow(label) = align(center)[
  #text(size: 0.8em, fill: rgb("#666666"))[#label] \
  #v(-1.5em)
  #text(size: 1.5em, weight: "bold", fill: rgb("#555555"))[$arrow.t.b$]
]

#show: fit-theme.with(
  footer-content: "NI-NLM – 01 – Tutorial",
)

#title-slide(
  title: "NI-NLM",
  name: "NI-NLM – Tutorial 02",
  subtitle: "Semestral project – updates",
  author: "Zdeněk Kasner",
  date: "3 Mar 2026",
)[]

#section-slide(section: "Paper presentations")[Paper presentations]

#slide[
  = Paper presentations

  #grid(
    columns: (2.5fr, 1fr),
    gutter: 1em,
    [
      === Why to present
      - You learn how to read, understand, and present papers.
      - You teach your colleagues something new.
      \+ You get *5 extra points* for the final test.

      #show: later
      === What to present
      - *Option \#1:* Choose from the #link("https://docs.google.com/spreadsheets/d/1SXHOzzc_GMTdEIiPSi8tGSjwmc-4MsqADEiAzo1Ndn4/edit?gid=0#gid=0")[list of recommended papers]
      - *Option \#2:* Propose a paper yourselves (e-mail / in person) → I approve
    ],
    [
      #set align(center + horizon)

      #image("img/lecture01/paper_presentations_list.png", width: 80%)],
  )
]


#slide[
  = Paper presentations

  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    [
      === When to present
      - *15 min presentation* during the tutorials.
      - First we go through all the presentations, then we will have consultations.
      - Sign up for the specific tutorial in the #link("https://docs.google.com/spreadsheets/d/1SXHOzzc_GMTdEIiPSi8tGSjwmc-4MsqADEiAzo1Ndn4/edit?usp=sharing")[spreadsheet].


      #uncover("2-")[
        === How to present

        - Slides
        - Live paper browsing (#link("https://www.youtube.com/@YannicKilcher/videos")[Yannic Kilcher] style)
        - Worksheets, pantomime, ... → your choice
      ]
    ],
    [
      #v(1em)
      #image("img/lecture01/paper_presentations_signup.png")

      #v(1em)

      #uncover("2-")[
        #image("img/lecture01/yannic_kilcher_style.png")

        #source("https://www.youtube.com/watch?v=iDulhoQ2pro", title: "Youtube – Yannic Kilcher")
      ]
    ],
  )
]


#section-slide(section: "Assignment")[Semestral project – Assignment]

#slide[
  = Semestral project
  === Overview

  #item-by-item[
    - You need to finish the semestral project to pass this course.

    - You need to *submit the report* till 31 May 2026.
      - Along with your the codebase and trained model(s).
    - It is a teamwork: *2-3 people per team*.
      - You can create the teams right now!
      - Don't know anyone? Join someone in the #link("https://docs.google.com/spreadsheets/d/1SXHOzzc_GMTdEIiPSi8tGSjwmc-4MsqADEiAzo1Ndn4/edit?gid=101797396#gid=101797396")[spreadsheet].
    - There is a *single, common topic* for everyone.
  ]
]

#slide[
  = Semestral project -- teams

  #set align(center + horizon)
  Fill your username in the #link("https://docs.google.com/spreadsheets/d/1SXHOzzc_GMTdEIiPSi8tGSjwmc-4MsqADEiAzo1Ndn4/edit?gid=101797396#gid=101797396")[spreadsheet] *until the next tutorial (5/3/2025)*:

  #image("img/lecture01/team_spreadsheet.png", width: 400pt)
]

#slide[
  = BabyLM Challenge

  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    [#image("img/lecture01/babylm_challenge.png", width: 300pt)

      *Goal: Training  a token-efficient language model*

      → 100M or even just 10M of words instead of   trillions.
    ],
    [#image("img/lecture01/model_sizes.png")],
  )

  #v(1em)
  - Similarly "as the babies learn" (although we are not there yet).
  - In 2025, there was a 3rd iteration of the competition (connected to a #link("https://aclanthology.org/volumes/2025.babylm-main/")[workshop])
    - We will use their data and evaluation pipeline.
  #v(-0.4em)
  👉 #link("https://babylm.github.io")[ https://babylm.github.io]
]

#slide[
  = BabyLM Challenge – Tracks

  You need to participate in *at least one* track (more is welcome).
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    infobox(title: "Strict-small (recommended)", icon: "!!")[
      - Budget: *10M words*, 10 epochs.
      - Language-only tasks.
    ],
    infobox(title: "Strict", icon: "!")[
      - Budget: *100M words*, 10 epochs.
      - Language-only tasks.
    ],

    infobox(title: "Multimodal", icon: "📼")[
      - *100M words* (text or image-text).
      - Language & vision tasks.
    ],
    infobox(title: "Interaction", icon: "🗣️")[
      - Interactions with external models.
      - Max *100M words* exposure.
    ],
  )
]

#slide[
  = BabyLM Challenge – Additional details

  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    [
      - In principle, you can train the model on *any dataset you want* (as long as it fits the size).
      - To start with, you can use #link("https://huggingface.co/collections/BabyLM-community/babybabellm")[BabyBabelLM]:

      #quote[*BabyBabelLM*: A multilingual collection of datasets modeling the language a person observes from birth until they acquire a native language.]

      #v(1em)

      - *Tip:* First try running one of the baselines.
    ],
    [
      #image("img/lecture01/babybabellm_data_1.png", width: 250pt)
      #image("img/lecture01/babybabellm_data_2.png", width: 250pt)],
  )
]


#slide[
  = How to evaluate

  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    [
      Download the *evaluation pipeline* and run it yourself: #link("https://github.com/babylm/evaluation-pipeline-2025")[https://github.com/babylm/evaluation-pipeline-2025]

      - *Fast eval*: small subset for a quicker turnaround.

      #infobox(title: "Checkpoints")[
        For full eval, you need to *save the training checkpoints*:
        - Every 1M words (first 10M).
        - Every 10M words (first 100M).
      ]
    ],
    [
      #bordered-box[#image("img/lecture01/evaluation-pipeline-2025.png")]

    ],
  )

]


#slide[
  = What is evaluated -- examples

  #set text(size: 15pt)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #v(-0.5em)
      === 📚 Textual datasets

      #link("https://github.com/alexwarstadt/blimp")[*BLiMP* – grammaticality tests]
      ```
      Which sentence is correct?
      A) The cashiers clean these chairs.
      B) The cashiers clean this chairs.
      ```

      #link("https://ewok-core.github.io")[*EWoK* – world knowledge]
      ```
      Context: The balloon is getting closer to the sky.
      A) The balloon is getting closer to the sky.
      B) The balloon is getting closer to the ground.
      ```

      #link("https://gluebenchmark.com")[*GLUE* – 7 language understanding benchmarks]
      ```
      "The great thing is to keep calm", Julius groaned.
      hypothesis: Julius was silent.
      → CONTRADICTION
      ```
    ],
    [=== 🖼 Multimodal

      #link("https://github.com/facebookresearch/winoground")[*Winoground* – vision track]

      #stack(dir: ltr, spacing: 1em, image("img/lecture01/winoground_1.jpg", height: 120pt), image(
        "img/lecture01/winoground_2.jpg",
        height: 120pt,
      ))
      ```
      Match images to descriptions:
      A) a person watches an animal
      B) an animal watches a person
      ```
      *... and others*
    ],
  )
]

#slide[
  = Further reading
  Reports from the organizers about the task submissions from the previous years:

  - #link("https://aclanthology.org/2023.conll-babylm.1/")[2023: Findings of the BabyLM Challenge]
  - #link("https://aclanthology.org/2024.conll-babylm.1/")[2024: Findings of the Second BabyLM Challenge]
  - #link("https://aclanthology.org/2025.babylm-main.28/")[2025: Findings of the Third BabyLM Challenge]
]

#slide[
  = Custom topics

  You can propose your *custom topic* for the semestral project IF:
  - You have another topic that is at least similarly challenging.
  - You do not work on the topic for another course / as a part of your thesis  / ...
  - You suggest the topic to me (in-person / mail) and I approve it.

  #v(1em)

  If the topic is approved, you need to *fulfill the same requirements* for submitting the project (including the 2-3 people teams).

  #warnbox(title: "Support")[
    I can provide only a limited support with custom topics.
  ]
]

#section-slide(section: "Report")[Semestral Project – Report]


#slide[
  = Report – Requirements

  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    [
      - To pass the course, *you must submit a technical report* describing your work on the semestral project.
      - *Format*: #link("https://github.com/acl-org/acl-style-files")[ACL paper template] (LaTeX), 4–8 pages.
      - *Main goal*: describe your strategies!

      #infobox(icon: "💡")[
        There is no need to "win" or pass a specific score. Genuine effort is enough 😉
      ]
    ],
    [#image("img/lecture01/acl_paper_template.png")],
  )
]
#slide[
  = Report – How to write

  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    [
      - *Recommended paper structure*:

      #v(-1em)
      #align(center)[#scale(65%)[#fletcher.diagram(
        node-stroke: 1pt,
        edge-stroke: 1pt,
        node-corner-radius: 5pt,
        node-inset: 8pt,
        spacing: (1em, 2.5em),
        axes: (ltr, ttb),
        node((0, 0), [Abstract]),
        edge("->"),
        node((1, 0), [Introduction]),
        edge("->"),
        node((2, 0), [Related Work]),
        edge("->"),
        node((3, 0), [Experiments]),

        edge((3, 0), (4.1, 0), (4.1, 0.5), (-0.8, 0.5), (-0.8, 1), (0, 1), "->", corner-radius: 5pt),

        node((0, 1), [Results]),
        edge("->"),
        node((1, 1), [Conclusion]),
        edge("->"),
        node((2, 1), [*Contributions*]),
      )]]
      #v(-1em)
      #text(size: 16pt)[
        _(You can change this  as long as you know what you are doing.)_]

      - I can help you with writing during consultations.

      #warnbox(title: "Contributions")[
        The _Contributions_ section is *OBLIGATORY* → make sure everyone participates.
      ]

    ],
    [#image("img/lecture01/acl_paper_template.png")],
  )
]

#slide[
  = Report – How to submit

  To submit the project, follow these instructions

  - Create a public + read-only repository called `nlm-sp` in your namespace (e.g., `gitlab.fit.cvut.cz/username/nlm-sp`).
  - The repository needs to contain:
    - `README.md`: Instructions how to run the code, links to external files.
    - `report.pdf`: The report (in the root).
    - Your codebase.
  - *Do NOT commit large data* (e.g. model checkpoints), upload them elsewhere.
    - You can use 100GB of space at https://owncloud.cesnet.cz.

  #align(
    right,
    text(
      size: 12pt,
      fill: muted-color,
      font: font-sans,
    )[
      #link("https://courses.fit.cvut.cz/NI-MVI/semestralka.html#_postup")[instructions adopted from NI-MVI]
    ],
  )
]

#section-slide(section: "Computing infrastructure")[Computing infrastructure]

#slide[
  = Computing infrastructure

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      - Your experiments will probably be   computationally heavy.
        _(if not, congrats -- we want efficiency!)_

      - Your options (covered next):
        - MetaCentrum infrastructure
        - Hosted notebooks
          - Google Colab
          - Kaggle notebooks
        - Your own resources

    ],
    [
      #set align(center + horizon)

      #image("img/lecture01/computing_meme.jpg")],
  )
]

#slide[
  = MetaCentrum
  #grid(columns: (1.5fr, 1fr), gutter: 2em)[

    #set align(horizon)

    - #link("https://docs.metacentrum.cz/")[MetaCentrum] is a research computing infrastructure operated by #link("https://www.e-infra.cz")[e-INFRA CZ].
    - It provides access to #link("https://docs.metacentrum.cz/en/docs/computing/resources/resources#cpus")[CPU] and #link("https://docs.metacentrum.cz/en/docs/computing/gpu-comput/gpu-job")[GPU] resources for the Czech academic community.
    - If you do not have an active account, *apply for it #link("https://docs.metacentrum.cz/en/docs/access/account")[here]*.


  ][
    #image("img/lecture01/metacentrum_RGB.png")
    #image("img/lecture01/metacentrum_portal.png")
  ]

]
#slide[
  = How MetaCentrum works: Nodes
  #v(1em)

  There are two types of servers / nodes: *frontends* and *compute nodes*:

  #columns(2)[
    #infobox(title: "Frontends")[
      - The servers that you can "`ssh`" into.
      - You should not run any computation here.
      - Every frontend has is own `$HOME`.
    ]
    #colbreak()
    #infobox(title: "Compute nodes")[
      - The servers on which you compute.
      - You need to be allocated compute time first.
      - Working dir: `$SCRATCHDIR`
    ]
  ]
]

#slide[
  = How MetaCentrum works: Storages

  There are also two types of storages:  *home directories* and *scratch directories*:
  #columns(2)[
    #infobox(title: "Home directory")[
      - For storing your files (almost) indefinitely.
      - Mounted directly to frontends.
      - Slow for frequent I/O – always *copy files to `$SCRATCHDIR`* when you run a compute job.
      - `brno2`: #link("http://metavo.metacentrum.cz/en/myaccount/kvoty")[largest quota].
    ]
    #colbreak()
    #infobox(title: "Scratch directory")[
      - Temporary storage you get allocated along with the node.
      - Can be very fast (SSD/RAM), but defaults to HDD.
      - You should copy the outputs from there after the job ends and "delete it after yourself".
    ]
  ]

  #align(center)[
    #text(fill: primary-color, size: 1.2em, weight: "bold")[]
  ]
]

#slide[
  = Interactive job

  #grid(columns: (1.5fr, 1fr), gutter: 1em)[
    #v(1em)
    *`qsub -I`*

    - You get an interactive shell on the compute node.
    - Good for any sort of ongoing development.
      - Very useful, use it!
    - *But*: If you do not get the resources straight away, you need to wait.

  ][
    #align(center + horizon)[
      #block(width: 60%)[
        #stack(
          dir: ttb,
          spacing: 0.5em,
          node-box(rgb("9ac7eb"), "Frontend node"),
          connect-arrow("You ask for resources"),
          node-box(rgb("#efcc82"), "Scheduler"),
          connect-arrow("Allocates you a node"),
          node-box(rgb("b5e4a3"), "Compute node"),
          connect-dbl-arrow("You get a bash shell"),
          node-box(rgb("#d1d1d1"), "Commands, scripts, ..."),
        )
      ]
    ]
  ]
]

#slide[
  = Batch job

  #grid(columns: (1.5fr, 1fr), gutter: 1em)[
    #v(1em)
    *`qsub script.sh`*

    - You write a script, ask for resources and submit it.
    - The script is executed automatically once the resources are allocated.
    - Output goes to `.o` (stdout) and `.e` (stderr) files.
    - Useful for late stage of development.
  ][
    #align(center + horizon)[
      #block(width: 60%)[
        #stack(
          dir: ttb,
          spacing: 0.5em,
          node-box(rgb("9ac7eb"), "Frontend node"),
          connect-arrow("You submit a job"),
          node-box(rgb("efcc82"), "Scheduler"),
          connect-arrow("Allocates you a node"),
          node-box(rgb("b5e4a3"), "Compute Node"),
          connect-arrow("Runs your script"),
          rect(stroke: (dash: "dashed"), width: 100%, inset: 10pt, radius: 4pt)[Output files],
        )
      ]
    ]
  ]
]

#slide[
  = Batch script example

  #text(size: 0.7em)[
    ```bash
    #!/bin/bash
    #PBS -N my_training
    #PBS -l select=1:ncpus=4:ngpus=1:mem=32gb:scratch_local=50gb
    #PBS -l walltime=24:00:00

    # 1. Setup environment
    module add python36-modules-gcc # or conda
    source venv/bin/activate

    # 2. Prepare data
    cp -r $DATADIR/dataset $SCRATCHDIR
    cd $SCRATCHDIR

    # 3. Run
    python train.py --data_dir $SCRATCHDIR/dataset --save_dir .

    # 4. Save results (automatic cleanup of scratch usually happens)
    cp -r checkpoints $DATADIR/results/
    ```
  ]
]


#slide[
  = Requesting resources

  You must specify the resources you need. *If you exceed it, the job is killed.*

  #v(1em)
  *Example*:
  ```bash
  qsub -l select=1:ncpus=4:mem=16gb:scratch_local=20gb -l walltime=4:00:00
  ```

  #v(1em)
  - `select=1`: Number of nodes (usually 1).
  - `ncpus=4`: Number of CPU cores.
  - `mem=16gb`: RAM amount.
  - `scratch_local=20gb`: Space on local SSD.
  - `walltime=4:00:00`: Max runtime (HH:MM:SS).
]

#slide[
  = GPU Jobs

  In case you need GPUS, add `ngpus` and `gpu_cap`.

  #v(1em)
  *Example*:

  ```bash
  qsub -I -l select=1:ncpus=4:ngpus=1:gpu_cap=cuda80:mem=32gb ...
  ```

  #v(1em)
  - `ngpus=1`: Number of GPUs.
  - `gpu_cap`: GPU capability/model.
  - `gpu_mem`: Optional, filter by VRAM size (e.g. `gpu_mem=20gb`).
]



#slide[
  = Job management

  #set align(horizon)

  - *Check status*: `qstat -u <username>`
  - *Kill job*: `qdel <job_id>`

  - *Qsub assembler:* https://metavo.metacentrum.cz/pbsmon2/qsub_pbspro

  #infobox(title: "Be a good neighbor")[
    - Do not run heavy calculations on the *frontend*.
    - Do not request 8 GPUs if you can only use 1.
    - Clean up your `$SCRATCHDIR` if your job fails (e.g. timeout).
  ]
]

#slide[
  = Modules

  Many software packages (Python, some libraries, …) can be loaded as #link("https://docs.metacentrum.cz/en/docs/software/modules")[*modules*].

  #v(1em)
  *Useful commands:*
  - `module avail`: list all available modules.
  - `module add <name>` (or `load`): load a module.
    - e.g., `module add python/3.8.0-gcc`
  - `module list`: list currently loaded modules.
  - `module purge`: unload all modules.
]


#section-slide()[Alternative ways to compute]

#slide[
  = Google Colab

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      #set align(horizon)

      - *Link*: #link("https://colab.research.google.com")[colab.research.google.com]
      - Cloud-based Jupyter notebooks environment.
      - Free access to GPUs (usually NVIDIA T4).
      - Session limits (\~12h), variable resource availability, disconnects if idle.


      #warnbox(title: "Warning")[ Not tested, limited support on my side.]
    ],
    [#image("img/lecture01/google_colab.png")],
  )
]

#slide[
  = Kaggle Notebooks

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      - *Link*: #link("https://www.kaggle.com/code")[kaggle.com/code]
      - Similar to Google Colab.
      - Free access to NVIDIA P100 or T4 GPUs.
      - \~30 hours GPU quota per week.
      - Can run in the background.

      #warnbox(title: "Warning")[ Not tested, limited support on my side.]
    ],
    [#image("img/lecture01/kaggle_notebooks.png") ],
  )
]


#slide[
  = Your own hardware

  #set align(center + horizon)

  #set text(size: 30pt)

  *Surprise me!*

  #image("img/lecture01/own_hardware_meme.png", width: 200pt)
]


#section-slide(section: "Tips")[Be more efficient]

#slide[
  = Tips for efficient remote development
  #set align(horizon)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [

      Use your favourite IDE with an *SSH access plugin*:
      - #link("https://code.visualstudio.com/docs/remote/ssh")[VSCode SSH plugin]
      - #link("https://www.jetbrains.com/help/pycharm/jetbrains-gateway.html")[PyCharm remote development]
      #v(1em)

      _(IMO) Life's too short to be using `rsync` and `vim` in #ez-today.today(lang: "en", format: "Y")._
    ],
    [#image("img/lecture01/real_programmers.png")],
  )
]

#slide[
  = Tips for efficient remote development

  Learn to use a *terminal multiplexer* (`screen`, `tmux`, ...) to keep your jobs running.

  My personal favourite is #link("https://www.byobu.org/")[`byobu`] (you need to  install it manually at MetaCentrum):
  #grid(
    columns: (2fr, 1fr),
    gutter: 1em,
    [```bash
    cd $HOME
    wget https://launchpad.net/byobu/trunk/5.133/+download/byobu_5.133.orig.tar.gz
    tar -xvzf byobu_5.133.orig.tar.gz

    cd byobu-5.133
    ./configure --prefix=$HOME/.local
    make && make install

    export BYOBU_CONFIG_DIR="$HOME/.byobu"
    ```],
    [#set align(center + horizon)

      #image("img/lecture01/byobu_terminal.png")],
  )
]

#slide[
  = Tips for efficient remote development

  *SSH keys:* no more typing password for logging in:

  1. Generate a #link("https://www.geeksforgeeks.org/linux-unix/how-to-generate-ssh-key-with-ssh-keygen-in-linux/")[public/private] key pair on your local machine.

  2. Run the following to copy the public key to a MetaCentrum frontend:
  ```bash
  ssh-copy-id -i ~/.ssh/{your_public_key} {username}@skirit.metacentrum.cz
  ```

  3. Add the following entry to your `.ssh`:
  ```ssh_config
  Host meta
    HostName skirit.metacentrum.cz
    User {username}
    IdentityFile ~/.ssh/{your_private_key}
    ForwardAgent yes
  ```
]

#slide[
  = Can I use LLM assistants / agents?

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 3em,
    [Of course! 🚀

      But:

      - For the experimental code, it is your responsibility to *ensure that the code does what is intended*.

      - For the text of the report, *no "AI-ish" allowed*.
        - Try  to make it readable, no need to sound too fancy.
    ],
    [
      #set align(center + horizon)

      #image("img/lecture01/ai_assistant_meme.jpg") #image("img/lecture01/llm_assistant_meme.png")],
  )
]

