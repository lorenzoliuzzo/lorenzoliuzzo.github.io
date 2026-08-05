#import "@preview/modern-cv:0.10.0": *
#import "@preview/fontawesome:0.6.0": fa-icon

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

// Three signals, each doing one job, so nothing has to be shouted:
//   `lead` — the document's own accent colour, on the phrase a bullet is about;
//   `tech` — a heavier weight on a technology, so the stack can be scanned;
//   `xlink` — a small mark after clickable text, the only thing a link gets.
// Bold stays rare on purpose: one claim per entry, and only the strongest skills.
#let lead(body) = text(fill: default-accent-color, weight: "semibold")[#body]
#let tech(body) = text(weight: "medium")[#body]
#let link-mark = box(
  baseline: -0.3em,
  text(size: 0.5em, fill: rgb("#8d93b5"))[#fa-icon("arrow-up-right-from-square")],
)
#let xlink(url, body) = link(url)[#body#h(1.2pt)#link-mark]

// The template's github-link stops at the icon; giving it the same mark the inline links
// carry keeps one convention for "this is clickable" across the whole page.
#let github-link(path) = align(right + horizon)[
  #box(height: 11pt, fa-icon("github", fill: color-darkgray))#h(2pt)#xlink("https://github.com/" + path)[#path]
]

// resume-item hard-codes `set par(leading: 0.65em)` inside the function, and neither a
// set rule nor a show-set rule out here can reach past it. Setting the leading inside
// the body does win, so the item is wrapped once and every call site picks it up.
// The value spends the space left at the bottom of the last page on line spacing.
#let template-item = resume-item
#let resume-item(body) = template-item[
  #set par(leading: 0.76em)
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
  description: "Personal project",
)
#resume-item[
  - #lead[A harness, not a single tool.] Started in July 2026 to see how far AI-assisted
    development can go, and where it should stop: #strong[more than 50 small Python tools]
    in the first month, each one independent, all sharing one SDK —
    #xlink("https://github.com/MyThingsLab/my-things-core")[#tech[my-things-core]] — and its
    five contracts (ledger, policy, engine, GitHub, isolation), so nothing gets reimplemented
    twice.
  - #lead[Control, not autonomy.] Headless workers pick up an issue, do the deterministic
    pre-work with no model call, ask the LLM once for the step that needs judgement, and
    close it as a pull request — never a merge, so the last word stays with a person.
  - #lead[No model inside the core.] The SDK is dependency-free and shells out to #tech[gh]
    and #tech[git], and the LLM sits behind a single #tech[Engine] protocol whose
    deterministic default lets the whole fleet be exercised and tested without a token spent.
]

#resume-entry(
  title: "Money Balling AI",
  location: github-link("MoneyBallingAI"),
  date: "September 2025 - Present",
  description: "Founder and Technical Lead",
)
#resume-item[
  - A team of four building one model that predicts the #strong[exact box score] of an NBA
    game — every player and team line — with calibrated uncertainty. I am responsible for the
    architecture, from raw play-by-play to a calibrated prediction:
  - #lead[Data] — play-by-play parsed into periods, lineup stints and possessions, aggregated
    into cumulative stat windows and modelled as heterogeneous stint graphs, with stable
    global identities for players and teams across seasons.
  - #lead[Encoder] — a heterogeneous GNN over those graphs with per-entity cross-game and
    hierarchical season/game/stint memory, pretrained on a box-score delta task for stable
    player and team strength embeddings.
  - #lead[Simulator] — a vectorized Monte Carlo possession engine whose policies are
    behavior-cloned on real possessions; #lead[calibration] scores per-stat distributions
    against the actual box score with MAE, CRPS, PIT and coverage, test-first and under CI.
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

#resume-entry(
  title: "School on Quantum Simulation",
  location: "Milan, Italy",
  date: "September 2026",
  description: "Department of Physics, University of Milan",
)

#resume-entry(
  title: "Qiskit Fall Fest",
  location: "Milan, Italy",
  date: "October - November 2025",
  description: "IBM Quantum · Department of Physics, University of Milan",
)

= Projects

#resume-entry(
  title: "Gauge-Equivariant Graph Neural Networks",
  location: github-link("lorenzoliuzzo/EGNN"),
  date: "July - August 2026",
  description: "Designer/Developer",
)
#resume-item[
  Lattice Standard Model field theory simulated with gauge-equivariant GNNs in
  #tech[PyTorch Geometric]: SU(3)×SU(2)×U(1) gauge groups, Wilson-Dirac fermions and
  Higgs spontaneous symmetry breaking.
]

