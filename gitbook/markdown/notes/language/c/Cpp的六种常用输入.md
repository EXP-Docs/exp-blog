# C++ 的六种常用输入

------


## cin

**用法1：** 最基本，也是最常用的用法，输入一个数字或字符(不接受空字符作为字符输入，当输入字符为空字符时，会不断重复要求输入，直至输入字符非空后，通过回车结束输入)：

```cpp
#include <iostream>
using std::cin;
using std::cout;    // 要求程序中出现几种标准库函数，就要用名字空间说明几次，这种
using std::endl;    // 做法等价于using namespace std; 因为对大程序比较麻烦，不推荐用
int main ()
{
    int a;
    char b;
    cin>>a>>b;    // cin允许这种"连续输入"模式
    cout<<a<<','<<b<<endl;
    return 0;
}
```

```
> 输入：2[回车]a[回车]
> 输出：2,a
```



**用法2：** 接受一个字符串，遇“空格”、“TAB”、“回车”都结束：

```cpp
#include <iostream>
using namespace std;
int main ()
{
    char a[20];
    cin>>a;
    cout<<a<<endl;
    return 0;
}
```

```
> 输入：jkljkljkl
> 输出：jkljkljkl
> 输入：jkljkl jkljkl    // 遇空格结束
> 输出：jkljkl
```




## cin.get()

**用法1：** cin.get(字符变量名) 可以用来接收字符：

```cpp
#include <iostream>
using namespace std;
int main ()
{
    char ch;
    ch=cin.get();    //或者cin.get(ch);
    cout<<ch<<endl;
    return 0;
}
```

```
> 输入：jljkljkl
> 输出：j
```



**用法2：** cin.get(字符数组名,串长) 用来接收一行字符串，可以接收空格：

```cpp
#include <iostream>
using namespace std;
int main ()
{
    char a[20];
    cin.get(a,20);
    cout<<a<<endl;
    return 0;
}
```

```
> 输入：jkl jkl jkl
> 输出：jkl jkl jkl
> 输入：abcdeabcdeabcdeabcdeabcde　　（输入25个字符）
> 输出：abcdeabcdeabcdeabcd　　　　　（接收19个字符+1个'\0'）
```

> *注： cin.get(char对象地址，串长)*
<br/> 　　cin.get()只能和char(或char\*)定义的字符串地址搭配，不能和string定义的字符串地址搭配




**用法3：** cin.get(无参数)

没有参数，主要是用于舍弃输入流中的不需要的字符,多用于舍弃前一次输入时放在输入缓冲区的回车。

