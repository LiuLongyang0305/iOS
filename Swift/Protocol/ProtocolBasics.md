# 协议(Protocol)

swift中协议用于定义多个类型应该遵守的规范。协议定义规范，类是协议的一种具体实现，协议不关心类内部的状态数据和实现细节，它只规定这批类里面必须提供某些方法，提供这些方法的类就能满足某种需要。协议定义了多个类型的共同的公共行为规范，这些欣慰是与外部交流的通道，协议同意了方法名、属性名和下标，但是协议不提供任何实现。实现协议的枚举、结构体、类成为协议的遵守者，协议实现者必须提供协议要求的属性、方法、构造器、下标等。

## 协议本身

### 语法

```swift
protocol SomeProtocol: SuperProtocol1, SuperProtocol2, ... {
    //protocol defination goes here
    //property,method,initializer,subscripts
}

struct SomeStructure: SomeProtocol {
    //structure defination goes here
}
class SomeClass: SomeProtocol {
    //class defination goes here
}

enum SomeEnumeration: SomeProtocol {
    //enumeration defination goes here
}
```

### 协议指定的属性要求(Property Requirements)

协议可以要求实现者必须提供包含**特定名称**的实例属性或者类型属性，也能要求该属性是否有get部分和set部分，但是**不关心该属性是存储属性还是实例属性**。

如果协议要求属性是可读可写的，那么遵循协议的类型 中的相同名称的属性必须是var修饰的，如果协议要求属性是可读的，那么遵循协议的类型中的属性用var或者let修饰都是可以的。

```swift
protocol PropertyRequirementExample {
    //一般属性
    var mustBeSettable : Int { get set }
    var doesNotNeedToBeSettable : Int { get }
    //类型属性
    static var someTypeProperty : Int { get set}
}
```

以下是一个具体例子：

```swift
protocol FullyNamed {
    var fullName : String {get}
}

struct Person : FullyNamed {
    //computed property ---> stored property
    var fullName: String
    init(_ name : String) {
        fullName = name
    }
}
class Starship: FullyNamed {
    var prefix : String?
    var name : String
    init(_ name : String, _ prefix : String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String{
        return (nil == prefix ? "" : prefix! + " ") + name
    }
}
```

### 协议指定方法要求(Method Requirements)

协议要求实现的方法可以是**实例方法，类方法，以及mutating修饰的方法**，但不能是**默认参数的方法**。

```swift
protocol RandomNumberGenerator {
    func random() -> Double
}
class LinearCongruentiaGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c)).truncatingRemainder(dividingBy: m)
        return lastRandom / m
    }
}
let generator = LinearCongruentiaGenerator()
print("Random number is : \(generator.random())")
print("Other random number is : \(generator.random())")
```

### 协议指定的可变方法的要求(Mutating Method Requirements)

枚举和结构体需要定义能**改变实例数据**的方法，则需要将该方法声明为**可变方法(Mutating修饰)**。协议中也可以定义可变方法，然后在枚举和结构体实现时需要声明为可变方法(Mutating修饰)，类中实现则不需要Mutating修饰。

```swift
protocol Togglable {
    mutating func toggle()
}
enum Switch : Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .on:
            self = .off
        case .off:
            self = .on
        }
    }
}
```

### 协议指定的下标的要求

协议可以要求实现者必须提供哪些下标，也能要求该下标是否有set和get部分，其中set部分可选。

注意：如果协议指定下标是只读的，只有get部分，实现的时候也可以提供表的set部分。即协议只要求必须实现的，至于额外提供什么，协议不做过多限制。

```swift
protocol Mathable {
    //要求get方法
    subscript(idx: Int) -> Int { get }
    subscript(a: Int, b: Int) -> Int { get }
}

struct LinearStruct: Mathable {
    var factor: Int
    //提供了get和set方法
    subscript(idx: Int) -> Int {
        get {
            return factor * idx
        }
        set {
            print("Set value to LinearStruct by subsript!")
        }
    }

    //只提供了get方法
    subscript(a: Int, b: Int) -> Int {
        return factor * a + b
    }
}

class Quadratic: Mathable {
    subscript(idx: Int) -> Int {
        return factor * factor * idx
    }

    subscript(a: Int, b: Int) -> Int {
        return factor * factor * a + b
    }

    var factor: Int
    init(factor: Int) {
        self.factor = factor
    }
}

var linear = LinearStruct(factor: 2)
print("\(linear[5]),   \(linear[3,7])")
var quadratic = Quadratic(factor: 2)
print("\(quadratic[4]),    \(quadratic[4,5])")
```

### 协议指定的构造器要求(Initailizer Requirements)

