# Key-Path 表达式

## 基本语法

Key-Path表达式用来引用一个类型的属性或者下标，可以在诸如`key-value observing`等动态编程任务中使用。基本的形式为：`\type name`.`path`。类型名是一个**具体类型**的名称，包含任何泛型参数。路径可以由属性、下标、可选连表达式和强制解包表达式组成，以上任意Key-Path组件可以以任何顺序重复多次。编译期，Key-Path表达式会被KeyPth类的实例替代。

```swift
struct SomeStructure {
    let someValue: Int
}
let s = SomeStructure(someValue: 12)
let pathToSomeValue = \SomeStructure.someValue
print(type(of: pathToSomeValue)) // KeyPath<SomeStructure, Int>
let val = s[keyPath: pathToSomeValue] // 12

```

## 缺省`type name`

如果根据上下文利用类型推断可以确定隐式的类型，表达式中的`type name`可以省略掉。

```swift
class SomeClass: NSObject  {
    @objc dynamic var someProperty: Int
    init(someProperty: Int) {
        self.someProperty = someProperty
    }
}

let c = SomeClass(someProperty: 10)
c.observe(\.someProperty) { (object, change) in
    print("changed!")
}
c.someProperty = 24 // changed!
```

## 使用`self`指向实例

```swift
var compoundValue = (a: 1, b: 2)
compoundValue[keyPath: \.self ] = (a:10,b:20)
```

## 嵌套Key-Path

```swift
struct SomeStructure {
    var someValue: Int
}

struct OuterStructure {
    var outer: SomeStructure
    init(someValue: Int) {
        self.outer = SomeStructure(someValue: someValue)
    }
}

let nested = OuterStructure(someValue: 24)
let nestedKeyPath = \OuterStructure.outer.someValue
let nestedValue = nested[keyPath: nestedKeyPath] // 24
```

## 包含下标(Subscripts)的Key-Path

下标可以作为path的一部分，唯一的要求是下标类型遵循`Hashable`协议。

```swift

let greetings = ["hello", "hola", "bonjour", "안녕"]
//                                   类型名称.[index]
let myGreeting = greetings[keyPath: \[String].[1]]
// myGreeting is 'hola'
```

下标访问中使用的值可以是一个变量或者字面量并且Key-Path表达式会使用**值语义**来捕获此值。下面的代码，通过`index`变量分别以key-path表达式和闭包的方式去访问`greetings`数组的第三个元素。当`index`改变时，key-path表达式依然引用数组的第三个元素，而闭包则使用了新的索引值。(这段代码证明了上面关于值语义的论述)

```swift
let greetings = ["hello", "hola", "bonjour", "안녕"]
var index = 2
let path = \[String].[index]
let fn: ([String]) -> String = {strings in strings[index]}
print(greetings[keyPath: path]) // bonjour
print(fn(greetings))//bonjour
index += 1
print(greetings[keyPath: path]) // bonjour
print(fn(greetings))//안녕
```

## 包含可选链和强制解包的Key-Path

```swift
let greetings = ["hello", "hola", "bonjour", "안녕"]
print(greetings.first?.count as Any) // Optional(5)
let count = greetings[keyPath: \[String].first?.count]
print(count as Any) // Optional(5)
```

## 混合使用Key-Path组件

```swift
let interestingNumbers = ["prime": [2, 3, 5, 7, 11, 13, 17],
                          "triangular": [1, 3, 6, 10, 15, 21, 28],
                          "hexagonal": [1, 6, 15, 28, 45, 66, 91]]
print(interestingNumbers[keyPath: \[String: [Int]].["prime"]] as Any) // Optional([2, 3, 5, 7, 11, 13, 17])
print(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]])// 2
print(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count])// 7
print(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth])// 64
```

## 可代替函数或者闭包的key-path表达式

在需要提供函数或者闭包的上下文中，可以使用key-path表达式代替他们。特别的，你可以用根本类型是`someType`并且表达式返回一个类型为`value`的值的key-path表达式代替类型为`(someType) -> Value0`函数或者闭包。

```swift
struct Task {
    var description: String
    var completed: Bool
}
var toDoList = [Task(description: "Practice ping-pong.", completed: false),Task(description: "Buy a private costume.", completed: true), Task(description: "Visit Bouton in the Fall.", completed: false)]

let descriptionsByKeyPathExpression = toDoList.filter(\.completed).map(\.description)
let descriptionsByClousure = toDoList.filter {$0.completed}.map { $0.description}
```

## key-path表达式的副作用

Key-Path表达式的唯一副作用在于**表达式只在定义时计算一次**。比如，你在key-path表达式的下标组件中调用了一个函数，那么这个函数**仅在计算这个表达式的时候被调用唯一一次**，而不是每次使用key-path的时候都会调用。

```swift
struct Task {
    var description: String
    var completed: Bool
}
var toDoList = [Task(description: "Practice ping-pong.", completed: false),Task(description: "Buy a private costume.", completed: true), Task(description: "Visit Bouton in the Fall.", completed: false)]

func makeIndex() -> Int {
    print("Made an iindex")
    return 0
}

let taskKeyPath = \[Task].[makeIndex()] // Made an index
let someTask = toDoList[keyPath: taskKeyPath]// No outpput
```
