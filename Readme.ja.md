This is a project forked from original Volt and is intended to translate Readme (and also other documents, if available) to Japanese, still in progress though.

VoltのReadme(および他のドキュメントがあればそれも)を日本語訳をするためのプロジェクトですが、まだ不完全です。

=======

** Voltの現在の状態についてはここで確認してください。
http://voltframework.com/blog

# Volt

VoltはRubyのWebフレームワークで、サーバーサイドとクライアントサイド、その両方のコードをRubyで書くことができます(クライアント側では[Opal](https://github.com/opal/opal)を利用)。
Voltでは、ユーザーがページに対して行った操作に応じて、自動的にDOMが更新されます。
また、ページの状態をURLとして保持することができます。
ユーザーがURLに直接アクセスした場合、HTMLはまずサーバー上でレンダリングされます。
これは、ロード時間の高速化や、検索エンジンによるインデックス化を容易にするためです。

Voltでは、HTTPを介してクライアントとサーバー間のデータを同期するのではなく、クライアントとサーバー間の永続的なコネクションを利用します。
したがって、ある1つのクライアント上でデータが更新されたときには、データベース、および他のリスニング中のクライアント上でも更新が行われます。
しかも、そのための設定用コードを書く必要はほとんどありません。

ページのHTMLは、Handlebarsに似たテンプレート言語で記述します。
Voltは、DOM(および値が更新されたことを検知したい他のすべてのコード)に対して、自動的かつ正確に変更を伝えるために、データフロー／リアクティブプログラミングを利用します。
DOMのある値が変わったとき、Voltは、変更が必要なノードだけを正しく更新することができます。

いくつかのデモ動画を用意しています。
** 注意: これらのビデオは古いものです。新しいビデオを公開する予定です。
 - [Volt Todoアプリケーションの例](https://www.youtube.com/watch?v=6ZIvs0oKnYs)
 - [Voltでブログを構築する](https://www.youtube.com/watch?v=c478sMlhx1o)
 - [Voltでのリアクティブバリューについて](https://www.youtube.com/watch?v=yZIQ-2irY-Q)

デモアプリケーションも用意しています。
 - https://github.com/voltrb/todos3
 - https://github.com/voltrb/contactsdemo


## 目指すゴール

Voltは以下のゴールを達成することを目標としています。

1. 開発者のしあわせ
2. クライアントとサーバーでの「write once」
3. クライアントとサーバー間の自動的なデータ同期
4. 階層的なコンポーネントで構築されたアプリケーション。コンポーネントは(Gemを介して)共有可能。
5. 並行性。Voltは、シンプルに並行性を実現するツールを提供する。コンポーネントのレンダリングは、サーバー上で並列実行される。
6. 賢いアセット管理
7. セキュアであること（わざわざ言うべきことではないですが）
8. 高速/軽量
9. 理解しやすいコードベース
10. アップグレードをコントロール可能であること(xx #2)

# ロードマップ

Voltの核となる機能の多くはすでに実装済みです。
しかし、1.0のリリースまでに対応すべきことがまだいくつか残っていて、そのほとんどはモデルに関するものです。

1. モデルのread/write権限
2. ユーザーアカウント、ユーザーコレクション、サインアップ/ログインのテンプレート

# Volt ガイド

ここでは、Voltで基本的なWebアプリケーションを作成する手順を示します。
このチュートリアルは、RubyとWeb開発の基本的な知識を持っていることを前提とします。

まずはVoltをインストールします。

    gem install volt

次に、新しいプロジェクトを作成します。

    volt new project_name

これで、基本的なプロジェクトがセットアップされます。
では、サーバーを起動してみましょう。

    bundle exec volt server

以下で、Voltのコンソールにアクセスすることができます。

    bundle exec volt console

# ガイドセクション

1. [ヘルプ](#ヘルプ)
2. [レンダリング](#レンダリング)
  1. [状態と計算](#状態と計算)
  1. [計算](#計算)
3. [ビュー](#ビュー)
  1. [バインディング](#バインディング)
    1. [コンテンツバインディング](#コンテンツバインディング)
    2. [ifバインディング](#ifバインディング)
    3. [eachバインディング](#eachバインディング)
    4. [属性バインディング](#属性バインディング)
    5. [エスケープ](#エスケープ)
4. [Models](#models)
  1. [Provided Collections](#provided-collections)
  2. [ArrayModel Events](#arraymodel-events)
  3. [Automatic Model Conversion](#automatic-model-conversion)
5. [Controllers](#controllers)
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
11. [Volt Helpers](#volt-helpers)
  1. [Logging](#logging)


# ヘルプ

Voltはまだ開発中ですが、早期のフィードバックは大歓迎です。
開発者とコンタクトを取りたいときには、以下を使ってくれれば、誰かが素早く返答してくれることでしょう。

- **ヘルプが欲しい！**: [stackoverflow.com](http://www.stackoverflow.com) に投稿してください。質問に`voltrb`タグを付けるのを忘れないように。
- **バグを見つけたとき**: [github issues](https://github.com/voltrb/volt/issues) に投稿してください。
- **Voltへの提案がある、こんな機能が欲しい**: [github issues](https://github.com/voltrb/volt/issues) に投稿してください。
- **Voltについて議論したい**: [gitterのチャット](https://gitter.im/voltrb/volt), 通常、Voltチームが誰かがオンラインです。喜んで助けになります。


# レンダリング

ユーザーがウェブページに対して操作を行ったときに行いたい処理は、以下が典型的なものでしょう。

1. アプリケーションの状態を変える
2. DOMを更新する

例えば、ユーザーが「新しいtodoアイテムをtodoリストに追加」するボタンをクリックしたときの処理は、todoアイテムを表すオブジェクトを作成し、そのアイテムをリストのDOMに追加するものになると思います。
その際、オブジェクトとDOMの状態が確実に同期しておくようにするためには、多くの手間のかかる処理が必要です。

「リアクティブプログラミング」という手法は、DOMの管理をシンプルにするために使われます。
この手法では、モデルを管理するイベントハンドラを持つ代わりに、リアクティブデータモデルを管理するイベントハンドラを持ちます。

DOMのレイヤーを宣言的に記述しておくことで、データモデルをどのようにレンダリングすべきかについて自動的に判別することができます。

## 状態と計算

Webアプリケーションの中心的な仕事は状態を管理することです。
多くのイベントは状態を変更します。
例えば、フォーム要素へテキストを入力する、ボタンをクリックする、リンク、スクロール...これらの操作はすべてアプリケーションの状態を変更するものです。

アプリケーションの状態管理をシンプルにするために、すべてのアプリケーションの状態は異なる場所に永続化されるモデルの中に保存されます。
アプリケーションの状態を一元管理することで、ページを更新するために必要となる複雑なコードをかなり減らすことができます。

モデルのデータが変更されたとき、自動的にDOMを更新したいと思うことでしょう。
そのためにVoltは、すべてのメソッド/Procの呼び出しを"監視(watch)"し、メソッド/procの呼び出しによってデータが変更されたときにもそれを知ることができます。xx


### 計算

実例を見てみましょう。
ここでは、```page```コレクションを例とします。(より多くのコレクションは後で出てきます)

はじめに、計算の監視を設定します。
計算はProcに対する .watch! を呼び出すことで設定されまうｓ．
ここでは、Ruby 1.9のProcの短縮シンタックス ```-> { .. }``` を使います。
これを一度実行すると、page._name が変更されたときに毎回実行されるようになります。

```ruby
    page._name = 'Ryan'
    -> { puts page._name }.watch!
    # => Ryan
    page._name = 'Jimmy'
    # => Jimmy
```

page._nameに新しい値が代入されると、そのたびに計算が実行されます。
前回計算されたデータが変更されたとき、計算は再度トリガーされて再実行されます。

```ruby
    page._first = 'Ryan'
    page._last = 'Stout'

    def lookup_name
      return "#{page._first} #{page._last}"
    end

    -> do
      puts lookup_name
    end.watch!
    # => Ryan Stout

    page._first = 'Jimmy'
    # => Jimmy Stout

    page._last = 'Jones'
    # => Jimmy Jones
```

.watch! を実行したときの戻り値は計算オブジェクトです。
もうそれ以上更新を受け取り必要がない場合には、計算オブジェクトに対し .stop メソッドを実行してください。

```ruby
    page._name = 'Ryan'

    comp = -> { puts page._name }.watch!
    # => Ryan

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

Voltでは、ビューはHandlebarsに似たテンプレート言語を使用します。


```html
<:Body>
```

セクションヘッダーは先頭が大文字で始まる必要があります。[コントロール](#コントロール)と混同しないようにしてください。
セクションヘッダーに閉じタグは使いません。
もしセクションヘッダーを書かなかった場合は、Bodyセクションであるとして扱います。

セクションは同じファイルの内のコンテンツの異なるパーツ(タイトルと本文など)を区別するのに役立ちます。

## バインディング

ReactiveValueの基礎を理解したら、次はバインディングの話です。
Voltでは、Handlebarsに似たテンプレート言語でビューのコードを記述します。
Voltはレンダリングのためのいくつかのバインディングを提供しています。
例えば、{ と } で括られたものは、コンテンツバインディングとなります。

### コンテンツバインディング

もっとも基本的なバインディングはコンテンツバインディングです。

```html
    <p>{some_method}<p>
```

コンテンツバインディングとは、{ と } の間のRubyコードを実行し、その戻り値をレンダリングするものです。
もしその戻り値がリアクティブバリューであった場合は、'changed'イベントが発生したときには常に値が更新されます。

### ifバインディング

ifバインディングは、基本的な制御機構を提供します。

```html
    {#if _some_check?}
      <p>render this</p>
    {/}
```

ブロックは {/} で閉じます。

ifバインディングがレンダリングされるときは、#if に続くRubyコードが実行されます。
そのコードが真の場合にのみ、下のコードがレンダリングされます。
ここでも、戻り値がリアクティブバリューの場合には、変更に応じてその値が更新されます。

また、ifバインディングは #elsif と #else ブロックを持つことができます。

```html
    {#if _condition_1?}
      <p>condition 1 true</p>
    {#elsif _condition_2?}
      <p>condition 2 true</p>
    {#else}
      <p>neither true</p>
    {/}
```

### eachバインディング

オブジェクトのイテレーションのために、eachバインディングが用意されています。

```html
    {#each _items as item}
      <p>{item}</p>
    {/}
```

上記では、_itemが配列だった場合、'item'に配列の各要素の値がセットされ、ブロックはその要素それぞれに対してレンダリングを行います。

\#index メソッドを使うことで、配列の各要素の位置を得ることもできます。

```html
    {#each _items as item}
      <p>{index}. {item}</p>
    {/}
```

例えば、['one', 'two', 'three'] という配列の場合には、このように出力されます。

    0. one
    1. two
    2. three

ゼロオフセットを修正したければ {index + 1} としてください。

配列の要素が追加、または削除された場合には、#eachバインディングは自動的かつ正確に、要素をDOMに追加、もしくはDOMから削除します。

## 属性バインディング

バインディングは属性の中にも配置することができます。

```html
    <p class="{#if _is_cool?}cool{/}">Text</p>
```

また、要素を"双方向バインディング"とするため、特別な機能が提供されます。

```html
    <input type="text" value="{_name}" />
```

上記の例で、_nameが変更された場合、フィールドも更新されます。
反対に、フィールドが更新された場合には、_nameも更新されます。

```html
    <input type="checkbox" checked="{_checked}" />
```

この例では、checked属性の値がtrueであるとき、チェックボックスはチェックされた状態になります。
そして、チェックされた/チェック解除された という状態の変化に応じて、値がtrueまたはfalseに更新されます。

ラジオボタンもcheckedにバインドすることができますが、true/falseの代わりにフィールドの値がセットされます。

```html
    <input type="radio" checked="{_radio}" value="one" />
    <input type="radio" checked="{_radio}" value="two" />
```

ラジオボタンがチェックされたとき、常にcheckedはフィールドの値が設定されるようにバインドされます。
checkedにバインドされた値が変更されたとき、ラジオボタンのバインドされた値にマッチするフィールドがチェックされた状態になります。
メモ: ラジオボタンでは、これがもっとも便利な振る舞いだと思われます。

セレクトボックスは値にバインドすることができます。
(これは技術的には正しくありませんが、これも利便性のために追加している振る舞いです。)

```html
  <select value="{_rating}">
    <option value="1">*</option>
    <option value="2">**</option>
    <option value="3">***</option>
    <option value="4">****</option>
    <option value="5">*****</option>
  </select>
```

選択されたオプションが変わった場合、それに合うように```_rating```が変更されます。
```_rating```が変わったときには、マッチする最初のオプションが選択されます。
マッチするオプションが存在しなかった場合には、セレクトボックスは未選択の状態になります。

もしコントローラーが app/home/controller/index_controller.rb であり、ビューが app/home/views/index/index.html だった場合、すべてのメソッドはそのコントローラー上で呼び出されます。

## エスケープ

{ と } とバインディング以外で使いたい場合、3連の波括弧で囲んだ中にあるものはエスケープされ、バインディングとして処理されることはありません。

```html
    {{{ bindings look like: {this}  }}}
```

# モデル

多くのフレームワークでは、モデルという単語はデータベースとのORMに使われるものですが、Voltのモデルのコンセプトはそれとは少し異なります。
Voltにおいて、モデルはデータを簡単に保存しておくために利用できるクラスを指します。
モデルは、Persistorととも作成することができます。
そのPersistorというものが、モデルにおいてデータを保持するための役割を果たします。
Persistor無しでモデルを作った場合には、データは単純にクラスのインスタンスに保存されます。
どのようにモデルを使うのか、まず見てみましょう。

Voltには多くのモデルがビルトインされており、その1つに `page` モデルがあります。
コントローラーで `#page` を呼び出すことでモデルにアクセスすることができます。
Voltが提供するモデルはReactiveValueに自動的にラップされているので、更新のイベントを追跡することが可能です。

Volt

```ruby
    page._name = 'Ryan'
    page._name
    # => @'Ryan'
```

モデルは、アンダースコア(_)で始まるゲッター/セッターでアクセス可能なハッシュのように振る舞います。
もし、その「アンダースコアメソッド」がまだアサインされていなかった場合には、"nilモデル"が返ってきます。
アンダースコアを前置することによって、存在しないメソッドを誤って呼び出すことを回避したり、例外が発生することを避けnilモデルを返すようにすることができます。
モデルがどのようなフィールドを持つかを定義しておく必要はありません。
フィールドはハッシュのように振る舞いますが、アクセスと代入については異なるシンタックスを使用します。

また、モデルは中間的なモデルを作成することなくネストすることができます。

```ruby
    page._settings._color = 'blue'
    page._settings._color
    # => @'blue'

    page._settings
    # => @#<Model:_settings {:_color=>"blue"}>
```

ネストされたデータは、代入時に自動的に設定されます。
上記の例では、page._settingはpageモデルの一部を形成するモデルとなります。

また、定義されていないデータの場合には追加することができます。
Voltのモデルでは、複数形の名前を持ったプロパティは配列(より厳密に言えばArrayModels)を持っているとされます。

```ruby
    page._items << 'item 1'
    page._items
    # => @#<ArrayModel ["item 1", "item 2"]>

    page._items[0]
    # => @"item 1"
```

ArrayModelsに対しては、通常の配列と同じように追加や参照を行うことができます。

### Nil Models

As a convience, calling something like ```page._info``` returns what's called a NilModel (assuming it isn't already initialized).  NilModels are place holders for future possible Models.  NilModels allow us to bind deeply nested values without initializing any intermediate values.

```ruby
    page._info
    # => <Model:70260787225140 nil>

    page._info._name
    # => <Model:70260795424200 nil>

    page._info._name = 'Ryan'
    # => <Model:70161625994820 {:_info=><Model:70161633901800 {:_name=>"Ryan"}>}>
```

One gotchya with NilModels is that they are a truthy value (since only nil and false are falsy in ruby).  To make things easier, calling ```.nil?``` on a NilModel will return true.

One common place we use a truthy check is in setting up default values with || (logical or)  Volt provides a convenient method that does the same thing `#or`, but works with NilModels.

Instead of

```ruby
    a || b
```

Simply use:

```ruby
    a.or(b)
```

`#and` works the same way as &&.  #and and #or let you easily deal with default values involving NilModels.

-- TODO: Document .true? / .false?

## 提供されるコレクション

前述の通り、Voltにはコントローラーからアクセス可能な豊富なデフォルトのコレクションモデルが搭載されています。
そして、そのそれぞれが異なる場所に保存されます。

| 名前          | 保存場所                                                                                                                           |
|---------------|------------------------------------------------------------------------------------------------------------------------------------|
| page          | pageは一時的なデータ保存場所を提供します。そのページが生きている間だけ残ります。                                                   |
| store         | storeはバックエンドのデータベースと動機し、クエリメソッドを提供します。                                                            |
| local_store   | データはローカルに保存されます。                                                                                         |
| params        | データはパラメータとURLに保存されます。どのようにURLに表示するかはルーティングの設定にしたがいます。(詳細はルートを御覧ください。) |
| flash         | 代入された文字列がページの先頭に表示され、ユーザーによるページの移動で消去されます。                                               |
| controller    | 現在のコントローラーのためのモデルです。                                                                                           |

**上記以外のストレージについても計画中です。**

## ArrayModelイベント

## モデルイベント

モデルは、そのデータが更新されたときにイベントをトリガーします。
現在、モデルは、added, removed の2つのイベントを発生させます。


```ruby
    model = Model.new

    model._items.on('added') { puts 'item added' }
    model._items << 1
    # => item added

    model._items.on('removed') { puts 'item removed' }
    model._items.delete_at(0)
    # => item removed
```

## 自動モデル変換

### Hash -> Model


利便性のために、あるModelの中にHashを入れた場合、それは自動的にModelに変換されます。
ModelはHashに似ていますが、例えば永続化やイベントのトリガなどの機能がある点が異なります。

```ruby
    user = Model.new
    user._name = 'Ryan'
    user._profiles = {
      twitter: 'http://www.twitter.com/ryanstout',
      dribbble: 'http://dribbble.com/ryanstout'
    }

    user._name
    # => "Ryan"
    user._profiles._twitter
    # => "http://www.twitter.com/ryanstout"
    user._profiles.class
    # => Model
```

ModelへのアクセスのしかたはHashとは異なります。`model[:symbol]`を使うのではなく、`model.method_name`メソッドを呼び出します。
これは動的に生成される統一的なデータ保存機構であり、アクセスのためのコードを変更することなく、セッターとゲッターが追加されます。

Modelに対して`#to_h`を実行すると、RubyのHashに戻したものを得ることができます。


### Array -> ArrayModel

Modelの中のArrayは自動的にArrayModelのインスタンスに変換されます。
ArrayModelは通常のArrayと同様に振る舞いますが、バックエンドのデータにバインドしたり、リアクティブイベントを発生させたりできる点が異なります。

```ruby
    model = Model.new
    model._items << {_name: 'item 1'}
    model._items.class
    # => ArrayModel

    model._items[0].class
    # => Model
    model._items[0]
```


ModelやArrayModelを通常のハッシュやアレイに戻したい場合には、それぞれ .to_h と .to_a を実行してください。
(JavaScriptのコードに渡すために)JavaScriptのオブジェクトに変換したい場合には、`#to_n` (to native)を実行してください。

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

ArrayModelに対して.to_aを実行することで通常の配列を得ることができます。


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

In methods, the `#model` method returns the current model.

See the [provided collections](#provided-collections) section for a list of the available collection models.

You can also provide your own object to model.

In the example above, any methods not defined on the TodosController will fall through to the provided model.  All views in views/{controller_name} will have this controller as the target for any Ruby run in their bindings.  This means that calls on self (implicit or with self.) will have the model as their target (after calling through the controller).  This lets you add methods to the controller to control how the model is handled, or provide extra methods to the views.

Volt is more similar to an MVVM architecture than an MVC architecture.  Instead of the controllers passing data off to the views, the controllers are the context for the views.  When using a ModelController, the controller automatically forwards all methods it does not handle to the model.  This is convenient since you can set a model in the controller and then access its properties directly with methods in bindings.  This lets you do something like ```{_name}``` instead of something like ```{@model._name}```

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

Like other html tags, controls can be passed attributes.  These are then converted into a hash and passed as the first argument to the initialize method on the controller.  The standard ModelController's initialize will then assign each key/value in the attributes hash as instance values.  This makes it easy to access attributes passed in.

```html

<:Body>

  <ul>
    {#each _todos as todo}
      <:todo name="{todo._name}" />
    {/}
  </ul>

<:Todo>
  <li>{@name}</li>

```


# Routes

Routes in Volt are very different from traditional backend frameworks.  Since data is synchronized using websockets, routes are mainly used to serialize the state of the application into the url in a pretty way.  When a page is first loaded, the URL is parsed with the routes and the params model's values are set from the URL.  Later if the params model is updated, the URL is updated based on the routes.

This means that routes in Volt have to be able to go both from URL to params and params to URL.  It should also be noted that if a link is clicked and the controller/view to render the new URL is within the current component (or an included component), the page will not be reloaded, the URL will be updated with the HTML5 history API, and the params hash will reflect the new URL.  You can use the changes in params to render different views based on the URL.

## Routes file

Routes are specified on a per-component basis in the config/routes.rb file.  Routes simply map from URL to params.

```ruby
    get "/todos", _view: 'todos'
```

Routes take two arguments, a path, and a params hash.  When a new URL is loaded and the path is matched on a route, the params will be set to the params provided for that route.

When the params are changed, the URL will be set to the path for the route whose params hash matches.

Route paths can also contain variables similar to bindings:

```ruby
    get "/todos/{_index}", _view: 'todos'
```

In the case above, if any URL matches /todos/*, (where * is anything but a slash), it will be the active route. ```params._view``` would be set to 'todos', and ```params._index``` would be set to the value in the path.

If ```params._view``` were 'todos' and ```params._index``` were not nil, the route would be matched.

Routes are matched top to bottom in a routes file.

## Debugging

An in browser irb is in the works.  We also have source maps support, but they are currently disabled by default.  To enable them run:

    MAPS=true volt s

This feature is disabled by default because (due to the volume of pages rendered) it slows down page rendering. We're working with the opal and sprockets teams to make it so everything is still served in one big source maps file (which would show the files as they originated on disk)


## Channel

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

## Accessing DOM section in a controller

TODO


# Data Store

Volt provides a data store collection on the front-end and the back-end.  In store, all plural names are assumed to be collections (like an array), and all singular are assumed to be a model (like a hash).

```ruby
store._things
```

**Work in progress**

| state       | events bound | description                                                  |
|-------------|--------------|--------------------------------------------------------------|
| not_loaded  | no           | no events and no one has accessed the data in the model      |
| loading     | maybe        | someone either accessed the data or bound an event           |
| loaded      | yes          | data is loaded and there is an event bound                   |
| dirty       | no           | data was either accessed without binding an event, or an event was bound, but later unbound. |

# Contributing

You want to contribute?  Great!  Thanks for being awesome!  At the moment, we have a big internal todo list, hop on https://gitter.im/voltrb/volt so we don't duplicate work.  Pull requests are always welcome, but asking about helping on gitter should save some duplication.

[![Pledgie](https://pledgie.com/campaigns/26731.png?skin_name=chrome)](https://pledgie.com/campaigns/26731)
