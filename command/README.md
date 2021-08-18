# Gitの使い方(基礎編)

## はじめに

通常、パソコンを操作する際はファイルをマウスでクリックして選択、ダブルクリックで対応するアプリケーションで開いて修正して保存、などとしていることだろう。また、スマホやタブレットは指でタッチして様々な操作を行うであろう。この際、アイコンやボタンなど、操作対象がグラフィカルに表現されたものを、マウスやタッチで操作するインタフェースを **グラフィカルユーザインタフェース(Graphical User Interface, GUI)** と呼ぶ。

一方、主にキーボードからコマンドを入力してコンピュータを操作する方法もある。こちらは命令(コマンド)を一行(ライン)ずつ受け付け、解釈して実行することから **コマンドラインインタフェース(Command-line Interface, CLI)**　と呼ばれる。最初からGUIツールとして作られているWordやPowerPoint等と異なり、Gitはコマンドラインツールとして作られている。GitにはGit Guiや、SourceTreeなどのGUIツールも用意されているが、これはCLIにGUIの「皮」をかぶせたものだ。Gitを「ただ使う」だけであればGUIツールを使えばよいが、本講義の目的はGitを使うことではなく、Gitというバージョン管理ツールを理解することだ。また、GUIツールを使っていて何かトラブルが起きた場合、それがコマンドに起因するものなのか、GUIの「皮」に起因するものなのかを切り分けなければならず、そのためにはコマンドライン操作を理解していなければならない。そこで、まずはコマンドライン操作について学ぶ。

なお、コマンドライン操作において最も注目して欲しいのはエラーメッセージだ。GUIではそもそも「許されない操作」ができないように設計されていることが多いが、コマンドラインでは頻繫に「許されない操作」をしてしまい、「それはできないよ」というメッセージが表示されることだろう。これをエラーメッセージと呼ぶ。エラーの多くは平易な英語で書いてあるので、ちゃんと読めば何が起きたか、そして次に何をすれば良いかがわかるはずだ。

## Unixコマンド

映画などでハッカーが何やら黒い画面を見ながらキーボードをものすごい勢いで叩いているのを見たことがあるだろう。この「黒い画面」はターミナル[^terminal]と呼ばれ、ユーザからの指示をコンピュータに入力するためのものだ。Gitはコマンドラインツールであるから、まずはコマンドラインの使い方に慣れなければならない。コマンドラインを入力するのはこのターミナルという黒い画面であるから、Gitを使うためにはこの「黒い画面」と友達にならなければならない。ターミナルへの命令はコマンドを通じて行われるが、このコマンドはオペレーティング・システムの種類によって異なる。GitはLinuxの開発のために作られた経緯があるため、Linux上で動作することを前提に作られた。LinuxはUnixというオペレーティング・システム(Operating System, OS)を参考にして作られたため、Unixの直系の子孫ではないが、操作やコマンドが似ている。Unixは極めて古いOSであり、macOSもUnixの子孫である。Unixの子孫や、Unixと操作が似ているOSをまとめてUnix系システムと呼ぶ。Unix系システムでは、Unixコマンドと呼ばれるコマンド群を用いて操作する。以下では、Gitの操作に最低限必要なUnixコマンドについて説明する。ターミナルはWindowsのGit Bashを想定するが、WSL2のUbuntuやMacのターミナルでも同様である。

[^terminal]: より正確に言えばターミナル(端末)エミュレータのこと。もともと大きなホストコンピュータに、たくさんの端末がぶら下がっており、複数の人が一つのマシンに命令を入力していた。この「端末」をエミュレートしたものが端末エミュレータである。

### コマンドプロンプト

多くのシェルでは、ユーザからの入力を待っている時に`$`が表示され、その隣でカーソルが点滅した状態となる。

```sh
$ |
```

これをコマンドプロンプト、あるいは単にプロンプトと呼び、コマンドが入力可能であることを表している。このプロンプトにコマンドを入力し、エンターキーを押すとその命令が処理される。コマンドに何か値を渡したいことがある。例えばファイルを削除するコマンドは`rm`だが、どのファイルを削除するか教えてやる必要がある。このように、コマンドに渡す値を **引数(ひきすう)** と呼ぶ。一方、コマンドの動作を変えるような引数を **オプション(option)** と呼び、`-`や`--`で始まることが多い。

WindowsやMacでは、複数のファイルをまとめるものをフォルダと呼ぶが、Unix系システムでは　**ディレクトリ(directory)** と呼ぶ。

この命令が実行されるディレクトリ、すなわち「いま自分がいるディレクトリ」をカレントディレクトリ、もしくはワーキングディレクトリと呼ぶ。特に、ターミナルを開いた直後のカレントディレクトリを **ホームディレクトリ(Home directory)** と呼ぶ。

### `ls`


