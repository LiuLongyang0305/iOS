import Foundation
/*
 A protocal defines a blueprint of methods, properties and other requirements that suit a particular task or piece od functionality, and can be adopted by a class, structure, or enumeration. Any type that satisfies the requirements of a protocol is said to confrom to that protocol
 */

//Syntax
protocol SomeProtocol {
    //protocol defination goes here
}

struct SomeStructure : SomeProtocol {
    //structure defination goes here
}
class SomeClass: SomeProtocol {
    //class defination goes here
}

//Property Requirements
protocol PropertyRequirementExample {
    var mustBeSettable : Int { get set }
    var doesNotNeedToBeSettable : Int { get }
    static var someTypeProperty : Int { get set}
}

protocol FullyNamed {
    var fullName : String {get}
}
struct Person : FullyNamed {
    var fullName: String
    init(_ name : String) {
        fullName = name
    }
}
class Starship: FullyNamed {
    
    var prefix : String?
    var name : String
    init(_ name : String, _ prefix : String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String{
        return (nil == prefix ? "" : prefix! + " ") + name
    }
}
func testPropertyRequirement()  {
    let player = Starship("Ming", "Yao")
    print(player.fullName)
}
//Method Requirements
/*
 Protocol can require specific methods and type methods to be implmented by conforming types.Default values can not be specified for method parameters with in a protocol definition.
 */

protocol RandomNumberGenerator {
    func random() -> Double
}
class LinearCongruentiaGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c)).truncatingRemainder(dividingBy: m)
        return lastRandom / m
    }
}

func testMethodRequirement(){
    let generator = LinearCongruentiaGenerator()
    print("Random number is : \(generator.random())")
    print("Other random number is : \(generator.random())")
}

//Nutating Method Requirements
//It is sometimes necessary for a method to modify or mutate the instance it belong to.
protocol Togglable {
    mutating func toggle()
}
enum Switch : Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .on:
            self = .off
        case .off:
            self = .on
        }
    }
}

func testMutatiingMethodRequirements(){
    var lightSwitch = Switch.off
    lightSwitch.toggle()
}

//Initializer Requirements
protocol TempProtocol {
    init()
}

class SuperClass {
    init() {
    }
}

class SomeSubClass : SuperClass,TempProtocol {
    required override init() {
    }
}
//Protocol as Types
/*
 You can use a protocol :
 (1) As a parameter type or return type in function, method or initilizer
 (2) As the type  of a constant, variable, or property
 (3)As the type of items in an array, dictionary, or other container
 */
class Dice {
    let sides : Int
    let generator : RandomNumberGenerator
    init(sides: Int, generator:RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}
func tsetProtocolAsType()  {
    let d6 = Dice(sides: 6, generator: LinearCongruentiaGenerator())
    for _ in 0...5 {
        print("Random dice roll is : \(d6.roll())")
    }
}
//Delegation
/*
 Delegation is a desigh pattern that enables a class or structure to hand ogg or delegate some of its responsibilites to an instance of an another type. This design pattern is implemented by defining a protocol that encapsulates  the delegated responsibilities, such that a conforming type (known as delegate) is guaranteed to provide the functionality that has been delegated. Delegate can be used to respond to a particular action, or to retrive data from an external data source.
 */

protocol DiceGame {
    var dice : Dice { get }
    func play()
}
protocol DiceGameDelegate : AnyObject {
    func gameDidstart(_ game : DiceGame)
    func game(_ game : DiceGame,didStartNewTernWithDiceRoll diceRoll : Int)
    func gameDidEnd(_ game : DiceGame)
}
class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    var dice: Dice = Dice(sides: 6, generator: LinearCongruentiaGenerator())
    var square : Int = 0
    var board : [Int]
    init() {
        board = Array<Int>(repeating: 0, count: finalSquare + 1)
        board[3] = 8;board[6] = 11;board[9] = 9;board[10] = 2
        board[14] = -10;board[19] = -11;board[22] = 2;board[24] = -8
    }
    weak var delegate : DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidEnd(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTernWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSqure where newSqure > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numOfTurns = 0
    func gameDidstart(_ game: DiceGame) {
        numOfTurns = 0
        if game is SnakesAndLadders{
            print("Start a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-side dice")
    }
    
    func game(_ game: DiceGame, didStartNewTernWithDiceRoll diceRoll: Int) {
        numOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numOfTurns) turns")
    }
}
//Adding a Protocol Confromance with an Extension
protocol TextRespentable {
    var textDescription : String { get }
}
extension Dice: TextRespentable {
    var textDescription: String {
        return "A \(sides)-side dice"
    }
}
extension SnakesAndLadders: TextRespentable {
    var textDescription: String {
        return "A game of Snakes and ladders with \(finalSquare) squares"
    }
}
//Conditionally Confroming to a Protocol
extension Array: TextRespentable where Element: TextRespentable {
    var textDescription: String {
        let itemsAsText = self.map { $0.textDescription}
        return "[" + itemsAsText.joined(separator: ",") + "]"
    }
}
//Protocol Inheriance
protocol PrettyTextRepresentable: TextRespentable {
    var prettyTextDescription: String {get}
}
extension SnakesAndLadders: PrettyTextRepresentable{
    var prettyTextDescription: String {
        var result = textDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                result += "*"
            case let snake where snake < 0:
                result += "&"
            default:
                result += "o"
            }
        }
        return result
    }
}

