# iOS多线程

## Thread

### 线程的创建

两种创建线程的方法 。常用属性：

1. name
2. Thread.sleep(forTimeInterval: 5)
3. Thead.current
4. Thread.main

```swift
let threadA = Thread(target: self, selector: #selector(ViewController.run), object: nil)
threadA.start()
let threadB = Thread(block: <#T##() -> Void#>)
threadA.start()

Thread.detachNewThreadSelector(#selector(self.run), toTarget: self, with: nil)
```

```swift
class ThreadTest {
    @objc func run() {
        for i in 0...10 {
            print("----------- curent thread = \(Thread.current.name!)   number = \(i) ----------")
        }
    }
    public func printNumbers() {
        Thread.main.name = "Main"
        for i in 1...5 {
            let thread = Thread(target: self, selector: #selector(self.run), object: nil)
            thread.name = "thread\(i)"
            print("=========== curent thread = \(Thread.current.name!)   child thread = \(thread.name!) ==========")
            thread.start()
        }
    }
}

ThreadTest().printNumbers()
```

运行结果 ：

```txt
=========== curent thread = Main   child thread = thread1 ==========
=========== curent thread = Main   child thread = thread2 ==========
----------- curent thread = thread1   number = 0 ----------
----------- curent thread = thread1   number = 1 ----------
----------- curent thread = thread1   number = 2 ----------
----------- curent thread = thread1   number = 3 ----------
----------- curent thread = thread2   number = 0 ----------
----------- curent thread = thread1   number = 4 ----------
----------- curent thread = thread1   number = 5 ----------
----------- curent thread = thread1   number = 6 ----------
=========== curent thread = Main   child thread = thread3 ==========
----------- curent thread = thread2   number = 1 ----------
----------- curent thread = thread2   number = 2 ----------
----------- curent thread = thread1   number = 7 ----------
----------- curent thread = thread2   number = 3 ----------
----------- curent thread = thread1   number = 8 ----------
=========== curent thread = Main   child thread = thread4 ==========
----------- curent thread = thread1   number = 9 ----------
----------- curent thread = thread3   number = 0 ----------
----------- curent thread = thread2   number = 4 ----------
----------- curent thread = thread2   number = 5 ----------
----------- curent thread = thread4   number = 0 ----------
----------- curent thread = thread2   number = 6 ----------
----------- curent thread = thread1   number = 10 ----------
----------- curent thread = thread4   number = 1 ----------
----------- curent thread = thread3   number = 1 ----------
----------- curent thread = thread2   number = 7 ----------
----------- curent thread = thread3   number = 2 ----------
=========== curent thread = Main   child thread = thread5 ==========
----------- curent thread = thread2   number = 8 ----------
----------- curent thread = thread2   number = 9 ----------
----------- curent thread = thread3   number = 3 ----------
----------- curent thread = thread2   number = 10 ----------
----------- curent thread = thread4   number = 2 ----------
----------- curent thread = thread3   number = 4 ----------
----------- curent thread = thread4   number = 3 ----------
----------- curent thread = thread3   number = 5 ----------
----------- curent thread = thread4   number = 4 ----------
----------- curent thread = thread5   number = 0 ----------
----------- curent thread = thread3   number = 6 ----------
----------- curent thread = thread4   number = 5 ----------
----------- curent thread = thread3   number = 7 ----------
----------- curent thread = thread4   number = 6 ----------
----------- curent thread = thread5   number = 1 ----------
----------- curent thread = thread3   number = 8 ----------
----------- curent thread = thread4   number = 7 ----------
----------- curent thread = thread5   number = 2 ----------
----------- curent thread = thread4   number = 8 ----------
----------- curent thread = thread5   number = 3 ----------
----------- curent thread = thread3   number = 9 ----------
----------- curent thread = thread4   number = 9 ----------
----------- curent thread = thread5   number = 4 ----------
----------- curent thread = thread4   number = 10 ----------
----------- curent thread = thread3   number = 10 ----------
----------- curent thread = thread5   number = 5 ----------
----------- curent thread = thread5   number = 6 ----------
----------- curent thread = thread5   number = 7 ----------
----------- curent thread = thread5   number = 8 ----------
----------- curent thread = thread5   number = 9 ----------
----------- curent thread = thread5   number = 10 ----------
```

### 线程的退出

退出条件：

1. 代码块执行完毕，正常退出
2. 执行代码块出错，异常退出
3. 调用exit()方法

主线程没有办法直接退出子线程，可以在主线程中给子线程发送信号（willExitThread?.cancel()），子线程代码块中判断 Thread.current.isCancelled 属性，来决定是否退出线程。

```swift
class ThreadTest {
    private var willExitThread: Thread?
    @objc private func exitThreadRun()  {
        for i in 0...100 {
            if Thread.current.isCancelled {
                Thread.exit()
            }
            print("current thread name = \(Thread.current.name!)  ----> number = \(i)")
            Thread.sleep(forTimeInterval: 0.5)
        }
    }
    public func exitThread() {
        willExitThread = Thread.init(target: self, selector: #selector(self.exitThreadRun), object: nil)
        willExitThread?.name = "WillExitThread"
        willExitThread?.start()
        Thread.sleep(forTimeInterval: 5)
        willExitThread?.cancel()
    }
}

ThreadTest().exitThread()
```

```txt
current thread name = WillExitThread  ----> number = 0
current thread name = WillExitThread  ----> number = 1
current thread name = WillExitThread  ----> number = 2
current thread name = WillExitThread  ----> number = 3
current thread name = WillExitThread  ----> number = 4
current thread name = WillExitThread  ----> number = 5
current thread name = WillExitThread  ----> number = 6
current thread name = WillExitThread  ----> number = 7
current thread name = WillExitThread  ----> number = 8
current thread name = WillExitThread  ----> number = 9
```

### 线程的优先级

1. 默认优先级0.5
2. 设置优先级为0---1.0之间的数字：threadA.threadPriority = 0.01

