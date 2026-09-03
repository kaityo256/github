# 『ゼロから学ぶGit/GitHub 現代的なソフトウェア開発のために』 正誤表

拙著『ゼロから学ぶGit/GitHub 現代的なソフトウェア開発のために』につきまして、以下のミスや修正点が見つかっております。ご迷惑をおかけして申し訳ありません。

他に誤りや修正すべき点を見つけた方は、[GitHubのIssue](https://github.com/kaityo256/github/issues)にてご指摘いただければ幸いです。

最終更新日：2026年9月3日

## 正誤表

| ページ番号 | 誤 | 正 |
| --- | --- | --- |
| | `git log --online` | `git log --oneline` |
| | `f3'`を囲むバッククォートが二重になっている | `f3'`を一組のバッククォートで囲む |
| | Gitに慣れ、後でデバッグする時に歴史が整理されていないのが気になりはじめところで`git rebase`を使い始めると良いだろう。 | Gitに慣れ、後でデバッグする時に歴史が整理されていないのが気になりはじめたところで`git rebase`を使い始めると良いだろう。 |
| | 今、バグが入ったことが気が付いたブランチがある。 | 今、バグが入ったことに気が付いたブランチがある。 |
| | ブランチをつけて置くと良い。 | ブランチをつけておくと良い。 |
| | `cp test1.txt dir`<br>`# test1.txtをdir1/test1.txtという名前で複製する` | `cp test1.txt dir`<br>`# test1.txtをdir/test1.txtという名前で複製する` |
| | 編集内容を破棄して終了するには、コマンドモードで`w!`を入力する。 | 編集内容を破棄して終了するには、コマンドモードで`q!`を入力する。操作全体では`:q!`となる。 |
| | とりあえずコマンドモードを覚える必要ない。 | とりあえずコマンドモードを覚える必要はない。 |
| | は、記念すべき最初のコミットをしよう。 | では、記念すべき最初のコミットをしよう。 |
| | Gitが「初めて問題が起きたらコミット」を見つけたら | Gitが「初めて問題が起きたコミット」を見つけたら |
| | Git Bashので以下を実行せよ。 | Git Bashで以下を実行せよ。 |
| | 「Quick setup — if you’ve done this kind of thing before」のしたにある | 「Quick setup — if you’ve done this kind of thing before」の下にある |
| | Compare & pull requst | Compare & pull request |
| | `Your site is live at https://ユーザ名.github.io/tyrano-sample/` | `Your site is live at https://ユーザ名.github.io/tyrano_sample/` |
| | ハッシュ値から元の入力を探すことの困難さを「強衝突耐性」としている。 | これは「原像計算困難性」である。暗号学的ハッシュ関数の特徴を、固定長の出力、原像計算困難性、衝突困難性、雪崩効果の4項目に整理する。また、SHA-1は衝突困難性が破られており、GitではSHA-256への移行が進められている旨を追記する。 |
| | `git status -s`の`??`は「ワーキングツリーにもインデックスにも無い」ことを表す。 | `??`は、ファイルがワーキングツリーには存在するが、インデックスには登録されておらず、Gitによる追跡対象でもないことを表す。 |
| | `$ git config remote.origin.url`<br>`url = ../test.git` | `$ git config remote.origin.url`<br>`../test.git` |
