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
    positions: ("Fisico", "Programmatore", "Sistemi di AI"),
  ),
  profile-picture: image("../assets/images/profile.jpg"),
  language: "it",
  show-footer: false,
  keywords: ("Fisico", "Programmatore"),
)

// Tre segnali, ognuno con un compito solo, così non serve alzare la voce:
//   `lead` — il colore d'accento del documento sulla frase di cui parla il punto;
//   `tech` — un peso più marcato sulle tecnologie, così lo stack si legge a colpo d'occhio;
//   `xlink` — un piccolo segno dopo il testo cliccabile, l'unica cosa che marca un link.
// Il grassetto resta raro di proposito: una affermazione per voce, e solo le competenze più solide.
#let lead(body) = text(fill: default-accent-color, weight: "semibold")[#body]
#let tech(body) = text(weight: "medium")[#body]
#let link-mark = box(
  baseline: -0.3em,
  text(size: 0.5em, fill: rgb("#8d93b5"))[#fa-icon("arrow-up-right-from-square")],
)
#let xlink(url, body) = link(url)[#body#h(1.2pt)#link-mark]

// github-link del template si ferma all'icona: aggiungendo lo stesso segno dei link in
// linea, tutta la pagina usa una sola convenzione per dire "qui si può cliccare".
#let github-link(path) = align(right + horizon)[
  #box(height: 11pt, fa-icon("github", fill: color-darkgray))#h(2pt)#xlink("https://github.com/" + path)[#path]
]

// resume-item fissa `set par(leading: 0.65em)` dentro la funzione, e nessuna set rule
// qui fuori riesce a scavalcarla. Impostare l'interlinea dentro il corpo invece
// funziona, quindi l'item viene avvolto una volta sola e tutti i punti di chiamata la
// ereditano. Il valore spende in leggibilità lo spazio libero in fondo all'ultima pagina.
#let template-item = resume-item
#let resume-item(body) = template-item[
  #set text(size: 9.5pt)
  #set par(leading: 0.66em)
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
  description: "Progetto personale",
)
#resume-item[
  - Un posto per capire fin dove si possa spingere lo sviluppo assistito dall'AI, e dove
    debba fermarsi: #strong[più di 50 piccoli tool Python] nel primo mese, tutti su un solo
    SDK — #xlink("https://github.com/MyThingsLab/my-things-core")[#tech[my-things-core]] —
    che espone cinque contratti (ledger, policy, engine,
    GitHub, isolation) importati da ogni tool e reimplementati da nessuno.
  - #lead[Controllo, non autonomia.] Worker headless prendono una issue, fanno il lavoro
    deterministico senza chiamare il modello, invocano l'LLM solo per il passo che richiede
    giudizio e chiudono con una pull request — mai un merge, così l'ultima parola resta a
    una persona.
  - #lead[Nessun modello dentro il core.] L'SDK è dependency-free e si appoggia a #tech[gh]
    e #tech[git], e l'LLM vive dietro un unico protocollo #tech[Engine] il cui default
    deterministico permette di esercitare e testare l'intera flotta senza spendere un token.
]

#resume-entry(
  title: "Money Balling AI",
  location: github-link("MoneyBallingAI"),
  date: "Settembre 2025 - in corso",
  description: "Founder e Technical Lead",
)
#resume-item[
  - Un team di quattro persone che costruisce un unico modello capace di predire il
    #strong[box score esatto] di una partita NBA — ogni riga di giocatore e di squadra — con
    incertezza calibrata. Ne curo l'architettura, dal play-by-play grezzo alla predizione:
  - #lead[Dati] — play-by-play scomposto in periodi, stint di quintetto e possessi,
    aggregato in finestre cumulative di statistiche e modellato come grafi di stint
    eterogenei, con identità globali stabili per giocatori e squadre tra le stagioni.
  - #lead[Encoder] — una GNN eterogenea su quei grafi con memoria per entità tra partite
    e gerarchica su stagione/partita/stint, pre-addestrata su un task di delta del box
    score per ottenere embedding stabili di giocatori e squadre.
  - #lead[Simulatore] — un motore Monte Carlo vettorizzato di possessi le cui policy sono
    behavior-cloned su possessi reali; la #lead[calibrazione] confronta le distribuzioni per
    statistica con il box score reale usando MAE, CRPS, PIT e coverage, test-first e sotto CI.
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

// Un secondo punto di rottura: in italiano il testo è più lungo e senza questo la
// coppia I.I.S. + EF finisce insieme sulla pagina dopo, lasciando un buco qui.
#block(height: 0pt, above: 0pt, below: 0pt, width: 100%)[#box()]

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

#resume-entry(
  title: "School on Quantum Simulation",
  location: "Milano, Italia",
  date: "Settembre 2026",
  description: "Dipartimento di Fisica, Università degli Studi di Milano",
)

#resume-entry(
  title: "Qiskit Fall Fest",
  location: "Milano, Italia",
  date: "Ottobre - Novembre 2025",
  description: "IBM Quantum · Dipartimento di Fisica, Università degli Studi di Milano",
)

= Progetti

