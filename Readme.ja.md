[![Gem Version](https://badge.fury.io/rb/volt.svg)](http://badge.fury.io/rb/volt)
[![Code Climate](http://img.shields.io/codeclimate/github/voltrb/volt.svg)](https://codeclimate.com/github/voltrb/volt)
[![Build Status](http://img.shields.io/travis/voltrb/volt/master.svg)](https://travis-ci.org/voltrb/volt)
[![Inline docs](http://inch-ci.org/github/voltrb/volt.svg?branch=master)](http://inch-ci.org/github/voltrb/volt)
[![Volt Chat](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/voltrb/volt)

** Voltの現在の開発状況はこちらで確認できます。 http://voltframework.com/blog

# Volt

VoltはRubyのWebフレームワークで、サーバーサイドとクライアントサイドの両方のコードをRubyで記述することができます(クライアント側では[opal](https://github.com/opal/opal)を利用)。Voltでは、ユーザーがページに対して行った操作に応じて自動的にDOMが更新されます。また、ページの状態をURLとして保持することができます。ユーザーがURLに直接アクセスした場合、HTMLはまずサーバー上でレンダリングされます。 これは、ロード時間の高速化や、検索エンジンによるインデックス化を容易にするためです。

Voltでは、HTTPを介してクライアントとサーバー間のデータを同期するのではなく、クライアントとサーバー間の永続的なコネクションを利用します。したがって、ある1つのクライアント上でデータが更新されたときには、データベース、および他のリスニング中のクライアント上でも更新が行われます。(しかも、そのための設定用コードを書く必要はほとんどありません。)

ページのHTMLはHandlebarsに似たテンプレート言語で記述します。Voltは、DOM(および値が更新されたことを検知したい他のすべてのコード)に対して、自動的に、かつ正確に変更を伝えるために、データフロー／リアクティブプログラミングを利用します。 DOMに何らかの変更があった場合、Voltは変更が必要なノードだけを正しく更新することができます。

いくつかのデモ動画を用意しています。
** 注意: これらのビデオは古いものです。近日中に新しいビデオを公開する予定です。 - [VoltでのTodoアプリケーションの例](https://www.youtube.com/watch?v=6ZIvs0oKnYs)
 - [Voltでブログを構築する](https://www.youtube.com/watch?v=c478sMlhx1o)
 - [Voltのリアクティブバリューについて](https://www.youtube.com/watch?v=yZIQ-2irY-Q)

デモアプリケーションも用意しています。
 - https://github.com/voltrb/todos3
 - https://github.com/voltrb/contactsdemo


## 目指すゴール

Voltの目標は以下のゴールを達成することです。

1. 開発者のしあわせ
2. クライアントとサーバーでの「write once」
3. クライアントとサーバー間の自動的なデータ同期
4. 階層的なコンポーネントで構築されたアプリケーション。コンポーネントは(Gemを介して)共有可能。
5. 並行性。Voltは、シンプルに並行性を実現するツールを提供する。コンポーネントのレンダリングは、サーバー上で並列実行される。
6. インテリジェントなアセット管理
7. セキュアであること（わざわざ言うべきことではないですが）
8. 高速/軽量
9. 理解しやすいコードベース
10. アップグレードをコントロール可能であること

# ロードマップ

Voltの核となる機能の多くはすでに実装済みです。 しかし、1.0のリリースまでに対応すべきことがまだいくつか残っていて、そのほとんどはモデルに関するものです。

1. モデルのread/write権限
2. ユーザーアカウント、ユーザーコレクション、サインアップ/ログインのテンプレート

# VOLTガイド

ここでは、Voltで基本的なWebアプリケーションを作成する手順を示します。 このチュートリアルは、RubyとWeb開発の基本的な知識を持っていることを前提とします。

まずはVoltをインストールします。

    gem install volt

次に、新しいプロジェクトを作成します。

    volt new project_name

これで、基本的なプロジェクトがセットアップされます。 では、サーバーを起動してみましょう。

    bundle exec volt server

Voltのコンソールにアクセスするには以下のようにします。

    bundle exec volt console

# ガイドの目次

1. [Getting Help](#getting-help)
2. [Rendering](#rendering)
  1. [States and Computations](#state-and-computations)
    1. [Computations](#computations)
  2. [Dependencies](#dependencies)
3. [Views](#views)
  1. [Bindings](#bindings)
    1. [Content Binding](#content-binding)
    2. [If Binding](#if-binding)
    3. [Each Binding](#each-binding)
    4. [Attribute Bindings](#attribute-bindings)
  2. [Escaping](#escaping)
4. [Models](#models)
  1. [Nil Models](#nil-models)
  2. [Provided Collections](#provided-collections)
  3. [Store Collection](#store-collection)
  4. [Sub Collections](#sub-collections)
  5. [Model Classes](#model-classes)
  6. [Buffers](#buffers)
  7. [Validations](#validations)
  8. [Model State](#model-state)
  9. [ArrayModel Events](#arraymodel-events)
  10. [Automatic Model Conversion](#automatic-model-conversion)
5. [Controllers](#controllers)
  1. [Reactive Accessors](#reactive-accessors)
6. [Tasks](#tasks)
7. [Components](#components)
  1. [Dependencies](#dependencies)
  2. [Assets](#assets)
  3. [Component Generator](#component-generator)
  4. [Provided Components](#provided-components)
    1. [Notices](#notices)
    2. [Flash](#flash)
8. [Controls](#controls)
9. [Routes](#routes)
  1. [Routes file](#routes-file)
10. [Testing](#testing)
11. [Debugging](#debugging)
12. [Volt Helpers](#volt-helpers)
  1. [Logging](#logging)
  2. [App Configuration](#app-configuration)
13. [Contributing](#contributing)

# ヘルプ

Voltはまだ開発中ですが、早期のフィードバックは大歓迎です。開発者とコンタクトを取りたいときには、以下を使ってください。誰かが素早く返答してくれることでしょう。


- **ヘルプが欲しい！**: [stackoverflow.com](http://www.stackoverflow.com) に投稿してください。質問に`voltrb`タグを付けるのを忘れないように。- **バグを見つけたとき**: [github issues](https://github.com/voltrb/volt/issues) に投稿してください。
- **Voltへの提案がある、こんな機能が欲しい**: [github issues](https://github.com/voltrb/volt/issues) に投稿してください。
- **Voltについて議論したい**: [gitterのチャット](https://gitter.im/voltrb/volt) 通常、Voltチームが誰かがオンラインです。喜んで助けになります。


# レンダリング

ユーザーがウェブページで操作をしたときの処理は、以下が典型的なものでしょう。

1. アプリケーションの状態を変える
2. DOMを更新する

例えば、ユーザーが「新しいtodoアイテムをtodoリストに追加」するためにクリックしたときの処理は、「todoアイテムを表すオブジェクトを作成し、そのアイテムをリストのDOMに追加する」といったものになると思います。  その際、オブジェクトとDOMの状態が確実に同期しておくようにするためには、多くの手間のかかる処理が必要です。

「リアクティブプログラミング」という手法は、DOMの管理をシンプルにするために使われます。  この手法では、モデルとDOMを管理するイベントハンドラを持つ代わりに、リアクティブなデータモデルを管理するイベントハンドラを持ちます。
DOMのレイヤーを宣言的に記述しておくことで、データモデルをどのようにレンダリングすべきかについて自動的に判別することができます。


## 状態と評価について

Webアプリケーションの中心的な仕事は状態を管理することです。多くのイベントが状態を変更します。例えば、フォーム要素へテキストを入力する、ボタンをクリックする、リンク、スクロール...などなど。これらの操作はすべてアプリケーションの状態を変更するものです。かつては、ページに対するイベントは、ページが持っている状態をそれぞれ手動で変更していました。

Voltでは、アプリケーションの状態管理をシンプルにするため、すべてのアプリケーションの状態を永続化されるモデルの中に保存します。保存のしかたはオプションで様々なものを指定可能です。
このようにアプリケーションの状態を一元管理することで、ページを更新するために本来必要となるはずの複雑なコードを、かなりの分量削減することができます。また、このことでページのHTMLを宣言的に組み立てることができます。ページのモデルへの結びつきは、関数とメソッド呼び出しによってバインドされます。

モデルのデータが変更されたときには、それに応じて自動的にDOMを更新したいと考えることでしょう。それを実現するために、Voltはすべてのメソッド/Procの呼び出しを"監視(watch)"し、メソッド/procの呼び出しによってデータが変更されたときにも、そこことを知ることができます。

### 評価

実例を見てみましょう。ここでは、```page```コレクションを例とします。(後でより多くのコレクションを紹介します)

はじめに、評価のための監視設定を行います。計算はProcオブジェクトに対して .watch! を実行ことで設定されます。Ruby 1.9のProcの短縮シンタックス ```-> { .. }``` を使ったProcオブジェクトで .watch! を実行しています。これを一度実行すると、以後 page._name が変更されたときに毎回Procが実行されます。
```ruby
    page._name = 'Ryan'
    -> { puts page._name }.watch!    # => Ryan
    page._name = 'Jimmy'
    # => Jimmy
```

page._nameに新しい値が代入されると、そのたびに評価されます。また、前回の実行でアクセスされたデータのいずれかに変更があったときには、再評価が実行されます。これによって、メソッドを介してデータにアクセスしながらデータの監視を続けることができます。

```ruby
    page._first = 'Ryan'
    page._last = 'Stout'

    def lookup_name
      return "#{page._first} #{page._last}"
    end

    -> do
      puts lookup_name
    end.watch!    # => Ryan Stout

    page._first = 'Jimmy'
    # => Jimmy Stout

    page._last = 'Jones'
    # => Jimmy Jones
```

.watch! を実行したとき、その戻り値はComputation(評価)オブジェクトです。もうそれ以上更新を受け取り必要がない場合には、評価オブジェクトに対し .stop メソッドを実行してください。

```ruby
    page._name = 'Ryan'

    comp = -> { puts page._name }.watch!    # => Ryan

    page._name = 'Jimmy'
    # => Jimmy

    comp.stop

    page._name = 'Jo'
    # (nothing)
```

## Dependencies

TODO: Explain Dependencies

As a Volt user, you rarely need to use Comptuations and Dependencies directly.  Instead you usually just interact with models and bindings.  Computations are used under the hood, and having a full understanding of what's going on is useful, but not required.

# ビュー

Voltでは、ビューにHandlebarsに似たテンプレート言語を使用します。ビューはセクションに分割することができます。例えば、セクションヘッダーは以下のようになります。

```html
<:Body>
```

セクションヘッダーは先頭が大文字で始まる必要があります。[コントロール](#コントロール)と混同しないようにしてください。また、セクションヘッダーに閉じタグは使いません。もしセクションヘッダーを書かなかった場合は、Bodyセクションであるとして扱います。

セクションは同じファイル上のコンテンツの異なるパーツ(タイトルと本文など)を区別するのに役立ちます。

## バインディング

Voltでは、Handlebarsに似たテンプレート言語でビューのコードを記述します。Voltはレンダリングのためのいくつかのバインディングを提供しています。例えば、{ と } で括られたものは、コンテンツのバインディングを表しています。

### コンテンツのバインディング

もっとも基本的なバインディングはコンテンツのバインディングです。

```html
    <p>{{ some_method }}<p>
```

コンテンツのバインディングとは、{ と } の間のRubyコードを実行し、その戻り値をレンダリングするものです。バインディングされたコンテンツのデータが変更を監視されているデータであった場合、その変更に応じてテキストが更新されます。

### Ifバインディング

ifバインディングは、基本的な制御文を提供します。

```html
    {{ if _some_check?}}
      <p>render this</p>
    {{ end }}
```

ブロックは {{ end }} で閉じます。

ifバインディングがレンダリングされるときは、#if に続くRubyコードが実行されます。そのコードが真の場合にのみ、下のコードがレンダリングされます。ここでも、戻り値がリアクティブな値である場合には、変更に応じてその値が更新されます。

また、ifバインディングは #elsif と #else ブロックを持つことができます。

```html
    {{ if _condition_1?}}
      <p>condition 1 true</p>
    {{ elsif _condition_2?}}
      <p>condition 2 true</p>
    {{ else }}
      <p>neither true</p>
    {{ end }}
```

### Eachバインディング

オブジェクトのイテレーション操作のために、eachバインディングを利用することができます。

```html
    {{ _items.each do |item| }}
      <p>{{ item }}</p>
    {{ end }}
```

上記では、_itemが配列だった場合、'item'に配列の各要素の値がセットされ、ブロックはその要素それぞれに対してレンダリングを行います。

#index メソッドを使うことで、配列の各要素の位置を得ることもできます。

```html
    {{ each _items as item }}
      <p>{{ index }}. {{ item }}</p>
    {{ end }}
```

例えば、['one', 'two', 'three'] という配列の場合には、このように出力されます。

    0. one
    1. two
    2. three

ゼロオフセットを修正したければ {index + 1} としてください。

配列の要素が追加または削除された場合には、#eachバインディングは自動的かつ正確に要素をDOMに追加、もしくはDOMから削除します。

### 属性バインディング

バインディングは属性内にも配置することができます。

```html
    <p class="{{ if _is_cool?}}cool{{ end }}">Text</p>
```

また、要素を"双方向バインディング"とするため、特別な機能が提供されます。

```html
    <input type="text" value="{{ _name }}" />
```

上記の例で、_nameが変更された場合、フィールドも更新されます。 反対に、フィールドが更新された場合には、_nameも更新されます。

```html
    <input type="checkbox" checked="{{ _checked }}" />
```

この例では、checked属性の値がtrueであるとき、チェックボックスはチェックされた状態になります。そして、チェックされた/チェック解除された という状態の変化に応じて、値がtrueまたはfalseに更新されます。

ラジオボタンもcheckedにバインドすることができますが、true/falseの代わりに与えられたフィールドの値がセットされます。

```html
    <input type="radio" checked="{{ _radio }}" value="one" />
    <input type="radio" checked="{{ _radio }}" value="two" />
```

ラジオボタンがチェックされたとき、checkedには常にフィールドの値が設定されるようにバインドされます。checkedにバインドされた値が変更されたとき、ラジオボタンのバインドされた値にマッチするすべてのフィールドがチェックされた状態になります。 checked.  メモ: ラジオボタンに対しては、この振る舞いがもっとも利便性が高いと考えています。

セレクトボックスは値に対してバインドすることができます。(技術的には正しくありませんが、これも利便性のために追加している振る舞いです。)

```html
  <select value="{{ _rating }}">
    <option value="1">*</option>
    <option value="2">**</option>
    <option value="3">***</option>
    <option value="4">****</option>
    <option value="5">*****</option>
  </select>
```

選択されたオプションが変更されると、それに合うように```_rating```が変更されます。```_rating```が変更された場合には、それにマッチする最初のオプションが選択された状態になります。マッチするオプションが存在しなかった場合には、セレクトボックスは未選択の状態になります。

もしコントローラーが app/home/controller/index_controller.rb であり、ビューが app/home/views/index/index.html だった場合、すべてのメソッドはそのコントローラー上で呼び出されます。

### テンプレートバインディング

すべての views/*.html ファイルはテンプレートとして扱われ、テンプレートバインディングを利用することで他のビューの内部でレンダリングすることが可能です。

```html
    {{ template "header" }}
```

## エスケープ

{{ と }) をバインディングの目的以外で使いたい場合には、3連の波括弧で囲んだ中にあるものはエスケープされバインディングとして処理されることはありません。


```html
    {{{ bindings look like: {{this}}  }}}
```

# モデル

多くのフレームワークでは、モデルというのはデータベースとのORMにおいて使われる単語ですが、Voltのモデルのコンセプトはそれとは少し異なります。Voltにおいて、モデルはデータを簡単に保存しておくために利用できるクラスを指します。モデルは、Persistorとともに作成することができます。そのPersistorというものが、モデルのデータを保持しておく役割を果たします。Persistor無しでモデルを作った場合には、データは単純にクラスのインスタンスに保存されます。どのようにモデルを使うのか、まず見てみましょう。

Voltには多くのモデルがビルトインされており、その1つに `page` モデルがあります。コントローラーで `#page` を呼び出すことでそのモデルにアクセスすることができます。

```ruby
    page._name = 'Ryan'
    page._name
    # => 'Ryan'
```

モデルは、先頭がアンダースコアで始まるゲッター/セッターでアクセス可能なハッシュのように振る舞います。もし、そのアトリビュートまだ設定されていないものだった場合には、"nilモデル"が返ってきます。アンダースコアを前置することによって、存在しないメソッドを誤って呼び出すことを回避したり、例外が発生することを避けnilモデルを返すようにすることができます。フィールドはハッシュのように振る舞いますが、アクセスと代入については異なるシンタックスを使用します。

  # TODO: Add docs on fields in classes

また、モデルは中間的なモデルを作成することなくネストすることができます。

```ruby
    page._settings._color = 'blue'
    page._settings._color
    # => @'blue'

    page._settings
    # => @#<Model:_settings {:_color=>"blue"}>
```

ネストされたデータは、代入時に自動的に設定されます。上記の例では、page._settingはpageモデルの一部を形成するモデルとなります。このことによって、事前に設定を行うことなく、ネストされたモデルをバインディングすることが可能になっています。

Voltのモデルでは、複数形の名前を持ったプロパティはArrayModelsのインスタンスを返します。ArrayModelは通常のアレイと同じように振る舞います。要素の追加/削除は通常のアレイと同様のメソッド (#<<, push, append, delete, delete_at, etc...) で行うことができます。

```ruby
    page._items
    # #<ArrayModel:70303686333720 []>

    page._items << {_name: 'Item 1'}

    page._items
    # #<ArrayModel:70303686333720 [<Model:70303682055800 {:_name=>"Item 1"}>]>

    page._items.size
    # => 1

    page._items[0]
    # => <Model:70303682055800 {:_name=>"Item 1"}>
```


## Nilモデル

利便性を高めるために、例えば```page._info```を実行した時にはNilModelを返すようになっています。(このとき、._infoはまだ設定されていないものとします。)NilModelは将来的に利用するモデルのプレースホルダーです。NilModelがあることによって、わざわざ中間の値を初期化することなく、深くネストされた値のバインドをすることが可能になっています。

```ruby
    page._info
    # => <Model:70260787225140 nil>

    page._info._name
    # => <Model:70260795424200 nil>

    page._info._name = 'Ryan'
    # => <Model:70161625994820 {:_info=><Model:70161633901800 {:_name=>"Ryan"}>}>
```

1つ注意しておくべきことは、NilModelは「真」の値であるということです。(Rubyではnilとfalseのみがfalseとして扱われます。)分かりやすくするために、NilModelに対して```.nil?```を実行するとtrueを返すようになっています。

真偽チェックを利用するよくあるケースとして、|| (論理和)を使ってデフォルト値を設定するものがあります。Voltはこれと同様の働きをするメソッド #or を提供します。これはNilModelに対しても有効です。

こう書くのではなく、

```ruby
    a || b
```

こう書きます。

```ruby
    a.or(b)
```

#and は && と同様の働きをします。#and と #or によって、NilModelも含めて、初期値の扱いを簡単にすることができます。

-- TODO: Document .true? / .false?


## 提供されるコレクション

前述の通り、Voltにはコントローラーからアクセス可能な豊富なデフォルトのコレクションモデルが用意されています。そして、そのそれぞれが異なる場所に保存されます。

| 名前          | 保存場所                                                                                                                           |
|---------------|------------------------------------------------------------------------------------------------------------------------------------|
| page          | pageは一時的なデータ保存場所を提供します。そのページが生きている間だけ残ります。|
| store         | storeはバックエンドのデータベースと同期し、クエリメソッドを提供します。|
| local_store   | データはローカルに保存されます。                                                                                         |
| params        | データはパラメータとURLに保存されます。どのようにURLに表示するかはルーティングの設定にしたがいます。(詳細はルートを御覧ください) |
| flash         | 代入された文字列がページの先頭に表示され、ユーザーによるページの移動で消去されます。|
| controller    | 現在のコントローラーのためのモデルです。                                                                                           |

**上記以外のストレージについても計画中です。**

## ストアコレクション

ストアコレクションは、データストアにデータを保存するためのものです。現在サポートされているデータストアはMongoのみです。(他のものも検討中です。おそらく次はRethinkDBに対応するでしょう) ストアは他のコレクションとほとんど同じように利用することができます。

Voltではフロントエンドとバックエンドのどちらも```store```にアクセスすることができます。そして、フロントエンドとバックエンドでデータが自動的に同期されます。ストアにあるデータに対する変更はすべて、そのデータを利用しているすべてのクライアントに対して反映されます。 (ただし、後述の[buffer](#buffer)が使われている場合は除きます。).

```ruby
    store._items << {_name: 'Item 1'}

    store._items[0]
    # => <Model:70303681865560 {:_name=>"Item 1", :_id=>"e6029396916ed3a4fde84605"}>
```

```sore_items```へ挿入を行うと、```_items```テーブルが作成され、そこにモデルが格納されます。そのとき、仮の一意な _id が自動的に生成されます。

現在、```store```とそれ以外のコレクションで異なっている点は、```store```はプロパティを直接持つことができないことです。```store```に直接設定することができるのはArrayModelのみです。

```ruby
    store._something = 'yes'
    # => won't be saved at the moment
```

メモ: ```store```に直接プロパティを設定できるようにすることも検討中です。

## サブコレクション

モデルは```store```上でネストすることができます。

```ruby
    store._states << {_name: 'Montana'}
    montana = store._states[0]

    montana._cities << {_name: 'Bozeman'}
    montana._cities << {_name: 'Helena'}

    store._states << {_name: 'Idaho'}
    idaho = store._states[1]

    idaho._cities << {_name: 'Boise'}
    idaho._cities << {_name: 'Twin Falls'}

    store._states
    # #<ArrayModel:70129010999880 [<Model:70129010999460 {:_name=>"Montana", :_id=>"e3aa44651ff2e705b8f8319e"}>, <Model:70128997554160 {:_name=>"Montana", :_id=>"9aaf6d2519d654878c6e60c9"}>, <Model:70128997073860 {:_name=>"Idaho", :_id=>"5238883482985760e4cb2341"}>, <Model:70128997554160 {:_name=>"Montana", :_id=>"9aaf6d2519d654878c6e60c9"}>, <Model:70128997073860 {:_name=>"Idaho", :_id=>"5238883482985760e4cb2341"}>]>
```

先にモデルを作って、それを挿入することも可能です。

```ruby
    montana = Model.new({_name: 'Montana'})

    montana._cities << {_name: 'Bozeman'}
    montana._cities << {_name: 'Helena'}

    store._states << montana
```

## Modelクラス

デフォルトでは、すべてのコレクションはModelクラスを使用します。

```ruby
    page._info.class
    # => Model
```

標準のModelクラスの代わりに使用するクラスを提供し、それを読み込むことも可能です。クラスは /app/{component}/models フォルダに格納します。例えば、```app/main/info.rb``` という具合です。モデルとするクラスは```Model```を継承する必要があります。

```ruby
    class Info < Model
    end
```

これで、```_info```というサブコレクションにアクセスすることができます。それは```Info```のインスタンスとして読み込まれます。

```ruby
    page._info.class
    # => Info
```

これによって、コレクションにカスタムメソッドやバリデーションを設定することが可能です。

## バッファ

ストアコレクションは自動的にバックエンドと同期するため、モデルのプロパティに対する更新は即座に他のクライアントにも反映されます。しかし、この動作が望ましくない場合もあります。[CRUD](http://en.wikipedia.org/wiki/Create,_read,_update_and_delete)アプリケーションの構築を容易にするため、Voltは"バッファ"という方法を的供します。バッファはモデルに対して作成することが可能で、save!を実行するまではバックエンドのモデルに反映されることはありません。これを利用することで、submitボタンが押されるまでは保存されないフォームを作成することが可能になります。

```ruby
    store._items << {_name: 'Item 1'}

    item1 = store._items[0]

    item1_buffer = item1.buffer

    item1_buffer._name = 'Updated Item 1'
    item1_buffer._name
    # => 'Updated Item 1'

    item1._name
    # => 'Item 1'

    item1_buffer.save!

    item1_buffer._name
    # => 'Updated Item 1'

    item1._name
    # => 'Updated Item 1'
```

なお、バッファに対して```#save!```を実行したときの戻り値は[promise](http://opalrb.org/blog/2014/05/07/promises-in-opal/)です。promiseはデータがサーバーに保存された時点で解決(resolve)されます。

```ruby
    item1_buffer.save!.then do
      puts "Item 1 saved"
    end.fail do |err|
      puts "Unable to save because #{err}"
    end
```

既存のモデルに対して .buffer を実行した場合の戻り値は、そのモデルのインスタンスのバッファになります。また、ArrayModel(複数形のサブコレクション)に対して .buffer を実行した場合には、そのコレクションの新しい要素のバッファを取得します。save! を実行すると、<< で要素をコレクションにプッシュするかのように、その要素をサブコレクションに追加することができます。

## バリデーション

モデルのクラスにはバリデーションを設定することが可能です。バリデーションによって、モデルに保存することができるデータの種類を制限することができます。特に```store```コレクションに対してバリデーションは有効ですが、他でも利用することができます。

現在のところ、2種類(lengthとpresence)のバリデーションが実装されています。これから追加されていく予定です。

```ruby
    class Info < Model
      validate :_name, length: 5
      validate :_state, presence: true
    end
```

バリデーションがある場合、ここでモデルに対して save を実行すると、以下のようになります。

1. クライアントサイトでバリデーションが実行されます。もしバリデーションがエラーになった場合、```save!```の結果のpromiseがエラーオブジェクトを伴ってrejectされます。2. データはサーバーに送られ、クライアントとサーバーサイドのバリデーションがサーバー上で実行されます。すべてのエラーが返され、promiseはフロントエンドで(エラーオブジェクトを伴って)rejectされます。
    - バリデーションがサーバーサイドでも再度実行されることで、バリデーションにパスしないデータが保存されてしまうことを確実に回避します。すべてのバリデーションにパスすると、データはデータベースに保存され、promiseはクライアント上でresolveされます。4. データが他のすべてのクライアントと同期されます。


## Model State

**Work in progress**

| state       | events bound | description                                                  |
|-------------|--------------|--------------------------------------------------------------|
| not_loaded  | no           | no events and no one has accessed the data in the model      |
| loading     | maybe        | someone either accessed the data or bound an event           |
| loaded      | yes          | data is loaded and there is an event bound                   |
| dirty       | no           | data was either accessed without binding an event, or an event was bound, but later unbound. |


## ArrayModel Events

Models trigger events when their data is updated.  Currently, models emit two events: added and removed.  For example:

```ruby
    model = Model.new

    model._items.on('added') { puts 'item added' }
    model._items << 1
    # => item added

    model._items.on('removed') { puts 'item removed' }
    model._items.delete_at(0)
    # => item removed
```

## Automatic Model Conversion

### Hash -> Model

For convenience, when placing a hash inside of another model, it is automatically converted into a model.  Models are similar to hashes, but provide support for things like persistence and triggering reactive events.

```ruby
    user = Model.new
    user._name = 'Ryan'
    user._profiles = {
      _twitter: 'http://www.twitter.com/ryanstout',
      _dribbble: 'http://dribbble.com/ryanstout'
    }

    user._name
    # => "Ryan"
    user._profiles._twitter
    # => "http://www.twitter.com/ryanstout"
    user._profiles.class
    # => Model
```

Models are accessed differently from hashes.  Instead of using `model[:symbol]` to access, you call a method `model.method_name`.  This provides a dynamic unified store where setters and getters can be added without changing any access code.

You can get a Ruby hash back out by calling `#to_h` on a Model.

### Array -> ArrayModel

Arrays inside of models are automatically converted to an instance of ArrayModel.  ArrayModels behave the same as a normal Array except that they can handle things like being bound to backend data and triggering reactive events.

```ruby
    model = Model.new
    model._items << {_name: 'item 1'}
    model._items.class
    # => ArrayModel

    model._items[0].class
    # => Model
    model._items[0]
```


To convert a Model or an ArrayModel back to a normal hash, call .to_h or .to_a respectively.  To convert them to a JavaScript Object (for passing to some JavaScript code), call `#to_n` (to native).

```ruby
    user = Model.new
    user._name = 'Ryan'
    user._profiles = {
      _twitter: 'http://www.twitter.com/ryanstout',
      _dribbble: 'http://dribbble.com/ryanstout'
    }

    user._profiles.to_h
    # => {_twitter: 'http://www.twitter.com/ryanstout', _dribbble: 'http://dribbble.com/ryanstout'}

    items = ArrayModel.new([1,2,3,4])
    # => #<ArrayModel:70226521081980 [1, 2, 3, 4]>

    items.to_a
    # => [1,2,3,4]
```

You can get a normal array again by calling .to_a on an ArrayModel.

# Controllers

A controller can be any class in Volt, however it is common to have that class inherit from ModelController.  A model controller lets you specify a model that the controller works off of.  This is a common pattern in Volt.  The model for a controller can be assigned by one of the following:

1. A symbol representing the name of a provided collection model:

```ruby
    class TodosController < ModelController
      model :page

      # ...
    end
```

2. Calling `self.model=` in a method:

```ruby
    class TodosController < ModelController
      def initialize
        self.model = :page
      end
    end
```

When a model is set, any missing methods will be proxied to the model.  This lets you bind within the views without prefixing the model object every time.  It also lets you change out the current model and have the views update automatically.

In methods, the `#model` method returns the current model.

See the [provided collections](#provided-collections) section for a list of the available collection models.

You can also provide your own object to model.

In the example above, any methods not defined on the TodosController will fall through to the provided model.  All views in views/{controller_name} will have this controller as the target for any Ruby run in their bindings.  This means that calls on self (implicit or with self.) will have the model as their target (after calling through the controller).  This lets you add methods to the controller to control how the model is handled, or provide extra methods to the views.

Volt is more similar to an MVVM architecture than an MVC architecture.  Instead of the controllers passing data off to the views, the controllers are the context for the views.  When using a ModelController, the controller automatically forwards all methods it does not handle to the model.  This is convenient since you can set a model in the controller and then access its properties directly with methods in bindings.  This lets you do something like ```{{ _name }}``` instead of something like ```{{ @model._name }}```

Controllers in the app/home component do not need to be namespaced, all other components should namespace controllers like so:

```ruby
    module Auth
      class LoginController < ModelController
        # ...
      end
    end
```

Here "auth" would be the component name.

## Reactive Accessors

The default ModelController proxies any missing methods to its model.  Since models are wrapped in ReactiveValues, they return ReactiveValues by default.  Sometimes you need to store additional data reactively in the controller outside of the model.  (Though often you may want to condier doing another control/controller).  In this case, you can add a ```reactive_accessor```.  These behave just like ```attr_accessor``` except the values assigned and returned are wrapped in a ReactiveValue.  Updates update the existing ReactiveValue.

```ruby
  class Contacts < ModelController
    reactive_accessor :_query
  end
```

Now from the view we can bind to _query while also changing in and out the model.  You can also use ```reactive_reader``` and ```reactive_writer```

# Tasks

Sometimes you need to explicitly execute some code on the server. Volt solves this problem through *tasks*. You can define your own tasks by dropping a class into your component's ```tasks``` folder.

```ruby
    # app/main/tasks/logging_tasks.rb

    class LoggingTasks
        def initialize(channel=nil, dispatcher=nil)
            @channel = channel
            @dispatcher = dispatcher
        end

        def log(message)
            puts message
        end
    end
```

To invoke a task from a controller use ```tasks.call```.

```ruby
    class Contacts < ModelController
        def hello
            tasks.call('LoggingTasks', 'log', 'Hello World!')
        end
    end
```

You can also pass a block to ```tasks.call``` that will receive the return value of your task as soon as it's done.

```ruby
    tasks.call('MathTasks', 'add', 23, 5) do |result|
        # result should be 28
        alert result
    end
```

# Components

Apps are made up of Components.  Each folder under app/ is a component.  When you visit a route, it loads all of the files in the component on the front end, so new pages within the component can be rendered without a new http request.  If a URL is visited that routes to a different component, the request will be loaded as a normal page load and all of that components files will be loaded.  You can think of components as the "reload boundary" between sections of your app.

## Dependencies

You can also use controls (see below) from one component in another.  To do this, you must require the component from the component you wish to use them in.  This can be done in the ```config/dependencies.rb``` file.  Just put

```ruby
    component 'component_name'
```

in the file.

Dependencies act just like require in ruby, but for whole components.

Sometimes you may need to include an externally hosted JS file from a component.  To do this, simply do the following in the dependencies.rb file:

```ruby
    javascript_file 'http://code.jquery.com/jquery-2.0.3.min.js'
    css_file '//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css'
```

Note above though that jquery and bootstrap are currently included by default.  Using javascript_file and css_file will be mixed in with your component assets at the correct locations according to the order they occur in the dependencies.rb files.

## Assets

**Note, asset management is still early, and likely will change quite a bit**

In Volt, assets such as JavaScript and CSS (or sass) are automatically included on the page for you.  Anything placed inside of a components asset/js or assets/css folder is served at /assets/{js,css} (via [Sprockets](https://github.com/sstephenson/sprockets)).  Link and script tags are automatically added for each css and js file in assets/css and assets/js respectively.  Files are included in their lexical order, so you can add numbers in front if you need to change the load order.

Any JS/CSS from an included component or component gem will be included as well.  By default [bootstrap](http://getbootstrap.com/) is provided by the volt-bootstrap gem.

**Note: asset bundling is on the TODO list**

## Component Generator

Components can easily be shared as a gem.  Volt provides a scaffold for component gems.  In a folder (not in a volt project), simply type: volt gem {component_name}  This will create the files needed for the gem.  Note that all volt component gems will be prefixed with volt- so they can easily be found by others on github and rubygems.

While developing, you can use the component by placing the following in your Gemfile:

```ruby
gem 'volt-{component_name}', path: '/path/to/folder/with/component'
```

Once the gem is ready, you can release it to ruby gems with:

    rake release

Remove the path: option in the gemfile if you wish to use the rubygems version.

## Provided Components

Volt provides a few components to make web developers' lives easier.

### Notices

Volt automatically places ```<:volt:notices />``` into views.  This shows notices for the following:

1. flash messages
2. connection status (when a disconnect happens, lets the user know why and when a reconnect will be attempted)
3. page reloading notices (in development)

### Flash

As part of the notices component explained above, you can append messages to any collection on the flash model.

Each collection represents a different type of "flash".  Common examples are ```_notices, _warnings, and _errors```  Using different collections allows you to change how you want the flash displayed.  For example, you might want ```_notices``` and ```_errors``` to show with different colors.

```ruby
    flash._notices << "message to flash"
```

These messages will show for 5 seconds, then disappear (both from the screen and the collection).

# Controls

Everyone wishes that we could predict the scope and required features for each part of our application, but in the real world, things we don't expect to grow large often do and things we think will be large don't end up that way.  Controls let you quickly setup reusable code/views.  The location of the controls code can be moved as it grows without changing the way controls are invoked.

To render a control, simply use a tag like so:

```html
    <:control-name />
```

or

```html
    <:control-name></:control-name>
```

To find the control's views and optional controller, Volt will search the following (in order):

| Section   | View File    | View Folder    | Component   |
|-----------|--------------|----------------|-------------|
| :{name}   |              |                |             |
| :body     | {name}.html  |                |             |
| :body     | index.html   | {name}         |             |
| :body     | index.html   | index          | {name}      |
| :body     | index.html   | index          | gems/{name} |

**Note that anything with a view folder will also load a controller if the name/folder matches.**


Each part is explained below:

1. section
Views are composed of sections.  Sections start with a ```<:SectionName>``` and are not closed.  Volt will look first for a section in the same view.

2. views
Next Volt will look for a view file with the control name.  If found, it will render the body section of that view.

3. view folder
Failing above, Volt will look for a view folder with the control name, and an index.html file within that folder.  It will render the :body section of that view.  If a controller exists for the view folder, it will make a new instance of that controller and render in that instance.

4. component
Next, all folders under app/ are checked.  The view path looked for is {component}/index/index.html with a section of :body.

5. gems
Lastly the app folder of all gems that start with volt are checked.  They are checked for a similar path to component.

When you create a control, you can also specify multiple parts of the search path in the name.  The parts should be separated by a :  Example:

```html
    <:blog:comments />
```

The above would search the following:

| Section   | View File    | View Folder    | Component   |
|-----------|--------------|----------------|-------------|
| :comments | blog.html    |                |             |
| :body     | comments.html| blog           |             |
| :body     | index.html   | comments       | blog        |
| :body     | index.html   | comments       | gems/blog   |

Once the view file for the control or template is found, it will look for a matching controller.  If the control is specified as a local template, an empty ModelController will be used.  If a controller is found and loaded, a corresponding "action" method will be called on it if its exists.  Action methods default to "index" unless the component or template path has two parts, in which case the last part is the action.

# Control Arguments/Attributes

Like other html tags, controls can be passed attributes.  These are then converted into an object that is passed as the first argument to the initialize method on the controller.  The standard ModelController's initialize will then assign the object to the attrs property which can be accessed with ```#attrs```  This makes it easy to access attributes passed in.

```html

<:Body>

  <ul>
    {{ _todos.each do |todo| }}
      <:todo name="{{ todo._name }}" />
    {{ end }}
  </ul>

<:Todo>
  <li>{{ attrs.name }}</li>
```

Instead of passing in individual attributes, you can also pass in a Model object with the "model" attribute and it will be set as the model for the controller.

```html
<:Body>
  <ul>
    {{ _todos.each do |todo| }}
      <:todo model="{{ todo }}" />
    {{ end }}
  </ul>

<:Todo>
  <li>
    {{ _name }} -
    {{ if _complete }}
      Complete
    {{ end }}
  </li>
```

# Routes

Routes in Volt are very different from traditional backend frameworks.  Since data is synchronized using websockets, routes are mainly used to serialize the state of the application into the url in a pretty way.  When a page is first loaded, the URL is parsed with the routes and the params model's values are set from the URL.  Later if the params model is updated, the URL is updated based on the routes.

This means that routes in Volt have to be able to go both from URL to params and params to URL.  It should also be noted that if a link is clicked and the controller/view to render the new URL is within the current component (or an included component), the page will not be reloaded, the URL will be updated with the HTML5 history API, and the params hash will reflect the new URL.  You can use the changes in params to render different views based on the URL.

## Routes file

Routes are specified on a per-component basis in the config/routes.rb file.  Routes simply map from URL to params.

```ruby
    get "/todos", {_view: 'todos'}
```

Routes take two arguments; a path, and a params hash.  When a new URL is loaded and the path is matched on a route, the params will be set to the params provided for that route.  The specified params hash acts as a constraint.  An empty hash will match any url.  Any params that are not matched will be placed in the query parameters.

When the params are changed, the URL will be set to the path for the route whose params hash matches.

Route paths can also contain variables similar to bindings:

```ruby
    get "/todos/{{ _index }}", _view: 'todos'
```

In the case above, if any URL matches /todos/*, (where * is anything but a slash), it will be the active route. ```params._view``` would be set to 'todos', and ```params._index``` would be set to the value in the path.

If ```params._view``` were 'todos' and ```params._index``` were not nil, the route would be matched.

Routes are matched top to bottom in a routes file.

# Channel

Controllers provide a `#channel` method, that you can use to get the status of the connection to the backend.  Channel is provided in a ReactiveValue, and when the status changes, the changed events are triggered.  It provides the following:

| method      | description                                               |
|-------------|-----------------------------------------------------------|
| connected?  | true if it is connected to the backend                    |
| status      | possible values: :opening, :open, :closed, :reconnecting  |
| error       | the error message for the last failed connection          |
| retry_count | the number of reconnection attempts that have been made without a successful connection |
| reconnect_interval | the time until the next reconnection attempt (in seconds) |


# Testing

** Testing is being reworked at the moment.
Volt provides rspec and capybara out of the box.  You can test directly against your models, controllers, etc... or you can do full integration tests via [Capybara](https://github.com/jnicklas/capybara).

To run Capybara tests, you need to specify a driver.  The following drivers are currently supported:

1. Phantom (via poltergeist)

```BROWSER=phantom bundle exec rspec```

2. Firefox

```BROWSER=firefox bundle exec rspec```

3. IE - coming soon

Chrome is not supported due to [this issue](https://code.google.com/p/chromedriver/issues/detail?id=887#makechanges) with ChromeDriver.  Feel free to go [here](https://code.google.com/p/chromedriver/issues/detail?id=887#makechanges) and pester the chromedriver team to fix it.

# Debugging

An in browser irb is in the works.  We also have source maps support, but they are currently disabled by default.  To enable them run:

    MAPS=true volt s

This feature is disabled by default because (due to the volume of pages rendered) it slows down page rendering. We're working with the opal and sprockets teams to make it so everything is still served in one big source maps file (which would show the files as they originated on disk)

# Volt Helpers

## Logging

Volt provides a helper for logging.  Calling ```Volt.logger``` returns an instance of the ruby logger.  See [here](http://www.ruby-doc.org/stdlib-2.1.3/libdoc/logger/rdoc/Logger.html) for more.

```ruby
Volt.logger.info("Some info...")
```

You can change the logger with:

```ruby
Volt.logger = Logger.new
```

## App Configuration

Like many frameworks, Volt changes some default settings based on an environment flag.  You can set the volt environment with the VOLT_ENV environment variable.

All files in the app's ```config``` folder are loaded when Volt boots.  This is similar to the ```initializers``` folder in Rails.

Volt does its best to start with useful defaults.  You can configure things like your database and app name in the config/app.rb file.  The following are the current configuration options:

| name      | default                   | description                                                   |
|-----------|---------------------------|---------------------------------------------------------------|
| app_name  | the current folder name   | This is used internally for things like logging.              |
| db_driver | 'mongo'                   | Currently mongo is the only supported driver, more coming soon|
| db_name   | "#{app_name}_#{Volt.env}  | The name of the mongo database.                               |
| db_host   | 'localhost'               | The hostname for the mongo database.                          |
| db_port   | 27017                     | The port for the mongo database.                              |
| compress_deflate | false              | If true, will run deflate in the app server, its better to let something like nginx do this though |

## Accessing DOM section in a controller

TODO

# Contributing

You want to contribute?  Great!  Thanks for being awesome!  At the moment, we have a big internal todo list, hop on https://gitter.im/voltrb/volt so we don't duplicate work.  Pull requests are always welcome, but asking about helping on gitter should save some duplication.

[![Pledgie](https://pledgie.com/campaigns/26731.png?skin_name=chrome)](https://pledgie.com/campaigns/26731)
