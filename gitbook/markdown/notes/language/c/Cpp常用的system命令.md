# C++ 常用的 system 命令

------

system命令是用来做和系统有关的DOS命令。

当我们开发的程序需在DOS界面做交互时，system命令就很有用了。

一般来说，能在CMD窗口下执行的命令（所有DOS命令，各种可执行的文件，用户自己编写的程序等），都可以在C++通过system命令执行。

下面列举一些常用的system命令：


```cpp
system("pause");	// 输出屏显示类似“请按任意键继续…”的语句

system("cls");		// 对此语句前面的所有输出进行清屏

system("cmd");		// 打开DOS窗口

system("路径名");		// 打开该路径下的指定文件（注意路径名中的“\”在C++中应写成“\\”才是表示“单斜杠”）

system("mem");		// 查看内存状况

system("date");		// 显示及修改日期

system("time");		// 显示及修改时间

system("tree");		// 列出目录树

system("help");		// 帮助，列出DOS命令清单
```
