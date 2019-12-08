# 在 C++ 中实现声音播放

------

## 前言

声音是多媒体的一个重要组成部分，在应用程序中加入声音可以使界面更友好。

在C++中可以根据不同的应用要求，用不同的方法实现声音的播放。




## 播放声音文件的简单方法

在C++中的多媒体动态连接库中提供了一组与音频设备有关的函数，利用这些函数可以方便地播放声音。

最简单的播放声音方法就是直接调用C++中提供的声音播放函数：

```cpp
// 方式一
BOOL sndPlaySound ( LPCSTR lpszSound, UINT fuSound );

// 方式二
BOOL PlaySound( LPCSTR lpszSound, HMODULE hmod, DWORD fuSound );
```

其中：

- lpszSound 是需要播放声音的 <font color="red">.WAV文件</font> 的路径和文件名
- hmod 在这里为NULL
- fuSound 是播放声音的标志

例如播放声音文件 C:\sound\music.wav 可以这样做：

```cpp
// 方式一：如果没有找到music.wav文件，将播放系统默认的声音
sndPlaySound ("c:\sound\music.wav", SND_ASYNC);

// 方式二：如果没有找到music.wav文件，不会播放系统默认的声音
PlaySound("c:\sound\music.wav", NULL, SND_ASYNC|SND_NODEFAULT );
```




## 将声音文件加入到程序中

在C++的程序设计中，可以利用各种标准的资源，如位图，菜单，对话框等，同时C++也允许用户自定义资源，因此我们可以将声音文件作为用户自定义资源加入程序资源文件中，经过编译连接生成EXE文件，实现 <font color="red">无.WAV文件</font> 的声音播放。

要实现作为资源的声音文件的播放，首先**要在资源管理器中加入待播放的声音文件**（实现过程并不复杂，这里不在叙述）。

假设生成的**声音文件资源标识符为IDR_WAVE1**，在播放时只需要调用下面的语句即可：

```cpp
PlaySound(MAKEINTRESOURCE(IDR_WAVE1), AfxGetResourceHandle(), SND_ASYNC|SND_RESOURCE|SND_NODEFAULT|SND_LOOP);
```

其中：

- MAKEINTRESOURCE()宏 将整数资源标识符转变为字符串
- AfxGetResourceHandle()函数 返回包含资源的模块句柄
- SND_RESOURCE 是必须的标志

这种方式的**原理**是把资源读入内存后作为内存数据播放，其内部逻辑如下：

```cpp
// ① 获得包含资源的模块句柄：
HMODULE hmod=AfxGetResourceHandle(); 

// ② 检索资源块信息：
HRSRC hSndResource=FindResource(hmod,MAKEINTRESOURCE(IDR_WAVE1),_T("WAVE"));

// ③ 装载资源数据并加锁：
HGLOBAL hGlobalMem=LoadResource(hmod,hSndResource);
LPCTSTR lpMemSound=(LPCSTR)LockResource(hGlobalMem);

// ④ 播放声音文件：
sndPlaySound(lpMemSound,SND_MEMORY))；

// ⑤ 释放资源句柄：
FreeResource(hGlobalMem); 
```




## 播放声音文件的高级方法

在C++中提供了一组对音频设备及多媒体文件直接进行操作的函数。利用这些函数可以灵活地对声音文件进行各种处理。

首先介绍几个要用到的数据结构：

- WAVEFORMATEX结构： 定义了WAVE音频数据文件的格式
- WAVEHDR结构： 定义了波形音频缓冲区，读出的数据首先要填充此缓冲区才能送音频设备播放
- WAVEOUTCAPS结构： 描述了音频设备的性能
- MMCKINFO结构： 包含了RIFF文件中一个块的信息

下面给出框架源码，在C++环境下可直接套用：

