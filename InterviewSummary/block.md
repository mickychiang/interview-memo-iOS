# iOS面试题备忘录(七) - block
所有源码基于[objc-runtime-objc.680版本](https://opensource.apple.com/source/objc4/) 

# 前言
《iOS面试题备忘录(七) - block》是关于iOS的block的相关知识点及面试题的整理，难易程度没做区分，即默认是必须掌握的内容。  
本篇内容会持续整理并不断更新完善，如果哪里有理解不正确的地方请路过的大神告知，共勉。  
**可通过目录自行检测掌握程度**   
[github原文地址](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/block.md)  
本篇代码详细内容请至[Block工程](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/BlockDemo)  

![BlockSummary.png](https://i.loli.net/2020/06/20/k3GhWRo6gUSqL4M.png)

# 目录

[<span id="jump-1"><h2>一. Block的本质</h2></span>](#1)
[1. 什么是Block？什么是Block调用？](#1-1)  

[<span id="jump-2"><h2>二. Block特性：截获变量</h2></span>](#2)
[1. 是否了解Block的截获变量的特性？/ Block的截获变量的特性是怎样的？](#2-1)  
[2. 以下代码分别输出什么结果？](#2-2)  
![question_01.png](https://i.loli.net/2020/06/20/2bc75xuTjWRN8G1.png)    
![question_02.png](https://i.loli.net/2020/06/20/x8ZUluEamyGNB1I.png)  

[<span id="jump-3"><h2>三. __block修饰符</h2></span>](#3)
[1. 什么场景下使用__block修饰符？](#3-1)  
[2. 以下的两个场景中，是否需要添加__block修饰符？](#3-2)   
![__block_01.png](https://i.loli.net/2020/06/20/49NqpXro7kYcwPe.png)  
![__block_02.png](https://i.loli.net/2020/06/20/tP1VwUcCeDSx2zl.png)  
[3. 对变量进行赋值时，__block修饰符的具体使用特点？](#3-3)  
[4. 以下代码输出什么结果？](#3-4)
![question_03.png](https://i.loli.net/2020/06/20/yOGngWX6d9aQ17s.png)   

[<span id="jump-4"><h2>四. Block内存管理</h2></span>](#4)
[1. Block的种类以及内存分配？](#4-1)   
[2. 什么时候需要对Block进行copy操作？/ 对Block的copy操作的理解？](#4-2)   
[3. 对栈上的Block进行了copy操作之后，在MRC环境下是否会引起内存泄露？](#4-3)   
[4. __forwarding指针的存在有什么意义？](#4-4)   
[5. 以下的代码输出什么结果？](#4-5)  
![question_04.png](https://i.loli.net/2020/06/20/po7qj4Mt92iYLUe.png)

[<span id="jump-5"><h2>五. Block的循环引用</h2></span>](#5)
[1. 以下代码有什么问题？怎么解决？](#5-1)  
![question_05.png](https://i.loli.net/2020/06/20/pGAJISVO3bjxF12.png)  
[2. 以下代码有什么问题？怎么解决？](#5-2)  
![question_06.png](https://i.loli.net/2020/06/20/WUZJNz9hgkfSQK1.png)  
[3. 为什么Block会产生循环引用？](#5-3)  
[4. 你都遇到过哪些循环引用？你又是怎么解决的？](#5-4)   

# 正文

<h2 id="1">一. Block的本质</h2>

<h3 id="1-1">1. 什么是Block？什么是Block调用？</h3>

>Block：带有自动变量的匿名函数。 匿名函数：没有函数名的函数，一对{}包裹的内容是匿名函数的作用域。 自动变量：栈上声明的一个变量不是静态变量和全局变量，是不可以在这个栈内声明的匿名函数中使用的，但在Block中却可以。 虽然使用Block不用声明类，但是Block提供了类似Objective-C的类一样可以通过成员变量来保存作用域外变量值的方法，那些在Block的一对{}里使用到但却是在{}作用域以外声明的变量，就是Block截获的自动变量。

- Block是一个**Objective-C对象**，这个对象封装了**函数**和**函数的执行上下文**。  
- Block调用即**函数的调用**。

#### 源码解析  
使用如下命令，可以查看编译之后的文件内容    
```
clang -rewrite-objc BlockDemo.m
```  

**BlockDemo.m**  
```
#import "BlockDemo.h"

@implementation BlockDemo

- (void)method {
    int count = 6;
    int (^blockName)(int) = ^int(int num) {
        return num * count;
    };
    blockName(2);
}

@end
```

**BlockDemo.cpp**  
__block_impl结构体，即为Block的结构体，可理解为Block的类结构。  

![BlockDemo.cpp_01.png](https://i.loli.net/2021/04/10/F7MCSXzbRhaGrVL.png)

![BlockDemo.cpp_02.png](https://i.loli.net/2021/04/10/XZ5TvpRJFdIAEbf.png)

[回到目录](#jump-1)


<h2 id="2">二. Block特性：截获变量</h2>

<h3 id="2-1">1. 是否了解Block的截获变量的特性？/ Block的截获变量的特性是怎样的？</h3>

>Block表达式可截获所使用的自动变量的值。  
截获：保存自动变量的瞬间值。  
因为是“瞬间值”，所以声明Block之后，即便在Block外修改自动变量的值，也不会对Block内截获的自动变量值产生影响。

```  
int i = 10;  
void (^blk)(void) = ^{  
  NSLog(@"In block, i = %d", i);  
};  
i = 20; // Block外修改变量i，也不影响Block内的自动变量  
blk(); // i修改为20后才执行，打印: In block, i = 10  
NSLog(@"i = %d", i); // 打印：i = 20 
```

Block的截获变量的特性对于不同的变量是不同的。

- **局部变量**的截获：
    - 基本数据类型的局部变量的截获：截获其值。
    - 对象类型的局部变量的截获：**连同所有权修饰符**一起截获。
- **静态局部变量**的截获：以指针形式截获。
- **全局变量**的截获：不截获。
- **静态全局变量**的截获：不截获。

#### 源码解析  
使用如下命令，可以查看编译之后的文件内容  
```
clang -rewrite-objc -fobjc-arc MCBlock.m
```  

**MCBlock.m**
```
#import "MCBlock.h"

@implementation MCBlock

// 全局变量
int global_var = 4;

// 静态全局变量
static int static_global_var = 5;

- (void)method {
    
    // 局部变量(基本数据类型)
    int var = 1;
    
    // 局部变量(对象类型)
    __unsafe_unretained id unsafe_obj = nil;
    __strong id strong_obj = nil;
    
    // 静态局部变量
    static int static_var = 3;
    
    // ***** Block特性：截获变量 *****
    void(^Block)(void) = ^{
        // 1.1 局部变量<基本数据类型>的截获：截获其值。
        NSLog(@"局部变量<基本数据类型> var = %d", var);
        // 1.2 局部变量<对象类型>的截获：连同所有权修饰符一起截获。
        NSLog(@"局部变量<__unsafe_unretained 对象类型> var = %d", unsafe_obj);
        NSLog(@"局部变量<__strong 对象类型> var = %d", strong_obj);
        // 2. 静态局部变量的截获：以指针形式截获。
        NSLog(@"静态局部变量 var = %d", static_var);
        // 3. 全局变量的截获：不截获。
        NSLog(@"全局变量 var = %d", global_var);
        // 4. 静态全局变量的截获：不截获。
        NSLog(@"静态全局变量 var = %d", static_global_var);
    };
    
    var = 11;
    unsafe_obj = [[NSObject alloc] init];
    strong_obj = [[NSObject alloc] init];
    static_var = 33;
    global_var = 44;
    static_global_var = 55;
    
    Block();
}

@end
```

**输出：**
```
2021-04-10 15:50:46.668510+0800 BlockDemo[6226:179160] 局部变量<基本数据类型> var = 1
2021-04-10 15:50:46.668750+0800 BlockDemo[6226:179160] 局部变量<__unsafe_unretained 对象类型> var = 0
2021-04-10 15:50:46.668891+0800 BlockDemo[6226:179160] 局部变量<__strong 对象类型> var = 0
2021-04-10 15:50:46.669021+0800 BlockDemo[6226:179160] 静态局部变量 var = 33
2021-04-10 15:50:46.669142+0800 BlockDemo[6226:179160] 全局变量 var = 44
2021-04-10 15:50:46.669283+0800 BlockDemo[6226:179160] 静态全局变量 var = 55
```

**MCBlock.cpp**  
![MCBlock.cpp_var.png](https://i.loli.net/2021/04/10/FbEw6uJIcpU7dno.png) 

[回到目录](#jump-2)


<h3 id="2-2">2. 以下代码分别输出什么结果？</h3>

### 代码1
```
- (void)method {
    int multiplier = 6;
    int(^Block)(int) = ^int(int num) {
        return num * multiplier;
    };
    multiplier = 4;
    NSLog(@"result is %d", Block(2));
}
```

**输出**  
```
result is 12
```

block对于**基本数据类型的局部变量的截获是获取其值的**，所以在block代码块里multiplier为6。

### 代码2
```
- (void)method {
    static int multiplier = 6;
    int(^Block)(int) = ^int(int num) {
        return num * multiplier;
    };
    multiplier = 4;
    NSLog(@"result is %d", Block(2));
}
```

**输出**  
```
result is 8
```
因为block对于**静态局部变量的截获是获取其指针的**。当指针指向的内容从6变成了4，那么输出的就是4x2=8。

[回到目录](#jump-2)


<h2 id="3">三. __block修饰符</h2>

<h3 id="3-1">1. 什么场景下使用__block修饰符？</h3>

>自动变量截获的值为Block声明时刻的瞬间值，保存后就不能改写该值，如需对自动变量进行重新赋值，需要在变量声明前附加__block修饰符，这时该变量称为__block变量。

```
__block int i = 10; // i为__block变量，可在block中重新赋值  
void (^blk)(void) = ^{  
  NSLog(@"In block, i = %d", i);  
};  
i = 20;  
blk(); // 打印: In block, i = 20  
NSLog(@"i = %d", i); // 打印：i = 20  
```

一般情况下，对**被截获变量**进行**赋值操作**时需要**添加__block修饰符**。  

注意：**赋值操作 不等于 使用操作**  

[回到目录](#jump-3)


<h3 id="3-2">2. 以下的两个场景中，是否需要添加__block修饰符？</h3>

注意：**赋值操作 不等于 使用操作** 

### 场景1
```
- (void)method1 {
    NSMutableArray *array = [NSMutableArray array];
    void (^Block)(void) = ^{
        [array addObject:@123];
    };
    Block();
    NSLog(@"array is %@", array);
}
```

不需要加__block修饰符。在block内部只是对array进行了**使用操作**。

### 场景2
![__block_02.png](https://i.loli.net/2020/06/20/tP1VwUcCeDSx2zl.png)

没有__block修饰，编译失败。  
需要在array的声明处添加__block修饰符。  
因为在block内部，对array进行了**赋值操作**。   
更改为：  
```
- (void)method2 {
    __block NSMutableArray *array = nil;
    void (^Block)(void) = ^{
        array = [NSMutableArray array]; // 不加 __block 发生：Variable is not assignable (missing __block type specifier)
    };
    Block();
    NSLog(@"array is %@", array); // ()
}
```

[回到目录](#jump-3)


<h3 id="3-3">3. 对变量进行赋值时，__block修饰符的具体使用特点？</h3>

**__block修饰的变量最终会变成对象**。

- 需要__block修饰符  
局部变量(基本数据类型、对象类型)

- 不需要__block修饰符  
静态局部变量、全局变量、静态全局变量

[回到目录](#jump-3)


<h3 id="3-4">4. 以下代码输出什么结果？</h3>

```
- (void)method {
    __block int multiplier = 6;
    int(^Block)(int) = ^int(int num) {
        return num * multiplier;
    };
    multiplier = 4;
    NSLog(@"result is %d", Block(2));
}
```

**输出**  
```
result is 8
```

**解析**   
分析源码客可知： **__block修饰的变量最终会变成对象。**

![answer_03.png](https://i.loli.net/2020/06/20/bFaTc9VOzyMg57Q.png)

![answer_03_02.png](https://i.loli.net/2020/06/20/yE32OUBJzidZMGC.png)

[回到目录](#jump-3)


<h2 id="4">四. Block内存管理</h2>

<h3 id="4-1">1. Block的种类以及内存分配？</h3>

- _NSConcreteStackBlock：在栈上创建的Block对象
- _NSConcreteMallocBlock：在堆上创建的Block对象
- _NSConcreteGlobalBlock：在已初始化数据区的Block对象

#### Block的种类  
![BlockType.png](https://i.loli.net/2020/06/20/qcuKdsRx1WIPNmf.png)

#### Block的内存分配  
![BlockMemory.png](https://i.loli.net/2020/06/20/LxDr49my7zfgY6s.png)

[回到目录](#jump-4)


<h3 id="4-2">2. 什么时候需要对Block进行copy操作？/ 对Block的copy操作的理解？</h3>

#### Block复制 
配置在栈上的Block，如果其所属的栈作用域结束，该Block就会被废弃，对于超出Block作用域仍需使用Block的情况，Block提供了将Block从栈上复制到堆上的方法来解决这种问，即便Block栈作用域已结束，但被拷贝到堆上的Block还可以继续存在。  
复制到堆上的Block，将_NSConcreteMallocBlock类对象写入Block结构体实例的成员变量isa：
```
impl.isa = &_NSConcreteMallocBlock;
```

#### 什么时候需要对Block进行copy操作
在ARC有效时，大多数情况下编译器会进行判断，自动生成将Block从栈上复制到堆上的代码(或者直接在堆上创建Block对象)，以下几种情况栈上的Block会自动复制到堆上：
- 调用Block的copy方法
- 将Block作为函数返回值时（MRC时此条无效，需手动调用copy）
- 将Block赋值给__strong修改的变量时（MRC时此条无效）
- 向Cocoa框架含有usingBlock的方法或者GCD的API传递Block参数时

其它时候，向方法的参数中传递Block时，需要手动调用copy方法复制Block。

```
- (void)methodd {
    // 在函数栈上创建的blk，如果没有截获自动变量，Block的结构实例还是会被设置在程序的全局数据区，而非栈上
    
    void (^blk)(void) = ^{ // 没有截获自动变量的Block
        NSLog(@"Stack Block");
    };
    blk();
    NSLog(@"%@",[blk class]); // 打印：__NSGlobalBlock__

    int i = 1;
    void (^captureBlk)(void) = ^{ // 截获自动变量i的Block
        NSLog(@"Capture:%d", i);
    };
    captureBlk();
    NSLog(@"%@",[captureBlk class]); // 打印：__NSMallocBlock__

    // 可以看到在栈上：
    // 没有截获自动变量的Block 打印的类是NSGlobalBlock，表示存储在全局数据区。
    // 捕获自动变量的Block 打印的类却是设置在堆上的NSMallocBlock，而非栈上的NSStackBlock。
}
```

栈上截获了自动变量i的Block之所以在栈上创建，却是NSMallocBlock_类，是因为这个Block对象赋值给了 **__strong修饰的变量 captureBlk**(_strong是ARC下对象的默认修饰符)。   
因为上面四条规则，在ARC下其实很少见到_NSConcreteStackBlock类的Block，大多数情况编译器都保证了Block是在堆上创建的。  
如下代码所示，仅最后一行代码直接使用一个不赋值给变量的Block，它的类才是NSStackBlock：

```
- (void)methodd {
    int count = 0;
    void (^blk)(void) = ^(){
        NSLog(@"In Stack:%d", count);
    };
    
    NSLog(@"blk's Class:%@", [blk class]); // 打印：blk's Class:__NSMallocBlock__
    NSLog(@"Global Block: %@", [^{NSLog(@"Global Block");} class]); // 打印：Global Block: __NSGlobalBlock__
    NSLog(@"Copy Block: %@", [[^{NSLog(@"Copy Block:%d",count);} copy] class]); // 打印：Copy Block: __NSMallocBlock__
    NSLog(@"Stack Block: %@", [^{NSLog(@"Stack Block:%d",count);} class]); // 打印：Stack Block: __NSStackBlock__
}
```

对于不同类型的Block进行copy操作的结果不同。
- 栈Block的copy操作：在堆上产生了一个block。
- 堆Block的copy操作：增加了引用计数。
- 全局Block的copy操作：没有变化。

声明一个对象的成员变量是一个block。  
在栈上创建一个block，同时将这个block赋值给成员变量(block)。  
如果成员变量(block)没有使用copy关键字的话(比如使用了assign)，当我们通过成员变量去访问block时，可能会由于栈所对应的函数退出之后在内存中销毁掉而产生了crash。

![BlockCopy.png](https://i.loli.net/2020/06/20/aXlHmQpwSCsuUgd.png)

[回到目录](#jump-4)


<h3 id="4-3">3. 对栈上的Block进行了copy操作之后，在MRC环境下是否会引起内存泄露？</h3>

会。

栈上Block的copy之后会在堆上产生一个一样的block。  
在变量作用域结束之后，栈上的Block和__block变量会被销毁。  
而堆上的Block和__block变量仍然存在。 
即没有对应的release操作，会产生内存泄露的问题。

#### 栈上Block的销毁
栈上的Block和__block变量会在变量作用域结束之后，系统自动销毁。

![StackBlockDistory.png](https://i.loli.net/2020/06/20/XeP8F5AHZJc3YTu.png)

#### 栈上Block的copy
![StackBlockCopy.png](https://i.loli.net/2020/06/20/fqwvdrSgNsbyUOj.png)

栈上Block的copy之后会在堆上产生一个一样的block。  
在变量作用域结束之后，栈上的Block和__block变量会被销毁。  
而堆上的Block和__block变量仍然存在。  

[回到目录](#jump-4)


<h3 id="4-4">4. __forwarding指针的存在有什么意义？</h3>

![StackBlockVarCopy.png](https://i.loli.net/2020/06/20/wVjN5XHpbDcIeAo.png)

对栈上的__block变量进行copy操作之后，栈上的__block变量的__forwarding指针指向了堆上的__block变量。而堆上的__block变量的__forwarding指针指向其自身。

**不论在任何内存位置，都可以通过__forwarding指针顺利的访问同一个__block变量。**  
- 如果没有对栈上__block变量进行copy的话，实际的操作就是对栈上的__block变量。  
- 如果对栈上__block变量进行了copy操作之后，无论是在栈还是在堆，我们对__block变量的赋值操作都是对堆上的__block变量的操作。同时栈上的__block变量的使用也是使用了堆上的__block变量。

**BlockDemo2.m**
```
- (void)method {
    __block int count = 10;
    void (^blk)(void) = ^(){
        count = 20;
        NSLog(@"In Block: %d", count); //打印：In Block: 20
    };
    count ++;
    NSLog(@"Out Block: %d", count); //打印：Out Block: 11
    blk();
}
```

**BlockDemo2.cpp**
![BlockDemo2.cpp_01.png](https://i.loli.net/2021/04/10/pZIt1VWbMa6SwKo.png)

[回到目录](#jump-4)


<h3 id="4-5">5. 以下的代码输出什么结果？</h3>

```
typedef int(^DemoBlock)(int num);

@interface ViewController ()

@property (nonatomic, copy) DemoBlock blk;

@end


- (void)method {
    // 栈上创建的局部变量被__block修饰之后就会变成了一个对象。
    __block int multiplier = 10;
    // _blk是对象的成员变量，对它进行赋值操作的时候，实际上是对_blk的copy操作。
    // 在堆上产生一个一样的_blk副本。
    _blk = ^int(int num) {
        return num * multiplier; // multiplier 是堆上的变量。
    };
    // 不是对变量进行赋值，而是通过multiplier对象的__forwarding指针对其成员变量进行赋值。
    // 如果没有之前的_blk的copy操作，那么 multiplier = 6; 修改的是栈上的变量的值；
    // 如果之前对_blk进行了copy操作，那么 multiplier = 6; 修改的是堆上的副本变量的值。(栈上的变量的__forwarding指针会指向堆上的副本变量)
    multiplier = 6;
    [self executeBlock];
}

- (void)executeBlock {
    int result = _blk(4); // 调用了堆上的block
    NSLog(@"result is %d", result);
}
```

**输出**
```
result is 24
```

[回到目录](#jump-4)


<h2 id="5">五. Block的循环引用</h2>

<h3 id="5-1">1. 以下代码有什么问题？怎么解决？</h3>

![question_05.png](https://i.loli.net/2020/06/20/pGAJISVO3bjxF12.png)

会产生一个自循环引用。  
解决方案如下：  
**block截获的变量如果是一个对象类型的话，会连同其所有权修饰符一起截获。**  
如果在外部定义的对象是__weak修饰的，那么在block结构体中持有的变量也是__weak，所以避免了自循环引用。  
![answer_05.png](https://i.loli.net/2020/06/20/VZ7stQSNcRAy4Gk.png)

[回到目录](#jump-5)


<h3 id="5-2">2. 以下代码有什么问题？怎么解决？</h3>

![question_06.png](https://i.loli.net/2020/06/20/WUZJNz9hgkfSQK1.png)

- 在MRC下，不会产生循环引用。
- 在ARC下，会产生多循环引用，引起内存泄漏。  
通过断环来规避循环引用。  
![answer_06.png](https://i.loli.net/2020/06/20/8tviU2urP1Y3XGk.png)

解决方案如下：
![answer_06_02.png](https://i.loli.net/2020/06/20/VKLvpFDg7Zyk21X.png)  
这种解决方案有个弊端，如果我们很长时间才调用block或者永远不会调用的话，这个循环引用的环就会一直存在。

[回到目录](#jump-5)


<h3 id="5-3">3. 为什么Block会产生循环引用？</h3>

- 如果block截获了当前对象的一个变量，就会对这个变量有个强引用。    
而当前对象对block也有一个强引用，这样就会造成自循环引用。  
可以使用__weak修饰变量。
- 如果__block修饰变量，在MRC下，不会产生循环引用；在ARC下，会产生多循环引用，引起内存泄漏，可以通过断环的方式解决。  

[回到目录](#jump-5)


<h3 id="5-4">4. 你都遇到过哪些循环引用？你又是怎么解决的？</h3>

- block
根据面试题1和2来回答。 
```
__weak typeof(self) weakSelf = self;
self.blk = ^{
    __strong typeof(self) strongSelf = weakSelf;
    NSLog(@"Use Property:%@", strongSelf.name);
    //……
};
self.blk();
```

```
self.blk = ^(UIViewController *vc) {
    NSLog(@"Use Property:%@", vc.name);
};
self.blk(self);
```

- NSTimer


[回到目录](#jump-5)


# 参考文档
《新浪微博资深大牛全方位剖析 iOS 高级面试》   
[Block 深入浅出](https://www.jianshu.com/p/157ee1dfedb2)  