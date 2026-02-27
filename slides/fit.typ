// ÚFAL Polylux Theme
// Inspired by the ÚFAL Marp theme and Touying theme
// Built with Polylux framework

#import "@preview/prequery:0.2.0"
#import "@preview/polylux:0.4.0": *
#import "@preview/polylux:0.4.0": slide as polylux-slide
#import "@preview/prequery:0.2.0": image as prequery-image


// ===== COLORS =====
#let primary-color = rgb("#0071BB")
#let secondary-color = rgb("#e7e6e6")
#let text-color = rgb("#252525")
#let muted-color = rgb("#888888")

// ===== FONTS =====
#let font-sans = ("Fira Sans", "Liberation Sans", "Arial")
#let font-mono = ("Consolas", "Liberation Mono")

// ===== LOGOS =====
#let fit-logo = image("img/fit-white.svg", width: 3.2cm)
#let fit-logo-title = image("img/fit-white.svg", width: 4.5cm)

// ===== SHARED COMPONENTS =====

/// Creates a sections band showing all sections with current section highlighted
/// Returns empty content if no sections are registered
#let sections-band = toolbox.all-sections((sections, current) => {
  if sections.len() == 0 {
    []
  } else {
    // Neutralize all link styling within the sections band
    show link: it => it.body
    set text(size: 10pt, font: font-sans)
    sections
      .map(s => if s == current {
        text(fill: rgb("#3e3e3e"), weight: "regular")[#s]
      } else {
        text(fill: muted-color, weight: "regular")[#s]
      })
      .join(text(fill: muted-color)[ #h(5pt) • #h(5pt) ])
  }
})

/// Creates an animated outline of all registered sections
/// Each section appears as a numbered box with orange styling
/// Returns empty content if no sections are registered
#let outline = toolbox.all-sections((sections, current) => {
  if sections.len() == 0 {
    []
  } else {
    show link: it => it.body
    stack(
      dir: ttb,
      spacing: 0.8em,
      ..sections
        .enumerate()
        .map(((i, section)) => {
          block(
            width: 100%,
            // inset: (left: 1.2em, right: 0.8em, top: 0.8em, bottom: 0.8em),
            // radius: 4pt,
            // fill: secondary-color,
            // stroke: (left: (paint: primary-color, thickness: 6pt)),
          )[
            #stack(
              dir: ltr,
              spacing: 0.5em,
              text(
                size: 1.1em,
                // weight: "semibold",
                fill: text-color,
                font: font-sans,
              )[#(i + 1).],
              text(
                size: 1.1em,
                // weight: "semibold",
                fill: text-color,
                font: font-sans,
              )[#section],
            )
          ]
        }),
    )
  }
})

/// Creates the header bar with title and logo
/// Default settings are optimized for title slides
#let fit-header-bar(
  title-text: none,
  title-size: 25pt,
  left-padding: 1.3cm,
  top-padding: 0.25cm,
  width: 100%,
  dx: 23cm,
) = {
  place(
    top + left,
    dx: dx,
    rect(
      width: width,
      height: 2.0cm,
      fill: primary-color,
      stroke: none,
    )[
      #pad(
        left: 0.3cm,
        align(left + horizon)[
          #if title-text != none [
            #text(
              fill: white,
              size: title-size,
              weight: "bold",
              font: font-sans,
            )[#title-text]
          ]
        ],
      )
    ],
  )
}

