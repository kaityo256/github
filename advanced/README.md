# Gitの使い方(応用編)

## Gitトラブルシューティング

Gitを使っていると、たまに「しまった！」と思うことがある。Gitに慣れていないとトラブルが起きた時に何が起きたかわからず、適切に対処することが難しい。以下ではありがちなトラブルとその対処について説明する。

### コミットメッセージを間違えた

Gitはコミットの際にメッセージをつけることが必須である。ちゃんとエディタで書く人もいるだろうが、コマンドラインから`git commit -m`でメッセージを書いてしまうことが多いだろう。その際、コミットの後に「あ！打ち間違えた！」と思うことがある。

たとえば`test.txt`を修正し、`git add`、`git commit`したとしよう。

```sh
git add test.txt
git commit -m "updaets test.txt"
```

そしてコミット直後に「あ！`updates`を打ち間違えている！」と気づくが、すでに歴史に間違いが刻まれてしまった。

```sh
$ git log --oneline
8f7d4f8 (HEAD -> main) updaets test.txt
78efaf0 initial commit
```

このままではとてもかっこ悪い歴史が残ってしまう。そこで、`git commit --amend`を実行することで、直前のコミットのコミットメッセージを修正することができる。そのまま実行するとエディタが開くが、`-m`も指定してメッセージを上書きするのが楽であろう。

```sh
git commit --amend -m "updates test.txt"
```

歴史を確認しよう。

```sh
$ git log --oneline
52304ef (HEAD -> main) updates test.txt
78efaf0 initial commit
```

無事にコミットメッセージが書き換えられた。

なお、ここで先ほどとコミットハッシュが変わっている(`8f7d4f8`→`52304ef`)ことに注意したい。`git commit --amend`によりコミットメッセージを修正すると、コミットハッシュが変わってしまう。`git rebase`の時と同様に歴史がおかしくなるため、`git push`した後には`git commit --amend`を実行してはならない[^push]。

[^push]: 個人開発であれば強制プッシュ(`git push -f`)するという手もあるが、GitHubに強制プッシュの履歴が残り、やはりあまりかっこよくない。そもそも`main`ブランチで作業するのがよくないため、常に別ブランチで作業するようにして、`main`ブランチにリベースしてコミットやメッセージを整理してからマージする習慣をつけたい。

### 修正を取り消したい

ファイルを修正したが、その修正をなかったことにしたい、ということがある。例えば、最後にコミットした状態から`test.txt`に修正が加えられたとしよう。`git diff`はこうなっている。

```sh
$ git diff
diff --git a/test.txt b/test.txt
index e965047..4f34f18 100644
--- a/test.txt
+++ b/test.txt
@@ -1 +1,2 @@
 Hello
+Modification to be undone
```

「Modification to be undone」という行が追加されている。これを取り消すには、`git restore ファイル名`とする。

```sh
git restore test.txt
```

これにより、`test.txt`は最後にコミットした状態に戻る。なお、`git restore`はオプションを指定しなかった場合`--worktree`が付く。これはワーキングツリーのファイルを修正する。`--worktree`は`-W`でも良い。

### ステージングを取り消したい

先ほどの修正をした後、`git add`までした状態を考える。

```sh
$ git diff --staged
diff --git a/test.txt b/test.txt
index e965047..5c936d2 100644
--- a/test.txt
+++ b/test.txt
@@ -1 +1,2 @@
 Hello
+Modification to be undone
```

ステージングした状態を取り消すには`git restore --staged ファイル名`とする。

```sh
git restore --staged test.txt
```

これで、先ほどの「最後のコミットからワーキングツリーのみ修正された状態」に戻る。`--staged`は`-S`でも良い。

あまりないと思うが、ワーキングツリーとインデックス両方に修正がある場合は`-W -S`で両方一度に取り消すことができる。

```sh
$ git status -s
MM test.txt      # ワーキングツリーとインデックス両方に修正がある

$ git restore -W -S test.txt # 両方一度に取り消し
```

### `git checkout`は使わない

`git switch`と`git restore`はGitのバージョン2.23.0から追加された機能であり、それまでは`git checkout`がその役目を担っていた。

例えば以下は同じ意味だ。

```sh
git checkout feature
git switch feature
```

また、ファイルの修正も`git checkout`でできる。以下は同じ意味だ。

```sh
git checkout -- test.txt
git restore --staged test.txt
```

もともと、`git checkout`に役目が多すぎたためにコマンドが分けられた背景がある。現在、`git checkout`を使う必要はほとんどない。また、`git switch`と異なり、`git checkout`は直接コミットハッシュを指定することができる。

例えば、いまカレントブランチが`main`であり、コミット`9b662ef`を指している状態であるとしよう。

```sh
$ git log --oneline
9b662ef (HEAD -> main) test
```

この状態で`9b662ef`を指定して`git checkout`すると、`HEAD`がブランチではなく、直接コミットハッシュを指す「detached HEAD」状態となる。

