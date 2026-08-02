#import "@preview/modern-cv:0.10.0": *

#show: resume.with(
  author: (
    firstname: "Lorenzo",
    lastname: "Liuzzo",
    email: "lorenzoliuzzo@outlook.com",
    github: "lorenzoliuzzo",
    positions: ("Fisico", "Programmatore", "Architetto del Software"),
  ),
  profile-picture: image("../assets/images/profile.jpg"),
  language: "it",
  show-footer: false,
  keywords: ("Fisico", "Programmatore"),
)

#align(center, block(width: 100%)[
  #set par(justify: false)
  #emph[Fisico] e #emph[programmatore] specializzato in #emph[AI] con esperienza
  in #emph[machine learning], #emph[analisi dati] e #emph[sviluppo software].
  Attitudine a risolvere problemi complessi attraverso approcci scientifici e
  innovativi.
])

= Educazione

#resume-entry(
  title: "Università degli Studi di Milano, di Milano-Bicocca e di Pavia",
  location: "Milano/Pavia, Italia",
  date: "Settembre 2025 - in corso",
  description: "Laurea magistrale in Artificial Intelligence for Science and Technology",
)

#resume-entry(
  title: "Università degli Studi di Milano",
  location: "Milano, Italia",
  date: "Settembre 2021 - Luglio 2025",
  description: "Laurea triennale in Fisica, Votazione: 100/110",
)
#resume-item[
  #emph[Tesi: «Ray tracing and Monte Carlo methods for uncertainty quantification
  in the pointing direction of radio telescopes for CMB observations.»]
]

#resume-entry(
  title: "I.I.S. Severi-Correnti",
  location: "Milano, Italia",
  date: "Settembre 2016 - Giugno 2021",
  description: "Diploma Scientifico, Votazione: 100/100",
)

#resume-entry(
  title: "EF International Language School",
  location: "Brighton, Inghilterra",
  date: "Giugno - Settembre 2019",
  description: "Corso intensivo di lingua inglese full-immersion",
)

= Scuole e Workshop

#resume-entry(
  title: "School on Quantum Simulation",
  location: "Milano, Italia",
  date: "9 - 11 Settembre 2026",
  description: "Dipartimento di Fisica, Università degli Studi di Milano",
)

#resume-entry(
  title: "Qiskit Fall Fest",
  location: "Milano, Italia",
  // TODO: confermare edizione/date — vedi la nota in cv_en.typ.
  date: "Autunno 2025",
  description: "IBM Quantum",
)

= Esperienze

#resume-entry(
  title: "Money Ball AI",
  location: "Milano, Italia",
  date: "Settembre 2025 - in corso",
  description: "Founder, Technical Lead e Developer",
)
#resume-item[
  - Ho fondato e guido #emph[MoneyBallingAI], un team di quattro persone (fisico, informatico, statistico) che trasforma i dati grezzi play-by-play NBA in modelli predittivi per l'analisi cestistica.
  - Curo l'architettura della piattaforma: un backend a database a grafo per i dati play-by-play, un backend di simulazione e il livello di Machine Learning costruito su di essi.
]

#resume-entry(
  title: "Lezioni private di Matematica e Fisica",
  location: "Milano, Italia",
  date: "2020 - in corso",
  description: "A domicilio",
)
#resume-item[
  - Assistenza continuativa a 20+ studenti
  - Preparazione esame di maturità e recupero debiti
  - Metodologie didattiche personalizzate in base alle esigenze dello studente
  - Monitoraggio dei progressi e report periodici alle famiglie
]

#resume-entry(
  title: "Barista",
  location: "Milano, Italia",
  date: "Settembre - Ottobre 2024",
  description: "Don Salvatore - Pizzaiuolo e Oste",
)

#resume-entry(
  title: "Cameriere",
  location: "Milano, Italia",
  date: "Maggio - Luglio 2022",
  description: "Bar Terrazza Clér",
)

#resume-entry(
  title: "Capo Scout",
  location: "Milano, Italia",
  date: "2021-2022",
  description: "Reparto Breithorn, Gruppo Milano 8, AGESCI",
)
#resume-item[
  - Progettazione e conduzione di attività educative e ricreative rivolte a ragazzi tra i 12-16 anni
  - Organizzazione di campi invernali/estivi e uscite formative durante tutto l'anno
  - Coordinamento con altri educatori e famiglie
]

= Progetti

#resume-entry(
  title: "MyThingsLab",
  location: github-link("MyThingsLab"),
  date: "Luglio 2026 - in corso",
  description: "Architect/Developer",
)
#resume-item[
  - Una flotta di 56 strumenti Python componibili su un SDK condiviso, con un policy engine per ogni side effect.
  - Guida un ciclo di sviluppo autonomo: worker LLM headless chiudono le issue di un backlog come pull request, in modo deterministico tranne dove serve un giudizio.
]

