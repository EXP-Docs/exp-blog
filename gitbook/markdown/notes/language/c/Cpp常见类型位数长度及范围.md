# C++ 常见类型位数、长度及范围

------

|类型 | 位数n | 长度 = 字节 = <br/>sizeof(\*) = n/8  | 值范围 |
|:----:|:----:|:----:|:----:|
| bool | 8 | 1 | 0 (false) 或 1 (true) |
| char | 8 | 1 | $\small{0 \sim 2^8-1}$<br/>（即0~255，相当于ASCII码范围） |
| char\* | 32 | 4 | &nbsp; |
| int | 32 | 4 | $\small{-2^{16} \sim 2^{16}-1}$ |
| int* | 32 | 4 | &nbsp; |
| unsigned int | 32 | 4 | $\small{0 \sim 2^{32}-1}$ |
| long int | 32 | 4 | $\small{-2^{16} \sim 2^{16}-1}$ |
| unsigned long int | 32 | 4 | $\small{0 \sim 2^{32}-1}$ |
| short int | 16 | 2 | $\small{-2^8 \sim 2^8-1}$ |
| unsigned short int | 16 | 2 | $\small{0 \sim 2^{16}-1}$ |
| float | 32 | 4 | $\small{-3.4x10^{-38} \sim 3.4x10^{38}}$ |
| float* | 32 | 4 | &nbsp; |
| double | 64 | 8 | $\small{-1.7x10^{-308} \sim 1.7x10^{308}}$ |
| long double | 64 | 8 | $\small{-1.2x10^{-4932} \sim 1.2x10^{4932}}$ |
| double* | 32 | 4 | &nbsp; |
| double& | 32 | 4 | &nbsp; |
| enum | 32 | 4 | &nbsp; |
| void | &nbsp; | &nbsp; | &nbsp; |

> **[info]** 用sizeof(void)计算空类型大小是非法的，说明viod无任何信息