```sh
$ git checkout 9b662ef
Note: switching to '9b662ef'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at 9b662ef test
```

ブランチを介さないでGitを操作するのは事故のもとである。一方、`git switch`は直接コミットを指定することはできず、コミットハッシュとブランチ名を同時に指定する必要がある。

```sh
$ git switch -c newbranch 9b662ef
Switched to a new branch 'newbranch'
```

したがって、`git checkout`の代わりに`git switch`を使った方が良い。同様な理由でファイルの修正を元に戻すのも`git restore`を使った方が良い。古い本やサイトには、まだ`git checkout`を使う方法が説明されていたりするので注意が必要だ。

### メインブランチで作業を開始してしまった

Gitでは原則としてメインブランチでは作業せず、必ずフィーチャーブランチを切って作業する。ところが、ファイルを修正した後で「あっ！メインブランチで作業してた！」と気が付いたとしよう。そんな時は`git stash`を使う。`git stash`はコミットを作らずに変更を退避するコマンドだ。

今、`main`ブランチにいるまま`test.txt`を結構修正してしまった状態にある。

```sh
$ git status
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   test.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

この状態で`git stash`を実行すると、最後のコミットからの修正が退避される。

```sh
$ git stash  # 修正が退避される
Saved working directory and index state WIP on main: 57222d5 update

$ git status # カレントブランチはきれいな状態に戻る
On branch main
nothing to commit, working tree clean
```

`git stash`はスタックになっており、どんどん修正を積み上げることができる。積み上げた修正は`git stash list`で見ることができる。

```sh
$ git stash list
stash@{0}: WIP on main: 57222d5 update
```

積んだ修正は`git stash pop`で適用できる。新しいブランチを切ってから適用しよう。

```sh
$ git switch -c feature
Switched to a new branch 'feature'

$ git stash apply pop
On branch feature
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   test.txt

no changes added to commit (use "git add" and/or "git commit -a")
Dropped refs/stash@{0} (171f9ddd0c02ed7e7ed9105aa9ef30f3553aa742)
```

これにより、あたかも「最初から`feature`ブランチを切ってから修正をした」ような状態となった。あとはキリの良いところまで作業してコミットし、`main`ブランチにマージするなりその前にリベースするなりすれば良い。うっかりメインブランチで作業を開始しがちな人(例えば私)は覚えておきたいコマンドだ。

なお、`git stash`を実行するたびに修正が詰みあがっていく。それぞれに`stash@{0}`、`stash@{1}`という名前がつき、`git stash apply`により名前を指定して適用することもできる。しかし、その場合は適用した修正がスタックに残るため、後で`git stash drop`で消さなければならない。一方、`git stash pop`は、最後に積んだ修正を適用し、その修正をスタックから削除する。

あまり積むと後で見てわからなくなるので、原則として`git stash`は`git stash pop`と対で利用すると良い。

### プッシュしようとしたらリジェクトされた

あなたは家で作業をして、一段落したのでコミット、プッシュしてから寝ようとしたら、無情にも`rejected`というメッセージが出て拒否された。

```sh
To /URL/to/test.git
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to '/URL/to/test.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

そこであなたは、大学で修正をプッシュしたのに、家のリポジトリで`git fetch`、`git merge`するのを忘れていたことに気が付く。もしプロジェクトがバージョン管理されておらず、プッシュではなく単に大学のサーバにアップロードをしていたら、大学での修正は失われてしまっていたかもしれない。しかし、幸運なことにあなたはGitを使っており、大学で行った修正がGitHubに、家で行った修正がローカルにある。この状態で、まず学校の修正をローカルに持ってこよう。

```sh
git fetch
```

これにより、ローカルの`origin/main`が大学で行った作業を反映したコミットを指すようになった。ローカルの`main`と、`origin/main`は、同じコミットから歴史が分岐した状態だ。これを一つにするにはマージすれば良い。

```sh
git merge origin/main
```

もし衝突したら、適切に修正して`git add`、`git commit`すれば良い。これで両方の修正を取り込んだ新たな歴史ができた。この歴史は、リモートの`main`と歴史を共有しているので、そのまま`git push`ができる。

```sh
git push # 問題なく実行できる
```

家と大学など、複数の場所で開発を進めることはよくあるであろう。その時、一方でpushを忘れてしまったり、fetch/mergeするのを忘れてコミットしてしまったりすると、`git push`ができずエラーが起きる。その場合は、慌てずに`git fetch`、`git merge origin/main`してから`git push`すれば良い。

### リベースしようとしたら衝突した

## その他の便利なコマンド

### この部分はいつ誰が書いた？(`git blame`)

多人数開発をしていると、頻繁に「この部分はいつ誰が書いたんだ？」と思うことであろう。個人開発をしていてもたまに「これ誰が書いたんだよ！」と思うことが多い(もちろん自分である)。そんな時に便利なコマンドが`git blame`だ。

