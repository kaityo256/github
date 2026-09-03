# 書籍版とリポジトリの対応

このリポジトリは、書籍『ゼロから学ぶGit/GitHub 現代的なソフトウェア開発のために』の元になった講義ノートである。書籍とリポジトリでは章の分け方や掲載順が異なるため、書籍に関する修正では以下の対応を参照すること。

書籍情報・目次: [Amazonの商品ページ](https://www.amazon.co.jp/dp/4065352193)

## 対応表

| 書籍版の目次 | 対応するディレクトリ | 備考 |
| --- | --- | --- |
| 第1章 バージョン管理システムとは<br>1.1 バージョン管理の必要性<br>1.2 バージョン管理システムの歴史<br>1.3 できる人、できない人<br>1.4 まとめ<br>コラム CEOからメッセージ | `vcs/`<br>`practice_github_advanced/` | 章本文は主に`vcs/`。コラムは`practice_github_advanced/README.md`の「余談：CEOからのメッセージ」に対応する。 |
| 第2章 Gitの仕組みと用語<br>2.1 リポジトリとコミット<br>2.2 ブランチとマージ<br>2.3 まとめ | `term/` | Gitの基本概念と用語に対応する。 |
| 第3章 Gitの基本的な使い方<br>3.1 初期設定<br>3.2 Gitの一連の操作<br>3.3 よく使うコマンドとファイル<br>3.4 まとめ<br>3.5 演習問題 | `basics/`<br>`practice_basic/` | 本文は`basics/`、演習は主に`practice_basic/`に対応する。 |
| 第4章 ブランチ操作<br>4.1 なぜブランチを分けるか<br>4.2 ブランチの基本<br>4.3 マージと衝突の解消<br>4.4 まとめ<br>4.5 演習問題<br>コラム 枝は切るのか生やすのか | `branch/`<br>`practice_advanced/` | `branch/README.md`のうちブランチとマージに関する部分、および`practice_advanced/README.md`のマージ演習に対応する。 |
| 第5章 リベース<br>5.1 リベースの仕組み<br>5.2 リベースとマージ<br>5.3 対話的リベース<br>5.4 リベース中の衝突<br>5.5 まとめ<br>5.6 演習問題 | `branch/`<br>`advanced/`<br>`practice_advanced/` | `branch/README.md`のリベース、`advanced/README.md`のリベース中の衝突、および`practice_advanced/README.md`のリベース演習に対応する。 |
| 第6章 Gitの便利な使い方<br>6.1 トラブルシューティング<br>6.2 便利なコマンドや知っておいた方がよいこと<br>6.3 まとめ<br>6.4 演習問題 | `advanced/`<br>`practice_advanced/` | `git commit --amend`、`git restore`、`git stash`、`git blame`、`git bisect`などに対応する。 |
| 第7章 GitHubのアカウント作成と認証<br>7.1 認証とは<br>7.2 SSH公開鍵認証<br>7.3 多要素認証<br>7.4 まとめ<br>7.5 演習問題<br>コラム 天空の城のセキュリティ | `ssh/`<br>`practice_github_basic/` | 認証の説明は`ssh/`、アカウント作成・SSH鍵登録の演習とコラムは`practice_github_basic/`に対応する。 |
| 第8章 リモートリポジトリの操作<br>8.1 リモートリポジトリ<br>8.2 リモートリポジトリに関する操作<br>8.3 上流ブランチとリモート追跡ブランチ<br>8.4 その他の知っておいたほうがよいこと<br>8.5 まとめ<br>8.6 演習問題 | `remote/`<br>`practice_github_basic/` | 本文は`remote/`、リポジトリの作成・クローン・pushの演習は`practice_github_basic/`に対応する。 |
| 第9章 GitHub Pagesへのデプロイ<br>9.1 ウェブサーバとは<br>9.2 GitHub Pagesとは<br>9.3 GitHub Pagesの種類<br>9.4 公開ディレクトリとブランチ<br>9.5 まとめ<br>9.6 演習問題 | `practice_github_advanced/` | GitHub Pagesの設定、MNISTデモ、ゲームの公開演習に対応する。 |
| 第10章 GitHubにおける多人数開発<br>10.1 課題管理システム<br>10.2 プルリクエスト<br>10.3 まとめ<br>10.4 演習問題<br>コラム データベース“ふっとばし”スペシャリスト | `practice_github_basic/`<br>`practice_basic/` | Issue、Project、プルリクエストは`practice_github_basic/`、コラムは`practice_basic/README.md`の「余談：データベース"ふっとばし"スペシャリスト」に対応する。 |
| 第11章 Gitの中身<br>11.1 `.git`の中身<br>11.2 Gitのオブジェクト<br>11.3 Gitの参照<br>11.4 インデックス<br>11.5 まとめ | `internals/` | Gitの内部構造に対応する。 |
| 付録<br>1 Gitのインストール<br>2 Visual Studio Codeのインストール<br>3 コマンドラインの使い方<br>4 Vimの使い方 | `command/`<br>`practice_basic/` | コマンドラインとVimは主に`command/`。GitとVisual Studio Codeの導入・初期設定は`practice_basic/`にも一部含まれる。インストール手順だけに対応する専用ディレクトリはない。 |

## 書籍の章と直接一対一にならないディレクトリ

| ディレクトリ | 内容 |
| --- | --- |
| `preface/` | 講義ノートの「はじめに」。 |
| `postface/` | 講義ノートの「終わりに」。 |
| `references/` | 参考文献。 |
| `errata/` | 書籍版の正誤表。 |
