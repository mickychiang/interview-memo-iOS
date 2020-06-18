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

**对象创建**  
对象的创建会分配内存、调整属性、甚至还有读取文件等操作，比较消耗CPU资源。

解决方案：
- 尽量用轻量的对象代替重量的对象。  
  比如：不需要响应触摸事件的控件，使用CALayer代替UIView会更加合适。CALayer比UIView要轻量许多。

- 如果对象不涉及UI操作，则尽量放到后台线程去创建。  
  但可惜的是包含有CALayer的控件，都只能在主线程创建和操作。

- 尽量用代码创建对象而不是用Storyboard创建对象。  
  通过Storyboard创建视图对象时，其资源消耗会比直接通过代码创建对象要大非常多，在性能敏感的界面里，Storyboard并不是一个好的技术选择。

- 尽量推迟对象创建的时间，并把对象的创建分散到多个任务中去。  
  尽管这实现起来比较麻烦，并且带来的优势并不多，但如果有能力做，还是要尽量尝试一下。

- 复用对象。    
如果对象可以复用，并且复用的代价比释放、创建新对象要小，那么这类对象应当尽量放到一个缓存池里复用。


**对象调整**  
对象的调整也经常是消耗CPU资源的地方。  
这里特别说一下CALayer：CALayer内部并没有属性，当调用属性方法时，它内部是通过运行时 resolveInstanceMethod为对象临时添加一个方法，并把对应属性值保存到内部的一个 Dictionary里，同时还会通知delegate、创建动画等等，非常消耗资源。

解决方案：
- 尽量减少不必要的属性修改。  
UIView的关于显示相关的属性（比如 frame/bounds/transform）等实际上都是CALayer属性映射来的，所以对UIView的这些属性进行调整时，消耗的资源要远大于一般的属性。

- 尽量避免调整视图层次、添加和移除视图。  
当视图层次调整时，UIView、CALayer之间会出现很多方法调用与通知。


**对象销毁**  
对象的销毁虽然消耗资源不多，但累积起来也是不容忽视的。  
通常当容器类持有大量对象时，其销毁时的资源消耗就非常明显。

解决方案：
- 让对象在后台线程销毁。  
把对象捕获到block中，然后扔到后台队列去随便发个消息以避免编译器警告。   
  ```
  NSArray *tmp = self.array;
  self.array = nil;
  dispatch_async(queue, ^{
    [tmp class];
  });
  ```


**布局计算**   
视图布局的计算是App中最为常见的消耗CPU资源的地方。

解决方案：
- 在后台线程提前计算好视图布局、并且对视图布局进行缓存。  
不论通过何种技术对视图进行布局，其最终都会落到对 UIView.frame/bounds/center 等属性的调整上。  
上面也说过，对这些属性的调整非常消耗资源，所以尽量提前计算好布局，在需要时一次性调整好对应属性，而不要多次、频繁的计算和调整这些属性。


**Autolayout**  
Autolayout是苹果本身提倡的技术，在大部分情况下也能很好的提升开发效率，但是 Autolayout对于复杂视图来说常常会产生严重的性能问题。  
随着视图数量的增长，Autolayout带来的CPU消耗会呈指数级上升。

解决方案：
- 如果你不想手动调整frame等属性，你可以用一些工具方法替代（比如常见的 left/right/top/bottom/width/height快捷属性），或者使用ComponentKit、AsyncDisplayKit等框架。


**文本计算**   
如果一个界面中包含大量文本（比如微博微信朋友圈等），文本的宽高计算会占用很大一部分资源，并且不可避免。

解决方案：
- 用[NSAttributedString boundingRectWithSize:options:context:]来计算文本宽高，用 -[NSAttributedString drawWithRect:options:context:]来绘制文本。   
参考了UILabel内部的实现方式，尽管这两个方法性能不错，但仍旧需要放到后台线程进行以避免阻塞主线程。

- CoreText绘制文本。  
先生成CoreText排版对象，然后自己计算，并且CoreText对象还能保留以供稍后绘制使用。


**文本渲染**   
屏幕上能看到的所有文本内容控件，包括UIWebView，在底层都是通过CoreText排版、绘制为 Bitmap显示的。常见的文本控件（UILabel、UITextView等），其排版和绘制都是在主线程进行的，当显示大量文本时，CPU的压力会非常大。

解决方案：
- 自定义文本控件，用TextKit或最底层的CoreText对文本异步绘制。  
CoreText对象创建好后，能直接获取文本的宽高等信息，避免了多次计算（调整 UILabel大小时算一遍、UILabel 绘制时内部再算一遍）；  
CoreText对象占用内存较少，可以缓存下来以备稍后多次渲染。


