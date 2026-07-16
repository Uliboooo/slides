// Uncoated Paper — a Touying theme
//
// PaperDesign.md の規約をスライドに移したテーマ。
//
//   - 紙面は透けない (不透明な paper / paper-light だけを使う)
//   - 角丸は使わない (radius: 0pt)
//   - 影・blur は使わない
//   - 黒ベタは使わない (濃い色は文字色の ink まで)
//   - active / focus は rose、warning は本当に警告の時だけ
//   - 階層は塗りではなく余白と細い罫線で分ける
//
// 使い方:
//
//   #import "@preview/touying:0.7.4": *
//   #import "paper-theme.typ": *
//
//   #show: paper-theme.with(aspect-ratio: "16-9")
//
//   #title-slide()
//   = 見出し           // 1枚のスライドになる (header に見出しが出る)
//   本文
//
// `=` は section divider ではなく通常のスライドになります。区切りが欲しい時は
// `#section-slide[...]` を明示的に呼ぶか、
// `config-common(new-section-slide-fn: section-slide)` を渡してください。

#import "@preview/touying:0.7.4": *

// ── Palette ──────────────────────────────────────────────────────────
// PaperDesign.md の Palette と 1:1 対応。透明度付きカラーは使いません。

/// bar / control center の基本紙面。スライドの地。
#let paper = rgb("#f1eee5")
/// notification / tooltip / inner surface。カードやコードブロックの面。
#let paper-light = rgb("#fbf9f2")
/// main text
#let ink = rgb("#2d302b")
/// secondary text / inactive text
#let ink-muted = rgb("#77766d")
/// main border
#let rule = rgb("#b7b0a2")
/// module separator / low-priority border
#let rule-soft = rgb("#d0c9bb")
/// active / focus / selected
#let rose = rgb("#d38ca0")
/// hover / soft selected background
#let rose-wash = rgb("#ead2d9")
/// critical / urgent。本当に警告の時だけ。
#let warning = rgb("#a84435")

// touying の self.colors への割り当て:
//
//   neutral-lightest → paper-light   neutral-lighter  → paper
//   neutral-light    → rule-soft     neutral          → rule
//   neutral-dark     → ink-muted     neutral-darkest  → ink
//   primary          → rose          primary-light    → rose-wash
//   secondary        → warning
#let _colors = config-colors(
  neutral-lightest: paper-light,
  neutral-lighter: paper,
  neutral-light: rule-soft,
  neutral: rule,
  neutral-dark: ink-muted,
  neutral-darker: ink-muted,
  neutral-darkest: ink,
  primary: rose,
  primary-light: rose-wash,
  secondary: warning,
)

// ── Helpers ──────────────────────────────────────────────────────────

/// active / focus 相当の強調。`#alert[..]` と同じ rose。
///
/// -> content
#let accent(body) = text(fill: rose, weight: "bold", body)

/// 本当に警告の時だけ使う強調。
///
/// -> content
#let warn(body) = text(fill: warning, weight: "bold", body)

/// 補足・弱い情報。
///
/// -> content
#let muted(body) = text(fill: ink-muted, body)

/// 紙面上のカード。paper-light の不透明面 + 細い罫線。角丸も影もなし。
///
/// - title (content, none): カード見出し。罫線で本文と区切ります。
/// - accent (bool): 左に rose の罫線を引いて「選択されている」ことを示します。
/// - width (relative): 幅。
///
/// -> content
#let card(title: none, accent: false, width: 100%, body) = block(
  width: width,
  fill: paper-light,
  radius: 0pt,
  stroke: if accent {
    (rest: 1pt + rule-soft, left: 3pt + rose)
  } else {
    1pt + rule
  },
  inset: (x: .9em, y: .8em),
  {
    if title != none {
      block(
        width: 100%,
        below: .6em,
        inset: (bottom: .4em),
        stroke: (bottom: 1pt + rule-soft),
        text(weight: "bold", fill: ink, title),
      )
    }
    body
  },
)

/// module separator 相当の細い横罫線。
///
/// -> content
#let hrule(stroke: 1pt + rule-soft) = line(length: 100%, stroke: stroke)

// ── Slides ───────────────────────────────────────────────────────────

