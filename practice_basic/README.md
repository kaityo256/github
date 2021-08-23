# Gitの操作

## 目標

* Gitの初期設定を行う
* コマンドラインでのGitの操作を一通り確認する
* VSCodeの設定と操作を覚える

## 初期設定

Git Bash (以下、ターミナルと呼ぶ)を開き、以下を実行せよ。

```sh
git config --global user.name "ユーザー名"
git config --global user.email "メールアドレス"
```

この名前とメールアドレスは後に公開されるため、イニシャルやニックネームなどでも良い。また、ここで「タブ補完」が効くことも確認しておこう。

* `git con`まで入力してタブを押すと`git config `まで入力される
* `--gl`まで入力してタブを押すと`--global`まで入力される
* `us`まで入力してタブを押すと`user.`まで入力される
* `n`まで入力してタブを押すと、`name`まで入力される

以上から「git con(TAB)--gl(TAB)us(TAB)n(TAB)」と入力すると`git config --global user.name `まで入力が完了する。これをタブ補完と呼ぶ。慣れると便利なので、普段から意識して使うようにすると良い。

また、念のためにデフォルトエディタをVimにしておこう。

```sh
git config --global core.editor vim
```

次に、よく使うコマンドの省略系(エイリアス)も登録しておこう。いろいろ便利なエイリアスがあるが、人や部署によって流儀が異なるので、今回は以下の一つだけを設定しよう。

```sh
git config --global alias.st "status -s"
```

以上を実行後、ターミナルで`.gitconfig`を表示し、先ほど設定した内容が書き込まれていることを確認せよ。

```sh
cat .gitconfig
```

以下のような表示になっていれば成功である。

```txt
[user]
        name = 先ほど設定したユーザー名
        email = 先ほど設定したメールアドレス
[core]
        editor = vim
[alias]
        st = status -s
```


## リポジトリの作成(`git init`)

それではいよいよGitの操作を一通り確認する。

まずは適当なテスト用のディレクトリを作成し、その中で作業しよう。この講義用に`git`というディレクトリを作成し、さらにその中に`test`というディレクトリを作ろう。

```sh
cd
mkdir git
cd git
mkdir test
cd test
```

最初に`cd`を入力しているのは、ホームディレクトリに戻るためだ。これで`git`ディレクトリの下の`test`ディレクトリがカレントディレクトリとなった。

この`test`ディレクトリの中に`README.md`というファイルを作成しよう。このディレクトリでVSCodeを起動する。

```sh
code .
```

`code`の後、空白を一つあけてピリオドを入力するのを忘れないこと。

VSCodeが開いたら、左のエクスローラーの「TEST」の右にある「新しいファイル」ボタンを押して、`README.md`と入力せよ。`README`まで大文字、`md`が小文字である。

![fig](fig/vscode_newfile.png)

`README.md`ファイルが開かれたら、

```md
# Test
```

とだけ入力し、保存しよう。これで、以下のようなディレクトリ構成になったはずだ。

```txt
git
└── test
    └── README.md
```

この状態でターミナルに戻り、リポジトリとして初期化しよう。

```sh
git init
```

すると、`.git`というディレクトリが作成され、`test`ディレクトリがリポジトリとして初期化される。以下を実行せよ。

```
ls -la
```

`README.md`に加え、`.git`というディレクトリが作成されたことがわかるはずだ。

`git init`した直後は、「現在のディレクトリ`test`をGitで管理することは決まったが、まだGitはどのファイルも管理していない」、すなわち歴史が全く無い状態になる。

この状態を確認してみよう。以下を実行せよ。

```sh
git status
```

以下のような表示が得られるはずだ。

```txt
On branch master

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        README.md

nothing added to commit but untracked files present (use "git add" to track)
```

ここには、

* まだ何もコミットがなく(No commits yet)
* `README.md`という管理されていないファイルがあるので(Untracked files)
* もし管理したければ`git add`してね(use "git add" to track)

と書いてある。

状態を見るのにいちいちこんな長いメッセージを見せられても困るので、`-s`オプションをつけて見よう。

```sh
git status -s
```

こんな表示がされたはずだ。

```txt
?? README.md
```

`??`と、`?`が二つ表示された。`git status -s`は、ファイルの状態を二つの文字であらわす。それぞれ右がワーキングツリー、左がインデックスの状態を表している。今回のケースはどちらも`?`なので、ワーキングツリーにもインデックスにも無い、すなわちGitの管理下に無い(Untracked)という意味だ。

さて、いちいち`git status -s`と入力するのは面倒なので、最初に`git status -s`に`git st`という別名をつけておいた。以下を実行せよ。

```sh
git st
```

正しくエイリアスが設定されていれば、`git status -s`と入力したのと同じことになる。以後こちらを使うことにしよう。

## インデックスへの追加

さて、`Untracked`な状態のファイルをGitの管理下に置こう。そのために`git add`を実行する。

```sh
git add README.md
```

現在の状態を見てみよう。

```sh
git st
```

こんな表示になるはずだ。

```txt
A  README.md
```

これは「`README.md`が追加されることが予約されたよ」という意味で、インデックスに`README.md`が追加された状態になっている。

は、記念すべき最初のコミットをしよう。Gitはコミットをする時に、コミットメッセージが必要となる。最初のメッセージは慣例により`initial commit`とすることが多い。

```sh
git commit -m "initial commit"
```

これによりコミットが作成され、`README.md`はGitの管理下に入った。

状態を見てみよう。

```
git st
```

何も表示されないはずである。ロングバージョンのステータスも見てみよう。

```sh
$ git status
On branch master
nothing to commit, working tree clean
```

自分がいまmasterブランチにいて、何もコミットをする必要がなく、ワーキングツリーがきれい(clean)、つまりリポジトリが記憶している最新のコミットと一致していることを意味している。

## ファイルの修正