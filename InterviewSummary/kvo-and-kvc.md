# iOS面试题备忘录(五) - KVO和KVC
所有源码基于[objc-runtime-objc.680版本](https://opensource.apple.com/source/objc4/)  


# 前言
《iOS面试题备忘录(五) - KVO和KVC》是关于iOS的KVO和KVC的知识点及面试题的整理。  
本篇内容会一直持续整理并完善，有理解不正确的地方请路过的大神告知，共勉。  


<span id="jump"><h1>目录</h1></span>

[<span id="jump-1"><h2>一. KVO</h2></span>](#1)
[<span id="jump-1-1">1. 什么是KVO？</span>](#1-1)  
[<span id="jump-1-2">2. KVO的实现原理？[※※※※※]</span>](#1-2)  
[<span id="jump-1-3">3. isa混写技术怎样实现KVO？[※※※※※]</span>](#1-3)  
[<span id="jump-1-4">4. 子类重写setter方法的逻辑和具体实现？[※※※※※]</span>](#1-4)  
[<span id="jump-1-5">5. KVO具体的代码实现</span>](#1-5)  
[<span id="jump-1-6">6. 手动实现KVO[※※※※※]</span>](#1-6)  
[<span id="jump-1-7">7. KVO生效的三种场景[※※※※※]</span>](#1-7)  
[<span id="jump-1-8">8. Swift中KVO与计算型属性的关系？</span>](#1-8)    

[<span id="jump-2"><h2>二. KVC</h2></span>](#2)
[<span id="jump-2-1">1. 什么是KVC？</span>](#2-1)  
[<span id="jump-2-2">2. 我们使用KVC键值编码技术是否会破坏面向对象的编程方法？[※※※]</span>](#2-2)  
[<span id="jump-2-3">3. valueForKey:的实现流程</span>](#2-3)  
[<span id="jump-2-4">4. setValue:forKey:的实现流程</span>](#2-4)  


# 正文
<h2 id="1">一. KVO</h2>

<h3 id="1-1">1. 什么是KVO？</h3>

KVO是Key-value observing的缩写。KVO是Objective-C对**观察者设计模式**的一种实现。系统使用**isa混写技术**(isa-swizzling)来实现KVO。

[回到目录](#jump-1)

<h3 id="1-2">2. KVO的实现原理？[※※※※※]</h3>

- KVO是系统对于**观察者模式**的一种实现。  
- KVO运用**isa混写技术**在**动态运行时为某一个类添加一个子类并重写子类的setter方法，同时把原有类的isa指针指向新创建的子类**。

[回到目录](#jump-1)


<h3 id="1-3">3. isa混写技术怎样实现KVO？[※※※※※]</h3>

- 当类A的实例对象注册观察者的时候，调用了`addObserver:forKeyPath:options:context:`方法，系统会在运行时动态创建一个名叫`NSKVONotifying_A`的类，同时将A的isa指针指向NSKVONotifying_A。    
- 类NSKVONotifying_A是类A的子类，类NSKVONotifying_A继承类A是为了重写原来类A中的setter方法，**重写的setter方法负责通知所有观察对象**。

![KVO-isa-swizzling.png](https://ae01.alicdn.com/kf/Ha703a062bfde417ca665c43beb5e9bf69.jpg)

[回到目录](#jump-1)


<h3 id="1-4">4. 子类重写setter方法的逻辑和具体实现？[※※※※※]</h3>

- 子类NSKVONotifying_A中**重写的setter方法**中**添加**了以下两个方法
  ```
  - (void)willChangeValueForKey:(NSString *)key;
  - (void)didChangeValueForKey:(NSString *)key;
  ```
- `didChangeValueForKey:`方法会触发KVO的回调方法`observeValueForKeyPath:ofObject:change:context:`
- `observeValueForKeyPath:ofObject:change:context:`来通知观察者value发生了变化

**子类重写setter方法的具体代码解析示例：**
![KVO-setteroverride.png](https://ae01.alicdn.com/kf/H1070d32d575c4e0f96a47c45f05e47c2p.jpg)

[回到目录](#jump-1)


<h3 id="1-5">5. KVO具体的代码实现</h3>

完整代码实例请查看：[InterviewSummary工程](https://github.com/mickychiang/iOSInterviewMemo/tree/master/InterviewSummary/InterviewSummary)
##### 5.1 创建了类MObject和类MObserver

MObject.h  
![MObject-h.png](https://ae01.alicdn.com/kf/H585a9904ac0645b9b484da390423798ec.jpg)

MObject.m  
![MObject-m.png](https://ae01.alicdn.com/kf/H71272f181290477094e3a6cf290037b6m.jpg)

MObserver.h  
![MObserver-h.png](https://ae01.alicdn.com/kf/Hedff11f1d1374d48a130ac741931ff3bK.jpg)

MObserver.m  
![MObserver-m.png](https://ae01.alicdn.com/kf/H64e0a381d300497ab1c34ab922f63308n.jpg)

##### 5.2 实现KVO
![KVOTest.png](https://ae01.alicdn.com/kf/H9f0ddb73bd1640388f01bcd6f22f3582e.jpg)

[回到目录](#jump-1)


<h3 id="1-6">6. 手动实现KVO[※※※※※]</h3>

- 在**对成员变量直接赋值**的时候，在它之前和之后分别添加`willChangeValueForKey:`方法和`didChangeValueForKey:`方法，就可以实现手动KVO。  
- `didChangeValueForKey:`在系统内部实现当中会触发KVO的回调方法`observeValueForKeyPath:ofObject:change:context:`方法。

![KVO-ManuallyRealize.png](https://i.loli.net/2020/06/16/5KWvSyLxk71mRil.png)

[回到目录](#jump-1)


<h3 id="1-7">7. KVO生效的三种场景[※※※※※]</h3>

- 调用KVO监听obj的value属性的变化，obj**通过setter方法修改value**。  
- 通过KVC设置value，即**使用setValue:forKey:改变value**，KVO可以生效。  
  为什么通过KVC设置value，KVO能生效？  
  KVC的实现机制和原理  
  通过KVC调用，最终会调用到obj对象的setter方法，系统为我们重写了setter方法可以实现KVO。
- **成员变量直接修改**需要**手动添加**`willChangeValueForKey`和 `didChangeValueForKey`才会生效。  

[回到目录](#jump-1)


<h3 id="1-8">8. Swift中KVO与计算型属性的关系？</h3>

KVO方法如下：
```
// 1: 添加观察
person.addObserver(self, forKeyPath: "name", options: .new, context: nil)
// 2: 观察响应回调
override func observeValue(forKeyPath keyPath:, of object:, change: , context:）{}
// 3: 移除观察
person.removeObserver(self, forKeyPath: "name")
```

平时在开发的时候，我们可以通过计算型属性直接观察
```
var name: String = "" {
    willSet {
        print(newValue)
    }
    didSet {
        print(oldValue)
    }
}
```

根据分析[Swift官方源码](https://github.com/apple/swift)可知：  
计算型属性在**willSet**里面就调用**willChangeValue**，在**didSet**调用**didChangeValue**，计算型属性和KVO相关方法是有所关联的。

[回到目录](#jump-1)


<h2 id="2">二. KVC</h2>

<h3 id="2-1">1. 什么是KVC？</h3>

KVC是Key-value coding的缩写。键值编码技术。
```
- (nullable id)valueForKey:(NSString *)key;
- (void)setValue:(nullable id)value forKey:(NSString *)key;
```
[回到目录](#jump-2)


<h3 id="2-2">2. 我们使用KVC键值编码技术是否会破坏面向对象的编程方法？[※※※]</h3>

KVC会破坏面向对象编程的封装特性。  
key没有任何限制，如果已知某个类或者实例的内部某个私有成员变量名称的话，我们在外界是可以通过已知的key来访问和设置。即破坏了面向对象的编程思想。  

[回到目录](#jump-2)


<h3 id="2-3">3. valueForKey:的实现流程</h3>

首先查找是否存在与key名称相同的get方法，再查找是否存在与key名称相同的实例变量，最后查询是否存在与key名称相同的属性 

- 访问器方法(Accessor Method)是否存在的判断规则  
getKey  
key  
isKey  

- 实例变量(Instance var)是否存在的判断规则  
_key  
_isKey  
key  
isKey  

![valueForKey.png](https://ae01.alicdn.com/kf/Hf09952080680459f853a3bf76d68b18ew.jpg)

[回到目录](#jump-2)


<h3 id="2-4">4. setValue:forKey:的实现流程</h3>


![setValueforKey.png](https://ae01.alicdn.com/kf/H00aed6e321d1442ea1928524ab7976e0u.jpg)

- 程序优先调用set<Key>:属性值方法，代码通过setter方法完成设置。注意，这里的<key>是指成员 变量名，首字母大小写要符合 KVC 的命名规则，下同
- 如果没有找到setName:方法，KVC机制会检查+(BOOL)accessInstanceVariablesDirectly方法有 没有返回 YES，默认该方法会返回 YES，如果你重写了该方法让其返回 NO 的话，那么在这一步 KVC 会执行 setValue:forUndefinedKey:方法，不过一般开发者不会这么做。所以 KVC 机制会搜索该类 里面有没有名为<key>的成员变量，无论该变量是在类接口处定义，还是在类实现处定义，也无论用 了什么样的访问修饰符，只在存在以<key>命名的变量，KVC 都可以对该成员变量赋值。
- 如果该类即没有set<key>:方法，也没有_<key>成员变量，KVC机制会搜索_is<Key>的成员变量。
- 和上面一样，如果该类即没有set<Key>:方法，也没有_<key>和_is<Key>成员变量，KVC机制再会
继续搜索<key>和 is<Key>的成员变量。再给它们赋值。
- 如果上面列出的方法或者成员变量都不存在，系统将会执行该对象的setValue:forUndefinedKey: 方法，默认是抛出异常。

即如果没有找到 Set<Key>方法的话，会按照_key，_iskey，key，iskey 的顺序搜索成员并进行赋值操作。
如果开发者想让这个类禁用 KVC，那么重写+
即可，这样的话如果 KVC 没有找到 set<Key>:属性名时，会直接用   :   :方法。
方法让其返回 NO

[回到目录](#jump-2)


# 参考文档

《新浪微博资深大牛全方位剖析 iOS 高级面试》  
[RxSwift（8）—— KVO底层探索（上）](https://www.jianshu.com/p/163c593bcf66)  
[RxSwift（9）—— KVO底层探索（下）](https://www.jianshu.com/p/7996efe382d8)  

