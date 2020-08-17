# 获取 Sysmon 事件信息

------

## 相关资源

- Sysmon 官方文档： [https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon)

<a class="download" href="/res/exe/get_sysmon_event.exe" target="_blank"><i class="fa fa-cloud-download"></i>get_sysmon_event.exe 下载</a>


## C++ 源码

```c
/*************************************************************************************************************
 * get_sysmon_event.cpp
 *             
 * Sysmon 事件查询脚本，使用方法:
 *   ./get_sysmon_event.exe 
 *                          -limit 100                              : 一次查询的数量上限（可选，默认值100）
 *                          -id 1                                   : 事件类型（可选，默认值1）
 *                          -ts '2019-12-16T00:00:00.000000000Z'    : 查询开始时间（可选，默认无此条件）
 *                          -te '2019-12-16T08:00:00.000000000Z'    : 查询结束时间（可选，默认值为当前时间）
 *  
 *  ./get_sysmon_event.exe 
 *                          -limit 100   : 一次查询的数量上限（可选，默认值100）
 *                          -query str   : 查询字符串，语法形式形如：
 *    "Event/System[TimeCreated[@SystemTime<'2019-12-16T08:00:00.000000000Z'] and TimeCreated[@SystemTime>'2019-12-05T00:00:00.000000000Z'] and EventID=3]"
 * 
 *************************************************************************************************************/


#include <windows.h>
#include <sddl.h>
#include <stdio.h>
#include <locale.h>
#include <winevt.h>
#pragma comment(lib, "wevtapi.lib") // winevt.h 库文件


#define EVENTID_PROCESS_CREATE 1    // Sysmon事件ID: 进程创建
#define EVENTID_NETWORK_CONNECT 3   // Sysmon事件ID: 网络连接
#define EVENT_CHANNEL L"Microsoft-Windows-Sysmon/Operational"   // Sysmon事件管道名称
#define EVENT_QUERY L"Event/System[EventID=1]"  // 系统事件查询条件语句
#define EVENT_ITERATOR 10           // 单次迭代事件的个数
#define EVENT_LIMIT 50              // 默认查询返回的事件数量上限
static DWORD _evtLimit = (DWORD) EVENT_LIMIT; // 当前查询返回的事件数量上限



bool isEmpty(const char* str);              // 检测字符串是否为空
bool equal(const char* a, const char* b);   // 比较两个字符串是否相同（忽略大小写）
LPWSTR toLPWSTR(const char* str);           // ASCII字符 -> 宽字符
void delUnASCII(LPWSTR wstr);               // 把非 ASCII 字符替换成 ?

LPWSTR toEvtQuery(int argc, char* argv[]);  // 根据脚本入参生成系统事件查询条件语句
LPWSTR toEvtQuery(int eventId, const char* startTime, const char* endTime);     // 生成系统事件查询条件语句

DWORD printEvents(EVT_HANDLE hEvents, DWORD limit);   // 打印查询得到的系统事件列表
DWORD printEvent(EVT_HANDLE hEvent);        // 打印单个系统事件



int main(int argc, char* argv[]) {
    LPWSTR channel = EVENT_CHANNEL;
    LPWSTR evtQuery = toEvtQuery(argc, argv);

    EVT_HANDLE hEvents = EvtQuery(NULL, channel, evtQuery, EvtQueryChannelPath | EvtQueryReverseDirection);
    if(NULL == hEvents) {
        DWORD errId = GetLastError();
        if (ERROR_EVT_CHANNEL_NOT_FOUND == errId) {
            wprintf(L"[Error %lu] The channel was not found: %s\n", errId, channel);

        } else if (ERROR_EVT_INVALID_QUERY == errId) {
            wprintf(L"[Error %lu] The query is invalid: %s\n", errId, evtQuery);

        } else {
            wprintf(L"[Error %lu] EvtQuery failed.\n", errId);
        }

    } else {
        printEvents(hEvents, _evtLimit);
        EvtClose(hEvents);
    }

    // system("pause");
    return 0;
}



// 根据脚本入参生成系统事件查询条件语句
LPWSTR toEvtQuery(int argc, char* argv[]) {
    int eventId = EVENTID_PROCESS_CREATE;
    char* startTime = "";
    char* endTime = "";
    char* query = "";

    for(int i = 1; i < argc; i += 2) {
        if(equal(argv[i], "-limit")) {
            _evtLimit = (DWORD) atoi(argv[i + 1]);
            _evtLimit = (_evtLimit <= 0 ? EVENT_LIMIT : _evtLimit);

        } else if(equal(argv[i], "-id")) {
            eventId = atoi(argv[i + 1]);
            eventId = (eventId < 0 ? EVENTID_PROCESS_CREATE : eventId);

        } else if(equal(argv[i], "-ts")) {
            startTime = argv[i + 1];

        } else if(equal(argv[i], "-te")) {
            endTime = argv[i + 1];

        } else if(equal(argv[i], "-query")) {
            query = argv[i + 1];
        }
    }
    return (strlen(query) > 0 ? toLPWSTR(query) :
        toEvtQuery(eventId, startTime, endTime));
}



// 生成系统事件查询条件语句
LPWSTR toEvtQuery(int eventId, const char* startTime, const char* endTime) {
    char* evtQuery = NULL;
    if(isEmpty(startTime) && isEmpty(endTime)) {
        evtQuery = new char[26];
        sprintf(evtQuery, "Event/System[EventID=%d]\0", eventId);

    } else if(!isEmpty(startTime) && !isEmpty(endTime)) {
        evtQuery = new char[26 + 62 * 2];
        sprintf(evtQuery, "Event/System[EventID=%d and TimeCreated[@SystemTime>'%s'] and TimeCreated[@SystemTime<'%s']]\0", eventId, startTime, endTime);

    } else if(!isEmpty(startTime)) {
        evtQuery = new char[26 + 62];
        sprintf(evtQuery, "Event/System[EventID=%d and TimeCreated[@SystemTime>'%s']]\0", eventId, startTime);

    } else if(!isEmpty(endTime)) {
        evtQuery = new char[26 + 62];
        sprintf(evtQuery, "Event/System[EventID=%d and TimeCreated[@SystemTime<'%s']]\0", eventId, endTime);
    }
    return toLPWSTR(evtQuery);
}



// 打印查询得到的系统事件列表
DWORD printEvents(EVT_HANDLE hEvents, DWORD limit) {
    DWORD errId = ERROR_SUCCESS;
    DWORD _iterNum = (EVENT_ITERATOR <= limit ? EVENT_ITERATOR : limit);

    DWORD cnt = 0;  // 累计迭代获得的事件数
    while(cnt < limit) {

        DWORD num = 0;   // 本次迭代获得的事件数
        EVT_HANDLE* evtCache = new EVT_HANDLE[_iterNum];  // 缓存

        // 提取事件列表
        if(!EvtNext(hEvents, _iterNum, evtCache, INFINITE, 0, &num)) {
            errId = GetLastError();
            if(errId != ERROR_NO_MORE_ITEMS) {
                wprintf(L"[Error %lu] EvtNext failed.\n", errId);
            }

            delete[] evtCache;
            break;
        }

        // 迭代打印
        for(DWORD i = 0; i < num && cnt < limit; i++, cnt++) {
            errId = printEvent(evtCache[i]);

            if(errId == ERROR_SUCCESS) {
                EvtClose(evtCache[i]);
                evtCache[i] = NULL;

            } else {
                break;
            }
            Sleep(10);
        }

        delete[] evtCache;
        Sleep(10);
    }
    return errId;
}



/* 打印单个系统事件
 *
<Event xmlns="http://schemas.microsoft.com/win/2004/08/events/event">
  <System>
    <Provider Name="Microsoft-Windows-Sysmon" Guid="{5770385F-C22A-43E0-BF4C-06F5698FFBD9}"/>
    <EventID>1</EventID>
    <Version>5</Version>
    <Level>4</Level>
    <Task>1</Task>
    <Opcode>0</Opcode>
    <Keywords>0x8000000000000000</Keywords>
    <TimeCreated SystemTime="2019-12-17T10:26:56.242881800Z"/>
    <EventRecordID>50077</EventRecordID>
    <Correlation/>
    <Execution ProcessID="1280" ThreadID="1904"/>
    <Channel>Microsoft-Windows-Sysmon/Operational</Channel>
    <Computer>WIN-S1B6IAK3UN2</Computer>
    <Security UserID="S-1-5-18"/>
  </System>
  <EventData>
    <Data Name="RuleName"/>
    <Data Name="UtcTime">2019-12-17 10:26:56.242</Data>
    <Data Name="ProcessGuid">{68E7DA22-AD70-5DF8-0000-0010428D1D01}</Data>
    <Data Name="ProcessId">16256</Data>
    <Data Name="Image">C:\\Program Files\\Sublime Text 3\\sublime_text.exe</Data>
    <Data Name="FileVersion">3188</Data>
    <Data Name="Description">Sublime Text</Data>
    <Data Name="Product">Sublime Text</Data>
    <Data Name="Company">Sublime HQ Pty Ltd</Data>
    <Data Name="OriginalFileName">sublime_text.exe</Data>
    <Data Name="CommandLine">"/C/Program Files/Sublime Text 3/sublime_text.exe" "--crawl" "14516:crawl:11"</Data>
    <Data Name="CurrentDirectory">C:\\Program Files\\Sublime Text 3\\</Data>
    <Data Name="User">WIN-S1B6IAK3UN2\\Administrator</Data>
    <Data Name="LogonGuid">{68E7DA22-383A-5DF8-0000-0020CBFF0200}</Data>
    <Data Name="LogonId">0x2ffcb</Data>
    <Data Name="TerminalSessionId">2</Data>
    <Data Name="IntegrityLevel">High</Data>
    <Data Name="Hashes">SHA256=450AD9A507403C5A3BA42DC6E1910E84E886200AFD190BF4B0B5B95FC066F7E1</Data>
    <Data Name="ParentProcessGuid">{68E7DA22-A908-5DF8-0000-0010A0B40F01}</Data>
    <Data Name="ParentProcessId">14516</Data>
    <Data Name="ParentImage">C:\\Program Files\\Sublime Text 3\\sublime_text.exe</Data>
    <Data Name="ParentCommandLine">"C:\\Program Files\\Sublime Text 3\\sublime_text.exe"</Data>
  </EventData>
</Event>
 */
DWORD printEvent(EVT_HANDLE hEvent) {
    DWORD errId = ERROR_SUCCESS;
    DWORD dwBufferSize = 0;
    DWORD dwBufferUsed = 0;
    DWORD dwPropertyCount = 0;
    LPWSTR pRenderedContent = NULL;

    if (!EvtRender(NULL, hEvent, EvtRenderEventXml, dwBufferSize, pRenderedContent, &dwBufferUsed, &dwPropertyCount)) {

        errId = GetLastError();
        if(errId == ERROR_INSUFFICIENT_BUFFER) {
            dwBufferSize = dwBufferUsed;
            pRenderedContent = (LPWSTR) malloc(dwBufferSize);
            if(pRenderedContent) {
                EvtRender(NULL, hEvent, EvtRenderEventXml, dwBufferSize, pRenderedContent, &dwBufferUsed, &dwPropertyCount);

            } else {
                wprintf(L"[Error %lu] malloc failed.\n", errId);
                errId = ERROR_OUTOFMEMORY;
            }

        } else if(errId != ERROR_SUCCESS) {
            wprintf(L"[Error %lu] EvtRender failed.\n", errId);
        }
    }

    if(pRenderedContent) {
        delUnASCII(pRenderedContent);
        wprintf(L"%ls\n", pRenderedContent);
        wprintf(L"==================\n");
        free(pRenderedContent);
        errId = ERROR_SUCCESS;
    }
    return errId;
}



// 检测字符串是否为空
bool isEmpty(const char* str) {
    return (str == NULL || strlen(str) <= 0);
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



// ASCII字符 -> 宽字符
LPWSTR toLPWSTR(const char* str) {
    int dwLen = strlen(str) + 1;
    int nwLen = MultiByteToWideChar(CP_ACP, 0, str, dwLen, NULL, 0);
    LPWSTR lpwstr = new WCHAR[dwLen];
    MultiByteToWideChar(CP_ACP, 0, str, dwLen, lpwstr, nwLen);
    return lpwstr;
}



// 把非 ASCII 字符替换成 ?
void delUnASCII(LPWSTR wstr) {
    wchar_t* p = wstr;
    while(*p) {
        if(((int) *p) > 127) {
            *p = '?';
        }
        p++;
    }
}
```


