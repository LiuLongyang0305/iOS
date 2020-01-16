# 流程控制(Control Flow)

## 循环控制

* for-in循环
  * 循环遍历一个序列(sequence):一个范围的数字，数组，字符串，集合，字典等等。
  
  ```swift

    for i in 0...3 {
        print(i)
    }
    for name in ["Tom","Ben","Mary"] {
        print(name)
    }

    for ch in "Hello, word!" {
        print(ch)
    }

    for (animal,numberOfLegs) in ["Spider": 8, "Ant": 6, "Cat": 4] {
        print("\(animal) has \(numberOfLegs) legs!")
    }

    for dic in ["Spider": 8, "Ant": 6, "Cat": 4] {
        print("\(dic.key) has \(dic.value) legs!")
    }

  ```

  * for-in 分段区间
  
  ```swift
  
    for tickMark in stride(from: 0, to: 10, by: 2) {
        print(tickMark)
    }
    for tickMark in stride(from: 0, through: 10, by: 2) {
        print(tickMark)
    }

  ```

* while
* repeat-while

## switch

* `switch`会将一个值与多个可能的模式匹配，然后基于一个成功匹配的模式指向合适的代码。
* `switch`语句一定是全面的，即每一个值都必须有对应的`case`相匹配，也可以定义一个默认匹配所有情况的`case`来匹配未明确出来的值，用`default`标记，必须放在所有`case`的最后。
* 不会默认贯穿，会在匹配到第一个`case`执行完毕之后退出；但是如果希望贯穿，可以使用`fallthrough`关键字。一个`case`需要匹配多个值的时候，用逗号隔开。
* `switch`用于区间匹配
  
  ```swift
    let approximateCount = 62
    let countedThings = "moons orbiting Saturn"
    let naturalCount: String
    switch approximateCount {
    case 0:
        naturalCount = "no"
    case 1..<5:
        naturalCount = "a few"
    case 5..<12:
        naturalCount = "several"
    case 12..<100:
        naturalCount = "dozens of"
    case 100..<1000:
        naturalCount = "hundreds of"
    default:
        naturalCount = "many"
    }
    print("There are \(naturalCount) \(countedThings).")
  ```

* 元组匹配: (_)可以匹配所有可能值
  
  ```swift
    let point = (1,1)
    switch point {
    case (0,0):
        print("\(point) is at the origin")
    case (_,0):
        print("\(point) is on the x-axis")
    case (0,_):
        print("\(point) is on the y-axis")
    case (-2...2,-2...2):
        print("\(point) is inside the box")
    default:
        print("\(point) is outside of the box")
    }
  ```

* 值绑定：`switch`的`case`可以将匹配到的值临时绑定为一个常量或者变量，来给`case`函数体调用。这个变量或者常量的作用域也仅为`case`的函数体。
  
  ```swift
    let point = (2,0)
    switch point {
    case (let x,0):
        print("on the x-axis with a x value of \(x)")
    case (0,let y):
        print("on the y-axis with a y value of \(y)")
    case (let x,let y):
        print("somewhere else at (\(x), \(y))")
    }
  ```

* 使用where子句检查是否符合特定的约束。
  
  ```swift
    let point = (1,-1)
    switch point {
    case let (x, y) where x == y:
        print("(\(x), \(y)) is on the line y = x")
    case let (x, y) where x == -y:
        print("(\(x), \(y)) is on the line y = -x")
    case let (x, y) :
        print("(\(x), \(y)) is just some arbitrary point")
    }

  ```

* 复合匹配
  * 多个模式之间逗号分隔；模式太长，可以写成多行。
  
    ```swift
    let someCharacter: Character = "e"
    switch someCharacter {
    case "a", "e", "i", "o", "u":
        print("\(someCharacter) is a vowel")
    case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
        "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
        print("\(someCharacter) is a consonant")
    default:
        print("\(someCharacter) is not a vowel or a consonant")
    }

    ```

  * 复合匹配也可以包括值绑定

    ```swift
    let point = (9,0)
    switch point {
    case (let distance, 0), (0, let distance):
        print("On an axis, \(distance) from the origin")
    default:
        print("Not on an axis")
    }

    ```

## 控制转移

* `continue`
* `break`
* `fallthrough`
* `return`
* `throw`
* 语句标签

## guard

```txt
A guard statement is used to transfer program control out of a scope if one or more conditions aren’t met.
```

* 建议使用`guard`的情况：
  * 验证入口条件。
  * 在成功的路径上提前退出(黄金大道理论)。
  * `guard let`语句用于可选值解包
  * 执行被终止，计算结果为空，执行时出现错误
  * 日志（返回之前输出信息到控制台），崩溃和断言中的条件需要处理可选值时。
* 不要用`guard`代替琐碎的`if...else`语句
* 不要用`guard`作为`if`的相反情况
* 不要在`guard`的`else`语句中放入复杂代码。

```swift
// 使用 if
 func isIpAddress(ipString: String) -> (Int,String) {
    let components = ipString.split(separator: ".")
    if components.count == 4 {
        if let first = Int(components[0]), first >= 0 && first <= 255 {
            if let second = Int(components[2]), second >= 0 && second <= 255 {
                if let third = Int(components[2]), third >= 0 && third <= 255 {
                    if let forth = Int(components[4]), forth >= 0 && forth <= 255 {
                        // Important code goes here
                        return (0, "ip地址合法")
                    } else {
                        return (4,"ip地址第四部分错误")
                    }
                } else {
                    return (3,"ip地址第三部分错误")
                }
            } else {
                return (2,"ip地址第二部分错误")
            }
        } else {
            return (1,"ip地址第一部分错误")
        }
    } else {
        return (100,"ip地址必须有四部分")
    }
 }
 // 使用 guard
 func isIpAddress(ipString: String) -> (Int,String) {
    let components = ipString.split(separator: ".")
    guard components.count == 4 else {
        return (100,"ip地址必须有四部分")
    }
    guard let first = Int(components[0]), first >= 0 && first <= 255 else {
        return (1,"ip地址第一部分错误")
    }
    guard let second = Int(components[2]), second >= 0 && second <= 255 else {
        return (2,"ip地址第二部分错误")
    }
    guard let third = Int(components[2]), third >= 0 && third <= 255 else {
        return (3,"ip地址第三部分错误")
    }
    guard let forth = Int(components[4]), forth >= 0 && forth <= 255 else {
        return (4,"ip地址第四部分错误")
    }
    // Important code goes here
    return (0, "ip地址合法")
 }
```

## 检查API的可用性

* swift拥有内置的对API可用想的检查功能。
* 使用`if`或者`guard`语句。

```swift

 if #available(iOS 10, macOS 10.12, *) {
     // Use iOS 10 APIs on iOS, and use macOS 10.12 APIs on macOS
 } else {
     // Fall back to earlier iOS and macOS APIs
 }
```