```swift
class ThreadTest {
    @objc func run() {
        for i in 0...10 {
            print("----------- curent thread = \(Thread.current.name!)   number = \(i) ----------")
        }
    }
    public func threadPriority() {
        print("UI thread priority = \(Thread.current.threadPriority)")
        let threadA = Thread(target: self, selector: #selector(self.run), object: nil)
        threadA.name = "threadA"
        print("ThreadA priority = \(Thread.current.threadPriority)")
        threadA.threadPriority = 0.01

        let threadB = Thread(target: self, selector: #selector(self.run), object: nil)
        threadB.name = "threadB"
        print("ThreadB priority = \(Thread.current.threadPriority)")
        threadB.threadPriority = 1.0

        threadA.start()
        threadB.start()
    }
}

ThreadTest().threadPriority()
```

```txt
UI thread priority = 0.5
ThreadA priority = 0.5
ThreadB priority = 0.5
----------- curent thread = threadB   number = 0 ----------
----------- curent thread = threadB   number = 1 ----------
----------- curent thread = threadB   number = 2 ----------
----------- curent thread = threadA   number = 0 ----------
----------- curent thread = threadB   number = 3 ----------
----------- curent thread = threadB   number = 4 ----------
----------- curent thread = threadB   number = 5 ----------
----------- curent thread = threadA   number = 1 ----------
----------- curent thread = threadB   number = 6 ----------
----------- curent thread = threadB   number = 7 ----------
----------- curent thread = threadB   number = 8 ----------
----------- curent thread = threadA   number = 2 ----------
----------- curent thread = threadB   number = 9 ----------
----------- curent thread = threadB   number = 10 ----------
----------- curent thread = threadA   number = 3 ----------
----------- curent thread = threadA   number = 4 ----------
----------- curent thread = threadA   number = 5 ----------
----------- curent thread = threadA   number = 6 ----------
----------- curent thread = threadA   number = 7 ----------
----------- curent thread = threadA   number = 8 ----------
----------- curent thread = threadA   number = 9 ----------
----------- curent thread = threadA   number = 10 ----------
```

### 线程同步

线程安全类的特点：

1. 类的实例可以被多个 线程安全的访问
2. 线程调用该对象任何方法之后获得正确的结果
3. 线程调用对象的任何方法，对象保持合理状态

不可变类总是线程安全的，可变类则需要提供额外的方法保证其线程安全：

1. 对会改变共享资源的方法进行线程同步
2. 区分运行环境，提供线程安全版本和线程不安全版本。

```swift
   objc_sync_enter(self)
   objc_sync_exit(self)
   let lock = NSLock()
   lock.lock()
   lock.unlock()
```

```swift
class Account {
    var accountNumber: String
    var balance: Double
    var lock: NSLock!
    init(_ accountNumber: String, _ balance : Double) {
        self.accountNumber = accountNumber
        self.balance = balance
        self.lock = NSLock()
    }
    func draw(_ drawAmmount : Double)  {
        //            objc_sync_enter(self)
        //            lock.lock()
        if self.balance > drawAmmount {
            print("Thread name = \(Thread.current.name ?? "" ) sucess to draw : \(drawAmmount)")
            Thread.sleep(forTimeInterval: 0.1)
            self.balance -= drawAmmount
            print("Thread name = \(Thread.current.name ?? "" )  balance = \(self.balance)")
        } else {
            print("Thread name = \(Thread.current.name ?? "" ) failed to draw because of  insufficient founds")
        }
        //        lock.unlock()
        //        objc_sync_exit(self)
    }
}

class ThreadTest {
    private var account = Account("123456", 1000)
    public func draw()  {
        let thread1 = Thread(target: self, selector: #selector(self.drawMoneyFromAccount(money:)), object: 800.0)
        thread1.name = "thread1"
        let thread2 = Thread(target: self, selector: #selector(self.drawMoneyFromAccount(money:)), object: 800.0)
        thread2.name = "threa2"
        thread1.start()
        thread2.start()
    }

    @objc private func drawMoneyFromAccount(money : NSNumber)  {
        account.draw(money.doubleValue)
    }
}
```

```txt
Thread name = thread2 sucess to draw : 800.0
Thread name = thread1 sucess to draw : 800.0
Thread name = thread2  balance = 200.0
Thread name = thread1  balance = -600.0
```

```txt
Thread name = thread1 sucess to draw : 800.0
Thread name = thread1  balance = 200.0
Thread name = thread2 failed to draw because of  insufficient founds
```

### 线程间通信

iOS提供NSCondition类来提供控制线程通信。其遵守NSLocking协议也可以用来同步。

1. wait()方法：当前线程等待，直到被唤醒
2. singal()方法：任意唤醒一个在等待的线程
3. broadcast()方法：唤醒所有等待线程

```swift
class Account {
    var accountNumber: String
    var balance: Double
    var lock: NSLock!
    init(_ accountNumber: String, _ balance : Double) {
        self.accountNumber = accountNumber
        self.balance = balance
        self.lock = NSLock()
    }
    func draw(_ drawAmmount : Double)  {
        //            objc_sync_enter(self)
                    lock.lock()
        if self.balance > drawAmmount {
            print("Thread name = \(Thread.current.name ?? "" ) sucess to draw : \(drawAmmount)")
            Thread.sleep(forTimeInterval: 0.1)
            self.balance -= drawAmmount
            print("Thread name = \(Thread.current.name ?? "" )  balance = \(self.balance)")
        } else {
            print("Thread name = \(Thread.current.name ?? "" ) failed to draw because of  insufficient founds")
        }
                lock.unlock()
        //        objc_sync_exit(self)
    }
}

class SavingAccount : Account {
    var condition : NSCondition!
    var flag : Bool = true
    override init(_ accountNumber: String, _ balance: Double) {
        self.condition = NSCondition()
        super.init(accountNumber, balance)
    }
    override func draw(_ drawAmmount: Double) {
        condition.lock()
        if !flag {
            condition.wait()
        } else {
            self.balance -= drawAmmount
            print("Thread name = \(Thread.current.name ?? "" ) sucess to draw : \(drawAmmount)  balance = \(self.balance)")
            flag = false
            condition.broadcast()
        }
        condition.unlock()
    }

    func deposit(money : Double)  {
        condition.lock()
        if flag {
            condition.wait()
        } else {
            self.balance += money
            print("Thread name = \(Thread.current.name ?? "" ) sucess to deposit : \(money) balance = \(self.balance)")
            flag = true
            condition.broadcast()
        }
        condition.unlock()
    }
}

class ThreadTest {
    let savingAccount = SavingAccount("123456", 1000.0)
    public func depositThenDraw() {
        for i in 0..<3 {
            let thread = Thread(target: self, selector: #selector(self.depositMoneyMethod(money:)), object: 800)
            thread.name = "Deposit thread\(i)"
            thread.start()
        }
        let thread = Thread(target: self, selector: #selector(self.drawMoneyMethod(money:)), object: 800)
        thread.name = "draw thread"
        thread.start()
    }
    @objc private  func depositMoneyMethod(money: NSNumber)  {
        for _ in 0..<10 {
            savingAccount.deposit(money: money.doubleValue)
        }
    }
    @objc private func drawMoneyMethod(money: NSNumber)  {
        for _ in 0..<30 {
            savingAccount.draw(money.doubleValue)
        }
    }
}

ThreadTest().depositThenDraw()
```

