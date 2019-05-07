# 枚举(Enumeration)

swift的枚举用于管理一组相关的有限的值的集合。

C语言中枚举值是一系列的整数(Integer Values),swift更灵活，枚举的每个case不强制要求有原始值，如果有则可以是字符串、字符、整型、浮点型。

swift的枚举支持关联数值(Associated Values)，关联值可以使任意类型。

swift的枚举也具备许多面向对象的属性：支持计算属性，支持实例方法和类型方法，支持构造器进行初始化，支持通过扩展来增强枚举功能，支持遵守协议来提供标准功能。

通过switch语句匹配枚举值。

## 枚举语法以及原始值

```swift
enum CompassPoint {
    case north
    case south
    case east
    case west
}

```

## Matching Enumeration Values with a Switch Statement

```swift
enum CompassPoint {
    case north
    case south
    case east
    case west
}
let directionToHead = CompassPoint.north
switch directionToHead {
case .north:
    print("Lots of planets have a north pole")
case .south:
    print("Watch out for penguins")
case .east:
    print("where the sun rises")
case .west:
    print("Where the skies are blue")
}
```

## Iterating over Enumeration Cases

```swift
enum Beverage: CaseIterable {
    case coffee, tea,juice
}

for beverage in Beverage.allCases {
    print(beverage)
}
```

运行结果：

```text
coffee
tea
juice
```

## 关联值(Associated Values)

swift除了定义一组枚举成员外，还可以专门为枚举成员定义一组关联值(Associated Values)---关联值可以是任何类型，并且每个枚举成员的关联值类型也不做限制，没有必要与其他枚举成员关联值类型相同。

关联值也即是枚举类型携带的一些额外的数据，关联值有点类似于枚举类型的属性。通过关联值，可以每个枚举值定义更多数据，从而更好反映实例的状态。

```swift
enum Barcode {
    case upc(Int,Int,Int,Int)
    case qrCode(String)
    func show() {
        switch self {
        case  let .upc(numberSystem, manufacturer, product, check):
            print("UPC: \(numberSystem), \(manufacturer), \(product), \(check)")
        case let .qrCode(productCode):
            print("QrCode : \(productCode)")
        }
    }
}
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode.show()
productBarcode = Barcode.qrCode("ABCDEFGHTYUI")
productBarcode.show()
```

运行结果：

```text
UPC: 8, 85909, 51226, 3
QrCode : ABCDEFGHTYUI
```

注意：

1. 定义不提供任何真是的Int或者string数据----仅仅是定义了Barcode类型的常量或者变量可以储存的数据类型。
2. Barcode类型的常量或者变量只能保存.upc或者.qrCode和他们各自的关联值，任何时候只能保存二者之一。所以有点像c语言的共同体。

## 原始值(Raw Values)

类似于c语言的枚举，通过原始值可以为每一个枚举实例制定一个简单类型（Int,Double,Float,String,Character）。每个原始值在枚举声明中必须独一无二。

```swift
enum CompassPoint: Int {
    case north = 1
    case south = 2
    case east = 3
    case west = 4
}

enum CompassPoint2: String {
    case north = "north"
    case south = "south"
    case east = "east"
    case west = "west"
}
```

### Implicitly Assigned Raw Values

当原始值类型是Int或者String时，开发者没有必要为每个枚举成员显式的赋值，swift会自动的设定初始值。整型类似于C语言，从0开始，每个枚举成员加1；String的话默认值是枚举成员变量的名字。

```swift
enum CompassPoint: Int {
    case north
    case south
    case east
    case west
}

enum CompassPoint1: String {
    case north
    case south
    case east
    case west
}

print(CompassPoint.north.rawValue)
print(CompassPoint.south.rawValue)
print(CompassPoint1.north.rawValue)
print(CompassPoint1.south.rawValue)
```

运行结果：

```text
0
1
north
south
```

### Initializing from  a Raw Value

如果枚举定义有原始值，那么枚举类型会默认提供一个以原始值类型的数值作为参数的构造函数，构造成功返回一个枚举成员，不成功返回nil。

```swift
enum CompassPoint: String {
    case north
    case south
    case east
    case west
}

if let direction = CompassPoint(rawValue: "SomeText") {
    print("The raw value of direction is \(direction.rawValue)")
} else {
    print("Fail to initialize CompassPoint!")
}
if let direction = CompassPoint(rawValue: "east") {
    print("The raw value of direction is \(direction.rawValue)")
}
```

运行结果：

```text
Fail to initialize CompassPoint!
The raw value of direction is east.
```

## Recursive Enumeration

递归枚举：枚举的一个或者多个成员的关联值是自身的实例。需要用关键字indirect修饰。

```swift
indirect enum ArithemticExpression {
    case number(Int)
    case addtion(ArithemticExpression,ArithemticExpression)
    case multiplication(ArithemticExpression,ArithemticExpression)
}

let five = ArithemticExpression.number(5)
let four = ArithemticExpression.number(4)
let sum = ArithemticExpression.addtion(five, four)//5 + 4 = 9
let product = ArithemticExpression.multiplication(sum, ArithemticExpression.number(2))//9 * 2 = 18

func evaluate(_ expression : ArithemticExpression) -> Int{
    switch expression {
    case let .number(value):
        return value
    case let .addtion(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}
```

## Enumeration With Computed Property

```swift
enum Shape {
    case squre(length: Double)
    case rectangle(length: Double, width: Double)
    case cycle(radius: Double)
    case trangle(Double,Double,Double)
    var area: Double {
        get {
            switch self {
            case let .squre(length):
                return length * length
            case let .rectangle(length, width):
                return length * width
            case let .cycle(radius):
                return .pi * radius * radius
            case let .trangle(l1, l2, l3):
                let half = (l1 + l2 + l3) * 0.5
                return sqrt(half * (half - l3) * (half - l2) * (half - l1))
            }
        }
    }
}
```