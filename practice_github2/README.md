# GitHubの操作(応用編)

## 目標

* GitHub Pagesを使ってウェブサイトを公開する
* 簡単なブラウザゲームを作る

## 課題1: MNISTの学習済みモデルをウェブで試す

MNISTは有名は手書き数字のデータセットだ。これを学習させたモデルをブラウザで読み込み、実際に数字を描いてみてちゃんと認識できるか確認してみよう。

### Step 1: リポジトリのfork

GitHubにログインした状態で、以下のサイトにアクセスせよ。

[https://github.com/appi-github/pages-sample](https://github.com/appi-github/pages-sample)

このサイトの右上に「Fork」というボタンがあるので、それを押す。すると、`pages-sample`がforkされ、自分のアカウントのリポジトリとしてコピーされる。

### Step 2: Pagesの設定

GitHubでは、リポジトリの任意のブランチの、任意のディレクトリをホームページとしてウェブに公開することができる。

* 上のタブの「Settings」を選ぶ。
* 左のメニューの「Pages」を選ぶ。
* 「GitHub Pages」という画面になるので「Source」として「None」となっているボタンをクリックし、`main`を選ぶ。
* 「`/root`」というボタンが現れるので、クリックして「`/docs`」を選んで「Save」ボタンを押す。

すると、

```txt
Your site is ready to be published at https://アカウント名.github.io/pages-sample/
```

という表示がされる。実際に公開するまでしばらくかかるため、数分まってからクリックしてアクセスしよう。もし「404」と表示されたら、またしばらく待ってからリロードすること。「MNIST Check」という画面が出たら成功だ。

先ほどの設定は、`main`ブランチにあるスナップショットの、`/docs`をルートディレクトリとしてウェブサイトを公開せよ、という意味だ。今回は`/docs`以下に`index.html`が置いてあるので、それが表示されている。

### Step 3: 数字認識を確認

画面には二つの黒い領域がある。左の「Please draw here」とある方にマウスで数字を入力してみよ。右側の「Input Image」が更新され、「Your figure is ... 1!」などというメッセージが表示されるはずだ。

学習済みモデルは、28x28ピクセルの画像を学習しているため、入力された画像を、まずは28x28ピクセルに変換する必要がある。それが右側の「Input Image」である。この「Input Image」を学習済みニューラルネットワークに入力し、これが何の数字であるかを推定している。本来は前処理をして渡すのだが、それを省いているために認識精度がかなり低くなっているはずだ。いろいろ数字を入力し、どの数字の認識が悪いか試してみよ。

### レポート課題

最も「これはないだろう」という判定画面(誰が見ても6なのに4と判定してしまった等)を選び、そのスクリーンショットをレポートとして提出せよ。また、どのような数字が誤判定しやすいか、またそれはなぜかを考察せよ。

## 課題2: 簡単なゲーム作成

Git/GitHubを使った演習の最後に、簡単なブラウザゲームを作ってみよう。

### Step 1: リポジトリのfork

GitHubにログインした状態で、以下のサイトにアクセスせよ。

[https://github.com/appi-github/tyrano_sample](https://github.com/appi-github/tyrano_sample)

このサイトの右上に「Fork」というボタンがあるので、それを押す。すると、`tyrano_sample`がforkされ、自分のアカウントのリポジトリとしてコピーされる。

### Step 2: Pagesの設定

先ほどと同様な手順で、GitHub Pagesを公開しよう。

* 上のタブの「Settings」を選ぶ。
* 左のメニューの「Pages」を選ぶ。
* 「GitHub Pages」という画面になるので「Source」として「None」となっているボタンをクリックし、`main`を選ぶ。
* 「`/root`」というボタンが現れるので、クリックして「`/docs`」を選んで「Save」ボタンを押す。

```txt
Your site is ready to be published at https://アカウント名.github.io/tyrano_sample/
```

という表示が現れるので、しばらく待ってからアクセスしてみよう。「走るか寝るかするメロス」という画面が表示されたら成功だ。

### Step 3: リポジトリのクローン

GitHubの自分のアカウントの`tyrano_sample`をクローンしよう。[https://github.com/](https://github.com/)を開き、Repositoriesから「tyrano_sample」を選ぶ。「Code」ボタンの「Clone」から、リモートリポジトリのURLをコピーしよう。その後、Git Bashでクローンする。

```sh
cd
cd github
git clone git@github.com:アカウント名/tyrano_sample.git
```

クローンできたら、VS Codeを開き、「フォルダーを開く」から、先ほどクローンしたディレクトリ(`z/github/tyrano_sample`)を開く。

### Step 4: Live Serverのインストール

VS Codeの左の「拡張機能」マークをクリックするか、Ctrl+Shift+Xにより拡張機能を開き、「Live Server」を探してインストールする。インストールに成功すると、右下に「Go Live」という表示がされるはずだ。

VS Codeのエクスプローラーから`docs/index.html`を開き、右下の「Go Live」をクリックする。ブラウザが開いて「走るか寝るかするメロス」がプレイできれば成功だ。URLは`http://127.0.0.1:5500/docs/index.html`となっているであろう。このタブをデバッグで使うので閉じないこと。

### Step 5: シナリオファイルの修正

VS Codeのエクスプローラーから`docs/data/scenario/first.ks`を開く。冒頭が以下のようになっているはずだ。

```txt
*start

[title name="走るか寝るかするメロス"]
[hidemenubutton]
[wait time=200]
[freeimage layer="base"]
```

この、`[title name="走るか寝るかするメロス"]`を書き換えて保存し、先ほどのゲーム画面を開こう。リロードしてタイトルが変わっていれば成功だ。

以下、シナリオファイルを修正し、オリジナルのゲームを作ってみよ。原則として、入力された文字がそのまま画面に表示されるが、「タグ」と呼ばれる機能でゲームを制御する。例えば、

```txt
「走るか寝るかするメロス」[l][r]
```

の`[l]`はマウスの入力待ち、`[r]`は改行をする命令だ。

選択肢は

```txt
[link target=*tag_sleep] →寝る [endlink][r]
[link target=*tag_run] →走る [endlink][r]
[s]
```

のように作る。`[link]`と`[endlink]`で囲まれたテキストをクリックすると、`target=`で指定されたラベルにジャンプする。例えば「→寝る」をクリックすると`*tag_sleep`のある場所にジャンプする。その先はこうなっている。

```txt
*tag_sleep

[cm]

[bg storage=sleep.jpg time=500]

メロスは死んだように深く眠った。[l][r]
勇者は、ひどく赤面した。[r]

【 BAD END 】[l][cm]

[jump target=*start]
```

`[cm]`はテキストをクリアする命令だ。`[bg]`は背景画像を指定する。`bgimage`というディレクトリにある画像を`storage=filename`で指定することで表示する。`time`は表示するまでの時間(ミリ秒)だ。

最後に`[jump target=*start]`で`*start`ラベル、つまりゲームの最初に戻っている。

その他のタグについては公式サイトの[タグリファレンス](https://tyrano.jp/tag/)を参照のこと。

### レポート課題

オリジナルのゲームを作成し、自分のリポジトリにプッシュしたのち、ブラウザで動作確認したらそのURLをレポートとして提出せよ。ローカルテスト用のURL(`http://127.0.0.1`)ではなく、`https://アカウント名.github.io/tyrano_sample`の方を提出すること。

**注意：**

* 公序良俗に反するような内容にしてはならない
* (たとえ友人であっても)特定個人を揶揄するような内容にしてはならない。有名人も題材としない
* 画像を用いる場合は、ライセンスとして問題ないものを利用する(例えば[Pexels](https://www.pexels.com/ja-jp/)の画像を利用するなど)。
* 面白い作品は別の場所で紹介する可能性があるため、紹介されたくない場合はその旨をレポートに明記すること