```txt
Thread name = draw thread sucess to draw : 800.0  balance = 200.0
Thread name = Deposit thread0 sucess to deposit : 800.0 balance = 1000.0
Thread name = draw thread sucess to draw : 800.0  balance = 200.0
Thread name = Deposit thread1 sucess to deposit : 800.0 balance = 1000.0
Thread name = draw thread sucess to draw : 800.0  balance = 200.0
Thread name = Deposit thread1 sucess to deposit : 800.0 balance = 1000.0
Thread name = draw thread sucess to draw : 800.0  balance = 200.0
Thread name = Deposit thread1 sucess to deposit : 800.0 balance = 1000.0
Thread name = draw thread sucess to draw : 800.0  balance = 200.0
Thread name = Deposit thread1 sucess to deposit : 800.0 balance = 1000.0
Thread name = draw thread sucess to draw : 800.0  balance = 200.0
Thread name = Deposit thread1 sucess to deposit : 800.0 balance = 1000.0
Thread name = draw thread sucess to draw : 800.0  balance = 200.0
Thread name = Deposit thread1 sucess to deposit : 800.0 balance = 1000.0
Thread name = draw thread sucess to draw : 800.0  balance = 200.0
Thread name = Deposit thread1 sucess to deposit : 800.0 balance = 1000.0
Thread name = draw thread sucess to draw : 800.0  balance = 200.0
Thread name = Deposit thread0 sucess to deposit : 800.0 balance = 1000.0
Thread name = draw thread sucess to draw : 800.0  balance = 200.0
Thread name = Deposit thread2 sucess to deposit : 800.0 balance = 1000.0
Thread name = draw thread sucess to draw : 800.0  balance = 200.0
Thread name = Deposit thread0 sucess to deposit : 800.0 balance = 1000.0
Thread name = draw thread sucess to draw : 800.0  balance = 200.0
```

## NSOperation

可以将Operation理解为任务操作，OperationQueue理解为操作队列。

```swift
open class Operation : NSObject {


    open func start()

    open func main()


    open var isCancelled: Bool { get }

    open func cancel()


    open var isExecuting: Bool { get }

    open var isFinished: Bool { get }

    open var isConcurrent: Bool { get }

    @available(iOS 7.0, *)
    open var isAsynchronous: Bool { get }

    open var isReady: Bool { get }


    open func addDependency(_ op: Operation)

    open func removeDependency(_ op: Operation)


    open var dependencies: [Operation] { get }


    open var queuePriority: Operation.QueuePriority


    @available(iOS 4.0, *)
    open var completionBlock: (() -> Void)?


    @available(iOS 4.0, *)
    open func waitUntilFinished()


    @available(iOS, introduced: 4.0, deprecated: 8.0, message: "Not supported")
    open var threadPriority: Double


    @available(iOS 8.0, *)
    open var qualityOfService: QualityOfService


    @available(iOS 8.0, *)
    open var name: String?
}
extension Operation {

    public enum QueuePriority : Int {

        case veryLow

        case low

        case normal

        case high

        case veryHigh
    }
}

```

Operation是基于OC封装的一套管理与执行线程操作的类。Operation是抽象类，BlockOperation是其子类，我们也可以继承Operation封装自己的操作类。每个单独的operation有四种状态，Ready、Executing、Cancelled、Finished.

```swift
class ImageeFilterOperation: Operation {
    var inputImage: UIImage?
    var outputImage: UIImage?
    override func main() {
        outputImage = filter(image: inputImage)
    }
}
```

### blockOperation

BlockOperation是Operation的子类，可以异步执行多个代码块，当所有Block都完成，操作才算完成 。

```swift
class OperationTest {
    public func blockOperationDemo() {
        let operation =  BlockOperation {
            for i in 0...10 {
                print("Thread  = \(Thread.current) i = \(i)")
            }
        }
        operation.addExecutionBlock {
            for j in 0...10 {
                print("Thread  = \(Thread.current) j = \(j)")
            }
        }
        let operation2 = BlockOperation {
            for k in 0...10 {
                print("Thread  = \(Thread.current) k = \(k)")
            }
        }
        operation.start()
        operation2.start()
    }
}

OperationTest().blockOperationDemo()
```

