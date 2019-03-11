import Foundation
struct FixedLengthRange {
    var firstValue = 0
    let length : Int
}

//For constant, provide a default value or set it during initialization
func testStoredProperties(){
    _ = FixedLengthRange(firstValue: 3, length: 3)
}

struct Point {
    var x = 0.0
    var y = 0.0
    
    mutating func moveBy(x deltaX : Double,y deltaY : Double)  {
        x += deltaX
        y += deltaY
    }
    
    mutating func moveBy2(x deltaX : Double,y deltaY : Double)  {
        self = Point(x: x + deltaX, y: y + deltaY)
    }
}
struct Size {
    var width = 0.0
    var height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    
    var centre : Point {
        get {
            let centreX = origin.x + size.width / 2.0
            let centreY = origin.y + size.height / 2.0
            return Point(x: centreX, y: centreY)
        }
        //        set(newCentre) {
        //            origin.x = newCentre.x - size.width / 2.0
        //            origin.y = newCentre.y - size.height / 2.0
        //        }
        
        set {
            origin.x = newValue.x - size.width / 2.0
            origin.y = newValue.y - size.height / 2.0
        }
    }
}
func testComputedProperties()  {
    var squre = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10.0, height: 10.0))
    let initCentre = squre.centre
    squre.centre = Point(x: 15.0, y: 15.0)
    
    print("init : centre = (\(initCentre.x),\(initCentre.y));   change : centre = (\(squre.centre.x),\(squre.centre.y))")
}

struct Cuboid {
    var width  = 0.0
    var length = 0.0
    var height = 0.0
    //read-only
    var volume : Double {
        return width * height * length
    }
}

class StepCounter {
    var totalSteps : Int = 0 {
        willSet {
            print("new value = \(newValue)")
        }
        didSet{
            print("old value = \(oldValue)")
        }
    }
}
func testPropertyObserver()  {
    let stepCounter = StepCounter()
    stepCounter.totalSteps = 200
    stepCounter.totalSteps = 360
    stepCounter.totalSteps = 896
    
}

struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel : Int = 0 {
        didSet{
            if currentLevel > AudioChannel.thresholdLevel {
                currentLevel = AudioChannel.thresholdLevel
            }
            
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
            
            print("currentLevel = \(currentLevel), maxInputLevelForAllChannels = \(AudioChannel.maxInputLevelForAllChannels)")
        }
    }
}
func testTypedProperties()  {
    var leftChannel = AudioChannel()
    var rightChannel = AudioChannel()
    
    leftChannel.currentLevel = 7
    rightChannel.currentLevel = 11
}

enum TristateSwitch : String {
    case off = "off"
    case low = "low"
    case high = "high"
    mutating func next(){
        switch self {
        case .high :
            self = .off
        case .off :
            self = .low
        case .low:
            self = .high
        }
        print("current state = \(self.rawValue)")
    }
}
/*
 modify instance's properties
 assign to self
 */
