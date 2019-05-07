# 多态(Polymorphism)

Swift的引用变量有连个类型：编译时类型和运行时类型。编译时类型由声明该变量时使用的类型决定，编译器只认每个变量的编译时类型；运行时类型由实际赋给该变量的值确定。如果编译时类型和运行时类型不一致，就出现所谓的多态。

## 多态性

```swift
class BaseClass {
    func base()  {
        print("This function belongs to BaseClass!")
    }
    func test() {
        print("This function belongs to BaseClass and to be overriden!")
    }
}

class SubClass: BaseClass {
    override func test() {
        print("This function belongs to subClass and override super's function!")
    }
    func sub()  {
        print("This function belongs to SubClass!")
    }
}

let bc = BaseClass()
bc.base()
bc.test()
let sc = SubClass()
sc.sub()
sc.base()
sc.test()

let polymorphismBc : BaseClass = SubClass()
polymorphismBc.base()
polymorphismBc.test()
```

运行结果：

```text
This function belongs to BaseClass!
This function belongs to BaseClass and to be overriden!
This function belongs to SubClass!
This function belongs to BaseClass!
This function belongs to subClass and override super's function!
This function belongs to BaseClass!
This function belongs to subClass and override super's function!
```

## 检查类型(Checking Type)

使用类型检查运算符(Type Check Operator)is来检查类型。其前一个操作数通常是一个引用型变量，后一个操作数通常是一个类或者协议，用以判断前面的引用变量是否是后面的类或者其子类或者实现类的实例，是返回true，否则返回false。

```swift
class MediumItem {
    var name : String
    init(name : String) {
        self.name = name
    }
}

class Movie : MediumItem {
    var director : String
    init(name : String, director : String) {
        self.director = director
        super.init(name: name)
    }
}

class Song : MediumItem {
    var artist : String
    init(name : String, artist : String) {
        self.artist = artist
        super.init(name: name)
    }
}
let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]

var movieCount = 0
var songCount = 0

for medium in library {
    if medium is Movie {
        movieCount += 1
    } else if medium is Song {
        songCount += 1
    }
}
```

## Downcasting

swift程序中，引用变量只能调用其编译时的类型的方法，而不能调用运行时类型的方法。如果想要调用就必须强制转换为其实际类型。这种强制转换也叫做向下转换。

类型转换运算符：

1. as编译时确定能转型成功才能用这个运算符。
2. as? 可选项下转型。返回一个可选值，转换成功返回的可选值包含转换结果，转换失败包含nil。
3. as! 可选项下转型。返回一个隐式解析可选值，转换成功返回转换结果，转换失败返回nil。

向下转换只能在具有继承关系的两个类型之间进行。如果把父类引用变量转换成子类类型，则该变量实际引用的实例必须是子类的实例，否则会转换失败。考虑到强制类型转换可能出现异常，因此在类型转换前可以进行必要的类型检查。

注意：

1. 子类实例赋值给父类引用变量成为向上转型(Upcasting),总是可以成功，这种转换方式表明引用变量编译时是父类类型，运行时是子类类型，在实际调用方法的过程中依然表现出子类的行为，即多态。
2. 父类引用变量赋值给子类引用变量，需要向下转换，并且可能失败。

```swift
for item in library {
    if let movie = item as? Movie {
        print("Movie : \(movie.name) , director : \(movie.director)")
    } else if let song = item as? Song {
        print("Song : \(song.name) , artist : \(song.artist)")
    }
}
```

运行结果：

```text
Movie : Casablanca , director : Michael Curtiz
Song : Blue Suede Shoes , artist : Elvis Presley
Movie : Citizen Kane , director : Orson Welles
Song : The One And Only , artist : Chesney Hawkes
Song : Never Gonna Give You Up , artist : Rick Astley
```

## Type Casting for Any and AnyObject

swif为不确定类型提供了两种特殊的类型别名。

1. Any---->代表任意类型的实例，包括值类型、l类以及函数
2. AnyObject---->代表任何类的实例

```swift
class MediumItem {
    var name : String
    init(name : String) {
        self.name = name
    }
}

class Movie : MediumItem {
    var director : String
    init(name : String, director : String) {
        self.director = director
        super.init(name: name)
    }
}
var things = [Any]()
things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0,5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({(name: String) -> String in "Hello, \(name)"})
things.append(-0.9)
for thing in things {
    switch thing {
    case 0 as Int:
        print("Zero as an Int")
    case 0 as Double:
        print("Zero as a Double")
    case let someInt as Int:
        print("An integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("An positive double value of \(someDouble)")
    case is Double:
        print("Some other double value that I don't want to print.")
    case let someString as String:
        print("A string value of \(someString)")
    case let (x,y) as (Double,Double):
        print("An (x,y) point at (\(x),\(y))")
    case let movie as Movie:
        print("A movie called \(movie.name), dir. \(movie.director)")
    case let stringConverter as (String) -> String:
        print(stringConverter("Tom"))
    default:
        print("Something else!")
    }
}

```

运行结果：

```text
Zero as an Int
Zero as a Double
An integer value of 42
An positive double value of 3.14159
A string value of hello
An (x,y) point at (3.0,5.0)
A movie called Ghostbusters, dir. Ivan Reitman
Hello, Tom
Some other double value that I don't want to print.
```