#resume-entry(
  title: "Gauge-Equivariant Graph Neural Networks",
  location: github-link("lorenzoliuzzo/EGNN"),
  date: "Luglio - Agosto 2026",
  description: "Designer/Developer",
)
#resume-item[
  Teoria di campo del Modello Standard su reticolo simulata con GNN gauge-equivarianti in
  #tech[PyTorch Geometric]: gruppi di gauge SU(3)×SU(2)×U(1), fermioni di Wilson-Dirac e
  rottura spontanea di simmetria di Higgs.
]

#resume-entry(
  title: "Progetti dei corsi della magistrale",
  location: github-link("lorenzoliuzzo"),
  date: "Maggio - Luglio 2026",
  description: "Designer/Developer",
)
#resume-item[
  - #xlink("https://github.com/lorenzoliuzzo/supervised-learning-on-food-images")[#strong[Supervised Learning on Food Images]] — una #tech[CNN] sotto i 10M di parametri sulle 251 classi del dataset FoodX-251.
  - #xlink("https://github.com/lorenzoliuzzo/TFIM")[#strong[Transverse Field Ising Model]] — transizioni di fase quantistiche esplorate su #tech[PennyLane].
  - #xlink("https://github.com/lorenzoliuzzo/unsupervised-learning-on-country-data")[#strong[Unsupervised Learning on Country Data]] — clustering e riduzione della dimensionalità su dati socio-economici nazionali.
]

#resume-entry(
  title: "Telescope Pointing Simulation",
  location: github-link("lorenzoliuzzo/thesis-L30"),
  date: "Giugno - Luglio 2025",
  description: "Designer/Developer",
)
#resume-item[
  Modello in #tech[Julia] del sistema riflettivo di un telescopio: i difetti degli specchi
  propagati sulla direzione di puntamento via #emph[ray tracing] e #emph[Monte Carlo].
]

#resume-entry(
  title: "Programmazione di sistema e numerica",
  location: "C++ · Nim",
  date: "2023 - 2024",
  description: "Designer/Developer",
)
#resume-item[
  - #xlink("https://github.com/lorenzoliuzzo/PhotoNim")[#strong[Ray Tracing Engine]] — progetto di coppia a UNIMI: un modello fisico tradotto in codice numerico strutturato, testato e documentato, imparando in fretta un nuovo linguaggio (#tech[Nim]).
  - #xlink("https://github.com/lorenzoliuzzo/ctda-cpp")[#strong[Dimensional Analysis Library]] — «CTDA: Compile Time Dimensional Analysis», tipi numerici C++ che portano le unità di misura nel sistema dei tipi.
]

= Come Sviluppo Software

#resume-item[
  - #lead[L'AI su tutto il flusso, non solo sulla scrittura del codice.] Tool componibili
    coprono ricerca, progettazione, implementazione, test e documentazione, così il modello
    viene usato dove serve davvero e non in un unico passaggio.
  - #lead[Prima il deterministico, il modello solo dove serve giudizio.] L'LLM sta dietro un
    unico punto di innesto #tech[Engine], così l'intero scheletro di un tool gira ed è
    testato a costo zero di token.
  - #lead[Test-driven, e sempre attraverso una pull request.] I test si scrivono insieme al
    codice, spesso prima; #tech[pytest], coverage e #tech[ruff] girano a ogni push, e il
    lavoro entra passando da una review, non da un push sul branch principale.
  - #lead[Ogni effetto collaterale passa da un gate.] Un motore di policy decide ogni azione
    allow/ask/deny, i tool aprono pull request invece di fare merge, e ogni #emph[ask] mi
    arriva su Telegram prima che accada qualcosa.
  - #lead[Capire il problema prima di scrivere il codice.] Un'abitudine che viene dalla
    fisica: ricavare il modello, decidere cosa deve davvero calcolare il codice e solo dopo
    scriverlo — tipizzato, documentato e senza astrazioni per bisogni che non esistono.
]

= Competenze

#resume-skill-item("Lingue", (strong("Italiano"), strong("Inglese C1")))
#resume-skill-item(
  "Programmazione",
  (strong("Python"), strong("C++"), strong("Julia"), "C", "Nim"),
)
#resume-skill-item(
  "AI Engineering",
  (
    strong("Claude"),
    strong("Claude Code"),
    "Workflow agentici",
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
  ),
)
#resume-skill-item(
  "Database & Quantum",
  ("Neo4j", "Cypher", strong("PennyLane"), "Qiskit"),
)
#resume-skill-item(
  "Pratiche",
  (strong("Sviluppo test-driven"), strong("Code review"), "CI/CD", "Tipizzazione statica"),
)
#resume-skill-item(
  "Strumenti di sviluppo",
  (strong("Git"), strong("GitHub"), "GitHub Actions", "pytest", "ruff", "Jupyter"),
)
#resume-skill-item(
  "Typesetting",
  (strong("LaTeX"), strong("Typst"), strong("Markdown"), "Jekyll"),
)

#v(1fr)
#text(size: 8pt, style: "italic", weight: "light")[
  Autorizzo il trattamento dei miei dati personali ai sensi del D. Lgs. 196/2003,
  coordinato con il D. Lgs. 101/2018, e del GDPR (Regolamento UE 2016/679) ai fini
  della ricerca e selezione del personale.
]
