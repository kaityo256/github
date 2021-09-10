# ブランチ操作

## はじめに

Gitは「玉(コミット)」と「線(コミット間の関係)」で構成された「歴史」を管理するツールだ。コミットは、その時点でのプロジェクトのスナップショットであり、いつでも任意のスナップショットを呼び出したり、差分を調べたりすることができる。

さて、この「歴史」を操作する手段として用意されているのがブランチである。ブランチは単に特定のコミットを指すラベルのようなものであることは既に説明した。Gitでは、このブランチを使って積極的に歴史を分岐、改変させることで開発を進める。

以下では、特になぜブランチが必要か、ブランチを使ってどのように開発を進めるのか、「歴史を分岐、改変する」とはどういうことかについて説明する。

## なぜブランチをわけるか

現代においてソフトウェア開発を完全に一人で開発することは稀であり、多くの場合、複数人で分担して開発することになるだろう。開発者が同じソフトウェアに対してばらばらに修正を加えたらプロジェクトが混乱することが予想されるであろう。その「交通整理」を行うためのスールが**ワークフロー (workflow)** である。

今、AliceとBobの二人が開発するプロジェクトがあったとしよう。Aliceは機能Aを、Bobは機能Bを開発することになった。機能Aの実現には、サブモジュールA1とA2を実装する必要があるが、A1を実装しただけではプログラムが正しく動作せず、A2まで実装して初めて全体として正しく動作する。

![center_workflow.png](fig/center_workflow.png)

さて、AliceはA1まで実装し、区切りが良いのでそれをリポジトリにコミットした。そのタイミングでBobが機能Bを実装しようと、リポジトリからソース一式を取得(クローン)すると[^clone]、プログラムが正しく動作しない。やむを得ず、Bobは機能A1を無効化するコードを書いた上で機能Bを追加し、コミットした。その状態でAliceがサブモジュールA2を実装し、コミットしようとすると、リポジトリがBobによって修正されているから、マージをしようとする。しかし、Bobによって機能A1が無効化されている修正が入っていることに気づかず、A2を追加したのに機能Aが動かないことに悩むことになる。

[^clone]: クローンやプッシュについてはまだ説明していないが、とりあえずソース一式をダウンロード、アップロードすること、と思っておいて欲しい。

なぜこんなことが起きたのだろうか？複数人で同じソフトウェアを開発する以上、かならず競合(コンフリクト)は発生することになるが、上記の問題は「他の開発者が見る(クローンする)リポジトリに、中途半端な状態があった」ことに起因する。自分で開発している時、例えばビルドが通らない状態でも、一度家に帰るなどの理由でコミット、プッシュしたくなることはあるだろう。しかし、その状態を他の開発者がクローンすると、ビルドが通らないような状態のリポジトリに困ってしまう。そこで、「みんなが参照するブランチは、中途半端な状態にしない」というルールを作りたくなる。そのために利用するのがブランチだ。

Gitでは原則としてデフォルトブランチ(`master`や`main`)では作業せず、作業開始時にブランチを作成し、歴史を分岐させてから開発を進め、やろうと思った作業がまとまったところでデフォルトブランチにマージする、という開発体制をとる。どのようなブランチを、どのような時に作り、どのように運用するかを決めルールがワークフローだ。チームやプロジェクトに応じて様々なワークフローがあるが、ここでは最も簡単なフィーチャーブランチワークフローについて説明しよう。

![feature_workflow](fig/feature_workflow.png)

Aliceは機能Aを実装するため、`master`ブランチから`feature_A`ブランチを派生させる。そして、機能A1まで実装し、コミットした。この状態で先ほどと同様、Bobが機能Bの実装を開始したとしよう。Bobが見るのは`master`ブランチなので、そこに`feature_B`ブランチを派生させる。Bobは問題なく機能Bを実装し、`master`ブランチにマージする。その後、Aliceは機能A2まで実装を完了し、`master`にマージしようとすると、Bobにより機能Bが追加されているため、その修正を取り込まなければならない。しかし、特に機能Aと機能Bは競合していなかったため、両方の修正を問題なく取り込んで、`master`にマージして、無事に機能Aと機能Bが実装された。