// ===== THEME SETUP =====
#let fit-theme(
  footer-content: "ÚFAL slides template",
  body,
) = {
  // Basic text styling
  set text(
    font: font-sans,
    size: 20pt,
    fill: text-color,
  )

  set par(
    leading: 1em,
    justify: false,
  )

  // Heading styles
  set heading(numbering: none)

  // Hide level-1 headings as they are used for slide titles
  show heading.where(level: 1): none

  show heading.where(level: 2): it => {
    v(0.4em)
    set text(
      size: 1.3em,
      weight: "bold",
    )
    it
    v(0.3em)
  }

  show heading.where(level: 3): it => {
    v(0.3em)
    set text(
      size: 1.2em,
      weight: "bold",
    )
    it
    v(0.2em)
  }

  show heading.where(level: 4): it => {
    v(0.3em)
    set text(
      size: 1em,
      weight: "bold",
    )
    it
    v(0.1em)
  }

  // Inline code: 1.3em makes Consolas approximately the same size as Fira Sans
  show raw.where(block: false): set text(
    font: font-mono,
    size: 1.3em,
    fill: text-color,
  )

  // Block code: 1em for better readability in code blocks
  show raw.where(block: true): set text(
    font: font-mono,
    size: 1em,
    fill: text-color,
  )

  // Use custom tmTheme for syntax highlighting
  set raw(
    theme: "fit-syntax.tmTheme",
  )

  show raw.where(block: true): block.with(
    fill: rgb("#eeeeee"),
    inset: 0.5em,
    radius: 3pt,
    width: 100%,
  )

  // Link styling
  show link: it => {
    set text(fill: primary-color)
    underline(it, stroke: 2pt, offset: 0.2em)
  }

  show hide: it => {
    set list(marker: none)
    set enum(numbering: n => none)

    it
  }

  show quote: it => {
    block(
      width: 100%,
      inset: (left: 1.0em, right: 0.8em, top: 0.5em, bottom: 1.1em),
      radius: 0pt,
      stroke: (left: (paint: rgb("#686868"), thickness: 6pt)),
    )[
      #set text(size: 0.9em, fill: rgb("#3c3c3c"), style: "italic")
      #it.body
      #v(-1em)
      // Show attribution if present
      #if it.attribution != none [
        #align(right)[
          #text(size: 0.8em, style: "italic", fill: muted-color)[
            — #it.attribution
          ]
        ]
      ]
    ]
  }

  // Enhanced list spacing
  show list: it => {
    it
    v(0.2em) // Additional space after each list
  }

  // Custom bullets
  set list(marker: (text(size: 1em)[●], text(size: 1em)[○], text(size: 0.7em)[□]))

  // Table styling
  show table: set text(size: 1em)
  show table: set table(inset: 0.5em)

  // Page setup with header and footer
  set page(
    paper: "presentation-16-9",
    margin: (top: 3.0cm, bottom: 1.3cm, left: 1.2cm, right: 1.2cm),
    header: [
      #set align(left + top)
      #toolbox.next-heading(h => fit-header-bar(
        title-text: h,
        title-size: 25pt,
        left-padding: 0.1cm,
        top-padding: 0.5cm,
        width: 100% + 2.4cm,
        dx: -1.2cm,
      ))
    ],
    footer: [
      #set align(left + bottom)

      // Only show footer if content is provided and not empty
      #if footer-content != none and footer-content != "" [
        #context [
          #let footer-text = text(
            fill: primary-color,
            size: 12pt,
            weight: "bold",
            font: font-sans,
          )[#footer-content]

          // Measure the text width and add some padding, with a minimum width
          #let text-width = measure(footer-text).width
          #let footer-width = calc.max(text-width + 0.8cm, 7cm)


          #place(
            bottom + left,
            dx: -1.2cm,
            dy: 0cm,

            rect(
              width: 100%,
              height: 1.0cm,
              fill: white,
              stroke: none,
            )[
              #align(left + horizon)[
                #pad(left: 0.3cm)[
                  #footer-text
                ]
              ]
            ],
          )
        ]
      ]

      // Sections band (left-aligned with footer bar)
      #if footer-content != none and footer-content != "" [
        #context [
          #let footer-text = text(
            fill: rgb("#ffffff"),
            size: 12pt,
            weight: "bold",
            font: font-sans,
          )[#footer-content]

          // Calculate footer width to position sections band
          #let text-width = measure(footer-text).width
          #let footer-width = calc.max(text-width + 0.8cm, 7cm)

          #place(
            bottom + left,
            dx: -1.2cm + footer-width - 2.0cm,
            dy: -0.38cm,
            sections-band,
          )
        ]
      ] else [
        // If no footer content, position at left with small padding
        #place(
          bottom + left,
          dx: 0.3cm,
          dy: -0.2cm,
          sections-band,
        )
      ]

      // Pagination
      #place(
        bottom + right,
        dx: 0.9cm,
        dy: -0.4cm,
        text(
          fill: text-color,
          size: 11pt,
          font: font-sans,
        )[#toolbox.slide-number/#toolbox.last-slide-number],
      )
    ],
  )

  body
}

