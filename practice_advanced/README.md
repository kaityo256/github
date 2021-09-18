# Gitの操作(応用編)

## 目標

* `git amend`によりコミットが変更されることを確認する
* `git merge`の衝突を解決する
* `git rebase`により歴史を改変する
* `git rebase`の衝突を解決する
* `git bisect`を使ってみる

## 課題1: git amendによるコミット修正

### リポジトリのクローン

サンプル用のリポジトリをクローンせよ。

```sh
cd github
git clone git clone https://github.com/appi-github/amend-sample.git
cd amend-sample
```

### 歴史の確認

履歴を確認し、最新のコミットメッセージに打ち間違いがあることを確認せよ。

```sh
git log --oneline
```

### コミットの保存

修正する前に、現在の最新のコミットに別名をつけておこう。

```sh
git branch original_main
```

### コミットの修正

コミットメッセージを修正しよう。

```sh
git commit -amend -m "updates README.md"
```

### 歴史の修正を確認

歴史が修正されたことを確認しよう。

```sh
git log --oneline
```

### レポート課題

`git commit --amend`はコミットハッシュを変更する。先ほど、変更前のコミットに別名をつけておいたので、そこで歴史が分岐したことを確認しよう。以下のコマンドを実行した結果をレポートとして提出せよ。

```sh
git log --all --graph --oneline
```

## 課題2: git mergeによる衝突の解決

TODO:

## 課題3: git rebaseによる歴史改変

TODO:

## 課題4: git rebaseによる衝突の解決

### リポジトリのクローン

サンプル用のリポジトリをクローンせよ。

```sh
cd github
git clone https://github.com/appi-github/rebase-conflict-sample
cd rebase-conflict-sample
```

### ブランチの準備

`origin/branch`から`branch`を作成せよ。

```sh
git switch -c branch origin/branch
```

### 歴史の確認

現在の歴史が分岐していることを確認せよ。

```sh
git log --all --graph --oneline
```

### リベースの実行

`branch`から`main`に対してリベースを実行し、衝突が発生することを確認せよ。

```sh
git rebase main
```

### 状態の確認

現在の状態を確認せよ。

```sh
git status
```

特に、いまリベース中であること、どのコミットを処理中に衝突が起きたのか、衝突が起きたのはどのファイルかを確認すること。

### 衝突の解決

VSCodeで衝突状態にあるファイル(`text1.txt`)を修正し、衝突を解決せよ。

```sh
code .
```

`text1.txt`を開くと衝突箇所が表示されているので、`Accept Both Changes`をクリックするだけで良い。

### 解決をGitに伝える

解決が終わったら`git add`、`git commit`を実行し、Gitに衝突の解決を伝えよう。

```sh
git add text1.txt
git commit -m "f2"
```

コミット実行時に`detached HEAD`と表示されることに注意。

### リベースの続行

残りのリベースプロセスを続行しよう。

```sh
git rebase --continue
```

最後まで実行され、リベースが完了するはずだ。

### レポート課題

以下のコマンドでリベースが完了した状態の歴史を表示し、それをレポートとして提出せよ。

```sh
git log --oneline --graph
```

リベース後の歴史は期待通りとなっているか？それはどこを見るとわかるか？

## 課題5: git bisectの確認

### リポジトリのクローン

サンプル用のリポジトリをクローンせよ。

```sh
cd github
git clone https://github.com/appi-github/bisect-sample.git
cd bisect-sample
```

### バグの確認

`evenodd.sh`は、本来であれば入力された数値の偶奇を判定するコードであったが、いつのまにか全ての数字に`even`と答えるようになった。適当な数字を与えて実行し、確認せよ。

```sh
./evenodd.sh 1
./evenodd.sh 2
```

### ブランチの準備

`origin/root`から`root`を作成し、カレントブランチを`root`にせよ。

```sh
git switch -c root origin/root
```

### バグっていないことを確認

先ほどと同様に`evenodd.sh`を実行し、正しく実行されることを確認せよ。確認後、`main`ブランチに戻っておくこと。

```sh
git switch main
```

### `git bisect`の実行

少なくとも`root`ブランチでは正常に動作し、`main`ブランチでは問題があることがわかった。そこで、`git bisect`により「問題が初めておきたコミット」を発見しよう。以下を実行し、二分探索モードに入る。

```sh
git bisect start main root
```

### 状態の確認

現在の状態を確認せよ。

```sh
git status
```

特に、頭がとれた(`detached HEAD`)状態であること、二分探索モードであること、どうすればこのモードを抜けることができるか等について確認すること。

### good/bad判定

いま、Gitは適当なコミットが指すスナップショットをワーキングツリーとして展開している。この状態にバグがあるのか、それともないのかをGitに教えよう。

以下のコマンドを実行し、正しい結果が得られるか確認せよ。

```sh
./evenodd.sh 1
./evenodd.sh 2
```

正しい結果が帰ってきたら、

```sh
git bisect good
```

を実行せよ。間違っていたら

```sh
git bisect bad
```

を実行せよ。そのたびにGitは次の候補を持ってくるので、終了するまで上記の操作を繰り返すこと。Gitが「初めて問題が起きたらコミット」を見つけたら`コミットハッシュ is the first bad commit`という表示がなされるはずだ。

### ブランチの付与と二分探索モードの終了

このコミットにブランチをつけておこう。

```sh
git branch bug 先ほど見つけたコミットハッシュ
```

これでバグが入ったコミットに印をつけることができた。二分探索モードを抜けよう。

```sh
git bisect reset
```

### 自動チェックの確認

いちいちバグの有無を人力で確認し、`git bisect good/bad`を入力するのは面倒だ。「成功/失敗」を判定するスクリプトを使って、二分探索を自動化しよう。そのようなスクリプト`test.sh`が用意されている。

```sh
#!/bin/bash

if [ `./evenodd.sh 1` != 'odd' ]; then
  exit 1
fi

if [ `./evenodd.sh 2` != 'even' ]; then
  exit 1
fi
```

これは`evenodd.sh`に1と2を食わせて、`odd`と`even`が表示されるか確認し、どちらも正しければ成功(終了ステータス0)、そうでなければ失敗(終了ステータス1)を返すスクリプトだ。これを使って二分探索を自動化するには、`git bisect run`を用いる。

```sh
git bisect start main root
git bisect run ./test.sh
```

やはり`コミットハッシュ is the first bad commit`というメッセージが表示されるはずなので、それが先ほど`bug`というブランチをつけたコミットと同じものであることを確認しよう。

```sh
git branch -v
```

終わったら二分探索モードを抜けよう。

```sh
git bisect reset
```

### レポート課題

いま、`main`ブランチにいるはずだが、先ほどバグの入ったコミットにつけたブランチに入ろう。

```sh
git switch bug
```

いま、「初めてバグが入ったコミット」にいるはずなのだから、「このコミット」と「一つ前のコミット」の差分を見れば、バグが入った原因がわかるはずだ。以下を実行し、出力された内容をレポートとして提出せよ。

```sh
git diff HEAD^
```
