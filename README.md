# GitHub演習

## この講義ノートについて

これは、理工学部の三年学部生向けのGit/GitHubを用いたソフトウェア開発演習のための講義ノートである。概ね一般的な記述となっているが、一部に大学のPC室特有の記述があるので、他大の方が利用される際は注意されたい。4回の座学、4回の実習の、計8回の講義/演習で学ぶ構成となっている。

* [GitHubリポジトリ](https://github.com/kaityo256/github)
* [HTML版](https://kaityo256.github.io/github/)

## [はじめに](preface/README.md)

## 座学

### [バージョン管理とは](vcs/README.md)

* [講義スライド](https://speakerdeck.com/kaityo256/github-vcs)
* バージョン管理システムとは
* バージョン管理システムの歴史
* プログラミングができる人、できない人

### [Gitの仕組みと用語](term/README.md)

* [講義スライド](https://speakerdeck.com/kaityo256/github-term)
* プロジェクト
* リポジトリとワーキングツリー
* コミット
* インデックスとステージング
* HEADとブランチ
* マージ

### [コマンドラインの使い方](command/README.md)

* [講義スライド](https://speakerdeck.com/kaityo256/github-cli)
* シェルとコマンドライン
* Unixコマンド
* Vimの使い方

### [Gitの基本的な使い方](basics/README.md)

* [講義スライド](https://speakerdeck.com/kaityo256/github-basics)
* 初期設定
* Gitの一連の操作
* `git init`
* `git add`
* `git commit`
* `git diff`
* `git log`
* `git config`
* `.gitignore`

### [ブランチ操作](branch/README.md)

* [講義スライド](https://speakerdeck.com/kaityo256/github-branch)
* なぜブランチを分けるか
* ブランチの基本
* マージ
* リベース

### [リモートリポジトリの操作](remote/README.md)

* [講義スライド](https://speakerdeck.com/kaityo256/github-remote)
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

### GitHubの使い方

* SSH公開鍵認証
* Issueの使い方
* Projectの使い方
* GitHub Pagesの使い方
* GitHub Actionsとは
* フォークとプルリク

### [Gitの使い方(応用編)](advanced/README.md)

* [講義スライド](https://speakerdeck.com/kaityo256/github-advanced)
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

### [Gitの中身](internals/README.md)

* [講義スライド](https://speakerdeck.com/kaityo256/github-internals)
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

* [講義スライド](https://speakerdeck.com/kaityo256/github-practice-basic)
* 初期設定
* リポジトリの作成(`git init`)
* インデックスへの追加(`git add`)
* ファイルの修正
* 自動ステージング(`git commit -a`)
* 歴史の確認(`git log`)
* VSCodeからの操作
* 余談：データベース"ふっとばし"スペシャリスト

### [Gitの操作(応用編)](practice_advanced/README.md)

* [講義スライド](https://speakerdeck.com/kaityo256/github-practice-advanced)
* `git amend`によりコミットが変更されることを確認する
* `git merge`の衝突を解決する
* `git rebase`により歴史を改変する
* `git rebase`の衝突を解決する
* `git bisect`を使ってみる
* 余談：OSの系譜とドラマ

### [GitHubの操作(基本編)](practice_github_basic/README.md)

* [講義スライド](https://speakerdeck.com/kaityo256/github-practice-github-basic)
* GitHubアカウントを作成とSSH接続
* ローカルのリポジトリをGitHubに登録
* Issue管理
* Projectの利用
* プルリクエストを作ってみる
* 余談：天空の城のセキュリティ

### [GitHubの操作(応用編)](practice_github_advanced/README.md)

* [講義スライド](https://speakerdeck.com/kaityo256/github-practice-github-advanced)
* MNISTの学習済みモデルをウェブで試す
* 簡単なゲーム作成

## [おわりに](postface/README.md)

## [参考文献](references/README.md)

## ライセンス

Copyright (C) 2021-present Hiroshi Watanabe

この文章と絵(pptxファイルを含む)はクリエイティブ・コモンズ 4.0 表示 (CC-BY 4.0)で提供する。
