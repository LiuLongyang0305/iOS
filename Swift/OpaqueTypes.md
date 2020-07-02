# 不透明类型

具有不透明返回类型的函数或者方法会隐藏返回值的类型信息，函数不在提供具体的类型组委返回值，而是根据它所支持的协议来描述。在处理模块和代码调用之间的关系时，隐藏类型信息非常有用，因为他返回的底层数据类型仍然保持私有。而且不同于返回协议类型，不透明类型能保持类型一致性---编译器能获取类型信息，而模块使用者却获取不到。

## 不透明类型解决的问题

鸡舍你正在写一个模块，用来绘制ASCII符号构成的几何图形。它的基本特征是有一个`draw()`方法，会返回一个代表几何图形的字符串，你可以使用包含这个方法的`shape`协议来描述。

```swift
protocol Shape {
    func draw() -> String
}
struct Triangle: Shape {
    var size: Int
    func draw() -> String {
        var result = [String]()
        for lenth in 1...size {
            result.append(String(repeating: "*", count: lenth))
        }
        return result.joined(separator: "\n")
    }
}

```

利用泛型来实现竖直翻转操作和拼接操作，代码如下：

```swift
struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}
struct JoinedShape<U: Shape, T: Shape>: Shape {
    var top: U
    var bottom: T
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}
let flipTriangle = FlippedShape(shape: smallTriangle)
let joinedShape = JoinedShape(top: smallTriangle, bottom: flipTriangle)
```

限制在于：

* 翻转操作的结果`FlippedShape<Triangle>`**暴露了用来构造翻转图形的泛型类型**：`Triangle`。
* 由于需要声明完整的返回值类型，暴露图形创建细节可能导致原本不应该成为公共接口的类型暴露。模块内部可以采用多种方法构造同样的图形，**而外部使用时，应该与内部各种变换顺序的实现逻辑无关**。包装类型`FlippedSahpe`和`JoinedSahpe`和模块的使用者无关，它们不应该对使用者可见。模块的公共接口应该由翻转和拼接等基础操作组成，这些操作也应该返回独立的`Shape`类型的值。

## 返回不透明类型

可以认为不透明类型和泛型相反。**泛型允许调用方法时，为这个函数的形参和返回值制定一个与实现无关的类型**。如下，参数`x`和`y`的类型决定了函数中`T`的具体类型,调用的代码可以使用任何遵循`Comparable`协议的类型。函数的内部也以**通用方式**实现，所以可以应对调用者传入的各种类型。`max(_:_)`的实现仅使用了所有`Comparable`类型的**共有特性**。

```swift
func max<T>(_ x: T, _ y: T) -> T where T: Comparable { ... }
```

返回不透明类型则恰好相反，**不透明类型允许函数实现时，原则一个与调用代码无关的返回值类型**。

```swift
struct Square: Shape {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}


func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    return JoinedShape(top: top, bottom: JoinedShape(top: middle, bottom: bottom))
}
```

这个例子中，`makeTrapezoid()`函数返回值类型定义为`some Shape`；因此该函数返回遵循`Shape`协议的给定类型，而**不需要指定任何具体类型**。这样写`makeTrapezoid()`函数，也可以表明其公共接口的基本性质---返回一个几何图形---而不是具体公共接口生成的具体类型。
这个例子凸显了不透明返回类型和泛型的相反之处。`makeTrapezoid()`中代码可以返回任何它需要的类型，只要这个类型遵循`Shape`协议，就像低啊用泛型函数时可以使用任何需要的类型一样。这个函数的调用代码要采用**通用的方式**，就像泛型函数的实现代码一样，这样才能让`makeTrapezoid()`返回任何`Shape`类型的值都能正常使用。

可以把返回不透明类型和泛型结合起来。

```swift
func flip<T: Shape>(_ shape: T) -> some Shape {
    return FlippedShape(shape: shape)
}
func join<U: Shape, T: Shape>(_ top: U, _ bottom: T) -> some Shape {
    return JoinedShape(top: top, bottom: bottom)
}
let opaqueJoinedTriangle = join(smallTriangle, flip(smallTriangle))
```

这个例子中`opaqueJoinedTriangle`与前文的`joinedTriangles`完全一样。不同之处在于，`flip(_:)`和`join(_:_:)`把**对泛型参数的操作结果包装成了不透明类型，保证了结果中泛型参数类型不可见**。两个函数都是泛型函数，依赖于泛型参数，泛型参数又将`FlippedShape`和`JoinedShape`所需类型信息传递给他们。

**如果函数中多个地方使用了泛型参数，那么所有的返回值必须是同一类型**。