```txt
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} i = 0
Thread  = <NSThread: 0x6000002329c0>{number = 3, name = (null)} j = 0
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} i = 1
Thread  = <NSThread: 0x6000002329c0>{number = 3, name = (null)} j = 1
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} i = 2
Thread  = <NSThread: 0x6000002329c0>{number = 3, name = (null)} j = 2
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} i = 3
Thread  = <NSThread: 0x6000002329c0>{number = 3, name = (null)} j = 3
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} i = 4
Thread  = <NSThread: 0x6000002329c0>{number = 3, name = (null)} j = 4
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} i = 5
Thread  = <NSThread: 0x6000002329c0>{number = 3, name = (null)} j = 5
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} i = 6
Thread  = <NSThread: 0x6000002329c0>{number = 3, name = (null)} j = 6
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} i = 7
Thread  = <NSThread: 0x6000002329c0>{number = 3, name = (null)} j = 7
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} i = 8
Thread  = <NSThread: 0x6000002329c0>{number = 3, name = (null)} j = 8
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} i = 9
Thread  = <NSThread: 0x6000002329c0>{number = 3, name = (null)} j = 9
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} i = 10
Thread  = <NSThread: 0x6000002329c0>{number = 3, name = (null)} j = 10
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} k = 0
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} k = 1
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} k = 2
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} k = 3
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} k = 4
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} k = 5
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} k = 6
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} k = 7
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} k = 8
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} k = 9
Thread  = <NSThread: 0x600000221640>{number = 1, name = main} k = 10
```

明显可以看出：两个循环在不同的线程中执行。使用BlockOperation的最大好处：不需要显式的操作Thread来管理线程，BlockOperation会根据加入的Block来分配线程，使之异步执行。但是两个Operation之间却是都是在主线程中按照顺序执行的。

### 操作依赖关系

操作之间通常存在这一些依赖关系。比如用网络请求到的数据来渲染界面，界面的渲染一定会在请求完成之后执行 。

```swift
class OperationTest {
    public func operationDependenciesDemo() {
        let operation1 =  BlockOperation {
            for i in 0...10 {
                print("Thread = \(Thread.current) i = \(i)")
            }
        }
        let operation2 = BlockOperation {
            for i in 11...20 {
                print("Thread  = \(Thread.current) i = \(i)")
            }
        }

        let queue = OperationQueue.init()
        //        operation2.addDependency(operation1)
        //        queue.maxConcurrentOperationCount = 1
        queue.addOperation(operation1)
        queue.addOperation(operation2)
    }
}

OperationTest().operationDependenciesDemo()
```

```txt
Thread = <NSThread: 0x600000a20440>{number = 4, name = (null)} i = 0
Thread  = <NSThread: 0x600000a3d500>{number = 3, name = (null)} i = 11
Thread  = <NSThread: 0x600000a3d500>{number = 3, name = (null)} i = 12
Thread = <NSThread: 0x600000a20440>{number = 4, name = (null)} i = 1
Thread  = <NSThread: 0x600000a3d500>{number = 3, name = (null)} i = 13
Thread = <NSThread: 0x600000a20440>{number = 4, name = (null)} i = 2
Thread  = <NSThread: 0x600000a3d500>{number = 3, name = (null)} i = 14
Thread = <NSThread: 0x600000a20440>{number = 4, name = (null)} i = 3
Thread  = <NSThread: 0x600000a3d500>{number = 3, name = (null)} i = 15
Thread = <NSThread: 0x600000a20440>{number = 4, name = (null)} i = 4
Thread  = <NSThread: 0x600000a3d500>{number = 3, name = (null)} i = 16
Thread = <NSThread: 0x600000a20440>{number = 4, name = (null)} i = 5
Thread  = <NSThread: 0x600000a3d500>{number = 3, name = (null)} i = 17
Thread  = <NSThread: 0x600000a3d500>{number = 3, name = (null)} i = 18
Thread = <NSThread: 0x600000a20440>{number = 4, name = (null)} i = 6
Thread  = <NSThread: 0x600000a3d500>{number = 3, name = (null)} i = 19
Thread = <NSThread: 0x600000a20440>{number = 4, name = (null)} i = 7
Thread  = <NSThread: 0x600000a3d500>{number = 3, name = (null)} i = 20
Thread = <NSThread: 0x600000a20440>{number = 4, name = (null)} i = 8
Thread = <NSThread: 0x600000a20440>{number = 4, name = (null)} i = 9
Thread = <NSThread: 0x600000a20440>{number = 4, name = (null)} i = 10
```

运行结果如上，因为OperationQueue默认并行执行Operation.如果我们想按顺序打印0--20，解决方法是添加依赖：operation2.addDependency(operation1)，这样在operation1完成之后才会执行operation2.

### OperationQueue  

负责安排和运行多个Operation，单并不局限于FIFO队列操作,他提供多个接口实现暂停、继续、终止、优先级、依赖等复杂操作。默认并行执行已经加入的Operation,但是可以通过：

```swift
    queue.maxConcurrentOperationCount = 1
```

来修改其为串行队列。

## GCD（Grand Central Dispatch）

GCD是基于c语言的多线程开发框架，相比Operation和Thread，GCD更加高效，并且线程由系统管理，会自动启用多核运算。GCD是官方推荐的多线程解决方案。

### 调度队列

GCD有一个重要概念调度队列。我们对线程的操作实际上由调度队列完成，我们只需要把要执行的任务添加到合适的调度队列中即可。

1. 主队列：任务在主线程中执行，会阻塞线程，是一个串行队列。
2. 全局并行队列。队列中的任务按照先进先出顺序执行：串行队列则一个任务结束才会开启另一个任务，并行队列则任务开启顺序和任务添加顺序一致。系统自动创建4个全局共享并行队列。
3. 自定义队列：包括串行的和并行的。

```swift
let mainQueue = DispatchQueue.main
print(mainQueue.debugDescription)
var qos: [DispatchQoS.QoSClass] = [.background,.userInitiated,.unspecified,.userInteractive,.default,.unspecified]
for i in 0..<qos.count {
    let queue = DispatchQueue.global(qos: qos[i])
    print(queue.debugDescription)
}
let myQueue = DispatchQueue(label: "self-define queue", qos: DispatchQoS.default, attributes: [DispatchQueue.Attributes.concurrent], autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
print(myQueue.debugDescription)
```