#resume-entry(
  title: "MSc Coursework Projects",
  location: "",
  date: "May - July 2026",
  description: "Designer/Developer",
)
#resume-item[
  - #xlink("https://github.com/lorenzoliuzzo/supervised-learning-on-food-images")[#strong[Supervised Learning on Food Images]] — a #tech[PyTorch] #tech[CNN] under 10M parameters classifying the 251 classes of the FoodX-251 dataset.
  - #xlink("https://github.com/lorenzoliuzzo/TFIM")[#strong[Transverse Field Ising Model]] — quantum phase transitions explored on #tech[PennyLane].
  - #xlink("https://github.com/lorenzoliuzzo/unsupervised-learning-on-country-data")[#strong[Unsupervised Learning on Country Data]] — clustering and dimensionality reduction on socio-economic country-level data.
]

#resume-entry(
  title: "Telescope Pointing Simulation",
  location: github-link("lorenzoliuzzo/thesis-L30"),
  date: "June - July 2025",
  description: "Designer/Developer",
)
#resume-item[
  #tech[Julia] model of a telescope's reflective system, propagating mirror defects to
  the pointing direction via #emph[ray tracing] and #emph[Monte Carlo] simulation.
]

#resume-entry(
  title: "Systems & Numerical Programming",
  location: "",
  date: "2023 - 2024",
  description: "Designer/Developer",
)
#resume-item[
  - #xlink("https://github.com/lorenzoliuzzo/PhotoNim")[#strong[Ray Tracing Engine]] — pair project at UNIMI: a physical model turned into structured, tested and documented numerical code, while rapidly learning a new language (#tech[Nim]).
  - #xlink("https://github.com/lorenzoliuzzo/ctda-cpp")[#strong[Dimensional Analysis Library]] — “CTDA: Compile Time Dimensional Analysis”, C++ numeric types carrying units of measurement in the type system.
]

= How I Build Software

#resume-item[
  - #strong[AI across the whole workflow, not only the coding step.] Composable tools cover
    research, design, implementation, testing and documentation, so the model is used
    wherever it earns its place rather than at a single step.
  - #strong[Deterministic first, models only where judgement is needed.] The LLM sits behind
    a single #lead[Engine] seam, so a tool's entire skeleton runs and is tested at zero
    token cost.
  - #strong[Test-driven, and always through a pull request.] Tests are written with the code
    and often before it; #lead[pytest], coverage and #lead[ruff] run on every push, and work
    lands by review rather than by pushing to a main branch.
  - #strong[Every side effect passes a gate.] A policy engine rules each action
    allow/ask/deny, tools open pull requests rather than merging, and every #lead[ask]
    reaches me over Telegram before anything happens.
  - #strong[Understand the problem before writing the code.] A habit kept from physics: work
    out the model first, decide what the code actually has to compute, then write it — typed,
    documented, and with no abstraction built for a need that does not exist yet.
]

= Technical Skills

#resume-skill-item("Languages", (strong("Italian"), strong("English C1")))
#resume-skill-item(
  "Programming Languages",
  (strong("Python"), strong("C++"), strong("Julia"), "C", "Nim"),
)
#resume-skill-item(
  "AI Engineering",
  (
    strong("Claude"),
    strong("Claude Code"),
    "Agentic workflows",
    "Prompt & context engineering",
  ),
)
#resume-skill-item(
  "ML & Data Science",
  (
    strong("PyTorch"),
    strong("PyTorch Geometric"),
    "Scikit-learn",
    "Pandas",
    "NumPy",
    "SciPy",
    "Jupyter",
  ),
)
#resume-skill-item(
  "Databases & Quantum",
  ("Neo4j", "Cypher", strong("PennyLane"), "Qiskit"),
)
#resume-skill-item(
  "Practices",
  (strong("Test-driven development"), strong("Pull request workflow"), "CI/CD", "Static typing"),
)
#resume-skill-item(
  "Development Tools",
  (strong("Git"), strong("GitHub"), "GitHub Actions", "pytest", "ruff"),
)
#resume-skill-item(
  "Typesetting",
  (strong("LaTeX"), strong("Typst"), strong("Markdown"), "Jekyll"),
)

#v(1fr)
#text(size: 8pt, style: "italic", weight: "light")[
  I authorize the processing of my personal data in accordance with Italian
  Legislative Decree 196/2003, as coordinated with Legislative Decree 101/2018,
  and the GDPR (EU Regulation 2016/679) for the purposes of recruitment and
  selection of personnel.
]