// ===== SLIDE FUNCTIONS =====

// Override the default slide function
#let slide(body) = {
  polylux-slide[
    #body
  ]
}

// Title slide
#let title-slide(
  title: none,
  name: none,
  subtitle: none,
  author: none,
  date: none,
  license-type: none,
  langtech: false,
  body,
) = slide[
  #set page(header: none, footer: none, margin: 0cm)

  #rect(fill: primary-color, width: 100%, height: 2.5cm)
  #v(-2cm)
  // Main content - use columns if body content is provided
  #align(center + horizon)[

    // Original single-column layout when no body content
    #if name != none [
      #text(
        size: 40pt,
        weight: "bold",
        fill: primary-color,
      )[#name]
      #v(-0.5cm)
    ]

    #if subtitle != none [
      #text(size: 25pt)[#subtitle]
      #v(0.5cm)
    ]


    #if author != none [
      #v(1cm)
      #text(size: 22pt, weight: "semibold")[#author]
    ]

    #if date != none [
      #rect(
        fill: secondary-color,
        inset: (x: 0.5em, y: 0.5em),
        radius: 0.5em,
      )[
        #stack(
          dir: ltr,
          spacing: 0.5em,
          image("img/calendar.svg", height: 0.7em),
          text(size: 18pt)[#date],
        )
      ]
    ]
  ]

  // Footer with logos
  #place(
    top,
    rect(
      width: 100%,
      height: 2.2cm,
      fill: none,
      stroke: none,
    )[
      #place(
        left + horizon,
        dx: 0.25cm,
        dy: 0.1cm,
        stack(
          dir: ltr,
          fit-logo-title,
        ),
      )
      #place(
        right + horizon,
        dx: -0.25cm,
        stack(
          dir: ttb,
          spacing: 0.2cm,

          // align(center)[#cc-by-sa-logo],
          // align(center)[
          //   #text(size: 9pt)[unless otherwise stated]
          // ],
        ),
      )


    ],
  )
]

// Summary slide
#let summary-slide(
  title: none,
  subtitle: none,
  link: none,
  body,
) = slide[
  #set page(header: none, footer: none, margin: 0cm)

  // Decorative mesh background
  #rect(fill: primary-color, width: 100%, height: 2.5cm)
  // #place(top + center, image("img/mesh_nn.svg", width: 100%))
  // #place(top + center, , width: 100%))
  #v(-2cm)
  // Main content - use columns if body content is provided
  #align(center + horizon)[
    // Original single-column layout when no body content
    #if title != none [
      #text(
        size: 40pt,
        weight: "bold",
        fill: primary-color,
      )[#title]
      #v(-0.5cm)
    ]

    // #if subtitle != none [
    //   #text(size: 25pt)[#subtitle]
    //   #v(0.5cm)
    // ]
    #body

    #if link != none [
      #v(0.5cm)
      #text(size: 18pt, font: font-mono)[#link]
    ]
  ]
]

// Part slide (section divider)
#let section-slide(section: none, body) = slide[
  #set page(header: none, footer: none, margin: 0pt, fill: primary-color)
  #set align(center + horizon)

  #if section != none [
    #toolbox.register-section[#section]
  ]

  #place(left + horizon, dx: 2cm)[
    #block(width: 100% - 4cm)[
      #align(left + horizon)[
        #text(
          fill: rgb("#ffffff"),
          size: 45pt,
          weight: "bold",
          font: font-sans,
        )[#body]
      ]
    ]
  ]
]

// Blank slide (no header, no footer, custom margin)
#let blank-slide(body) = slide[
  #set page(header: none, footer: none, margin: 1.2cm)
  #body
]


// ===== HELPER FUNCTIONS =====

// You need `prequery` (https://typst-community.github.io/prequery/introduction.html) to be able to use this
#let iconify(prefix, name, ..args) = {
  let url = "https://api.iconify.design/" + prefix + "/" + name + ".svg"
  let local-path = "icons/" + prefix + "-" + name + ".svg"

  // prequery.image(url, local_path)
  box(prequery-image(url, local-path, height: 1em, ..args), baseline: 20%)
}

#let bordered-box(img, padding: 0pt) = {
  block(
    stroke: 1pt + rgb("#828282"),
    inset: padding,
    radius: 0pt,
  )[
    #img
  ]
}
#let inline-image(path) = box(image(path, height: 01em), baseline: 10%, inset: (right: 0.2em))

