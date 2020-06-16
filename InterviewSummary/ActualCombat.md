# iOS面试题备忘录() - 实战
所有源码基于[objc-runtime-objc.680版本](https://opensource.apple.com/source/objc4/)  


# 前言
《iOS面试题备忘录() - 实战》是关于实际iOS开发中遇到的难题的整理。  
本篇内容会一直持续整理并完善，有理解不正确的地方请路过的大神告知，共勉。  
[github原文地址](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/ActualCombat.md)


<span id="jump"><h1>目录</h1></span>

<!-- [<span id="jump-1"><h2>一. KVO</h2></span>](#1)
[<span id="jump-1-1">1. KVO的概念</span>](#1-1)  
[<span id="jump-1-2">2. KVO的实现原理[※※※※※]</span>](#1-2)  
[<span id="jump-1-3">3. isa混写技术怎样实现KVO？[※※※※※]</span>](#1-3)  
[<span id="jump-1-4">4. 子类重写setter方法的逻辑和具体实现[※※※※※]</span>](#1-4)  
[<span id="jump-1-5">5. KVO具体的代码实现</span>](#1-5)  
[<span id="jump-1-6">6. 手动实现KVO[※※※※※]</span>](#1-6)  
[<span id="jump-1-7">7. KVO总结[※※※]</span>](#1-7) 


[<span id="jump-2"><h2>二. KVC</h2></span>](#2)
[<span id="jump-2-1">1. KVC的概念</span>](#2-1)  
[<span id="jump-2-2">2. 我们使用KVC键值编码技术是否会破坏面向对象的编程方法？[※※※]</span>](#2-2)  
[<span id="jump-2-3">3. valueForKey:的实现流程</span>](#2-3)  
[<span id="jump-2-4">4. setValue:forKey:的实现流程</span>](#2-4)   -->


# 正文
<!-- <h2 id="1">一. KVO</h2>

<h3 id="1-1">1. KVO的概念</h3>

- KVO是Key-value observing的缩写。
- KVO是Objective-C对**观察者设计模式**的一种实现。
- 系统使用**isa混写技术**(isa-swizzling)来实现KVO。

[回到目录](#jump-1) -->

### 1. 你知道有哪些情况会导致App卡顿，分别可以用什么方法来避免？

App卡顿包括CPU卡顿和GPU卡顿。

#### CPU卡顿原因和解决方案

##### 对象创建

对象的创建会分配内存、调整属性、甚至还有读取文件等操作，比较消耗CPU资源。

解决方案：
- 尽量用轻量的对象代替重量的对象，可以对性能有所优化。  
  比如：不需要响应触摸事件的控件，使用CALayer代替UIView会更加合适。(CALayer比UIView要轻量许多)

- 如果对象不涉及UI操作，则尽量放到后台线程去创建。
  但可惜的是包含有CALayer的控件，都只能在主线程创建和操作。

- 尽量直接用代码创建对象而不是用Storyboard创建对象。  
  因为通过Storyboard创建视图对象时，其资源消耗会比直接通过代码创建对象要大非常多，在性能敏感的界面里，Storyboard并不是一个好的技术选择。

- 尽量推迟对象创建的时间，并把对象的创建分散到多个任务中去。
  尽管这实现起来比较麻烦，并且带来的优势并不多，但如果有能力做，还是要尽量尝试一下。

- 如果对象可以复用，并且复用的代价比释放、创建新对象要小，那么这类对象应当尽量放到一个缓存池里复用。





##### 对象调整

##### 对象销毁

##### 布局计算

##### Autolayout


##### 文本计算


##### 文本渲染

##### 图片的解码







- 主线程中进行了耗时操作。解决：将耗时操作放到子线程。
- 线程爆炸
- 滑动页面渲染卡顿（离屏渲染）
- 图像渲染解码

#### GPU卡顿
- 查看xcode的cpu占用。
- 使用instrument 查看耗时代码。查看渲染耗时问题。


主线程中进化IO或其他耗时操作，解决：把耗时操作放到子线程中操作
GCD并发队列短时间内创建大量任务，解决：使用线程池
文本计算，解决：把计算放在子线程中避免阻塞主线程
大量图像的绘制，解决：在子线程中对图片进行解码之后再展示
高清图片的展示，解法：可在子线程中进行下采样处理之后再展示

[iOS 保持界面流畅的技巧](https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/)  
[zongjie ](https://github.com/skyming/iOS-Performance-Optimization)  
[iOS 性能优化总结](http://www.cocoachina.com/articles/22990)  

https://www.jianshu.com/p/87cff5f30e63



# 参考文档

[出一套 iOS 高级面试题](https://juejin.im/post/5b56155e6fb9a04f8b78619b)  
[iOS 高级面试题--答案](https://juejin.im/post/5e01c5ef6fb9a016464359ca)

<!-- 《新浪微博资深大牛全方位剖析 iOS 高级面试》  -->

# 其他
<!-- 《iOS面试题备忘录》系列文章的github原文地址：  

[iOS面试题备忘录(一) - 属性关键字](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/PropertyModifier.md)    
[iOS面试题备忘录(二) - 内存管理](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/memoryManagement.md)   
[iOS面试题备忘录(三) - 分类和扩展](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/CategoryAndExtension.md)  
[iOS面试题备忘录(四) - 代理和通知](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/DelegateAndNSNotification.md)  
[iOS面试题备忘录(五) - KVO和KVC](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/KVOAndKVC.md)  
[iOS面试题备忘录(六) - runtime](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/runtime.md)  
[算法](https://github.com/mickychiang/iOSInterviewMemo/blob/master/Algorithm/Algorithm.md)   -->
