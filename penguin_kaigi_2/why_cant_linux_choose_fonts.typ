#import "@preview/touying:0.7.4": *
// #import themes.simple: *
#import "paper-theme.typ": *

#show: paper-theme.with(aspect-ratio: "16-9")

#set quote(block: true)
#let glyph(x) = [「#x」]

// #show: simple-theme.with(
//   aspect-ratio: "16-9",
// )

#show footnote.entry: it => {
  set text(size: 0.8em)
  it
}

#set text(
  font: ("TeX Gyre Heros", "Harano Aji Gothic"),
)

= なぜLinuxは適切な文字を選べないのか?

= 適切に選べないとは?

メジャーな問題は*漢字フォントの選択ミス*

日本語として記述された文字が繁体字などで表示される問題。

#pause

#grid(
  columns: (1fr, 2fr),
  [
    #image("fonts_prob.png")
  ],
  [
    - *半*の字の*丷*の角度が違う
    - *適*の部首が*二点しんにょう*になっている
    - etc...
  ],
)

#pause

#text(size: 16pt)[
  実際のところLinuxじゃなくても起こりうる。特にwebとか
]

= そもそも文字とは? フォントとは?

#pause

#show strong: set text(red)

- script, writing system
- 言語を書き記すための*記号*
- [A]とか[あ]とか
- 文字は*意味*と*表示*を持つ

#pause

一般的なコンピューター環境では

- 意味を*文字コード*で
- 表示を*字体(グリフ, フォント)*

で表現する#footnote()[ほんとは字形と字体とか細かい話あるけど一旦無視する]

= 文字コードとは

- コンピュータ上で文字を*識別する*ための規則、ID
- いくつかの種類がある. ASCII, ISO/IEC 8859, Unicodeなど#footnote()[2024年時点ではwebの98%がUTF-8らしい]

#pause

#grid(
  columns: (1fr, 2fr),
  [
    #table(
      columns: 2,
      [code(dec)], [char],

      [00], [null],
      [...], [],
      [65], [A],
      [...], [],
      [97], [a],
      [127], [DEL],
    )
  ],
  [
    #pause
    - 各コードポイントに対応する文字がある
    - 基本的にはこれを記述したり読み出したりする
  ],
)

= 同じ文字?

#grid(
  columns: (1fr, 2fr),
  [
    #image("./images/kesu_kanji.png", height: 3.5em)
    #pause
    #image("./images/syhoka copy.png", height: 3.5em)
  ],
  [
    #pause
    #text(size: 2em)[`U+6D88`]
    #pause
    - どちらも同じコードポイント
    #pause
    - 上は`Meiryo`フォント
    - 下は`Anthropic Sans` or `System`
    #pause
    - これらはグリフが違うだけで*同じ*文字としてUnicodeでは登録されている
    #pause
    #align(center)[
      #text(size: 2em)[*統合漢字*]
    ]
  ]
)

= CJK統合漢字

#quote()[
  ISO/IEC 10646（略称：UCS[1]）およびUnicode（）にて採用されている符号化用漢字集合およびその符号表
]

#pause

Unicodeの`U+4E00..U+9FFF`の範囲。意味的に同一であればグリフが異なる漢字も同一にしましょうという話。

#pause
統合の条件としては

#text(size: 18pt)[
  #pause
  - 意味が同一で
  #pause
  - 抽象的構造が同一で
  #pause
  - 具体的な字形が異なる
]

#pause
まあ、色々批判はあったりする。


= どこまでが同じ文字?

(あくまで私見として)

使われる地域が違えば同一の意味を持っていた文字も別の意味を持つ。

$arrow.r.curve$ 意味が異なるなら最早、別の*字*では?


例えば、#glyph[湯]は日本語では#glyph[お湯]という意味だが、中国語では#glyph[スープ]。
#glyph[愛人]は日本では不倫だが、中国では配偶者や恋人を表す。





= フォントが選択されるまで

#import "@preview/fletcher:0.5.8": *

#let layer(fill, title, body) = rect(
  radius: 6pt,
  fill: fill,
  stroke: luma(70%),
  inset: 10pt,
)[
  #align(center)[
    #strong(title)
    #linebreak()
    #body
  ]
]

#align(center)[
  #stack(
    spacing: 10pt,

    layer(rgb("#ece8ff"), [Webページ], [font-family]),

    text(size: 18pt)[↓],

    layer(rgb("#ece8ff"), [Blink], [style resolve]),

    text(size: 18pt)[↓],

    layer(rgb("#e8fff4"), [Glyph Matching], [per character]),
  )
]