```cpp
LPSTR szFileName;	// 声音文件名
MMCKINFO mmckinfoParent;
MMCKINFO mmckinfoSubChunk;
DWORD dwFmtSize;
HMMIO m_hmmio;	// 音频文件句柄
DWORD m_WaveLong;
HPSTR lpData;	// 音频数据
HANDLE m_hData;
HANDLE m_hFormat;
WAVEFORMATEX * lpFormat;
DWORD m_dwDataOffset;
DWORD m_dwDataSize;
WAVEHDR pWaveOutHdr;
WAVEOUTCAPS pwoc;
HWAVEOUT hWaveOut;

// 打开波形文件
if(!(m_hmmio=mmioOpen(szFileName,NULL,MMIO_READ|MMIO_ALLOCBUF)))
{
	Error("Failed to open the file.");	// 错误处理函数
	return false;
}

// 检查打开文件是否是声音文件
mmckinfoParent.fccType =mmioFOURCC(’W’,’A’,’V’,’E’);
if(mmioDescend(m_hmmio,(LPMMCKINFO)&mmckinfoParent,NULL,MMIO_FINDRIFF))
{
	// NOT WAVE FILE AND QUIT
}

// 寻找 fmt 块
mmckinfoSubChunk.ckid =mmioFOURCC(’f’,’m’,’t’,’ ’);
if(mmioDescend(m_hmmio,&mmckinfoSubChunk,&mmckinfoParent,MMIO_FINDCHUNK))
{
	// Can't  find 'fmt' chunk
}

// 获得 fmt 块的大小，申请内存
dwFmtSize=mmckinfoSubChunk.cksize ;
m_hFormat=LocalAlloc(LMEM_MOVEABLE,LOWORD(dwFmtSize));
if(!m_hFormat)
{
	// failed alloc memory
}

lpFormat=(WAVEFORMATEX*)LocalLock(m_hFormat);
if(!lpFormat)
{
	// failed to lock the memory
}

if((unsigned long)mmioRead(m_hmmio,(HPSTR)lpFormat,dwFmtSize)!=dwFmtSize)
{
	// failed to read format chunk
}

// 离开 fmt 块
mmioAscend(m_hmmio,&mmckinfoSubChunk,0);

//寻找 data块
mmckinfoSubChunk.ckid=mmioFOURCC(’d’,’a’,’t’,’a’);
if(mmioDescend(m_hmmio,&mmckinfoSubChunk,&mmckinfoParent,MMIO_FINDCHUNK))
{
	// Can't find 'data' chunk
}

// 获得 data块的大小
m_dwDataSize=mmckinfoSubChunk.cksize ;
m_dwDataOffset =mmckinfoSubChunk.dwDataOffset ;
if(m_dwDataSize==0L)
{
	// no data in the 'data' chunk
}

// 为音频数据分配内存
lpData=new char[m_dwDataSize];
if(!lpData)
{
	// faile
}

if(mmioSeek(m_hmmio,SoundOffset,SEEK_SET)<0)
{
	// Failed to read the data chunk
}

m_WaveLong=mmioRead(m_hmmio,lpData,SoundLong);
if(m_WaveLong<0)
{
	// Failed to read the data chunk
}

// 检查音频设备，返回音频输出设备的性能
if(waveOutGetDeVCaps(WAVE_MAPPER,&pwoc,sizeof(WAVEOUTCAPS))!=0)
{
	// Unable to allocate or lock memory
}

// 检查音频输出设备是否能播放指定的音频文件
if(waveOutOpen(&hWaveOut,DevsNum,lpFormat,NULL,NULL,CALLBACK_NULL)!=0)
{
	// Failed to OPEN the wave out devices
}

// 准备待播放的数据
pWaveOutHdr.lpData =(HPSTR)lpData;
pWaveOutHdr.dwBufferLength =m_WaveLong;
pWaveOutHdr.dwFlags =0;
if(waveOutPrepareHeader(hWaveOut,&pWaveOutHdr,sizeof(WAVEHDR))!=0)
{
	// Failed to prepare the wave data buffer
}

// 播放音频数据文件
if(waveOutWrite(hWaveOut,&pWaveOutHdr,sizeof(WAVEHDR))!=0)
{
	// Failed to write the wave data buffer
}

// 关闭音频输出设备,释放内存
waveOutReset(hWaveOut);
waveOutClose(hWaveOut);
LocalUnlock(m_hFormat);
LocalFree(m_hFormat);
delete [] lpData; 
```

**注意：**

- 以上使用的音频设备和声音文件操作函数的声明包含在&lt;mmsystem.h&gt;头文件中。
- 在编译时要加入动态连接导入库winmm.lib，在VC++6.0中的具体实现方法是：在Developer Studio的Project菜单中，选择Settings，然后在Link选项卡上的Object/Library Modules控制中加入winmm.lib。
- 在pWaveOutHdr.lpData中指定不同的数据，可以播放音频数据文件中任意指定位置的声音。
- 以上程序在VC++6.0中调试通过，在文中省略了对错误及异常情况的处理，在实际应用中必须加入。




## 结论

在C++中可以根据应用需要采用不同的方法播放声音文件：

- 简单应用可以直接调用第一种方法的声音播放函数。
- 若希望隐藏声音文件、或减少最终可执行文件的关联文件数，可使用第二种方法。
- 如果在播放之前要对声音数据进行处理，可使用第三种方法。



