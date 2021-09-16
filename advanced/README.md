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

これにより、`test.txt`は最後にコミットした状態に戻る。

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

これで、先ほどの「最後のコミットからワーキングツリーのみ修正された状態」に戻る。

* log
* stash
* blame
* bisect
* cherry-pick
* tag
