#import "@preview/modern-cv:0.10.0": *

#show: resume.with(
  author: (
    firstname: "Lorenzo",
    lastname: "Liuzzo",
    email: "lorenzoliuzzo@outlook.com",
    github: "lorenzoliuzzo",
    custom: (
      (
        text: "lorenzoliuzzo.github.io",
        icon: "globe",
        link: "https://lorenzoliuzzo.github.io",
      ),
    ),
    positions: ("Physicist", "Software Engineer", "AI Systems"),
  ),
  profile-picture: image("../assets/images/profile.jpg"),
  language: "en",
  show-footer: false,
  keywords: ("Physicist", "Developer"),
)

// resume-item hard-codes `set par(leading: 0.65em)` inside the function, and neither a
// set rule nor a show-set rule out here can reach past it. Setting the leading inside
// the body does win, so the item is wrapped once and every call site picks it up.
// The value spends the space left at the bottom of the last page on line spacing.
#let template-item = resume-item
#let resume-item(body) = template-item[
  #set par(leading: 0.80em)
  #body
]

// Pulled up into the space the header grid leaves free, and kept as wide as the
// name/contacts column so it never runs under the profile picture.
#v(-33pt)
#block(width: 100% - 4cm - 10pt)[
  #set par(justify: false)
  #align(center)[
    #emph[Physicist] and #emph[software engineer] specialized in #emph[AI]. Physics taught
    me to derive the model before writing the code; lately most of my time goes into
    learning how much of that writing can be delegated to a model, and where a person
    still has to decide.
  ]
]
#v(-4pt)

= Experience

#resume-entry(
  title: "MyThingsLab",
  location: github-link("MyThingsLab"),
  date: "July 2026 - Present",
  description: "Founder, Architect and Developer",
)
#resume-item[
  - A personal lab for AI-assisted development, started in July 2026: #strong[more than 50
    composable Python tools] in the first month, all on one SDK — #emph[my-things-core] —
    exposing five contracts (ledger, policy, engine, GitHub, isolation) that every tool
    imports and no tool reimplements.
  - What I am testing is control, not autonomy: headless workers pick an issue, do the
    deterministic pre-work with no model call, invoke the LLM once for the step needing
    judgement, and close it as a pull request — never a merge, so I keep the last word.
  - The SDK is dependency-free and calls no model itself: it shells out to #emph[gh] and
    #emph[git], and the LLM lives behind one #emph[Engine] protocol whose deterministic
    default lets the whole fleet be exercised and tested without spending a token.
]

#resume-entry(
  title: "Money Ball AI",
  location: github-link("MoneyBallingAI"),
  date: "September 2025 - Present",
  description: "Founder, Technical Lead and Developer",
)
#resume-item[
  - Founded and lead a team of four building one model that predicts the #strong[exact box
    score] of an NBA game — every player and team line — with calibrated uncertainty. I own
    the architecture, from raw play-by-play to a calibrated prediction:
  - #strong[Data] — play-by-play parsed into periods, lineup stints and possessions,
    aggregated into cumulative stat windows and modelled as heterogeneous stint graphs with
    stable global identities for players and teams across seasons.
  - #strong[Encoder] — a heterogeneous GNN over those graphs with per-entity cross-game and
    hierarchical season/game/stint memory, pretrained on a box-score delta task for stable
    player and team strength embeddings.
  - #strong[Simulator] — a vectorized Monte Carlo possession engine whose policies are
    behavior-cloned on real possessions; #strong[calibration] scores per-stat distributions
    against the actual box score with MAE, CRPS, PIT and coverage, under CI with a 134-test
    #emph[pytest] suite.
]

#resume-entry(
  title: "Private Tutoring in Mathematics and Physics",
  location: "Milan, Italy",
  date: "2020 - Present",
  description: "In-home tutoring",
)
#resume-item[
  Continuous support for 20+ students: exam preparation, remedial tutoring and periodic
  reports to families.
]

#resume-entry(
  title: "Barista",
  location: "Milan, Italy",
  date: "September - October 2024",
  description: "Don Salvatore - Pizzaiuolo e Oste",
)

#resume-entry(
  title: "Waiter",
  location: "Milan, Italy",
  date: "May - July 2022",
  description: "Bar Terrazza Clér",
)

#resume-entry(
  title: "Scout Leader",
  location: "Milan, Italy",
  date: "2021 - 2022",
  description: "Reparto Breithorn - Gruppo MI8 - AGESCI",
)
#resume-item[
  Educational activities for youth aged 12-16: camps, outings, coordination with educators
  and families.
]

= Education

#resume-entry(
  title: "University of Milan, Milan-Bicocca and Pavia",
  location: "Milan/Pavia, Italy",
  date: "September 2025 - Present",
  description: "Master's degree in Artificial Intelligence for Science and Technology",
)

#resume-entry(
  title: "University of Milan",
  location: "Milan, Italy",
  date: "September 2021 - July 2025",
  description: "Bachelor's degree in Physics, Grade: 100/110",
)
#resume-item[
  Thesis: #emph[ray tracing and Monte Carlo methods for uncertainty quantification in
  radio-telescope pointing for CMB observations.]
]

#resume-entry(
  title: "I.I.S. Severi-Correnti",
  location: "Milan, Italy",
  date: "September 2016 - June 2021",
  description: "Scientific Diploma, Grade: 100/100",
)

#resume-entry(
  title: "EF International Language School",
  location: "Brighton, England",
  date: "June - September 2019",
  description: "Full-immersion intensive English language course",
)