/// 通常のスライド。header に現在の level 1 見出しを出し、下端に `rule` の
/// 1pt 罫線を 1 本だけ引きます (Waybar の「細い紙の帯」と同じ扱い)。
///
/// 一番最初の `= foo` だけは表紙として扱い、header / footer を外して
/// 上下左右 centering します (`cover-first-slide: false` で無効)。
///
/// - title (content, auto): header に出すタイトル。`auto` で現在の見出し。
/// - config (dictionary): `config-xxx` で渡すスライド設定。
/// - repeat (int, auto): subslide 数。
/// - setting (function): このスライドに掛ける set/show rule。
/// - composer (function, array): レイアウト。`#slide(composer: (1fr, 2fr))[A][B]` など。
/// - bodies (array): スライドの中身。
#let slide(
  title: auto,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  // ── 表紙 ──────────────────────────────────────────────────────────
  // 最初の `= foo` は紙の中央に置く。罫線も header も引かない。
  // `title` が明示されているものは見出し由来ではない (outline-slide など) ので
  // 表紙にしない。
  if (
    self.at("is-first-slide", default: false)
      and self.store.at("cover-first-slide", default: false)
      and title == auto
  ) {
    let cover-self = utils.merge-dicts(
      self,
      config-common(freeze-slide-counter: true),
      config-page(
        fill: self.colors.neutral-lighter,
        header: none,
        footer: none,
        margin: 3em,
      ),
    )
    let cover-body = bodies.pos().sum(default: none)
    return touying-slide(
      self: cover-self,
      config: config,
      repeat: repeat,
      setting: setting,
      std.align(center + horizon, {
        block(
          below: .8em,
          text(
            size: 1.7em,
            weight: "bold",
            fill: self.colors.neutral-darkest,
            utils.display-current-heading(level: 1, depth: self.slide-level),
          ),
        )
        if cover-body != none {
          block(text(fill: self.colors.neutral-dark, cover-body))
        }
      }),
    )
  }

  let header(self) = {
    set std.align(bottom)
    block(
      width: 100%,
      spacing: 0pt,
      inset: (bottom: .38em),
      // 紙の帯: 下端だけ罫線
      stroke: (bottom: 1pt + self.colors.neutral),
      {
        set std.align(horizon)
        set text(fill: self.colors.neutral-darkest, weight: "bold", size: 1.05em)
        components.left-and-right(
          if title != auto {
            utils.fit-to-width(grow: false, 100%, title)
          } else {
            utils.call-or-display(self, self.store.header)
          },
          text(
            size: .72em,
            weight: "regular",
            fill: self.colors.neutral-dark,
            utils.call-or-display(self, self.store.header-right),
          ),
        )
      },
    )
  }
  let footer(self) = {
    // bottom 寄せにすると footer 領域の下端 = 紙の端に貼り付いて見切れる。
    // top 寄せにして、本文のすぐ下に置く。
    set std.align(top)
    set text(size: .55em, fill: self.colors.neutral-dark)
    components.left-and-right(
      utils.call-or-display(self, self.store.footer),
      utils.call-or-display(self, self.store.footer-right),
    )
  }
  let self = utils.merge-dicts(
    self,
    config-page(
      fill: self.colors.neutral-lighter,
      header: header,
      footer: footer,
    ),
    config-common(subslide-preamble: self.store.subslide-preamble),
  )
  // 罫線と本文の間の空き。block で包むと本文側の `#align(horizon)` が
  // 効かなくなるので、spacing を 1 つ置くだけにする。
  let new-setting = body => {
    v(self.store.content-gap)
    show: setting
    body
  }
  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: new-setting,
    composer: composer,
    ..bodies,
  )
})

/// header / footer を持たない、中身だけのスライド。
///
/// - config (dictionary): スライド設定。
#let bare-slide(config: (:), ..args) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(fill: self.colors.neutral-lighter),
  )
  touying-slide(self: self, config: config, ..args)
})

/// タイトルスライド。情報は `config-info` で渡します。
///
/// - config (dictionary): スライド設定。
/// - extra (content, none): 追加情報。
#let title-slide(config: (:), extra: none, ..args) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(fill: self.colors.neutral-lighter, margin: (x: 3em, y: 3em)),
  )
  let info = self.info + args.named()
  let body = {
    set std.align(horizon)
    block(width: 100%, {
      if info.logo != none {
        block(below: 1em, text(1.4em, utils.call-or-display(self, info.logo)))
      }
      block(
        below: if info.subtitle != none { .5em } else { .9em },
        text(size: 1.6em, weight: "bold", fill: ink, info.title),
      )
      if info.subtitle != none {
        block(below: .9em, text(size: .95em, fill: ink-muted, info.subtitle))
      }
      hrule(stroke: 1pt + rule)
      v(.4em)
      set text(size: .78em, fill: ink-muted)
      if info.author != none {
        block(spacing: .7em, text(fill: ink, info.author))
      }
      if info.institution != none { block(spacing: .7em, info.institution) }
      if info.date != none { block(spacing: .7em, utils.display-info-date(self)) }
      if info.contact != none { block(spacing: .7em, info.contact) }
      if extra != none { block(spacing: .7em, extra) }
    })
  }
  touying-slide(self: self, config: config, body)
})

