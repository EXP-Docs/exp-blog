# C++ 之父写的桌面计算器：看看大师的功力吧

------


这是 《The C++ Programming Language》 第六章函数的一个例子。

例子中没有高深的算法，都是c++中最常用的语法现象，但是这150行程序里蕴含的功力极深（至少我达不到这种水平，程序的效率，存储开销等方面做的都非常出色，甚至是天衣无缝）。

今日贴出，请大家一同欣赏（作者在程序中因为简化程序而改写了一些更好的方法，正如作者在序言中所说，要有一种健康的怀疑态度,我之所以说它完美，并不是指我们编不出比它好的程序，而是指它清晰的结构，合理的设计，以及蕴含在这里面的编程艺术）

> [!NOTE|style:flat|icon:fa fa-cloud-download|label:Download]
> 
> [Gitbub 源码](https://github.com/lyy289065406/The-C-Programming-Language/tree/master/TCPL-Desktop-Calculator)
<br/> [桌面计算器.exe](https://github.com/lyy289065406/The-C-Programming-Language/blob/master/TCPL-Desktop-Calculator/Release/%E6%A1%8C%E9%9D%A2%E8%AE%A1%E7%AE%97%E5%99%A8.exe)


```cpp
////////////////////////////////////////////////////////////// 
//以下是 c++之父写的一个简单计算器程序 包括分析器,输入,符号表,驱动程序 
//计算器的输入语法: 
// 1)以 ";" 号作为一行的结束 
// 2)可用英文单词命名变量 (但变量后要有空格) 
// 例子如下: 
// 输入: r =2.5; (注意空格) 
// 输出: 2.5 (记负值结果) 
// 输入: area = r * r * pi ; 
// 输出: 19.635 
// 
// 以下代码为标准c++代码,我在vc++2003.net上运行无误 

#include <iostream> 
#include <string> 
#include <map> 
#include <cctype> 
using namespace std; 
const int ture=1; 
const int flase=0; 

map<string,double> table; 


/////////////////////////////////////////////////////////////// 
//计算器输入允许的词法 
enum Token_value{ 
	NAME, NUMBER, END, 
	PLUS='+', MINUS='-', MUL='*', DIV='/', 
	PRINT=';', ASSIGN='=', LP='(', RP=')', 
}; 

/////////////////////////////////////////////////////////////// 
//分析器 加和减 
double expr(bool); 

/////////////////////////////////////////////////////////////// 
//分析器 乘和除 
double term(bool); 

/////////////////////////////////////////////////////////////// 
//分析器 处理初等项 
double prim(bool); 

/////////////////////////////////////////////////////////////// 
//词法分析器 
Token_value get_token(); 

/////////////////////////////////////////////////////////////// 
//错误处理 
double error(const string &s); 

/////////////////////////////////////////////////////////////// 
//当前词法标记 
Token_value curr_tok=PRINT; 

double number_value;  //存放数值 
string string_value; //存放计算器变量名 
int no_of_errors; //记录错误个数 


double expr(bool get) { 
	double left=term( get); 

	for( ; ; ) 
		switch(curr_tok) { 
		case PLUS: 
			left+=term(ture); 
			break; 
		case MINUS: 
			left-=term(ture); 
			break; 
		default: 
			return left; 
	} 
} 

double term(bool get) { 
	double left=prim(get); 

	for( ; ; ) 
		switch(curr_tok) { 
		case MUL: 
			left*=prim(ture); 
			break; 
		case DIV: 
			if(double d=prim(ture)) { 
				left/=d; 
				break; 
			} 
			return error("divide by 0"); 
		default: 
			return left; 
	} 
} 


double prim(bool get) { 
	if(get) get_token(); 

	switch(curr_tok) { 
	case NUMBER: { 
		double v=number_value; 
		get_token(); 
		return v; 
				 } 
	case NAME: { 
		double& v=table[string_value]; 
		if(get_token()==ASSIGN) 
			v=expr(ture); 
		return v; 
			   } 
	case MINUS: 
		return -prim(ture); 
	case LP: { 
		double e=expr(ture); 
		if(curr_tok!=RP) 
			return error(") expected"); 
		get_token(); 
		return e; 
			 } 
	default: 
		return error("primary expected"); 
	} 
} 

Token_value get_token() { 
	char ch=0; 
	cin>>ch; 

	switch(ch) { 
	case 0: 
		return curr_tok=END; 
	case ';': 
	case '*': 
	case '/': 
	case '+': 
	case '(': 
	case ')': 
	case '=': 
		return curr_tok=Token_value(ch); 
	case '0': 
	case '1': 
	case '2': 
	case '3': 
	case '4': 
	case '5': 
	case '6': 
	case '7': 
	case '8': 
	case '9': 
	case '.': 
		cin.putback(ch); 
		cin>>number_value; 
		return curr_tok=NUMBER; 
	default: 
		if(isalpha(ch)) { 
			cin.putback(ch); 
			cin>>string_value; 
			return curr_tok=NAME; 
		} 
		error("bad token"); 
		return curr_tok=PRINT; 
	} 
} 

double error(const string& s)
{ 
	no_of_errors++; 
	cerr<<"error: "<<s<<endl; 
	return 1; 
} 

int main() 
{ 
	table["pi"]=3.1415926; 
	table["e"]=2.718281828; 

	while(cin) { 
		get_token(); 
		if(curr_tok==END) 
			break; 
		if(curr_tok==PRINT) 
			continue; 
		cout<<expr(false)<<endl; 
	} 
	return no_of_errors; 
}

```




