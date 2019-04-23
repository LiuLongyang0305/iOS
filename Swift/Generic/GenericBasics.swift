/****** GENERICS ***********/
import Foundation
/*
 Generic code enables you to write flexible, reusable functions and types that can work with any type, subjects, or
 requirements tat you define.
 */

//Generic Functions
func swap<T>(_ a: inout T, _ b: inout T){
    let tempararyA = a
    a = b
    b = tempararyA
}
//Type Parameters
//named the type parameters with T, V, U
//Generic Types
struct Stack<Element> {
    var items = [Element]()
    mutating func push(element: Element){
        items.append(element)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}
//Extension a Generic Type
extension Stack {
    var top : Element? {
        return items.last
    }
}

func testGenericStack(){
    var stack = Stack<String>()
    stack.push(element: "uno")
    stack.push(element: "dos")
    stack.push(element: "tres")
    stack.push(element: "cuatro")
    print("\(String(describing: stack.top))")
}

//Type Constraints
/*
 It is sometimes useful to enforce certain type constraints on the types that can be used with generic fuctions and Generic
 types. Type constrains specify that a type parameter must inherit from a specific class, or  conform to particular protocol
 or protocol composions.
 Example : Dictionary's keys must be hashable.
 */
/*
 Syntax:
 func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U){
 //funcbody goes here
 }
 */
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value  == valueToFind {
            return index
        }
    }
    return nil
}

//Associated Types
/*
 When defining a protocol, it is sometimes useful to declear one or more associated types as one part of the protocol's
 defination. An associated type gives a placeholder name to a type that is used as part of the protocol. The actual type
 to use for that associated type is not specified until the protocol is adopted. Associated types are specified with the
 associatedtype keyword.
 */

protocol Container {
    //    associatedtype Item: Equatable
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

struct NewStack<Element>: Container {
    
    typealias Item = Element
    
    var items = [Element]()
    mutating func push(_ item: Element){
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    mutating func append(_ item: Element) {
        self.push(item)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Element {
        return items[i]
    }
}

//Extending an Existing type to specify an Associated type
extension Array: Container{}

//Adding constraints to Associated Types
protocol NewContainer {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

//Using a protocol in Its Associated Type's Constraints
/*
 Suffix:(1)Conform to the protocol SuffixableContainer
        (2)Its Item type must be the same as the container's Item type
 */
protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}
extension NewStack : SuffixableContainer {
    func suffix(_ size: Int) -> NewStack {
        var result = NewStack()
        for index in (count - size)..<count {
            result.append(self[index])
        }
        return result
    }
}

func testAssociatedTypesContraints() {
    var stackOfInts = NewStack<Int>()
    stackOfInts.append(10)
    stackOfInts.append(20)
    stackOfInts.append(30)
    let _ = stackOfInts.suffix(2)//[20,30]
}
testAssociatedTypesContraints()

//Generic Where Clauses
/*
 A generic where clauses enables you to require that an associated type must conform to a certain protocol, or the certain
 type parameters and associated types must be the same. A Generic where clause start with the  where keyword, followed
 by constraints for associated types or  eauality relationship between types and associated type.
 */
func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.Item == C2.Item, C1.Item: Equatable
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

func testGenericWhereClause(){
    var stackOfString = NewStack<String>()
    stackOfString.append("uno")
    stackOfString.append("dos")
    stackOfString.append("tres")
    let arrayOfString = ["uno","dos","tres"]
    if allItemsMatch(stackOfString, arrayOfString) {
        print("All Items match.")
    } else {
       print("not all Items match.")
    }
}
testGenericWhereClause()
//Extensions with a Generic Where Clause
extension NewStack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}
extension Container where Item: Equatable{
    func startWith(_ item: Item) -> Bool {
        return count >= 1  && self[0] == item
    }
}
extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}

//Associated Types with a Generic Where Clause
protocol ThirdContainer {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}

//Generic Subscripts
extension ThirdContainer {
    subscript<Indecies: Sequence>(indecies: Indecies) -> [Item] where Indecies.Iterator.Element == Int {
        var result = [Item]()
        for index in indecies {
            result.append(self[index])
        }
        return result
    }
}
