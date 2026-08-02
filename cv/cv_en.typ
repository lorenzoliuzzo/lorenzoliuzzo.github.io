#import "@preview/modern-cv:0.10.0": *

#show: resume.with(
  author: (
    firstname: "Lorenzo",
    lastname: "Liuzzo",
    email: "lorenzoliuzzo@outlook.com",
    github: "lorenzoliuzzo",
    positions: ("Physicist", "Developer", "Software Architect"),
  ),
  profile-picture: image("../assets/images/profile.jpg"),
  language: "en",
  show-footer: false,
  keywords: ("Physicist", "Developer"),
)

#align(center, block(width: 100%)[
  #set par(justify: false)
  #emph[Physicist] and #emph[developer] specialized in #emph[AI], combining
  #emph[machine learning] expertise with robust #emph[software engineering] to
  solve complex problems through scientific rigor and creative innovation.
])

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
  #emph[Ray tracing and Monte Carlo methods for uncertainty quantification in
  the pointing direction of radio telescopes for CMB observations.]
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

= Schools & Workshops

#resume-entry(
  title: "School on Quantum Simulation",
  location: "Milan, Italy",
  date: "9 - 11 September 2026",
  description: "Department of Physics, University of Milan",
)

#resume-entry(
  title: "Qiskit Fall Fest",
  location: "Milan, Italy",
  // TODO: confirm the edition/dates — Fall Fest runs in the autumn, so this is
  // presumably the 2025 edition, but I have no record of it to check against.
  date: "Autumn 2025",
  description: "IBM Quantum",
)

= Experiences

#resume-entry(
  title: "Money Ball AI",
  location: "Milan, Italy",
  date: "September 2025 - Present",
  description: "Founder, Technical Lead and Developer",
)
#resume-item[
  - Founded and lead #emph[MoneyBallingAI], a team of four (physics MSc student, CS MSc graduate, statistician) turning raw NBA play-by-play data into predictive models for basketball analytics.
  - Own the platform architecture: a graph-database backend for play-by-play data, a simulation backend, and the Machine Learning layer built on top of them.
]

#resume-entry(
  title: "Private Tutoring in Mathematics and Physics",
  location: "Milan, Italy",
  date: "2020 - Present",
  description: "In-home tutoring",
)
#resume-item[
  - Continuous support for 20+ students
  - High school graduation exam preparation and remedial tutoring
  - Personalized teaching methodologies tailored to student needs
  - Progress monitoring and periodic reports to families
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
  date: "2021-2022",
  description: "Reparto Breithorn, Gruppo Milan 8, AGESCI",
)
#resume-item[
  - Design and leadership of educational and recreational activities for youth aged 12-16
  - Organization of winter/summer camps and educational outings throughout the year
  - Coordination with other educators and families
]

= Projects

#resume-entry(
  title: "MyThingsLab",
  location: github-link("MyThingsLab"),
  date: "July 2026 - Present",
  description: "Architect/Developer",
)
#resume-item[
  - A fleet of 56 composable Python tools on a shared SDK, with a policy engine gating every side effect as allow/ask/deny.
  - Drives an autonomous development loop: headless LLM workers pick issues off a backlog and close them as pull requests, deterministic except where judgement is genuinely needed.
]

#resume-entry(
  title: "Gauge-Equivariant Graph Neural Networks",
  location: github-link("lorenzoliuzzo/EGNN"),
  date: "July - August 2026",
  description: "Designer/Developer",
)
#resume-item[
  Lattice Standard Model field theory simulated with gauge-equivariant GNNs in
  #emph[PyTorch Geometric], covering SU(3)×SU(2)×U(1) gauge groups, Wilson-Dirac
  fermions and Higgs spontaneous symmetry breaking.
]

#resume-entry(
  title: "Supervised Learning on Food Images",
  location: github-link("lorenzoliuzzo/supervised-learning-on-food-images"),
  date: "July 2026",
  description: "Designer/Developer",
)
#resume-item[
  A convolutional neural network under 10M parameters classifying the 251 classes
  of the FoodX-251 dataset.
]

#resume-entry(
  title: "Transverse Field Ising Model",
  location: github-link("lorenzoliuzzo/TFIM"),
  date: "July 2026",
  description: "Designer/Developer",
)
#resume-item[
  Exploration of quantum phase transitions in the Transverse Field Ising Model,
  implemented on #emph[PennyLane].
]

#resume-entry(
  title: "Unsupervised Learning on Country Data",
  location: github-link("lorenzoliuzzo/unsupervised-learning-on-country-data"),
  date: "May 2026",
  description: "Designer/Developer",
)
#resume-item[
  Clustering and dimensionality reduction applied to socio-economic country-level
  data.
]

#resume-entry(
  title: "Telescope Pointing Simulation",
  location: github-link("lorenzoliuzzo/thesis-L30"),
  date: "June - July 2025",
  description: "Designer/Developer",
)
#resume-item[
  Implementation in #emph[Julia] that allows modeling the reflective system of an
  optical telescope and studying the propagation of instrumental defects in mirrors
  to the pointing direction, combining geometric optics with #emph[ray tracing] and
  #emph[Monte Carlo] simulation techniques.
]

#resume-entry(
  title: "Ray Tracing Engine",
  location: github-link("lorenzoliuzzo/PhotoNim"),
  date: "March - July 2024",
  description: "Co-Designer/Developer",
)
#resume-item[
  - Pair project for the course #emph[Numerical Techniques for Photorealistic Image Generation] at UNIMI.
  - Translated a physical model into well-structured, tested and documented numerical code, while rapidly learning a new language (#emph[Nim]).
]

#resume-entry(
  title: "Dimensional Analysis Library",
  location: github-link("lorenzoliuzzo/ctda-cpp"),
  date: "September - October 2023",
  description: "Designer/Developer",
)
#resume-item[
  “CTDA: Compile Time Dimensional Analysis”, implementation in C++ of numeric
  types supporting units of measurement.
]

= Skills

#resume-skill-item("Languages", (strong("Italian"), strong("English C1")))
#resume-skill-item(
  "Programming Languages",
  (strong("C++"), strong("Python"), strong("Julia"), "C", "Nim"),
)
#resume-skill-item(
  "Markup Languages",
  (strong("LaTeX"), strong("Typst"), strong("Markdown"), "HTML"),
)
#resume-skill-item(
  "Development Tools",
  (strong("Git"), strong("GitHub"), strong("Jupyter")),
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
#resume-skill-item("Quantum Computing", (strong("PennyLane"), strong("Qiskit")))

= Personal Interests

#resume-skill-item(
  "Hiking & Camping",
  ("Walking in the mountains and experiencing the essentiality of nature",),
)
#resume-skill-item(
  "Volunteering",
  ("Scout camps", "Elderly assistance", "Music therapy for children with disabilities"),
)
#resume-skill-item("Sports", ("Swimming", "Water polo", "SlackLine", "Climbing"))
#resume-skill-item(
  "Travel",
  ("Any destination and mode: on foot, by bike, by train, by car, by plane",),
)

#v(1fr)
#text(size: 8pt, style: "italic", weight: "light")[
  I authorize the processing of my personal data in accordance with Italian
  Legislative Decree 196/2003, as coordinated with Legislative Decree 101/2018,
  and the GDPR (EU Regulation 2016/679) for the purposes of recruitment and
  selection of personnel.
]

