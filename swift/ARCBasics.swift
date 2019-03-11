/**************Automatic Reference Counting ****************/
import Foundation
/*
 Swift uses Automatic Refeerence Counting (ARC) to track and manage  app's memeory usage. Referene counting applies only to
 instances of classes. Structures and enumerations are value types, not reference types, and are not stored and passed by
 reference.
 */

//How ARC Works
/*
 1. Every time you create a new instance of a class, ARC allocates a chunk of memory to store information about the instance.
 This memory holds the information about the type of the instance, togeter with the values of any stored properties
 associated with the instance.
 2. When an instance is no longer needed, ARC frees up the memory used by that instance so that the memory can be used for
 other purposes. This ensures taht class  instance don't take up space in memory when they are no longer needed.
 3. If ARC were to deallocate an instance that was still in use, it would no longer be possible to access the instance's
 properties, and call the instance's methods. If you try to access the instance, you app  would most likely crash.
 4. To make sure that instances don't disappear while they are still used, ARC tracks how many properties, variables, and
 constants are currently referring to each class instance. ARC will not deallocate an instance as long as at least one
 active reference to that instance still exists.
 5. To make this possible, whenever you assign a class instance to a property, constant, or a variable, that property,
 constant, or variable will makes a strong reference to the instance. The reference is called a "strong" reference because
 it keeps a firm hold on that instance, and doesn;t allow it to be deallocated for as long as that strong referece remains.
 */

//ARC in Action
class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized!")
    }
    var appartment: Apartment?
    deinit {
        print("\(name) is being deinitialized!")
    }
}
func testARC(){
    var ref1: Person? = Person(name: "John")
    var ref2: Person? = ref1
    var ref3: Person? = ref1
    print("***** 1 ******")
    ref1 = nil
    print("***** 2 ******")
    ref2 = nil
    print("***** 3 ******")
    ref3 = nil
}
/*result:
 John is being initialized!
 ***** 1 ******
 ***** 2 ******
 ***** 3 ******
 John is being deinitialized!
 */

//Strong Reference Cycles Between class Instances
class Apartment {
    let unit: String
    init(unit: String) {
        self.unit = unit
    }
    var tenant: Person?
    deinit {
        print("Apartment \(unit) is being deinitialized!")
    }
}

func testStrongReferenceCycle(){
    var john: Person? = Person(name: "John")
    var apartment: Apartment? = Apartment(unit: "4A")
    john?.appartment = apartment
    apartment?.tenant = john
    john = nil
    apartment = nil
}
//result : John is being initialized!

//Resolving Strong referenve Cycle Between Class Instance
/*
 Two ways : Weak Reference && Unowed Reference
 Weak and unowed reference enables one instance in a reference cycle to refer to the other instance without keeping a strong
 hold on it. The instance can then refer to each other without creating a strong reference cycle.
 Use a weak reference when the other instance has a shorter lifetime.
 Use an unowed reference when the other reference  has the same lifetime or a longer lifetime.
 */
//Weak Reference
//ARC automatically sets weak reference to nil when the instance that it refer to deallocated, and always decleared as variables.=======> Both of the two properties are allowed to be nil.
class NewPerson {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized!")
    }
    var appartment: NewApartment?
    deinit {
        print("\(name) is being deinitialized!")
    }
}
class NewApartment {
    let unit: String
    init(unit: String) {
        self.unit = unit
    }
    weak var tenant: NewPerson?
    deinit {
        print("Apartment \(unit) is being deinitialized!")
    }
}
func testweakreference(){
    var john: NewPerson? = NewPerson(name: "John")
    var apartment: NewApartment? = NewApartment(unit: "4A")
    john?.appartment = apartment
    apartment?.tenant = john
    print("Set John = nil")
    john = nil
    print("Set apartment = nil")
    apartment = nil
}
//testweakreference()
/*
 Result:
 John is being initialized!
 Set John = nil
 John is being deinitialized!
 Set apartment = nil
 Apartment 4A is being deinitialized!
 */

//Unowed Reference
/*An unowned reference is exoected to always have a value, so ARC never set an unowned reference's value to nil, which means
 that unowed reference are defined using non-optional types.
 =====> One is allowed to be nil while the other can't be nil
 */

class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit {
        print("\(name) is being deinitialized!")
    }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit {
        print("Card #\(number) is being deinitialized!")
    }
}
func testUnownedReference()  {
    var john: Customer? = Customer(name: "John")
    john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
    print("Set john = nil")
    john = nil
}
//testUnownedReference()
/*Result:
 Set john = nil
 John is being deinitialized!
 Card #1234567890123456 is being deinitialized!
 */

//Unowned Reference and impplicitly Unwrapped Optional Properties
/*The third scenario: both properties should always have a value, and neither property should ever be nil once initialization
 is complete.
 ===> Combine an unowned property on one class with an implicitly unwrapped optional property on the other class.
 CapitalCity has a default value = nil. So after setting the name, the country initializer can start to reference and
 pass around the implicit self property to create the instance of City.
 */

class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capticalName: String) {
        self.name = name
        self.capitalCity = City(name: capticalName, country: self)
    }
}
class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}
//Strong Reference Cycle for closures
/*A strong reference cycle can also occuer if  you assign a closure to a property 0f a class instance, and the body of that clousure captures the instance.
 =========> By accessing some properties or invoke some methods.
 =========>Reason: Closures are reference types.
 =========>Solution: closure capture list
 */

class HTMLElement {
    let name: String
    let text: String?
    //    lazy var asHTML : () -> String = {
    //        if let text = self.text {
    //            return "<\(self.name)>\(text)</\(self.name)>"
    //        } else {
    //            return "<\(self.name) />"
    //        }
    //    }
    lazy var asHTML : () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    init(name: String, text: String? =  nil) {
        self.name = name
        self.text = text
    }
    deinit {
        print("\(name) is being deinitialized!")
    }
}

func tsetStrongReferenceCycleCausedByClosure() {
    let heading = HTMLElement(name: "h1")
    let defaultText = "some default texts"
    heading.asHTML = {
        return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
    }
    print(heading.asHTML())
    var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, aorld!")
    print(paragraph?.asHTML())
    print("set paragraph = nil")
    paragraph = nil
}
tsetStrongReferenceCycleCausedByClosure()
/*Result:
 <h1>some default texts</h1>
 Optional("<p>hello, aorld!</p>")
 set paragraph = nil
 After using capture list:
 h1>some default texts</h1>
 Optional("<p>hello, aorld!</p>")
 set paragraph = nil
 p is being deinitialized!
 */
//Capture list
class Example {
    lazy var closure : (Int, String) -> String = {
        [unowned self] (index: Int, str : String) -> String in
        return String(index) + "" + str
    }
}