func testMutatingMethods(){
    var point = Point(x: 3.0, y: 4.0)
    point.moveBy(x: 2.0, y: 3.0)
    print("The point is now at : (\(point.x),\(point.y))")
    
    point.moveBy2(x: 1.0, y: 1.0)
    print("The point is now at : (\(point.x),\(point.y))")
    
    var ovenLight = TristateSwitch.low
    ovenLight.next()
    ovenLight.next()
}
struct LevelTracker{
    static var highestUnlockedLevel = 1
    var currentLevel = 1
    static func unlock(_ level : Int)  {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }
    static func isUnlocked(_ level : Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    
    @discardableResult
    mutating func advance(to level : Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

class Player{
    var tracker = LevelTracker()
    let playerName : String
    init(name : String) {
        playerName = name
    }
    func complete(level : Int)  {
        LevelTracker.unlock(level)
        tracker.advance(to: level)
    }
}
func testClassMethods(){
    let player = Player(name: "Tom")
    player.complete(level: 1)
    print("Highest unlocked level is : \(LevelTracker.highestUnlockedLevel)")
}

struct Martrix {
    let rows :Int
    let cloumns: Int
    var grid : [Double]
    init(rows: Int, cloumns : Int) {
        self.rows = rows
        self.cloumns = cloumns
        grid = Array(repeating: 0.0, count: rows * cloumns)
    }
    
    func indexIsValid(row : Int, cloumn : Int) -> Bool {
        return row >= 0 && row < rows && cloumn >= 0 && cloumn < cloumns
    }
    
    subscript(row : Int,cloumn: Int) -> Double {
        get {
            assert(indexIsValid(row: row, cloumn: cloumn)," Index out of range")
            return grid[(row * cloumns) + cloumn]
        }
        set {
            assert(indexIsValid(row: row, cloumn: cloumn)," Index out of range")
            grid[(row * cloumns) + cloumn] = newValue
        }
    }
}

func testScripts(){
    var martrix = Martrix(rows: 2, cloumns: 2)
    print(martrix)
    martrix[0,1] = 1.5
    martrix[1,1] = 3.2
    print(martrix)
}
func testPropertiesAndMethods() {
    //    testComputedProperties()
    //    testPropertyObserver()
    //    testTypedProperties()
    //    testMutatingMethods()
    //    testClassMethods()
    testScripts()
}


class Vehicle {
    var currentSpeed = 0.0
    var description : String {
        return "Traveling in \(currentSpeed ) miles per hour"
    }
    func makeNoise()  {
        print("vehile is making noise!")
    }
}
class Bicycle : Vehicle {
    var hasBasket = false
    override var currentSpeed: Double{
        didSet {
            print("oldSpeed = \(oldValue) miles, current speed = \(currentSpeed) miles")
        }
    }
    override func makeNoise() {
        print("bicycle is making noise!")
    }
    
    override var description: String {
        return super.description + "by bicycle!"
    }
}

func testInheritance(){
    let bicycle = Bicycle()
    bicycle.hasBasket = true
    bicycle.currentSpeed = 15.0
    print(bicycle.description)
    bicycle.makeNoise()
}

//testInheritance()

struct Celsius {
    var temperatureInCelsius : Double
    
    init(fromFahrenheit fahrenheit : Double) {
        temperatureInCelsius = ( fahrenheit - 32.0 ) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius : Double) {
        temperatureInCelsius = celsius
    }
}

func testCustomizingInitialization(){
    _ = Celsius(fromFahrenheit: 212.0)
    _ = Celsius(fromKelvin: 273.15)
    _ = Celsius(23.5)
}
class Fruit {
    var name : String
    var weight : Double
    init(name: String, weight : Double) {
        self.name = name
        self.weight = weight
    }
    
    convenience init(name : String){
        self.init(name: name, weight: 0.0)
    }
    convenience init() {
        self.init(name: "Fruit")
        self.weight = 1.0
    }
}

class Apple : Fruit {
    var color : String
    init(name : String,weight:Double,color:String){
        self.color = color
        super.init(name: name, weight: weight)
    }
    override init(name: String, weight: Double) {
        color = "defaultColor"
        super.init(name: name, weight: weight)
    }
    convenience init(name: String,color: String){
        self.init(name: name, weight: 1.0, color: color)
    }
}

struct Animal{
    let species : String
    init?(species: String) {
        if species.isEmpty { return nil}
        self.species = species
    }
}
func testFailureInitializer(){
    let animal = Animal(species: "")
    print(animal as Any)
}

enum TemperatureUnit {
    case kelvin,celsius,fahrenheit
    init?(symbol: Character){
        switch symbol {
        case "K":
            self = .kelvin
        case "C":
            self = .celsius
        case "F":
            self = .fahrenheit
        default:
            return nil
        }
    }
}

struct ChessBoard {
    var boardColors : [Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...8 {
            for j in 1...8 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    
    func squreIsBlackAt(row:Int,column:Int) -> Bool {
        return boardColors[(row * 8 ) + column]
    }
}


class Birds{
    var sing  = "sing"
    deinit {
        print("bird is deallocked")
    }
}
class Chick: Birds {
    var run = "run"
    deinit {
        print("chick is deallocked!")
    }
}

func testDeinitlizer(){
    var chick : Chick? = Chick()
    print(chick!)
    chick = nil
}


/********** Optional Chain  ************/
class Adress {
    var buildingName : String?
    var buildingNumber : String?
    var street : String?
    
    func buildingIndentifier() -> String? {
        if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) \(street)"
        } else if let buildingName = buildingName {
            return buildingName
        } else {
            return nil
        }
    }
}

class Room {
    let name : String
    init(name : String) {
        self.name = name
    }
}

class Residence {
    var rooms = [Room]()
    var numberOfRooms : Int {
        return rooms.count
    }
    
    subscript(i : Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    
    func printNumberOfRooms()  {
        print("The number of rooms is \(numberOfRooms)")
    }
    
    var address : Adress?
}

class Person {
    var residence : Residence?
}

func createAddress() -> Adress {
    let address = Adress()
    address.buildingName = "Acacia Road"
    address.buildingNumber = "29"
    
    return address
}
func testOptionalChain()  {
    let john = Person()
    
    let johnHouse = Residence()
    johnHouse.rooms.append(Room(name: "LivingRoom"))
    johnHouse.rooms.append(Room(name: "Kitchen"))
    john.residence = johnHouse
    
    john.residence?.address = createAddress()
    
    if let roomCount = john.residence?.numberOfRooms {
        print("John's residence has \(roomCount) room(s)")
    } else {
        print("Unable to retrive the number of rooms!")
    }
    
    
    
    if john.residence?.printNumberOfRooms() != nil {
        print("It was possible to print the number of the rooms")
    } else {
        print("It was not possible to print the number of the rooms")
    }
    
    if let firstRoomName = john.residence?[0].name {
        print("The first room name is \(firstRoomName)")
    } else {
        print("Unable to retrive the number of room name")
    }
    
    if let buildingIndentifier = john.residence?.address?.buildingIndentifier() {
        print("John's building indentifier is \(buildingIndentifier)")
    } else {
        print("Unable to retrive John's building indentifier")
    }
}

//testOptionalChain()
/********* Error Handling *********/
enum VendingMachineError : Error {
    case invalidSelection
    case insufficientFounds(coinsNeeded: Int)
    case outOfStock
}

struct Item {
    var price : Int
    var count : Int
}

class VendingMachine{
    var inventory = [
        "candy Bar" : Item(price: 12, count: 7),
        "Chips" : Item(price: 10, count: 4),
        "Pretzels" : Item(price: 7, count: 11)
    ]
    
    var coinsDeposited = 0
    
    func vend(itemName name : String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFounds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print("Dispresenting \(name)")
    }
}

/*********** Type Casting ******/
class MediumItem {
    var name : String
    init(name : String) {
        self.name = name
    }
}

class Movie : MediumItem {
    var director : String
    init(name : String, director : String) {
        self.director = director
        super.init(name: name)
    }
}

class Song : MediumItem {
    var artist : String
    init(name : String, artist : String) {
        self.artist = artist
        super.init(name: name)
    }
}

func testTypeCasting(){
    let library = [
        Movie(name: "Casablanca", director: "Michael Curtiz"),
        Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
        Movie(name: "Citizen Kane", director: "Orson Welles"),
        Song(name: "The One And Only", artist: "Chesney Hawkes"),
        Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
    ]
    
    var movieCount = 0
    var songCount = 0
    
    for medium in library {
        if medium is Movie {
            movieCount += 1
        } else if medium is Song {
            songCount += 1
        }
    }
    print("Medium library contains \(movieCount) movies and \(songCount) songs")
    
    
    for item in library {
        if let movie = item as? Movie {
            print("Movie : \(movie.name) , director : \(movie.director)")
        } else if let song = item as? Song {
            print("Song : \(song.name) , artist : \(song.artist)")
        }
    }
}