いま、こんなPythonスクリプトがあったとしよう。

```py
def func1():
    print("Hello func1")


def func2():
    print("Hello func2")


if __name__ == '__main__':
    print("Hello")
    func1()
    func2()
```

`git blame`にファイル名を指定すると、どの行が、いつ、誰によって修正されたかが表示される。

```sh
$ git blame test.py
56127fbb (H. Watanabe 2021-09-17 21:22:49 +0900  1) def func1():
56127fbb (H. Watanabe 2021-09-17 21:22:49 +0900  2)     print("Hello func1")
56127fbb (H. Watanabe 2021-09-17 21:22:49 +0900  3)
56127fbb (H. Watanabe 2021-09-17 21:22:49 +0900  4)
26bdec20 (H. Watanabe 2021-09-17 21:23:31 +0900  5) def func2():
26bdec20 (H. Watanabe 2021-09-17 21:23:31 +0900  6)     print("Hello func2")
26bdec20 (H. Watanabe 2021-09-17 21:23:31 +0900  7)
26bdec20 (H. Watanabe 2021-09-17 21:23:31 +0900  8)
^fea5775 (H. Watanabe 2021-09-17 21:22:08 +0900  9) if __name__ == '__main__':
^fea5775 (H. Watanabe 2021-09-17 21:22:08 +0900 10)     print("Hello")
26bdec20 (H. Watanabe 2021-09-17 21:23:31 +0900 11)     func1()
26bdec20 (H. Watanabe 2021-09-17 21:23:31 +0900 12)     func2()
```

これを見れば、`func1`や`func2`がいつ作られたかがわかる。`git blame`には行を指定したり、コミットハッシュを指定したりするなど多くのオプションがあるが、エディタや統合環境と一緒に使うことがほとんどであろう。

個人開発でバグに気が付いた時、どの関数がどの順番で作られたかは非常に有用な情報なので、個人開発でも役に立つ。

### このバグが入ったのはいつだ？(`git bisect`)

プログラムをずっと開発していて、ある時にバグに気が付いたとする。最近入れたバグならデバッグは比較的容易だが、ずいぶん前に入れてしまったバグが今になって顕在化した場合はやっかいだ。三日前の自分は全くの他人であり、そのバグの振る舞いからどこでどういう経緯でバグが入ったかをすぐに特定することは難しいであろう。しかし、少なくとも昔はバグが入っていなかった時があり、現在はバグっているのだから、どこかに「バグが混入したコミット」が存在するはずだ。これを二分探索で調べるためのコマンドが`git bisect`である。

今、バグが入ったことが気が付いたブランチがある。例えばカレントブランチである`main`が指しているコミットはバグっているとしよう。そして、適当に探した昔のコミット`e34d733`はバグってなかったことが確認できたとしよう。バグはこの二つのコミットの間にある。二分探索を開始しよう。`git bisect start 問題のある場所 問題のない場所`を実行する。場所はコミットハッシュやブランチで指定できる。

```sh
git bisect start main e34d733
```

これによりGitは二分探索モードとなり、まずは適当なコミットを持ってくる。このコミットがバグっているかどうかGitに教えてやろう。もしバグっていたら

```sh
git bisect bad
```

もし問題がなければ

```sh
git bisect good
```

を実行する。その度にGitは問題の範囲を狭めていき、最終的にバグが混入したコミットを見つけてくれる。

```sh
$ git bisect bad
e6348e408b57fdb42eb1281cb77b5c331cd400e7 is the first bad commit
(snip)
```

上記は、最後に`git bisect bad`を実行したら、それによりGitが問題箇所を特定し、`e6348e4`が問題の入ったコミットだよ、と教えてくれた。ここで`git diff`を取ったりいろいろできるが、とりあえず「バグった印」としてブランチをつけて置くと良い。

```sh
git branch bug
```

これで、問題の入ったコミットに`bug`というブランチがついた。二分探索モードを抜けよう。

```sh
git bisect reset
```

後は先ほどつけた`bug`の時点に`git switch`で戻って詳細を調べれば良い。

今回は手動で`good`/`bad`判定をしたが、判定を自動実行するシェルスクリプトが書けるなら、上記の動作を自動化できる。例えば現在のリポジトリの状態に対して、問題がなければ成功(終了ステータス0を返す)、問題があれば失敗(終了ステータス1を返す)ような`test.sh`というシェルスクリプトがあるなら、

```sh
git bisect start main e34d733
git bisect run ./test.sh
```

と`git bisect run`コマンドにそのスクリプトを渡すだけで自動的に二分探索してくれる。一般に二分探索は非常に効率が良く、数回も実行すれば問題のコミットを特定できるが、いちいち`git bisect good/bad`と入力するのも面倒だし、また人力だと間違えることもあるので、可能なら自動化したい。これらについては後に演習で実際に体験する。