カレントディレクトリに存在するディレクトリやファイルを表示するコマンドが`ls`だ[^ls]。

[^ls]: `list`の略だと思われる。

```sh
$ ls
```

上記は、`$ `というコマンドプロンプトに、`ls`という文字を入力し、エンターキーを押す、という意味だ。ユーザが入力するのは`ls`(+エンターキー)だけであり、`$`は入力しないことに注意。

すると、例えば以下のような表示がされる。

```sh
$ ls
dir1/  dir2/  file1.txt  file2.txt
```

これは、カレントディレクトリに、`dir1`、`dir2`というディレクトリと、`file1.txt`、`file2.txt`というファイルがあるよ、という意味だ。ディレクトリは名前の右側に`/`がついていることが多いが、それはシェルの設定によるため、ついていない場合もある。

![ls](fig/ls.png)

`ls`に`-l`というオプションを渡すと、結果をリスト表示する。

```sh
$ ls -l
total 0
drwxr-xr-x 1 watanabe 197121 0  8月 17 21:03 dir1/
drwxr-xr-x 1 watanabe 197121 0  8月 17 20:32 dir2/
-rw-r--r-- 1 watanabe 197121 0  8月 17 20:33 file1.txt
-rw-r--r-- 1 watanabe 197121 0  8月 17 20:33 file2.txt
```

リスト表示では、ファイル名の他に、そのファイルの読み書きの許可、所有者、日付などが表示される。このように、「コマンドの直接の目的語」が引数、「コマンドの振る舞いを変える」のがオプションである。

引数としてカレントディレクトリの下にあるディレクトリ(サブディレクトリと言う)を指定することで、そのディレクトリの中身を表示することもできる。

```sh
$ ls dir1
file3.txt
```

存在しないファイルやディレクトリを指定すると、そんなファイルは知らないよ、というエラーが出る。

```sh
$ ls non-existing-dir
ls: cannot access 'non-existing-dir': No such file or directory
```

頭に`.`がついているファイルやディレクトリは隠しファイル、隠しディレクトリとなり、デフォルトでは表示されない。それを表示するには`ls -a`オプションを使う。

```sh
$ ls -a
./  ../  dir1/  dir2/  file1.txt  file2.txt
```

新たに表示された`.`と`..`は、それぞれカレントディレクトリと親ディレクトリの別名だ。どちらも良く使うので覚えておきたい。

### `cd`

カレントディレクトリを変更するコマンドが`cd`だ[^cd]。`cd`の後にディレクトリ名を指定すると、カレントディレクトリがそこに移動する。ダブルクリックでフォルダを開いた時には、そのフォルダの中身が自動的に表示された。しかし、コマンドラインインタフェースではそんな親切なことはしてくれない。カレントディレクトリをそのディレクトリに変更しておしまいである。中身を表示したければ`cd`した後に`ls`を実行しよう。

[^cd]: `change directory`の略だと思われる。

```sh
$ cd dir1
$ ls
file3.txt
```

![cd](fig/cd.png)

存在しないディレクトリに移動しようとしたら、エラーが出る。

```sh
$ cd non-exisiting-dir
bash: cd: non-exisiting-dir: No such file or directory
```

これは「`non-exisiting-dir`というディレクトリに`cd`しようとしたけど、そんなファイルもディレクトリも無いよ」というエラーだ。ファイルに対して`cd`しようとしてもエラーとなる。

```sh
$ cd file1.txt
bash: cd: file1.txt: Not a directory
```

これは「`file1.txt`はディレクトリではないので`cd`できないよ」というエラーだ。

`cd`コマンドを引数無しで実行すると、ホームディレクトリに戻る。重要なコマンドなので覚えておこう。

`..`は親ディレクトリを表すため、`cd ..`を実行するとカレントディレクトリが一つ上に移動する。

```sh
$ ls
dir1/  dir2/  file1.txt  file2.txt
$ cd dir1 # dir1に移る
$ ls
file3.txt
$ cd ..   #一つ上に戻る
$ ls
dir1/  dir2/  file1.txt  file2.txt
```

### `mkdir`

ディレクトリを作るには`mkdir`を使う[^mkdir]。

```sh
$ ls
dir1/  dir2/  file1.txt  file2.txt

$ mkdir dir3 # dir3を作成
$ ls
dir1/  dir2/  dir3/  file1.txt  file2.txt # dir3/が増えた
```

[^mkdir]: `make directory`の略であろう。

## Gitコマンド

* config
* init, add, commit
* checkout, merge, branch
* status
* .gitignore
* VSCodeの設定

* 説明メモ
  * git addには三種類の意味がある
    * リポジトリの管理下にないファイルを管理下に置く
    * リポジトリの管理下にあるファイルをステージングする
    * Gitにconflictの解消について教える

## 余談：データベース「ふっとばし」スペシャリスト