> *注：* 此用法会在“[附页一](#附页一：-cinget与cingetline的异同)”通过比较cin.get()与cin.getline()的不同详细而举例说明




## cin.getline()

**用法1：** 接受一个字符串，可以接收空格并输出：

```cpp
#include <iostream>
using namespace std;
int main ()
{
    char m[20];
    cin.getline(m,5);
    cout<<m<<endl;
    return 0;
}
```

```
输入：jkljkljkl
输出：jklj   （接受5个字符到m中，其中最后一个为'\0'，所以只看到4个字符输出）
```

如果把5改成20：

```
输入：jkljkljkl
输出：jkljkljkl
输入：jklf fjlsjf fjsdklf
输出：jklf fjlsjf fjsdklf
```




**用法2：** 当用在多维数组中的时候，也可以用cin.getline(m[i],20)之类的用法：

```cpp
#include<iostream>
#include<string>
using namespace std;
int main ()
{
    char m[3][20];
    for(int i=0;i<3;i++)
    {
        cout<<"\n请输入第"<<i+1<<"个字符串："<<endl;
        cin.getline(m[i],20);
    }
    cout<<endl;

    for(int j=0;j<3;j++)
        cout<<"输出m["<<j<<"]的值:"<<m[j]<<endl;

    return 0;
}
```

```
输入第1个字符串：kskr1
输入第2个字符串：kskr2
输入第3个字符串：kskr3
输出m[0]的值:kskr1
输出m[1]的值:kskr2
输出m[2]的值:kskr3
```

> *注： cin.getline()功能的扩展说明*
<br/> 　　cin.getline()实际上有三个参数，cin.getline(char对象地址，串长，’结束字符’)
<br/> 　　① 当第三个参数省略时，系统默认为'\0'
<br/> 　　② 如果把例子中cin.getline()改为cin.getline(m,5,'a');
<br/> 　　　　当输入jlkjkljkl时，输出jklj ； 输入jkaljkljkl时，输出jk
<br/> 　　③ cin.getline()至少要有前2个参数，且只能和char(或char\*)定义的字符串地址搭配，不能和string定义的字符串地址搭配




## getline()

**只有一种用法**：接受一个字符串，可以接收空格并输出（需 #include &lt;string&gt;）：

```cpp
#include<iostream>
#include<string>
using namespace std;
int main ()
{
    string str;
    getline(cin,str);
    cout<<str<<endl;
    return 0;
}
```

```
输入：jkljkljkl   （按2次回车后输出，至于为什么，在“附页二”会详细解释）
输出：jkljkljkl
输入：jkl jfksldfj jklsjfl    （按2次回车后输出）
输出：jkl jfksldfj jklsjfl
```

> *注：*
<br/> 　　① getline()和cin.getline()类似，但是cin.getline()属于istream流，而getline()属于string流，是不一样的两个函数。
<br/> 　　② getline(cin,string对象地址) 中的字符串地址只能和string定义的字符串地址搭配，不能和char(或char\*)定义的字符串地址搭配。这与cin.getline()相反。




## gets()

**用法1：** 接受一个字符串，可以接收空格并输出（需 #include &lt;string&gt;）：

```cpp
#include<iostream>
#include<string>
using namespace std;
int main ()
{
    char m[20];
    gets(m);    //不能写成m=gets();
    cout<<m<<endl;
    return 0;
}
```

```
输入：jkljkljkl
输出：jkljkljkl
输入：jkl jkl jkl
输出：jkl jkl jkl
```

> *注：gets(char对象地址)*
<br/> 　　gets()只能和char(或char\*)定义的字符串地址搭配，不能和string定义的字符串地址搭配





**用法2：** 类似cin.getline()里面的一个例子，gets()同样可以用在多维数组里面：

```cpp
#include<iostream>
#include<string>
using namespace std;
int main ()
{
    char m[3][20];
    for(int i=0;i<3;i++)
    {
        cout<<"\n请输入第"<<i+1<<"个字符串："<<endl;
        gets(m[i]);
    }
    cout<<endl;

    for(int j=0;j<3;j++)
        cout<<"输出m["<<j<<"]的值:"<<m[j]<<endl;

    return 0;
}
```

```
请输入第1个字符串：
kskr1
请输入第2个字符串：
kskr2
请输入第3个字符串：
kskr3
输出m[0]的值:kskr1
输出m[1]的值:kskr2
输出m[2]的值:kskr3
```



## getchar()

**只有一种用法**：接受一个字符（需 #include &lt;string&gt;）：

```cpp
#include<iostream>
#include<string>
using namespace std;
main ()
{
    char ch;
    ch=getchar();    //不能写成getchar(ch);
    cout<<ch<<endl;
}
```

```
输入：jkljkljkl
输出：j
```

> *注：* getchar()是C语言的函数，C++也可以兼容，但是尽量不用或少用





## 附页一： cin.get()与cin.getline()的异同

**相同点：** cin.get ()和cin.getline()都是对输入的面向行的读取,即一次读取整行而不是单个数字或字符。




**不同点一：** cin.get()每次读取一整行并把由Enter键生成的换行符留在输入队列中，如：

```cpp
#include <iostream>
using namespace std;
const int SIZE = 15;
int main( )
{
    cout << "Enter your name:";
    char name[SIZE];
    cin.get(name,SIZE);
    cout << "name:" << name;
    cout << "\nEnter your address:"<<endl;
    char address[SIZE];
    cin.get(address,SIZE);    //这里直接读入了上次输入的回车符，因而不允许用户再输入了
    cout << "address:" << address<<endl;
    return 0;
}
```

输出：

```
Enter your name:jimmyi shi
name:jimmyi shi
Enter your address:address:
```

在这个例子中，cin.get()将输入的名字读取到了name中，并将由Enter生成的换行符'/n'留在了输入队列（即输入缓冲区）中，因此下一次的cin.get()便在缓冲区中发现了'/n'并把它读取了，最后造成第二次的无法对地址的输入并读取了换行符。

*解决方法：*

- ① 可以在源程序两次调用cin.get()之间再加入一个cin.get();语句，把第一次输入的换行符'\n'吃掉，一般为了易读性应该在第一次调用cin.get()函数输入后，马上再添加一个cin.get();语句。
- ② 可以把第一次调用的cin.get()函数组合式地写为cin.get(name,SIZE).get();直接吃掉换行符




**不同点二：** cin.getline()每次读取一整行并把由Enter键生成的换行符抛弃，如：

```cpp
#include <iostream>
using std::cin;
using std::cout;
const int SIZE = 15;
int main( )
{
    cout << "Enter your name:";
    char name[SIZE];
    cin.getline(name,SIZE);
    cout << "name:" << name;
    cout << "\nEnter your address:";
    char address[SIZE];
    cin.get(address,SIZE);
    cout << "address:" << address;
}
```

输出：

```
Enter your name:jimmyi shi
name:jimmyi shi
Enter your address:YN QJ
address:YN QJ
```

在这个例子中，由于由Enter生成的换行符被抛弃了，所以不会影响下一次cin.get()对地址的读取



## 附页二： getline()函数 -&gt; FIFO的队列问题

先看看函数定义：

```cpp
getline(cin,string字符串地址)；
```

显然，这个函数接受两个参数：一个输入流对象和一个string对象。

getline函数从输入流的下一行读取，并把上一次读取的内容保存到string中（但不包括换行符）。和输入操作符不一样的是，getline并不忽略行开头的换行符，只要getline遇到换行符，即便它是输入的第一个字符，getline也停止读入并返回。如果第一个字符就是换行符，则string参数将被置为空。

由于getline函数返回时丢弃换行符，因此换行符不会存储在string对象中。当在循环中时若要逐行输出，需要再额外添加换行符，通常用endl，换行的同时刷新输出缓冲区。

可以通过队列去理解getline的功能：

- 第一次输入时，信息流1被存放到cin缓冲区中（cin是缓冲式输入，而且这里的cin也不能指定存放对象，因而信息流1被存放到缓冲区）。
- 第二次输入时，信息流1被string对象读取并保存，信息流2被寄存到cin缓冲区。
- 第三次输入时，信息流2被string对象读取并保存，信息流1被信息流2所覆盖，信息流3被存放到cin缓冲区。

![](/res/img/article/20110513/01.png)

由此也可以解释为什么类似于这种程序需要在输入信息流后按两次回车才执行输出了：

```cpp
string str;
getline(cin,str);
cout<<str<<endl;
```

如：输入abcd，第一次回车，abcd被存放到输入缓冲区，此时程序仍然停留在执行语句getline(cin,str);中，第二次回车，abcd被str读取保存，空字符(回车符)被送到输入缓冲区，然后getline(cin,str);执行完毕，跳到cout语句，输出str:  abcd。

以下这个小程序在第一次调用getline(cin,line)时需要输入2个信息流，以后每输入新的信息流，最就会输出上一次输入的信息流，可以体验一下什么是队列：

```cpp
#include<iostream>
#include<string>
using namespace std;
int main ()
{
    string line;
    while(getline(cin,line))    // getline函数将istream参数作为返回值，和输入操作符一样也把它用作判断条件
        cout<<line<<endl;
    return 0;
}
```



## 资源下载

<a class="download" href="http://download.csdn.net/download/lyy289065406/10533718" target="_blank"><i class="fa fa-cloud-download"></i>本文全文下载</a>

