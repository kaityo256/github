# Gitの操作(応用編)

## 目標

* `git amend`によりコミットが変更されることを確認する
* `git merge`の衝突を解決する
* `git rebase`により歴史を改変する
* `git rebase`の衝突を解決する
* `git bisect`を使ってみる

## 課題1: git amendによるコミット修正

コミットメッセージでうっかりタイポしてしまった。恥ずかしいので修正しよう。

### Step 1: リポジトリのクローン

最初に、作業用のディレクトリ`github`を作ろう。Git Bashで、以下を実行せよ。

```sh
cd
mkdir github
cd github
```

プロンプトのカレントディレクトリ表示が`/z/github/`となっていることを確認せよ。

以下の演習は、全てのこの`github`ディレクトリ以下で作業する。

次にサンプル用のリポジトリをクローンせよ。

```sh
git clone https://github.com/appi-github/amend-sample.git
cd amend-sample
```

なお、`git clone`実行時にGitHubへのアクセス権を求められたら、URLの入力を間違えている。処理を中断し、もう一度正しいURLを入力せよ。

### Step 2: 歴史の確認

履歴を確認し、最新のコミットメッセージに打ち間違いがあることを確認せよ。

```sh
git log --oneline
```

### Step 3: コミットの保存

修正する前に、現在の最新のコミットに別名をつけておこう。

```sh
git branch original_main
```

### Step 4: コミットの修正

コミットメッセージを修正しよう。

```sh
git commit --amend -m "updates README.md"
```

### Step 5: 歴史の修正を確認

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

ある詩人が、ロバの上で詩を作っていたが、「僧は推す、月下の門」とするか、「僧は敲く、月下の門」とするか迷って、都の長官、韓愈の列に突っ込んでしまった。`git merge`でどちらにするか決断して上げよう。

### Step 1: リポジトリのクローン

サンプル用のリポジトリをクローンせよ。

```sh
cd
cd github
git clone https://github.com/appi-github/merge-sample.git
cd merge-sample
```

### Step 2: ブランチの準備

`origin/knock`が存在することを確認せよ。

```sh
git branch -vva
```

`origin/knock`から`knock`ブランチを作成せよ。

```sh
git branch knock origin/knock
```

### Step 3: 差分確認

`main`ブランチと、`knock`ブランチの差分を確認せよ。

```sh
git diff knock
```

### Step 4: マージと、マージの中止

`main`ブランチから、`knock`ブランチをマージせよ。

```sh
git merge knock
```

`poetry.txt`で衝突が起きたはずだ。中身を確認せよ。

```sh
cat poetry.txt
```

一度マージを中止して元に戻ることを確認しよう。

```sh
git merge --abort
cat poetry.txt
```

### Step 5: マージと衝突の解決

次は衝突を解決し、マージを実行しよう。

```sh
git merge knock
```

衝突がおきるはずなので、韓愈のアドバイス通り「推」ではなく「敲」の方を残して保存せよ。VS Codeの「フォルダーを開く」でこのディレクトリ(`/z/github/merge-sample`)を開き、その上で`poetry.txt`を開いて修正せよ。

その後、

```sh
git add poetry.txt
git commit -m "knock"
```

を実行し、マージを完了させよ。

### レポート課題

以下のコマンドでマージが完了した状態の歴史を表示し、それをレポートとして提出せよ。

```sh
git log --all --graph --oneline
```

## 課題3: git rebaseによる歴史改変

Bobは、姉であるAliceの大事なアイスを食べてしまった。このままでは大目玉だ。`git rebase`により歴史を改変し、Bobにアリバイを作ってあげよう。

### Step 1: リポジトリのクローン

サンプル用のリポジトリをクローンせよ。

```sh
cd 
cd github
git clone https://github.com/appi-github/rebase-history-sample.git
cd rebase-history-sample
```

### Step 2: 歴史の確認

現在の歴史を確認しよう。

```sh
$ git log --oneline
b6f729a (HEAD -> main, origin/main, origin/HEAD) Bob headed off to school.
f1ecd8d Ice cream was gone.
de96bad The ice cream was still there.
9e6dca2 (origin/start) The two woke up.
```

時間は「下から上」に流れている。したがって、現在の歴史は

1. AliceとBobが目を覚ます
2. Aliceがアイスを確認する
3. Aliceがアイスが無くなっていることに気づく
4. Bobが学校へ行く

となっている。`alice.txt`と`bob.txt`には、それぞれの行動が記されている。差分を見てみよう。