/// 章の区切り。`config-common(new-section-slide-fn: section-slide)` に渡せます。
///
/// - config (dictionary): スライド設定。
/// - level (int): 見出しレベル。
/// - numbered (bool): 見出し番号を出すか。
/// - body (content): 補足。
#let section-slide(config: (:), level: 1, numbered: true, body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(fill: self.colors.neutral-lighter, margin: (x: 3em, y: 3em)),
  )
  let slide-body = {
    set std.align(horizon)
    block(width: 100%, {
      block(
        below: .6em,
        text(
          size: 1.5em,
          weight: "bold",
          fill: ink,
          utils.display-current-heading(level: level, numbered: numbered, style: auto),
        ),
      )
      hrule(stroke: 1pt + rule)
      if body != none {
        block(above: .8em, text(size: .8em, fill: ink-muted, body))
      }
    })
  }
  touying-slide(self: self, config: config, slide-body)
})

/// 1点だけ見せるスライド。黒ベタの代わりに rose-wash の紙面を使います。
///
/// - config (dictionary): スライド設定。
/// - align (alignment): 配置。
#let focus-slide(config: (:), align: horizon + center, body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(fill: self.colors.primary-light, margin: 2.5em),
  )
  set text(fill: ink, size: 1.5em, weight: "bold")
  touying-slide(self: self, config: config, std.align(align, body))
})

/// 目次スライド。level 1 は `ink`、level 2 以下は `ink-muted` で読ませます。
///
/// - config (dictionary): スライド設定。
/// - title (content): header に出すタイトル。
/// - level (int, auto): 表示する見出しの深さ。
/// - numbered (bool): 番号を振るか。見出しに numbering がある時だけ有効です。
/// - highlight-current (bool): 現在の章を rose で示すか。章ごとに目次を挟む
///   構成でだけ意味があります。章の外に置いた目次では全項目が現在扱いになるので
///   既定は `false` です。
/// - columns (int, auto): 段組み。`auto` で自動。
#let outline-slide(
  config: (:),
  title: [目次],
  level: auto,
  numbered: false,
  highlight-current: false,
  columns: auto,
  ..args,
) = slide(title: title, config: config, self => {
  set text(size: .85em)
  let entries = components.custom-progressive-outline(
    self: self,
    // 透明度は使わない。階層は文字色と太字で分ける。
    alpha: 100%,
    level: if level != auto { level } else { self.slide-level },
    numbered: (numbered,),
    numbering: ("1.",),
    filled: (false,),
    paged: (false,),
    indent: (0em, 1.2em),
    vspace: (.8em, .3em),
    text-style: (
      (fill: ink, weight: "bold"),
      (fill: ink-muted, weight: "regular"),
    ),
    style-current: if highlight-current { ((fill: rose, weight: "bold"),) },
    ..args,
  )
  if columns == auto {
    components.adaptive-columns(entries)
  } else if columns <= 1 {
    entries
  } else {
    std.columns(columns, entries)
  }
})

// ── Theme ────────────────────────────────────────────────────────────

