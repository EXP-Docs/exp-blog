# 获取进程信息

------

## 相关资源

- PROCESSENTRY32 结构： [https://docs.microsoft.com/en-us/windows/win32/api/tlhelp32/ns-tlhelp32-processentry32](https://docs.microsoft.com/en-us/windows/win32/api/tlhelp32/ns-tlhelp32-processentry32)
- MODULEENTRY32 结构： [https://docs.microsoft.com/en-us/windows/win32/api/tlhelp32/ns-tlhelp32-moduleentry32](https://docs.microsoft.com/en-us/windows/win32/api/tlhelp32/ns-tlhelp32-moduleentry32)

<a class="download" href="/res/exe/get_process.exe" target="_blank"><i class="fa fa-cloud-download"></i>get_process.exe 下载</a>


## C++ 源码

```c
/***************************************************************************************
 * get_process.cpp
 *             
 * 进程信息查询脚本，使用方法:
 *   ./get_process.exe            :  查询当前所有进程信息
 *   ./get_process.exe -id 1234   :  查询进程号为 1234 的进程信息
 *   ./get_process.exe -name abcd :  查询进程名以 abcd 开头（忽略大小写）的进程信息
 * 
 ***************************************************************************************/

#include <windows.h>
#include <tlhelp32.h>
#include<stdio.h>
#include <tchar.h>



/* 进程信息结构体: https://docs.microsoft.com/en-us/windows/win32/api/tlhelp32/ns-tlhelp32-processentry32
typedef struct tagPROCESSENTRY32 {
　　DWORD dwSize;                    // 此进程的结构体大小（字节）
　　DWORD cntUsage;                  // 进程的引用计数（已废弃，固定值0）
　　DWORD th32ProcessID;             // 进程号
　　ULONG_PTR th32DefaultHeapID;     // 默认堆ID（已废弃，固定值0）
　　DWORD th32ModuleID;              // 进程模块ID（已废弃，固定值0）
　　DWORD cntThreads;                // 此进程创建的线程数
　　DWORD th32ParentProcessID;       // 父进程号
　　LONG pcPriClassBase;             // 此进程所创建的线程优先级
　　DWORD dwFlags;                   // （已废弃，固定值0）
　　TCHAR szExeFile[MAX_PATH];       // 进程的可执行文件的名称（不含路径，完整路径可通过 MODULEENTRY32->szExePath 获取）
} PROCESSENTRY32, *PPROCESSENTRY32;
*/

/* 进程模块结构体: https://docs.microsoft.com/en-us/windows/win32/api/tlhelp32/ns-tlhelp32-moduleentry32
typedef struct tagMODULEENTRY32 {
  DWORD   dwSize;                           // 此模块的结构体大小（字节）
  DWORD   th32ModuleID;                     // 模块ID（已废弃，固定值1）
  DWORD   th32ProcessID;                    // 所属进程的进程号
  DWORD   GlblcntUsage;                     // 负载计数（通常没有意义，一般情况下值为 0xFFFF）
  DWORD   ProccntUsage;                     // 与 GlblcntUsage 相同
  BYTE    *modBaseAddr;                     // 该模块在所属进程中的基址
  DWORD   modBaseSize;                      // 模块大小（字节）
  HMODULE hModule;                          // 该模块在所属进程中的句柄
  char    szModule[MAX_MODULE_NAME32 + 1];  // 模块名称
  char    szExePath[MAX_PATH];              // 模块路径
} MODULEENTRY32;
*/



void printSysError();                       // 打印系统异常
void printProc(PROCESSENTRY32 pe32);        // 打印进程信息到控制台
char* getProcessOwner(DWORD pid);           // 获取进程归属用户
bool equal(const char* a, const char* b);   // 比较两个字符串是否相同（忽略大小写）
char* toChar(const wchar_t* _wchar);        // 宽字符 -> ASCII字符
bool startwith(const char* str, const char* substr);    // 判断 str 是否以 substr 开头（忽略大小写）



/**
 * argc: 入参个数(至少为1: 第0个为执行文件文件名)
 * argv: 入参列表。当 argc!=3 时打印所有进程; 当 argc==3 时:
 *   -id {pid} : 打印进程号为 pid 的进程信息
 *   -name {pname} : 打印进程名为以 pname 开头的进程信息（忽略大小写，若有多个则只打印第一个）
 */
int main(int argc, char* argv[]) {

    // 提取入参
    int exPid = -1;       // 期望查询的进程号
    char* exPname = "";   // 期望查询的进程名
    if(argc == 3) {
        if(equal(argv[1], "-id")) {
            exPid = atoi(argv[2]);

        } else if(equal(argv[1], "-name")) {
            exPname = argv[2];
        }
    }

    // 拍摄当前系统所有进程快照
    HANDLE hProcess = ::CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if(hProcess == INVALID_HANDLE_VALUE) {
        printf("[Error] Fail to take processes snapshot.\n");
        printSysError();
        return -1;
    }

    PROCESSENTRY32 pe32;
    pe32.dwSize = sizeof(pe32);
    BOOL hasNext = ::Process32First(hProcess, &pe32);     // 进程快照列表迭代器

    // 打印特定进程信息
    if(exPid > -1 || strlen(exPname) > 0) {
        bool flag = false;
        while(hasNext) {
            DWORD pid = pe32.th32ProcessID;
            char* pname = toChar(pe32.szExeFile);
            if(((DWORD) exPid) == pid || startwith(pname, exPname)) {
                printProc(pe32);
                flag = true;
                break;
            }
            delete[] pname;
            hasNext = ::Process32Next(hProcess, &pe32);
        }

        if(flag == false) {
            printf("[Error] The process is not exists.\n");
        }

    // 打印所有进程信息
    } else {
        while(hasNext) {
            printProc(pe32);
            hasNext = ::Process32Next(hProcess, &pe32);
        }
    }
    
    // 清除快照对象
    ::CloseHandle(hProcess);

    // system("pause");
    return 0;
}



// 打印系统异常
void printSysError() {
    DWORD errId;
    TCHAR errMsg[256];
    TCHAR* p;

    errId = GetLastError();
    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, 
                    NULL, errId, 
                    MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                    errMsg, 256, NULL);

    p = errMsg;
    while(*p > 31 || *p == 9) { ++p; }
    do { *p-- = 0; } while(p >= errMsg && (*p == '.' || *p < 33));
    _tprintf(TEXT("[Error %d] %s\n"), errId, errMsg);
}



// 打印进程信息到控制台
void printProc(PROCESSENTRY32 pe32) {
    printf("[Process Info]\n");
    printf("name: %s\n", toChar(pe32.szExeFile));
    printf("pid: %u\n", pe32.th32ProcessID);
    printf("ppid: %u\n", pe32.th32ParentProcessID);
    printf("owner: %s\n", getProcessOwner(pe32.th32ProcessID));
    printf("dwSize: %u\n", pe32.dwSize);
    printf("cntThreads: %u\n", pe32.cntThreads);
    printf("pcPriClassBase: %ld\n", pe32.pcPriClassBase);

    // 拍摄当前进程模块列表快照
    HANDLE hModule = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, pe32.th32ProcessID);
    if(hModule == INVALID_HANDLE_VALUE) {
        // printf("[Error] Fail to take process snapshot\n");
        // printSysError();
        printf("path: \n");

    } else {
        MODULEENTRY32 me;
        me.dwSize = sizeof(MODULEENTRY32);
        BOOL hasNext = Module32First(hModule, &me);    // 进程模块列表迭代器
        if(hasNext) {  // 第一个模块即进程自身, 可从中提取其可执行文件的完整路径
            printf("path: %s\n", toChar(me.szExePath));
        }
    }

    ::CloseHandle(hModule);
    printf("==================\n");
}



// 获取进程归属用户
char* getProcessOwner(DWORD pid) {
    char* owner = new char[513];
    *owner = '\0';

    HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION, FALSE, pid);
    if(hProcess == NULL) {
        return owner;
    }

    HANDLE hToken = NULL;
    DWORD dwSize = 0;
    TCHAR szUserName[256] = { 0 };
    TCHAR szDomain[256] = { 0 };
    DWORD dwDomainSize = 256;
    DWORD dwNameSize = 256;
    SID_NAME_USE SNU;
    PTOKEN_USER pTokenUser = NULL;

    __try {
        if(!OpenProcessToken(hProcess, TOKEN_QUERY, &hToken)) {
            __leave;
        }

        if(!GetTokenInformation(hToken, TokenUser, pTokenUser, dwSize, &dwSize)) {
            if(GetLastError() != ERROR_INSUFFICIENT_BUFFER) {
                __leave;
            }
        }

        pTokenUser = NULL;
        pTokenUser = (PTOKEN_USER) malloc(dwSize);
        if(pTokenUser == NULL) {
            __leave;
        }

        if(!GetTokenInformation(hToken, TokenUser, pTokenUser, dwSize, &dwSize)) {
            __leave;
        }

        if(LookupAccountSid(NULL, pTokenUser->User.Sid, szUserName, &dwNameSize, szDomain, &dwDomainSize, &SNU) != 0) {
            sprintf(owner, "%s\\%s\0", toChar(szDomain), toChar(szUserName));
        }

    } __finally {
        if(pTokenUser != NULL) {
            free(pTokenUser);
        }
    }
    return owner;
}



// 比较两个字符串是否相同（忽略大小写）
bool equal(const char* a, const char* b) {
    bool flag = false;
    if(a == NULL && b == NULL) {
        flag = true;

    } else if(a != NULL && b != NULL) {
        flag = (stricmp(a, b) == 0);
    }
    return flag;
}



// 宽字符 -> ASCII字符
char* toChar(const wchar_t* _wchar) {
    int len = WideCharToMultiByte(CP_ACP, 0, _wchar, -1, NULL, 0, NULL, NULL);
    char* _char = new char[len];
    WideCharToMultiByte(CP_ACP, 0, _wchar, -1, _char, len, NULL, NULL);   
    return _char;
}



// 判断 str 是否以 substr 开头（忽略大小写）
bool startwith(const char* str, const char* substr) {
    bool flag = false;
    if(str != NULL && substr != NULL) {
        int len = strlen(substr);
        if(len > 0) {
            flag = (strnicmp(str, substr, len) == 0);
        }
    }
    return flag;
}
```


## PowserShell 源码

```powershell
# get_process.ps1 
#
# 进程信息查询脚本
# Powershell Script 3.0+
# ---------------------------------------------------------------------------------------
# 脚本使用方式:
#
#   通过进程号查询:
#     .\get_process.ps1 -id 0
#
#   通过进程名查询:
#     .\get_process.ps1 -name "powershell"
#
# ---------------------------------------------------------------------------------------

# id: 进程ID（二选一）
# name: 进程名称（二选一）
param([int]$id=-1, [string]$name="")


# 获取进程对象
function Get-Proc {
    param([int]$id=-1, [string]$name="")

    Try {
        if ($id -gt -1) {
            $process = Get-Process -Id $id -ErrorAction Stop

        } else  {
            $process = Get-Process -Name $name -ErrorAction Stop
        }

    } catch [Microsoft.PowerShell.Commands.ProcessCommandException] {
        Write-Warning "Process [id=$id][name=$name] has not exist"

    } catch {
        Write-Warning "Find Process[id=$id][name=$name] Error"
    }
    return $process
}

# 获取进程属主
function Get-Proc-Owner {
    param([int]$id=-1)

    $owner = ""
    Try {
        $info = (Get-WmiObject -Class Win32_Process -Filter "Handle=$id").GetOwner()
        if ($info.ReturnValue -eq 2) {
            $owner = 'Unknow/Unknow'

        } else {
            $owner = '{0}/{1}' -f $info.Domain, $info.User
        }

    } catch {
        Write-Warning "Find Process[id=$id]'s owner Error"
    }
    return $owner
}


$process = Get-Proc -id $id -name $name
if($process) {
    $owner = Get-Proc-Owner -id $id
    $process_inst = Get-CimInstance Win32_Process -Filter "ProcessId = '$id'"
    $fid = $process_inst.ParentProcessId

    Write-Host "---------------------------------------"
    Write-Host "PID =" $process.Id
    Write-Host "PPID =" $fid
    Write-Host "Name(ProcessName) =" $process.Name
    Write-Host "Path =" $process.Path
    Write-Host "Owner =" $owner
    Write-Host "Handle =" $process.Handle
    Write-Host "Handles(Handlecount) =" $process.Handles
    Write-Host "NPM(NonpagedSystemMemorySize) =" $process.NPM
    Write-Host "PM(PagedMemorySize) =" $process.PM
    Write-Host "VM(VirtualMemorySize) =" $process.VM
    Write-Host "WS(WorkingSet) =" $process.WS
    Write-Host "BasePriority =" $process.BasePriority
    Write-Host "Container =" $process.Container
    Write-Host "EnableRaisingEvents =" $process.EnableRaisingEvents
    Write-Host "ExitCode =" $process.ExitCode
    Write-Host "ExitTime =" $process.ExitTime
    Write-Host "HasExited =" $process.HasExited
    Write-Host "MachineName =" $process.MachineName
    Write-Host "MainModule =" $process.MainModule
    Write-Host "MainWindowHandle =" $process.MainWindowHandle
    Write-Host "MainWindowTitle =" $process.MainWindowTitle
    Write-Host "MaxWorkingSet =" $process.MaxWorkingSet
    Write-Host "MinWorkingSet =" $process.MinWorkingSet
    # Write-Host "Modules =" $process.Modules
    Write-Host "NonpagedSystemMemorySize =" $process.NonpagedSystemMemorySize
    Write-Host "NonpagedSystemMemorySize64 =" $process.NonpagedSystemMemorySize64
    Write-Host "NonPagedMemorySize =" $process.NonPagedMemorySize
    Write-Host "PagedMemorySize64 =" $process.PagedMemorySize64
    Write-Host "PagedSystemMemorySize =" $process.PagedSystemMemorySize
    Write-Host "PagedSystemMemorySize64 =" $process.PagedSystemMemorySize64
    Write-Host "PeakPagedMemorySize =" $process.PeakPagedMemorySize
    Write-Host "PeakPagedMemorySize64 =" $process.PeakPagedMemorySize64
    Write-Host "PeakVirtualMemorySize =" $process.PeakVirtualMemorySize
    Write-Host "PeakVirtualMemorySize64 =" $process.PeakVirtualMemorySize64
    Write-Host "PeakWorkingSet =" $process.PeakWorkingSet
    Write-Host "PeakWorkingSet64 =" $process.PeakWorkingSet64
    Write-Host "PriorityBoostEnabled =" $process.PriorityBoostEnabled
    Write-Host "PriorityClass =" $process.PriorityClass
    Write-Host "PrivateMemorySize =" $process.PrivateMemorySize
    Write-Host "PrivateMemorySize64 =" $process.PrivateMemorySize64
    Write-Host "PrivilegedProcessorTime =" $process.PrivilegedProcessorTime
    Write-Host "ProcessorAffinity =" $process.ProcessorAffinity
    Write-Host "Responding =" $process.Responding
    Write-Host "SessionId =" $process.SessionId
    Write-Host "Site =" $process.Site
    Write-Host "StandardError =" $process.StandardError
    Write-Host "StandardInput =" $process.StandardInput
    Write-Host "StandardOutput =" $process.StandardOutput
    Write-Host "StartInfo =" $process.StartInfo
    Write-Host "StartTime =" $process.StartTime
    Write-Host "SynchronizingObject =" $process.SynchronizingObject
    # Write-Host "Threads =" $process.Threads
    Write-Host "Threads.Count =" $process.Threads.Count
    Write-Host "TotalProcessorTime =" $process.TotalProcessorTime
    Write-Host "UserProcessorTime =" $process.UserProcessorTime
    Write-Host "VirtualMemorySize64 =" $process.VirtualMemorySize64
    Write-Host "WorkingSet =" $process.WorkingSet
    Write-Host "WorkingSet64 =" $process.WorkingSet64
    Write-Host "Company =" $process.Company
    Write-Host "CPU =" $process.CPU
    Write-Host "Description =" $process.Description
    Write-Host "FileVersion =" $process.FileVersion
    Write-Host "Product =" $process.Product
    Write-Host "ProductVersion =" $process.ProductVersion
    # Write-Host "PSConfiguration =" $process.PSConfiguration
    # Write-Host "PSResources =" $process.PSResources
}




# ---------------------------------------------------------------------------------------
# 通过 Get-Member 命令可以获得 process 对象的所有属性
#
#    TypeName: System.Diagnostics.Process
#
# Name                       MemberType     Definition
# ----                       ----------     ----------
# Handles                    AliasProperty  Handles = Handlecount
# Name                       AliasProperty  Name = ProcessName
# NPM                        AliasProperty  NPM = NonpagedSystemMemorySize
# PM                         AliasProperty  PM = PagedMemorySize
# VM                         AliasProperty  VM = VirtualMemorySize
# WS                         AliasProperty  WS = WorkingSet
# Disposed                   Event          System.EventHandler Disposed(System.Object, System.EventArgs)
# ErrorDataReceived          Event          System.Diagnostics.DataReceivedEventHandler ErrorDataReceived(System.Objec...
# Exited                     Event          System.EventHandler Exited(System.Object, System.EventArgs)
# OutputDataReceived         Event          System.Diagnostics.DataReceivedEventHandler OutputDataReceived(System.Obje...
# BeginErrorReadLine         Method         void BeginErrorReadLine()
# BeginOutputReadLine        Method         void BeginOutputReadLine()
# CancelErrorRead            Method         void CancelErrorRead()
# CancelOutputRead           Method         void CancelOutputRead()
# Close                      Method         void Close()
# CloseMainWindow            Method         bool CloseMainWindow()
# CreateObjRef               Method         System.Runtime.Remoting.ObjRef CreateObjRef(type requestedType)
# Dispose                    Method         void Dispose(), void IDisposable.Dispose()
# Equals                     Method         bool Equals(System.Object obj)
# GetHashCode                Method         int GetHashCode()
# GetLifetimeService         Method         System.Object GetLifetimeService()
# GetType                    Method         type GetType()
# InitializeLifetimeService  Method         System.Object InitializeLifetimeService()
# Kill                       Method         void Kill()
# Refresh                    Method         void Refresh()
# Start                      Method         bool Start()
# ToString                   Method         string ToString()
# WaitForExit                Method         bool WaitForExit(int milliseconds), void WaitForExit()
# WaitForInputIdle           Method         bool WaitForInputIdle(int milliseconds), bool WaitForInputIdle()
# __NounName                 NoteProperty   System.String __NounName=Process
# BasePriority               Property       int BasePriority {get;}
# Container                  Property       System.ComponentModel.IContainer Container {get;}
# EnableRaisingEvents        Property       bool EnableRaisingEvents {get;set;}
# ExitCode                   Property       int ExitCode {get;}
# ExitTime                   Property       datetime ExitTime {get;}
# Handle                     Property       System.IntPtr Handle {get;}
# HandleCount                Property       int HandleCount {get;}
# HasExited                  Property       bool HasExited {get;}
# Id                         Property       int Id {get;}
# MachineName                Property       string MachineName {get;}
# MainModule                 Property       System.Diagnostics.ProcessModule MainModule {get;}
# MainWindowHandle           Property       System.IntPtr MainWindowHandle {get;}
# MainWindowTitle            Property       string MainWindowTitle {get;}
# MaxWorkingSet              Property       System.IntPtr MaxWorkingSet {get;set;}
# MinWorkingSet              Property       System.IntPtr MinWorkingSet {get;set;}
# Modules                    Property       System.Diagnostics.ProcessModuleCollection Modules {get;}
# NonpagedSystemMemorySize   Property       int NonpagedSystemMemorySize {get;}
# NonpagedSystemMemorySize64 Property       long NonpagedSystemMemorySize64 {get;}
# PagedMemorySize            Property       int PagedMemorySize {get;}
# PagedMemorySize64          Property       long PagedMemorySize64 {get;}
# PagedSystemMemorySize      Property       int PagedSystemMemorySize {get;}
# PagedSystemMemorySize64    Property       long PagedSystemMemorySize64 {get;}
# PeakPagedMemorySize        Property       int PeakPagedMemorySize {get;}
# PeakPagedMemorySize64      Property       long PeakPagedMemorySize64 {get;}
# PeakVirtualMemorySize      Property       int PeakVirtualMemorySize {get;}
# PeakVirtualMemorySize64    Property       long PeakVirtualMemorySize64 {get;}
# PeakWorkingSet             Property       int PeakWorkingSet {get;}
# PeakWorkingSet64           Property       long PeakWorkingSet64 {get;}
# PriorityBoostEnabled       Property       bool PriorityBoostEnabled {get;set;}
# PriorityClass              Property       System.Diagnostics.ProcessPriorityClass PriorityClass {get;set;}
# PrivateMemorySize          Property       int PrivateMemorySize {get;}
# PrivateMemorySize64        Property       long PrivateMemorySize64 {get;}
# PrivilegedProcessorTime    Property       timespan PrivilegedProcessorTime {get;}
# ProcessName                Property       string ProcessName {get;}
# ProcessorAffinity          Property       System.IntPtr ProcessorAffinity {get;set;}
# Responding                 Property       bool Responding {get;}
# SessionId                  Property       int SessionId {get;}
# Site                       Property       System.ComponentModel.ISite Site {get;set;}
# StandardError              Property       System.IO.StreamReader StandardError {get;}
# StandardInput              Property       System.IO.StreamWriter StandardInput {get;}
# StandardOutput             Property       System.IO.StreamReader StandardOutput {get;}
# StartInfo                  Property       System.Diagnostics.ProcessStartInfo StartInfo {get;set;}
# StartTime                  Property       datetime StartTime {get;}
# SynchronizingObject        Property       System.ComponentModel.ISynchronizeInvoke SynchronizingObject {get;set;}
# Threads                    Property       System.Diagnostics.ProcessThreadCollection Threads {get;}
# TotalProcessorTime         Property       timespan TotalProcessorTime {get;}
# UserProcessorTime          Property       timespan UserProcessorTime {get;}
# VirtualMemorySize          Property       int VirtualMemorySize {get;}
# VirtualMemorySize64        Property       long VirtualMemorySize64 {get;}
# WorkingSet                 Property       int WorkingSet {get;}
# WorkingSet64               Property       long WorkingSet64 {get;}
# PSConfiguration            PropertySet    PSConfiguration {Name, Id, PriorityClass, FileVersion}
# PSResources                PropertySet    PSResources {Name, Id, Handlecount, WorkingSet, NonPagedMemorySize, PagedM...
# Company                    ScriptProperty System.Object Company {get=$this.Mainmodule.FileVersionInfo.CompanyName;}
# CPU                        ScriptProperty System.Object CPU {get=$this.TotalProcessorTime.TotalSeconds;}
# Description                ScriptProperty System.Object Description {get=$this.Mainmodule.FileVersionInfo.FileDescri...
# FileVersion                ScriptProperty System.Object FileVersion {get=$this.Mainmodule.FileVersionInfo.FileVersion;}
# Path                       ScriptProperty System.Object Path {get=$this.Mainmodule.FileName;}
# Product                    ScriptProperty System.Object Product {get=$this.Mainmodule.FileVersionInfo.ProductName;}
# ProductVersion             ScriptProperty System.Object ProductVersion {get=$this.Mainmodule.FileVersionInfo.Product...
```