```sh
git diff HEAD^
git diff HEAD^ HEAD^^
git diff HEAD^^ HEAD^^^
```

上記は歴史を一つずつさかのぼっている。「ボブが学校へ行く」「Aliceがアイスが無くなっていることに気づく」「Aliceがアイスを確認する」という順番になっている。

さて、このままではBobがAliceのアイスを食べたことがバレてしまい、大目玉をくらう。`git rebase`で歴史を改変してアリバイを作ってあげよう。

### Step 3: ブランチの作成

二人が起きた時点にブランチを作る。

```sh
git branch start origin/start
```

### Step 4: コミットの入れ替え

`main`ブランチから`start`ブランチに対してリベースをする。

```sh
git rebase -i start
```

こんな画面が表示されたはずだ。

```txt
pick de96bad The ice cream was still there.
pick f1ecd8d Ice cream was gone.
pick b6f729a Bob headed off to school.
```

これを順序を入れ替えて以下の状態にせよ。

```txt
pick b6f729a Bob headed off to school.
pick de96bad The ice cream was still there.
pick f1ecd8d Ice cream was gone.
```

Vimで入れ替えるには、以下の手順を取る。

1. 「j」と「k」でカーソルを上下に移動し、「Bob headed off to school.」の行に合わせる
2. 「dd」と入力し、3行目を切り取る
3. 「k」を数回入力し、カーソルを一番上に移動する
4. 「P (シフトキーを押しながらp)」を入力し、行の一番上に先ほど切り取った行を貼り付ける
5. 「ZZ (シフトキーを押しながらZを二回)」を入力し、歴史改変を終了する。

### Step 5: 改変された歴史の確認

歴史が無事に改変されたか確認しよう。

```sh
$ git log --oneline
469ce60 (HEAD -> main) Ice cream was gone.
65552f7 The ice cream was still there.
650e6bd Bob headed off to school.
9e6dca2 (origin/start, start) The two woke up.
```

歴史は以下のように改変された。

1. AliceとBobが目を覚ます
2. Bobが学校へ行く
3. Aliceがアイスを確認する
4. Aliceがアイスが無くなっていることに気づく

Bobが学校に行った後にアイスがあることが確認されているのだから、Bobはアイスを食べることができない。すなわちアリバイが成立し、Aliceに怒られることは無くなった。

`alice.txt`と`bob.txt`には、それぞれの行動が記されている。差分を見てみよう。

```sh
git diff HEAD^
git diff HEAD^ HEAD^^
git diff HEAD^^ HEAD^^^
```

これで一つずつ歴史をさかのぼることができる。「アリスがアイスがないことに気づく」「アリスがアイスの存在を確認する」「ボブが学校に行く」という歴史になっていることがわかるだろう。

### レポート課題

歴史を改変した後に、以下のコマンドを実行した結果をレポートとして提出せよ。

```sh
git log --oneline
```

## 課題4: git rebaseによる衝突の解決

### Step 1: リポジトリのクローン

サンプル用のリポジトリをクローンせよ。

```sh
cd
cd github
git clone https://github.com/appi-github/rebase-conflict-sample.git
cd rebase-conflict-sample
```

### Step 2: ブランチの準備

`origin/branch`から`branch`を作成せよ。

```sh
git switch branch
```

プロンプトのカレントブランチ表示が`branch`となっていることを確認すること。

本来、`git switch branch`というコマンドは、すでに存在している`branch`というブランチをカレントブランチにする、という命令だが、Gitはもし`branch`が存在せず、`origin/branch`が存在する場合、自動的に`origin/branch`から`branch`を作成し、`branch`をカレントブランチとする。

明示的に`origin/branch`から`branch`を作成し、`branch`をカレントブランチとするコマンドは

```sh
git switch -c branch origin/branch
```

であり、先程の`git switch branch`はその省略形になっている。

### Step 3: 歴史の確認

現在の歴史が分岐していることを確認せよ。

```sh
git log --all --graph --oneline
```

### Step 4: リベースの実行

`branch`から`main`に対してリベースを実行し、衝突が発生することを確認せよ。

```sh
git rebase main
```

### Step 5: 状態の確認

現在の状態を確認せよ。

```sh
git status
```

特に、いまリベース中であること、どのコミットを処理中に衝突が起きたのか、衝突が起きたのはどのファイルかを確認すること。

### Step 6: 衝突の解決

VSCodeで衝突状態にあるファイル(`text1.txt`)を修正し、衝突を解決せよ。VS Codeの「フォルダーを開く」から`/z/github/rebase-conflict-sample`を開き、その上で`text1.txt`を開くと衝突箇所が表示されている。このような表示になっているはずだ。

