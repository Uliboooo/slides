#import "@preview/touying:0.7.4": *
#import themes.simple: *

#set quote(block: true)

#show: simple-theme.with(
  aspect-ratio: "16-9",
)

= dotfilesから見るLinuxプログラムのお行儀

== dotfilesとは

各プログラムの設定ファイルを1箇所に集めたもの

#pause

=== なぜ"dot"files?

多くの設定ファイルは`~/.config/`や`.zshrc`などのように#box[*隠しファイル*]になっている

それらを総称してdot(.)filesと呼ぶ

= 具体例

#image("ls_config.png")

= メリット

- 複数の環境で設定を共有できる
- git repositoryにすることでコンフリクト対策も
- 設定のバックアップ的な

= デメリット

- symbolic linkを貼る際に面倒なことも
  - nix home-managerやshell scriptで自動化もできる
-

= Unix哲学

#quote(attribution: ["Peter H. Salus", "McIlroy"])[
  ...
  - 普遍的なインターフェースであるテキストストリームを扱うプログラムを書く
]

拡張すれば...

=> *プレーンテキストこそがもっとも普遍なデータ*

= プレーンテキストだからこそ

dotfilesは基本的にプレーンテキスト + 明快なパスだから成り立つ

#pause

=> Excelの設定ファイル#footnote[あるのか知らんけど]はExcelからしか読めない

#pause

例としてnvimは`~/.config/nvim`以下にluaなどの#box[*プレーンテキスト*]な設定ファイルを配置することを要求する

`toml`とか`json`とか。

=