```txt
<OS_dispatch_queue_main: com.apple.main-thread[0x111033a80] = { xref = -2147483648, ref = -2147483648, sref = 1, target = com.apple.root.default-qos.overcommit[0x111033f00], width = 0x1, state = 0x001ffe9d00000300, dirty, max qos 5, in-flight = 0, thread = 0x303 }>
<OS_dispatch_queue_global: com.apple.root.background-qos[0x111033c80] = { xref = -2147483648, ref = -2147483648, sref = 1, target = [0x0], width = 0xfff, state = 0x0060000000000000, in-barrier}>
<OS_dispatch_queue_global: com.apple.root.user-initiated-qos[0x111033f80] = { xref = -2147483648, ref = -2147483648, sref = 1, target = [0x0], width = 0xfff, state = 0x0060000000000000, in-barrier}>
<OS_dispatch_queue_global: com.apple.root.default-qos[0x111033e80] = { xref = -2147483648, ref = -2147483648, sref = 1, target = [0x0], width = 0xfff, state = 0x0060000000000000, in-barrier}>
<OS_dispatch_queue_global: com.apple.root.user-interactive-qos[0x111034080] = { xref = -2147483648, ref = -2147483648, sref = 1, target = [0x0], width = 0xfff, state = 0x0060000000000000, in-barrier}>
<OS_dispatch_queue_global: com.apple.root.default-qos[0x111033e80] = { xref = -2147483648, ref = -2147483648, sref = 1, target = [0x0], width = 0xfff, state = 0x0060000000000000, in-barrier}>
<OS_dispatch_queue_global: com.apple.root.default-qos[0x111033e80] = { xref = -2147483648, ref = -2147483648, sref = 1, target = [0x0], width = 0xfff, state = 0x0060000000000000, in-barrier}>
<OS_dispatch_queue_concurrent: self-define queue[0x600000691280] = { xref = 2, ref = 1, sref = 1, target = com.apple.root.default-qos[0x111033e80], width = 0xffe, state = 0x0000041000000000, in-flight = 0}>
```

### 使用队列运行任务

开发者自定义队列的是时候用attributes参数控制要创建串行队列还是并行队列。

```swift
class DispatchQueueTest {
    public func dispatchQueueDemo() {
//        let  serialQueue = DispatchQueue.init(label: "serial", qos: DispatchQoS.default, attributes: [], autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
//        serialQueue.async {
//            for i in 1...5 {
//                print("\(Thread.current) i = \(i)")
//            }
//        }
//        serialQueue.async {
//            for i in 1...5 {
//                print("\(Thread.current) i = \(i)")
//            }
//        }
        let  concurrentQueue = DispatchQueue.init(label: "concurrent", qos: DispatchQoS.default, attributes: [.concurrent], autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        concurrentQueue.async {
            for i in 1...5 {
                print("\(Thread.current) i = \(i)")
            }
        }
        concurrentQueue.async {
            for i in 1...5 {
                print("\(Thread.current) i = \(i)")
            }
        }
    }
}

DispatchQueueTest().dispatchQueueDemo()
```

并行队列打印结果：

```txt
<NSThread: 0x6000028bfa00>{number = 4, name = (null)} i = 1
<NSThread: 0x6000028bfa40>{number = 5, name = (null)} i = 1
<NSThread: 0x6000028bfa00>{number = 4, name = (null)} i = 2
<NSThread: 0x6000028bfa40>{number = 5, name = (null)} i = 2
<NSThread: 0x6000028bfa00>{number = 4, name = (null)} i = 3
<NSThread: 0x6000028bfa40>{number = 5, name = (null)} i = 3
<NSThread: 0x6000028bfa00>{number = 4, name = (null)} i = 4
<NSThread: 0x6000028bfa40>{number = 5, name = (null)} i = 4
<NSThread: 0x6000028bfa40>{number = 5, name = (null)} i = 5
<NSThread: 0x6000028bfa00>{number = 4, name = (null)} i = 5
```

串行队列打印结果如下，并且只有一个线程工作。

```txt
<NSThread: 0x6000036d09c0>{number = 3, name = (null)} i = 1
<NSThread: 0x6000036d09c0>{number = 3, name = (null)} i = 2
<NSThread: 0x6000036d09c0>{number = 3, name = (null)} i = 3
<NSThread: 0x6000036d09c0>{number = 3, name = (null)} i = 4
<NSThread: 0x6000036d09c0>{number = 3, name = (null)} i = 5
<NSThread: 0x6000036d09c0>{number = 3, name = (null)} i = 1
<NSThread: 0x6000036d09c0>{number = 3, name = (null)} i = 2
<NSThread: 0x6000036d09c0>{number = 3, name = (null)} i = 3
<NSThread: 0x6000036d09c0>{number = 3, name = (null)} i = 4
<NSThread: 0x6000036d09c0>{number = 3, name = (null)} i = 5
```

### Sync/Async

Sync: 当前任务加入到队列当中，等到任务完成，线程返回继续运行，即会阻塞线程。
Async:把任务加入队列，立即返回，无须等任务执行完成。即不会阻塞线程 。
串行队列和并行队列，都可以执行同步任务和异步任务。

```swift
class DispatchQueueTest {
    public func serialQueueAsyncTasks() {
        let  serialQueue = DispatchQueue.init(label: "serial", qos: DispatchQoS.default, attributes: [], autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        print("SerialQueue------>SyncTasks")
        serialQueue.sync {
            for i in 1...5 {
                print("\(Thread.current) i = \(i)")
            }        }
        print("-------- \(Thread.current) ----------")
        serialQueue.sync {
            for i in 6...10 {
                print("\(Thread.current) i = \(i)")
            }
        }
        print("-------- \(Thread.current) ----------")
        print("SerialQueue------>AsyncTasks")
        serialQueue.async {
            for i in 1...5 {
                print("\(Thread.current) i = \(i)")
            }
        }
        print("-------- \(Thread.current) ----------")
        serialQueue.async {
            for i in 6...10 {
                print("\(Thread.current) i = \(i)")
            }
        }
        print("-------- \(Thread.current) ----------")
    }
}
```

