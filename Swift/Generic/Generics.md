# Swift之Generics

## 泛型发展

1. 泛型程序最早出现在1970年的CLU和Ada语言中，后来被 许多基于对象和面向对象的语言采用，包括C++、Java、VB等。
2. 1971年，Dave Musser首先提出闭关推广了泛型编程理论，但是局限于软件开发和计算机代数领域。1979年，Alexander Stepanov开始研究泛型编程，并提出STL体系结构。
3. 1993年，Stepanov受邀在ANSI/ISO C++标准委员会的会议上介绍了泛型编程理论及其相关工作。1994年3月，Stepanov和Meng Lee提出STL草案，1994年7月ANSI/ISO C++标准委员会通过了修改后的STL草案。
4. C++泛型典型应用：STL和Boost.

## 定义泛型函数

```swift
 func sawpTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a =  b
    b = temp
 }
```

## 定义泛型类型

```swift
 struct Stack<Element> {
    var items = [Element]()
    mutating func push(element: Element){
        items.append(element)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
 }
```

扩展时不需要提供形式参数列表：

```swift
extension Stack {
    var top : Element? {
        return items.last
    }
}
```

## 泛型类型约束

### 为什么需要类型约束

上述函数和stack可以适用于任意类型，但是于是需要添加强制的类型约束。类型约束指的是一个类型形式参数必须继承自特定类，或者遵循特定协议、组合协议。比如swift中的字典，声明如下：

```swift
struct Dictionary<Key, Value> where Key : Hashable
```

就在键的类型上添加了约束，必须可以哈希，即必须提供一种使其可以唯一表示的方法。如果键值不可哈希，我们在插入删除以及更新值的时候回发生混乱。
类型约束语法：

```swift
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        //因为用到==，所以类型必须遵循Equatable协议。
        if value  == valueToFind {
            return index
        }
    }
    return nil
}
```

如果没有添加遵循Equatable协议的要求，则会有如下报错,告诉你可以使用==的所有类型。

```txt
SwiftPractice.playground:24:20: note: overloads for '==' exist with these partially matching parameter lists: ((), ()), ((A, B), (A, B)), ((A, B, C), (A, B, C)), ((A, B, C, D), (A, B, C, D)), ((A, B, C, D, E), (A, B, C, D, E)), ((A, B, C, D, E, F), (A, B, C, D, E, F)), (Any.Type?, Any.Type?), (AnyHashable, AnyHashable), (AnyIndex, AnyIndex), (AnyKeyPath, AnyKeyPath), (Array<Element>, Array<Element>), (ArraySlice<Element>, ArraySlice<Element>), (Bool, Bool), (CGAffineTransform, CGAffineTransform), (CGPoint, CGPoint), (CGRect, CGRect), (CGSize, CGSize), (CGVector, CGVector), (Calendar, Calendar), (Calendar.Component, Calendar.Component), (Calendar.Identifier, Calendar.Identifier), (Calendar.MatchingPolicy, Calendar.MatchingPolicy), (Calendar.RepeatedTimePolicy, Calendar.RepeatedTimePolicy), (Calendar.SearchDirection, Calendar.SearchDirection), (Character, Character), (CharacterSet, CharacterSet), (ClosedRange<Bound>, ClosedRange<Bound>), (ClosedRange<Bound>.Index, ClosedRange<Bound>.Index), (CodingUserInfoKey, CodingUserInfoKey), (CollectionDifference<ChangeElement>, CollectionDifference<ChangeElement>), (CollectionDifference<ChangeElement>.Change, CollectionDifference<ChangeElement>.Change), (CollectionDifference<ChangeElement>.Index, CollectionDifference<ChangeElement>.Index), (ContiguousArray<Element>, ContiguousArray<Element>), (DarwinBoolean, DarwinBoolean), (Data, Data), (Date, Date), (DateComponents, DateComponents), (DateInterval, DateInterval), (Decimal, Decimal), (Dictionary<Key, Value>.Index, Dictionary<Key, Value>.Index), (Dictionary<Key, Value>.Keys, Dictionary<Key, Value>.Keys), (DispatchQoS, DispatchQoS), (DispatchQoS.QoSClass, DispatchQoS.QoSClass), (DispatchQueue.AutoreleaseFrequency, DispatchQueue.AutoreleaseFrequency), (DispatchQueue.GlobalQueuePriority, DispatchQueue.GlobalQueuePriority), (DispatchQueue.SchedulerTimeType.Stride, DispatchQueue.SchedulerTimeType.Stride), (DispatchTime, DispatchTime), (DispatchTimeInterval, DispatchTimeInterval), (DispatchTimeoutResult, DispatchTimeoutResult), (DispatchWallTime, DispatchWallTime), (EmptyCollection<Element>, EmptyCollection<Element>), (FlattenSequence<Base>.Index, FlattenSequence<Base>.Index), (FloatingPointClassification, FloatingPointClassification), (FloatingPointRoundingRule, FloatingPointRoundingRule), (FloatingPointSign, FloatingPointSign), (IndexPath, IndexPath), (IndexSet, IndexSet), (IndexSet.Index, IndexSet.Index), (IndexSet.RangeView, IndexSet.RangeView), (Int, Int), (Int16, Int16), (Int32, Int32), (Int64, Int64), (Int8, Int8), (LazyPrefixWhileSequence<Base>.Index, LazyPrefixWhileSequence<Base>.Index), (Locale, Locale), (ManagedBufferPointer<Header, Element>, ManagedBufferPointer<Header, Element>), (Measurement<LeftHandSideType>, Measurement<RightHandSideType>), (Mirror.DisplayStyle, Mirror.DisplayStyle), (NSDirectionalEdgeInsets, NSDirectionalEdgeInsets), (NSObject, NSObject), (NSObject.KeyValueObservingPublisher<Subject, Value>, NSObject.KeyValueObservingPublisher<Subject, Value>), (NSRange, NSRange), (Never, Never), (Notification, Notification), (NotificationCenter.Publisher, NotificationCenter.Publisher), (ObjectIdentifier, ObjectIdentifier), (OpaquePointer, OpaquePointer), (OperationQueue.SchedulerTimeType.Stride, OperationQueue.SchedulerTimeType.Stride), (PersonNameComponents, PersonNameComponents), (Range<Bound>, Range<Bound>), (Result<Success, Failure>, Result<Success, Failure>), (ReversedCollection<Base>.Index, ReversedCollection<Base>.Index), (RunLoop.SchedulerTimeType.Stride, RunLoop.SchedulerTimeType.Stride), (Scanner.NumberRepresentation, Scanner.NumberRepresentation), (Selector, Selector), (Self, Other), (Self, RHS), (Set<Element>, Set<Element>), (Set<Element>.Index, Set<Element>.Index), (String, String), (String.Encoding, String.Encoding), (String.Index, String.Index), (TimeZone, TimeZone), (UIEdgeInsets, UIEdgeInsets), (UIFloatRange, UIFloatRange), (UIOffset, UIOffset), (UInt, UInt), (UInt16, UInt16), (UInt32, UInt32), (UInt64, UInt64), (UInt8, UInt8), (URL, URL), (URLComponents, URLComponents), (URLQueryItem, URLQueryItem), (URLRequest, URLRequest), (UUID, UUID), (Unicode.CanonicalCombiningClass, Unicode.CanonicalCombiningClass), (Unicode.GeneralCategory, Unicode.GeneralCategory), (Unicode.NumericType, Unicode.NumericType), (Unicode.Scalar, Unicode.Scalar), (Unicode.UTF32, Unicode.UTF32), (UnicodeDecodingResult, UnicodeDecodingResult), (Wrapped?, Wrapped?), (Wrapped?, _OptionalNilComparisonType), ([Key : Value], [Key : Value]), (_OptionalNilComparisonType, Wrapped?), (_UIntBuffer<Element>.Index, _UIntBuffer<Element>.Index), (_ValidUTF8Buffer.Index, _ValidUTF8Buffer.Index)
         if value  == valueToFind {
```

