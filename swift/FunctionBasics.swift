import Foundation
import UIKit

func testCommonFunction(){
    func greet(person: String) -> String {
        let greeting = "Hello, " + person + "!"
        return greeting
    }
    func greetAgain(person: String) -> String {
        let greeting = "Hello again, " + person + "!"
        return greeting
    }
    func  greet(person: String,alreadyGreeted: Bool) -> String {
        return alreadyGreeted ? greetAgain(person: person) : greet(person: person)
    }
    
    let greeting = greet(person: "Tom", alreadyGreeted: true)
    print(greeting)
    
}

//“Functions with Multiple Return Values”
func testFunctionReturnTuples(){
    func minMaxWithTuplesMembersNamed(array : [Int]) -> (min : Int,max:Int) {
        var currentMin = array[0]
        var currentMax = array[0]
        for value in array[1..<array.count] {
            if value < currentMin {
                currentMin = value
            } else if value > currentMax {
                currentMax = value
            }
        }
        return (currentMin,currentMax)
    }
    func minMaxWithTuplesMembersUnnamed(array : [Int]) -> (Int,Int) {
        var currentMin = array[0]
        var currentMax = array[0]
        for value in array[1..<array.count] {
            if value < currentMin {
                currentMin = value
            } else if value > currentMax {
                currentMax = value
            }
        }
        return (currentMin,currentMax)
    }
    func minMaxWithOptionalTuples(array : [Int]) -> (Int,Int)?{
        if array.isEmpty {
            return nil
        }
        var currentMin = array[0]
        var currentMax = array[0]
        for value in array[1..<array.count] {
            if value < currentMin {
                currentMin = value
            } else if value > currentMax {
                currentMax = value
            }
        }
        return (currentMin,currentMax)
    }
    
    let bounds1 = minMaxWithTuplesMembersNamed(array: [8,-6,2,109,3,71])
    print("min = \(bounds1.min)   max = \(bounds1.max)")
    
    let bounds2 = minMaxWithTuplesMembersUnnamed(array: [8,-6,2,109,3,71])
    print("min = \(bounds2.0)   max = \(bounds2.1)")
    
    if let bounds = minMaxWithOptionalTuples(array: [8,-6,2,109,3,71]){
        print("min = \(bounds.0)   max = \(bounds.1)")
    }
    
    let (min,max) = minMaxWithTuplesMembersNamed(array: [8,-6,2,109,3,71])
    print("min = \(min)   max = \(max)")
    
}

//Default Parameter Values
func testFunctionWithDefaultValue(){
    func someFunction(parameterWithoutDefault : Int, parameterWithDefault : Int = 12) -> Int{
        return parameterWithDefault + parameterWithoutDefault
    }
    
    print(someFunction(parameterWithoutDefault: 4))
    print(someFunction(parameterWithoutDefault: 6, parameterWithDefault: 8))
}

//Variadic Parameters
func testVariadicParameters(){
    func arithmeticMean(_ nums : Double...) -> Double {
        var total : Double = 0.0
        for num in nums {
            total += num
        }
        return total / Double(nums.count)
    }
    
    print(arithmeticMean(1,2,3,4,5))
    print(arithmeticMean(3.5,5.6))
}

// In-Out Parameters
func testInoutParameters(){
    func swapTwoInts(_ a : inout Int, _ b : inout Int){
        let temparayA = a
        a = b
        b = temparayA
    }
    
    var first : Int = 4
    var second : Int = 10
    print("before: first = \(first)  second = \(second) ")
    swapTwoInts(&first, &second)
    print("after: first = \(first)  second = \(second) ")
}
//Function Types
func testFunctionsTypes(){
    typealias MathFunction = (Int,Int) -> Int
    
    func addTwoInts(_ a : Int,_ b : Int) -> Int {
        return a + b
    }
    func multiplyTwoInts(_ a : Int , _ b : Int) -> Int {
        return a * b
    }
    
    func printMathResult(mathFunction: MathFunction,_ a : Int, _ b : Int){
        print("result = \(mathFunction(a,b))")
    }
    
    func functionWithReturnFunctionTypes(_ isAdd : Bool) -> MathFunction {
        return isAdd ? addTwoInts(_:_:) : multiplyTwoInts(_:_:)
    }
    var myFunction : MathFunction = addTwoInts(_:_:)
    print("two numbers sum = \(myFunction(3,5))")
    myFunction = multiplyTwoInts(_:_:)
    print("two numbers product = \(myFunction(3,5))")
    printMathResult(mathFunction: addTwoInts(_:_:), 123, 456)
    
    let func1 = functionWithReturnFunctionTypes(true)
    let func2 = functionWithReturnFunctionTypes(false)
    
    print("add two numbers : \(func1(3,5))")
    print("multiply two numbers : \(func2(3,5))")
}
func test(){
    //    testFunctionWithDefaultValue()
    //    testVariadicParameters()
    //    testInoutParameters()
    //    testFunctionsTypes()
}