```txt
SerialQueue------>SyncTasks
<NSThread: 0x6000001dd5c0>{number = 1, name = main} i = 1
<NSThread: 0x6000001dd5c0>{number = 1, name = main} i = 2
<NSThread: 0x6000001dd5c0>{number = 1, name = main} i = 3
<NSThread: 0x6000001dd5c0>{number = 1, name = main} i = 4
<NSThread: 0x6000001dd5c0>{number = 1, name = main} i = 5
-------- <NSThread: 0x6000001dd5c0>{number = 1, name = main} ----------
<NSThread: 0x6000001dd5c0>{number = 1, name = main} i = 6
<NSThread: 0x6000001dd5c0>{number = 1, name = main} i = 7
<NSThread: 0x6000001dd5c0>{number = 1, name = main} i = 8
<NSThread: 0x6000001dd5c0>{number = 1, name = main} i = 9
<NSThread: 0x6000001dd5c0>{number = 1, name = main} i = 10
-------- <NSThread: 0x6000001dd5c0>{number = 1, name = main} ----------
SerialQueue------>AsyncTasks
-------- <NSThread: 0x6000001dd5c0>{number = 1, name = main} ----------
<NSThread: 0x6000001f4180>{number = 3, name = (null)} i = 1
-------- <NSThread: 0x6000001dd5c0>{number = 1, name = main} ----------
<NSThread: 0x6000001f4180>{number = 3, name = (null)} i = 2
<NSThread: 0x6000001f4180>{number = 3, name = (null)} i = 3
<NSThread: 0x6000001f4180>{number = 3, name = (null)} i = 4
<NSThread: 0x6000001f4180>{number = 3, name = (null)} i = 5
<NSThread: 0x6000001f4180>{number = 3, name = (null)} i = 6
<NSThread: 0x6000001f4180>{number = 3, name = (null)} i = 7
<NSThread: 0x6000001f4180>{number = 3, name = (null)} i = 8
<NSThread: 0x6000001f4180>{number = 3, name = (null)} i = 9
<NSThread: 0x6000001f4180>{number = 3, name = (null)} i = 10
```

```swift
class DispatchQueueTest {
    public func concurrentQueueAsyncTasks() {
        let  concurrentQueue = DispatchQueue.init(label: "concurrent", qos: DispatchQoS.default, attributes:[.concurrent], autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        print("concurrentQueue------>SyncTasks")
        concurrentQueue.sync {
            for i in 1...5 {
                print("\(Thread.current) i = \(i)")
            }        }
        print("-------- \(Thread.current) ----------")
        concurrentQueue.sync {
            for i in 6...10 {
                print("\(Thread.current) i = \(i)")
            }
        }
        print("-------- \(Thread.current) ----------")
        print("concurrentQueue------>AsyncTasks")
        concurrentQueue.async {
            for i in 1...5 {
                print("\(Thread.current) i = \(i)")
            }
        }
        print("-------- \(Thread.current) ----------")
        concurrentQueue.async {
            for i in 6...10 {
                print("\(Thread.current) i = \(i)")
            }
        }
        print("-------- \(Thread.current) ----------")
    }
}
```

```txt
concurrentQueue------>SyncTasks
<NSThread: 0x60000119e8c0>{number = 1, name = main} i = 1
<NSThread: 0x60000119e8c0>{number = 1, name = main} i = 2
<NSThread: 0x60000119e8c0>{number = 1, name = main} i = 3
<NSThread: 0x60000119e8c0>{number = 1, name = main} i = 4
<NSThread: 0x60000119e8c0>{number = 1, name = main} i = 5
-------- <NSThread: 0x60000119e8c0>{number = 1, name = main} ----------
<NSThread: 0x60000119e8c0>{number = 1, name = main} i = 6
<NSThread: 0x60000119e8c0>{number = 1, name = main} i = 7
<NSThread: 0x60000119e8c0>{number = 1, name = main} i = 8
<NSThread: 0x60000119e8c0>{number = 1, name = main} i = 9
<NSThread: 0x60000119e8c0>{number = 1, name = main} i = 10
-------- <NSThread: 0x60000119e8c0>{number = 1, name = main} ----------
concurrentQueue------>AsyncTasks
-------- <NSThread: 0x60000119e8c0>{number = 1, name = main} ----------
<NSThread: 0x6000011b10c0>{number = 3, name = (null)} i = 1
-------- <NSThread: 0x60000119e8c0>{number = 1, name = main} ----------
<NSThread: 0x600001188040>{number = 4, name = (null)} i = 6
<NSThread: 0x6000011b10c0>{number = 3, name = (null)} i = 2
<NSThread: 0x600001188040>{number = 4, name = (null)} i = 7
<NSThread: 0x6000011b10c0>{number = 3, name = (null)} i = 3
<NSThread: 0x6000011b10c0>{number = 3, name = (null)} i = 4
<NSThread: 0x600001188040>{number = 4, name = (null)} i = 8
<NSThread: 0x6000011b10c0>{number = 3, name = (null)} i = 5
<NSThread: 0x600001188040>{number = 4, name = (null)} i = 9
<NSThread: 0x600001188040>{number = 4, name = (null)} i = 10
```

根据上述结果：由于同步任务会阻塞线程，所以系统不会新建线程来执行开发者所添加的任务，例子中不管串行队列还是并行队列，都是number = 1的线程。通俗地讲，反正要等待，闲着也是闲着，不如活都让你干了。异步任务不会阻塞线程，所以添加完任务之后都会快速返回number = 1的线程。这个时候体现出了串行队列和并行队列的区别：串行队列知会新建一个线程（number = 3）来执行开发者添加的任务，而并行队列的话，系统会根据需要创建多个线程（number = 3 && number = 4）来执行开发者添加的任务。

### 队列组