/// Uncoated Paper theme.
///
/// - aspect-ratio (str): 縦横比。既定は `"16-9"`。
/// - font (array, str): 本文フォント。
/// - font-mono (array, str): 等幅フォント。
/// - size (length): 本文サイズ。既定は `24pt`。
/// - code-theme (str, none): syntax highlighting のテーマ。既定は palette に
///   揃えた `paper-code.tmTheme`。`none` で typst の既定テーマに戻します。
/// - strong-alert (bool): `*強調*` を rose にするか (touying の既定動作)。
///   `false` にすると強調は太字のままで、rose は `#alert[..]` だけに残ります。
///   紙面の色数を絞りたい時はこちら。
/// - content-gap (length): header の罫線と本文の間の空き。
/// - cover-first-slide (bool): 一番最初の `= foo` を表紙 (中央寄せ・header /
///   footer なし) にするか。`false` で普通のスライドになります。
/// - header (content, function): header 左。既定は現在の level 1 見出し。
/// - header-right (content, function): header 右。既定は `self.info.logo`。
/// - footer (content, function): footer 左。既定は `none`。
/// - footer-right (content, function): footer 右。既定はページ番号。
/// - subslide-preamble (content, function): level 2 見出しの表示。
#let paper-theme(
  aspect-ratio: "16-9",
  font: ("TeX Gyre Heros", "Harano Aji Gothic"),
  font-mono: ("JetBrainsMono NF", "Harano Aji Gothic"),
  size: 24pt,
  code-theme: "paper-code.tmTheme",
  strong-alert: true,
  content-gap: .5em,
  cover-first-slide: true,
  header: self => utils.display-current-heading(
    setting: utils.fit-to-width.with(grow: false, 100%),
    level: 1,
    depth: self.slide-level,
  ),
  header-right: self => self.info.logo,
  footer: none,
  footer-right: context utils.slide-counter.display() + " / " + utils.last-slide-number,
  subslide-preamble: context {
    // level 2 見出しが無い時は何も出さない。
    // 無条件に v() や block() を置くと、見出しが空でも spacing だけが残り、
    // `=` だけのスライドで header と本文が離れる。
    if utils.current-heading(level: 2) != none {
      block(
        above: .5em,
        below: 1em,
        text(1.05em, weight: "bold", fill: ink, utils.display-current-heading(level: 2)),
      )
    }
  },
  ..args,
  body,
) = {
  show: touying-slides.with(
    config-page(
      ..utils.page-args-from-aspect-ratio(aspect-ratio),
      fill: paper,
      margin: (top: 2.25em, bottom: 1.5em, x: 2.1em),
      // ascent を小さくすると header は下がる = 罫線と本文の間が詰まり、
      // 逆に title の上 (紙の端) に余白が戻る。
      header-ascent: 14%,
      // descent を小さくして、ページ番号を紙の下端から離す。
      footer-descent: 20%,
    ),
    config-common(
      // `=` を区切りスライドにせず、中身のあるスライドにする。
      // 区切りが欲しい時は `new-section-slide-fn: section-slide` を渡す。
      slide-fn: slide,
      new-section-slide-fn: none,
      // header / footer を本文と同じ左右マージンに揃える。
      zero-margin-header: false,
      zero-margin-footer: false,
      // `*強調*` を rose にするか。touying 既定は true。
      show-strong-with-alert: strong-alert,
    ),
    config-methods(
      alert: utils.alert-with-primary-color,
      init: (self: none, body) => {
        set text(font: font, size: size, fill: ink, lang: "ja")
        // 余白で読ませる。行間は CJK 込みで少し広めに。
        set par(leading: .75em, spacing: 1em, justify: false)
        set block(radius: 0pt)
        set list(indent: .35em, spacing: .8em, marker: (
          text(fill: ink-muted, [▪]),
          text(fill: ink-muted, [–]),
          text(fill: ink-muted, [·]),
        ))
        set enum(indent: .35em, spacing: .9em)

        show heading: set text(fill: ink)
        show heading.where(level: 1): set text(size: 1.4em)

        // rose にするのは外部リンクだけ。目次や相互参照の内部リンクは
        // 地の文字色のままにして、色数を増やさない。
        show link: it => if type(it.dest) == str {
          text(fill: rose, it)
        } else {
          it
        }

        // code: 影も角丸もなし。paper-light の面に細い罫線。
        // theme のパスは paper-theme.typ からの相対で解決されます。
        set raw(theme: code-theme) if code-theme != none
        show raw: set text(font: font-mono)
        show raw.where(block: true): it => block(
          width: 100%,
          fill: paper-light,
          radius: 0pt,
          stroke: 1pt + rule-soft,
          inset: (x: .8em, y: .7em),
          text(size: .78em, it),
        )
        show raw.where(block: false): it => box(
          fill: paper-light,
          radius: 0pt,
          stroke: .6pt + rule-soft,
          inset: (x: .3em),
          outset: (y: .22em),
          text(size: .92em, it),
        )

        // table: 塗り分けではなく罫線で読ませる。
        // 行の inset は詰めておく。ここが緩いと数行で 1 面を使い切る。
        set table(
          inset: (x: .6em, y: .25em),
          fill: (x, y) => if y == 0 { paper-light },
          stroke: (x, y) => (
            bottom: if y == 0 { 1pt + rule } else { .6pt + rule-soft },
          ),
        )
        show table.cell.where(y: 0): set text(weight: "bold")

        // quote: 引用は左の罫線だけで示す。
        show quote.where(block: true): it => block(
          width: 100%,
          inset: (left: .9em),
          stroke: (left: 2pt + rule),
          {
            text(fill: ink-muted, it.body)
            if it.attribution != none {
              v(.3em)
              std.align(right, text(size: .8em, fill: ink-muted, [— ] + it.attribution))
            }
          },
        )

        set footnote.entry(separator: line(length: 30%, stroke: .6pt + rule-soft))
        show footnote.entry: set text(size: .58em, fill: ink-muted)

        body
      },
    ),
    _colors,
    config-store(
      header: header,
      header-right: header-right,
      footer: footer,
      footer-right: footer-right,
      subslide-preamble: subslide-preamble,
      content-gap: content-gap,
      cover-first-slide: cover-first-slide,
    ),
    ..args,
  )

  body
}