```txt
Text1:
<<<<<<< HEAD
The way to get started is to quit talking and begin doing.
It's kind of fun to do the impossible.
The flower that blooms in adversity is the rarest and most beautiful of all.
=======
If you can dream it, you can do it.
>>>>>>> 8f1d6d2 (f2)
```

この`<<<<<<< HEAD`や`=======`、`>>>>>>> 8f1d6d2 (f2)`を削除して、以下のような文章を完成させよう。

```txt
Text1:
The way to get started is to quit talking and begin doing.
It's kind of fun to do the impossible.
The flower that blooms in adversity is the rarest and most beautiful of all.
If you can dream it, you can do it.
```

もし、「Accept Current Change | Accept Incoming Change | Accept Both Changes | Compare Changes」という表示がされていた場合は、「Accept Both Changes」をクリックすると自動的に両方の修正を取り込むことができる。

修正が終わったらファイルを保存すること。

### Step 7: 解決をGitに伝える

解決が終わったら`git add`、`git commit`を実行し、Gitに衝突の解決を伝えよう。

```sh
git add text1.txt
git commit -m "f2"
```

コミット実行時に`detached HEAD`と表示されることに注意。

### Step 8: リベースの続行

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

## 発展課題: git bisectの確認

数の偶奇を判定するスクリプト`evenodd.sh`を開発していたが、いつの間にか全ての数字に`even`と答えるようになってしまった。`git bisect`による二分探索でどこでバグが入ったか調べよう。

### Step 1: リポジトリのクローン

サンプル用のリポジトリをクローンせよ。

```sh
cd
cd github
git clone https://github.com/appi-github/bisect-sample.git
cd bisect-sample
```

### Step 2: バグの確認

`evenodd.sh`は、本来であれば入力された数値の偶奇を判定するコードであったが、いつのまにか全ての数字に`even`と答えるようになった。適当な数字を与えて実行し、確認せよ。

```sh
./evenodd.sh 1
./evenodd.sh 2
```

### Step 3: ブランチの準備

`origin/root`から`root`を作成し、カレントブランチを`root`にせよ。

```sh
git switch root
```

カレントブランチが`root`になっていることを確認すること。

先に説明した通り、これは

```sh
git switch -c root origin/root
```

と同じ意味となる。

### Step 4: バグっていないことを確認

先ほどと同様に`evenodd.sh`を実行し、正しく実行されることを確認せよ。確認後、`main`ブランチに戻っておくこと。

```sh
git switch main
```

### Step 5: `git bisect`の実行

少なくとも`root`ブランチでは正常に動作し、`main`ブランチでは問題があることがわかった。そこで、`git bisect`により「問題が初めておきたコミット」を発見しよう。以下を実行し、二分探索モードに入る。

```sh
git bisect start main root
```

### Step 6: 状態の確認

現在の状態を確認せよ。

```sh
git status
```

特に、頭がとれた(`detached HEAD`)状態であること、二分探索モードであること、どうすればこのモードを抜けることができるか等について確認すること。

### Step 7: good/bad判定

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

### Step 8: ブランチの付与と二分探索モードの終了

このコミットにブランチをつけておこう。

```sh
git branch bug 先ほど見つけたコミットハッシュ
```

なお、「先程見つけたコミットハッシュ」のところには、初めて問題が起きたコミットのコミットハッシュを入力するが、全ての桁を入力する必要はなく、冒頭の6〜7桁を入力すれば良い。

これでバグが入ったコミットに印をつけることができた。二分探索モードを抜けよう。

```sh
git bisect reset
```

### Step 9: 自動チェックの確認

いちいちバグの有無を人力で確認し、`git bisect good/bad`を入力するのは面倒だ。「成功/失敗」を判定するスクリプトを使って、二分探索を自動化しよう。そのようなスクリプト`test.sh`が用意されている。`cat`で見てみよう。以下のコマンドを実行せよ。

```sh
cat test.sh
```

以下のような表示がされるはずだ(これをコマンドとして入力する必要はない)。

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

## 余談：OSの系譜とドラマ

WordやPowerPointなど、普段使うアプリケーションは、オペレーティング・システムの上で動作している。オペレーティング・システム(OS)は、基本ソフトとも呼ばれ、ハードウェアとアプリケーションの間で動作する。その存在を意識することは少ないが、PCやスマホ、タブレットなどのデバイスの使い勝手を大きく左右する重要なソフトウェアである。普段よく目にするOSは、PCならWindowsかmacOS、スマホならAndroidかiOSであろう。WindowsはMicrosoft、macOSやiOSはApple、AndroidはGoogleが開発している。OSは日々進化しており、どんどん新しい機能が追加されていく。その進化に乗り遅れたOSは市場から淘汰されてしまうため、その裏には様々なドラマがある。そのうちWindows 95とmacOSの話を紹介したい。

