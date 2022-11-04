# GitHubの操作(基本編)

## 目標

* GitHubのアカウントを作成する
* リモートリポジトリの作成と、ローカルリポジトリとの同期について学ぶ
* issueの使い方の基本を覚える
* Project(Automated Kanban)の使い方を覚える
* プルリクエストを作ってみる

## 課題1: GitHubアカウントを作成とSSH接続

### Step 1: アカウントの作成

まず、GitHubにアカウントを作成する。既にGitHubにアカウントを持っている人はこのステップをスキップしてよい。ユーザ名、メールアドレス、パスワードを入力するが、ユーザー名は今後長く使う可能性があるのでよく考えること。場合によっては本名よりも有名になる可能性もある。メールアドレスは普段使うアドレスを設定しておく。このアドレスは公開されない(公開することもできる)。

[https://github.com/](https://github.com/)にアクセスし、右上から「Sign up」を選ぶ。

* Enter your email : メールアドレスを入力する
* Create a password: パスワードを入力する
* Enter a username: GitHubのアカウント名を入力
* Would you like to receive product updates and announcements via email?: アナウンスを受け取るか。通常は不要なのでnで良い。
* Verify your account: 人間であることを証明するため、パズル認証を解く
* Create account: 実行すると、登録メールにlaunch code(6桁の数字)が届くので、メールを確認して入力
* 最初にアンケートを聞かれる。答えても良いが、面倒なら「Skip personlization」

「Learn Git and GitHub without any code!」という画面が出てきたら登録完了だ。この画面はまだ使うので、まだブラウザを閉じないこと。

### Step 2: SSH公開鍵の作成

SSH公開鍵のペアを作成する。なお、過去に作成したことがある場合はその鍵が使えるので、このステップを飛ばして良い。Git Bashのホームディレクトリで以下のコマンドを実行せよ。

```sh
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/z//.ssh/id_rsa):  # (1)
Created directory '/z/.ssh'.
Enter passphrase (empty for no passphrase): # (2)
Enter same passphrase again:                # (3)
```

* (1) 秘密鍵を保存する場所を入力する。`/z/.ssh/id_rsa`と入力してエンターキーを押すこと。
* (2) ここでパスフレーズを聞かれる。何も入力せずに改行するとパスフレーズ無しとなるが、**必ずパスフレーズを入力すること**。ここではキーを入力しても画面には何も表示されないので注意。
* (3) 先ほどの入力したものと同じパスフレーズを再度入力する。

パスフレーズを二度入力した後、

```txt
Your identification has been saved in /z/.ssh/id_rsa
Your public key has been saved in /z/.ssh/id_rsa.pub
```

といったメッセージが表示されたら成功である。`id_rsa`が秘密鍵、`id_rsa.pub`が公開鍵だ。秘密鍵は誰にも見せてはならない。公開鍵は、文字通り公開するための鍵で、これからGitHubに登録するものだ。

### Step 3: SSH公開鍵の登録

GitHubに公開鍵を登録する。

* GitHubの一番右上のアイコンをクリックして現れるメニューの下の方の「Settings」を選ぶ。
* 左に「Account settings」というメニューが現れるので「SSH and GPG keys」を選ぶ。
* 「SSH keys」右にある「New SSH key」ボタンを押す
* 「Title」と「Key」を入力する。Titleはなんでも良いが、例えば「Git Bash」もしくは「University PC」とする。Keyには、`.ssh/id_rsa`ファイルの中身をコピペする。Git Bashで以下を実行せよ。

```sh
cat .ssh/id_rsa.pub
```

すると、`ssh-rsa`から始まるテキストが表示されるため、マウスで選択して右クリックから「Copy」、そして、先ほどのGitHubの画面の「Key」のところにペーストし、「Add SSH key」ボタンを押す。

`This is a list of SSH keys associated with your account. Remove any keys that you do not recognize.`というメッセージの下に、先ほどつけたTitleの鍵が表示されていれば登録成功だ。

### Step 4: 鍵の登録の確認

正しく鍵が登録されたか見てみよう。Git Bashで、以下を実行せよ。

```sh
$ ssh -T git@github.com
```

もし`Are you sure you want to continue connecting (yes/no/[fingerprint])?`というメッセージが表示されたら`yes`と入力する。

`Enter passphrase for key '/path/to/.ssh/id_rsa':`と表示されたら、先ほど設定したパスフレーズを入力する。その結果、

```txt
Hi GitHubアカウント名! You've successfully authenticated, but GitHub does not provide shell access.
```

と表示されたら、鍵の登録に成功している。

### Step 5: リポジトリの作成とクローン

では実際にGitHubと通信して、データのやり取りをしてみよう。まずはGitHubでリポジトリを作成して、ローカルにクローンする。

* GitHubのホーム画面を表示する。左上のネコのようなアイコン(Octocat)をクリックするとホーム画面に戻る。
* ホーム画面に戻ったら「Create repository」ボタンを押す。
* リポジトリの新規作成画面では、以下の項目を設定しよう。
    * Repository name: リポジトリの名前。Gitでアクセスするので、英数字だけにしよう。ここではtestとしておく。
    * Descrption: リポジトリの説明(任意)。ここは日本語でも良いが、とりあえず「test repository」にしておこう。
    * Public/Private: ここで「Public」を選ぶと、全世界の人から見ることができるリポジトリとなる。とりあえずは「Private (自分だけがアクセスできる)」を選んでおこう。
    * Initialize this repository with: リポジトリを作成する際に一緒に作るもの。ここをチェックすると自動で作ってくれる。ここでは、「Add a README file」にチェックを入れ、「Choose a license」のプルダウンメニューから「MIT License」を選んでおこう。「Add .gitignore」は「None」のままで良い。
* 以上の設定を終了したら「Create repository」ボタンを押す。
* リポジトリの画面に移るので、右上の緑色の「Code」ボタンをクリックすると、「Clone」というウィンドウが現れるので「SSH」を選ぶ。すると`git@github.com:`から始まるURLが現れるので、それを右の「コピーアイコン」ボタンを押してコピーする(「Copied!」と表示される)。

次に、ローカルマシンで`github`ディレクトリの下に先ほど作ったリポジトリをクローンしよう。以下を実行せよ。

```sh
cd
cd github
git clone git@github.com:アカウント名/test.git
cd test
```

先ほどURLをコピーしていたので、`git clone`まで入力した後で、空白を入力してから右クリックで「Paste」を選べば良い。すると、パスフレーズを要求されるので、先ほど設定した秘密鍵のパスフレーズを入力しよう。正しく公開鍵が登録されていたらクローンできる。

### Step 6: ローカルの修正とpush

手元にクローンしたリポジトリを修正し、GitHubに修正をpushしてみよう。

まず、クローンしたリポジトリの`README.md`を修正しよう。VSCodeの「フォルダを開く」によって、先ほどクローンされた`test`ディレクトリを開き、`README.md`を開こう(Vimを使える人はVimで開いても良い)。

すると、以下のような内容が表示されるはずだ。

```md
# test
test repository
```

これを、以下のように「Hello Github」と一行追加し、保存せよ。

```sh
# test
test repository

Hello GitHub
```

この状態で、`README.md`の修正を`git add`して`git commit`しよう。Git Bashで以下を実行せよ。

```sh
git add README.md
git commit -m "updates README.md"
```

これでローカルの「歴史」は、GitHubが記憶している「歴史」よりも先に進んだ。歴史を見てみよう。

```sh
$ git log --oneline
1db6b18 (HEAD -> main) updates README.md
0a103b5 (origin/main, origin/HEAD) Initial commit
```

コミットハッシュは人によって異なるが、`origin/main`よりも、`HEAD -> main`が一つ先の歴史を指していることがわかる。この「新しくなった歴史」をGitHubに教えよう。ターミナルで以下を実行せよ。

```sh
git push
```

パスフレーズを聞かれるので入力せよ。これでローカルの修正がリモート(GitHub)に反映された。もう一度ブラウザでGitHubのリポジトリを見てみよう。ブラウザをリロードしてみよ。ローカルの変更が反映され、画面に「Hello GitHub」の画面が表示されたら成功だ。

### レポート課題

GitHub側で情報が更新され、`README.md`に「Hello GitHub」が表示されている画面のスクリーンショットをレポートとして提出せよ。

## 課題2: ローカルのリポジトリをGitHubに登録

先ほどはGitHub側で新規リポジトリを作り、それをローカルにクローンした。しかし、まずローカルで開発を進め、ある程度形になったらGitHubに登録することの方が多いであろう。そこで、ローカルでリポジトリを作ってからGitHubに登録する作業を体験しよう。

### Step 1: ローカルにリポジトリを作る

Git Bashの`github`ディレクトリ以下に`test2`というディレクトリを作ろう。

```sh
cd
cd github
mkdir test2
cd test2
```

ここでまた`README.md`ファイルを作る。VSCodeで「フォルダーを開く」から`github/test2`ディレクトリを開き、ファイルの追加ボタンを押して`README.md`を新規作成する。

内容は何でも良いが、例えば以下の内容を入力して保存しよう。

```md
# test2

2nd repository
```

この状態で、Gitリポジトリとして初期化し、最初のコミットをしよう。

```sh
git init
git add README.md
git commit -m "initial commit"
```

### Step 2: GitHubにベアリポジトリを作る

GitHubのホーム画面の左上の「Repositories」の右にある「New」をクリックする。Repository nameはtest2、Descriptionは無くても良いが、とりあえず2nd repositoryとしておこう。また、今回もPrivateリポジトリとする。

空のリポジトリを作りたいので、「Initialize this repository with:」のチェックは全て外した状態で「Create Repository」とすること。

すると、先ほどとは異なり、全くファイルを含まない空のリポジトリが作成される。そこには「次にすべきこと」がいくつか書いてあるが、ここでは「既に存在するリポジトリをpushする(...or push an existing repository from the command line)」を選びたいので、そこに書かれている以下のコマンドをコピーする。

```sh
git remote add origin git@github.com:アカウント名/test2.git
git branch -M main
git push -u origin main
```

これをGit Bashに貼り付けて実行すれば、プッシュできる。この状態で、もう一度GitHubの当該リポジトリを見てみよう。ブラウザをリロードせよ。リポジトリにREADME.mdが作成された状態になるはずだ。

### レポート課題

GitHubの`test2`リポジトリにおいて`README.md`が表示されている画面のスクリーンショットをレポートとして提出せよ。

## 課題3: Issue管理

Gitでは、原則としてメインブランチで作業をしない。これから作業をする内容によってブランチを作成し、そのブランチ上で作業し、完成したらメインブランチにマージする、という作業を繰り返すことで開発をすすめる。それぞれの作業に対応するブランチを作業ブランチ(トピックブランチもしくはフィーチャーブランチ)と呼ぶ。

一般に、必要な作業は複数同時に発生する。このとき、どのタスクを実行中で、どのタスクが手つかずか、タスク管理をしたくなる。原則としてタスクと作業ブランチは一対一に対応するのであるから、それらをツールで一度に管理したくなるのは自然であろう。それがGitHubのissueである。

GitHubを使う場合、

* これから行う作業をissueに登録する。
* 登録されたissueのうち、これから手をつけるissueに対応した作業ブランチを作成する
* 作業ブランチで作業し、修正をコミットする
* メインブランチにマージする

という流れで開発をすすめる。issueとは「課題」という意味であり、一般に課題を管理するシステムをIssue Tracking System (ITS)と呼ぶ。一種のTodo リストだと思えば良い。GitHubはITSの機能を持っている。

以下ではブランチとIssueを連携させた開発について体験しよう。

### Step 1: Issueの作成

* 先ほど作った`test`リポジトリに移動せよ。左上のOctocatのアイコンをクリックしてホーム画面に戻り、「Repositories」の「アカウント名/test」を選べばよい。
* 「Code」「Issues」「Pull requests」「Actions」「Projects」などのメニューが並んだタブから「Issues」を選び、「New Issue」ボタンを押す。画面の最上部の「Issues」と間違えないこと。
* Titleに「READMEの修正」と書く
* コメント(Leave a commentとあるところ)に「内容を追加」と書く。
* Labelsとして「enhancement」を選ぶ。

以上の操作の後「Submit new issue」をクリックする。すると、「READMEの修正 #1」というissueが作られたはずだ。ここで「#1」とあるのはissue番号であり、issueを作るたびに連番で付与される。この画面は後で使うので、そのままブラウザを閉じないこと。

### Step 2: ブランチの作成

次に、issueに対応するブランチを作成する。ブランチの命名規則には様々な流儀があるが、先ほどつけたラベル(enhancement)、issue番号(1)、そして修正内容を含めるのが一般的だ。ここではディレクトリ型の命名規則を採用しよう。ディレクトリ型の命名規則では「ラベル/issue番号/内容」という名前のブランチを作成する。今回、「enhancement」というラベルをつけたが、これは「新しい機能(feature)を追加する」という意味なので、「feat」とする。あとはissue番号1番、READMEの修正なので、全てまとめて`feat/1/README`というブランチを作ることにする。

Git Bashで以下を実行せよ。

```sh
cd
cd github
cd test
git switch -c feat/1/README
```

### Step 3: コミットとマージ

今、カレントブランチが`feat/1/README`ブランチとなったはずだ。このブランチ上で、README.mdに一行追加しよう。

```sh
# test
test repository

Hello GitHub
modifies README
```

修正したら、`git add`、`git commit`するが、コミットメッセージを`closes #1`とする。シャープ`#`を忘れたり、全角にしたり、数字との間に空白を挟んだりしないこと。

```sh
git add README.md
git commit -m "closes #1"
```

修正を`main`に取り込もう。

```sh
git switch main
git merge feat/1/README
```

### Step 4: 修正のプッシュとissueのクローズ

以上の修正をpushする。pushする前に、先ほどのissueの画面をブラウザで表示しておくこと。ブラウザの画面が見える状態でGit Bashから`git push`する。

```sh
git push
```

ブラウザのissueの画面を見てみよう。push後に自動的にissueが閉じられたはずだ。

このように、`fixes`、`closes`といった動詞と`#1`のような形でissue番号が含まれたコミットメッセージを含むコミットがpushされると、GitHubがそれを検出し、自動的に対応するissueを閉じてくれる。

不要になったブランチは消しておこう。

```sh
git branch -d feat/1/README
```

### レポート課題

issueが自動的に閉じられた画面のスクリーンショットをレポートとして提出せよ。

## 課題4: Projectの利用

issueには「open (未完了)」と「closed (完了)」の二状態しかないが、issueが増えてくると、いまどのissueがどういう状態なのかをより細かく管理したくなる。例えば未完了と完了の間に、「作業中」という状態が欲しくなる。このような状態を管理するのがProjectだ。以下では、もっとも基本的なProjectであるKanbanを使ってみよう。

### Step 1: Projectの作成

まずはBoard(Kanban)方式のプロジェクトを作成し、リポジトリに関連付けよう。以下の作業を実施せよ。

1. GitHubの`test`リポジトリの上のタブから「Project」を選び、「Add project」をクリックする。
1. 「Go to you profile to create a new project」をクリック
1. 「Welcome to project」画面が現れたら「Jump right in」ボタンをクリック
1. 「Create your first GitHub project」画面で「New project」をクリック。
1. 「Select a template」画面で「Board」を選び、「Create」ボタンを押す。
1. Projectが作成されるが、名前が「ユーザ名’s untitled project」となっているので、「Kanban」に修正
1. 「test」リポジトリに戻り、「Project」の「Add project」をクリック、先ほど作成した「Kanban」を選ぶ

これにより「test」リポジトリに「Kanban」プロジェクトが関連付けられた。

### Step 2: Issueの作成とProjectへの関連付け

上のタブから「Issues」をクリックし、「New Issue」ボタンを押し、新たにissueを作る。Titleは「READMEの修正」とする。Issueのコメントには、他のissueを参照したり、チェックボックスを作る機能があるので試してみよう。コメントに以下の内容を記述せよ。

```md
- [ ] 修正1 (#1 に追加)
- [ ] 修正2
```

ここで「`#`」と数字の間には空白をいれず、「`#1`」の後には半角空白を入れるのをわすれないこと。また、`- [ ]`の間には半角空白を入れる。入力をしたら「Preview」タブを見て、チェックボックスができているか、別のissueにリンクされているか確認すること。

ラベルは先ほどと異なるもので試したいので「documentation」を選ぶ。

このissueをprojectと関連付けよう。右の「Labels」の下にある「Projects」を開き、先ほど作った「Kanban」を選ぼう。

以上の準備が済んだら「Submit new issue」ボタンを押し、issueを作る。この画面はまた使うのでブラウザを閉じないこと。

### Step 3: ブランチの作成

Git Bashに戻り、ブランチを作成しよう。今回はラベルが`documentation`、issue番号が2番、内容がREADMEの修正なので、`doc/2/README`としよう。Git Bashの`test`リポジトリで以下を実行せよ。

```sh
git switch -c doc/2/README
```

ブランチを作成したら、このissueのステータスを「作業中」にしよう。GitHubの`test`リポジトリの「Projects」タブから「Kanban」を選ぶ。

すると、「No Status」のところに「READMEの修正」というカードが出来ているはずなので、マウスで「In progress」にドラッグしよう。また「Issues」タブにもどって先ほどのissueを見てみると、「Projects」の「Kanban」で、状態が「In progress」になっていることがわかる。

状態とブランチの関係はプロジェクトやチームによって異なるが、例えば「ブランチを作ったらIn progressにする」というルールにしておくと、逆に「In progressになっていれば、ブランチがあるはず」とわかって便利だ。

### Step 4: 修正とマージ

また`README.md`を修正しよう。「Hello Kanban」という一行を追加せよ。

```md
# test
test repository

Hello GitHub
modifies README
Hello Kanban
```

ファイルを保存したら、今度は`fixes #2`というメッセージでコミットする。

```sh
git add README.md
git commit -m "fixes #2"
```

また`main`ブランチに戻って、修正を取り込もう。まだpushしないこと。

```sh
git switch main
git merge doc/2/README
```

### Step 5: 修正のプッシュとカードの移動

マージが終了したらブラウザで先ほどの「Kanban」の画面を見よう。まだカードは「In progress」にある。

この状態でGit Bashから`git push`しよう。

```sh
git push
```

2番のIssueが閉じられると同時に、自動でカードが「In progress」から「Done」に移動したはずだ。

### レポート課題

Projectの「Kanban」で、「READMEの修正」のカードが「Done」にある状態のスクリーンショットをレポートとして提出せよ。

## 発展課題: プルリクエストを作ってみる

GitHubでは、公開されているリポジトリを自分の場所に「コピー」することができる。これをforkと呼ぶ。公開リポジトリは、HTTPSによりクローンはできるが、書き込み権限がなければ修正できない。しかし、forkすれば自分の所持するリポジトリとなるので、好きなように修正できる(ただし、ライセンスには気を付けること)。

### Step 1: リポジトリのfork

まず、既存のリポジトリをforkしよう。以下のサイトにアクセスせよ。

* A班の場合
[https://github.com/appi-github/pullreq_2022_a](https://github.com/appi-github/pullreq_2022_a)

* B班の場合
[https://github.com/appi-github/pullreq_2022_b](https://github.com/appi-github/pullreq_2022_b)

このサイトの右上に「Fork」というボタンがあるので、それを押す。すると自分のアカウントのリポジトリとしてコピーされる。以下、A班を例にリポジトリ名を`pullreq_2022_a`として説明するが、B班は適宜`pullreq_2022_b`に読み替えること。

### Step 2: リポジトリのクローン

ブラウザのURLが`https://github.com/自分のアカウント/リポジトリ名`になったら、フォークが完了している。ローカルにクローンしよう。「Code」ボタンの「Clone」からリモートリポジトリをコピーできる。プロトコルがHTTPSではなくSSHになっていることを確認すること。

```sh
cd
cd github
git clone git@github.com:アカウント名/pullreq_2022_a.git
cd pullreq_2022_a
```

### Step 3: ブランチの作成

次に、ブランチを作成するが、ブランチ名を「自分の学籍番号」のSHA-1ハッシュの上位7桁としよう。例えば学籍番号が`1234568`である時、以下のコマンドを実行せよ。

```sh
echo 12345678 | shasum
9806af3952e1380212b0998f07a6afe4e5f00428 *-
```

上記のSHA-1ハッシュは各自異なるため、以下は適宜読み替えること。

表示された上位7桁`9806af3`をブランチ名として、ブランチを作ろう。

```sh
git switch -c 9806af3
```

### Step 4: ファイルの追加とプッシュ

先ほどのSHA-1ハッシュをファイル名として、ファイルを作ろう。

```sh
echo Hello > 9806af3952e1380212b0998f07a6afe4e5f00428
```

できたファイルを`git add`、`git commit`しよう。

```sh
git add 9806af3952e1380212b0998f07a6afe4e5f00428
git commit -m "adds a file"
```

最後に修正をプッシュしよう。

```sh
git push origin 9806af3
```

`git push origin`の後にブランチ名を入れるのを忘れないこと。

### レポート課題: プルリクエストの作成

GitHubのフォークしたページを見ると、上部に「Compare & pull requst」というボタンが出来ているので押す。すると「Open a pull request」という画面に遷移するので、タイトルとコメントを入力する。タイトルは「add a file」、コメントはなんでも良いが、例えば「よろしくお願いします。」などとしておく。最後に「Create a pull request」を押せば、fork元にプルリクエストが飛ぶ。このプルリクエストを飛ばしたことをもってレポートとする。

## 余談：天空の城のセキュリティ

スタジオジブリの長編アニメ映画「天空の城ラピュタ」を知っているであろう。空から少女がゆっくり降りてくるシーンでが印象的なこの映画は、滅びの言葉「バルス」でも有名だ。金曜ロードショーなどで「バルス」を言うタイミングで、多くの人がネット上で「バルス」と発信するため、サーバが落ちたこともある。さて、ラピュタというシステムおける「バルス」の認証はどうなっているだろうか？「バルス」の前に、まずは「リーテ・ラトバリタ・・・」で始まる「ラピュタ起動の呪文」の認証について考えてみよう。劇中では、ペンダントを首にかけた状態で、シータが呪文を唱えることでラピュタが起動する。回想シーンでシータがおばあさんからこの呪文を教わっている時に特に何も起きていないので、「ペンダントが近くにある」ことが要件であろう。この「特定の物を持っている」ことによる認証を「所持認証」と呼ぶ。家の鍵などが所持認証であり、鍵の持ち主が家に入る権利を持っているものとみなす。また、呪文やパスワード、合言葉のような「特定の知識があること」を要件とする認証を「知識認証」と呼ぶ。大学のワークステーション室のパソコンにログインする場合にアカウントとパスワードを入力するであろう。これは、アカウントとパスワードの正しい組み合わせを知っている人が、そのアカウントにログインする権利を持つ人であるとみなしている。さらに静脈認証や指紋認証といった、身体的特徴を個人識別の手段として使うものを「生体認証」と呼ぶ。タブレットで指紋で認証したり、スマホのカメラで顔で認証したりするのがその例である。劇中では明示的に描かれていないが、ラピュタ王家の血を引くものが呪文を唱えることを起動要件としているかもしれない。少なくとも私がラピュタのエンジニアならそうする。もしそうなら、ラピュタの起動は「所持認証(飛行石のペンダント)」「知識認証(長い呪文)」「生体認証(王家の血を引く人物)」の多要素認証で守られていることになる。では、ラピュタの緊急停止コマンドである「バルス」はどうであろうか。劇中ではやはり「王家の人間が」「飛行石を持って」「呪文を唱える」という多要素認証で守られているように見えるが、そのわりには起動に比べて緊急停止の呪文が短いのが気になるであろう。あくまで個人的な考えだが、私は「バルス」は多要素認証で守られて「いない」と考える。ラピュタは強大な兵器であり、もし敵の手に渡ったら大変なことになる。その場合は可及的速やかに停止させなければならない。緊急事態において、王家の血をひく人間を用意するのは大変であろう。なので生体認証はないだろう。さらに、ラピュタが敵の手に落ちているということは、飛行石も相手側にあると考えるのが自然だ。したがって所持認証をかけてしまうと、停止させることができない。以上から、「誰が呪文を唱えたとしても」「飛行石を持っていなくても」「ラピュタが起動している状態でバルスとさえ言えば(その言葉がラピュタに感知されれば)」ラピュタは停止すると思われる。少なくとも私がラピュタのエンジニアならそうする。一般に、「ヤバい」ものほど、起動は面倒に、停止は簡単にするのがセオリーである。ちなみに、もし「バルス」に「所持認証」と「生体認証」がかかっていたとしても、シータが呪文を唱えれば発動要件を満たすはずだ。この状態でなぜシータがパズーに滅びの言葉を教えたときになぜ発動しなかったのか、ラピュタ好きな友人に聞いてみたことがある。その友人は、「シータがパズーの手に指で文字を書いて教えたのだろう」と答えた。なるほど。