// resume-entry is sticky: without a neutral block here the whole Education tail is
// dragged onto the next page instead of breaking after this entry.
#block(height: 0pt, above: 0pt, below: 0pt, width: 100%)[#box()]

= Schools & Workshops

#resume-item[
  #block(breakable: false)[
    - #strong[School on Quantum Simulation] — Department of Physics, University of Milan
      (9 - 11 September 2026).
    - #strong[Qiskit Fall Fest] — IBM Quantum · Department of Physics, University of Milan
      (31 October - 7 November 2025).
  ]
]

= Projects

#resume-entry(
  title: "Gauge-Equivariant Graph Neural Networks",
  location: github-link("lorenzoliuzzo/EGNN"),
  date: "July - August 2026",
  description: "Designer/Developer",
)
#resume-item[
  Lattice Standard Model field theory simulated with gauge-equivariant GNNs in
  #emph[PyTorch Geometric]: SU(3)×SU(2)×U(1) gauge groups, Wilson-Dirac fermions and
  Higgs spontaneous symmetry breaking.
]

#resume-entry(
  title: "MSc Coursework Projects",
  location: github-link("lorenzoliuzzo"),
  date: "May - July 2026",
  description: "Designer/Developer",
)
#resume-item[
  - #link("https://github.com/lorenzoliuzzo/supervised-learning-on-food-images")[#strong[Supervised Learning on Food Images]] — a convolutional neural network under 10M parameters classifying the 251 classes of the FoodX-251 dataset.
  - #link("https://github.com/lorenzoliuzzo/TFIM")[#strong[Transverse Field Ising Model]] — quantum phase transitions explored on #emph[PennyLane].
  - #link("https://github.com/lorenzoliuzzo/unsupervised-learning-on-country-data")[#strong[Unsupervised Learning on Country Data]] — clustering and dimensionality reduction on socio-economic country-level data.
]

#resume-entry(
  title: "Telescope Pointing Simulation",
  location: github-link("lorenzoliuzzo/thesis-L30"),
  date: "June - July 2025",
  description: "Designer/Developer",
)
#resume-item[
  #emph[Julia] model of a telescope's reflective system, propagating mirror defects to
  the pointing direction via #emph[ray tracing] and #emph[Monte Carlo] simulation.
]

#resume-entry(
  title: "Systems & Numerical Programming",
  location: "C++ · Nim",
  date: "2023 - 2024",
  description: "Designer/Developer",
)
#resume-item[
  - #link("https://github.com/lorenzoliuzzo/PhotoNim")[#strong[Ray Tracing Engine]] — pair project at UNIMI: a physical model turned into structured, tested and documented numerical code, while rapidly learning a new language (#emph[Nim]).
  - #link("https://github.com/lorenzoliuzzo/ctda-cpp")[#strong[Dimensional Analysis Library]] — “CTDA: Compile Time Dimensional Analysis”, C++ numeric types carrying units of measurement in the type system.
]

= How I Build Software

#resume-item[
  - #strong[AI across the whole workflow, not just the coding step.] Composable tools cover
    design, implementation, testing and documentation — which is how one person can cover
    more than 50 of them in a month, with pytest, coverage and ruff on every push.
  - #strong[Deterministic first, models only where judgement is needed.] The LLM sits behind
    a single #emph[Engine] seam, so a tool's entire skeleton runs and is tested at zero
    token cost.
  - #strong[Cut complexity before it accrues.] The shared core stays dependency-free —
    shelling out to #emph[gh] and #emph[git] rather than pulling SDKs — and builds no
    abstraction for a need that does not exist yet.
  - #strong[Every side effect passes a gate.] A policy engine rules each action
    allow/ask/deny, tools open pull requests rather than merging, and every #emph[ask]
    reaches me over Telegram before anything happens.
  - #strong[Derive the model, then write the code.] Physics first, then typed and documented
    numerical code — as in the telescope pointing thesis.
]

= Skills

#resume-skill-item("Languages", (strong("Italian"), strong("English C1")))
#resume-skill-item(
  "Programming Languages",
  (strong("C++"), strong("Python"), strong("Julia"), "C", "Nim"),
)
#resume-skill-item(
  "AI Engineering",
  (
    strong("Claude"),
    strong("Claude Code"),
    strong("Agentic workflows"),
    strong("Prompt & context engineering"),
  ),
)
#resume-skill-item(
  "ML & Data Science",
  (
    strong("PyTorch"),
    strong("PyTorch Geometric"),
    strong("Scikit-learn"),
    strong("Pandas"),
    strong("NumPy"),
    strong("SciPy"),
  ),
)
#resume-skill-item(
  "Databases & Quantum",
  (strong("Neo4j"), strong("Cypher"), strong("PennyLane"), strong("Qiskit")),
)
#resume-skill-item(
  "Development Tools",
  (
    strong("Git"),
    strong("GitHub"),
    strong("GitHub Actions"),
    strong("pytest"),
    strong("ruff"),
    strong("Jupyter"),
    strong("LaTeX"),
    strong("Typst"),
    strong("Markdown"),
  ),
)

#v(1fr)
#text(size: 8pt, style: "italic", weight: "light")[
  I authorize the processing of my personal data in accordance with Italian
  Legislative Decree 196/2003, as coordinated with Legislative Decree 101/2018,
  and the GDPR (EU Regulation 2016/679) for the purposes of recruitment and
  selection of personnel.
]