1980年代、MS-DOS、そしてWindows 3.1というOSにより大きなシェアを獲得したMicrosoftは、二つのOSの開発を進めていた。一つはコンシューマ向けの「使いやすい」OS、もう一つはサーバ向けの「信頼性の高い」OSだ。後者はWindows NTとして完成するが、その時の筆舌に尽くしがたい「デスマーチ」の様子が「闘うプログラマー」に記述があるので興味のある人は読んで見ると良いであろう。さて、もう一つの「家庭用」のOS開発プロジェクトは「カイロ」という名前で進められていたが、進捗が悪かった。そこで、「シカゴ」という別プロジェクトが走り出す。情報科学で博士号を取ったような人ばかりで構成された「カイロ」と、職人プログラマを寄せ集めたような「シカゴ」、どちらがMicrosoftの次世代OSを担うか、ビル・ゲイツの前で「裁判」が行われる。「カイロ」は400ページに渡る資料を用意し、いかに「シカゴ」がダメかを論じたのに対して、「シカゴ」チームはただ一枚のCD-ROMを取り出し、開発中のOSを実演してみせた。両方の言い分を聞いたビル・ゲイツは即座にカイロのキャンセルを決断。その時にCD-ROMに入っていたOSは、後に大ブームを巻き起こすことになるWindows 95のベータ版であった。負けた「カイロ」を率いていたリーダー、ジム・オールチンは、後にWindows Vistaの開発を率いることになり、そこにも面白いストーリーがあるのだが、ここでは割愛しよう。

macOS開発のドラマも面白い。1984年、Appleはグラフィックを重視するコンピュータ、Macintoshを発売する。MS-DOS等、他のOSがコマンドラインインタフェースを採用することがほとんどであった当時、マウスで直感的に操作できるグラフィカルなシェルを搭載したOSは画期的であり、GUIという概念の普及に大きく貢献した。OSは「System」と呼ばれ、ハードと一体で開発されていた。Systemは優れたOSであったが、長く開発が続けられるうちに設計が古くなり、不安定になっていった。Microsoftと同様に、1980年代後半から次世代OSの必要性を痛感していたAppleは「コープランド(copland)」というプロジェクトを立ち上げ、新しいOSの開発をすすめる。しかし、必要と思われる機能を際限なく仕様に追加していった結果、プロジェクトは収拾がつかなくなり、AppleはOSの自社開発を断念、外部から調達することを決断する。次世代Mac OSの候補は二つ、かつてAppleで開発責任者を務めたジャン＝ルイ・ガセーが独立し設立したBe社が開発したBeOSと、Appleの創業者でありながら、自らが引き抜いたCEOにAppleを追い出されたスティーブ・ジョブズが設立したNeXT社が開発したOPENSTEPである。ガセーは勝利を確信していたフシがあり、プレゼンに力を入れなかったが、ジョブズは完璧なプレゼンを行い、結果、次世代OSの座を獲得したのはOPENSTEPとなり、ジョブズはAppleに返り咲く。ジョブズがAppleを去ったのは、ガセーによる密告が原因という話もあり、そのあたりの「ドラマ」も興味深い。

MicrosoftはしばらくWindows 95系列とWindows NT系列を両方開発していたが、両者はWindows XPにて統合され、Windows 95系列はWindows Meを最後に開発を終えた。MacのOSは、当初Macintosh搭載のSystemとしてスタートしたが、Mac OS 9を最後にOPENSTEP由来のMac OS Xに移行し、役目を終えた。中身は完全に変わったが、どちらも「Windows」「Mac」として開発、発売が続いている。OSはソフトウェアであり、ソフトウェアは人が開発するものである以上、人の数だけドラマがある。いまもどこかで次世代OSの開発が進められているのだろう。そこにはどんなドラマが待っているだろうか。

* 参考文献
    * [闘うプログラマー](https://www.amazon.co.jp/dp/4822247570)
    * [米マイクロソフト本社で目の当たりにしたビル・ゲイツの決断力](https://www.huffingtonpost.jp/satoshi-nakajima/bill-gates-microsoft_b_10351956.html)
    * [アップル薄氷の500日](https://www.amazon.co.jp/dp/4797306157)