协议可以要求实现者必须实现那些构造器。枚举和结构体实现协议中的构造器比较简单，不需要特别的注意。**当使用类来实现协议中的构造器时，可以使用指定构造器也可以使用便利构造器实现，协议不做明显的限制**。但是需要注意：

1. 类实现协议并且实现协议中那个的构造器时，必须用**required**修饰，除非该类被final修饰，不能被继承。
2. 类实现协议并且实现协议中那个的构造器时，如果该构造器还同时重写了父类的构造器，则必须用**rquired和override**修饰。

```swift
protocol TempProtocol {
    init()
}

class SuperClass {
    init() {
    }
}

class SomeSubClass : SuperClass,TempProtocol {
    required override init() {
    }
}
```

### 使用协议作为类型(Protocol as Types)

协议也相当于一种类型，与枚举、结构体和类相比，**协议相当于一种抽象类型**，因为它只定义了规范而没有负责实现。可以像使用枚举、结构体和类一样使用协议，只是**不能用来创建实例**。

1. 可以声明变量
2. 可以使用协议作为方法、函数、构造器的形参和返回值
3. 可以用作泛型参数---指定数组字典元素类型
4. 可以使用is、as、as?、as!操作符。

```swift
protocol RandomNumberGenerator {
    func random() -> Double
}

class Dice {
    let sides : Int
    let generator : RandomNumberGenerator
    init(sides: Int, generator:RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}
```

### 协议继承

协议可以继承一个或者多个其他协议，语法与类继承语法类似。

```swift
 protocol SomeProtocol {}
 protocol AnotherProtocol {}
 protocol SubProtocol: SomeProtocol,  AnotherProtocol {}
```

### 类专用协议

如果协议继承列表添加AnyObject，那么这个协议只能被类所继承。如果 值类型强制执行会报错：

```txt
Non-class type 'SomeStruct' cannot conform to class protocol 'SomeProtocol'
```

```swift
 protocol SomeProtocol: AnyObject{}
 class  SomeClass: SomeProtocol {}
```

### 协议组合

协议组合用于复合多个协议到一个要求里，协议组合类似于局部临时协议，其拥有构成中的所有协议的要求，但是不定义任何新的协议要求。**协议组合也能包含类类型，允许表明一个需要的父类**。

```swift
 protocol  Named {
    var name: String {get}
 }
 protocol Aged {
    var age: Int {get}
 }

 struct Person: Named,Aged {
    var name: String
    var age: Int
 }

 struct Pet: Named,Aged {
    var name: String
    var age: Int
 }
 func wishHappyBirthday(to celebrator: Aged & Named)  {
    print("Happy  birthday, \(celebrator.name), you are \(celebrator.age).")
 }
let robin = Person(name: "Robin", age: 20)
wishHappyBirthday(to: robin)
```

## 协议和扩展

### 扩展现有类型使其遵循协议

可以**通过扩展是一个已存在类型遵循使其遵循新的协议**，即便你没有办法访问类型的源代码。这个功能依赖于：**扩展可以给已存在类型添加新的属性、下标和方法**，这满足协议的任何需求。

```swift
 protocol TextRepresentable  {
    var  textDescription: String  {get}
 }

 extension Int: TextRepresentable {
    var textDescription: String {
        return "\(self)"
    }
 }
```

### 有条件遵循协议

```swift
 protocol TextRepresentable  {
    var  textDescription: String  {get}
 }

 extension Int: TextRepresentable {
    var textDescription: String {
        return "\(self)"
    }
 }

 extension Array: TextRepresentable where Element: TextRepresentable {
    var textDescription: String {
        let itemsAsText = self.map{$0.textDescription}
        return "[" + itemsAsText.joined(separator: " ") + "]"
    }
 }
 let arr = [1,2,3,4,5]
 print(arr.textDescription)
```

### 使用扩展声明采纳协议

如果已存在类型已经遵循了协议的所有需求，而这个类型没有声明采纳协议，可以通过**空的扩展**让他采纳这个协议。

```swift
 protocol  Named {
    var name: String {get}
 }
 protocol Aged {
    var age: Int {get}
 }

 struct Person {
    var name: String
    var age: Int
 }

 extension Person: Named & Aged  {}
```

### 协议的扩展

1.可以通过扩展给协议添加默认实现。

```swift
 protocol  Named {
    var name: String {get}
 }

 extension Named {
    var name: String {
        return  "Tom"
    }
 }

 struct PersonWithDefaultName: Named  {}
 struct PersonWithSpecificName: Named {
    var first: String
    var last: String
    var name: String {
        return  "\(first) \(last)"
    }
 }
```

2.通过扩展给协议增加需要提供的方法和属性,并提供默认实现。

```swift
 protocol RandomNumberGenerator {
     func random() -> Double
 }
 extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random()  > 0.5
    }
 }
```
