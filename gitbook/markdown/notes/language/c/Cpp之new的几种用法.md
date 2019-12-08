# C++ 之 new 的几种用法

------

## 运算符new

new最常的用法是作为运算符，这时候new会在堆上分配一块内存，并会自动调用类的构造函数，如：

```cpp
string *str = new string("test new");
```

new作为运算符时，它是C++内置的，你不能对它做任何的改变，除了使用它。




## 函数new

第二种用法是new函数，其实new作为运算符时，内部分配内存使用的就是new函数，其原型是：

```cpp
void *operator new(size_t size);
```

new函数返回的是一个void指针，指向一块未经初始化的内存。

可以发现，这和C语言的malloc行为相似，所以你可以重载new函数，并且增加额外的参数，但是必须保证第一个参数必须是size_t类型，它指明了分配内存块的大小。

如果重载了new函数，在使用new操作符时调用的就是你重载后的new函数了。

这时候使用new函数，和语句 【string \*str = new string("test new");】 相对的代码大概是如下的样子：

```cpp
string *str = (string*)operator new(sizeof(string));
str.string("test new");  // 当然这个调用时非法的，但是编译器是没有这个限制的
```




## placement new

placement new 其实也是new作为函数的一种用法，它允许你在一块已存在的内存上分配一个对象，而内存上的数据不会被覆盖或者被你主动改写。placement new同样由new操作符调用，调用格式是：

```cpp
new (buffer) type(size_t size);
```

先看看下面的代码：

```cpp
char str[22];
int data = 123;
int *pa = new (&data) int;
int *pb = new (str) int(9);
```

结果为：

```cpp
*pa = 123 // 未覆盖原数据）
*pb = 9    // 覆盖原数据
```

可以看到placement new 并没有分配新的内存，也可以使用在栈上分配的内存，而不限于堆。为了使用placement new 你必须 #include &lt;new&gt; 或 #include &lt;new.h&gt;。

其实placement new和第二种用法一样，只不过多了参数，是函数new的重载，语法格式为：

```cpp
void *operator new(size_t, void* buffer);
```

它看起来可能是这个样子：

```cpp
void *operator new(size_t, void* buffer) { return buffer;}
```

和new对应的就是delete了




## 总结

① 函数new：

```cpp
void *operator new(size_t size);  // 在堆上分配一块内存
placement new（void *operator new(size_t, void* buffer)）;  // 在一块已经存在的内存上创建对象
```

如果你已经有一块内存，placement new会非常有用，事实上，它STL中有着广泛的使用。

② 运算符new： 最常用的new，没什么可说的。

③ 函数new 不会自动调用类的构造函数，因为它对分配的内存类型一无所知；而运算符new会自动调用类的构造函数。

④ 函数new 允许重载，而 运算符new 不能被重载。

⑤ new对应的是delete。