```swift
class DispatchGroupTest {
    public func dispatchGroupDemo() {
        let group = DispatchGroup.init()
        let queue = DispatchQueue.init(label: "my dispatch queue", qos: DispatchQoS.default, attributes: [.concurrent], autoreleaseFrequency: .inherit, target: nil)
        //notify
        queue.async(group: group, qos: DispatchQoS.default, flags: []) {
            for i in 1...5 {
                print("\(Thread.current) i = \(i)")
            }
        }
        queue.async(group: group, qos: DispatchQoS.default, flags: []) {
            for i in 6...10 {
                print("\(Thread.current) i = \(i)")
            }
        }
        group.notify(queue: .main) {
            for i in 11...15 {
                 print("\(Thread.current) i = \(i)")
            }
        }

        //wait
        queue.async(group: group, qos: DispatchQoS.default, flags: []) {
            print("\(Thread.current)   Time-consuming task one")
            Thread.sleep(forTimeInterval: 2)
        }
        queue.async(group: group, qos: DispatchQoS.default, flags: []) {
            print("\(Thread.current)   Time-consuming task two")
            Thread.sleep(forTimeInterval: 2)

        }
        let result = group.wait(timeout: DispatchTime.now() + 5)
        switch result {
        case .success:
            print("Wonderful! Finished two tasks!")
        case .timedOut:
            print("Timeout! Failed to excute last two tasks!")
        }

        //enter && leave
        group.enter()
        queue.async(group: group, qos: DispatchQoS.default, flags: []) {
            print("\(Thread.current)   Time-consuming task one")
            for i in 1...5 {
                print("\(Thread.current) i = \(i)")
            }
            group.leave()
        }
        group.enter()
        queue.async(group: group, qos: DispatchQoS.default, flags: []) {
            print("\(Thread.current)   Time-consuming task two")
            for i in 6...10 {
                print("\(Thread.current) i = \(i)")
            }
            group.leave()
        }
        group.notify(queue: .main) {
            print("\(Thread.current)   Time-consuming task three")
            for i in 11...15 {
                print("\(Thread.current) i = \(i)")
            }
        }
    }
}
DispatchGroupTest().dispatchGroupDemo()
```

三段代码分别的运行结果：

```txt
<NSThread: 0x600001a95e40>{number = 3, name = (null)} i = 1
<NSThread: 0x600001a9da40>{number = 4, name = (null)} i = 6
<NSThread: 0x600001a9da40>{number = 4, name = (null)} i = 7
<NSThread: 0x600001a95e40>{number = 3, name = (null)} i = 2
<NSThread: 0x600001a9da40>{number = 4, name = (null)} i = 8
<NSThread: 0x600001a95e40>{number = 3, name = (null)} i = 3
<NSThread: 0x600001a9da40>{number = 4, name = (null)} i = 9
<NSThread: 0x600001a95e40>{number = 3, name = (null)} i = 4
<NSThread: 0x600001a9da40>{number = 4, name = (null)} i = 10
<NSThread: 0x600001a95e40>{number = 3, name = (null)} i = 5
<NSThread: 0x600001aba800>{number = 1, name = main} i = 11
<NSThread: 0x600001aba800>{number = 1, name = main} i = 12
<NSThread: 0x600001aba800>{number = 1, name = main} i = 13
<NSThread: 0x600001aba800>{number = 1, name = main} i = 14
<NSThread: 0x600001aba800>{number = 1, name = main} i = 15
```

```txt
<NSThread: 0x6000033dafc0>{number = 3, name = (null)}   Time-consuming task one
<NSThread: 0x6000033d41c0>{number = 4, name = (null)}   Time-consuming task two
Wonderful! Finished two tasks!
```

```txt
<NSThread: 0x600003d0f400>{number = 3, name = (null)}   Time-consuming task one
<NSThread: 0x600003d35740>{number = 4, name = (null)}   Time-consuming task two
<NSThread: 0x600003d35740>{number = 4, name = (null)} i = 6
<NSThread: 0x600003d0f400>{number = 3, name = (null)} i = 1
<NSThread: 0x600003d35740>{number = 4, name = (null)} i = 7
<NSThread: 0x600003d0f400>{number = 3, name = (null)} i = 2
<NSThread: 0x600003d35740>{number = 4, name = (null)} i = 8
<NSThread: 0x600003d35740>{number = 4, name = (null)} i = 9
<NSThread: 0x600003d0f400>{number = 3, name = (null)} i = 3
<NSThread: 0x600003d0f400>{number = 3, name = (null)} i = 4
<NSThread: 0x600003d35740>{number = 4, name = (null)} i = 10
<NSThread: 0x600003d0f400>{number = 3, name = (null)} i = 5
<NSThread: 0x600003d1e500>{number = 1, name = main}   Time-consuming task three
<NSThread: 0x600003d1e500>{number = 1, name = main} i = 11
<NSThread: 0x600003d1e500>{number = 1, name = main} i = 12
<NSThread: 0x600003d1e500>{number = 1, name = main} i = 13
<NSThread: 0x600003d1e500>{number = 1, name = main} i = 14
<NSThread: 0x600003d1e500>{number = 1, name = main} i = 15
```

### GCD处理循环任务

根据打印结果，我的电脑大约有70个线程来执行代码块。

```swift
let queue = DispatchQueue.global()
for i in 0...1000 {
    queue.async {
        print("\(Thread.current) Time-consuming task \(i)")
        Thread.sleep(forTimeInterval: 0.5)
    }
}
```

### GCD的消息和信号量

```swift
class DispatchSourceAndSemaphoreTest {
    public func DispatchSourceAndSemaphoreDemo() {
        let source =  DispatchSource.makeUserDataAddSource(queue: DispatchQueue.global())
        source.setEventHandler {
            print("Received Info!")
        }
        source.activate()
        source.add(data: 1)

        let semaphore = DispatchSemaphore.init(value: 0)
        let queue = DispatchQueue.global()
        queue.async {
            Thread.sleep(forTimeInterval: 3)
            semaphore.signal()
        }
        let start = Date()
        semaphore.wait()
        print("After \(Date().timeIntervalSince(start)) seconds, dispatchSemaphore test !")
    }
}

DispatchSourceAndSemaphoreTest().DispatchSourceAndSemaphoreDemo()
```

```txt
Received Info!
After 3.0051910877227783 seconds, dispatchSemaphore test !
```

### GCD执行延时任务

