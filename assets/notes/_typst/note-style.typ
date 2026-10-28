// Shared style for the technical references that sit behind the site notes
// (one PDF per course). Written once so every course looks and behaves the same.
// Use:
//
//   #import "../../_typst/note-style.typ": *
//   #show: reference.with(title: "...", subtitle: "...", abstract: [...], site: "https://...")
//
// The rules for writing a reference are in .claude/skills/write-typst-reference/.
// The palette is the site's (--hue-1 ... --hue-6 in _sass/_tokens.scss), so a figure,
// a callout and a link mean the same thing on the page and in the PDF.

#let hue = (
  blue: rgb("#26647f"), violet: rgb("#7b4f9d"), green: rgb("#2f7d52"),
  orange: rgb("#b4581f"), rose: rgb("#a63a62"), olive: rgb("#5b6e22"),
)
#let ink = rgb("#1b1f23")
#let muted = rgb("#5f6971")
#let faint = rgb("#8a939b")
#let rule-colour = rgb("#d9d4c8")

// Operators shared by every statistics-style reference. Add course-specific ones in
// the course file, not here.
#let EE = math.op("E")
#let PP = math.op("P")
#let Var = math.op("Var")
#let Cov = math.op("Cov")
#let MSE = math.op("MSE")
#let bias = math.op("bias")
#let se = math.op("se")
#let argmax = math.op("arg max", limits: true)
#let iid = $"i.i.d."$
#let cd = $->^d$
#let cp = $->^P$

/// Document setup: page, type, headings, running header, title block and contents.
#let reference(title: "", subtitle: "Technical reference", abstract: none, site: none, author: "Lorenzo Liuzzo", body) = {
  set document(title: title + ": " + lower(subtitle), author: author)
  set page(
    paper: "a4",
    margin: (x: 2.2cm, top: 2.6cm, bottom: 2.4cm),
    numbering: "1",
    header: context {
      if counter(page).get().first() > 1 {
        let chapters = query(heading.where(level: 1).before(here()))
        set text(size: 8.5pt, fill: faint)
        grid(columns: (1fr, auto), title, if chapters.len() > 0 { chapters.last().body })
        v(-4pt)
        line(length: 100%, stroke: 0.5pt + rule-colour)
      }
    },
    footer: context {
      set text(size: 8.5pt, fill: faint)
      align(center, counter(page).display("1"))
    },
  )
  set text(size: 10.5pt, lang: "en", fill: ink)
  set par(justify: true, leading: 0.62em)
  set heading(numbering: "1.1")
  show heading.where(level: 1): it => block(above: 2em, below: 1em, width: 100%, breakable: false)[
    #set text(size: 17pt, weight: "bold", fill: hue.blue)
    #grid(columns: (auto, 1fr), column-gutter: 0.6em, counter(heading).display(), it.body)
    #v(-4pt)
    #line(length: 100%, stroke: 1.2pt + hue.blue)
  ]
  show heading.where(level: 2): it => block(above: 1.4em, below: 0.7em)[
    #set text(size: 12.5pt, weight: "bold")
    #grid(columns: (auto, 1fr), column-gutter: 0.5em, text(fill: faint, counter(heading).display()), it.body)
  ]
  set math.equation(numbering: "(1)")
  show link: set text(fill: hue.blue)
  show figure.caption: set text(size: 9pt, fill: muted)
  show figure: set block(above: 1.4em, below: 1.4em)

  // Title block.
  block(width: 100%, inset: (x: 0pt, y: 0pt))[
    #rect(width: 3.2cm, height: 4pt, fill: hue.blue, radius: 2pt)
    #v(10pt)
    #text(size: 24pt, weight: "bold")[#title]
    #v(2pt)
    #text(size: 13pt, fill: muted)[#subtitle]
    #if abstract != none [
      #v(8pt)
      #block(width: 88%, text(size: 10pt, fill: muted, abstract))
    ]
    #if site != none [
      #v(2pt)
      #text(size: 9pt, fill: faint)[Companion to the notes at #link(site)]
    ]
  ]
  v(10pt)
  text(size: 9pt, weight: "bold", fill: faint, tracking: 0.08em)[#upper[Contents]]
  v(-2pt)
  outline(title: none, indent: 1.2em, depth: 2)
  body
}

// Boxed environments. Left bar and tint in the environment's colour, label in bold.
#let box-env(kind, title, body, colour, id: none) = block(
  width: 100%, inset: (x: 11pt, y: 8pt), radius: (right: 3pt), breakable: true,
  fill: colour.lighten(92%), stroke: (left: 2.2pt + colour),
)[
  #text(weight: "bold", fill: colour, size: 9.5pt)[#upper(kind)]#if title != none [ #text(weight: "bold")[#title]] #h(0.4em) #body #if id != none { label(id) }
]
#let definition(title: none, id: none, body) = box-env("Definition", title, body, hue.blue, id: id)
#let theorem(title: none, id: none, body) = box-env("Theorem", title, body, hue.violet, id: id)
#let lemma(title: none, id: none, body) = box-env("Lemma", title, body, hue.violet, id: id)
#let example(title: none, body) = box-env("Example", title, body, hue.green)
#let key(body) = box-env("Key idea", none, body, hue.blue)
#let trap(body) = box-env("Watch out", none, body, hue.orange)
#let rule(body) = box-env("Rule of thumb", none, body, hue.green)
#let proof(body) = block(inset: (left: 11pt), breakable: true)[
  #emph[Proof.] #body #h(1fr) $square$
]
#let remark(body) = block(inset: (left: 11pt), breakable: true)[#emph[Remark.] #body]

/// Where a chapter is explained on the site. One line under the chapter heading:
/// #notes-line("https://.../notes/statistics/", ("Random Variables", "random-variables"), ...)
#let notes-line(base, ..notes) = block(above: 0pt, below: 0.9em)[
  #set text(size: 9pt, fill: muted)
  #text(weight: "bold", fill: hue.blue)[In the notes:]
  #notes.pos().map(n => link(base + n.at(1) + "/", n.at(0))).join(" · ")
]

/// Quick-reference table for the end of a chapter or the whole document.
/// #formulas(("Name", $formula$, "when it holds"), ...) with a header row.
#let formulas(header, ..rows) = {
  set text(size: 9.5pt)
  table(
    columns: (auto, 1fr, 1fr),
    inset: (x: 8pt, y: 5pt),
    stroke: (x, y) => (bottom: if y == 0 { 1.2pt + hue.blue } else { 0.4pt + rule-colour }),
    fill: (x, y) => if y == 0 { hue.blue.lighten(92%) },
    align: (left, left, left),
    table.header(..header.map(h => text(weight: "bold", fill: hue.blue, size: 8.5pt, upper(h)))),
    ..rows.pos().flatten(),
  )
}

/// A figure from tools/figures (print SVG). The path is from the compile root, assets/notes:
/// #fig("/statistics/figures/clt.svg", caption: [...]).
#let fig(path, caption: none, width: 88%) = figure(
  image(path, width: width),
  caption: caption,
)
