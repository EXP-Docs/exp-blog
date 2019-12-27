# N 皇后问题 – 构造法原理与证明: 时间复杂度O(1)

------


<center>***[原]**  E.J.Hoffman;  J.C.Loessi;  R.C.Moore*</center>
<center>*The Johns Hopkins University Applied Physics Laboratory*</center>
<center>***[译]**  EXP  2017-12-29*</center>

----------
> &nbsp;
> <font color="red">由于原文使用了“**m皇后**”进行描述，所以本文从现在开始也使用“**m皇后**”进行描述。</font>
> <font color="red">我这里就**不调整**为大多数人习惯的“**n皇后**”了，避免某些数学公式参数混淆。</font>

----------

***【写在前面】***
　　<font color="blue">这是现在网上流传的一套关于M皇后问题的构造法公式，但是这套公式是怎么得来的，却鲜有人知。
而文本会详细阐述这套公式的推导过程：</font>

对于 $m \geq 4$ 的 **m皇后** 问题：
　　若 $m \bmod 6 \neq 2$ 且 $m \bmod 6 \neq 3$ ，则可通过（A1）或（A2）导出解序列。
　　若 $m \bmod 6 = 2$ 或 $m \bmod 6 = 3$ ，则可通过（B1）或（B2）或（B3）或（B4）导出解序列。
　　其中当 $m$ 是偶数时, $n=\dfrac{m}{2}$ ；当 $m$ 是奇数时 $n=\dfrac{m-1}{2}$ ，

$$
\small{
\begin{cases}
\text{A1-m是偶数: }\[2,4,6,8,...,m\],\[1,3,5,7,...,m-1\] \\\
\text{A2-m是奇数: }\[2,4,6,8,...,m-1\],\[1,3,5,7,...,m-2\],\[m\] \\\
\text{B1-m偶n偶: } \\\
 \quad \[n,n+2,...,m\],\[2,4,6,...,n-2\],\[n+3,n+5,...,m-1\],\[1,3,5,...,n+1\] \\\
\text{B2-m偶n奇: } \\\
 \quad \[n,n+2,...,m-1\],\[1,3,5,...,n-2\],\[n+3,n+5,...,m\],\[2,4,6,...,n+1\] \\\
\text{B3-m奇n偶: } \\\
 \quad \[n,n+2,...,m-1\],\[2,4,6,...,n-2\],\[n+3,n+5,...,m-2\],\[1,3,5,...,n+1\],\[m\] \\\
\text{B4-m奇n奇: } \\\
 \quad \[n,n+2,...,m-2\],\[1,3,5,...,n-2\],\[n+3,n+5,...,m-1\],\[2,4,6,...,n+1\],\[m\]
\end{cases}
}
$$

------------
[toc]

