# Gitの基本的な使い方

## はじめに

それではいよいよGitの操作を見ていこう。Gitは「git コマンド オプション 対象」といった形で操作する。Gitには大量のコマンドがあり、さらにそれぞれに多くのオプションがある。それらを全て覚えるのは現実的ではない。まずはよく使うコマンドとオプションだけ覚えよう。また、Gitはヘルプが充実している。「あのコマンドなんだっけ？」と思ったら、`git help`を実行しよう。また、コマンドの詳細を知りたければ`git help command`で詳細なヘルプが表示されるので、合わせて覚えておくこと。たとえば`git help help`で、`help`コマンドのヘルプを見ることができる。

Gitに限らず、使い方がわからないコマンドがあった時に、まずは公式ドキュメントやヘルプを参照する癖をつけておきたい。広く使われているツールは、公式のドキュメントやチュートリアルが充実していることが多い。例えばGitであれば[Pro Git](https://git-scm.com/book/ja/v2)というGitの本がウェブで公開されている。また、`git help`で表示されるヘルプも非常に充実している。公式ドキュメント及びヘルプを読めるか読めないか(読むか読まないか)で学習効率が大きく異なる。「困ったらまずは公式」という習慣をつけておこう。

## 初期設定(`config`)

まず、最初にやるべきことは、Gitに名前とメールアドレスを教えてやることだ。この二つを設定しておかないと、Gitのコミットができない。名前やメールアドレスが未設定のままコミットをしようとすると、こんなメッセージが表示される。

```txt
*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.
```

Gitはエラーが親切で、何か問題が起きた時に「こうすればいいよ」と教えてくれることが多い。今回も、このメッセージに表示されている通り、`git config --global`命令を使って、メールアドレスと名前を登録しよう。

```sh
git config --global user.name "H. Watanabe"
git config --global user.email hwatanabe@example.com
```

また、念のためにデフォルトエディタを`vim`にしておこう。

```sh
git config --global core.editor vim
```

さらに、デフォルトブランチの名前を`master`から`main`に変更しておく。

```sh
git config --global init.defaultBranch main
```


以上で設定は完了だ。ここで、`--global`オプションは、そのコンピュータ全体で有効な情報を登録するよ、という意味だ。具体的に、今回登録した内容はホームディレクトリの`.gitconfig`の中に表示されている。見てみよう。

```sh
$ cat .gitconfig
[user]
        name = H. Watanabe
        email = hwatanabe@example.com
[core]
        editor = vim
[init]
        defaultBranch = main
```

`git config`で `user.name`で指定した項目が、`user`セクションの`name`の値として登録されている。基本的にはGitの設定は`git config`でコマンドラインから指定するが、直接このファイルを編集して設定することも可能だ。

また、プロジェクト固有の設定を登録したい場合は、そのプロジェクトの中で

```sh
git config user.name "John Git"
```

などと、`--global`をつけずに設定すると、そちらの設定が優先される。複数のプロジェクトで名前やメールアドレスを使い分けたいことがあるかもしれないので、覚えておくと良い。

なお、現在の設定は`git config -l`で表示できるが、そのオプション`-l`を忘れたとしよう。その場合は

```sh
git help config
```

を実行し、ヘルプを見よう。

```txt
       -l, --list
           List all variables set in config file, along with their values.
```

という項目を見つけて`--list`が目的のオプションであり、`-l`がその短縮形であることがわかる。

## 一連の操作

Gitではリポジトリを初期化したのち、「修正をステージングしてはコミット」という作業を繰り返すことで歴史を作っていく。以下では初期化、ステージング、コミットまでの一連の操作を見てみよう。

### リポジトリの初期化

リポジトリを作るには、`git init`コマンドを用いる。作り方は大きく分けて「すでに存在するプロジェクトのディレクトリをGit管理にする方法」と「最初からGit管理されたディレクトリを作る方法」の二通りだ。

いま、`project`というディレクトリがあり、そこにGit管理したいファイルやディレクトリがあるとしよう。その`project`ディレクトリの一番上で`git init`することでGitの初期化が行われる。

```sh
$ pwd
/c/Users/watanabe/project  # 現在、projectというディレクトリの中にいる
$ git init                 # カレントディレクトリをGitリポジトリとして初期化
Initialized empty Git repository in C:/Users/watanabe/project/.git/
```

すると、`project`ディレクトリ直下に`.git`というディレクトリが作られる。Gitの管理情報は全てこのディレクトリに格納される。プロジェクトがディレクトリを含む場合、その下で`git init`しないように気を付けよう。親子関係にあるディレクトリに複数の`.git`が存在すると動作がおかしくなる。また、Git Bashを使っているなら、プロンプトに`~/project (main)`と、Git管理されたディレクトリであり、現在のブランチが`main`であることが表示されたはずだ。

もう一つの方法は、空のリポジトリをディレクトリごと作る方法だ。

```sh
$ pwd
/c/Users/watanabe         # 現在、ホームディレクトリにいる
$ git init project        # projectというディレクトリを作成して初期化
Initialized empty Git repository in C:/Users/watanabe/project/.git/
```

先ほどとコマンドを実行した場所は異なるが、同じ場所に`.git`が作られたことに注意したい。

管理したいディレクトリの中で`git init`する方法と、`git init projectname`としてディレクトリごと作る方法のどちらを使ってもよいが、一般的にはある程度形になってから「じゃあGitで管理するか」と思うであろうから、前者を使うことが多いであろう。

### 最初のコミット

初期化直後のGitリポジトリには、全く歴史が保存されていない。そこで、最初のコミットを作ろう。そのために、管理したいファイルをインデックスに追加する必要がある。すでに述べたように、Gitはコミットを作る前に、インデックスにコミットされるスナップショットを作る。これをステージングと呼ぶ。インデックスにステージングするコマンドが`git add`だ。

例えば先ほど作成した`project`の中に`README.md`を作り、それを追加しよう。

```sh
echo "Hello" > README.md
git add README.md
```

現在の状態を見るのは、`git status`コマンドを使う。

```sh
$ git status
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   README.md
```

これは、

* 現在のカレントブランチは`main`であり (`On branch main`)
* まだ全く歴史はなく (`No commits yet`)
* 現在コミットした場合に反映される修正は (`Changes to be committed:`)、`README.md`という新しいファイルを追加することである

ということを意味している。

早速最初のコミットを作ろう。コミットは`git commit`コマンドを使う。

```sh
git commit
```

すると、デフォルトエディタ(本講義の設定では`vim`)が起動し、以下のような画面が表示される。

```sh

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# On branch main
#
# Initial commit
#
# Changes to be committed:
#       new file:   README.md
#
```

ここでコミットメッセージを書く。最初のコミットメッセージは`initial commit`とすることが多い。なお、`#`で始まる行はコミットメッセージには含まれない。コミットメッセージを入力し、ファイルを保存してエディタを終了するとコミットが実行される。

```sh
$ git commit
[main (root-commit) 9d8aab0] initial commit
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
```

これは

* `main`ブランチの、最初のコミットであり (`root-commit`)
* コミットハッシュ(の先頭7桁)が`9d8aab0`であるコミットが作られた

ということを意味している。Gitはコマンド実行時やエラー時にわりとていねいなメッセージが出る。それらをスルーせず、ちゃんと意味を理解しようとするのがGitの理解の早道だ。

ここでコミットハッシュという言葉が出てきた。Gitでは歴史をコミットで管理しており、コミットは「コミットされた時点でのプロジェクトのスナップショット」を表す。そのコミットを区別する一意な識別子がコミットハッシュである。先ほどはコミットハッシュの上位7桁しか表示されなかったが、実際には40桁ある。ハッシュ値の計算にはSHA-1というアルゴリズムが用いられている(詳細は「Gitの仕組み」の項で触れる)。

これで最初の歴史が作られた。過去のコミットを見てみよう。履歴を見るには`git log`コマンドを使う。

```sh
$ git log
commit 9d8aab06e0a1f1b152546db086fe7737a02526e1 (HEAD -> main)
Author: H. Watanabe <hwatanabe@example.com>
Date:   Thu Sep 16 17:15:41 2021 +0900

    initial commit
```

これは、

* `9d8aab06e0a1f1b152546db086fe7737a02526e1`というコミットハッシュのコミットがあり、
* `main`ブランチがそのコミットを指しており
* カレントブランチは`main`ブランチであり (`HEAD -> main`)
* 著者とメールアドレスは`H. Watanabe <hwatanabe@example.com>`であり、
* コミットされた日付が2021年9月16日であり、
* コミットメッセージが`initial commit`である

ということを表している。繰り返しになるが、Gitの出力するメッセージを面倒くさがらずにちゃんと理解しようとするのがGitの理解の早道だ。

### 修正をコミット

次に、`README.md`を修正し、その修正をコミットしよう。Vimで修正してもよいが、VS Codeで編集しよう。Git Bashでカレントディレクトリが`project`である状態から、

```sh
code .
```

を実行すると、このディレクトリをVS Codeで開くことができる。左のエクスプローラーから`README.md`を選び、以下のように行を追加する。

```sh
Hello
Update

```

修正した状態で`git status`を実行してみよう。

```sh
$ git status
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

これは、

* カレントブランチが`main`であり(`On branch main`)
* ステージされていない変更があり(`Changes not staged for commit`)
* その変更とは、`README.md`が修正されたものである (`modified:   README.md`)

ということを意味する。また、`git status`には`-s`オプションがあり、表示が簡略化される。

```sh
$ git status -s
 M README.md
```

ファイルの隣に`M`という文字が表示された。これはワーキングツリーで表示されたが、インデックスには変更がないことを示す。

この状態で差分を見てみよう。`git diff`を実行する。

```sh
$ git diff
diff --git a/README.md b/README.md
index e965047..9c99d1a 100644
--- a/README.md
+++ b/README.md
@@ -1 +1,2 @@
 Hello
+Update
```

これは、ワーキングツリーとインデックスを比較して、`README.md`に変更があり、ワーキングツリーには「Update」という行が追加されていることを示す。

では、この修正を`git add`でステージングしよう。

```sh
git add README.md
```

これで、修正がステージングされた。この状態で、ワーキングツリーとインデックスは同じ状態となり、リポジトリにはまだ修正が反映されていない状態となっている。

`git diff`を実行しても何も表示されない。

```sh
$ git diff

```

これは、`git diff`に何も引数を渡さないと、ワーキングツリーとインデックスの差分を表示するからだ。リポジトリの`main`ブランチの状態は古いので、その状態と比較すると差分が表示される。

```sh
diff --git a/README.md b/README.md
index e965047..9c99d1a 100644
--- a/README.md
+++ b/README.md
@@ -1 +1,2 @@
 Hello
+Update
```

また、`git status`の表示も見てみよう。

```sh
$ git status
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   README.md
```

先ほど、「Changes not staged for commit:」となっていた部分が、「Changes to be committed:」となっている。これは我々が修正をインデックスにステージングしたからだ。簡略版も表示させよう。

```sh
$ git status -s
M  README.md
```

先ほどと異なり、二桁目は空白、一桁目に緑色で`M`が表示された。実は、一桁目がインデックスとリポジトリの差分、二桁目がインデックスとワーキングツリーの差分を示している。慣れたら`git status`よりも`git status -s`の方を使うことが多いと思われる。

ではコミットしよう。先ほどはコミットメッセージをエディタで書いたが、`-m`オプションで直接コマンドラインで指定することもできる。

```sh
$ git commit -m "updates README.md"
[main a736d82] updates README.md
 1 file changed, 1 insertion(+)
```

新たに`a736d82`というコミットが作られ、歴史に追加された。歴史を表示させてみよう。

```sh
$ git log
commit a736d82251279f592a25e38503bb9130bac12481 (HEAD -> main)
Author: H. Watanabe <kaityo@users.sourceforge.jp>
Date:   Thu Sep 16 19:13:34 2021 +0900

    updates README.md

commit 9d8aab06e0a1f1b152546db086fe7737a02526e1
Author: H. Watanabe <kaityo@users.sourceforge.jp>
Date:   Thu Sep 16 17:15:41 2021 +0900

    initial commit
```

二つのコミットができている。`git log`は`--oneline`オプションをつけるとコミットを一行表示してくれる。

```sh
$ git log --oneline
a736d82 (HEAD -> main) updates README.md
9d8aab0 initial commit
```

その他、`git log`には多くのオプションがあるので、必要に応じて覚えると良い。

コミットの後は、ワーキングツリーは「きれいな状態」になる。

```sh
$ git status
On branch main
nothing to commit, working tree clean
```

## `git add`の意味

* git addには三種類の意味がある
    * リポジトリの管理下にないファイルを管理下に置く
    * リポジトリの管理下にあるファイルをステージングする
    * Gitにconflictの解消について教える

## VSCodeの設定と操作

## その他の設定(`.gitignore`)

* .gitignore

## 余談：データベース"ふっとばし"スペシャリスト

誰かが会社に甚大な被害をもたらす大きなミスをしたとしよう。そのリカバリ作業のため、多くの人が残業を余儀なくされた状況で、ミスをした本人が「先に帰ります」と家に帰ったらどう思うだろうか？「非常識だ」と思う人が多いのではないだろうか？しかし、実際大きなミスをした人がリカバリ作業からすぐに離脱し、それを誰も咎めなかったケースがある。GitLabのデータベース障害対応だ。

GitLabは、GitHubと同様にGitのリポジトリをホスティングするサービスを運営している会社である。日本時間で2017年2月1日、そのGitLabがサービスを停止し、緊急メンテナンスに入る。原因は人為的なミスによるデータベースの喪失であった。GitLabのデータベースはプライマリ(本番)とセカンダリ(待機系)の二つを持っており、二つが同期する仕組みとなっていた。しかし当日、スパムユーザからの攻撃をうけ、データベースが過負荷状態になり、同期がうまくいかなくなっていた。データベースを管理していたエンジニアはこのトラブルに長時間対応し、疲れていたようだ。現地時間で23時、彼は不要なデータを削除してから再度同期しようとして、セカンダリデータベースのディレクトリを削除する。しかし、その数秒後、彼は操作したのがバックアップのセカンダリではなく、プライマリのデータであったことに気づく。すぐに削除を停止したが時すでに遅く、ほとんどのデータは失われてしまった。GitLabはこういう時のためにデータベースをバックアップするコマンドを定期的に実行する仕組みを導入していたが、バージョン違いによるエラーが発生しており、しばらく前からバックアップに失敗していることに気づかなかった。その他のいくつかのバックアップも機能していなかったことが判明し、バックアップはたまたま事故の6時間前にとられたスナップショットのみであった。この頼みの綱のスナップショットから復旧作業が始まったが、この時、データベースをふっとばしたエンジニアは「自分はもうsudoコマンドを実行しない方が良いだろう」と、復旧作業を別の人に依頼。そして事故から1日後、GitLabは復旧作業を完了し、全てのサービスを再開した。

ここで、データベースをふっとばした張本人が、早々に復旧作業から離脱していることに注意して欲しい。私はこれは正しい判断だったと思う。自分が会社に巨額の損失を与えるような失敗をしてしまったことを想像してみよう。「自分の責任だから自分で挽回しよう」とか「ミスをした贖罪として寝ずに仕事をしよう」と考えてしまう人が多いのではないだろうか？しかし、すでに長時間作業をして疲れており、大きなミスをして動揺している状態で復旧作業に参加しても、また大きなミスをしてしまう可能性が高い。「頼みの綱」のスナップショットを失ったら、GitLabはサービスを再開できなくなってしまう。それなら復旧作業は信頼できる同僚にまかせて、自分は休んでから別の作業で復帰したほうが良い。GitLabは事故の詳細を(人為ミスであることも含めて)すぐに公表し、リカバリ作業をYouTubeのストリーミング放映、Twitterでも進捗を報告、事故の詳細も隠さずにリアルタイムに公表していった。筆者もリアルタイムで復旧作業のストリーミング映像を見たが、エンジニアが淡々と作業しており、そこに悲壮感などはなかった。GitLabが復旧を完了し、サービス再開を告げたツイートには、「よくやった」「事故対応の透明性が素晴らしい」など多くの賛辞が寄せられた。このように、ミスや問題を報告しやすい雰囲気を「心理安全性が高い」と言う。ミスをした人が先に帰っても問題視されず、自社が犯したミスを(バックアップが動作していなかったことまで含めて)包み隠さず公開したGitLabは、間違いなく心理安全性が高い会社と言えよう。

なお、この事故のあとしばらくの間、データベースをふっとばしたエンジニアはGitLabの自分のページで「データベース"ふっとばし"スペシャリスト (Database "removal" specialist)」と名乗っていた。

* [GitLab.com database incident](https://about.gitlab.com/blog/2017/02/01/gitlab-dot-com-database-incident/)
* [GitLab.comが操作ミスで本番データベース喪失。5つあったはずのバックアップ手段は役立たず、頼みの綱は6時間前に偶然取ったスナップショット](https://www.publickey1.jp/blog/17/gitlabcom56.html) 2021年8月20日閲覧
