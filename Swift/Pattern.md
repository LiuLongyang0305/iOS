# swift之模式

## 模式简介

* 模式代表单个值或者复合值的**结构**。比如 `(10,20)`和`("Tom","Mary")`在结构上并无本质差别，都是包含两个值的元组。
* swift中的模式分为两类，一类**能成功匹配任何类型的值**，另一类**在运行时匹配某个特定值时可能会失败**。
  * 第一类用于解构简单变量、常量和可选绑定中的值。包括**通配符模式** 和**标识符模式**以及包含这两种模式的**值绑定模式**和**元组模式**。可以为这类模式制定一个类型标注，从而限定他们只匹配某种特定类型的值。
  * 第二类用于全模式匹配。，这种情况下你视图匹配的值在运行时可能不存在。包括**枚举用例模式**、**可选模式**、**表达式模式**和**类型转换模式**。

## 具体实例

* 通配符模式（Wildcard Pattern):不关注匹配的值

```swift
 for _ in 1...3 {
    // Do something three times
 }
```

* 标识符模式(Identifier Pattern):匹配任何值并且把匹配到的值绑定给变量或者常量。
* 值绑定模式(Value-Binding pattern):把匹配到的值绑定给一个变量或者常量，绑定给常量时用`let`,绑定给变量时用`var`。
  
```swift
 let point = (1,2)
 switch point {
 case let (x,y):
    print("The point is at (\(x), \(y))") //The point is at (1, 2)
 }
```

* 元组模式
  * 逗号分隔的具有一个或者多个模式的列表
  * 可以使用类型标注去限定一个元组模式可以匹配那些元组类型。
  * 元组模式被用于`for-in`语句或者变量火证常量声明时，金可以包含通配符模式、标识符模式、可选模式或者其他包含这些模式的元组模式。
  
```swift
 let points = [(0,0),(1,0),(2,0),(0,3),(1,1),(2,1)]
 for (x,y) in points where y == 0 || x == 0 {
    print("Point(\(x), \(y)) is on axis!")
 }

 for point in points {
    switch point {
    case (_,0), (0,_):
        print("Point(\(point.0), \(point.1)) is on axis!")
    default:
        break
    }
 }
```

* 枚举用例模式(Enumeration Case Pattern)
  
```swift
 enum SomuEnum {
    case left,right
 }
 let direction: SomuEnum? = .left
 switch direction {
 case .left:
    print("Turn left!")
 case .right:
    print("Turn right!")
 case nil:
    print("Keep going straiht!")
 }


var someOptional: Optional<Int> = 43
 //枚举用例模式匹配
 switch someOptional {
 case .some(let x):
    print(x) // 43
 case .none:
    print("nil")
 }
 if case .some(let x) = someOptional {
    print(x) // 43
 }
```

* 可选项模式(Optional Pattern)
  * 可选项模式匹配`Optional<Wrapped>`枚举在`some(Wrapped)`中包装的值。

```swift
 var someOptional: Optional<Int> = 43
 if  case let x? = someOptional {
    print(x) // 43
 }

 let arrayOfOptionalInts: [Int?] = [nil,2,3,5,nil]
 for case let number? in arrayOfOptionalInts {
    print("Found a \(number) !")
 }
```

* 类型转换模式(Type-Casting Pattern)
  * `is`模式：只出现在`switch`语句的`case`标签中，当一个值的类型在运行时与模式右边指定类型一致或者是其子类的情况下才会匹配。
  * `as`模式:当一个值的类型在运行时和右边指定类型一致或者是其子类的情况下，才会匹配。如果匹配成功，被匹配值的类型被撞换成`as`模式右边指定的类型。

```swift
 class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
 }

 class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
 }
 
 class Song: MediaItem {
    var artist: String
    init( name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
 }

 let library: [MediaItem] = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
 ]

 for mediaItem in library {
    switch mediaItem {
    case is Song :
        print("Song: \(mediaItem.name)")
    case let movie as Movie:
        print("Movie: \(movie.name)  director: \(movie.director)")
    default:
        break
    }
 }
```

* 表达式模式(Expression Pattern)
  * 只出现在`switch`的`case`标签中。
  * 表达式模式代表的表达式会使用Swift的标准库中的`~=`运算符与输入表达式的值进行比较，如果`~=`预算内算符返回`true`,则匹配成功。因此自定义类型要使用表达式模式匹配，需要**重载`~=`运算符**。

```swift
let point = (0,0)
 func ~= (pattern: String, value: Int) -> Bool {
    return  pattern == "\(value)"
 }
 switch point {
 case ("0","0"):
    print("(0,0) is at the origin.")
 default:
    print("The point is at (\(point.0), \(point.1))")
 }

```