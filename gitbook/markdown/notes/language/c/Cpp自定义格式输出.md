# C++ 的自定义格式输出

------

标准输出函数cout允许用户输出各种 标准数据类型 定义的数据，但是这种输出都是按标准格式输出的。有时，用户希望能改变输出格式，比如希望以十六进制输出100等，此时就必须用 **自定义输出格式**。

> **[info]** 在C++头文件 <font color="red">**iomanip**</font> 中包含了许多控制符用于控制数据的输出格式。



## 控制符：进制转换

用于不同进制转换的控制符如下表:

| 控制符名称 | 产生的效果 |
|:----:|:----:|
| dec | 用十进制输出数据 |
| hex | 用十六进制输出数据 |
| oct | 用八进制输出数据 |
| setbase(n) | 将基数设为n，用n进制输出数据（n的取值为8，10，16） |

> **注意：**
<br/> ① 使用进制符输出n进制数时，默认不显示基数，若有字母则默认以小写显示。
<br/> ② 使用进制符转换数据值输出后，原变量所存储的值会从转变为该进制数的值。
<br/> 　　例如：int a=30; cout&lt;&lt;hex&lt;&lt;a&lt;&lt;endl;
<br/> 　　输出：a的值为0x1e （即十六进制的1e）




## 控制符：其他

此外，iomanip 还提供了其他控制符，如下表：

| 控制符名称 | 产生的效果 |
|:----:|:----:|
| left | 靠左对齐输出数据 |
| right | 靠右对齐输出数据 |
| setfill(&apos;ch&apos;) | 利用字符ch来填充空白处 |
| setprecision(n) | 设置小数位数(就是定义精度) |
| setw(n) | 设置显示的宽度为n<br/>（若值宽度为m，当n&gt;m时，值自动靠右对齐，左边补空格；<br/>当n&lt;m时，则按值的原长度m靠左输出） |
| uppercase | 用大写字母显示十六进制中的字母 |
| nouppercase | 取消用大写字母显示十六进制中的字母 |
| showbase | 在数值前显示基数<br/>（基数就是进制数的标志，例如八进制前的0，十六进制前的0x） |
| noshowbase | 取消显示数值的基数 |
| showpos | 在正数前面输出+号 |
| skipws | 忽略输入流中的空格 |
| setiosflags(n) | 设置ios标志，其中n为ios中枚举数据的值，如ios::left |
| resetioflags() | 取消ios标志 |
| scientific | 用科学计数法显示浮点数 |
| fixed | 用固定的小数点位数来显示浮点数 |


> **注意：**
<br/> 关于 ios::scientific 和 ios::fixed 标志：两者都是控制符 setiosflags 的参数之一。
<br/> ① **setiosflags(ios::scientific)** 用指数的方式表示实数
<br/> ② s**etiosflags(ios::fixed)** 以带小数点的形式表示浮点数，并且在允许的精度范围内尽可能的把数字移向小数点右侧



## 使用实例

给定一个整数，分别用十进制、八进制、十六进制的形式输出；

再给定一个浮点数，分别采用科学计数法和小数形式输出。

源程序代码如下：

```cpp
#include<iostream>
#include<iomanip>
using namespace std;
int main(void)
{
  int a=30;
  float f=3.1415926539798;
  cout<<"用不同的进制数输出数字30:"<<endl;
  cout<<"用十进制输:"<<dec<<a<<endl;    //十进制显示：30。
  cout<<"用八进制输出:"<<oct<<a<<endl;    //八进制显示：36。
  cout<<showbase;    //显示数字的基数。
  cout<<uppercase;    //用大写字母显示十六进制的字母。
  cout<<"用十六进制输出:"<<hex<<a<<endl;   //十六进制显示:OX1E。
  cout<<noshowbase;    //取消显示数字基数。
  cout<<nouppercase;    //取消用大写字母显示十六进制。
  cout<<setw(10)<<a<<endl;    //设置宽度为10显示数字。
  cout<<setfill('$')<<setw(10)<<a<<endl;    //设置显示宽度为10并$填充空白处。
  cout<<left<<setw(10)<<a<<endl;    //左靠齐。
  cout<<right<<setw(10)<<a<<endl;    //右靠齐。
  cout<<setprecision(6)<<scientific<<f<<endl;    //用科学计数法形式输出f值，6位小数。
  cout<<setprecision(5)<<fixed<<f<<endl;    //用小数形式输出f值，5位小数。
  system("pause");    //从程序调用pause命令，pause的功能就是在命令行输出一行类似"Press any  return 0;            key to exit."的字，等待用户按一个键然后返回。
}
```




## 附：控制符的生命周期

编译器**默认输入输出的整型都是十进制**。

<font color="red">一旦改变进制形式，将保持改变后的进制模式，直至下一次的改变进制为止</font>。

```cpp
int k,m,p;
cin>> p;        //默认十进制输入
cin>>hex>>k;   //十六进制输入；
cin>>m;        //依然是十六进制输入；
cin>>dec>>p;   //恢复十进制输入
cout<<k;       //默认十进制输出（不是因为前一个语句中dec的关系）
cout<<oct<<k;  //八进制输出；
cout<<m;      //依然是八进制输出
cout<<dec<<p;   //恢复十进制输出
```


另外需要注意的是，<font color="red">**输入流cin** 的进制形式 与 **输出流cout** 的进制形式 **互不干扰**</font>。

例如：

```cpp
cin>>hex>>k;       // 十六进制输入
cout<<k;           // 只要这个是同一函数中第一次执行的cout，就是默认十进制输出，不受cin的hex干扰
```

> **[info]** 上面的特性对 istringstream，ostringstream和iostringstream 所定义的变量也适用，而且在利用 istringstream，ostringstream 转换格式时，应活用此方法。

