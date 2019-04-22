# Operation and OperationQueue

## Consepts

1. OperationQueue
   FIFO队列，负责管理系统提交的多个Operation.底层维护一个线程池，按顺序启动线程来执行提交的Operation.
2. Operation
   Abstract class.代表多线程的一个任务。使用时需要自己实现Operation子类，或者直接使用BlockOperation。

## Steps

1. 创建队列，设置相关属性。
2. 创建Operation子类对象，并添加到OperationQueue队列。

## Properties and Methods

### OperationQueue

https://developer.apple.com/documentation/foundation/operationqueue

### Operation

https://developer.apple.com/documentation/foundation/operation
