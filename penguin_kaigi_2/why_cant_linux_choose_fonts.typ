#import "@preview/touying:0.7.4": *
// #import themes.simple: *
#import "paper-theme.typ": *

#show: paper-theme.with(aspect-ratio: "16-9")

#set quote(block: true)

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
    - 各コードポイントに対応する文字がある
    - 基本的にはこれを記述したり読み出したりする
  ],
)

=