// Info box with customizable heading and content
#let infobox(..args) = {
  let pos = args.pos()
  let named = args.named()
  let title = if "title" in named {
    named.title
  } else if pos.len() > 1 {
    pos.at(0)
  } else {
    "Info"
  }
  let body = pos.last()
  let icon = named.at("icon", default: none)

  let title-text = if icon != none { [#icon #h(0.1em) #title] } else { title }
  block(
    width: 100%,
    inset: (left: 1.2em, right: 0.8em, top: 0.8em, bottom: 0.8em),
    radius: 4pt,
    fill: primary-color.lighten(95%),
    stroke: (left: (paint: primary-color, thickness: 6pt)),
  )[
    #if title != none [
      #set par(leading: 0.65em)
      #text(weight: "bold", fill: primary-color)[#title-text]
      #v(-0.1em)
    ]
    #body
  ]
}

#let warnbox(title: none, body) = {
  let title-text = [⚠ #h(0.1em) #title]
  block(
    width: 100%,
    inset: (left: 1.2em, right: 0.8em, top: 0.8em, bottom: 0.8em),
    radius: 4pt,
    fill: rgb("#dab307").lighten(90%),
    stroke: (left: (paint: rgb("#dab307"), thickness: 6pt)),
  )[
    #if title != none [
      #text(weight: "bold", fill: rgb("#dab307"))[#title-text]
      #v(-0.1em)
    ]
    #body
  ]
}

#let questionbox(..args) = {
  let pos = args.pos()
  let named = args.named()
  let title = if "title" in named {
    named.title
  } else if pos.len() > 1 {
    pos.at(0)
  } else {
    "Question"
  }
  let body = pos.last()
  block(
    width: 100%,
    inset: (left: 1.2em, right: 0.8em, top: 0.8em, bottom: 0.8em),
    radius: 4pt,
    fill: rgb("#511299").lighten(90%),
    stroke: (left: (paint: rgb("#511299"), thickness: 6pt)),
  )[
    #text(weight: "bold", fill: rgb("#511299"))[#title]
    #v(-0.1em)
    #body
  ]
}

#let ideabox(..args) = {
  let pos = args.pos()
  let named = args.named()
  let title = if "title" in named {
    named.title
  } else if pos.len() > 1 {
    pos.at(0)
  } else {
    "Idea"
  }
  let body = pos.last()
  block(
    width: 100%,
    inset: (left: 1.2em, right: 0.8em, top: 0.8em, bottom: 0.8em),
    radius: 4pt,
    fill: rgb("#7a9912").lighten(90%),
    stroke: (left: (paint: rgb("#7a9912"), thickness: 6pt)),
  )[
    #text(weight: "bold", fill: rgb("#7a9912"))[#title]
    #v(-0.1em)
    #body
  ]
}

// Vertically center content using flexible spacing
#let halign(body) = {
  v(1fr)
  body
  v(1fr)
}

// Source link - small, right-aligned link for referencing sources
#let source(url, title: none) = {
  let link-text = if title != none { "source: " + title } else { "source: " + url }

  align(
    right,
    text(
      size: 12pt,
      fill: muted-color,
      font: font-sans,
    )[
      #link(url)[#link-text]
    ],
  )
}

// Source slide - positions source link in top-right corner of slide
#let source-slide(url, title: none) = {
  let link-text = if title != none { "source: " + title } else { "source: " + url }

  place(
    top + right,
    dx: 0.3cm,
    dy: -2.2cm,
    text(
      size: 12pt,
      font: font-sans,
    )[
      #link(url)[#text(fill: rgb("#ffffff"))[#link-text]]
    ],
  )
}

// Todo box - styled placeholder for unfinished content
#let todo(content) = {
  block(
    width: 100%,
    inset: (left: 1.2em, right: 0.8em, top: 0.8em, bottom: 0.8em),
    radius: 4pt,
    fill: secondary-color,
    stroke: (left: (paint: primary-color, thickness: 6pt)),
  )[
    #text(weight: "bold", fill: primary-color)[TODO]
    #v(-0.1em)
    #text(fill: text-color)[#content]
  ]
}
