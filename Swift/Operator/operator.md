# swift 之 operator

## 基本概念

* 一元运算符：对一个目标进行操作，如一元前缀运算符（!flag）和用于解包的一元后缀运算符(b!)。
* 二元运算符（中缀）。
* 三元运算符： flag ? a : b

## 赋值和算术运算符

swift支持c中大多数标准运算符，并且：

* 赋值运算符(=)不会返回值，防止误用为等于（==）。
* 算术运算符（+、-、*、/、 %）可以检测并阻止值溢出，甚至提供了可以允许值溢出的算术运算符。
* 加法运算符可以用于字符串拼接。
* 一元算术运算符：切换正负值，比如（+5，-5）。
* 取余运算符需要注意：被除数正负号不会被忽略，除数正负号会被忽略。
  
```swift

print(3 % 2) // 1
print(-3 % 2) // -1
print(3 % -2) // 1

```

## 溢出运算符

* 默认情况下，当给一个整数赋超过他容量的值时，swift会报错而不是生成一个无效的数，这给我们操作过大过小的数提供了额外的安全性。
* 提供三个溢出运算符让系统支持整数溢出运算：
  * 溢出加法：&+
  * 溢出减法：&-
  * 溢出乘法：&*

```swift
 var a: UInt8 = 0xff
 a &+= 1
 print(a) // 0
 a = 0
// a -= 1  error
 a &-= 1
 print(a) // 255
```

## 合并空值运算符

* a ?? b: a有值则解包，如果是nil，则返回默认值b。
* 文档要求： 表达式a为可选类型，表达式b必须与a的存储类型相同。(实际操作则不然)
* a ?? b 等价于 a != nil ? a! : b
* 如果a的值不是nil，那么b的值不会被考虑。

```swift
 //正常用法
 var a : Int? = nil
 var b: Int = 255

 print(a ?? b ) // 255
 a = 20
 print(a ?? b ) // 20
 print(type(of: a ?? b)) // Int

 //这样不会报错，但是明显c和d类型不同
 var c: Int? = nil
 let d: String = "abc"
 print(c ?? d) // abc

 //Expression type '(_) -> _' is ambiguous without more context
// print(type(of: c ?? d))
```

## 区间运算符

* 闭区间: (a...b)
* 半开区间: (a..<b)
* 单侧区间： (a...)   或者 (...b)
* 倒叙区间:  `(a...b).reversed()`
  
## 位运算

* 按位取反：~
* 与： &
* 或：|
* 异或：^
* 移位： >> 和 <<
  
常见应用：

* 交换两个变量的值

```swift
func swap(_ a: inout Int,_ b: inout Int) {
    a = a ^ b
    b = a ^ b
    a = a ^ b
 }
 var a = 10
 var b = 8
 print("a = \(a) b = \(b)")
 swap(&a, &b)
 print("a = \(a) b = \(b)")
```

* 无符号二进制中1的个数

```swift
 func countOfOnes(_ num: UInt) -> UInt {
    var count: UInt = 0
    var temp = num
    while temp != 0 {
        count += 1
        temp = temp & (temp - 1)
    }
    return count
 }
```

* 判断无符号整型是否是2的整数次幂

```swift
 func isPowerOfTwo(_ num: UInt) -> Bool {
    return num & (num - 1) == 0
 }
```

* 缺失的数字

```swift
 func findLostNum(_ nums: [UInt]) -> UInt {
    return nums.reduce(0) { $0 ^ $1}
 }
```

* 缺失失的两个数字： 分组异或

```swift
func findTwoLostNumbers(_ nums: [UInt]) -> (UInt,UInt) {
    let temp = nums.reduce(0) { $0 ^ $1}
    var flag: UInt = 1
    while temp & flag == 0 {
        flag <<= 1
    }
    var ans: (UInt,UInt) = (0,0)
    for num in nums {
        if num & flag == 0 {
            ans.0 ^= num
        } else {
            ans.1 ^= num
        }
    }
    return ans
 }

```

## 运算符重载

* 类和结构体可以为现有运算符提供自定义实现，叫做运算符重载。
  
```swift
 struct Vector2D {
    var x: Int
    var y: Int
    var description: String {
        return "(x: \(x), y: \(y))"
    }
 }

 extension Vector2D {
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
 }

 let vector = Vector2D(x: 1, y: 2)
 let another = Vector2D(x: 2, y: 5)
 let combineVector = vector + another
 print("vector1: \(vector.description) another: \(another.description) combineVector: \(combineVector.description)")
 //vector1: (x: 1, y: 2) another: (x: 2, y: 5) combineVector: (x: 3, y: 7)
```

* 一元运算符重载： 需要声明是前缀还是后缀(prefix or postfix)

```swift
 extension Vector2D {
    static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }
 }

 let positive = Vector2D(x: 3, y: 5)
 let negative = -positive
 print("positive: \(positive.description) negative: \(negative.description)") //positive: (x: 3, y: 5) negative: (x: -3, y: -5)
```

* 组合赋值运算符重载：左参数需要为 inout类型

```swift
 extension Vector2D {
    static func += (left: inout Vector2D, right: Vector2D) {
        left.x += right.x
        left.y += right.y
    }
 }

 var original = Vector2D(x: 2, y: 3)
 let toAdd = Vector2D(x: 4, y: 5)
 original += toAdd
 print(original.description) //(x: 6, y: 8)
```

* 等价运算符的重载：需要遵循Equatable协议，swift为以下自定义类型提供等价运算符的合成实现。
  
  * 只拥有遵循Equatable协议的存储属性的结构体
  * 只拥有遵循Equatable协议的关联类型的枚举
  * 没有关联类型的枚举

```swift
 extension Vector2D: Equatable {
    static func == (left: Vector2D, right: Vector2D) -> Bool {
        return left.x == right.x && left.y == right.y
    }
 }
```

## 自定义运算符

* 用operator声明
* 用prefix、postfix、infix限定

```swift
 prefix operator ++
 extension Vector2D {
    static prefix func ++ (vector: inout Vector2D) {
        vector += vector
    }
 }
var vector = Vector2D(x: 1, y: 2)
 ++vector
 print("vector: \(vector.description)") //vector: (x: 2, y: 4)
```

* 自定义中缀运算符需要制定优先级和结合性： 优先级组
  * 使用系统优先级组
  
```swift
 infix operator +- : AdditionPrecedence
 extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
 }

 infix operator *^: MultiplicationPrecedence
 extension Vector2D {
    static func *^ (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x * right.x, y: left.y * left.y + right.y * right.y)
    }
 }

 let first = Vector2D(x: 1, y: 2)
 let second = Vector2D(x: 3, y: 7)
 let third = Vector2D(x: 2, y: 2)
 //根据优先级组：先算 *^ 再算 +-
 print("vector: \((first +- second *^ third).description)") //vector: (x: 7, y: -51)
```

  * 使用自定义优先级组

```swift
 infix operator +- : AdditionPrecedence
 extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
 }
  precedencegroup UserDefinePrecedence {
     associativity: left
     lowerThan: AdditionPrecedence
  }
 infix operator *^: UserDefinePrecedence
 extension Vector2D {
    static func *^ (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x * right.x, y: left.y * left.y + right.y * right.y)
    }
 }

 let first = Vector2D(x: 1, y: 2)
 let second = Vector2D(x: 3, y: 7)
 let third = Vector2D(x: 2, y: 2)
 //根据优先级组：先算 +- 再算 *^
 print("vector: \((first +- second *^ third).description)") //vector: (x: 8, y: 29)
```
