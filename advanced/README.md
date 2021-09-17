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

* blame
* bisect
* cherry-pick
* tag