## 泛型协议

```txt
Protocols do not allow generic parameters; use associated types instead
```

泛型协议通过关联类型实现,管理按类型是协议中类型的占位符。

### 关联类型

```swift
 protocol Container {
     associatedtype ItemType
     mutating func append(_ item: ItemType)
     var count: Int { get }
     subscript(i: Int) -> ItemType { get }
 }
```

具体实例化的例子：

```swift
 struct IntStack: Container {
    var items = [Int]()
    mutating func push(element: Int){
        items.append(element)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }

    //必须指明关联类型
    typealias ItemType = Int
    mutating func append(_ item: Int) {
        self.push(element: item)
    }

    var count: Int {
        return items.count
    }

    subscript(i: Int) -> Int {
        return items[i]
    }
 }
```

因为swift强大的类型推断功能，反省类型遵循协议时，可以省略协议中关联类型的显示指定。

```swift
 struct Stack<Element>: Container {
    var items = [Element]()
    mutating func push(element: Element){
        items.append(element)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    mutating func append(_ item: Element) {
        self.push(element: item)
    }

    var count: Int {
        return items.count
    }

    subscript(i: Int) -> Element {
        return items[i]
    }
 }
```

### 关联类型的约束

关联类型的类型约束添加方法与泛型类型中类型约束方法一样,冒号后面添加继承的类或者遵循的协议

```swift
 protocol Container {
    //关联类型约束
    associatedtype ItemType: Equatable
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
 }
```

协议本身可以作为其关联类型的类型约束。

```swift
protocol Container {
    //关联类型约束
    associatedtype ItemType: Equatable
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
 }

 protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.ItemType == ItemType
    func suffix(_ size: Int) -> Suffix
 }

 struct Stack<Element: Equatable>: Container {
    var items = [Element]()
    mutating func push(element: Element){
        items.append(element)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    mutating func append(_ item: Element) {
        self.push(element: item)
    }

    var count: Int {
        return items.count
    }

    subscript(i: Int) -> Element {
        return items[i]
    }
 }

 extension Stack: SuffixableContainer {
    func suffix(_ size: Int) -> Stack {
        var ans = Stack()
        for index in (count  - size)..<count {
            ans.append(self[index])
        }
        return ans
    }
 }
```

## where子句

where子句应用于函数。

```swift
 protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
 }

 func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.ItemType == C2.ItemType, C1.ItemType: Equatable
 {
    if someContainer.count != anotherContainer.count {
        return false
    }
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
    return true
 }

```

where子句也可以应用在扩展之中。

```swift
 extension Array where Element: BinaryInteger  {
    var average: Double {
        return self.reduce(0.0) {$0 +  Double($1)} / Double(count)
    }
 }
 extension Array where Element == Double {
    var average: Element {
        return self.reduce(0.0) {$0 +  $1} / Double(count)
    }
 }
```

where子句应用于关联类型。

```swift
 protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
    associatedtype Iterator: IteratorProtocol where Iterator.Element == ItemType
    func makeIterator() -> Iterator
 }
```

## 泛型下标

```swift
 protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
 }

 extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [ItemType] where Indices.Iterator.Element == Int {
        var ans = [ItemType]()
        for index in indices  {
            ans.append(self[index])
        }
        return ans
    }
 }
```
