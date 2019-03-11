/*
 A enumeration defines a common type for group of related vlues and enables you to work with those 
 values in a type-safety way within your code. You do not have to provide a raw value for enumeration.
  If you do, the value can be a string, character, a value of any integer or floating-point type. Enumeration 
  cases can specify associated values of any type to be stored along with each different case value.
 Features: computed properties;instance methods;initializers;to be extend;conform to protocols.
 Matching Enumeration values with a Switch Statement
 */
import Foundation

//Iterating over Enumeration Cases
enum CompassDirection : CaseIterable {
    case West,East,North,South
}

/*Associated Value
 Constants and variables of type Barcode can store either a .upc  or a .qrCode with their 
 associated values, but they can store only one of them at any given time.
 */
enum Barcode {
    case upc(Int,Int,Int,Int)
    case qrCode(String)
}

func testAssociatedValues(){
    var productBarcode = Barcode.upc(8, 85909, 51226, 3)
    productBarcode = Barcode.qrCode("ABCDEFGHTYUI")
    switch productBarcode {
    case  let .upc(numberSystem, manufacturer, product, check):
        print("UPC: \(numberSystem), \(manufacturer), \(product), \(check)")
    case let .qrCode(productCode):
        print("QrCode : \(productCode)")
    }
}

func testRecursiveEnumerations(){
    indirect enum ArithemticExpression {
        case number(Int)
        case addtion(ArithemticExpression,ArithemticExpression)
        case multiplication(ArithemticExpression,ArithemticExpression)
    }
    
    let five = ArithemticExpression.number(5)
    let four = ArithemticExpression.number(4)
    let sum = ArithemticExpression.addtion(five, four)
    let product = ArithemticExpression.multiplication(sum, ArithemticExpression.number(2))
    
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
    print(evaluate(product))
}
func testEnumerations(){
    //    testAssociatedValues()
    testRecursiveEnumerations()
}