```swift
class DispatchQueueTest {
    public func DispatchQueueDemo() {
        let queue = DispatchQueue.global()
        let start = Date()
        queue.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            print("After \(Date().timeIntervalSince(start)) seconds, block start to execute.")
        }
    }
}
DispatchQueueTest().DispatchQueueDemo()
```

## 并发编程三大问题

### 竞态条件

指的是两个或者两个以上的线程对共享资源进行读写操作，最终导致结果不确定。

```swift
class ConcurrentProgramProblem {
    public func raceConditionTest() -> Int {
        var num = 0
        DispatchQueue.global().async {
            for i in 0...50 {
                num += i
            }
        }
        for i in 0...50 {
            num += i
        }
        return num
    }
}
var ans = ""
for _ in 0...10 {
    ans += "  \(ConcurrentProgramProblem().raceConditionTest())  "
}
print(ans)
```

```txt
  1803    2178    2310    2181    2310    2451    2517    2500    2550    2550    1710 
```

### Priority Inverstion(优先倒置)

```swift
class ConcurrentProgramProblem {
    public func priorityInverstionTest() {
        let lowPriorityQueue = DispatchQueue(label: "Low Priority", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        let highPriorityQueue = DispatchQueue(label: "High Priority", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        let semaphore = DispatchSemaphore.init(value: 1)

        lowPriorityQueue.async {
//            semaphore.wait()
            for i in 0...10 {
                print("\(Thread.current)  i = \(i)")
            }
//            semaphore.signal()
        }
        highPriorityQueue.async {
//            semaphore.wait()
            for i in 11...20 {
                print("\(Thread.current)  i = \(i)")
            }
//            semaphore.signal()
        }
    }
}
ConcurrentProgramProblem().priorityInverstionTest()
```

明显优先级高的先执行完。

```txt
<NSThread: 0x6000013a7a40>{number = 4, name = (null)}  i = 11
<NSThread: 0x6000013a7b00>{number = 3, name = (null)}  i = 0
<NSThread: 0x6000013a7a40>{number = 4, name = (null)}  i = 12
<NSThread: 0x6000013a7a40>{number = 4, name = (null)}  i = 13
<NSThread: 0x6000013a7a40>{number = 4, name = (null)}  i = 14
<NSThread: 0x6000013a7a40>{number = 4, name = (null)}  i = 15
<NSThread: 0x6000013a7b00>{number = 3, name = (null)}  i = 1
<NSThread: 0x6000013a7a40>{number = 4, name = (null)}  i = 16
<NSThread: 0x6000013a7a40>{number = 4, name = (null)}  i = 17
<NSThread: 0x6000013a7b00>{number = 3, name = (null)}  i = 2
<NSThread: 0x6000013a7a40>{number = 4, name = (null)}  i = 18
<NSThread: 0x6000013a7b00>{number = 3, name = (null)}  i = 3
<NSThread: 0x6000013a7a40>{number = 4, name = (null)}  i = 19
<NSThread: 0x6000013a7a40>{number = 4, name = (null)}  i = 20
<NSThread: 0x6000013a7b00>{number = 3, name = (null)}  i = 4
<NSThread: 0x6000013a7b00>{number = 3, name = (null)}  i = 5
<NSThread: 0x6000013a7b00>{number = 3, name = (null)}  i = 6
<NSThread: 0x6000013a7b00>{number = 3, name = (null)}  i = 7
<NSThread: 0x6000013a7b00>{number = 3, name = (null)}  i = 8
<NSThread: 0x6000013a7b00>{number = 3, name = (null)}  i = 9
<NSThread: 0x6000013a7b00>{number = 3, name = (null)}  i = 10
```

加入信号量：

```txt
<NSThread: 0x6000035d06c0>{number = 3, name = (null)}  i = 0
<NSThread: 0x6000035d06c0>{number = 3, name = (null)}  i = 1
<NSThread: 0x6000035d06c0>{number = 3, name = (null)}  i = 2
<NSThread: 0x6000035d06c0>{number = 3, name = (null)}  i = 3
<NSThread: 0x6000035d06c0>{number = 3, name = (null)}  i = 4
<NSThread: 0x6000035d06c0>{number = 3, name = (null)}  i = 5
<NSThread: 0x6000035d06c0>{number = 3, name = (null)}  i = 6
<NSThread: 0x6000035d06c0>{number = 3, name = (null)}  i = 7
<NSThread: 0x6000035d06c0>{number = 3, name = (null)}  i = 8
<NSThread: 0x6000035d06c0>{number = 3, name = (null)}  i = 9
<NSThread: 0x6000035d06c0>{number = 3, name = (null)}  i = 10
<NSThread: 0x6000035d9ec0>{number = 6, name = (null)}  i = 11
<NSThread: 0x6000035d9ec0>{number = 6, name = (null)}  i = 12
<NSThread: 0x6000035d9ec0>{number = 6, name = (null)}  i = 13
<NSThread: 0x6000035d9ec0>{number = 6, name = (null)}  i = 14
<NSThread: 0x6000035d9ec0>{number = 6, name = (null)}  i = 15
<NSThread: 0x6000035d9ec0>{number = 6, name = (null)}  i = 16
<NSThread: 0x6000035d9ec0>{number = 6, name = (null)}  i = 17
<NSThread: 0x6000035d9ec0>{number = 6, name = (null)}  i = 18
<NSThread: 0x6000035d9ec0>{number = 6, name = (null)}  i = 19
<NSThread: 0x6000035d9ec0>{number = 6, name = (null)}  i = 20
```

### Dead Lock(死锁问题)

两个或者多个 线程等待彼此执行结束，以获得某种资源，但是没有一方会提前退出。

```swift
class ConcurrentProgramProblem {
    public func deadLockTest() {
        let operationA = BlockOperation()
        let operationB = BlockOperation()
        operationA.addDependency(operationB)
        operationB.addDependency(operationA)

        let serialQueue = DispatchQueue.init(label: "Serial Queue")
        serialQueue.sync {
            serialQueue.sync {
                print("!!!!")
            }
        }
    }
}
```
