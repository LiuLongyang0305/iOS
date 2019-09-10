# Swift之Optional

## 为什么需要Optional

1. Objective-C里面的nil是无类型指针，不同那个类型无法区别。
2. Objective-C
3. Objective-C中的所有对性都可以设置为nil，运行的时候不能直接判定当前对象是否为空。
4. Objective-C里面的nil只能使用在对象上，而其他类型则需要其他值表示，比如NSNotFound。也就是说值缺失的情况有了不同的表达方式。

## Optional

1. 变量类型后面加上?表示可选类型，有两层含义：

   1. 这里有值，等于x
   2. 这里根本没有值，即值为空

2. 可以给可选变量设置为nil表示值为空

   1. 在Objective-C中，nil表示一个纸箱不存在对象的指针
   2. 在Swift中，nil不是指针，他是值缺失的一中特殊类型，任何类型的可选项 都可以设置为nil而不仅仅是对象类型

### 可选项的使用

可选项无法直接使用，如果要使用可选项可以通过以下四种方式：

#### 强制解包

使用!号强制解包，如果可选项有值，则代码可以正常运行；如果可选项值缺失（即为nil)则运行时则会发生错误：

```txt
 Execution was interrupted, reason: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0).

 Fatal error: Unexpectedly found nil while unwrapping an Optional value
```

```swift
var str: String? = "abc"
print(str!.count)
```

#### 可选绑定

1. 可以使用可选项绑定判断可选项是否包含值，如果包含值就赋给一个临时的变量或者常量。
2. 可选绑定可以与if或者while一起使用检查可选项内部的值，并付给常量或者变量。
3. 同一个if语句可以进行多个可选项绑定，如果其中一个为nil或者Bool类型值为false，if表达式值即为false。

```swift
var name: String? = "Mary"
var age: Int? = 20

if let name = name, let age = age {
    print("\(name) is \(age) years old.")
}

var weather: String? = nil
if let weather = weather {
    print("It is a \(weather) day.")
} else {
    print("Today may be a sunny day.")
}
```

```txt
Mary is 20 years old.
Today may be a sunny day.
```

可选绑定有三种方式：

1. if: 大括号内使用解包之后的值
2. swich
3. guard：解包之后直接使用，不许用大括号包裹；多个需要解包的值时，避免金字塔灾难，推荐使用此方式。

```swift
let str: Optional<String> = "abc" //equals to : let str1: String? = "abc"
if let str1 = str {
    print(str1.count)
}
if str != nil {
    print(str.unsafelyUnwrapped.count)
}

switch str {
case .none:
    print("Empty string!")
case .some(let str2):
    print("str = \(str2)  count = \(str2.count)")
}

enum UnpackError : Error {
  case emptyString(message: String)
}
guard let str3 = str else {
    throw  UnpackError.emptyString(message: "Empty String")
}
print("str = \(str3)  count = \(str3.count)")
```

#### 隐式展开

1. 有些可选项在设定值之后，就会一直拥有，这种情况下就没有必要每次使用的时候都去检查。
2. 使用方法：类型后面用!号而非?号
3. 主要用于Swift类的初始化过程中

```swift
var str: String! = "abc"
print(str.count)
```

#### 可选链

1. 可选项后面加上?号
2. 如果可选项有值返回可选结果，否则返回nil。

```swift
var str: String? = "abc"
print("\(String(describing: str?.count))")
```

注意打印的结果：

```txt
Optional(3)
```

### Optional实现探究

1. Optional并不是语言内置特性而是标准库里面的一个enum类型。
2. Optional是用标准库实现语言特性的典型。
3. 以下是optional的部分源代码：
   1. Optional.none--->nil
   2. Optional.some--->包装了实际值
   3. 可以用Optional枚举类型定义可选项
   4. Optional.unsafelyUnwrapped来获取可选项的值。

