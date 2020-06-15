# iOS面试题备忘录(六) - runtime
所有源码基于[objc-runtime-objc.680版本](https://opensource.apple.com/source/objc4/) 

# 前言
《iOS面试题备忘录(六) - runtime》是关于iOS的runtime机制的相关知识点及面试题的整理，难易程度没做区分，即默认是必须掌握的内容。  
本篇内容会持续整理并不断更新完善，如果哪里有理解不正确的地方请路过的大神告知，共勉。  
**可通过目录自行检测掌握程度**  
[github原文地址](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/runtime.md)

<!-- ![runtime总结](./images/runtime/runtimeSummary.png) -->
![runtimeSummary.png](https://ae01.alicdn.com/kf/Hfb5ebad1066047799f74de1190ae436dH.jpg)

<span id="jump"><h1>目录</h1></span>

[<span id="jump-1"><h2>一. 数据结构</h2></span>](#1)

[<span id="jump-1-1">1. 简述一下runtime的基础数据结构</span>](#1-1)   
[<span id="jump-1-2">2. 简述一下objc_object </span>](#1-2)   
[<span id="jump-1-3">3. 简述一下objc_class？和objc_object有什么关系？</span>](#1-3)   
[<span id="jump-1-4">4. Class是否是对象？(什么是类对象？) </span>](#1-4)   
[<span id="jump-1-5">5. isa指针的含义？</span>](#1-5)   
[<span id="jump-1-6">6. isa指针的指向？</span>](#1-6)   
[<span id="jump-1-7">7. 介绍一下objc_class结构体里的cache_t</span>](#1-7)   
[<span id="jump-1-8">8. 介绍一下objc_class结构体里的class_data_bits_t</span>](#1-8)    
[<span id="jump-1-9">9. 简述一下method_t</span>](#1-9)   


[<span id="jump-2"><h2>二. 类对象和元类对象</h2></span>](#2)
[<span id="jump-2-1">1. 类对象和元类对象分别是什么？实例对象与类对象之间的关系？类对象和元类对象的区别和联系？</span>](#2-1)  
[<span id="jump-2-2">2. 如果我们调用的类方法没有对应的实现，但是有同名的实例方法的实现，那么这时会不会发生crash？或者会不会产生实际的调用？</span>](#2-2)    

[<span id="jump-3"><h2>三. 消息传递机制</h2></span>](#3)
[<span id="jump-3-1">1. 请描述一下消息传递过程</span>](#3-1)  
[<span id="jump-3-2">2. objc_msgSend()和objc_msgSendSuper()的区别？</span>](#3-2)  
[<span id="jump-3-3">3. 代码如下图所示，[self class]和[super class]打印出来的内容是什么？</span>](#3-3)  
![classAndMetaClassExample.png](https://i.loli.net/2020/06/04/jAfaxET8u3ZHFMr.png)  
[<span id="jump-3-4">4. [obj foo]和objc_msgSend()函数之间有什么关系？ </span>](#3-4)  
[<span id="jump-3-5">5. runtime是如何通过selector找到对应的IMP地址的？</span>](#3-5)   
[<span id="jump-3-6">6. 当我们进行消息传递的过程中，如何进行缓存的方法查找？/缓存查找的具体流程和步骤</span>](#3-6)   
[<span id="jump-3-7">7. 消息转发流程是怎样的？</span>](#3-7)   

[<span id="jump-4"><h2>四. runtime应用场景</h2></span>](#4)
[<span id="jump-4-1">1. Method Swizzling是什么？实际应用场景？(Method Swizzling)</span>](#4-1)  
[<span id="jump-4-2">2. 你是否使用过performSelector:方法？实际应用场景？(动态添加方法)</span>](#4-2)    
[<span id="jump-4-3">3. 编译时语言与OC这种运行时语言的区别？(动态方法解析)</span>](#4-3)  
[<span id="jump-4-4">4. 能否向编译后的类中添加实例变量？能否向运行时创建的类中添加实例变量？</span>](#4-4)    

[<span id="jump-5"><h2>五. 总结 - 消息传递机制具体解析</h2></span>](#5)

# 正文

<!-- 1.编译时语言与OC这种运行时语言的区别？- 👌  
2.消息传递与函数调用的区别？- 👌  
3.当我们调用一个方法却没有实现的时候，系统是如何为我们实现消息转发过程的？- 👌  
4.简述一下runtime的基础数据结构-👌  
5.类对象与元类对象分别是什么？-👌  
6.实例对象与类对象之间的关系？-👌  
7.类对象与元类对象之间的关系？-👌  
8.Objective-C语言中的消息传递机制？- 👌  
9.当我们进行消息传递的过程中，如何进行缓存的方法查找？- 👌  
10.消息转发流程是怎样的？- 👌  
11.Method Swizzling的应用- 👌  
12.动态添加方法  
13.动态方法解析   -->

<h2 id="1">一. 数据结构</h2>

<h3 id="1-1">1. 简述一下runtime的基础数据结构</h3>

<!-- ![runtimeStruct](./images/runtime/runtimeStruct.png) -->
![runtimeStruct.png](https://i.loli.net/2020/06/04/Rs1TMvgFdz6Nbrm.png)

[回到目录](#jump-1)


<h3 id="1-2">2. 简述一下objc_object</h3>

<!-- ![objc_object结构体](./images/runtime/objc_object_pic.png) -->
![objc_object_pic.png](https://i.loli.net/2020/06/04/D8lfNy9BKxZhSrU.png)

- id类型 = objc_object结构体   
平时开发使用的所有对象都是id类型的，id类型的对象对应到runtime当中是objc_object结构体。
<!-- ![objc_object结构体源码](./images/runtime/objc_object.png) -->
![objc_object.png](https://i.loli.net/2020/06/04/aGi6yo71ISZnLNV.png)

- objc_object结构体主要包含以下内容：    
    - isa_t：是一个共用体。
    - 关于isa操作的相关方法：比如，通过objc_object的isa指针获取其指向的类对象；通过类对象的isa指针来获取其指向的元类对象等。
    - 弱引用的相关方法：比如，标记一个对象它是否曾有过弱引用指针。
    - 关联对象的相关方法：比如，为对象设置关联属性。
    - 内存管理的相关方法：比如，MRC下的retain和release；MRC和ARC下的@autoReleasePool。

**延伸：**
内存管理的相关方法都是封装在objc_object结构体中。

[回到目录](#jump-1)


<h3 id="1-3">3. 简述一下objc_class？和objc_object有什么关系？</h3>

<!-- ![objc_class结构体](./images/runtime/objc_class_pic.png) -->
![objc_class_pic.png](https://i.loli.net/2020/06/04/qKXjHPbyw1gzJ5n.png)

- Class类型 = objc_class结构体   
在OC中使用到的Class是一个类，对应到runtime当中是objc_class结构体。

- objc_class结构体继承自objc_object结构体  

<!-- ![objc_class结构体源码](./images/runtime/objc_class.png)
![objc_class结构体源码](./images/runtime/objc_class_content.png) -->
![objc_class.png](https://i.loli.net/2020/06/04/sYwo6itEDk3ZO1p.png)
![objc_class_content.png](https://i.loli.net/2020/06/04/Lnyj421eQUmbTMP.png)

- objc_class结构体主要包含以下内容：   
    - superClass指针：指向Class，比如：如果是类对象，那么它的superClass指针指向的是它的父类对象。也就是类与父类之间的关系是通过objc_class中的superClass来定义的。
    - cache_t：是一个方法缓存的结构体，在消息传递过程中会使用到。
    - class_data_bits_t：关于类的变量、属性、方法都在class_data_bits_t结构体中。

[回到目录](#jump-1)


<h3 id="1-4">4. Class是否是对象？(什么是类对象？)</h3>

**Class是一个对象，称作类对象。**   
Class类型对应runtime底层的写法为objc_class结构体。  
objc_class结构体继承自objc_object结构体。  
objc_object结构体对应着id类型，而id类型是对象，所以Class是类对象。  

[回到目录](#jump-1)


<h3 id="1-5">5. isa指针的含义？</h3>

- isa指针是一个C++共用体类型(在objc_objct中被定义成isa_t)。
- 在64位架构上是64个0或者1的数字，在32位架构上是32个0或者1的数字。
- isa指针包括**指针型isa**和**非指针型isa**。（考点!）
    - 指针型isa：**isa的值**代表Class的地址。比如，objc_object对象可以通过isa内容来获取它的类对象的地址。
    - 非指针型isa：**isa的值的部分**代表Class的地址。比如，在64位架构，其中的30多位代表Class的地址，多出的位置可以用来存储其他相关内容已达到节省内存的目的。这也是有两种isa的初衷。

<!-- ![isa指针](./images/runtime/isaPointer.png) -->
![isaPointer.png](https://i.loli.net/2020/06/04/1SP8FxXw4L9pcAf.png)

[回到目录](#jump-1)


<h3 id="1-6">6. isa指针的指向？</h3>

- 实例对象的isa指针指向其对应的类对象。  
objc_object的isa指针指向它对应的Class。

- 类对象的isa指针指向其对应的元类对象。  
Class类对象的isa指针指向它对应的MetaClass。

**可以查看问题2中的源代码**

<!-- ![isa指针的指向](./images/runtime/isaPointerTo.png) -->
![isaPointerTo.png](https://i.loli.net/2020/06/04/GivQJUBnzWXawkO.png)

注意：
- 实例方法：**- 号方法**，必须通过实例化的对象调用。
- 类方法：**+ 号方法**，不需要实例化对象就可以调用。

[回到目录](#jump-1)


<h3 id="1-7">7. 介绍一下objc_class结构体里的cache_t</h3>

#### cache_t的特点
- 用于**快速**查找方法的执行函数

- 是可**增量扩展**的**哈希表**结构  
增量扩展：当存储的量在增大，它也扩展自己的内存空间来支持更多的缓存。  
哈希表：为了提高查找效率。

- 是**局部性原理**的最佳应用  
局部性原理：调用频次高的方法放在缓存里，下次的命中率会高些。

#### cache_t的数据结构
- cache_t是一个数组，包含多个bucket_t结构体。
- bucket_t包含两个成员变量：key和IMP。  
key对应OC的selector选择器名称；IMP是一个无类型的函数指针，对应方法的实现。  
比如，**给出一个key，通过哈希算法找出key对应的位于cache_t的位置，然后通过提取IMP来调用函数。**

<!-- ![cache_t的数据结构](./images/runtime/cache_t.png) -->
![cache_t.png](https://i.loli.net/2020/06/04/bjQJ9XFuzdm1eOc.png)

[回到目录](#jump-1)


<h3 id="1-8">8. 介绍一下objc_class结构体里的class_data_bits_t</h3>

- class_data_bits_t是对class_rw_t的封装。包含协议、属性、方法等内容。  
- class_rw_t：类相关的读写信息，是对class_ro_t的封装。  
- class_ro_t：类相关的只读信息。  
注意：  
rw = readwrite  
ro = readonly   

#### 8.1 class_rw_t
<!-- ![class_rw_t结构体的解析](./images/runtime/class_rw_t.png) -->
![class_rw_t.png](https://i.loli.net/2020/06/04/yPBF2ODmoe3R4NK.png)

#### 8.2 class_ro_t
<!-- ![class_ro_t结构体的解析](./images/runtime/class_ro_t.png) -->
![class_ro_t.png](https://i.loli.net/2020/06/04/6zfOnmBu8YSpcrM.png)

[回到目录](#jump-1)


<h3 id="1-9">9. 简述一下method_t</h3>

**函数的四要素：**
- 名称
- 返回值
- 参数
- 函数体

**method_t是对函数四要素的封装。**
<!-- ![method_t结构体的解析](./images/runtime/method_t.png) -->
![method_t.png](https://i.loli.net/2020/06/04/rQUemAD1B5I2HMJ.png)

**Type Encodings**
```
const char *types;
```
函数的返回值类型 + 参数个数(包括每个参数的类型)
<!-- ![TypeEncodings](./images/runtime/TypeEncodings.png) -->
![TypeEncodings.png](https://i.loli.net/2020/06/04/S2X9TnVkGeODPux.png)
**举例：**
<!-- ![TypeEncodingsExample](./images/runtime/TypeEncodingsExample.png) -->
![TypeEncodingsExample.png](https://i.loli.net/2020/06/04/jdHn1JMUsTclgeo.png)

[回到目录](#jump-1)


<h2 id="2">二. 类对象和元类对象</h2>

<h3 id="2-1">1. 类对象和元类对象分别是什么？实例对象与类对象之间的关系？类对象和元类对象的区别和联系？</h3>

#### 1.1 类对象和元类对象分别是什么
- 类对象：是一种**存储实例方法列表**等信息的数据结构。
- 元类对象：是一种**存储类方法列表**等信息的数据结构。

#### 1.2 实例和类对象的关系 
实例对象通过isa指针找到其对应的类对象，从而可以访问类对象里存储的实例方法列表等信息。

#### 1.3 类对象和元类对象的关系
类对象通过isa指针找到其对应的元类对象，从而可以访问元类对象里存储的类方法列表等相关信息。

<!-- ![类对象和元类对象](./images/runtime/classAndMetaClass.png) -->
![classAndMetaClass.png](https://i.loli.net/2020/06/04/HncBlke8UvmZVy4.png)

#### 1.4 类对象和元类对象的区别和联系
以下知识点都可以当成面试题
- 实例对象通过isa指针找到其对应的类对象，从而可以访问类对象里存储的实例方法列表等信息。
- 类对象通过isa指针找到其对应的元类对象，从而可以访问元类对象里存储的类方法列表等相关信息。
- 类对象和元类对象都是objc_class结构体，由于objc_class继承了objc_object，所以它们有isa指针，进而才能实现上面所述的关系。
- 任何一个元类对象的isa指针都指向其对应的根元类对象。(元类对象是objc_class结构体，所以它有isa指针)
- 根元类对象的isa指针指向其自身。
- 根元类对象的superclass指针指向的是根类对象。(比如，当我们调用的类方法在元类对象的类方法列表里查找不到的时候，它就会找根类对象当中同名的实例方法的实现。)
- 根类对象的superclass指针指向nil。

[回到目录](#jump-2)


<h3 id="2-2">2. 如果我们调用的类方法没有对应的实现，但是有同名的实例方法的实现，那么这时会不会发生crash？或者会不会产生实际的调用？</h3>
 
由于根元类对象的superclass指针指向了根类对象，当我们在元类对象的类方法列表中没有找到对应的类方法实现的时候，就会顺着superclass指针去根类对象的实例方法列表中查找，如果有同名的方法，那么就会实行同名方法的实例方法调用。

[回到目录](#jump-2)


<h2 id="3">三. 消息传递机制</h2>

<h3 id="3-1">1. 请描述一下消息传递过程</h3>  

#### 调用类方法(类方法的传递流程)  
- 通过当前类对象的isa指针找到其对应的元类对象，在元类对象中遍历类方法列表去查找同名的方法实现。  
- 如果没有查找到，当前元类对象会通过它的superClass指针的指向去查找父元类对象的类方法列表。
- 如果没有查找到，父元类对象通过superClass指针再顺次查找直到根元类对象的方法列表。
- 如果没有查找到，通过根元类对象的superclass指针找到其根类对象，查找同名的实例方法。
- 如果没有查找到，就会走消息转发流程。

#### 调用实例方法(实例方法的传递流程)  
- 通过当前实例对象的isa指针找到其对应的类对象，在类对象中遍历实例方法列表去查找同名的方法实现。  
- 如果没有查找到，当前类对象会通过它的superClass指针的指向去查找父类对象的实例方法列表。  
- 如果没有查找到，父类对象通过superClass指针再顺次查找直到根类对象的实例方法列表。  
- 如果没有查找到，就会走消息转发流程。 

![classAndMetaClass.png](https://i.loli.net/2020/06/04/HncBlke8UvmZVy4.png)

[回到目录](#jump-3)


<h3 id="3-2">2. objc_msgSend()和objc_msgSendSuper()的区别？</h3>

消息传递 = 函数调用

#### objc_msgSend()
```
void objc_msgSend(void /* id self, SEL op, ... */ )
```
- 参数1：消息传递的接收者 
- 参数2：传递的消息名称/方法选择器

举例：[self class] => objc_msgSend(self, @selector(class))

#### objc_msgSendSuper()
```
void objc_msgSendSuper(void /* struct objc_super *super, SEL op, ... */ )
```
- 参数1：objc_super结构体 
- 参数2：传递的消息名称/方法选择器

举例：[super class] => objc_msgSendSuper(super, @selector(class))

objc_super结构体
```
#ifndef OBJC_SUPER
#define OBJC_SUPER

/// Specifies the superclass of an instance. 
struct objc_super {
    /// Specifies an instance of a class. 指定类的实例。
    __unsafe_unretained id receiver; // 消息的实际接收者是当前对象

    /// Specifies the particular superclass of the instance to message. 
#if !defined(__cplusplus)  &&  !__OBJC2__
    /* For compatibility with old objc-runtime.h header */
    __unsafe_unretained Class class;
#else
    __unsafe_unretained Class super_class;
#endif
    /* super_class is the first class to search */
};
#endif
``` 

**注意**：  
objc_msgSendSuper(super, @selector(class))的super里包含的receiver就是当前对象即self。  
所以，**无论是调用[self class]还是[super class]，消息的实际接收者都是当前对象self。**

[回到目录](#jump-3)

<h3 id="3-3">3. 代码如下图所示，[self class]和[super class]打印出来的内容是什么？</h3>
 
<!-- ![classAndMetaClassExample](./images/runtime/classAndMetaClassExample.png) -->
![classAndMetaClassExample.png](https://i.loli.net/2020/06/04/jAfaxET8u3ZHFMr.png)

回答：  
**打印结果都是：Phone**  
- [self class] => objc_msgSend(self, @selector(class))  
- [super class] => objc_msgSendSuper(super, @selector(class))  
- super是objc_super结构体，里面有一个receiver，它代表当前对象即self。  
所以，无论是调用[self class]还是[super class]，消息的实际接收者都是当前对象self。  

具体分析请参考上一题。

[回到目录](#jump-3)


<h3 id="3-4">4. [obj foo]和objc_msgSend()函数之间有什么关系？</h3>

[obj foo] => objc_msgSend(obj, @selector(foo))  

runtime消息传递过程如下：
1. 通过obj的isa指针找到其对应的Class；  
在Class的cache中，通过哈希算法来查找foo对应的位于cache的位置，如果存在，则提取这个位置里面的IMP实现方法；  
(cache_t是一个数组，包含多个bucket_t结构体。bucket_t包含两个成员变量：key和IMP。key对应OC的selector选择器名称；IMP是一个无类型的函数指针，对应方法的实现。)    
如果cache里不存在，那么在method list里查找foo；如果找到foo函数，就去执行它的IMP的实现，并且把foo作为key，把foo函数作为IMP给保存到bucket_t添加到cache_t数组；
2. 如果在Class的cache和method list里都没有查找到，那么在Class中通过superClass指针去查找父类直到根类Root Class，循环步骤1所做的事情；
3. 如果没有查找到，就会走消息转发流程。

[回到目录](#jump-3)


<h3 id="3-5">5. runtime是如何通过selector找到对应的IMP地址的？</h3>
 
1. 查找当前实例所对应的类对象的缓存是否有selector对应的缓存的IMP实现。  
如果缓存有命中，将缓存中的函数返还给调用方。  
2. 如果缓存没有命中，则在当前类的方法列表查找selector对应的具体的IMP实现。  
3. 如果当前类没有命中，则在当前类的superclass逐级查找父类的方法列表，查找selector对应的具体的IMP实现。

[回到目录](#jump-3)


<h3 id="3-6">6. 当我们进行消息传递的过程中，如何进行缓存的方法查找？/缓存查找的具体流程和步骤</h3>

思路：给定值是SEL，目标值是对应bucket_t中的IMP。

类对象中有一个cache_t结构体，用来存放缓存。  
cache_t数组包含多个bucket_t结构体。  
bucket_t是方法选择器(selector)和方法实现(IMP)的封装。 

**哈希查找**：根据方法选择器通过一个函数来映射出对应的bucket_t在cache_t数组中的索引位置，提取对应的IMP实现。

[回到目录](#jump-3)


<h3 id="3-7">7. 消息转发流程是怎样的？</h3>

<!-- ![MessageForwardingProcess_01](./images/runtime/MessageForwardingProcess_01.png)
![MessageForwardingProcess_02](./images/runtime/MessageForwardingProcess_02.png)
![MessageForwardingProcess_03](./images/runtime/MessageForwardingProcess_03.png) -->

当走消息转发流程的时候会顺次执行以下方法直到找到或者没找到。  

举例：实例方法的消息转发流程  
- resolveInstanceMethod:
- forwardingTargetForSelector:
- methodSignatureForSelector:
  - 如果返回了方法签名，那么执行forwardInvocation: => 消息已处理/消息无法处理
  - 如果返回了nil => 消息无法处理

![MessageForwardingProcess_01.png](https://i.loli.net/2020/06/04/er5zmyavJ2nQ917.png)
![MessageForwardingProcess_02.png](https://i.loli.net/2020/06/04/kyaCYdioUJSb3WP.png)
![MessageForwardingProcess_03.png](https://i.loli.net/2020/06/04/JxR9jIS3KymHM2Z.png)

完整代码实例请查看：[InterviewSummary工程](https://github.com/mickychiang/iOSInterviewMemo/tree/master/InterviewSummary/InterviewSummary)

[回到目录](#jump-3)


<h2 id="4">四. runtime应用场景</h2>

<h3 id="4-1">1. Method Swizzling是什么？实际应用场景？(Method Swizzling)</h3>

runtime应用 - 方法交换

#### 1.1 Method Swizzling

Method Swizzing是发生在运行时的，主要用于在运行时将两个Method进行交换。  
我们可以将Method Swizzling代码写到任何地方，但是只有在这段Method Swilzzling代码执行完毕之后互换才起作用。

<!-- ![methodSwizzling](./images/runtime/methodSwizzling.png) -->
![methodSwizzling.png](https://i.loli.net/2020/06/04/a8Ae6RgPC39xpvY.png)

#### 1.2 简单实现(不是最佳写法，仅当例子参考)
<!-- ![methodSwizzling_01](./images/runtime/methodSwizzling_01.png)
![methodSwizzling_02](./images/runtime/methodSwizzling_02.png)
![methodSwizzling_03](./images/runtime/methodSwizzling_03.png) -->
![methodSwizzling_01.png](https://i.loli.net/2020/06/04/UNO4i6mSs85RarG.png)
![methodSwizzling_02.png](https://i.loli.net/2020/06/04/8MyPfZQnhrA7uO4.png)
![methodSwizzling_03.png](https://i.loli.net/2020/06/04/q8DKn2Zl7fcP4vz.png)

简单实现的完整代码请查看：[InterviewSummary工程](https://github.com/mickychiang/iOSInterviewMemo/tree/master/InterviewSummary/InterviewSummary)

#### 1.3 方法交换的最佳写法
- Swizzling应该总在+load中执行
- Swizzling应该总是在dispatch_once中执行
- Swizzling在+load中执行时，不要调用[super load]。  
如果多次调用了[super load]，可能会出现“Swizzle无效”的假象。
- 为了避免Swizzling的代码被重复执行，我们可以通过GCD的dispatch_once函数来解决，利用dispatch_once函数内代码只会执行一次的特性。

<!-- ![methodSwizzlingAboutInstanceAndClass](./images/runtime/methodSwizzlingAboutInstanceAndClass.png) -->
![methodSwizzlingAboutInstanceAndClass.png](https://i.loli.net/2020/06/05/rdkM3Aznxlf9bP6.png)

#### 1.4 实际应用场景
- 统计VC加载次数并打印
- 防止UI控件短时间多次激活事件
- 防奔溃处理：数组越界问题

实际应用场景的完整代码请查看：[RuntimeDemo工程](https://github.com/mickychiang/iOSInterviewMemo/tree/master/RuntimeDemo/RuntimeDemo)

[回到目录](#jump-4)


<h3 id="4-2">2. 你是否使用过performSelector:方法？实际应用场景？(动态添加方法)</h3>

runtime应用 - 动态添加方法

#### 1.1 动态添加方法
一个类在编译时没有方法，在运行时才产生方法。

- 任何方法默认都有两个隐式参数：self、_cmd
- 什么时候调用：只要一个对象调用了一个未实现的方法就会调用这个方法进行处理
- 作用：动态添加方法，处理未实现

#### 1.2 简单实现

<!-- ![dynamicAddMethod](./images/runtime/dynamicAddMethod.png) -->
![dynamicAddMethod.png](https://i.loli.net/2020/06/04/XMVJWms95Gz72Ab.png)

简单实现的完整代码请查看：[InterviewSummary工程](https://github.com/mickychiang/iOSInterviewMemo/tree/master/InterviewSummary/InterviewSummary)

#### 1.3 实际应用场景
- performSelector

实际应用场景的代码待整理。。。

[回到目录](#jump-4)


<h3 id="4-3">3. 编译时语言与OC这种运行时语言的区别？(动态方法解析)</h3>

runtime应用 - 动态方法解析@dynamic

- 编译时语言：在编译期进行函数决议。  
在编译期，我们就确定了一个方法名称所对应的函数执行体是哪个，在运行时是无法修改的。

- 动态运行时语言：将函数决议推迟到运行时。  
在运行时为方法添加具体的执行函数。  
当@dynamic修饰属性的时候，表示不需要编译器在编译时为我们生成属性的getter和setter方法的具体实现，而是在运行时调用了getter和setter时再去为它们添加具体的实现。

[回到目录](#jump-4)


<h3 id="4-4">4. 能否向编译后的类中添加实例变量？能否向运行时创建的类中添加实例变量？</h3>

- 不能向编译后的类中添加实例变量  
因为编译后的类已经注册在 runtime 中，类结构体中的 objc_ivar_list 实例变量的链表和 instance_size 实例变量的内存大小已经确定，同时 runtime 会调用 class_setIvarLayout 或 class_setWeakIvarLayout 来处理 strong weak 引用。所以不能向存在的类中添加实例变量。
- 可以向运行时创建的类中添加实例变量   
运行时创建的类是可以添加实例变量，调用 class_addIvar 函数。但是得在调用 objc_allocateClassPair 之后，objc_registerClassPair 之前，原因同上。

[回到目录](#jump-4)


<h2 id="5">五. 消息传递机制具体解析（完整具体答案）</h2>

**缓存是否命中 => 当前类的方法列表是否命中 => 逐级父类的方法列表是否命中 => 消息转发流程**
<!-- ![消息传递机制的流程图](./images/runtime/messageSend.png) -->
![messageSend.png](https://i.loli.net/2020/06/04/MjWKT7goPQdfNtn.png)

### 1. 缓存中查找

举例：给定值是SEL，目标值是对应bucket_t中的IMP。  
注意：bucket_t是方法选择器selector和方法实现IMP的封装。

**根据给定的方法选择器，来查找它对应的方法实现。**  
根据选择器因子到cache_t把对应的bucket_t查找出来。

**缓存查找是一个哈希查找**：  
根据给定的方法选择器通过一个函数来映射出对应的bucket_t在数组中的索引位置。  
作用：利用哈希查找来提高查找效率。
<!-- ![缓存查找](./images/runtime/cacheSearch.png) -->
![cacheSearch.png](https://i.loli.net/2020/06/04/3Xi5UCl8pqNPtVT.png)

### 2. 当前类中查找
- 对于**已排序**的列表，采用**二分查找算法**来查找方法对应的执行函数实现。
- 对于**没有排序**的列表，采用**一般遍历**来查找方法对应的执行函数实现。

### 3. 父类逐级查找
当前类的superClass指针向上查找。  
父类缓存 => 父类方法列表 => 逐级向上。
<!-- ![父类逐级查找流程图](./images/runtime/superClassLevelByLevelSearch.png) -->
![superClassLevelByLevelSearch.png](https://i.loli.net/2020/06/04/AJChpINQufeygnV.png)

### 4. 消息转发流程
<!-- ![消息转发流程](./images/runtime/MessageForwardingProcess.png) -->
![MessageForwardingProcess.png](https://i.loli.net/2020/06/04/bWsKaNhVS53RIc8.png)

详细请看代码~

# 参考文档

《新浪微博资深大牛全方位剖析 iOS 高级面试》  
[iOS开发·runtime原理与实践: 方法交换篇(Method Swizzling)(iOS“黑魔法”，埋点统计，禁止UI控件连续点击，防奔溃处理)](https://juejin.im/post/5aebc6ae6fb9a07aad1761a4)

# 其他
《iOS面试题备忘录》系列文章的github原文地址：  

[iOS面试题备忘录(一) - 属性关键字](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/PropertyModifier.md)    
[iOS面试题备忘录(二) - 内存管理](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/memoryManagement.md)   
[iOS面试题备忘录(三) - 分类和扩展](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/CategoryAndExtension.md)  
[iOS面试题备忘录(四) - 代理和通知](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/DelegateAndNSNotification.md)  
[iOS面试题备忘录(五) - KVO和KVC](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/KVOAndKVC.md)  
[iOS面试题备忘录(六) - runtime](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/runtime.md)  
[算法](https://github.com/mickychiang/iOSInterviewMemo/blob/master/Algorithm/Algorithm.md)  
