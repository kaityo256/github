# GitHubの操作

## 目標

* GitHubのアカウントを作成する
* リモートリポジトリの作成と、ローカルリポジトリとの同期について学ぶ
* issueの使い方の基本を覚える
* Project(Automated Kanban)の使い方を覚える
* GitHub Pagesの公開を体験する

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

### Step 2: SSH公開鍵の確認と作成

SSH公開鍵を作成する。Git Bashを起動せよ。

```sh
ls .ssh
```

を実行し、`id_rsa.pub`と`id_rsa`が表示された場合は既に公開鍵が作られている。これらの鍵を自分で作った記憶があり、かつ秘密鍵にパスフレーズが設定されているのならこのステップをスキップして良い。パスフレーズの確認は以下のコマンドでできる。

```sh
ssh-keygen -yf .ssh/id_rsa
```

実行後、パスフレーズが聞かれ、入力したら`ssh-rsa AAAAB...`という長い文字列が表示されたらそのまま使ってよいので、次のステップに進む。もしパスフレーズを入力せずに文字列が表示されたり、パスフレーズを忘れてしまった場合は以下の手順で作り直す。

SSH公開鍵がなかった場合は、以下の手順で作成する。Git Bashのホームディレクトリで以下のコマンドを実行せよ。

```sh
$ ssh-keygen
Generating public/private rsa key pair.pat
Enter file in which to save the key (/c/Users/watanabe/.ssh/id_rsa): # ←ここではそのままリターン
Created directory '/c/Users/watanabe/.ssh'.
Enter passphrase (empty for no passphrase): # ここでパスフレーズを入力
Enter same passphrase again:                # 同じパスフレーズを入力
```

パスフレーズを二度入力した後、

```txt
Your identification has been saved in /path/to/.ssh/id_rsa
Your public key has been saved in /path/to/.ssh/id_rsa.pub
```

といったメッセージが表示されたら成功である(`path/to`は環境によって異なることを表しており、その通りに表示されるわけではない。以下同様)。`id_rsa`が秘密鍵、`id_rsa.pub`が公開鍵だ。秘密鍵は誰にも見せてはならない。公開鍵は、文字通り公開するための鍵で、これからGitHubに登録するものだ。

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

### Step 4: リポジトリの作成とクローン

では実際にGitHubと通信して、データのやり取りをしてみよう。まずはGitHubでリポジトリを作成して、ローカルにクローンする。

* GitHubのホーム画面を表示する。左上のネコのようなアイコン(Octocat)をクリックするとホーム画面に戻る。
* ホーム画面に戻ったら「Create repository」ボタンを押す。
* リポジトリの新規作成画面では、以下の項目を設定しよう。
    * Repository name: リポジトリの名前。Gitでアクセスするので、英数字だけにしよう。ここではtestとしておく。
    * Descrption: リポジトリの説明(任意)。ここは日本語でも良いが、とりあえず「test repository」にしておこう。
    * Public/Private: ここで「Public」を選ぶと、全世界の人から見ることができるリポジトリとなる。とりあえずは「Private (自分だけがアクセスできる)」を選んでおこう。
    * Initialize this repository with: リポジトリを作成する際に一緒に作るもの。ここをチェックすると自動で作ってくれる。ここでは、「Add a README file」と「Choose a license」をチェックしよう。「Choose a license」をクリックすると選択肢が現れるが、ここでは「MIT License」を選んでおこう。
* 以上の設定を終了したら「Create repository」ボタンを押す。
* リポジトリの画面に移るので、右上の「Code」をクリックすると、「Clone」というウィンドウが現れるので「SSH」を選ぶ。すると`git@github.com:`から始まるURLが現れるので、それを右の「コピーアイコン」ボタンを押してコピーする(「Copied!」と表示される)。

次に、ローカルマシンで`github`というディレクトリを作り、その下に先ほど作ったリポジトリをクローンしよう。以下を実行せよ。

```sh
cd
mkdir github
cd github
git clone git@github.com:アカウント名/test.git
```

先ほどURLをコピーしていたので、`git clone`まで入力した後で、空白を入力してから右クリックで「Paste」を選べば良い。すると、パスフレーズを要求されるので、先ほど設定した秘密鍵のパスフレーズを入力しよう。正しく公開鍵が登録されていたらクローンできる。

### Step 5: ローカルの修正とpush

手元にクローンしたリポジトリを修正し、GitHubに修正をpushしてみよう。

まず、クローンしたリポジトリの`README.md`を修正しよう。先ほどクローンされた`test`に移動し、VSCodeで`README.md`を開こう。

```sh
cd test
code README.md
```

すると、以下のような内容が表示されるはずだ。

```md
# test
test repository
```

これを、以下のように内容を修正し、保存せよ。

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