func testDelegate(){
    let tracker = DiceGameTracker()
    let game = SnakesAndLadders()
    game.delegate = tracker
    game.play()
    print(game.textDescription)
    let myDice = [Dice(sides: 6, generator: LinearCongruentiaGenerator()),Dice(sides: 8, generator: LinearCongruentiaGenerator())]
    print(myDice.textDescription)
    //Collection of Protocol Types
    let things: [TextRespentable] = [game,Dice(sides: 6, generator: LinearCongruentiaGenerator())]
    for thing in things {
        print(thing.textDescription)
    }
    print(game.prettyTextDescription)
}
//Class-only Protocols
protocol ClassOnlyProtocol : AnyObject {
    //class-only protocol goes here
}
//Protocol Composition
protocol Named {
    var name : String { get }
}
class Location {
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude : Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
}

class City: Location, Named{
    var name: String
    init(name: String, latitude: Double, longitude : Double ) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
    
}
func testProtocolComposition()  {
    func beginConcert(to location : Location & Named){
        print("Hello, \(location.name)")
    }
    let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
    beginConcert(to: seattle)
}

//Checking for Protocol Confromance
/*
 (1)The is operator returns true if an instance confrom to an protocol and returns false if it doesn't.
 (2)The as? version of the downcast operator returns an optional value of the protocols type, and its value is nil if the instance doesn't confrom the protocol.
 (3)he as! version of the downcast operator froces downcast to the protocol type and trigger a runtime error if the downcast doesn't succeed.
 */

//Optional Protocol Requirements
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count : Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource : CounterDataSource?
    func increment()  {
        if let amount = dataSource?.increment?(forCount: count){
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

class ThreeSource: NSObject,CounterDataSource {
    let fixedIncrement: Int = 3
}
class TowardZeroSource: NSObject, CounterDataSource{
    func increment(forCount count: Int) -> Int {
        return 0 == count ? 0 : (count < 0 ? 3 : -1)
    }
}
func testOptionalProtocolRequirements()  {
    let counter = Counter()
    counter.dataSource = ThreeSource()
    for _ in 0...4 {
        counter.increment()
        print(counter.count)
    }
    counter.count = -4
    counter.dataSource = TowardZeroSource()
    for _ in 0...10 {
        counter.increment()
        print(counter.count)
    }
}
//testOptionalProtocolRequirements()
//Protocol Extensions && Provide a Default Implementation
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

//Adding Constraints to Protocol Extensions
extension Collection where Element: Equatable {
    func allequal() -> Bool {
        for ele in self {
            if ele != self.first {
                return false
            }
        }
        return true
    }
}
