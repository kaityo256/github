# 修正TODO

`*/README.md`の確認で見つかった指摘のうち、未修正の項目をまとめる。

## Gitの説明

- [x] `internals/README.md:98` — 「指定されたハッシュ値を持つ入力を探す困難さ」を「強衝突耐性」と呼んでいるが、これは原像計算困難性である。強衝突耐性は、同じハッシュ値になる任意の異なる二入力を見つけることの困難さを指す。

- [ ] `advanced/README.md:413`、`practice_advanced/README.md:377` — リベースで衝突した際の手順が `git add` → `git commit` → `git rebase --continue` となっている。通常は、衝突を解決して `git add` した後、直接 `git rebase --continue` を実行する。`git rebase --continue` が元のコミット情報を使ってコミットを作成するため、途中の通常の `git commit` は削除する。`branch/README.md`は修正済み。参考: [Git公式のrebase手順](https://git-scm.com/docs/git-rebase)

- [x] `practice_basic/README.md:157` — `git status -s` の `??`について「ワーキングツリーにもインデックスにも無い」と説明しているが、ファイルはワーキングツリーに存在する。「ワーキングツリーには存在するが、インデックスには登録されておらず、Gitによる追跡対象でもない」などに修正する。`??` は通常のXY欄とは別扱いの特殊表示である。

- [x] `practice_basic/README.md:281` — `git commit -a` を「ステージングを飛ばしてコミットする」と説明しているが、実際には追跡済みファイルの変更と削除を自動的にステージしてからコミットする。また、新規ファイルは対象外である。「追跡済みファイルを自動的にステージしてコミットする」などに修正する。

- [x] `internals/README.md:645` — `git config remote.origin.url` の出力例が `url = ../test.git` となっているが、通常は値だけが出力される。次のように修正する。

  ```console
  $ git config remote.origin.url
  ../test.git
  ```

- [ ] `basics/README.md:180`、`internals/README.md:100`ほか — 「コミットハッシュは実際には40桁」「GitではSHA-1を用いる」という断定は、SHA-256形式のリポジトリも存在するため厳密ではない。標準的なSHA-1形式についての説明であることを明記する。SHA-1のオブジェクトIDは40桁、SHA-256では64桁となる。参考: [Git公式のハッシュ移行資料](https://git-scm.com/docs/hash-function-transition.html)

- [x] `remote/README.md:225` — `git pull` を常に `git fetch` + `git merge` と説明しているが、`pull.rebase`や`--rebase`の設定時にはfetch後にrebaseを行う。「デフォルト設定では `git fetch` と `git merge` を行う」などに修正する。

## その他

- [x] `vcs/README.md:21` — SCCSを1972年のものとして紹介した直後に「バージョン管理システムができてから三十余年」とある。2021年時点でも約49年経過しており、年代が合わないため「半世紀余り」などに修正する。

- [ ] `ssh/README.md:103` — 章末が次のメモ書きのまま終了している。本文として完成させるか、不要なら削除する。

  ```text
  - GitHubでも任意の公開鍵が見られる話
  - 知識認証と所持認証
  ```