```swift
/// A type that represents either a wrapped value or `nil`, the absence of a
/// value.
///
/// You use the `Optional` type whenever you use optional values, even if you
/// never type the word `Optional`. Swift's type system usually shows the
/// wrapped type's name with a trailing question mark (`?`) instead of showing
/// the full type name. For example, if a variable has the type `Int?`, that's
/// just another way of writing `Optional<Int>`. The shortened form is
/// preferred for ease of reading and writing code.
///
/// The types of `shortForm` and `longForm` in the following code sample are
/// the same:
///
///     let shortForm: Int? = Int("42")
///     let longForm: Optional<Int> = Int("42")
///
/// The `Optional` type is an enumeration with two cases. `Optional.none` is
/// equivalent to the `nil` literal. `Optional.some(Wrapped)` stores a wrapped
/// value. For example:
///
///     let number: Int? = Optional.some(42)
///     let noNumber: Int? = Optional.none
///     print(noNumber == nil)
///     // Prints "true"
///
/// You must unwrap the value of an `Optional` instance before you can use it
/// in many contexts. Because Swift provides several ways to safely unwrap
/// optional values, you can choose the one that helps you write clear,
/// concise code.
///
/// The following examples use this dictionary of image names and file paths:
///
///     let imagePaths = ["star": "/glyphs/star.png",
///                       "portrait": "/images/content/portrait.jpg",
///                       "spacer": "/images/shared/spacer.gif"]
///
/// Getting a dictionary's value using a key returns an optional value, so
/// `imagePaths["star"]` has type `Optional<String>` or, written in the
/// preferred manner, `String?`.
///
/// Optional Binding
/// ----------------
///
/// To conditionally bind the wrapped value of an `Optional` instance to a new
/// variable, use one of the optional binding control structures, including
/// `if let`, `guard let`, and `switch`.
///
///     if let starPath = imagePaths["star"] {
///         print("The star image is at '\(starPath)'")
///     } else {
///         print("Couldn't find the star image")
///     }
///     // Prints "The star image is at '/glyphs/star.png'"
///
/// Optional Chaining
/// -----------------
///
/// To safely access the properties and methods of a wrapped instance, use the
/// postfix optional chaining operator (postfix `?`). The following example uses
/// optional chaining to access the `hasSuffix(_:)` method on a `String?`
/// instance.
///
///     if imagePaths["star"]?.hasSuffix(".png") == true {
///         print("The star image is in PNG format")
///     }
///     // Prints "The star image is in PNG format"
///
/// Using the Nil-Coalescing Operator
/// ---------------------------------
///
/// Use the nil-coalescing operator (`??`) to supply a default value in case
/// the `Optional` instance is `nil`. Here a default path is supplied for an
/// image that is missing from `imagePaths`.
///
///     let defaultImagePath = "/images/default.png"
///     let heartPath = imagePaths["heart"] ?? defaultImagePath
///     print(heartPath)
///     // Prints "/images/default.png"
///
/// The `??` operator also works with another `Optional` instance on the
/// right-hand side. As a result, you can chain multiple `??` operators
/// together.
///
///     let shapePath = imagePaths["cir"] ?? imagePaths["squ"] ?? defaultImagePath
///     print(shapePath)
///     // Prints "/images/default.png"
///
/// Unconditional Unwrapping
/// ------------------------
///
/// When you're certain that an instance of `Optional` contains a value, you
/// can unconditionally unwrap the value by using the forced
/// unwrap operator (postfix `!`). For example, the result of the failable `Int`
/// initializer is unconditionally unwrapped in the example below.
///
///     let number = Int("42")!
///     print(number)
///     // Prints "42"
///
/// You can also perform unconditional optional chaining by using the postfix
/// `!` operator.
///
///     let isPNG = imagePaths["star"]!.hasSuffix(".png")
///     print(isPNG)
///     // Prints "true"
///
/// Unconditionally unwrapping a `nil` instance with `!` triggers a runtime
/// error.
public enum Optional<Wrapped> : ExpressibleByNilLiteral {

    /// The absence of a value.
    ///
    /// In code, the absence of a value is typically written using the `nil`
    /// literal rather than the explicit `.none` enumeration case.
    case none

    /// The presence of a value, stored as `Wrapped`.
    case some(Wrapped)

    /// Creates an instance that stores the given value.
    public init(_ some: Wrapped)

    /// Creates an instance initialized with `nil`.
    ///
    /// Do not call this initializer directly. It is used by the compiler when you
    /// initialize an `Optional` instance with a `nil` literal. For example:
    ///
    ///     var i: Index? = nil
    ///
    /// In this example, the assignment to the `i` variable calls this
    /// initializer behind the scenes.
    public init(nilLiteral: ())

    /// The wrapped value of this instance, unwrapped without checking whether
    /// the instance is `nil`.
    ///
    /// The `unsafelyUnwrapped` property provides the same value as the forced
    /// unwrap operator (postfix `!`). However, in optimized builds (`-O`), no
    /// check is performed to ensure that the current instance actually has a
    /// value. Accessing this property in the case of a `nil` value is a serious
    /// programming error and could lead to undefined behavior or a runtime
    /// error.
    ///
    /// In debug builds (`-Onone`), the `unsafelyUnwrapped` property has the same
    /// behavior as using the postfix `!` operator and triggers a runtime error
    /// if the instance is `nil`.
    ///
    /// The `unsafelyUnwrapped` property is recommended over calling the
    /// `unsafeBitCast(_:)` function because the property is more restrictive
    /// and because accessing the property still performs checking in debug
    /// builds.
    ///
    /// - Warning: This property trades safety for performance.  Use
    ///   `unsafelyUnwrapped` only when you are confident that this instance
    ///   will never be equal to `nil` and only after you've tried using the
    ///   postfix `!` operator.
    @inlinable public var unsafelyUnwrapped: Wrapped { get }
}

extension Optional : Equatable where Wrapped : Equatable {

    /// Returns a Boolean value indicating whether two optional instances are
    /// equal.
    ///
    /// Use this equal-to operator (`==`) to compare any two optional instances of
    /// a type that conforms to the `Equatable` protocol. The comparison returns
    /// `true` if both arguments are `nil` or if the two arguments wrap values
    /// that are equal. Conversely, the comparison returns `false` if only one of
    /// the arguments is `nil` or if the two arguments wrap values that are not
    /// equal.
    ///
    ///     let group1 = [1, 2, 3, 4, 5]
    ///     let group2 = [1, 3, 5, 7, 9]
    ///     if group1.first == group2.first {
    ///         print("The two groups start the same.")
    ///     }
    ///     // Prints "The two groups start the same."
    ///
    /// You can also use this operator to compare a non-optional value to an
    /// optional that wraps the same type. The non-optional value is wrapped as an
    /// optional before the comparison is made. In the following example, the
    /// `numberToMatch` constant is wrapped as an optional before comparing to the
    /// optional `numberFromString`:
    ///
    ///     let numberToFind: Int = 23
    ///     let numberFromString: Int? = Int("23")      // Optional(23)
    ///     if numberToFind == numberFromString {
    ///         print("It's a match!")
    ///     }
    ///     // Prints "It's a match!"
    ///
    /// An instance that is expressed as a literal can also be used with this
    /// operator. In the next example, an integer literal is compared with the
    /// optional integer `numberFromString`. The literal `23` is inferred as an
    /// `Int` instance and then wrapped as an optional before the comparison is
    /// performed.
    ///
    ///     if 23 == numberFromString {
    ///         print("It's a match!")
    ///     }
    ///     // Prints "It's a match!"
    ///
    /// - Parameters:
    ///   - lhs: An optional value to compare.
    ///   - rhs: Another optional value to compare.
    @inlinable public static func == (lhs: Wrapped?, rhs: Wrapped?) -> Bool
}

/// Performs a nil-coalescing operation, returning the wrapped value of an
/// `Optional` instance or a default value.
///
/// A nil-coalescing operation unwraps the left-hand side if it has a value, or
/// it returns the right-hand side as a default. The result of this operation
/// will have the non-optional type of the left-hand side's `Wrapped` type.
///
/// This operator uses short-circuit evaluation: `optional` is checked first,
/// and `defaultValue` is evaluated only if `optional` is `nil`. For example:
///
///     func getDefault() -> Int {
///         print("Calculating default...")
///         return 42
///     }
///
///     let goodNumber = Int("100") ?? getDefault()
///     // goodNumber == 100
///
///     let notSoGoodNumber = Int("invalid-input") ?? getDefault()
///     // Prints "Calculating default..."
///     // notSoGoodNumber == 42
///
/// In this example, `goodNumber` is assigned a value of `100` because
/// `Int("100")` succeeded in returning a non-`nil` result. When
/// `notSoGoodNumber` is initialized, `Int("invalid-input")` fails and returns
/// `nil`, and so the `getDefault()` method is called to supply a default
/// value.
///
/// - Parameters:
///   - optional: An optional value.
///   - defaultValue: A value to use as a default. `defaultValue` is the same
///     type as the `Wrapped` type of `optional`.
public func ?? <T>(optional: T?, defaultValue: @autoclosure () throws -> T) rethrows -> T

/// Performs a nil-coalescing operation, returning the wrapped value of an
/// `Optional` instance or a default `Optional` value.
///
/// A nil-coalescing operation unwraps the left-hand side if it has a value, or
/// returns the right-hand side as a default. The result of this operation
/// will be the same type as its arguments.
///
/// This operator uses short-circuit evaluation: `optional` is checked first,
/// and `defaultValue` is evaluated only if `optional` is `nil`. For example:
///
///     let goodNumber = Int("100") ?? Int("42")
///     print(goodNumber)
///     // Prints "Optional(100)"
///
///     let notSoGoodNumber = Int("invalid-input") ?? Int("42")
///     print(notSoGoodNumber)
///     // Prints "Optional(42)"
///
/// In this example, `goodNumber` is assigned a value of `100` because
/// `Int("100")` succeeds in returning a non-`nil` result. When
/// `notSoGoodNumber` is initialized, `Int("invalid-input")` fails and returns
/// `nil`, and so `Int("42")` is called to supply a default value.
///
/// Because the result of this nil-coalescing operation is itself an optional
/// value, you can chain default values by using `??` multiple times. The
/// first optional value that isn't `nil` stops the chain and becomes the
/// result of the whole expression. The next example tries to find the correct
/// text for a greeting in two separate dictionaries before falling back to a
/// static default.
///
///     let greeting = userPrefs[greetingKey] ??
///         defaults[greetingKey] ?? "Greetings!"
///
/// If `userPrefs[greetingKey]` has a value, that value is assigned to
/// `greeting`. If not, any value in `defaults[greetingKey]` will succeed, and
/// if not that, `greeting` will be set to the non-optional default value,
/// `"Greetings!"`.
///
/// - Parameters:
///   - optional: An optional value.
///   - defaultValue: A value to use as a default. `defaultValue` and
///     `optional` have the same type.
public func ?? <T>(optional: T?, defaultValue: @autoclosure () throws -> T?) rethrows -> T?
```