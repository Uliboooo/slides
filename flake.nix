{
  description = "Typst development environment";

  inputs = {
    # nixos-unstable は現在 aarch64-darwin で appstream のビルドが壊れている
    # (zathura が appstream に依存するため巻き込まれる)。
    # https://github.com/NixOS/nixpkgs/issues/514566
    # 直っていることを確認できるまでは動作確認済みのコミットに固定する。
    nixpkgs.url = "github:NixOS/nixpkgs/46336d4d6980ae6f136b45c8507b17787eb186a0";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            typst
            tinymist
            typstyle

            imagemagick
            # pdf viewer
            zathura
            pdfpc
            # PDF CLI tool(e.g. merge)
            pdfcpu

            presenterm
          ];
          shellHook = ''
            unset SOURCE_DATE_EPOCH
          '';
        };
      });
    };
}
