# ThreadDemo

## MultiThread

### init&&Start

```swift
let threadA = Thread(target: self, selector: #selector(ViewController.run), object: nil)
threadA.start()
let threadB = Thread(block: <#T##() -> Void#>)
threadA.start()

Thread.detachNewThreadSelector(#selector(ViewController.run), toTarget: self, with: nil)
```

### properties

1. thread.name
2. Thread.sleep()
3. Thread.current

## Exit

线程退出条件：

1. 代码块执行完毕，正常退出
2. 执行代码块出错，异常退出
3. 调用exit()方法

UI线程当中没有办法直接退出子线程。可以在UI线程中给子线程发送信号（比如调用cancel()方法）。然后在子线程代码块中判断calcelled属性来决定是否退出线程。

## DownloadImage

只能在UI线程更新UI控件属性。

## Priority

1. 默认优先级为0.5，优先级范围0.0 --- 1.0.  
2. 设置优先级: threadA.threadPriority = 0.05

## Sync

### 线程安全类的特点

1. 类的实例可以被多个线程安全的访问
2. 线程调用该对象任何方法之后都得到正确结果
3. 线程调用该对象的任意方法，对象都保持合理状态

不可变类总是线程安全的，可变类则需要提供额外的方法保证其线程安全。所以：

1. 只对那些会改变共享资源的方法进行同步
2. 区分运行环境。提供可变类的线程安全版本和线程不安全版本。

```swift
   objc_sync_enter(self)
   objc_sync_exit(self)
   let lock = NSLock()
   lock.lock()
   lock.unlock()
```

## Intercommucation

iOS提供NSCondition类来控制线程通信，其遵守NSLocking协议因此也可以用来同步。

1. wait()方法：当前线程等待，直到被唤醒
2. singal()方法：任意唤醒一个在等待的线程
3. broadcast()方法：唤醒所有等待线程
