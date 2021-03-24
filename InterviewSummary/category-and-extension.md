# iOS面试题备忘录(三) - 分类和扩展
所有源码基于[objc-runtime-objc.680版本](https://opensource.apple.com/source/objc4/)

# 前言
《iOS面试题备忘录(三) - 分类和扩展》是关于iOS的分类和扩展的知识点及面试题的整理。  
本篇内容会一直持续整理并完善，有理解不正确的地方请路过的大神告知，共勉。  

<span id="jump"><h1>目录</h1></span>

[<span id="jump-1"><h2>一. 分类Category</h2></span>](#1)
[<span id="jump-1-1">1. 分类的书写规则？</span>](#1-1)  
[<span id="jump-1-2">2. 一般用分类做什么？/分类的应用场景？</span>](#1-2)  
[<span id="jump-1-3">3. 分类的特点是什么？</span>](#1-3)  
[<span id="jump-1-4">4. 分类中都可以添加哪些内容？[※※※]</span>](#1-4)  
[<span id="jump-1-5">5. 分类结构体的源码中包含哪些内容？</span>](#1-5)  
[<span id="jump-1-6">6. 为一个类添加了分类A和分类B，两个分类中分别添加了名字相同的实例方法，那么哪个分类的方法最终会生效？[※※※※※]</span>](#1-6)  
[<span id="jump-1-7">7. 分类添加的同名方法可以"覆盖"宿主类的方法吗？[※※※※※]</span>](#1-7)  
[<span id="jump-1-8">8. 分类的总结</span>](#1-8)  
[<span id="jump-1-9">9. 能否给分类添加"实例变量"？添加的"实例变量"存在于哪里？[※※※※※]</span>](#1-9)  
[<span id="jump-1-10">10. 关联对象的本质？[※※※※※]</span>](#1-10)  
[<span id="jump-1-11">11. 如何删除已经被关联到对象的值？[※※※※※]</span>](#1-11)  
[<span id="jump-1-12">12. 关联对象的数据结构</span>](#1-12)   
[<span id="jump-1-13">13. 请简述分类的实现原理？[※※※※※]</span>](#1-13) 

[<span id="jump-2"><h2>二. 扩展Extension</h2></span>](#2)
[<span id="jump-2-1">1. 一般用扩展做什么？/扩展的应用场景？</span>](#2-1)  
[<span id="jump-2-2">2. 扩展的特点是什么？</span>](#2-2)  
[<span id="jump-2-3">3. 分类和扩展有什么区别？可以分别用来做什么？分类有哪些局限性？分类的结构体里面有哪些成员？[※※※※※]</span>](#2-3)  

# 正文

<h2 id="1">一. 分类Category</h2>

<h3 id="1-1">1. 分类的书写规则？</h3>

```
// .h文件
@interface 宿主类类名（分类名）

@end

// .m文件
@implementation 宿主类类名（分类名）

@end
```

[回到目录](#jump-1)


<h3 id="1-2">2. 一般用分类做什么？/分类的应用场景？</h3>

- 声明私有方法  
定义一个分类，只把他的头文件放到宿主文件的.m当中，可以满足私有方法的声明和使用，对外不暴露。

- 分解体积庞大的类文件  
比如：这个类的功能复杂，可以按照功能对类中的一些方法进行分类。把同一功能的方法放到对应的一个分类文件中。 

- 把Framework的私有方法公开

[回到目录](#jump-1)


<h3 id="1-3">3. 分类的特点是什么？</h3>

- 运行时决议  
编写好分类文件之后，系统并没有把分类中添加的内容附加到相应的宿主类中，即宿主类中没有分类添加的内容，而是在运行时通过runtime把分类中添加的内容真实的添加到对应的宿主类中。

- 可以为系统类添加分类  
比如会经常使用分类为UI控件封装一些常用方法。

[回到目录](#jump-1)


<h3 id="1-4">4. 分类中都可以添加哪些内容？[※※※]</h3>

- 实例方法  
- 类方法  
- 协议  
- 属性：在分类中定义属性，实际上只声明了setter方法和getter方法，并没有生成对应的实例变量。可以通过**runtime的关联对象机制添加实例变量**。

[回到目录](#jump-1)


<h3 id="1-5">5. 分类结构体的源码中包含哪些内容？</h3>

分类结构体category_t的源码：
```
struct category_t {
    const char *name; // 分类的名称
    classref_t cls; // 分类的宿主类
    struct method_list_t *instanceMethods; // 实例方法列表
    struct method_list_t *classMethods; // 类方法列表
    struct protocol_list_t *protocols; // 协议列表
    struct property_list_t *instanceProperties; // 实例属性列表

    method_list_t *methodsForMeta(bool isMeta) {
        if (isMeta) return classMethods;
        else return instanceMethods;
    }

    property_list_t *propertiesForMeta(bool isMeta) {
        if (isMeta) return nil; // classProperties;
        else return instanceProperties;
    }
};
```

[回到目录](#jump-1)


<h3 id="1-6">6. 为一个类添加了分类A和分类B，两个分类中分别添加了名字相同的实例方法，那么哪个分类的方法最终会生效？[※※※※※]</h3>

**取决于分类的编译顺序。**  
**最后编译的分类当中的同名方法才会最终生效。前面的会被覆盖掉。**

源码解析
![sameNameCategoriesMethodWhoRun.png](https://i.loli.net/2020/05/23/kHIvFdMSh2GXj5W.png)

[回到目录](#jump-1)


<h3 id="1-7">7. 分类添加的同名方法可以"覆盖"宿主类的方法吗？[※※※※※]</h3>
 
分类添加的同名方法可以"覆盖"宿主类的方法。  
**宿主类的方法仍然存在**，但是由于消息函数方法查找过程中根据选择器名称查找，一旦找到对应的实现就返回。  
**由于分类方法位于宿主类的方法数组靠前的位置，如果分类中有和宿主类同名的方法，那么分类的方法会被优先实现**。

源码分析
![categoryCoversOriginalTheSameMethod.png](https://i.loli.net/2020/05/23/JWFAlsQdZyuMLqC.png)

[回到目录](#jump-1)


<h3 id="1-8">8. 分类的总结</h3>
 
- 分类添加的方法可以"覆盖"宿主类的同名方法  
- 同名分类方法谁能生效取决于编译顺序  
- 名字相同的分类会引起编译报错  

[回到目录](#jump-1)


<h3 id="1-9">9. 能否给分类添加"实例变量"？添加的"实例变量"存在于哪里？[※※※※※]</h3>

注意：[实例变量=成员变量]    
可以通过**runtime的关联对象机制**为分类添加"实例变量"。   
**添加的"实例变量"放到了一个全局容器中，并且为不同的分类添加的关联对象的值全都放在同一个全局容器中。**
```
// 设置关联对象
void objc_setAssociatedObject(id _Nonnull object, const void * _Nonnull key, id _Nullable value, objc_AssociationPolicy policy)

// 获取关联对象
id _Nullable objc_getAssociatedObject(id _Nonnull object, const void * _Nonnull key)

// 删除关联对象
void objc_removeAssociatedObjects(id _Nonnull object)
```

[回到目录](#jump-1)


<h3 id="1-10">10. 关联对象的本质？[※※※※※]</h3>
 
关联对象由**AssociationsManager管理**并在**AssociationsHashMap存储**。  
所有对象的关联内容都在**同一个全局容器**中。
![AssociatedObjectNature.png](https://i.loli.net/2020/06/15/hcUzs7LEW51MmCd.png)  
  
- 1.传递进来的value和policy封装成一个ObjcAssociation结构。  
- 2.通过ObjcAssociation和key建立一个映射结构ObjectAssociationMap。  
- 3.ObjectAssociationMap作为object的一个value放到全局容器AssociationsHashMap中。  

设置关联对象的源码分析：  
![objc_setAssociatedObject.png](https://i.loli.net/2020/06/15/dznULg5iIk2fe6O.png) 

[回到目录](#jump-1)


<h3 id="1-11">11. 如何删除已经被关联到对象的值？[※※※※※]</h3>

**可以把value传为nil来实现。(源码中通过擦除来解决这个场景)**

[回到目录](#jump-1)


<h3 id="1-12">12. 关联对象的数据结构</h3>

![AssociatedDataStructure.png](https://i.loli.net/2020/06/15/z415gWQd69LhlGP.png)

[回到目录](#jump-1)


<h3 id="1-13">13. 分类的实现原理？[※※※※※]</h3>

- 分类的实现是由运行时决议。  
- 不同的分类中含有同名的方法，谁最终生效取决于分类的编译顺序。最后编译的分类当中的同名方法会最终生效。前面的会被覆盖掉。  
- 如果分类中有和宿主类同名的方法，那么分类方法会"覆盖"同名的宿主类方法。    
宿主类的方法仍然存在，但是由于消息函数方法查找过程中根据选择器名称查找，一旦找到对应的实现就返回。  
由于分类方法位于宿主类的方法数组靠前的位置，如果分类中有和宿主类同名的方法，那么分类的方法会被优先实现。

[回到目录](#jump-1)


<h2 id="2">二. 扩展Extension</h2>

<h3 id="2-1">1. 一般用扩展做什么？/扩展的应用场景？</h3>

平日开发中，一般把扩展放到宿主类的.m文件中
- 声明私有属性：不对子类暴露 
- 声明私有方法：方便阅读  
- 声明私有成员变量

[回到目录](#jump-2)


<h3 id="2-2">2. 扩展的特点是什么？</h3>

- 编译时决议  
- 只以声明的形式存在(没有具体实现)，多数情况下寄生于宿主类的.m文件中  
- 不能为系统类添加扩展

[回到目录](#jump-2)


<h3 id="2-3">3. 分类和扩展有什么区别？可以分别用来做什么？分类有哪些局限性？分类的结构体里面有哪些成员？[※※※※※]</h3>
 
#### 分类和扩展的区别
- 分类是运行时决议；扩展是编译时决议。  
- 分类有声明和实现；扩展只有声明，扩展的实现是写在宿主类中。 
- 分类声明的属性，只会生成getter和setter方法的声明，不会自动生成实例变量及getter和setter方法的实现；而扩展会。
- 可以为系统类添加分类；不能为系统类添加扩展。

#### 分类和扩展可以分别用来做什么

- 分类
    - 声明私有方法  
    定义一个分类，只把他的头文件放到宿主文件的.m当中，可以满足私有方法的声明和使用，对外不暴露。
    - 分解体积庞大的类文件  
    比如：这个类的功能复杂，可以按照功能对类中的一些方法进行分类。把同一功能的方法放到对应的一个分类文件中。 
    - 把Framework的私有方法公开 

- 扩展
    - 声明私有属性：不对子类暴露
    - 声明私有方法：方便阅读
    - 声明私有成员变量

#### 分类的局限性
- 分类不能自动生成实例变量，需要通过关联对象技术来实现。
- 多个分类中有同名的方法的时候，只会执行最后编译的方法。
- 当分类中有和宿主类同名的方法的时候，会"覆盖"宿主类方法而执行分类中同名方法。

#### 分类结构体中包含的内容
```
struct category_t {
    const char *name; // 分类的名称
    classref_t cls; // 分类的宿主类
    struct method_list_t *instanceMethods; // 实例方法列表
    struct method_list_t *classMethods; // 类方法列表
    struct protocol_list_t *protocols; // 协议列表
    struct property_list_t *instanceProperties; // 实例属性列表

    method_list_t *methodsForMeta(bool isMeta) {
        if (isMeta) return classMethods;
        else return instanceMethods;
    }

    property_list_t *propertiesForMeta(bool isMeta) {
        if (isMeta) return nil; // classProperties;
        else return instanceProperties;
    }
};
```

[回到目录](#jump-2)

# 参考文档

《新浪微博资深大牛全方位剖析 iOS 高级面试》 
 