**图片的解码**  
当你用UIImage或CGImageSource的那几个方法创建图片时，图片数据并不会立刻解码。  
图片设置到UIImageView或者CALayer.contents中去，并且CALayer被提交到GPU前，CGImage中的数据才会得到解码。  
这一步是发生在主线程的，并且不可避免。

解决方案：
- 在后台线程先把图片绘制到CGBitmapContext中，然后从Bitmap直接创建图片。  
目前常见的网络图片库都自带这个功能。


**图像的绘制**    
图像的绘制通常是指用那些以CG开头的方法把图像绘制到画布中，然后从画布创建图片并显示这样一个过程。  
这个最常见的地方就是 [UIView drawRect:] 里面了。  
由于CoreGraphic方法通常都是线程安全的，所以图像的绘制可以很容易的放到后台线程进行。  
一个简单异步绘制的过程大致如下（实际情况会比这个复杂得多，但原理基本一致）：

解决方案：
- 后台线程进行图像的绘制。  
  ```
  - (void)display {
    dispatch_async(backgroundQueue, ^{
        CGContextRef ctx = CGBitmapContextCreate(...);
        // draw in context...
        CGImageRef img = CGBitmapContextCreateImage(ctx);
        CFRelease(ctx);
        dispatch_async(mainQueue, ^{
            layer.contents = img;
        });
    });
  }
  ```


#### GPU卡顿原因和解决方案
相对于CPU来说，GPU能干的事情比较单一：接收提交的纹理（Texture）和顶点描述（三角形），应用变换（transform）、混合并渲染，然后输出到屏幕上。  
通常你所能看到的内容，主要也就是纹理（图片）和形状（三角模拟的矢量图形）两类。

**纹理的渲染**  
所有的 Bitmap，包括图片、文本、栅格化的内容，最终都要由内存提交到显存，绑定为 GPU Texture。不论是提交到显存的过程，还是 GPU 调整和渲染 Texture 的过程，都要消耗不少 GPU 资源。当在较短时间显示大量图片时（比如 TableView 存在非常多的图片并且快速滑动时），CPU 占用率很低，GPU 占用非常高，界面仍然会掉帧。避免这种情况的方法只能是尽量减少在短时间内大量图片的显示，尽可能将多张图片合成为一张进行显示。

当图片过大，超过 GPU 的最大纹理尺寸时，图片需要先由 CPU 进行预处理，这对 CPU 和 GPU 都会带来额外的资源消耗。目前来说，iPhone 4S 以上机型，纹理尺寸上限都是 4096×4096，更详细的资料可以看这里：iosres.com。所以，尽量不要让图片和视图的大小超过这个值。

解决方案：
- 多个视图预先渲染为一张图片来显示。


**视图的混合（Composing）**  
当多个视图（或者说 CALayer）重叠在一起显示时，GPU会首先把他们混合到一起。  
如果视图结构过于复杂，混合的过程也会消耗很多GPU资源。

解决方案：
- 尽量减少视图数量和层次，并在不透明的视图里标明opaque属性以避免无用的Alpha通道合成。
- 多个视图预先渲染为一张图片来显示。


**图形的生成 - 滑动页面渲染卡顿（离屏渲染）**  
CALayer的border、圆角、阴影、遮罩（mask），CASharpLayer的矢量图形显示，通常会触发离屏渲染（offscreen rendering），而离屏渲染通常发生在GPU中。  
当一个列表视图中出现大量圆角的CALayer，并且快速滑动时，可以观察到GPU资源已经占满，而CPU资源消耗很少。  
这时界面仍然能正常滑动，但平均帧数会降到很低。

解决方案：
- 开启CALayer.shouldRasterize属性，但这会把原本离屏渲染的操作转嫁到CPU上去。
- 只需要圆角的某些场合，也可以用一张已经绘制好的圆角图片覆盖到原本视图上面来模拟相同的视觉效果。
- 需要显示的图形在后台线程绘制为图片，避免使用圆角、阴影、遮罩等属性。



# 参考文档
[iOS 保持界面流畅的技巧](https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/)  
[iOS-Performance-Optimization](https://github.com/skyming/iOS-Performance-Optimization)  
[iOS 性能优化总结](http://www.cocoachina.com/articles/22990)  
[iOS客户端卡顿优化总结](https://www.jianshu.com/p/87cff5f30e63)   
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