```swift
func invalidFlip<T: Shape>(_ shape: T) -> some Shape{
    if shape is Squre {
        //Function declares an opaque return type, but the return statements in its body do not have matching underlying types
        return shape
    }
    //Function declares an opaque return type, but the return statements in its body do not have matching underlying types
    return FlippedShape(shape: shape)
}
```

解决办法是把对`Sqaure`的特殊操作转移到`FlippedShape`的实现当中，如下。

```swift
struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        if shape is Square {
            return shape.draw()
        }
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}
```

返回值类型唯一的要求，并不影响在返回的不透明类型中使用泛型。

```swift
func `repeat`<T: Shape>(shape: T,count: Int) -> some Collection {
    return Array<T>(repeating: shape, count: count)
}

```

## 不透明类型和协议类型的区别

虽然使用不透明类型作为函数的返回值，看起来和返回协议类型非常相似，但有一个主要区别，就是**是否需要保持类型的一致性**。一个不透明类型只能对应一个具体类型，即使函数调用者并不知道是哪一种类型；协议类型可以对应多个类型，只要他们遵循同一个协议。总的来说，**协议类型根据有灵活性，底层可以存储更多样的值，而不透明类型对底层类型由更强的限定**。

看一下协议版本的`protocolFlip`函数,它对API调用者约束更加松散，保留了返回多种不同类型的灵活性。

```swift
//返回不同类型, Squre 和 FlippedShape
func protocolFlip<T : Shape>(_ shape: T) -> Shape {
    if shape is Square {
        return shape
    }
    return FlippedShape(shape: shape)
}
```

修改后的代码根据代表形状的参数的不同，可以可能返回`Square`实例和`FlippedShape`实例，索引同样的函数可能返回两个完全不同的类型。`protocolFlip(_:)`返回类型的不确定性，意味着**许多依赖于类型的操作无法执行**。比如不能使用`==`运算符。

```swift
let protocolFlippedTriangle = protocolFlip(smallTriangle)
let someThing = protocolFlip(smallTriangle)
protocolFlippedTriangle == someThing//ERROR
```

错误的原因在于，`Shhape`并未提供`==`运算符的实现，即使你添加了一个实现，也无法使用,因为`==`需要知道左右两侧参数类型。这类运算符通常采用`self`类型作为参数，用来匹配符合协议的具体类型，由于**协议作为类型使用时会发生类型擦除**，所以并不能给协议加上对`self`的实现要求。另外嘉定让协议遵循`Equatable`协议，那么`protocolFlip(_:)`函数将会报错，原因是：`Protocol 'Shape' can only be used as a generic constraint because it has Self or associated type requirements`。


这种方法的另外一个问题在于，`protocolFlip(_:)`函数无法嵌套使用，诸如`protocolFlip(protocolFlip(smallTriangle))`，因为`Value of protocol type 'Shape' cannot conform to 'Shape'; only struct/enum/class types can conform to protocols`。相比之下不透明类型则保留了**底层类型的唯一性**。`Swift`能够推断出关联类型。这个特性使得作为函数返回值，不透明类型比协议类型有更多的使用场景。

```Swift
protocol Container {
    associatedtype Item
    var count: Int { get }
    subscript(i:Int) -> Item { get }
}
extension Array: Container{}
```

以下两种都是错误的使用方法：

```swift
//Protocol 'Container' can only be used as a generic constraint because it has Self or associated type requirements
func makeProtocolContainer<T>(item: T) -> Container {
    return [item]
}

// Cannot convert return expression of type '[T]' to return type 'C'
func makeProtocolContainer<T, C: Container>(item: T) -> C {
    return [item]
}
```

使用不透明类型`some Container`作为返回类型，就能满足API的要求---返回一个结合类型，但不指定具体类型。

```swift
func makeOpaqueContainer<T>(item: T) -> some Container {
    return [item]
}

let opaqueContanierInt = makeOpaqueContainer(item: 23)
print(type(of: opaqueContanierInt) )//Array<Int>
print(type(of: opaqueContanierInt[0]) )//Int
let opaqueContanierSquare = makeOpaqueContainer(item: Square(size: 4))
print(type(of: opaqueContanierSquare) )//Array<Square>
```

上述例子表明**类型推断适用于不透明类型**。`makeOpaqueContainer<T>(item: )`函数中，底层类型是不透明集合`[T]`,此时`T`就是`Int`类型，所以返回值就是整数数组，关联类型`Item`也会被推断为`T`，`Container`协议中下标方法返回`Item`,意味着`opaqueContanierInt[0]`也会被推断为`Int`。