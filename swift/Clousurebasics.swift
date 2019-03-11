import Foundation
/*
 Closures are self-contained blocks of functionality that can be passed around and used in your code.
 Closures can capture and store references to any constants and variables from the context in which they are defined.
 
 Closures take one of three forms:
 1.Global functions are closures that have a name and do not capture any values
 2.Nested functions are closures that have a name and can capture values from their enclosing functions.
 3.Closures expressions are unnamed closures written in a lightweight syntax that can capture values from their sourounding context
 
 Closures' optimizations:
 1.Inferring parameters and return value types from context
 2.Implicit returns from a single-expression closures
 3.Shorthand argument names
 4.Trailing closure syntax
 
 Closures expression syntax:
 { (parameters) -> return type in
 statements
 }
 
 “Closures Are Reference Types”
 */

func testClosuresExpressionSyntax(){
    var names = ["Chris","Alex","Ewa","Barry","Tom"]
    var  orderedNames = names.sorted { (s1: String, s2 : String) -> Bool in
        return s1 < s2
    }
    print(orderedNames)
    //“Inferring Type From Context”
    names = ["Chris","Alex","Ewa","Barry","Tom"]
    orderedNames = names.sorted(by: { (s1, s2) -> Bool in
        return s1 < s2
    })
    print(orderedNames)
    //“Implicit Returns from Single-Expression Closures”
    names = ["Chris","Alex","Ewa","Barry","Tom"]
    orderedNames = names.sorted(by: { (s1, s2) -> Bool in s1 < s2
    })
    print(orderedNames)
    //Shorthand Argument Names
    names = ["Chris","Alex","Ewa","Barry","Tom"]
    orderedNames = names.sorted(by: {$0 < $1})
    print(orderedNames)
    //Operator Methods
    names = ["Chris","Alex","Ewa","Barry","Tom"]
    orderedNames = names.sorted(by: >)
    print(orderedNames)
    
    //Trailing Closure
    /*
     If you need to pass a closure expression to a function as the final argument and the closure expression is long, use Trailing Closure instead.
     */
    names = ["Chris","Alex","Ewa","Barry","Tom"]
    orderedNames = names.sorted(){
        $0 > $1
    }
    print(orderedNames)
    names = ["Chris","Alex","Ewa","Barry","Tom"]
    //if the closure is the only parameter of the function
    orderedNames = names.sorted{
        $0 > $1
    }
    print(orderedNames)
}

func testTrailingClosure(){
    let digitNames = [0:"Zero",1: "One",2:"Two",3:"Three",4:"Four",5:"Five",6:"Six",7:"Seven",8:"Eight",9:"Nine"]
    let nums = [16,58,510]
    
    let string = nums.map { (number) -> String in
        var number = number
        var output = ""
        
        repeat {
            output = digitNames[number % 10]! + output
            number = number / 10
        } while number > 0
        return output
    }
    print(string)
}

//Capturing Values

func testClosureCaptureValues(){
    func makeIncrementer(amount : Int) -> (() -> Int) {
        var runingTotal = 0
        func incrementer() -> Int {
            runingTotal += amount
            return runingTotal
        }
        return incrementer
    }
    
    let incrementerByTen = makeIncrementer(amount: 10)
    
    print(incrementerByTen())
    print(incrementerByTen())
    print(incrementerByTen())
    let incrementerBySeven = makeIncrementer(amount: 7)
    print(incrementerBySeven())
}
/*
 A closure is said to "escape" a function when the clousure is passed as a argument to the function, but is called after the function returns.
 
 One way that a closure can escape is by being stored in a variable that is defined ouside the function.
 
 asynchronous operation
 */

var completionHandlers : [() -> Void] = []
func someFunctionWithEscapeClosure(completionHandler : @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapeClosure(closure : () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomethind(){
        //“Marking a closure with @escaping means you have to refer to self explicitly within the closure. ”
        someFunctionWithEscapeClosure {
            self.x += 100
        }
        someFunctionWithNonescapeClosure {
            x = 200
        }
    }
}
func test_clousure()  {
    let instance = SomeClass()
    instance.doSomethind()
    print(instance.x)
    
    completionHandlers.first?()
    print(instance.x)
}