追加したい機能ごとに派生したブランチを**フィーチャーブランチ(feature branch)** と呼ぶ。フィーチャーブランチを利用したワークフローをフィーチャーブランチワークフローと呼ぶ。フィーチャーブランチワークフローは、ワークフローのうち最も簡単なもののひとつだ。ここで、`master`ブランチの歴史がマージでしか増えていないことに注意したい。ほとんどのワークフローにおいて、`master`には直接コミットをせず、必ずブランチを経由する。ブランチでは中途半端な状態でコミットしても良いが、`master`には「きちんとした状態」にしてからマージする。これにより、`master`ブランチが常に「まとも」な状態であることが保証される。

![straight.png](fig/straight.png)

ワークフローはもともと多人数開発のために用意された開発ルールだが、一人で開発する場合も有用だ。例えば、卒論用のプログラムに、機能Aを追加することにした。機能Aを開発中に、機能Bも必要なことに気が付いたので、それも追加することにした。最終的に機能A、機能Bの両方を実装しおわった時に、プログラムがバグっていることに気が付いた。このように「まっすぐな一本の歴史」で開発をしていると、機能Aと機能Bをごっちゃに開発していた場合、開発の「歴史」が全て中途半端な状態となるため、そのバグがどちらの機能に起因するかわからなくなる。

![feature_dev.png](fig/feature_dev.png)

一方、もしあなたが普段から単独開発であっても「新機能は必ずブランチを派生させて開発する」というルールを守っていたとしよう。機能Aを追加するため、`feature_A`というブランチを作り、そこで途中まで開発を進めた。ここで「あ、機能Bも必要だな」と思ったあなたは、`master`ブランチに戻ってから`feature_B`ブランチを作成し、途中まで開発する。そこで「やっぱりAを完成させておくか」と思って、`feature_A`ブランチに戻って開発を進め、機能Aを完成させて`master`にマージする(fast-forwardマージになる)。次に、`feature_B`にブランチに移って、機能Bを最後まで完成させてから`master`にマージする。この時点でバグが発覚する。

開発の手間は「まっすぐな一本の歴史」とほとんど同じであり、最後のソフトウェアの状態も先ほどと同じだ。しかし、先ほどと異なり、過去の歴史には「機能Aのみ実装された状態」と「機能Bのみ実装された状態」が存在する。それぞれの状態を呼び出してテストしてみれば、どちらがバグの原因になっているかがすぐにわかる。「容疑者」が少ない分、デバッグ時間も短くなる。

これは筆者の経験から強く伝えたいことだが、「三日前の自分は他人」である。同様に「三日後の自分も他人」だ。他人と開発するのであるから、単独開発であっても多人数開発と同様な問題が発生する。一人で開発しているにも関わらず、いちいちブランチを切るなど面倒だと思うかもしれない。しかし、「ブランチを切ってマージする手間」に比べて、「何か問題が起きた時にブランチを切っていたことで軽減される手間」を比べると、後者の方が圧倒的にメリットが大きい。何より問題なのは、デバッグのために「全て中途半端な状態の歴史」と格闘している人が、「ブランチを切っていたらこの手間が軽減されていた」という可能性に気づかないことだ。Gitを使えば開発が便利になるのではなく、開発が便利になるようにGitを使うように心がけなければならない。

## ブランチの作成と切り替え

### カレントブランチとコミット

まず、ブランチとコミットについておさらいしておこう。Gitが管理する歴史はコミットがつながったものであり、そのコミットにつけた「ラベル」がブランチだ。特に「いま自分が見ている」場所を指すブランチをカレントブランチと呼ぶ。どのブランチがカレントブランチかを示すのが「HEAD」である。また、コミットとは、新たにコミットを作り、今見ていたコミットにつなげる操作だが、「今見ていたコミット」とは、「HEADが指しているブランチが指しているコミット」のことだ。

