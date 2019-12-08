# C++ 风格的几种 IO 流

> **[success]** 本文介绍的三个IO函数（stringstream、**o**stringstream、**i**stringstream）均在头文件&lt;sstream&gt;中

------



## stringstream

可以说 stringstream 是 **o**stringstream 和 **i**stringstream 的综合体。

因为在 **o**stringstream 和 **i**stringstream 的一般用法中，凡是使用 **o**stringstream（或 **i**stringstream）函数的地方，都可以用 stringstream 进行替换，因此不介绍 stringstream。




## ostringstream

ostringstream 对象将所有“赋”给它的字符串整合成一个流存放，该流中各个字符串的排列顺序按照“赋值”时的顺序排列，当输出ostringstream对象时，该流被完整输出。

**ostringstream 对象中存放的流可以使用函数 .str("") 进行清空**。养成好习惯，在程序允许的情况下在每次重新调用 ostringstream 对象时最好清空内存，避免流过长引致的奇怪问题。

**可以通过栈 Stack 理解 ostringstream 的这种功能**：

- 把各条零散的字符串存放到ostringstream对象里（字符串的数量、长度没有限制）
- ostringstream在内部对零散的字符串进行连续顺序的整合
- 把整合后的字符串流整体输出

![](/res/img/article/20101103/01.png)


下面通过一个例子理解这个流程：

```cpp
#include <iostream>
#include <sstream>
using namespace std;
int main()
{
    ostringstream oss;    //声明ostringstream对象oss
    oss << "abcd";        //向oss放入第一个字符串
    oss << " ";           //注意，必须放入字符串，即使是单个字符也要使用双引号，支持空字符
    oss << "efghijklm89";
    oss << "zxcvbn";
    oss << endl;          //把换行符放到流oss的里面与放在cout最后是一样的
    cout << oss.str();    // .str( )函数，提供C中的字符串头指针或者匿名的内存首地址
                          //必须通过.str( )函数提供地址值给oss输出，cout << oss；是无法输出oss内存的
    oss << "who";   //输出流后，oss的内容并不会被清空，可以继续在原有的流末尾插入新的字符串
    cout << oss.str() <<endl; //这里是为了说明"换行符放到流oss的里面与放在cout最后是一样的"
    return 0;
}
```

第一次输出：
```cpp
abcd efghijklm89zxcvbn
```

第二次输出：
```cpp
abcd efghijklm89zxcvbn
who
```



上例其实就是一个格式化输出的例子，下面简单介绍ostringstream类型转换的功能：

```cpp
#include <iostream>
#include <string>
#include <sstream>
using namespace std;
int main()
{
    string Str1, Str2;
    ostringstream oss;

    //double型转化为字符串
    oss << 3.1234274234;     //double型输出时保留6位有效数字(不包括小数点)，最后一位四舍五入，若为0则舍去（不论是本来为0还是四舍五入为0均舍去），因此有时会出现double型没有小数的情况
    Str2 = oss.str();        //类型转换
    cout << Str2 << endl;    // 输出：3.12343

    //int型转化为字符串
    oss.str("");     //清空oss对象内所存储的流，注意oss.clear() 函数并不能清空内存，即不能清空oss对象内所存储的流，它的作用在介绍istringstream函数时会详细说明
    oss << 1234567;            //注意当整型数据溢出时，编译会提示出错
    Str2 = oss.str();          //类型转换
    cout << Str2 << endl;      // 输出：1234567

    //格式化输出
    oss.str("");
    oss << "3.1415926548930288822"; //添加双引号会被当做字符串处理，原样输出
    oss << " "; 
    oss << "efghijklm43";
    oss << "888888888888888888888"; //添加双引号会被当做字符串处理，不提示溢出，原样输出
    oss << endl;
    cout << oss.str();  //输出：3.1415926548930288822 efghijklm43888888888888888888888

    //通过.put()向oss插入单个字符，通过.str()向oss插入字符串
    oss.str("");
    oss.str("abc");        //构造oss时设置字符串参数   
    oss.str("hjklpo");     //用.str()函数可以对oss从起始而不是结尾处插入字符串，并修改原有数据,超出的部分往后增长。.str()函数只能插入字符串
    oss.put('d');   //用.put()函数可以对oss从起始而不是结尾处插入字符串，并修改原有数据
    oss.put('e');   //再次调用.put()函数时从上一个.put()插入的位置后插入，并修改原有数据，超出的部分往后增长。.put()函数只能插入字符
    oss << "fg";      //左移运算符<<是紧接上一个.str()或.put()的指针位置后插入
    cout<< oss.str() <<endl;  //输出结果：defgpo
    return 0;
}
```