## PowerShell 源码

```powershell
# get_sysmon_event.ps1
#
# sysmon事件查询脚本
# Powershell Script 3.0+
# ---------------------------------------------------------------------------------------
# 脚本使用方式:
#
#   .\get_sysmon_event.ps1 -id 1 -limit 10 -h 0 -m -5 -s 0
#
# ---------------------------------------------------------------------------------------

# id: sysmon事件ID （默认值1）
#       1   Process Creation
#       2   Process Changed a File Creation Time
#       3   Network Connection
#       4   Sysmon Service State Changed
#       5   Process Terminated
#       6   Driver Loaded
#       7   Image Loaded
#       8   Create Remote Thread
#       9   Raw Access Read
#       10  Process Access
#       11  File Create
#       12  Registry Event (Object Create and Delete)
#       13  Registry Event (Value Set)
#       14  Registry Event (Key and Value Rename)
#       15  File Create Stream Hash
#       16  Sysmon Configuration Change
#       17  Named Pipe Created
#       18  Named Pipe Connected
#       255 Error
# limit: 限制单次查询最多获取的事件数 （默认值100）
# h: <=0 的整数，标识查询 h 小时内的事件
# m: <=0 的整数，标识查询 m 分钟内的事件
# s: <=0 的整数，标识查询 s 秒内的事件
param([int]$id=1,[int]$limit=100,[int]$h=0,[int]$m=5,[int]$s=0)

if ($id -lt 1) {
  $id=1
}

if ($limit -lt 1) {
  $limit=100
}


$args = @{}
$args.Add("logname", "Microsoft-Windows-Sysmon/Operational")
$args.Add("id", $id)
$args.Add("StartTime", ((Get-Date).AddHours(-$h).AddMinutes(-$m).AddSeconds(-$s)))
$args.Add("EndTime", (Get-Date))


Get-WinEvent -FilterHashtable $args -MaxEvents $limit | Format-Table -Property message -Wrap
# Get-WinEvent -FilterHashtable $args -MaxEvents $limit | Where{$_.Message -notmatch 'keyword'} | Format-Table -Property message -Wrap

```