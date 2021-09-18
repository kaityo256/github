# Gitの操作(応用編)

## 目標

* `git bisect`を使ってみる
* `git rebase`の衝突を解決する

## 課題1: git rebase確認

### 1. リポジトリのクローン

サンプル用のリポジトリをクローンせよ。

```sh
cd github
git clone https://github.com/appi-github/rebase-conflict-sample
cd rebase-conflict-sample
```

### 2. ブランチの準備

`origin/branch`から`branch`を作成せよ。

```sh
git switch -c branch origin/branch
```

### 3. 歴史の確認

現在の歴史が分岐していることを確認せよ。

```sh
git log --all --graph --oneline
```

### 4. リベースの実行

`branch`から`main`に対してリベースを実行し、衝突が発生することを確認せよ。

```sh
git rebase main
```

### 5. 状態の確認

現在の状態を確認せよ。

```sh
git status
```

特に、いまリベース中であること、どのコミットを処理中に衝突が起きたのか、衝突が起きたのはどのファイルかを確認すること。

### 6. 衝突の解決

VSCodeで衝突状態にあるファイル(`text1.txt`)を修正し、衝突を解決せよ。

```sh
code .
```

`text1.txt`を開くと衝突箇所が表示されているので、`Accept Both Changes`をクリックするだけで良い。

### 7. 解決をGitに伝える

解決が終わったら`git add`、`git commit`を実行し、Gitに衝突の解決を伝えよう。

```sh
git add text1.txt
git commit -m "f2"
```

コミット実行時に`detached HEAD`と表示されることに注意。

### 8. リベースの続行

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
