import Foundation
/******** Memory Satefy **********/
//Understanding Confilicting Access to Memory
/*
 Access to memeory happens in your code when you do things like set the value or pass an argument to a function. A
 confilicting access  to memeory can occuer when different parts of your code are trying to access the same location in
 memeory at the same time.
 */
//Characteristics of Memory Access
/*(1) At least one is a write access.
 (2) They access the same location in memory.
 (3) Their durations overlap. (Instantaneous or Long-term)
 A long-term access can overlap with other long-term accesses or instantaneous access. Overlapping access appears primarily in
 code that uses in-out parameters in functions and methods or mutating methods of a structure.
 */

//Confilicting Access to  In-out Parameters
/* A function has long-term accesses to all of its in-out parameters. The write access for an in-out parameters starts after
 all non-in-out parameters have been evaluated and last for the entire duration of the function call. On of this long-term access is that you can not access the original variable that was passed as in-out.
 */
func testConflictAccessToInoutParameters(){
    var stepSize = 1
    func insrement(_ number : inout Int){
        number += stepSize
    }
    insrement(&stepSize)
    insrement(&stepSize)
    insrement(&stepSize)
}
//testConflictAccessToInoutParameters()
/*
 Simultaneous accesses to 0x7fb88000f7b0, but modification requires exclusive access.
 Previous access (a modification) started at  (0x1127a207d).
 */

//Passing a single variable as argument for multiply in-out parameters of the same function produces a confilict.
func balance(_ x: inout Int, _ y: inout Int ){
    let sum = x + y
    x = sum / 2
    y = sum - x
}
var oneScore = 30
var otherScore = 42
balance(&oneScore, &otherScore)//OK
//balance(&oneScore, &oneScore)
/*
 error: SwiftPractice.playground:34:20: error: inout arguments are not allowed to alias each other
 balance(&oneScore, &oneScore)
 ^~~~~~~~~
 
 SwiftPractice.playground:34:9: note: previous aliasing argument
 balance(&oneScore, &oneScore)
 */

//Conflicting Access to self in Methods
struct Player {
    var name: String
    var health: Int
    var energy: Int
    
    static let maxHealth = 10
    mutating func restoredHealth() {
        health = Player.maxHealth
    }
}

extension Player {
    mutating func sharedHealth(with teamate: inout Player) {
        balance(&teamate.health, &health)
    }
}
var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)
oscar.sharedHealth(with: &maria)//OK
//oscar.sharedHealth(with: &oscar)
/*
 error: SwiftPractice.playground:70:26: error: inout arguments are not allowed to alias each other
 oscar.sharedHealth(with: &oscar)
 ^~~~~~
 
 SwiftPractice.playground:70:1: note: previous aliasing argument
 oscar.sharedHealth(with: &oscar)
 ^~~~~
 */

//Conficting Access to Properties
/*
 Types like structures, tuples, enumerations are made up of individual constituent values, such as the properties of a
 structure or the elements of a tuple. Because these are value types, mutatinga any piece of the value mutates the whole
 value, means read or write to the elements requires read or write access to the whole value.
 */

var playerInformation = (health: 10, energy: 30)
balance(&playerInformation.health, &playerInformation.energy)
/*
 Simultaneous accesses to 0x10eee6000, but modification requires exclusive access.
 Previous access (a modification) started at  (0x10eee7046).
 */
var  holly = Player(name: "Holly", health: 20, energy: 30)
balance(&holly.energy, &holly.health)
/*Simultaneous accesses to 0x7fef9951c1e0, but modification requires exclusive access.
 Previous access (a modification) started at  (0x1128aa07d).
 */
//Solution: change holly to a local variable instead of a global variable.
func testAccessToProperties() {
    var mary = Player(name: "mary", health: 12, energy: 14)
    balance(&mary.energy, &mary.health)
}
/*
 Overlapping Access to properties of a structure is safe in:
 (1) Accessing only stored properties of an instance, not computed properties or class properties
 (2) The structure is the value of a local variable, not a global variable
 (3) The structure is either not captured by any closures, or it is captured noly by escaped closures
 */
