# GCD

## Conceptions

1. 队列
   队列负责管理开发者提交的任务。GCD队列始终先进先出(FIFO)管理任务，但是由于任务执行时间各不相同，因此并不一定先出的任务据先完成。队列有可分为串行队列和并行队列。

2. 任务
   任务是提交给队列的工作单元。这些任务将会提交给队列底层维护的线程池执行，因此这些任务将是以多线程额方式执行。

## Steps

1. 创建队列
2. 将任务提交给队列

## Create Queues and Run tasks

默认创建串行队列。

```swift
        var serialQueue = DispatchQueue(label: "Serial Queue")
        var concurrentQueue = DispatchQueue(label: "Concurrent Queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)

        serialQueue.async {
            for i in 1...10 {
                print("======= currend thread = \(Thread.current)    ======= number = \(i)")
            }
        }
        concurrentQueue.sync {
            for i in 1...10 {
                print("======= currend thread = \(Thread.current)    ======= number = \(i)")
            }
        }
        //运行多次
        DispatchQueue.concurrentPerform(iterations: times) { (val) in
            print("Execute time = \(val)")
        }
```

## BackgroundTask

APP进入后台运行后，尚未完成的任务会被暂停。如果app有进入后台并继续运行一段时间的需要，则按照以下步骤：

1. 调用UIApplication.shared.beginBackgroundTask方法请求获取更多的后台运行时间，默认为3分钟。传入超时后需要运行的代码块，返回UIBackgroundTaskIdentifier变量作为后台任务的标识符。 
2. 后台任务完成，调用endBackgroundTask方法结束任务。

```swift
func enterBack()  {
        let app = UIApplication.shared
        var backTaskId = UIBackgroundTaskIdentifier(rawValue: 0)
         backTaskId = app.beginBackgroundTask(withName: "BackgroundTask", expirationHandler: {
            print("Havn't complete the task with three minutes!")
            app.endBackgroundTask(backTaskId)
        })
        if backTaskId == UIBackgroundTaskIdentifier.invalid {
            print("Current iOS version don't support background task!")
            return
        }
        print("Apply for background task time remaining \(app.backgroundTimeRemaining)")
        DispatchQueue.global(qos: .default).async {
            for i in 0...9{
                Thread.sleep(forTimeInterval:5 )
                print("Background task fnished : \(10 * (i + 1))%")
            }
            DispatchQueue.main.sync {
                print("Background task time remaining \(app.backgroundTimeRemaining)")
            }
            app.endBackgroundTask(backTaskId)
        }
    }

```
