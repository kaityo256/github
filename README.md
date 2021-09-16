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

* トラブルシューティング
* reset
* log
* stash
* blame
* bisect
* cherry-pick
* tag

### [Gitの仕組み](internals/README.md)

* ファイルシステムの仕組み
* SHA-1 (コミットID)
* Gitオブジェクト(objects)
    * blob
    * tree
    * commit
    * tag
* Gitの参照(refs)
* 操作の裏側で起きていること

## 演習

### [Gitの操作(基本編)](practice_basic/README.md)

* 初期設定
* リポジトリの作成(`git init`)
* インデックスへの追加(`git add`)
* ファイルの修正
* 自動ステージング(`git add -a`)
* 歴史の確認(`git log`)
* VSCodeからの操作

### [GitHubの操作](practice_github/README.md)

* アカウント作成
* リポジトリの作成
* issueのオープンとクローズ
* Projectの使い方(Automated Kanban)
* forkとclone、GitHub Pagesの公開

## 何を説明するかメモ

* 座学
    * バージョン管理とは
    * ソフトウェア開発で気を付けるべきこと
    * ライセンス
    * BTS/ITS
    * Gitの仕組みと使い方
    * Gitで管理するもの、しないもの
    * GitHubの使い方
* 演習
    * Git演習
        * 基本的な操作の確認
        * git init
        * git add, commit
        * git branch
        * git merge
        * コマンドでの動作確認とVS Codeでの確認
        * マージの確認(fast-forward, non fast-forward, conflictの対処)
        * 実戦的な使い方
        * (途中でバグが入った歴史を持つコードを使って、git logやbisectを使う)
        * git-bisect-exampleというリポジトリを作る
        * rebase の仕方
        * トラブル対応
        * mergeしたらconflictした！
            * とりあえず元に戻そう git merge --revert
        * detached HEADの対応 (rebaseで失敗したもの)
    * GitHub演習
        * issue
        * issue drivenな開発例
        * issue を切って、ブランチを作り、コミットログで自動でissueを閉じる
        * Project
        * CI
    * 複数人による開発
        * issue
        * プルリク

## [参考文献](references/README.md)

## ライセンス

Copyright (C) 2021-present Hiroshi Watanabe

この文章と絵(pptxファイルを含む)はクリエイティブ・コモンズ 4.0 表示 (CC-BY 4.0)で提供する。
