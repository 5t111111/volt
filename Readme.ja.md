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
 - [Volt Todoアプリケーションの例](https://www.youtube.com/watch?v=6ZIvs0oKnYs)
 - [Voltでブログを構築する](https://www.youtube.com/watch?v=c478sMlhx1o)
 - [Voltでのリアクティブバリューについて](https://www.youtube.com/watch?v=yZIQ-2irY-Q)

デモアプリケーションも用意しています。
 - https://github.com/voltrb/todos3
 - https://github.com/voltrb/blog
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

1. リアクティブモデルクエリー
2. ブロックを使ったリアクティブEnumerators（.mapや.countなど）
3. （高速なレンダリングのための）フルマネージドなループレンダリング
4. いくつかのリアクティブな値に関しての「N + 1」問題の修正（修正する方法は分かっていますが、対応する余裕がありません）

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
  1. [リアクティブバリュー](#リアクティブバリュー)
    1. [ReactiveValueについて気に留めておくべきこと](#ReactiveValueについて気に留めておくべきこと)
3. [ビュー](#ビュー)
  1. [バインディング](#バインディング)
    1. [コンテンツバインディング](#コンテンツバインディング)
    2. [ifバインディング](#ifバインディング)
    3. [eachバインディング](#eachバインディング)
    4. [属性バインディング](#属性バインディング)
    5. [エスケープ](#エスケープ)
4. [Models](#models)
  1. [Provided Collections](#provided-collections)
  2. [Reactive Models](#reactive-models)
  3. [Model Events](#model-events)
  4. [Automatic Model Conversion](#automatic-model-conversion)
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


# ヘルプ

Voltはまだ開発中ですが、早期のフィードバックは大歓迎です。
開発者とコンタクトを取りたいときには、以下を使ってくれれば、誰かが素早く返答してくれることでしょう。

- **ヘルプが欲しい！**: [stackoverflow.com](http://www.stackoverflow.com) に投稿してください。質問に`voltrb`タグを付けるのを忘れないように。
- **バグを見つけたとき**: [github issues](https://github.com/voltrb/volt/issues) に投稿してください。
- **Voltへの提案がある、こんな機能が欲しい**: [github issues](https://github.com/voltrb/volt/issues) に投稿してください。
- **Voltについて議論したい**: Freenodeの #voltrb で。


# レンダリング

ユーザーがウェブページに対して操作を行ったときに行いたい処理は、以下が典型的なものでしょう。

1. アプリケーションの状態を変える
2. DOMを更新する

例えば、ユーザーが「新しいtodoアイテムをtodoリストに追加」するボタンをクリックしたときの処理は、todoアイテムを表すJavaScriptオブジェクトを作成し、そのアイテムをリストのDOMに追加するものになると思います。
その際、JavaScriptのオブジェクトとDOMの状態が確実に同期しておくようにするためには、多くの手間のかかる処理が必要です。

「リアクティブプログラミング」という手法は、DOMの管理をシンプルにするために使われます。
この手法では、モデル(もしくはJavaScriptのオブジェクト)を管理するイベントハンドラを持つ代わりに、リアクティブデータモデルを管理するイベントハンドラを持ちます。

DOMのレイヤーを宣言的に記述しておくことで、データモデルをどのようにレンダリングすべきかについて自動的に判別することができます。

## リアクティブバリュー

Voltは、バインディングを構築するためのReactiveValueクラスを提供します。
このクラスを使用することで、任意のオブジェクトをリアクティブなインターフェースでラップすることができます。
ReactiveValueクラスは、単純に、ラップしたいオブジェクトをnewメソッドの第一引数に渡すことで作成できます。

```ruby
    a = ReactiveValue.new("my object")
    # => @"my object"
```

ReactiveValueに対して`#inspect`を実行すると(xx #2 like in the console)、その値を示す文字列の前に'@'が付与されているのが分かります。これによって、その値がリアクティブであることを判別することが可能です。

ReactiveValueに対してメソッドを実行すると、以前の値に応じた新しいリアクティブバリューが返ってきます。
リアクティブバリューは、自分がどのように作られたのかを記憶していて、`#cur`を実行することで、いつでも現在の値を取得することが可能です。
現在の値というのは、その元になったリアクティブバリューを基準にして計算されます。
(ただし、以下で「+」がメソッド呼び出しであることは気に留めておいてください。Rubyでの `a.+(b)` と同様です。)

```ruby
    a = ReactiveValue.new(1)
    a.reactive?
    # => true

    a.cur
    # => 1

    b = a + 5
    b.reactive?
    # => true

    b.cur
    # => 6

    a.cur = 2
    b.cur
    # => 7
```

このことがリアクティブプログラミングのバックボーンを提供します。
例えば、実際に自分で計算をすることなく、計算/フローグラフ(xx #2)を設定することができます。
 `#cur` (または `#inspect`、 `#to_s`など)を呼び出すことで、それらすべてが自分の依存関係に基づいて、その時点での現在の値を返します。

ReactiveValueには、リスナーとイベントトリガーを設定することも可能です。

```ruby
    a = ReactiveValue.new(0)
    a.on('changed') { puts "A changed" }
    a.trigger!('changed')
    # => A Changed
```


これらのイベントは、そのリアクティブバリューを元にしたすべてのリアクティブバリューに対しても伝わります。

```ruby
    a = ReactiveValue.new(1)
    b = a + 5
    b.on('changed') { puts "B changed" }

    a.trigger!('changed')
    # => B changed
```

このイベントフローによってオブジェクトの変更を検知することができるので、そのオブジェクトに依存したすべてを更新することが可能になっています。

最後にもう一つ。リアクティブバリューのメソッドの引数に、別のリアクティブバリューを指定することができます。
その両方に対して依存関係の追跡が行われて、両方からイベントが伝播されます。
(`#cur=`を呼び出して現在の値を更新することは、"changed"イベントのトリガーとなることを覚えておいてください。)

```ruby
    a = ReactiveValue.new(1)
    b = ReactiveValue.new(2)
    c = a + b

    a.on('changed') { puts "A changed" }
    b.on('changed') { puts "B changed" }
    c.on('changed') { puts "C changed" }

    a.cur = 3
    # => A changed
    # => C changed

    b.cur = 5
    # => B changed
    # => C changed
```

### ReactiveValueについて気に留めておくべきこと

ReactiveValueについて、いくつかのことを気に留めておく必要があります。
ReactiveValueが他のRubyオブジェクトと最大限に互換性を保てるように、以下の2つのメソッドはReactiveValueを返さないようになっています。

    to_s and inspect

もしこれらをリアクティブに扱いたければ、[with](#with)の項を参照してください。

また、これはRubyの制限によるものですが、ReactiveValueは常に真となってしまいます。
真偽チェックの方法については[真偽チェック](#真偽チェック: .true?, .false?, .or, .and)の項を参照してください。

何らかのリアクティブバリューを含むものをJSの関数に渡した場合、オブジェクトに対して```#deep_cur```を実行することで、すべてのリアクティブバリューを、その現在の値にしたものを含んだコピーを取得することができます。

### 現在のステータス

注意: 現在、ReactiveValueはまだ完全なものではありません。
今のところ、RealctiveValueはブロック(またはprocやlambda)を渡すメソッドを扱うことができません。
これについて対応する計画はありますが、まだ終わっていません。
現時点では、同様の処理を実現したい場合には[with](#with)を使ってください、

### 真偽チェック: .true?, .false?, .or, .and
リアクティブバリューのメソッドはリアクティブバリューを返しますが、Rubyではnilとfalseのみが偽であるため、ReactiveValueがコード中で真であるかをチェックする方法が必要になります。
そのための一番簡単な方法は .true? を実行することです。
このメソッドはラップされていないboolean値を返します。
nil? や false? も期待通りの動きをします。

真偽チェックを利用するよくあるケースに、|| (論理和)を使ってデフォルト値を設定するものがあります。
Voltは、リアクティブバリューに対して、これと同様の働きをするメソッド `#or` を提供します。

こう書くのではなく、

```ruby
    a || b
```

こう書きます。

```ruby
    a.or(b)
```

`#and` は && と同様の働きをします。
\#and と #or によって、リアクティブ性をずっと保持し続けることができます。


### With

他の値に依存している値があったとして、それを変更したい場合には、単純に変更するためのメソッドをReactiveValueに対して実行すればよいです。
ただ、変換が直接ReactiveValueオブジェクトに対して行われないこともしばしばあります。

すべてのReactiveValueに対して`#with`メソッドを実行することができます。
`#with`は現在のReactiveValueに応じた新しいReactiveValueを返します。
`#with`にはブロックを渡すこともできて、ブロックの第1引数に指定した値が、`#with`を実行したReactiveValueの現在(cur)の値となります。
`#with`に追加で渡した引数はすべて第1引数に続けて渡されます。
もし、`#with`に他のReactiveValueを引数として渡した場合には、返ってくるReactiveValueはその引数のReactiveValueに依存し、そのときブロックは引数の現在の(cur)値を受け取ります。


```ruby
    a = ReactiveValue.new(5)
    b = a.with {|v| v + 10 }
    b.cur
    # => 15
```

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

-- TODO: select boxes

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

Volt comes with many built-in models; one is called `page`.  If you call `#page` on a controller, you will get access to the model.  Models provided by Volt are automatically wrapped in a ReactiveValue so update events can be tracked.

Volt

```ruby
    page._name = 'Ryan'
    page._name
    # => @'Ryan'
```

Models act like a hash that you can access with getters and setters that start with an _ .  If an underscore method is called that hasn't yet been assigned, you will get back a "nil model".  Prefixing with an underscore makes sure we don't accidentally try to call a method that doesn't exist and get back nil model instead of raising an exception.  There is no need to define which fields a model has. Fields behave similarly to a hash, but with a different access and assignment syntax.

Models also let you nest data without creating the intermediate models:

```ruby
    page._settings._color = 'blue'
    page._settings._color
    # => @'blue'

    page._settings
    # => @#<Model:_settings {:_color=>"blue"}>
```

Nested data is automatically setup when assigned.  In this case, page._settings is a model that is part of the page model.

You can also append to a model if it's not defined yet.  In Volt models, plural properties are assumed to contain arrays (or more specifically, ArrayModels).

```ruby
    page._items << 'item 1'
    page._items
    # => @#<ArrayModel ["item 1", "item 2"]>

    page._items[0]
    # => @"item 1"
```

ArrayModels can be appended to and accessed just like regular arrays.

## Provided Collections

Above, I mentioned that Volt comes with many default collection models accessible from a controller.  Each stores in a different location.

| Name      | Storage Location                                                          |
|-----------|---------------------------------------------------------------------------|
| page      | page provides a temporary store that only lasts for the life of the page. |
| store     | store syncs the data to the backend database and provides query methods.  |
| session   | values will be stored in a session cookie.                                |
| params    | values will be stored in the params and URL.  Routes can be setup to change how params are shown in the URL.  (See routes for more info) |
| flash     | any strings assigned will be shown at the top of the page and cleared as the user navigates between pages. |
| controller| a model for the current controller                                        |

**more storage locations are planned**

## Reactive Models

Because all models provided by Volt are wrapped in a ReactiveValue, you can register listeners on them and be updated when values change.  You can also call methods on their values and get updates when the sources change.  Bindings also setup listeners.  Models should be the main place you store all data in Volt.  While you can use ReactiveValues manually, most of the time you will want to just use something like the controller model.

## Model Events

Models trigger events when their data is updated.  Currently, models emit three events: changed, added, and removed.  For example:

```ruby
    model = Model.new

    model._name.on('changed') { puts 'name changed' }
    model._name = 'Ryan'
    # => name changed

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
      twitter: 'http://www.twitter.com/ryanstout',
      dribbble: 'http://dribbble.com/ryanstout'
    }

    user._profiles.to_h
    # => {twitter: 'http://www.twitter.com/ryanstout', dribbble: 'http://dribbble.com/ryanstout'}

    items = ArrayModel.new([1,2,3,4])
    items
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
