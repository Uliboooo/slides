#import "@preview/touying:0.7.4": *
// #import themes.simple: *
#import "paper-theme.typ": *

#show: paper-theme.with(aspect-ratio: "16-9")

#set quote(block: true)
#let glyph(x) = [「#x」]

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

= 統合漢字によってCJKの漢字を文字コードレベルで区別できない

CJK間でグリフの異なる統合漢字(#glyph()[直], #glyph()[半], etc...)を文字コードレベルで区別ができない

#pause

$arrow.r.double$ どの文字が表示されるかはフォントの優先度に依存する

#pause

#text(size: 0.8em)[
  こういう資料を作成する際に*とても*困る
]

#pause

文字ごとにフォントを当てるとか正気か?

#pause

#statement()[最も*困る*領域が_Web_]

= どこまでが同じ文字?

(あくまで私見として)

使われる地域が違えば同一の意味を持っていた文字も別の意味を持つ。

$arrow.r.curve$ 意味が異なるなら、別の*字*では?

例えば、#glyph[湯]は日本語では#glyph[お湯]という意味だが、中国語では#glyph[スープ]。
#glyph[愛人]は日本では不倫だが、中国では配偶者や恋人を表す。

= フォントが選択されるまで(Webの場合)

#import "@preview/fletcher:0.5.8": *

#let layer(fill, title, body) = rect(
  radius: 1pt,
  fill: fill,
  stroke: luma(70%),
  inset: 6pt,
)[
  #align(center)[
    #text(size: 18pt)[#strong(title)]
    #linebreak()
    #text(size: 14pt, fill: luma(30%))[#body]
  ]
]

#grid(
  columns: (300pt, 1fr),
  gutter: 1em,
  [
    #pause
    #align(center)[
      #stack(
        spacing: 6pt,
        layer(rgb("#ece8ff"), [Web ページ(CSS)], [font-family リスト + lang 属性]),
        text(size: 20pt)[$arrow.b.double$],
        layer(rgb("#ece8ff"), [Blink スタイル解決], [総称名をユーザー設定に置換]),
        text(size: 20pt)[$arrow.b.double$],
        layer(rgb("#e8fff4"), [文字ごとのマッチング], [グリフ有無をフォント毎に確認]),
        text(size: 20pt)[$arrow.b.double$],
        layer(rgb("#e8fff4"), [システムフォールバック], [文字 + lang で OS に問合せ]),
        text(size: 20pt)[$arrow.b.double$],
        layer(rgb("#fdf3e1"), [fontconfig(Linux)], [conf.d の規則で候補を並替え]),
      )
    ]
  ],
  [
    #pause
    このような手順でサイトの要求したフォントは解決される

    この間で日本語のフォントが当たらないとズレてしまう

    #text(size: 0.4em)[Blinkはブラウザのエンジン]
  ],
)

= Case 1. Webサイト側でフォントが完結している

#pause
#statement()[サイト側でフォントが配信されていて、そこにJPフォントが無い]

$arrow.r.double$ フォント解決がWebで完結してしまうため、\
基本的にユーザー側でその設定を覆すことはできない

#pause
CSSを注入したり、ブラウザの起動フラグでWebフォントを無効化

#pause
$arrow.r.double$ 正常なサイトへ影響が出てしまう

= Case 2. ローカルへフォールバックされる

#statement()[WebサイトがOS側の実体フォントを使う場合]

`font-family: "Noto Ssns JP", ...`のような名前のみの指定、\
フォント解決がOSになるため、ユーザーが手を出すことができる

Linuxでは...

`fontconfig`という設定があり、



= Case 3. Webサイト側でフォントが完結している




= 適切にフォントが解決されるとは限らない

== そもそもWebの時点でフォントが固定される

てしまうと

= フォントってなんだよ!

= 結局フォントってどうするべき?

- 個人的にはWebサイトはその表記した言語のフォントをちゃんと使うべき
- しかし任意の内容を多言語対応することもある
  - SNSとかブログサービスとか
- その場合、静的にCJKの優先度をつけることは難しい
  - 言語推定などによってフォント優先度を動的にする?
  - クライアント側の言語設定に引っ張る?
    - 非本質的な解決ですが楽

= {}.comはどうしてる?

== x.com

#grid(
  columns: (1fr, 2fr),
  gutter: 1em,
  [
    #image("./images/x_fonts_.png")
  ],
  [
    #text(size: 0.8em)[
      `Noto Sans CJK JP`になっている
    ]

    #text(size: 0.8em)[
      $arrow.r.double$ Twitterはツイートごとに`lang`属性をつけている

      各言語ごとにちゃんとしたフォントが使われる
    ]
  ]
)

== claude.ai

#grid(
  columns: (1fr, 2fr),
  gutter: 1em,
  [
    #image("./images/claude_ai_fonts.png")
  ],
  [
    #text(size: 0.8em)[
      なぜか`Noto Sans CJK KR`になっている
    ]

    #text(size: 0.8em)[
    $arrow.r.double$ Claudeはこのあたりが雑でシステムフォールバックに落ち、そのあとに私のLinuxの設定も雑なのでKRに転んだ\
    ]
    #text(size: 0.6em)[という説もある]
  ]
)

= I HATE "中華フォント"

#quote(attribution: [「確率的存在文字」$dash.em$ Compute on Snails])[
  私個人としてはあまりこの表記は好きじゃない。\
  中国語の方が優先されている設定のことが多いせいで、間違いとして繁体字や簡体字などが表示されるだけで別にそれ固有の問題ではない。\
  ほんとは繁体字で表示される場所に日本の新字体が出ればそれは同型の問題なので、あまり固有名として「中華フォント」という表現は好きじゃない。
]


#grid(
  columns: (auto, auto, auto),
  gutter: 1em,
  [
    お気持ち表明でした\
    良ければどうぞ $arrow.r$
  ],
  [
    #image("./images/qr.svg", height: 2.8em)
  ],
  [
    #align(left + horizon)[
      #text(size: 0.7em)[
        #link("https://blog.uliboooo.dev/probabilistic-existence-characters")
      ]
    ]
  ]
)
