# iOS面试题备忘录(八) - RunLoop

![runloop.png](https://i.loli.net/2021/03/08/E2lKBmdbYyCkZVQ.png)

## RunLoop本质

### 1. 什么是RunLoop？

- RunLoop是通过内部维护的**事件循环**来对**事件/消息进行管理**的一个对象。
- 状态的切换：具体回答问题2的答案

### 2. 什么是事件循环 Event Loop？
- 维护的事件循环可以用来**不断的处理事件/消息**和**对事件/消息进行管理**；
- 没有消息需要处理时，会发生从**用户态到内核态的切换**，当前线程会**休眠**以避免资源占用； 
- 有消息需要处理时，会发生从**内核态到用户态的切换**，当前线程立刻被**唤醒**。  

**扩展1**：
- 没有消息需要处理时，休眠以避免资源占用；  
RunLoop休眠：从用户态到内核态的切换
![event-loop-dormancy.png](https://i.loli.net/2021/03/08/1DIRjp6UYAkK3ec.png)

- 有消息需要处理时，立刻被唤醒。  
RunLoop唤醒：从内核态到用户态的切换
![event-loop-awaken.png](https://i.loli.net/2021/03/08/4vDIJjLErWVxi8B.png)

**扩展2**：  
- 用户态：应用程序、绝大多数的API
- 内核态：系统调用  
用户态和内核态介绍：  
我们的应用程序都是运行在用户态上的。  
用户进程以及开发中使用的绝大多数API都是在用户层面的，而发生的系统调用需要使用关于操作系统以及底层内核相关的指令和API就相当于触发了系统调用，有些系统调用就会发生状态空间的切换。  
这种切换空间是对计算机的一些资源调度、管理进行统一或者一致性的操作，避免特殊的异常，合理的安排资源调度；同时内核态的一些内容可以对用户态的线程进行调度、管理、进程间通信。  

### 3. 为什么app中的main()函数一直活跃，一直保持不退出的状态？

![main__.png](https://i.loli.net/2021/03/08/DMFjtVbKQqBza94.png)

在main()函数中调用的`UIApplicationMain`函数的内部会**启动主线程的runloop**，而runloop又是对**事件循环**的一种维护机制，可以做到有事做的时候做事，没有事情做的时候会通过**用户态到内核态的切换**，避免资源占用，让当前线程处于休眠状态。

## RunLoop的数据结构

NSRunLoop是CFRunLoop的封装，提供了面向对象的API。

- CFRunLoop
- CFRunLoopMode
- CFRunLoopSource/CFRunLoopTimer/CFRunLoopObserver

### CFRunLoop

![CFRunLoop.png](https://i.loli.net/2021/03/08/gQPlwSqzu4HkfCt.png)

- pthread：CFRunLoop和pthread是**一一对应**的关系（RunLoop和线程的关系）
- currentMode：CFRunLoopMode
- modes：NSMutableSet<CFRunLoopMode *>
- commonModes：NSMutableSet<NSString *>
- commonModeItems：也是一个集合，包括多个Observer、多个Timer、多个Source

### CFRunLoopMode

![CFRunLoopMode.png](https://i.loli.net/2021/03/08/bYmU2uZHGqKnO79.png)

- name：NSDefaultRunLoopMode别名定义的字符串
- source0：MutableSet（集合无序）
- source1：MutableSet
- observers：MutableArray（数组有序）
- timers：MutableArray

### CFRunLoopSource

source0和source1有什么区别？

- source0：需要手动唤醒线程  
- source1：具备唤醒线程的能力

### CFRunLoopTimer

基于事件的定时器，和NSTimer是具备免费桥转换（toll-free bridged）的。

### CFRunLoopObserver

观测时间点

我们可以监听runloop的哪些时间点？
- kCFRunLoopEntry：入口时机
- kCFRunLoopBeforeTimers：
- kCFRunLoopBeforeSources：
- **kCFRunLoopBeforeWaiting**：即将发生用户态到内核态的切换。
- **kCFRunLoopAfterWaiting**：内核态切换到用户态后。
- kCFRunLoopExit：

### 各个数据结构之间的关系

![data.png](https://i.loli.net/2021/03/08/ZPEOHFt1l4MYyqL.png)

RunLoop、Mode、Source、Timer、Observer的关系？

- 线程和RunLoop是一一对应的关系
- RunLoop和Mode是一对多的关系
- Mode分别和Source、Timer、Observer是一对多的关系

### RunLoop的Mode

![runloop2.png](https://i.loli.net/2021/03/08/Wp3SCM68L45Gszx.png)

#### 1. RunLoop为什么会有多个Mode？  
当我们运行在mode1上时，只能接收处理mode1当中的source1、timers、observers，不能处理mode2、mode3里的。

#### 2. tableview的banner不能自动滚动的原因？  

#### 3. 一个Timer想要加入到两个Mode，怎么处理？

![runloop3.png](https://i.loli.net/2021/03/09/tkPTGfWlY9MAwRj.png)

**使用CommonMode**  
CommonMode的特殊性：  
NSRunLoopCommonModes字符串常量来表达CommonMode。
- CommonMode并不是实际存在的mode。
- 是同步source、timer、observer到多个mode的一个技术方案。

#### 4. 什么是CommonMode？
CommonMode是同步Source/Timer/Observer到多个Mode的一个技术方案。


## RunLoop事件循环机制

### 事件循环的实现机制

调用NSRunLoop与CFRunLoop相关的run方法，最终都是调用CFRunLoopRun();

![runloop5.png](https://i.loli.net/2021/03/09/ZnuQCw5XzHWPBcx.png)

#### 1. 处于休眠状态的runloop，我们可以从哪些方面来唤醒它？  
- 通过Source1来进行唤醒
- Timer事件回调
- 外部手动唤醒

#### 2. App从点击一个图标到程序启动运行再到最终退出的这个过程中，系统都发生了什么？

![runloop6.png](https://i.loli.net/2021/03/09/3q7fjvXZTBmWQxP.png)

- 从屏幕点击App图标，调用了main函数之后，会调用UIApplicationMain;
- 在UIApplicationMain函数内部会启动主线程的runloop，进过一系列的处理后，主线程的runloop会处于休眠状态。
- 此时点击屏幕产生了mach-port，最终转成source1事件，把主线程唤醒，运行处理。
- 当我们把程序杀死时，会触发kCFRunloopExit通知，即将退出runloop，线程被销毁。


### RunLoop的核心
用户态到核心态的切换 - 休眠  
核心态到用户态的切换 - 唤醒

![runloop7.png](https://i.loli.net/2021/03/09/lyE5oMH1NfIrinP.png)


## RunLoop与NSTimer

### 1. 滑动tableview的时候我们的定时器还会生效吗？如果不生效的话，有什么解决方案呢？
![runloop-nstimer.png](https://i.loli.net/2021/03/09/KCJESXxy9trid8z.png)

tableview(当前线程)正常情况下，运行在kCFRunLoopDefaultMode；当滑动tableview时，会发生Mode切换，切换到UITrackingRunLoopMode，此时定时器就不会再生效。

可以通过CFRunLoopAddTimer使定时器生效。
```
void CFRunLoopAddTimer(runLoop, timer, commonMode);
```
把NSTimer添加到当前runloop的commonMode中。  
commonMode并不是实际存在的mode，它只是把一些mode打上commonMode的标记，把某个事件源例如timer同步到多个mode当中。


## RunLoop与多线程

- 线程和RunLoop是一一对应的关系
- 自己创建的线程默认是没有RunLoop的，需要手动开启RunLoop

### 1. 怎样实现一个常驻线程？

- 为当前线程开启一个RunLoop
- 向该RunLoop中添加一个Port/Source等维持RunLoop的事件循环
- 启动该RunLoop

具体代码看工程


## RunLoop面试总结

### 1. 什么是RunLoop？它是怎么做到有事做事，没事休息的？
RunLoop是一个事件循环用于处理事件消息和对他们的管理的对象。  

在调用CFRunLoopRun方法中，会调用系统方法mach_msg，同时发生从用户态到内核态的切换，然后当前线程处于休眠状态，所以做到有事做事，没事休息。

### 2. RunLoop与线程是怎样的关系？

- 两者一一对应的关系
- 一个线程默认是没有runloop，需要手动加上runloop。

### 3. 如何实现一个常驻线程？

- 创建一个runoop。
- 给runloop添加source/timer/observer事件以及port。
- 调用run方法。

注意：  
运行的模式和资源添加的模式必须是同一个，否则可能由于外部使用while循环会导致死循环。

### 4. 怎样保证子线程数据回来更新UI的时候不打断用户的滑动操作？
- 用户滑动操作时，当前的RunLoop是运行在kCFRunLoopUITrackingMode下
- 网络请求一般放在子线程中
- 我们可以把子线程中更新UI的操作包装一下，把它放在NSDefaultRunLoopMode模式下，等手势停止滑动后，才进行更新，这样就不打断用户的滑动操作