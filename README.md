# GitHub演習

## この講義ノートについて

これは、大学の学部生向けのGit/GitHubを用いたソフトウェア開発演習のための講義ノートになる予定である。

* [GitHubリポジトリ](https://github.com/kaityo256/github)
* [HTML版](https://kaityo256.github.io/github/)

## [はじめに](preface/README.md)

## 座学

### [バージョン管理とは](vcs/README.md)

* バージョン管理システムとは
* バージョン管理システムの歴史
* プログラミングができる人、できない人

### [Gitの仕組みと用語](term/README.md)

* プロジェクト
* リポジトリとワーキングツリー
* コミット
* インデックスとステージング
* HEADとブランチ
* マージ

### [コマンドラインの使い方](command/README.md)

* シェルとコマンドライン
* Unixコマンド
* Vimの使い方
* 余談：OSの系譜とドラマ

### [Gitの基本的な使い方](basics/README.md)

* 初期設定
* Gitの一連の操作
* `git init`
* `git add`
* `git commit`
* `git diff`
* `git log`
* `git config`
* `.gitignore`
* 余談：データベース"ふっとばし"スペシャリスト

### [ブランチ操作](branch/README.md)

* なぜブランチを分けるか
* ブランチの基本
* マージ
* リベース

### [リモートリポジトリの操作](remote/README.md)

* リモートリポジトリとは
* ベアリポジトリ
* クローン
* プッシュ
* フェッチ
* 上流ブランチとリモート追跡ブランチ
* その他知っておいた方が良いこと
    * `git remote`
    * `git pull`
    * プッシュしたブランチをリベースしない

### [Gitの使い方(応用編)](advanced/README.md)

* Gitトラブルシューティング
    * コミットメッセージを間違えた(`git commit --amend`)
    * 修正を取り消したい(`git restore`)
    * ステージングを取り消したい(`git restore --staged`)
    * `git checkout`は使わない
    * リモートを間違えて登録した(`git remote remove`)
    * メインブランチで作業を開始してしまった(`git stash`)
    * プッシュしようとしたらリジェクトされた
    * 頭が取れた(`detached HEAD`)
    * リベースしようとしたら衝突した
* その他の便利なコマンド
    * この部分はいつ誰が書いた？(`git blame`)
    * このバグが入ったのはいつだ？(`git bisect`)

### [Gitの仕組み](internals/README.md)

* `.git`ディレクトリの中身
* Gitのオブジェクト
    * blobオブジェクト
    * コミットオブジェクト
    * treeオブジェクト
* Gitの参照
    * HEADとブランチの実体
    * Detached HEAD状態
    * ブランチの作成と削除
    * リモートブランチと上流ブランチ
* インデックス
    * インデックスの実体と中身
    * ブランチ切り替えとインデックス

## 演習

### [Gitの操作(基本編)](practice_basic/README.md)

* 初期設定
* リポジトリの作成(`git init`)
* インデックスへの追加(`git add`)
* ファイルの修正
* 自動ステージング(`git add -a`)
* 歴史の確認(`git log`)
* VSCodeからの操作

### [Gitの操作(応用編)](practice_advanced/README.md)

* `git amend`によりコミットが変更されることを確認する
* `git merge`の衝突を解決する
* `git rebase`により歴史を改変する
* `git rebase`の衝突を解決する
* `git bisect`を使ってみる

### [GitHubの操作(基本編)](practice_github/README.md)

* アカウント作成
* リポジトリの作成
* コミットとプッシュ
* issueのオープンとクローズ
* Projectの使い方(Automated Kanban)
* forkとclone、GitHub Pagesの公開
* プルリクエスト

### GitHubの操作(応用編)

* 実際にウェブアプリ(ゲーム)を作ってみる

## [参考文献](references/README.md)

## ライセンス

Copyright (C) 2021-present Hiroshi Watanabe

この文章と絵(pptxファイルを含む)はクリエイティブ・コモンズ 4.0 表示 (CC-BY 4.0)で提供する。
