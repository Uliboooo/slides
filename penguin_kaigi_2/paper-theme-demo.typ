// paper-theme.typ の見本。`typst compile paper-theme-demo.typ` で確認できます。

#import "@preview/touying:0.7.4": *
#import "paper-theme.typ": *

#set quote(block: true)

#show: paper-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Uncoated Paper Theme],
    subtitle: [非塗工紙の UI を、そのままスライドに],
    author: [Uliboooo],
    date: datetime.today(),
  ),
)

#title-slide()

#outline-slide()

= 見出しはそのままスライドになる

本文は `ink` の文字色。行間は少し広めにして、投影しても追える濃度にしています。

- 箇条書きの marker は `ink-muted`
- #alert[alert は rose]、#warn[warn は本当に警告の時だけ]
- #muted[補足は ink-muted で一段落とす]

インラインの `code` は `paper-light` の面に細い罫線を引くだけです。

== level 2 は subslide の見出しになる

`==` を使うと header はそのままで、見出しだけが本文の上に出ます。

= 面は塗らずに罫線で分ける

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  card(title: [card])[
    #text(size: .8em)[`paper-light` の面に 1pt の `rule`。角丸も影もなし。]
  ],
  card(title: [card (accent)], accent: true)[
    #text(size: .8em)[選択されている面は左に `rose` の罫線を引きます。]
  ],
)

= 表とコードも同じ規約で

#grid(
  columns: (1fr, 1.2fr),
  column-gutter: 1.2em,
  table(
    columns: 2,
    [role], [color],
    [paper], [`#f1eee5`],
    [ink], [`#2d302b`],
    [rose], [`#d38ca0`],
  ),
  ```lua
  decoration = {
    rounding = 0,
    blur = { enabled = false },
    shadow = { enabled = false },
  }
  ```,
)

= 引用と脚注

#quote(attribution: [PaperDesign.md])[
  紙の階層は影ではなく、余白と細い罫線で分ける。
]

脚注も紙面に馴染む細さにしています#footnote[separator は `rule-soft` の短い線です]。

#focus-slide[
  黒ベタの代わりに rose-wash
]
