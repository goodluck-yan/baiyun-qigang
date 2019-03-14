@echo off
title 白云收费亭起杆程序监控脚本



set jarPackage=TestJar.jar
set jarPackagePath=D:\test
set logPath=D:\log.txt
set sleeptime=5

set allMemorySize=600M
set newMemorySize=300M

set logSizeOld=0

:RESTART
wmic process where caption="javaw.exe" get commandline /value | find /C "javaw  -Xms%allMemorySize% -Xmx%allMemorySize% -Xmn%newMemorySize% -Xss256k -XX:PermSize=100m -XX:MaxPermSize=200m -jar %jarPackage%" > temp.txt
set /p num= < temp.txt
del /F temp.txt

tail -1 %logPath% >nul
dir %logPath% | find "1 个文件" > temp2.txt
type temp2.txt
set /p logSizeNew= < temp2.txt
del /F temp2.txt

if "%logSizeNew%" == "%logSizeOld%" (
    echo 收费亭起杆软件日志超过60秒没有变化，开始判断进程是否存在。
    if "%num%" == "0" (   echo %num%
                          echo %date% %time% 日志变化不正常，进程不存在，开始启动程序 >> log.txt
                          echo 没有检测到收费亭起杆软件%jarPackage%进程，准备启动
                          start /D "%jarPackagePath%" javaw -Xms%allMemorySize% -Xmx%allMemorySize% -Xmn%newMemorySize% -Xss256k -XX:PermSize=100m -XX:MaxPermSize=200m -jar %jarPackage%
                          echo 启动完成!
    ) else ( wmic process where caption="javaw.exe" get commandline,ProcessId | find "javaw  -Xms%allMemorySize% -Xmx%allMemorySize% -Xmn%newMemorySize% -Xss256k -XX:PermSize=100m -XX:MaxPermSize=200m -jar %jarPackage%"  > shutdowntemp.txt
             for /f "tokens=1,2,3,4,5,6,7,8,9,10" %%a in (shutdowntemp.txt) do (
                 echo  %%a
                 echo  %%b
                 echo  %%c
                 echo  %%d
                 echo  %%e
                 echo  %%f
                 echo  %%g
                 echo  %%h
                 echo  %%i
                 echo  %%j
                 
                 if "%%j" == "" (echo "%jarPackage%进程不存在") else (
                     echo %date% %time% 日志变化不正常，存在僵死进程，开始重启程序 >> log.txt
                     echo "%jarPackage%进程存在，准备结束进程"
                     echo  杀掉程序进程%%j
                     tskill %%j
                     ping -n 3 -w 30000 localhost >nul
                 )
             
             
             )
             
             goto RESTART
    )


) else (
    echo 收费亭起杆软件日志变化正常，开始判断进程是否存在。
    if "%num%" == "0" (   echo %num%
                          echo 没有检测到收费亭起杆软件%jarPackage%进程，准备启动
                          echo %date% %time% 日志变化正常，但程序没有启动，开始启动程序 >> log.txt
                          start /D "%jarPackagePath%" javaw -Xms%allMemorySize% -Xmx%allMemorySize% -Xmn%newMemorySize% -Xss256k -XX:PermSize=100m -XX:MaxPermSize=200m -jar %jarPackage%
                          echo 启动完成!
    ) else ( echo 存在%num%个收费亭起杆软件%jarPackage%进程 
    )
               
)


set logSizeOld=%logSizeNew%
ping -n %sleeptime% -w 30000 localhost >nul
goto RESTART
