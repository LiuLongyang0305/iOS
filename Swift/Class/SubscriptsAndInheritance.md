# Subscripts and Inheritance

## Subscripts(下标)

类、结构体和枚举类型都可以定义下标作为访问诸如集合、列表、序列元素的快捷方式。在没有单独的设定和读取元素数值的方法的情况下，可以利用下标实现元素的设定和读取。例如，Array实例访问元素的方式someArray[index]和字典实例的访问元素方式someDictionary[key]。

对于一个类型，开发者可以定义多种下标形式，类似于函数的重载，具体抵用哪种方式由传入的参数决定。

### 下标语法(Subscripts Syntax)

Subscripts enables you to query instances of a type by writing one or  more values in squre brackets after the instance name.

```swift
struct SomeStruct {
    //read-write
    subscript(index : Int) -> Int {
        get {
            return index * index
        }
        set {
            //perform a suitable setting action here
        }
    }
    //read-only
    subscript( key : String) -> Int {
        return 0
    }
}

struct TimeTable {
    let multiplier : Int
    subscript(index : Int) -> Int {
        return multiplier * index
    }
}

let threeTimesTable = TimeTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")
```

### Subscripts Usage(下标用法)

下标额最具代表性用法是作为访问集合、列表、序列的元素的快捷方式。对于自定义的类或者结构体，开发者可以左右的发挥趋势线下标的用法。

```swift
var numberOfLegs = ["spider" : 8,"ant" : 6, "cat" : 4]
numberOfLegs["birds"] = 2
```

### Subcripts Options

下标允许任意类型的数据作为参数，也允许返回任意类型的数据，甚至可以使用可变参数，但是不能使用in-out类型的参数或者默认参数（提供默认值）。开发者可以提供、多种下标的实现，具体使用哪个实现由下标使用时方括号内传入的参数确定。这个机制称作下标重载(Subscripts Overloading)。

```swift
struct Martrix {
    let rows : Int
    let cloumns: Int
    var grid : [Double]
    init(rows: Int, cloumns : Int) {
        self.rows = rows
        self.cloumns = cloumns
        grid = Array(repeating: 0.0, count: rows * cloumns)
    }

    func indexIsValid(row : Int, cloumn : Int) -> Bool {
        return row >= 0 && row < rows && cloumn >= 0 && cloumn < cloumns
    }

    subscript(row : Int,cloumn: Int) -> Double {
        get {
            assert(indexIsValid(row: row, cloumn: cloumn)," Index out of range")
            return grid[(row * cloumns) + cloumn]
        }
        set {
            assert(indexIsValid(row: row, cloumn: cloumn)," Index out of range")
            grid[(row * cloumns) + cloumn] = newValue
        }
    }
}

func testScripts(){
    var martrix = Martrix(rows: 2, cloumns: 2)
    print(martrix)
    martrix[0,1] = 1.5
    martrix[1,1] = 3.2
    print(martrix)
}
testScripts()
```

运行结果：

```txt
Martrix(rows: 2, cloumns: 2, grid: [0.0, 0.0, 0.0, 0.0])
Martrix(rows: 2, cloumns: 2, grid: [0.0, 1.5, 0.0, 3.2])
```

## Inheritance(继承)

subclass && superClass

swift中，子类可以调用或者访问父类的方法、属性和下标，或者提供自己的实现（称作override）重新定义或者改变父类默认的行为。子类可以给父类的任意属性（包括存储属性和计算属性）添加属性观察者来监控父类属性值的变化。

### Define a Base Class and Subclassing

Any Class that does not inherit from another class is known as base class. Sunclassing is the act of basing a new class on an existing class. The subclass inherits characteristic from the existing class, which you can then refine or modify. You can also add new characteristic to the sub class.

```swift
class Vehicle {
    var currentSpeed = 0.0
    var description : String {
        return "Traveling in \(currentSpeed ) miles per hour"
    }
    func makeNoise()  {
        print("vehicle is making noise!")
    }
}
class Bicycle : Vehicle {
    var hasBasket = false
}
```

### 重写(Override）

对于父类的方法和属性以及下标，子类可以提供适合自己的个性化个性化的实现，称作重写。语法：用关键词override修饰方法或者属性的名字。

### 访问父类的属性，调用父类的方法，使用父类的下标

1. 重写的方法someMethod()在自己的实现中可以通过super.someMethod()调用父类的someMethod()方法。
2. 重写的属性someProperty在自己的getter和setter实现中可以通过super.someProperty访问父类的someProperty属性。
3. 重写的下标someIndex可以在自己的实现中通过super[someIndex]使用父类的下标。

### 重写方法

```swift
class Vehicle {
    var currentSpeed = 0.0
    var description : String {
        return "Traveling in \(currentSpeed ) miles per hour"
    }
    func makeNoise()  {
        print("vehicle is making noise!")
    }
}
class Bicycle : Vehicle {
    var hasBasket = false
    override func makeNoise() {
        print("bicycle is making noise!")
    }

}
```

### 重写属性

#### 重写属性的getter和setter

需要注意：

1. 继承的read-only属性可以重写为read-write属性，具体做法：重写时提供getter和setter函数；但是read-write属性不能被重写为read-only属性。
2. 重写的时候，可以只提供getter函数，也可以setter和getter函数一起提供；不能只提供setter函数。

```swift
class Vehicle {
    var currentSpeed = 0.0 {
    }
    var description : String {
        return "Traveling in \(currentSpeed ) miles per hour"
    }
    func makeNoise()  {
        print("vehicle is making noise!")
    }
}

class Car : Vehicle {
    var gear = 1
    var newDescription : String = ""
    override var description: String {
        get {
            return super.description + " in gear \(gear)"
        }
        set {
            newDescription = newValue
        }
    }
}
let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("car : \(car.description)")
```

运行结果：

```txt
car : Traveling in 25.0 miles per hour in gear 3.
```

#### 重写属性观察者

开发者可以对继承来的属性添加属性观察者，这个机制使得开发者能在这些属性值的变化的时候及时获得通知。

```swift
class Vehicle {
    var currentSpeed = 10.0
    var description : String {
        return "Traveling in \(currentSpeed ) miles per hour"
    }
    func makeNoise()  {
        print("vehicle is making noise!")
    }
}
class Car : Vehicle {
    var gear = 1
    var newDescription : String = ""
    override var description: String {
            return super.description + " in gear \(gear)"
    }
}

class AutomaticCar : Car {
    override var currentSpeed: Double {
        willSet {
            print("Before speed changes, in gear = \(Int(self.currentSpeed / 5.0) + 1).")
        }
        didSet {
            gear = Int(self.currentSpeed / 5.0) + 1
            print("After speed changes, in gear \(gear).")
        }
    }
}

let automaticCar = AutomaticCar()
automaticCar.currentSpeed = 35.0
```

运行结果：

```txt
Before speed changes, in gear = 3.
After speed changes, in gear 8.
```

注意：

1. 不能给继承的常量存储属性和只读（read-only）的计算属性添加观察者，因为这些属性的值压根不会发生改变。
2. 同一个属性不能同时重载setter和观察者，因为在setter函数里面也可以及时监测到属性值的变化。

### 防止重写(Preventing Overrides)

用final标记的属性、方法和下标，可以禁止他们被子类重写，例如 final var,final let, final func,final class func 和 final subscripts. 如果尝试重写，会触发compile-time error。扩展中定义的方法、属性和下标也可以用final修饰。如果开发者用final修饰整个类形如final class，那么这个类就不能被继承,如果尝试继承会导致触发compile-time error。