------------
## 1. 前言
文本核心内容主要译自E. J. Hoffman、J. C. Loessi 和R. C. Moore发表于Mathematics Magazine《数学杂志》上的学术论文《Constructions for the Solution of the m Queens Problem》（已被美国数学协会Mathematical Association of America公开），具体期数为Vol. 42, No. 2 (Mar., 1969), pp. 66-72。
　　*该文献可从以下途径购买*：
　　　[http://www.jstor.org/stable/2689192](http://www.jstor.org/stable/2689192)
　　　[http://links.jstor.org/sici?sici=0025-570X%28196903%2942%3A2%3C66%3ACFTSOT%3E2.0.CO%3B2-9](http://links.jstor.org/sici?sici=0025-570X%28196903%2942%3A2%3C66%3ACFTSOT%3E2.0.CO%3B2-9)
　　*该文献的英文原文链接*：
 　　　[http://penguin.ewu.edu/~trolfe/QueenLasVegas/Hoffman.pdf](http://penguin.ewu.edu/~trolfe/QueenLasVegas/Hoffman.pdf)
　　<a  class="dl" href="http://download.csdn.net/download/lyy289065406/10184847" target="_blank" rel="nofollow" data-original-title="" title=""><i class="fa fa-cloud-download"></i>英文原文下载</a> <a  class="dl" href="http://download.csdn.net/download/lyy289065406/10184900" target="_blank" rel="nofollow" data-original-title="" title=""><i class="fa fa-cloud-download"></i>本文译文全文下载</a>


## 2. 问题背景
**M皇后问题**： 在M×M格的国际象棋上摆放M个皇后，使其不能互相攻击，即任意两个皇后都不能处于同一行、同一列或同一斜线上。
　　根据场景，又有**三种衍生问题**：
　　① 共有多少种摆法（即有多少种可行解）
　　② 求出所有可行解
　　③ 求任意一个可行解

**问题①** 属于 **禁位排列** 问题，目前是存在通项公式直接求解的。
　　**问题②** 属于 **搜索** 问题，在网上也有多种解法，主流是 回溯法（另有衍生的位运算变种算法），但不管如何优化，回溯法都有一个致命的问题：M值不能过大（一般M=30已是极限）。
　　**问题③** 属于 问题② 的子集，因此很多人的切入点依然是回溯法，也有启发式算法的解法：如遗传算法、还有刘汝佳在《算法艺术与信息学竞赛》提出的启发式修补算法。启发式算法在M<10000左右都是可解的，但是因为启发式算法均存在随机性，收敛速度视不同的收敛因子而变化（我看过某篇论文称启发式算法在M=10000时的耗时等价于回溯法M=30的耗时）。

但早在1969年， 问题③ 的解就被E. J. Hoffman、J. C. Loessi 和R. C. Moore找到了潜在的数学规律，通过推导出数学公式，<font color="red">利用 构造法  使得该问题可在O(1) 的时间复杂度得到解</font>。
<br/>

## 3. 译者的话
① 原文写得有点艰涩，有些中间步骤是跳过了。我就加上自己的理解做了意译，并补上了跳过的步骤和图示，但是核心的推导思路和步骤不会修改。
　　② 原文首先给出了3个构造式（其实就是m皇后问题的通解式），然后以此为结论展开了一系列的推导证明这3个构造式是正确的。但是这3个构造式真正是怎么得来，原作者并没有说，估计是原作者做了大量的演绎、从m皇后的特解找到了潜在规则所总结出来的通解。
<br/>

## 4. 译文：m皇后问题的构造解法
### 4.1. 数学模型定义
m皇后问题最初是由Gauss（高斯）提出的，该问题描述如下：
　　是否有可能在一个m×m的国际棋盘上放置m个皇后使得她们无法互相攻击？（注：皇后是国际象棋中的一种棋子，她可以对横、竖、斜三个方向的棋子发起攻击）

这是一个有趣的问题，我们可以将其约束到一个数学模型进行描述：
　　把棋盘定义为一个m×m的方格矩阵，那么对于任意方格可以使用有序对 $(i, j)$ 以表示其行列坐标，其中 $1 \leq i \leq m$ 表示该方格的<font color="red">行编号</font>， $1 \leq j \leq m$ 表示该方格的<font color="red">列编号</font>。
　　同时我们再为每个方格定义一组对角编号：
　　令**自左上到右下方向为主对角线**，对于主对角线上的方格 $(i, j)$ ，显然有：
　　$\small{m-j+i=MAJOR\\_CONSTANT}$ <font color="blue">*—— 译者注：这个公式对后续推导起到重要作用*</font>

其中MAJOR_CONSTANT称之为主对角常数，显然有 $1 \leq MAJOR\\_CONSTANT \leq m$ ，将其定义为方格 $(i, j)$ 的<font color="red">主对角编号</font>。
　　进一步地，令**自右上到左下方向为次对角线**，对于次对角线上的方格 $(i, j)$ ，显然有：
　　$\small{i+j-1=MINOR\\_CONSTANT}$ <font color="blue">*—— 译者注：这个公式对后续推导起到重要作用*</font>

其中MINOR_CONSTANT称之为次对角常数，显然有 $1 \leq MINOR\\_CONSTANT \leq m$ ，将其定义为方格 $(i, j)$ 的<font color="red">次对角编号</font>。

<br/>
![图 1  m皇后问题的解模型](http://203.195.132.63/wp-content/uploads/2018/06/ce051a1aff60d00814922b6362dd4198.png)
<center>**图 1  m皇后问题的解模型**</center>
<br/>

至此，m皇后问题的**解模型**可以定义为如下：
　　放置m个皇后到一个m×m的方格矩阵，使得皇后们的所在的方格同时满足下面所有条件：
　　**① 行编号唯一**
　　**② 列编号唯一**
　　**③ 主对角编号唯一**
　　**④ 次对角编号唯一**
　　这个模型足以解决所有m皇后问题（但<font color="red">仅适用于m>=4</font>的情况，因为m=2、3时无解，m=1的解就不需要讨论了） <font color="blue">*—— 译者注：这个大前提条件会在最后进行论证*</font>
<br/>

------------


### 4.2. m皇后通解：三个构造式
由于通解公式相对复杂，为了便于说明，此处不从过程推导出结论，而是反其道而行之：先给出结论的通解公式（且不考虑公式是怎么推演出来的），再证明之。
　　<font color="red">m皇后问题的解的共由3个构造式组成</font>。
<br/>

------------


#### 4.2.1. 【构造式A】
<font color="red">令m = 2n，其中 n = 2, 3, 4,......</font>
　　构造式A仅适用于**m是偶数**的情况，它由**两个子公式**组成：
　　PA-1：放置皇后到方格 $(i_k, j_k)$ ，其中：
<center>$i_k=k, \quad  j_k=2k \quad  (k=1,2,3,...,n)$</center>
　　PA-2：放置皇后到方格 $(i_l, j_l)$ ，其中：
<center>$i_l=2n+1-l, \quad  j_l=2n+1-2l \quad  (l=1,2,3,...,n)$</center>

<br/>
![图 2 使用构造式A解决12皇后问题的解](http://203.195.132.63/wp-content/uploads/2018/06/51bb853ecfeb5452e324d40e9b6f70dd.png)
<center>**图 2 使用构造式A解决12皇后问题的解**</center>
<br/>

------------


#### 4.2.2. 【构造式B】
<font color="red">令m = 2n，其中 n = 2, 3, 4,......</font>
　　构造式B同样仅适用于**m是偶数**的情况，它同样由**两个子公式**组成：
　　PB-1：放置皇后到方格 $(i_k, j_k)$ ，其中：
<center>$i_k=k, \quad  j_k=1+\\{\[2(k-1)+n-1\] \bmod m\\} \quad  (k=1,2,3,...,n)$</center>
　　PB-2：放置皇后到方格 $(i_l, j_l)$ ，其中：
<center>$i_l=2n+1-l, \quad  j_l=2n-\\{\[2(l-1)+n-1\] \bmod m\\} \quad  (l=1,2,3,...,n)$</center>

<br/>
![图 3 使用构造式B解决14皇后问题的解](http://203.195.132.63/wp-content/uploads/2018/06/b39ca1d42ef357842c0c52fa5fc9470c.png)
<center>**图 3 使用构造式B解决14皇后问题的解**</center>
<br/>

------------


#### 4.2.3. 【构造式C】
构造式C是构造式A或B的<font color="red">扩展推导式</font>，仅适用于**m+1是奇数**的情况：
　　当已使用构造式A或B求得一个m×m的皇后问题的解时，若同时增加第 m+1 行和第 m+1 列，那么第 m+1 个皇后应放置在坐标为 $(m+1, m+1)$ 的方格。

<br/>
![图 4 构造式C解集图示（在前面构造式B的示例解集基础上增加一行一列）](http://203.195.132.63/wp-content/uploads/2018/06/7da88a3a8893c1c7abdd3b5cec2635a0.png)
<center>**图 4 构造式C解集图示（在前面构造式B的示例解集基础上增加一行一列）**</center>
<br/>

------------


### 4.3. 三个构造式的正确性证明
要证明构造式是成立的，只需要<font color="red">证明</font>**每个构造式导出的皇后位置均满足**：
　　　　*① 行编号唯一*
　　　　*② 列编号唯一*
　　　　*③ 主对角编号唯一*
　　　　*④ 次对角编号唯一*
<br/>

------------


#### 4.3.1. 【构造式A】的证明
##### 4.3.1.1. 【构造式A】
<font color="red">令m = 2n，其中 n = 2, 3, 4,......（即m≥4且是偶数）：</font>
　　PA-1：放置皇后到方格 $(i_k, j_k)$ ，其中：
<center>$i_k=k, \quad  j_k=2k \quad  (k=1,2,3,...,n)$</center>
　　PA-2：放置皇后到方格 $(i_l, j_l)$ ，其中：
<center>$i_l=2n+1-l, \quad  j_l=2n+1-2l \quad  (l=1,2,3,...,n)$</center>

<br/>
**构造式含义**：若把棋盘在横中轴线切开，很明显解集是呈中心旋转对称的，其中上半部分对应PA-1的解集，下半部分对应PA-2的解集：

<br/>
![图 5 构造式A解集图示](http://203.195.132.63/wp-content/uploads/2018/06/9be05ec1491b7e8d941704aa7c74fac6.png)
<center>**图 5 构造式A解集图示**</center>
<br/>

------------


##### 4.3.1.2. 【定理A】
> &nbsp;
> 对于m皇后问题，当 $n \neq 3\lambda+1 $ （其中 $\lambda=0,1,2,...$ ）时，
> 则必定可以使用【构造式A】求解。

<br/>

------------


##### 4.3.1.3. 【定理A】的证明
<font color="red">**① 行列编号的唯一性证明：**</font>
　　根据 PA-1 导出的皇后位置为 $(k, 2k)$ ，其中 $1 \leq k \leq n$
　　根据 PA-2 导出的皇后位置为 $(2n+1-l, 2n+1-2l)$ ，其中 $1 \leq l \leq n$
　　明显地，PA-1 的每个皇后放置在前n行的每个奇数列，PA-2 的每个皇后放置在后n行的每个偶数列，亦即每行每列均有且只有一个皇后，**行列编号的唯一性得证**。
<br/>
　　<font color="red">**② 主对角编号的唯一性证明：**</font>
　　把 PA-1 的 $i_k, j_k$ 代入主对角公式 $m-j+i$ ：
　　　　$m-j+i \Rightarrow 2n-2k+k \Rightarrow 2n-k$，其中 $1 \leq k \leq n$
<br/>
　　把 PA-2 的 $i_l, j_l$ 代入主对角公式 $m-j+i$ ：
　　　　$m-j+i \Rightarrow 2n-(2n+1-2l)+(2n+1-l) \Rightarrow 2n+l$，其中 $1 \leq l \leq n$

**假设** PA-1 与 PA-2 的**主对角编号存在冲突**，则有：
　　　　$2n-k=2n+l \quad \Rightarrow \quad -k=l$
　　受k、l的取值范围影响，显然是不可能的，**主对角编号的唯一性得证**。
<br/>

<font color="red">**③ 次对角编号的唯一性证明：**</font>
　　把 PA-1 的 $i_k, j_k$ 代入次对角公式 $i+j-1$ ：
　　　　$i+j-1 \Rightarrow k+2k-1 \Rightarrow 3k-1$，其中 $1 \leq k \leq n$
<br/>
　　把 PA-2 的 $i_l, j_l$ 代入次对角公式 $i+j-1$ ：
　　　　$i+j-1 \Rightarrow (2n+1-l)+(2n+1-2l)-1 \Rightarrow 4n-3l+1$，其中 $1 \leq l \leq n$

**假设** PA-1 与 PA-2 的**次对角编号存在冲突**，则有：
　　　　$3k-1=4n-3l+1 \quad \Rightarrow \quad 2n=3(\dfrac{k+l}{2})-1$
<br/>
　　由于 2n 是偶数，则 $\dfrac{k+l}{2}$ 必定是奇数，即 $\dfrac{k+l}{2}=2\lambda+1$ ，其中 $\lambda=0,1,2,...$
<br/>
　　代入替换有 $2n=3(2\lambda+1)-1=6\lambda+2 \quad \Rightarrow \quad  n=3\lambda+1$，其中 $\lambda=0,1,2,...$
　　由此可知当 $n \neq 3\lambda+1$（$\lambda=0,1,2,...$）时，**次对角编号是唯一的**。

<font color="red">**综上①②③，定理A得证**</font>。
<br/>

------------


#### 4.3.2. 【构造式B】的证明
##### 4.3.2.1. 【构造式B】
<font color="red">令m = 2n，其中 n = 2, 3, 4,......（即m≥4且是偶数）：</font>
　　PB-1：放置皇后到方格 $(i_k, j_k)$ ，其中：
<center>$i_k=k, \quad  j_k=1+\\{\[2(k-1)+n-1\] \bmod m\\} \quad  (k=1,2,3,...,n)$</center>
　　PB-2：放置皇后到方格 $(i_l, j_l)$ ，其中：
<center>$i_l=2n+1-l, \quad  j_l=2n-\\{\[2(l-1)+n-1\] \bmod m\\} \quad  (l=1,2,3,...,n)$</center>
<br/>
　　为了便于说明，对 PB-1 和 PB-2 的**对m取mod运算做一下等价处理**：
　　　　以 PB-1 为例，先计算模边界值, 令：
 　　 　　　　$2(k-1)+n-1=m$ （注：m=2n ）
　　　　　$ \Rightarrow k=\dfrac{n+3}{2}$
<br/>
　　　　那么原式的取模运算可变形为分段函数：
  　　　　　　$j_k=
\small{
\begin{cases}
1+\[2(k-1)+n-1\], \qquad (k < \dfrac{n+3}{2}) \\\
1+\\{\[2(k-1)+n-1\]-m\\}, \qquad (k \geq \dfrac{n+3}{2})
\end{cases}
}
$
<br/>


**PB-1：化简后等价于：**
　　　　$
\small{
\begin{cases}
i_k=k, \qquad (k=1,2,3,...,n) \\\
j_k=\begin{cases}
2k+n-2, \qquad (1 \leq k < \dfrac{n+3}{2}) \quad ...... \quad (1) \\\
2k-n-2, \qquad (\dfrac{n+3}{2} \leq k \leq n) \quad ...... \quad (2)
\end{cases}
\end{cases}
}
$
<br/>
　　**PB-2：同理可等价于：**
　　　　$
\small{
\begin{cases}
i_l=2n+1-l, \qquad (l=1,2,3,...,n) \\\
j_l=\begin{cases}
n-2l+3, \qquad (1 \leq l < \dfrac{n+3}{2}) \qquad ...... \quad (1) \\\
3n-2l+3, \qquad (\dfrac{n+3}{2} \leq l \leq n) \quad ...... \quad (2)
\end{cases}
\end{cases}
}
$
<br/>

**构造式含义**：若把棋盘在横中轴线切开，很明显解集是呈中心旋转对称的，其中上半部分对应 PB-1 的解集，下半部分对应 PB-2 的解集。同时根据列编号mod m部分的取值（≥m或＜m），PB-1 与 PB-2 的解集又分别拆分成两个分段函数子集：

<br/>
![图 6 构造式B解集图示](http://203.195.132.63/wp-content/uploads/2018/06/a05ec1b81c94cd5da37d71c1850101c0.png)
<center>**图 6 构造式B解集图示**</center>
<br/>

------------



##### 4.3.2.2. 【定理B】
> &nbsp;
> 对于m皇后问题，当 $n \neq 3\lambda $ （其中 $\lambda=1,2,3,...$ ）时，
> 则必定可以使用【构造式B】求解。

<br/>

------------


##### 4.3.2.3. 【定理B】的证明
<font color="red">**① 行列编号的唯一性证明：**</font>
　　　**注意 PB-1 与 PB-2 都是分段函数**。
<br/>
　　　根据 PB-1 导出的皇后位置 $(i_k, j_k)$ 是**递增**的，
　　　依次放置皇后在 PB-1-(1) 的 $(1, n)$、$(2, n+2)$、$(3, n+4)$、......、$(r, s)$
　　　　　其中把 $MAX(k)$ 代入 $i_k$ 有：$MAX(i_k)=r=
\small{
\begin{cases}
\dfrac{n+2}{2}, \text{n是偶数} \\\
\dfrac{n+1}{2}, \text{n是奇数}
\end{cases}
}
$ $\quad (1 \leq k < \dfrac{n+3}{2})$
<br/>
　　　　　再把 $MAX(k)$ 代入 $j_k$ 有：$MAX(j_k)=s=
\small{
\begin{cases}
2n, \text{n是偶数} \\\
2n-1, \text{n是奇数}
\end{cases}
}
$ $\quad (1 \leq k < \dfrac{n+3}{2})$
<br/>

　和依次放置皇后在 PB-1-(2) 的 $(r^\prime, s^\prime)$、$(r^\prime+1, s^\prime+2)$、......、$(n, n-2)$
　　　　　其中把 $MIN(k)$ 代入 $i_k$ 有：$MIN(i_k)=r^\prime=
\small{
\begin{cases}
\dfrac{n+4}{2}, \text{n是偶数} \\\
\dfrac{n+3}{2}, \text{n是奇数}
\end{cases}
}
$ $\quad (\dfrac{n+3}{2} \leq k \leq n)$
$\qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad \Rightarrow r^\prime=r+1$

<br/>
　　　再把 $MIN(k)$ 代入 $j_k$ 有：$MIN(j_k)=s^\prime=
\small{
\begin{cases}
2, \text{n是偶数} \\\
1, \text{n是奇数}
\end{cases}
}
$ $\quad (\dfrac{n+3}{2} \leq k \leq n)$
<br/>


　根据 PB-2 导出的皇后位置 $(i_l, j_l)$ 是**递减**的，
　　　依次放置皇后在 PB-2-(1) 的 $(2n, n+1)$、$(2n-1, n-1)$、$(2n-2, n-3)$、......、$(p, q)$
　　　　　其中把 $MAX(l)$ 代入 $i_l$ 有：$MAX(i_l)=p=
\small{
\begin{cases}
\dfrac{3n}{2}, \text{n是偶数} \\\
\dfrac{3n+1}{2}, \text{n是奇数}
\end{cases}
}
$ $\quad (1 \leq l < \dfrac{n+3}{2})$
<br/>
　　　　　再把 $MAX(l)$ 代入 $j_l$ 有：$MAX(j_l)=q=
\small{
\begin{cases}
1, \text{n是偶数} \\\
2, \text{n是奇数}
\end{cases}
}
$ $\quad (1 \leq l < \dfrac{n+3}{2})$
<br/>

　和依次放置皇后在 PB-2-(2) 的 $(p^\prime, q^\prime)$、$(p^\prime-1, q^\prime-2)$、$(p^\prime-2, q^\prime-4)$、......、$(n+1, n+3)$
　　　　　其中把 $MIN(l)$ 代入 $i_l$ 有：$MIN(i_l)=p^\prime=
\small{
\begin{cases}
\dfrac{3n-2}{2}, \text{n是偶数} \\\
\dfrac{3n-1}{2}, \text{n是奇数}
\end{cases}
}
$ $\quad (\dfrac{n+3}{2} \leq l \leq n)$
$\qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad \quad \Rightarrow p^\prime=p-1$

<br/>
　　　再把 $MIN(l)$ 代入 $j_l$ 有：$MIN(j_l)=q^\prime=
\small{
\begin{cases}
2n-1, \text{n是偶数} \\\
2n, \text{n是奇数}
\end{cases}
}
$ $\quad (\dfrac{n+3}{2} \leq l \leq n)$
<br/>

明显地：当n是偶数时，PB-1 的每个皇后放置在前n行的每个偶数列，PA-2 的每个皇后放置在后n行的每个奇数列；当n是奇数时，PB-1 的每个皇后放置在前n行的每个奇数列，PA-2 的每个皇后放置在后n行的每个偶数列。亦即不论n的奇偶性如何，每行每列均有且只有一个皇后，**行列编号的唯一性得证**。
<br/>

<font color="red">**② 主对角编号的唯一性证明：**</font>
　　把 PB-1 的 $i_k, j_k$ 代入主对角公式 $m-j+i$ ：
　　　　$m-j+i=
\small{
\begin{cases}
2n-(2k+n-2)+k \Rightarrow n-k+2, \quad (1 \leq k < \dfrac{n+3}{2})\\\
2n-(2k-n-2)+k \Rightarrow 3n-k+2, \quad (\dfrac{n+3}{2} \leq k \leq n)
\end{cases}
}
$
　　　　　　　　　　$\Rightarrow
\small{
\begin{cases}
n-k+2, \quad (1 \leq k < \dfrac{n+3}{2})\\\
3n-k^\prime+2, \quad (\dfrac{n+3}{2} \leq k^\prime \leq n) \text{......此处替换变量以便下文区分}
\end{cases}
}
$
<br/>
　　把 PB-2 的 $i_l, j_l$ 代入主对角公式 $m-j+i$ ：
　　　　$m-j+i=
\small{
\begin{cases}
2n-(n-2l+3)+(2n+1-l) \Rightarrow 3n+l-2, \quad (1 \leq l < \dfrac{n+3}{2})\\\
2n-(3n-2l+3)+(2n+1-l) \Rightarrow n+l-2, \quad (\dfrac{n+3}{2} \leq l \leq n)
\end{cases}
}
$
　　　　　　　　　　$\Rightarrow
\small{
\begin{cases}
3n+l-2, \quad (1 \leq k < \dfrac{n+3}{2})\\\
n+l^\prime-2, \quad (\dfrac{n+3}{2} \leq l^\prime \leq n) \text{......此处替换变量以便下文区分}
\end{cases}
}
$
<br/>

**假设**主对角编号不是唯一的，那么以下六个等式必至少有一成立：
　　$
\small{
\begin{cases}
n-k+2=3n+l-2 \quad ...... (1) \\\
n-k+2=n+l^\prime-2 \quad ...... (2) \\\
3n-k^\prime+2=3n+l-2 \quad ...... (3) \\\
3n-k^\prime+2=n+l^\prime-2 \quad ...... (4) \\\
n-k+2=3n-k^\prime+2 \quad ...... (5) \\\
3n+l-2=n+l^\prime-2 \quad ...... (6)
\end{cases}
}
$　其中：$1 \leq k,l < \dfrac{n+3}{2} \quad , \quad \dfrac{n+3}{2} \leq k^\prime,l^\prime \leq n$

<br/>
化简（1）得 $k+l=4n-2$，但因为 $min(k+l)=2$，此时 $n=1$，与前提条件 $m=2n\geq4 \Rightarrow n\geq2$ 矛盾，因此（1）不成立。
　　化简（4）得 $k^\prime+l^\prime=2n+4$，与 $max(k^\prime+l^\prime)=2n$ 矛盾，因此（4）不成立。
　　化简（5）得 $k+k^\prime=2n$ 从取值范围看显然不成立。
　　化简（6）得 $l^\prime-l=2n$ 从取值范围看显然不成立。
　　化简（2）得 $k+l^\prime=4$，化简（3）得 $k^\prime+l=4$，
　　由于 $k$ 与 $l$ 的取值范围相同， $k^\prime$ 与 $l^\prime$ 的取值范围相同，因此有：
　　　　$
\small{
MIN(k+l^\prime)=MIN(k^\prime+l)=
\begin{cases}
1+\dfrac{n+4}{2} \\\
1+\dfrac{n+3}{2}
\end{cases}
\quad \Rightarrow \quad
\begin{cases}
\dfrac{n+6}{2}, \quad\text{n是偶数} \\\
\dfrac{n+5}{2}, \quad\text{n是奇数}
\end{cases}
}
$
<br/>
　　　　$
\small{
MAX(k+l^\prime)=MAX(k^\prime+l)=
\begin{cases}
\dfrac{n+2}{2}+2 \\\
\dfrac{n+1}{2}+2
\end{cases}
\quad \Rightarrow \quad
\begin{cases}
\dfrac{3n+2}{2}, \quad\text{n是偶数} \\\
\dfrac{3n+1}{2}, \quad\text{n是奇数}
\end{cases}
}
$
<br/>
　　　分别令 $\dfrac{n+6}{2}=4$、$\dfrac{n+5}{2}=4$、$\dfrac{3n+2}{2}=4$、$\dfrac{3n+1}{2}=4$，
<br/>
　　　显然当 n=2 或 n=3 时，（2）或（3）是有可能成立的。
<br/>
　　　但从取值范围$\dfrac{n+3}{2} \leq k^\prime,l^\prime \leq n \quad \Rightarrow \quad \dfrac{n+3}{2} \leq n \quad \Rightarrow \quad n \geq 3$
<br/>
　　　而 n=3 不在定理B的前提条件 $n \neq 3\lambda$（$\lambda=1,2,3,...$）范围内，可以直接排除。
　　　因此 n>3（否则 $k^\prime$ 与 $l^\prime$ 不能存在），所以不存在 n=2 或 n=3 取值的可能性，亦即（2）（3）实际均不成立。

综上，（1）（2）（3）（4）（5）（6）均不成立，**主对角编号的唯一性得证**。

<br/>
<font color="red">**③ 次对角编号的唯一性证明：**</font>
　　把 PB-1 的 $i_k, j_k$ 代入次对角公式 $i+j-1$ ：
　　　　$
\small{
i+j-1 \Rightarrow
\begin{cases}
k+(2k+n-2)-1 \Rightarrow 3k+n-3, \quad(1 \leq k < \dfrac{n+3}{2}) \\\
k+(2k-n-2)-1 \Rightarrow 3k-n-3, \quad(\dfrac{n+3}{2} \leq k \leq n)
\end{cases}
}
$
　　　　　　　　$
\small{
\quad \Rightarrow 
\begin{cases}
3k+n-3, \quad(1 \leq k < \dfrac{n+3}{2}) \\\
3k^\prime-n-3, \quad(\dfrac{n+3}{2} \leq k^\prime \leq n) \text{......此处替换变量以便下文区分}
\end{cases}
}
$
<br/>
　　把 PB-2 的 $i_l, j_l$ 代入次对角公式 $i+j-1$ ：
　　　　$
\small{
i+j-1 \Rightarrow
\begin{cases}
(2n+1-l)+(n-2l+3)-1 \Rightarrow 3n-3l+3, \quad(1 \leq l < \dfrac{n+3}{2}) \\\
(2n+1-l)+(3n-2l+3)-1 \Rightarrow 5n-3l+3, \quad(\dfrac{n+3}{2} \leq l \leq n)
\end{cases}
}
$
　　　　　　　　$
\small{
\quad \Rightarrow 
\begin{cases}
3n-3l+3, \quad(1 \leq l < \dfrac{n+3}{2}) \\\
5n-3l^\prime+3, \quad(\dfrac{n+3}{2} \leq l^\prime \leq n) \text{......此处替换变量以便下文区分}
\end{cases}
}
$
<br/>
　　**假设**次对角编号不是唯一的，那么以下六个等式必至少有一成立：
　　$
\small{
\begin{cases}
3k+n-3=3n-3l+3 \quad ...... (1) \\\
3k+n-3=5n-3l^\prime+3 \quad ...... (2) \\\
3k^\prime-n-3=3n-3l+3 \quad ...... (3) \\\
3k^\prime-n-3=5n-3l^\prime+3 \quad ...... (4) \\\
3k+n-3=3k^\prime-n-3 \quad ...... (5) \\\
3n-3l+3=5n-3l^\prime+3 \quad ...... (6)
\end{cases}
}
$　其中：$\small{1 \leq k,l < \dfrac{n+3}{2} \quad , \quad \dfrac{n+3}{2} \leq k^\prime,l^\prime \leq n}$

<br/>
化简（1）得$2n=3(k+l-2)$，因此$k+l-2$ 必为偶数，令 $2\lambda=k+l-2$（$\lambda=1,2,3,...$），则有 $2n=3(2\lambda) \Rightarrow n=3\lambda$，即当且仅当 $n=3\lambda$ 时（1）成立。
　　化简（2）得 $4n=3(k+l^\prime-2)$，因此 $k+l^\prime-2$ 必为二重偶数（即至少能被2整除两次），令 $4\lambda=k+l^\prime-2$（$\lambda=1,2,3,...$），则有 $4n=3(4\lambda) \Rightarrow n=3\lambda$，即当且仅当 $n=3\lambda$ 时（2）成立。
　　化简（3）得 $4n=3(k^\prime+l-2)$，因此 $k^\prime+l-2$ 必为二重偶数（即至少能被2整除两次），令 $4\lambda=k^\prime+l-2$（$\lambda=1,2,3,...$），则有 $4n=3(4\lambda) \Rightarrow n=3\lambda$，即当且仅当 $n=3\lambda$ 时（3）成立。
　　化简（4）得 $2n=k^\prime+l^\prime-2$，但从 $k^\prime$ 与 $l^\prime$ 的取值范围可知 $MAX(k^\prime+l^\prime-2)=$ $n+n-2=2n-2$，亦即 $2n>k^\prime+l^\prime-2$，因此（4）不成立。
　　化简（5）得 $2n=3(k^\prime-k)$，因此 $k^\prime-k$ 必为偶数，令 $2\lambda=k^\prime-k$（$\lambda=1,2,3,...$），则有 $2n=3(2\lambda) \Rightarrow n=3\lambda$，即当且仅当 $n=3\lambda$ 时（5）成立。
　　化简（6）得 $2n=3(l^\prime-l)$，因此 $l^\prime-l$ 必为偶数，令 $2\lambda=l^\prime-l$（$\lambda=1,2,3,...$），则有 $2n=3(2\lambda) \Rightarrow n=3\lambda$，即当且仅当 $n=3\lambda$ 时（6）成立。

由此可知，当 $n \neq 3\lambda$（$\lambda=1,2,3,...$）时，（1）（2）（3）（4）（5）（6）均不成立，**次对角编号的唯一性得证**。

<font color="red">**综上①②③，定理B得证**</font>。
<br/>

------------


#### 4.3.3. 【构造式C】的证明
##### 4.3.3.1. 两条【引理】
我们**定义**棋盘上由方格 $(1, 1)$、$(2, 2)$、$(3, 3)$、...、$(m, m)$连线所得的对角线为**标准对角线**，亦即标准对角线的行列编号必有 $i==j$。

<br/>
![图 7 构造式C解集图示](http://203.195.132.63/wp-content/uploads/2018/06/dab6eb802f52c542a514b3058072e403.png)
<center>**图 7 构造式C解集图示**</center>
<br/>


**在证明构造式C之前，首先需要证明两条引理**：
　　　<font color="blue">【引理A】</font> 使用构造式A得到的解，没有任何皇后的坐标是在标准对角线上的。
　　　<font color="blue">【引理B】</font>  使用构造式B得到的解，没有任何皇后的坐标是在标准对角线上的。
<br/>

------------


<font color="red">**① 【引理A】的证明：**</font>
　　**假设**存在皇后位于标准对角线上，则必定满足 $i_k=j_k$ 或 $i_l=j_l$，代入 PA-1 与 PA-2 有：
　　$
\small{
\begin{cases}
i_k=j_k \\\
i_l=j_l
\end{cases}
}
$  $ \quad \Rightarrow \quad
\small{
\begin{cases}
k=2k \\\
2n+1-l=2n+1-2l
\end{cases}
}
$  $ \quad \Rightarrow \quad
\small{
\begin{cases}
k=0 \\\
l=0
\end{cases}
}
$

$k=0$ 与取值范围 $k=1,2,3,...,n$ 矛盾，$l=0$ 与取值范围 $l=1,2,3,...,n$ 矛盾，
因此假设不成立，**【引理A】得证**。
<br/>

------------

<font color="red">**② 【引理B】的证明：**</font>
　　**假设**存在皇后位于标准对角线上，则必定满足 $i_k=j_k$ 或 $i_l=j_l$，代入 PB-1 与 PB-2 有：
　　$
\small{
\begin{cases}
i_k=j_k \Rightarrow \begin{cases}
k=2k+n-2 \\\
k=2k-n-2
\end{cases}  \Rightarrow \begin{cases}
k=2-n, \quad(1 \leq k < \dfrac{n+3}{2}) \quad ..................(1) \\\
k=2+n, \quad(\dfrac{n+3}{2} \leq k \leq n) \quad ..................(2)
\end{cases} \\\
i_l=j_l \Rightarrow \begin{cases}
2n+1-l=n-2l+3 \\\
2n+1-l=3n-2l+3
\end{cases} \Rightarrow \begin{cases}
l=2-n, \quad(1 \leq l < \dfrac{n+3}{2}) \quad ......(3) \\\
l=2+n, \quad(\dfrac{n+3}{2} \leq l \leq n) \quad ......(4)
\end{cases}
\end{cases}
}
$

由于 $2n=m\geq4 \Rightarrow n\geq2$，因此（1）（3）不成立，否则 $k,l \leq 0$，与取值范围矛盾。
　　又由于（2）（4）的取值范围 $k,l \leq n$，（2）（4）明显不成立。
　　因此假设不成立，**【引理B】得证**。
<br/>

------------


##### 4.3.3.2. 【定理C】
> &nbsp;
> 对于可使用【构造式A】或【构造式B】求解的m皇后问题，若同时增加第 m+1 行和第 m+1 列，使其延展为m+1皇后问题，那么这个m+1皇后问题也是可解的，且第 m+1 个皇后应放置在坐标为 $(m+1, m+1)$ 的方格。
<br/>

------------


##### 4.3.3.3. 【定理C】的证明
<font color="red">**① 行列编号的唯一性证明：**</font>
　　由于【定理C】是从【定理A】或【定理B】上扩展的，且【定理A】与【定理B】的所有皇后的行列编号唯一性已得到证明，而【定理C】的第m+1行与第m+1列是新增的，那么第m+1个皇后的行列编号也必定是唯一的，因此所有皇后的行列编号必定也是唯一的。

<font color="red">**② 主对角编号的唯一性证明：**</font>
　　由于第m+1个皇后的主对角线与标准对角线是重合的，而通过【引理A】与【引理B】可知在m×m范围内的标准对角线上不存在任何皇后，换言之标准对角线上只有第m+1个皇后，所以主对角线编号是唯一的。

<font color="red">**③ 次对角编号的唯一性证明：**</font>
　　对于第m+1条次对角线，上面只有 $(m+1, m+1)$ 一个方格，显然次对角线编号是唯一的。
<br/>

------------

### 4.4. 大前提条件m≥4的证明
上述所有的证明，都是基于一开始给出的大前提条件：
　　<font color="red">**对于构造式A或B**：令m = 2n，其中 n = 2, 3, 4,......（即m≥4且m是偶数）</font>
　　<font color="red">**对于构造式C**：在构造式A或B可解的基础上令m+1（即m≥5且m是奇数）</font>

亦即m皇后问题（m≥4且m是偶数）可通过【构造式A】或【构造式B】求解，而m+1皇后问题（m+1≥5且m是奇数）则可通过【构造式C】求解。

至于为什么m=1、m=2或m=3时并不适用于构造式A、B、C就是这里要讨论的。
首先当m=1时，虽然是有明确的唯一解，但并不存在m=2n的形式。而n作为三个构造式的重要变量，既然一开始就不存在n值，构造式A、B、C也就无从谈起了。
　　<font color="red">**那么需要证明的，就是为什么m=2与m=3也不可取？**</font>

<font color="red">**证明：**</font>
　　　　通过定理的描述我们知道，
　　　　【定理A】是存在一个约束条件的：$n \neq 3\lambda_A+1$（$\lambda_A=0,1,2,...$）……………（1）
　　　　同样【定理B】也是存在一个约束条件的： $n \neq 3\lambda_B$（$\lambda_B=1,2,3,...$）………（2）
　　　　由于m=2n，因此（1）（2）等价于：
　　　　　$
\small{
\begin{cases}
m \neq 6\lambda_A-4, \quad (\lambda_A=1,2,3,...) \\\
m \neq 6\lambda_B, \quad (\lambda_B=1,2,3,...)
\end{cases} \Rightarrow \begin{cases}
m \neq 2, 8, 14, ... \\\
m \neq 6, 12, 18
\end{cases} \quad \text{m是偶数}
}
$
　　　　不难发现，（2）中**m=2是在m<4范围内没有被约束条件限制的特例**。
　　　　但当m=2时n=1，不妨把n=1代入 PB-1 与 PB-2，取值范围均矛盾，无法计算列坐标编号。
　　　　因此对于【定理A】与【定理B】而言，m=2都是不可解的，从而导致m=3也不可用【定理C】求解。

<font color=red>**证毕**</font>（事实上，通过画图可以明显发现m=2、m=3是无解的）。
<br/>


## 5. 译者后记：通解转换式（编程用）
在原作者提出的三个构造式A、B、C中，均使用 $(i, j)$ 的**二维坐标形式**标记每个皇后的位置，从数学角度上更易于表达作者的思想，但是不便于编程使用。
　　为此译者在这里补充针对构造式A、B、C的转换公式，使用**一维坐标形式**标记每个皇后位置，以配合编程使用（其实这就是目前网上普遍流传的m皇后问题构造式）。
　　<font color="red">**一维坐标**的标记方式为：从第1行开始，依次写出m个数字，分别代表每行的皇后列坐标。亦即行坐标为数序（索引/下标），列坐标为数值</font>。
　　如序列 \[5, 3, 1, 6, 8, 2, 4, 7\] 等价于 (1,5), (2,3), (3,1), (4,6), (5,8), (6,2), (7,4), (8,7)
<br/>

------------


### 5.1. 【构造式A】的转换式
<font color="red">**约束条件：**</font>$n \neq 3\lambda+1$（其中$\lambda=0,1,2,...$）
　　　　　即：$m \neq 2(3\lambda+1) \quad \Rightarrow \quad m \bmod 6 \neq 2$（m为偶数）
　　　　　<font color="blue">**且：**</font>$m-1 \neq 6\lambda+2 \quad \Rightarrow \quad m \bmod 6 \neq 3$（m为奇数，此时适用于构造式C）

<font color="red">**当m为偶数时：**</font>
　　　把行编号1~n代入 PA-1，可得到第1~n行的解序列：$\small{\[2, 4, 6, 8, ..., m\]}$
　　　把行编号n+1~2n代入 PA-2，可得到第n+1~m行的解序列：$\small{\[1, 3, 5, 7, ..., m-1\]}$
　　　合并两个解序列，就是构造式A的通解转换式（A1）：
　　　　$\small{\[2, 4, 6, 8, ..., m\], \[1, 3, 5, 7, ..., m-1\]}$............................................................<font color="red">**（A1）**</font>

<font color="red">**当m为奇数时：**</font>
　　　把行编号1~m-1代入（A1），可得到第1~m-1行的解序列：
　　　　$\small{\[2, 4, 6, 8, ..., m-1\], \[1, 3, 5, 7, ..., m-2\]}$
　　　然后直接套用构造式C（增加第m行第m列），则可得到通解转换式（A2）：
　　　　$\small{\[2, 4, 6, 8, ..., m-1\], \[1, 3, 5, 7, ..., m-2\], \[m\]}$............................................<font color="red">**（A2）**</font>
<br/>

------------


### 5.2. 【构造式B】的转换式
<font color="red">**约束条件：**</font>不满足构造式A约束条件的，都可使用构造式B求解。
　　　　　即：$m \bmod 6 = 2$ （m为偶数）
　　　　　<font color="blue">**或：**</font>$m \bmod 6 = 3$（m为奇数，此时适用于构造式C）

<font color="red">**当m为偶数时：**</font>
　　　<font color="blue">**若n为偶数：**</font>
　　　把行编号1~n代入PB-1，可得到第1~n行的解序列（注：PB-1是分段函数）：
　　　　$\small{\[n, n+2, ..., m\], \[2, 4, 6, ..., n-2\]}$
　　　把行编号n+1~2n代入PB-2，可得到第n+1~m行的解序列（注：PB-2是分段函数）：
　　　　$\small{\[n+3, n+5, ..., m-1\], \[1, 3, 5, ..., n+1\]}$
　　　合并两个解序列，就是构造式B的通解转换式（B1）：
　　　　$\small{\[n,n+2,...,m\], \[2,4,6,...,n-2\], \[n+3,n+5,...,m-1\], \[1,3,5,...,n+1\]}$......<font color="red">**（B1）**</font>

　<font color="blue">**若n为奇数：**</font>
　　　把行编号1~n代入PB-1，可得到第1~n行的解序列（注：PB-1是分段函数）：
　　　　$\small{\[n, n+2, ..., m-1\], \[1, 3, 5, ..., n-2\]}$
　　　把行编号n+1~2n代入PB-2，可得到第n+1~m行的解序列（注：PB-2是分段函数）：
　　　　$\small{\[n+3, n+5, ..., m\], \[2, 4, 6, ..., n+1\]}$
　　　合并两个解序列，就是构造式B的通解转换式（B2）：
　　　　$\small{\[n, n+2, ..., m-1\], \[1, 3, 5, ..., n-2\], \[n+3, n+5, ..., m\], \[2, 4, 6, ..., n+1\]}$......<font color="red">**（B2）**</font>
<br/>

<font color="red">**当m为奇数时, n=(m-1)/2：**</font>
　　　<font color="blue">**若n为偶数：**</font>
　　　把行编号1~m-1代入（B1），可得到第1~m-1行的解序列：
　　　　$\small{\[n, n+2, ..., m-1\], \[2, 4, 6, ..., n-2\], \[n+3, n+5, ..., m-2\], \[1, 3, 5, ..., n+1\]}$
　　　然后直接套用构造式C（增加第m行第m列），则可得到通解转换式（B3）：
　　　　$\small{\[n, n+2, ..., m-1\], \[2, 4, 6, ..., n-2\], \[n+3, n+5, ..., m-2\], \[1, 3, 5, ..., n+1\], \[m\]}$
　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　...............................................................<font color="red">**（B3）**</font>

　<font color="blue">**若n为奇数：**</font>
　　　把行编号1~m-1代入（B2），可得到第1~m-1行的解序列：
　　　　$\small{\[n, n+2, ..., m-2\], \[1, 3, 5, ..., n-2\], \[n+3, n+5, ..., m-1\], \[2, 4, 6, ..., n+1\]}$
　　　然后直接套用构造式C（增加第m行第m列），则可得到通解转换式（B4）：
　　　　$\small{\[n, n+2, ..., m-2\], \[1, 3, 5, ..., n-2\], \[n+3, n+5, ..., m-1\], \[2, 4, 6, ..., n+1\], \[m\]}$
　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　...............................................................<font color="red">**（B4）**</font>
<br/>

------------


### 5.3. 小结：通解转换式归整
对于 $m \geq 4$ 的 **m皇后** 问题：
　　若 $m \bmod 6 \neq 2$ 且 $m \bmod 6 \neq 3$ ，则可通过（A1）或（A2）导出解序列。
　　若 $m \bmod 6 = 2$ 或 $m \bmod 6 = 3$ ，则可通过（B1）或（B2）或（B3）或（B4）导出解序列。
　　其中当 $m$ 是偶数时, $n=\dfrac{m}{2}$ ；当 $m$ 是奇数时 $n=\dfrac{m-1}{2}$ ，

$$
\small{
\begin{cases}
\text{A1-m是偶数: }\[2,4,6,8,...,m\],\[1,3,5,7,...,m-1\] \\\
\text{A2-m是奇数: }\[2,4,6,8,...,m-1\],\[1,3,5,7,...,m-2\],\[m\] \\\
\text{B1-m偶n偶: } \\\
 \quad \[n,n+2,...,m\],\[2,4,6,...,n-2\],\[n+3,n+5,...,m-1\],\[1,3,5,...,n+1\] \\\
\text{B2-m偶n奇: } \\\
 \quad \[n,n+2,...,m-1\],\[1,3,5,...,n-2\],\[n+3,n+5,...,m\],\[2,4,6,...,n+1\] \\\
\text{B3-m奇n偶: } \\\
 \quad \[n,n+2,...,m-1\],\[2,4,6,...,n-2\],\[n+3,n+5,...,m-2\],\[1,3,5,...,n+1\],\[m\] \\\
\text{B4-m奇n奇: } \\\
 \quad \[n,n+2,...,m-2\],\[1,3,5,...,n-2\],\[n+3,n+5,...,m-1\],\[2,4,6,...,n+1\],\[m\]
\end{cases}
}
$$

------------

