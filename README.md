# BindableUIKit

UIKitとCombineを統合し、プロパティラッパーによるリアクティブなデータバインディングを提供するSwiftパッケージです。

## 特徴

- **`@Source`** — データをCombineの`CurrentValueSubject`として公開するプロパティラッパー
- **`@Bindable` / `@WeakBindable`** — PublisherからUIプロパティへの単方向バインディング
- **`@BiDiBindable` / `@WeakBiDiBindable`** — データソースとUI間の双方向バインディング
- **`ValueBindable`プロトコル** — `UITextField`、`UITextView`、`UISwitch`、`UISlider`、`UIStepper`、`UISegmentedControl`、`UIDatePicker`、`UIPageControl`、`UISearchBar`に対応済み

## 動作環境

- iOS 14+
- Swift 6.2+

## インストール

### Swift Package Manager

`Package.swift`の`dependencies`に追加してください。

```swift
dependencies: [
    .package(url: "https://github.com/trickart/BindableUIKit.git", from: "1.0.0")
]
```

## 使い方

### データソースの定義

`@Source`でデータを定義すると、`$`プレフィックスで`CurrentValueSubject`としてアクセスできます。

```swift
class ViewController: UIViewController {
    @Source var count = 0
    @Source var text = ""
}
```

### 単方向バインディング

`@Bindable`でUIを宣言し、`bind(_:to:)`でPublisherとUIプロパティを接続します。

```swift
@Bindable var label = UILabel()

override func viewDidLoad() {
    super.viewDidLoad()
    // count の変更を String に変換してラベルに反映
    $label.bind($count.map(String.init), to: \.text)
}
```

`@WeakBindable`は弱参照版で、`@IBOutlet`との併用に適しています。

```swift
@IBOutlet @WeakBindable var label: UILabel!

override func viewDidLoad() {
    super.viewDidLoad()
    $label.bind($count.map(String.init), to: \.text)
}
```

### 双方向バインディング

`@BiDiBindable`を使うと、UIの入力変更がデータソースに自動反映され、データソースの変更もUIに反映されます。

```swift
@BiDiBindable var textField = UITextField()

override func viewDidLoad() {
    super.viewDidLoad()
    // textField と text を双方向に同期
    $textField.bind(with: $text)
}
```

`@WeakBiDiBindable`は弱参照版で、`@IBOutlet`との併用に適しています。

```swift
@IBOutlet @WeakBiDiBindable var textField: UITextField!

override func viewDidLoad() {
    super.viewDidLoad()
    $textField.bind(with: $text)
}
```

### 対応UIコンポーネント（ValueBindable）

| コンポーネント | バインド値 | 変更イベント |
|---|---|---|
| `UITextField` | `String`（テキスト） | `.editingChanged` |
| `UITextView` | `String`（テキスト） | `textDidChangeNotification` |
| `UISwitch` | `Bool`（オン/オフ） | `.valueChanged` |
| `UISlider` | `Float`（値） | `.valueChanged` |
| `UIStepper` | `Double`（値） | `.valueChanged` |
| `UISegmentedControl` | `Int`（選択インデックス） | `.valueChanged` |
| `UIDatePicker` | `Date`（日付） | `.valueChanged` |
| `UIPageControl` | `Int`（現在のページ） | `.valueChanged` |
| `UISearchBar` | `String`（検索テキスト） | `textDidChangeNotification` |

## ライセンス

MIT License