> **[info]** ostringstream 对象只支持 &lt;&lt; 操作符，可以用来进行格式化的输出，并能够方便的将各种类型转换为string类型。




## istringstream

istringstream对象只支持 >> 操作符，会对“赋”给它的字符串流进行空格识别，把该字符串中以空格隔开的内容分别提取出来，被提取的内容可以赋值给string等类型输出。

**istringstream对象中存放的流可以使用函数.str("")进行清空**。

**可以通过栈Stack理解istringstream的这种功能**：

- 把一条较长的字符串流赋值给istringstream对象（字符串长度没有限制）
- istringstream对象通过识别该字符串流中的空格，把该字符串流中以空格分隔的子字符串进行拆分，并按原来的顺序从栈顶到栈底进行连续存放
- istringstream对象由栈顶开始把逐个子字符串对外赋值，每前一个子字符串出栈后，指针指向下一个子字符串的串首
- istringstream对象的内存不一定要一次全部输出，允许只输出一部分，但内部指针的指向不会自动初始化。下一次调用istringstream对象赋值时将从中断处继续对外输出
- 当指针指向栈底时， istringstream对象不能再对外赋值，但仍然保存该字符串流的所有信息

![](/res/img/article/20101103/02.png)


下面通过一个例子理解这个流程：


```cpp
#include <iostream>
#include <string>
#include <sstream>
using namespace std;
int main()
{
    int a;
    double b;
    string Str1, Str2;
    string Input = "abc 123 bcd 456 sss 999";
    istringstream iss(Input);  //通过构造函数对istringstream类进行赋值，可以将一个字符串变量的值传递给istringstream对象
                               //若传入的字符串是常量，也可以进行如下赋值
                               //  iss.str("abc 123 bcd 456 sss 999");
                               //扩展: iss对象支持对C语言流的操作，所以也可以进行如下的赋值
                               //       iss.str(Input.c_str( ));
    while( iss >> Str1)  //当赋值不为 NULL时执行（其实就是判断iss的指针是否指向栈底）
    {                   //循环提取iss中的字符串对Str1重复赋值
        cout << Str1 << endl;   //对Str1的每次赋值进行输出
    }                          //输出：abc
                               //    123
                               //    bcd
                               //    456
                               //    sss
                               //    999
    cout << iss.str( ) << endl;   //此语句是为了测试iss对外赋值后内存是否为空，可见是不为空的
                              //输出：abc 123 bcd 456 sss 999
    iss.clear();  //iss.clear()函数并不能清空内存，目的是使已经指向iss栈底的指针初始化到栈顶
                 //这里若使用iss.str("");清空iss内存是无补于事的，即使清空内存再重新赋值（不论是原来的字符串还是新的字符串），iss指针始终指向栈底，iss依然无法对外赋值
    iss.str(Input);    //对iss重新赋值，这里赋值为原来的字符串Input (注意iss不像oss，新的赋值是会覆盖旧的值，而不是插入到流的最后)
                      //iss有一个很奇怪的现象，笔者现在也无法想通，仅仅使用iss.clear();初始化指针而不重新赋值，iss依然不能对外赋值，必须“iss指针初始化，iss重新赋值”都执行了，iss才可以重新在栈顶开始对外赋值，两步缺一不可。除非重新定义一个istringstream对象 
    while(iss >> Str1 >> a)   //当且仅当iss的内存为字符串常量（即已知的字符串流）时，才可以使用这种赋值方式，否则会使当类型不匹配时(如string到int)，iss会丢失对外赋值
                          //由于已知Input中的字符串为"abc 123 bcd 456 sss 999"，由此规律可以使用iss >>Str1>>a这种对外输出方式，这是因为iss同样具有类型转换功能，虽然iss存储的必定是string型，但当字符串为整型形式的数据（形式是整型，但实际依然是string型）时，允许赋值到整型变量中并转换为int型。同样对double型也适用
    {
        cout << Str1 << " " << a << endl;  //输出：abc 123
                                            //    bcd 456
                                            //    sss 999
    }
    iss.clear();
    iss.str("abc 1.20 def 3.13159267 bmp 0.5432899 cji 123456.889");
    while(iss >> Str2 >> b)      //测试iss字符串中含有double型时是否能成功转换类型
    {
        cout << Str2 << " " << b << endl;  //输出：abc 1.2
                                           //     def 3.13159
                                           //     bmp 0.54329
                                           //     cji 123457
    }
    return 0;
}
```




## 资源下载

> [!NOTE|style:flat|icon:fa fa-cloud-download|label:Download]
> 
> [本文全文下载](https://download.csdn.net/download/lyy289065406/10545201)

