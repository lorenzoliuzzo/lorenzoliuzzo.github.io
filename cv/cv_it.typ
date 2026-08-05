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
    positions: ("Fisico", "Programmatore", "Sistemi di AI"),
  ),
  profile-picture: image("../assets/images/profile.jpg"),
  language: "it",
  show-footer: false,
  keywords: ("Fisico", "Programmatore"),
)

// resume-item fissa `set par(leading: 0.65em)` dentro la funzione, e nessuna set rule
// qui fuori riesce a scavalcarla. Impostare l'interlinea dentro il corpo invece
// funziona, quindi l'item viene avvolto una volta sola e tutti i punti di chiamata la
// ereditano. Il valore spende in leggibilità lo spazio libero in fondo all'ultima pagina.
#let template-item = resume-item
#let resume-item(body) = template-item[
  #set par(leading: 0.73em)
  #body
]

// Risalita nello spazio libero lasciato dalla griglia dell'intestazione, con la stessa
// larghezza della colonna del nome per non finire sotto alla foto.
#v(-33pt)
#block(width: 100% - 4cm - 10pt)[
  #set par(justify: false)
  #align(center)[
    #emph[Fisico] e #emph[programmatore] specializzato in #emph[AI]. La fisica mi ha
    insegnato a ricavare il modello prima di scrivere il codice; ultimamente passo gran
    parte del tempo a capire quanto di quella scrittura si possa delegare a un modello, e
    dove debba ancora decidere una persona.
  ]
]
#v(-4pt)

= Esperienze

#resume-entry(
  title: "MyThingsLab",
  location: github-link("MyThingsLab"),
  date: "Luglio 2026 - in corso",
  description: "Founder, Architect e Developer",
)
#resume-item[
  - Un laboratorio personale sullo sviluppo assistito dall'AI, avviato a luglio 2026:
    #strong[più di 50 tool Python componibili] nel primo mese, tutti su un solo SDK —
    #emph[my-things-core] — che espone cinque contratti (ledger, policy, engine, GitHub,
    isolation) importati da ogni tool e reimplementati da nessuno.
  - Quello che sto sperimentando è il controllo, non l'autonomia: worker headless prendono
    una issue, svolgono il lavoro deterministico senza chiamare il modello, invocano l'LLM
    una sola volta per il passo che richiede giudizio e chiudono con una pull request —
    mai un merge, così l'ultima parola resta mia.
  - L'SDK è dependency-free e non chiama alcun modello: si appoggia a #emph[gh] e
    #emph[git], e l'LLM vive dietro un unico protocollo #emph[Engine] il cui default
    deterministico permette di esercitare e testare l'intera flotta senza spendere token.
]

#resume-entry(
  title: "Money Ball AI",
  location: github-link("MoneyBallingAI"),
  date: "Settembre 2025 - in corso",
  description: "Founder, Technical Lead e Developer",
)
#resume-item[
  - Ho fondato e guido un team di quattro persone che costruisce un unico modello capace di
    predire il #strong[box score esatto] di una partita NBA — ogni riga di giocatore e di
    squadra — con incertezza calibrata. Ne curo l'architettura, dal play-by-play grezzo
    fino a una predizione calibrata:
  - #strong[Dati] — play-by-play scomposto in periodi, stint di quintetto e possessi,
    aggregato in finestre cumulative di statistiche e modellato come grafi di stint
    eterogenei con identità globali stabili per giocatori e squadre tra le stagioni.
  - #strong[Encoder] — una GNN eterogenea su quei grafi con memoria per entità tra partite
    e gerarchica su stagione/partita/stint, pre-addestrata su un task di delta del box
    score per ottenere embedding stabili di giocatori e squadre.
  - #strong[Simulatore] — un motore Monte Carlo vettorizzato di possessi le cui policy sono
    behavior-cloned su possessi reali; la #strong[calibrazione] confronta le distribuzioni
    per statistica con il box score reale usando MAE, CRPS, PIT e coverage, sotto CI con
    una suite #emph[pytest] da 134 test.
]

#resume-entry(
  title: "Lezioni private di Matematica e Fisica",
  location: "Milano, Italia",
  date: "2020 - in corso",
  description: "A domicilio",
)
#resume-item[
  Assistenza continuativa a 20+ studenti: preparazione agli esami, recupero debiti e
  report periodici alle famiglie.
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
  date: "2021 - 2022",
  description: "Reparto Breithorn - Gruppo MI8 - AGESCI",
)
#resume-item[
  Attività educative per ragazzi tra i 12 e i 16 anni: campi, uscite e coordinamento con
  educatori e famiglie.
]

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
  Tesi: #emph[ray tracing e metodi Monte Carlo per la quantificazione dell'incertezza nel
  puntamento di radiotelescopi per osservazioni della CMB.]
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

// resume-entry è sticky: senza un blocco neutro qui l'intera coda di Educazione viene
// trascinata sulla pagina successiva invece di spezzarsi dopo questa voce.
#block(height: 0pt, above: 0pt, below: 0pt, width: 100%)[#box()]

= Scuole e Workshop

