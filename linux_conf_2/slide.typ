#import "@preview/touying:0.7.4": *
#import themes.simple: *

#set quote(block: true)

#show: simple-theme.with(
  aspect-ratio: "16-9",
)

= dotfilesから見るLinuxプログラムのお行儀

== Outline <touying:hidden>

#components.adaptive-columns(outline(title: none, indent: 1em))

== dotfilesとは

各プログラムの設定ファイルを1箇所に集めたもの

#pause

=== なぜ"dot"files?

多くの設定ファイルは`~/.config/`や`.zshrc`などのように#box[*隠しファイル*]になっている

それらを総称してdot(.)filesと呼ぶ

= 具体例

#grid(
  columns: (2fr, 1fr),
  column-gutter: 1em,

  image("ls_config.png", width: 100%),

  [
    #text(size: 22pt)[Symbolic linkがたくさん]

    #v(0.5em)

    #text(size: 16pt)[
      - 長いパスはHash値
      - nixはrebuildのたびにHashからパスを生成する
      - `~/dotfiles/.config/git/`\
        $=>$ `~/.config/git/`にlinkする
    ]
  ],
)

= メリット

- 複数の環境で設定を共有できる
- gitを使えばコンフリクト対策も
- 設定のバックアップ的な

= デメリット

- symbolic linkを貼る際に面倒なことも
  - nix home-managerやshell scriptで自動化もできる
- 盆栽が始まり環境構築に気を取られる

= Unix哲学

#quote(
  block: true,
  attribution: [
    Peter H. Salus and McIlroy
  ],
)[
  普遍的なインターフェースであるテキストストリームを扱うプログラムを書く \
  ...
]

#pause

拡張して捉えれば...

#pause

$=>$ *プレーンテキストこそがもっとも普遍なデータ*

= プレーンテキストだからこそ

dotfilesで管理できるのは基本的にプレーンテキスト\
\+ 明快なパスだから成り立つ

#pause

$=>$ Excelの設定はExcelからしか読めない

#pause

例としてnvimは`~/.config/nvim`以下にluaなどの#box[*プレーンテキスト*]な設定ファイルを配置することを要求する

#pause

他のツールでは`toml`とか`json`とかが使われます。

= XDG Base Directory

#pause

XDG Base Directory Specification#footnote[https://specifications.freedesktop.org/basedir/latest/]によって#box[*"ファイルが配置されるべき基準となるディレクトリ"*]\
が定義されている

#pause

#text(size: 18pt)[
  ユーザー個別のデータを種類によって各値が設定されている
]

#pause

#{
  set text(size: 18pt)
  table(
    stroke: none,
    columns: 3,
    align: auto,

    table.header([], align(center)[Description], align(center)[Default]),

    [`XDG_CONFIG_HOME`], [設定], [`$HOME/.config`],
    [`XDG_CACHE_HOME`], [キャッシュ], [`$HOME/.cache`],
    [`XDG_DATA_HOME`], [データ], [`$HOME/.local/share`],
    [`XDG_STATE_HOME`], [状態ファイル], [`$HOME/.local/state`],
  )
}

#pagebreak()

== dotfilesの内容は`XDG_CONFIG_HOME`へ

- Linux向けのプログラムで固有のファイルを
