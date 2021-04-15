# interview-memo-iOS RunLoop
所有源码基于[objc-runtime-objc.680版本](https://opensource.apple.com/source/objc4/) 

# 前言
《interview-memo-iOS RunLoop》是关于iOS的RunLoop相关的知识点及面试题的整理，难易程度没做区分，即默认是必须掌握的内容。  
本篇内容会持续整理并不断更新完善，如果哪里有理解不正确的地方请路过的大神告知，共勉。  
**可通过目录自行检测掌握程度**   
[github原文地址](https://github.com/mickychiang/interview-memo-iOS/blob/master/InterviewSummary/runloop.md)

![runloop.png](https://i.loli.net/2021/03/08/E2lKBmdbYyCkZVQ.png)

# 目录

[<span id="jump-1"><h2>一. RunLoop的本质</h2></span>](#1)
[1. 什么是RunLoop？](#1-1)  
[2. 什么是事件循环 Event Loop？](#1-2)  
[3. 为什么app中的main()函数一直活跃，一直保持不退出的状态？](#1-3)  

[<span id="jump-2"><h2>二. RunLoop的数据结构</h2></span>](#2)
[1. CFRunLoop](#2-1)  
[2. CFRunLoopMode](#2-2)  
[3. CFRunLoopSource](#2-3)  
[4. CFRunLoopTimer](#2-4)  
[5. CFRunLoopObserver](#2-5)  
[6. RunLoop、Mode、Source、Timer、Observer的关系？](#2-6)  
[7. RunLoop为什么会有多个Mode？](#2-7)  
[8. tableview的banner不能自动滚动的原因？](#2-8)  
[9. 一个Timer想要加入到两个Mode，怎么处理？](#2-9)  
[10. 什么是CommonMode？](#2-10)  

[<span id="jump-3"><h2>三. RunLoop的事件循环机制</h2></span>](#3)
[1. RunLoop事件循环的实现机制？](#3-1)  
[2. RunLoop的核心？](#3-2)  

[<span id="jump-4"><h2>四. RunLoop与NSTimer</h2></span>](#4)
[1. 滑动tableview的时候我们的定时器还会生效吗？如果不生效的话，有什么解决方案呢？](#4-1)  

[<span id="jump-5"><h2>五. RunLoop与多线程</h2></span>](#5)
[1. RunLoop与线程的关系？](#5-1)  
[2. 怎样实现一个常驻线程？](#5-2)  

[<span id="jump-6"><h2>六. RunLoop面试总结</h2></span>](#6)
[1. 什么是RunLoop？它是怎么做到有事做事，没事休息的？](#6-1)  
[2. RunLoop与线程是怎样的关系？](#6-2)  
[3. 如何实现一个常驻线程？](#6-3)  
[4. 怎样保证子线程数据回来更新UI的时候不打断用户的滑动操作？](#6-4)  

# 正文

<h2 id="1">一. RunLoop的本质</h2>

<h3 id="1-1">1. 什么是RunLoop？</h3>

- RunLoop是通过内部维护的**事件循环**来对**事件/消息进行管理**的一个对象。
- 状态的切换：[具体回答问题2的答案](#1-2)

[回到目录](#jump-1)


<h3 id="1-2">2. 什么是事件循环 Event Loop？</h3>

- 维护的事件循环可以用来**不断的处理事件/消息**和**对事件/消息进行管理**；
- 没有消息需要处理时，会发生从**用户态到内核态的切换**，当前线程会**休眠**以避免资源占用； 
- 有消息需要处理时，会发生从**内核态到用户态的切换**，当前线程立刻被**唤醒**。  

**扩展1**：
- **没有消息需要处理时，休眠以避免资源占用；**  
**RunLoop`休眠`：从`用户态`到`内核态`的切换**  
![event-loop-dormancy.png](https://i.loli.net/2021/03/08/1DIRjp6UYAkK3ec.png)

- **有消息需要处理时，立刻被唤醒。**  
**RunLoop`唤醒`：从`内核态`到`用户态`的切换**  
![event-loop-awaken.png](https://i.loli.net/2021/03/08/4vDIJjLErWVxi8B.png)

**扩展2**：  
- 用户态：应用程序、绝大多数的API
- 内核态：系统调用  
用户态和内核态介绍：  
我们的应用程序都是运行在用户态上的。  
用户进程以及开发中使用的绝大多数API都是在用户层面的，而发生的系统调用需要使用关于操作系统以及底层内核相关的指令和API就相当于触发了系统调用，有些系统调用就会发生状态空间的切换。  
这种切换空间是对计算机的一些资源调度、管理进行统一或者一致性的操作，避免特殊的异常，合理的安排资源调度；同时内核态的一些内容可以对用户态的线程进行调度、管理、进程间通信。  

[回到目录](#jump-1)

<h3 id="1-3">3. 为什么app中的main()函数一直活跃，一直保持不退出的状态？</h3>

![main__.png](https://i.loli.net/2021/03/08/DMFjtVbKQqBza94.png)

在main()函数中调用的`UIApplicationMain`函数的内部会**启动主线程的runLoop**，而runloop又是对**事件循环**的一种维护机制，可以做到有事做的时候做事，没有事情做的时候会通过**用户态到内核态的切换**，避免资源占用，让当前线程处于休眠状态。

[回到目录](#jump-1)


<h2 id="2">二. RunLoop的数据结构</h2>

NSRunLoop是CFRunLoop的封装，提供了面向对象的API。

- CFRunLoop
- CFRunLoopMode
- CFRunLoopSource/CFRunLoopTimer/CFRunLoopObserver

<h3 id="2-1">1. CFRunLoop</h3>

![CFRunLoop.png](https://i.loli.net/2021/03/08/gQPlwSqzu4HkfCt.png)

- pthread：CFRunLoop和pthread是**一一对应**的关系（RunLoop和线程的关系）
- currentMode：CFRunLoopMode
- modes：NSMutableSet<CFRunLoopMode *>
- commonModes：NSMutableSet<NSString *>
- commonModeItems：也是一个集合，包括多个Observer、多个Timer、多个Source

[回到目录](#jump-2)


<h3 id="2-2">2. CFRunLoopMode</h3>

![CFRunLoopMode.png](https://i.loli.net/2021/03/08/bYmU2uZHGqKnO79.png)

- name：NSDefaultRunLoopMode别名定义的字符串
- source0：MutableSet（集合无序）
- source1：MutableSet
- observers：MutableArray（数组有序）
- timers：MutableArray

[回到目录](#jump-2)


<h3 id="2-3">3. CFRunLoopSource</h3>

source0和source1有什么区别？

- source0：需要手动唤醒线程  
- source1：具备唤醒线程的能力

[回到目录](#jump-2)


<h3 id="2-4">4. CFRunLoopTimer</h3>

基于事件的定时器，和NSTimer是具备免费桥转换（toll-free bridged）的。

[回到目录](#jump-2)


<h3 id="2-5">5. CFRunLoopObserver</h3>

观测时间点

我们可以监听runloop的哪些时间点？
- kCFRunLoopEntry：入口时机
- kCFRunLoopBeforeTimers：
- kCFRunLoopBeforeSources：
- **kCFRunLoopBeforeWaiting**：即将发生用户态到内核态的切换。
- **kCFRunLoopAfterWaiting**：内核态切换到用户态后。
- kCFRunLoopExit：

[回到目录](#jump-2)


<h3 id="2-6">6. RunLoop、Mode、Source、Timer、Observer的关系？</h3>

![data.png](https://i.loli.net/2021/03/08/ZPEOHFt1l4MYyqL.png)

- 线程和RunLoop是一一对应的关系
- RunLoop和Mode是一对多的关系
- Mode分别和Source、Timer、Observer是一对多的关系

[回到目录](#jump-2)


<h3 id="2-7">7. RunLoop为什么会有多个Mode？</h3>

**RunLoop的Mode**  
![runloop2.png](https://i.loli.net/2021/03/08/Wp3SCM68L45Gszx.png)
 
当我们运行在mode1上时，只能接收处理mode1当中的source1、timers、observers，不能处理mode2、mode3里的。

[回到目录](#jump-2)


<h3 id="2-8">8. tableview的banner不能自动滚动的原因？</h3>

[回到目录](#jump-2)


<h3 id="2-9">9. 一个Timer想要加入到两个Mode，怎么处理？</h3>

![runloop3.png](https://i.loli.net/2021/03/09/tkPTGfWlY9MAwRj.png)

**使用CommonMode**  
CommonMode的特殊性：  
NSRunLoopCommonModes字符串常量来表达CommonMode。
- CommonMode并不是实际存在的mode。
- 是同步source、timer、observer到多个mode的一个技术方案。

[回到目录](#jump-2)


<h3 id="2-10">10. 什么是CommonMode？</h3>

CommonMode是同步Source/Timer/Observer到多个Mode的一个技术方案。

[回到目录](#jump-2)


<h2 id="3">三. RunLoop的事件循环机制</h2>

<h3 id="3-1">1. RunLoop的事件循环的实现机制？</h3>

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

[回到目录](#jump-3)


<h3 id="3-2">2. RunLoop的核心？</h3>

用户态到核心态的切换 - 休眠  
核心态到用户态的切换 - 唤醒

![runloop7.png](https://i.loli.net/2021/03/09/lyE5oMH1NfIrinP.png)

[回到目录](#jump-3)


<h2 id="4">四. RunLoop与NSTimer</h2>

<h3 id="4-1">1. 滑动tableview的时候我们的定时器还会生效吗？如果不生效的话，有什么解决方案呢？</h3>

![runloop-nstimer.png](https://i.loli.net/2021/03/09/KCJESXxy9trid8z.png)

tableview(当前线程)正常情况下，运行在kCFRunLoopDefaultMode；当滑动tableview时，会发生Mode切换，切换到UITrackingRunLoopMode，此时定时器就不会再生效。

可以通过CFRunLoopAddTimer使定时器生效。
```
void CFRunLoopAddTimer(runLoop, timer, commonMode);
```
把NSTimer添加到当前runloop的commonMode中。  
commonMode并不是实际存在的mode，它只是把一些mode打上commonMode的标记，把某个事件源例如timer同步到多个mode当中。

[回到目录](#jump-4)


<h2 id="5">五. RunLoop与多线程</h2>

<h3 id="5-1">1. RunLoop与线程的关系？</h3>

- 线程和RunLoop是一一对应的关系。
- 自己创建的线程默认是没有RunLoop的，需要手动开启RunLoop。

[回到目录](#jump-5)


<h3 id="5-2">2. 怎样实现一个常驻线程？</h3>

- 为当前线程开启一个RunLoop
- 向该RunLoop中添加一个Port/Source等维持RunLoop的事件循环
- 启动该RunLoop

具体代码看工程

[回到目录](#jump-5)


<h2 id="6">六. RunLoop面试总结</h2>

<h3 id="6-1">1. 什么是RunLoop？它是怎么做到有事做事，没事休息的？</h3>

RunLoop是一个事件循环用于处理事件消息和对他们的管理的对象。  

在调用CFRunLoopRun方法中，会调用系统方法mach_msg，同时发生从用户态到内核态的切换，然后当前线程处于休眠状态，所以做到有事做事，没事休息。

[回到目录](#jump-6)


<h3 id="6-2">2. RunLoop与线程是怎样的关系？</h3>

- 两者一一对应的关系
- 一个线程默认是没有runloop，需要手动加上runloop。

[回到目录](#jump-6)


<h3 id="6-3">3. 如何实现一个常驻线程？</h3>

- 创建一个runoop。
- 给runloop添加source/timer/observer事件以及port。
- 调用run方法。

注意：  
运行的模式和资源添加的模式必须是同一个，否则可能由于外部使用while循环会导致死循环。

[回到目录](#jump-6)


<h3 id="6-4">4. 怎样保证子线程数据回来更新UI的时候不打断用户的滑动操作？</h3>

- 用户滑动操作时，当前的RunLoop是运行在kCFRunLoopUITrackingMode下
- 网络请求一般放在子线程中
- 我们可以把子线程中更新UI的操作包装一下，把它放在NSDefaultRunLoopMode模式下，等手势停止滑动后，才进行更新，这样就不打断用户的滑动操作

[回到目录](#jump-6)