#resume-entry(
  title: "Gauge-Equivariant Graph Neural Networks",
  location: github-link("lorenzoliuzzo/EGNN"),
  date: "Luglio - Agosto 2026",
  description: "Designer/Developer",
)
#resume-item[
  Teoria di campo del Modello Standard su reticolo simulata con GNN
  gauge-equivarianti in #emph[PyTorch Geometric], con gruppi di gauge
  SU(3)×SU(2)×U(1), fermioni di Wilson-Dirac e rottura spontanea di simmetria
  di Higgs.
]

#resume-entry(
  title: "Supervised Learning on Food Images",
  location: github-link("lorenzoliuzzo/supervised-learning-on-food-images"),
  date: "Luglio 2026",
  description: "Designer/Developer",
)
#resume-item[
  Una rete neurale convoluzionale sotto i 10M di parametri che classifica le 251
  classi del dataset FoodX-251.
]

#resume-entry(
  title: "Transverse Field Ising Model",
  location: github-link("lorenzoliuzzo/TFIM"),
  date: "Luglio 2026",
  description: "Designer/Developer",
)
#resume-item[
  Esplorazione delle transizioni di fase quantistiche nel Transverse Field Ising
  Model, implementata su #emph[PennyLane].
]

#resume-entry(
  title: "Unsupervised Learning on Country Data",
  location: github-link("lorenzoliuzzo/unsupervised-learning-on-country-data"),
  date: "Maggio 2026",
  description: "Designer/Developer",
)
#resume-item[
  Clustering e riduzione della dimensionalità applicati a dati socio-economici a
  livello nazionale.
]

#resume-entry(
  title: "Telescope Pointing Simulation",
  location: github-link("lorenzoliuzzo/thesis-L30"),
  date: "Giugno - Luglio 2025",
  description: "Designer/Developer",
)
#resume-item[
  Implementazione in #emph[Julia] che permette di modellare il sistema riflettivo
  di un telescopio ottico e di studiare la propagazione di difetti strumentali
  degli specchi nella direzione di puntamento, combinando l'ottica geometrica con
  tecniche di #emph[ray tracing] e di simulazione #emph[Monte Carlo].
]

#resume-entry(
  title: "Ray Tracing Engine",
  location: github-link("lorenzoliuzzo/PhotoNim"),
  date: "Marzo - Luglio 2024",
  description: "Co-Designer/Developer",
)
#resume-item[
  - Progetto di coppia per il corso #emph[Tecniche numeriche per la generazione di immagini fotorealistiche] presso UNIMI.
  - Traduzione di un modello fisico in codice numerico ben strutturato, testato e documentato, con apprendimento rapido di un nuovo linguaggio (#emph[Nim]).
]

#resume-entry(
  title: "Dimensional Analysis Library",
  location: github-link("lorenzoliuzzo/ctda-cpp"),
  date: "Settembre - Ottobre 2023",
  description: "Designer/Developer",
)
#resume-item[
  «CTDA: Compile Time Dimensional Analysis», implementazione in C++ di tipi
  numerici che supportano unità di misura.
]

= Skills

#resume-skill-item("Lingue straniere", (strong("Inglese C1"),))
#resume-skill-item(
  "Programmazione",
  (strong("C++"), strong("Python"), strong("Julia"), "C", "Nim"),
)
#resume-skill-item(
  "Impaginazione",
  (strong("LaTeX"), strong("Typst"), strong("Markdown"), "HTML"),
)
#resume-skill-item(
  "Strumenti di Sviluppo",
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

= Interessi personali

#resume-skill-item(
  "Hiking & Camping",
  ("Camminare in montagna e vivere l'essenzialità della natura",),
)
#resume-skill-item(
  "Volontariato",
  ("Campi scout", "Assistenza agli anziani", "Musica-Terapia per bambini con disabilità"),
)
#resume-skill-item("Sport", ("Nuoto", "Pallanuoto", "SlackLine", "Arrampicata"))
#resume-skill-item(
  "Viaggiare",
  ("Qualsiasi meta e modalità: piedi, bici, treno, macchina, aereo",),
)

#v(1fr)
#text(size: 8pt, style: "italic", weight: "light")[
  Autorizzo il trattamento dei miei dati personali ai sensi del D. Lgs. 196/2003,
  coordinato con il D. Lgs. 101/2018, e del GDPR (Regolamento UE 2016/679) ai fini
  della ricerca e selezione del personale.
]