#resume-item[
  #block(breakable: false)[
    - #strong[School on Quantum Simulation] — Dipartimento di Fisica, Università degli
      Studi di Milano (9 - 11 settembre 2026).
    - #strong[Qiskit Fall Fest] — IBM Quantum · Dipartimento di Fisica, Università degli
      Studi di Milano (31 ottobre - 7 novembre 2025).
  ]
]

= Progetti

#resume-entry(
  title: "Gauge-Equivariant Graph Neural Networks",
  location: github-link("lorenzoliuzzo/EGNN"),
  date: "Luglio - Agosto 2026",
  description: "Designer/Developer",
)
#resume-item[
  Teoria di campo del Modello Standard su reticolo simulata con GNN gauge-equivarianti in
  #emph[PyTorch Geometric]: gruppi di gauge SU(3)×SU(2)×U(1), fermioni di Wilson-Dirac e
  rottura spontanea di simmetria di Higgs.
]

#resume-entry(
  title: "Progetti dei corsi della magistrale",
  location: github-link("lorenzoliuzzo"),
  date: "Maggio - Luglio 2026",
  description: "Designer/Developer",
)
#resume-item[
  - #link("https://github.com/lorenzoliuzzo/supervised-learning-on-food-images")[#strong[Supervised Learning on Food Images]] — una rete neurale convoluzionale sotto i 10M di parametri che classifica le 251 classi del dataset FoodX-251.
  - #link("https://github.com/lorenzoliuzzo/TFIM")[#strong[Transverse Field Ising Model]] — transizioni di fase quantistiche esplorate su #emph[PennyLane].
  - #link("https://github.com/lorenzoliuzzo/unsupervised-learning-on-country-data")[#strong[Unsupervised Learning on Country Data]] — clustering e riduzione della dimensionalità su dati socio-economici nazionali.
]

#resume-entry(
  title: "Telescope Pointing Simulation",
  location: github-link("lorenzoliuzzo/thesis-L30"),
  date: "Giugno - Luglio 2025",
  description: "Designer/Developer",
)
#resume-item[
  Modello in #emph[Julia] del sistema riflettivo di un telescopio, che propaga i difetti
  degli specchi fino alla direzione di puntamento tramite #emph[ray tracing] e simulazione
  #emph[Monte Carlo].
]

#resume-entry(
  title: "Programmazione di sistema e numerica",
  location: "C++ · Nim",
  date: "2023 - 2024",
  description: "Designer/Developer",
)
#resume-item[
  - #link("https://github.com/lorenzoliuzzo/PhotoNim")[#strong[Ray Tracing Engine]] — progetto di coppia a UNIMI: un modello fisico tradotto in codice numerico strutturato, testato e documentato, imparando in fretta un nuovo linguaggio (#emph[Nim]).
  - #link("https://github.com/lorenzoliuzzo/ctda-cpp")[#strong[Dimensional Analysis Library]] — «CTDA: Compile Time Dimensional Analysis», tipi numerici C++ che portano le unità di misura nel sistema dei tipi.
]

= Come Sviluppo Software

#resume-item[
  - #strong[L'AI su tutto il flusso, non solo sulla scrittura del codice.] Tool componibili
    coprono progettazione, implementazione, test e documentazione — ed è così che una sola
    persona ne può seguire più di 50 in un mese, con pytest, coverage e ruff a ogni push.
  - #strong[Prima il deterministico, il modello solo dove serve giudizio.] L'LLM sta dietro
    un unico punto di innesto #emph[Engine], così l'intero scheletro di un tool gira ed è
    testato a costo zero di token.
  - #strong[Tagliare la complessità prima che si accumuli.] Il core condiviso resta
    dependency-free — si appoggia a #emph[gh] e #emph[git] invece di tirarsi dentro SDK — e
    non costruisce astrazioni per bisogni che ancora non esistono.
  - #strong[Ogni effetto collaterale passa da un gate.] Un motore di policy decide ogni
    azione allow/ask/deny, i tool aprono pull request invece di fare merge, e ogni
    #emph[ask] mi arriva su Telegram prima che accada qualcosa.
  - #strong[Prima il modello, poi il codice.] Dalla fisica al codice numerico tipizzato e
    documentato — come nella tesi sul puntamento del telescopio.
]

= Competenze

#resume-skill-item("Lingue", (strong("Italiano"), strong("Inglese C1")))
#resume-skill-item(
  "Programmazione",
  (strong("C++"), strong("Python"), strong("Julia"), "C", "Nim"),
)
#resume-skill-item(
  "AI Engineering",
  (
    strong("Claude"),
    strong("Claude Code"),
    strong("Workflow agentici"),
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
  "Database & Quantum",
  (strong("Neo4j"), strong("Cypher"), strong("PennyLane"), strong("Qiskit")),
)
#resume-skill-item(
  "Strumenti di sviluppo",
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
  Autorizzo il trattamento dei miei dati personali ai sensi del D. Lgs. 196/2003,
  coordinato con il D. Lgs. 101/2018, e del GDPR (Regolamento UE 2016/679) ai fini
  della ricerca e selezione del personale.
]