![current_branch.png](fig/current_branch.png)

今、カレントブランチが`branch`だとしよう。カレントブランチとは、`HEAD`というラベルが指すブランチのことなので、`HEAD`は`branch`を指してしている。あるブランチ`branch`が、別のブランチ`other`と同じコミットを指していたとする。この状態でコミットをすると、新たにコミットが作られ、カレントブランチが指すコミットにつなげられることで歴史が伸びる。そして、カレントブランチは新たに作られたコミットを指す。具体的には、`HEAD`が`branch`を指したまま、`branch`が新たにできたコミットを差す。この時、カレントブランチ以外のブランチは移動しないことに注意。この状態でカレントブランチを`other`に変更してコミットをすると、歴史が分岐することになる。

### コミットと差分

![commit.png](fig/commit.png)

Gitのコミットは、自分の親コミットを覚えており、それをたどることで歴史をたどることができる。いま、コミット1からコミット2が作られたとする。コミット2にとってコミット1は親コミットになる。この時、それぞれのコミットはその時点でのスナップショットを表しているが、玉と玉をつなぐ線は差分(パッチ)を表している。玉と線からなる歴史は、一つ前の玉が表すコミットに、線が表すパッチを適用することで、次のコミットが得られる、と解釈することができる。この、**コミットの間の線は差分(パッチ)を表す** という事実は今後の説明に重要な役割を果たす。

### `git branch`と`git switch`

さて、ブランチを作ろう。ブランチはコミットにつけるラベルであるから、任意のコミットを指定して作ることができる。ブランチは`git branch`で作ることができる。

```sh
git branch ブランチ名 ブランチをつけたいコミット
```

ブランチをつけたいコミットは、コミットハッシュの他、別のブランチでも指定できる。

しかし、一番よく使われるのは、カレントブランチに別名を与えることだ。その場合は、`git branch`に与える第二引数は不要で、ブランチ名だけで良い。

```sh
git branch newbranch
```

これにより、`newbranch`というブランチが作られ、カレントブランチが指しているコミットを指す。

この状態では、同じコミットに二つのブランチがついただけだ。この状態で、「今見ているブランチ」を`newbranch`に切り替えよう。ブランチの切り替えは`git switch`を使う。

```sh
git switch newbranch
```

これで、HEADが`master`から`newbranch`を指すようになった。この状態で何か修正してコミットをすると、HEADと`newbranch`は新しいコミットに移動するが、`master`は取り残される。つまり、新しいブランチを作成して切り替える作業は、作業前の状態がどのコミットであったかを保存しておく、という意味を持つ。

![switch.png](fig/switch.png)

なお、`git switch`に`-c`オプションをつけると、ブランチの作成と切り替えを同時に行ってくれる。

```sh
git switch -c newbranch
```

これは以下のコマンドと等価だ。

```sh
git branch newbranch
git switch newbranch
```

通常の作業では`git switch -c`を使うことが多いだろう。

以上の操作をまとめて置こう。

* 「カレントブランチ」とはHEADが指すブランチである
* 「git branch ブランチ名」で、カレントブランチが指すコミットに別のブランチをつけることができる
* 「git switch ブランチ名」で、カレントブランチを変更できる(HEADを付け替えることができる)
* 「git switch -c ブランチ名」で、ブランチの作成とカレントブランチの変更を同時に行うことができる。

## コミットとブランチ

`git commit`により、新たにコミットを作ると、「カレントブランチが見ているコミット」に新たに歴史が追加され、「カレントブランチ」がそこに追従する。このとき、カレントブランチ以外のブランチは元のコミットに取り残される。この状態で、別のブランチに歴史が追加されるとで歴史が分岐する。

## ブランチ操作(`switch, checkout, merge, branch`)

覚えるコマンド

* switch
* merge
* branch