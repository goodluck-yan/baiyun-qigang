@echo off
title �����շ�ͤ��˳����ؽű�



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
dir %logPath% | find "1 ���ļ�" > temp2.txt
type temp2.txt
set /p logSizeNew= < temp2.txt
del /F temp2.txt

if "%logSizeNew%" == "%logSizeOld%" (
    echo �շ�ͤ���������־����60��û�б仯����ʼ�жϽ����Ƿ���ڡ�
    if "%num%" == "0" (   echo %num%
                          echo %date% %time% ��־�仯�����������̲����ڣ���ʼ�������� >> log.txt
                          echo û�м�⵽�շ�ͤ�������%jarPackage%���̣�׼������
                          start /D "%jarPackagePath%" javaw -Xms%allMemorySize% -Xmx%allMemorySize% -Xmn%newMemorySize% -Xss256k -XX:PermSize=100m -XX:MaxPermSize=200m -jar %jarPackage%
                          echo �������!
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
                 
                 if "%%j" == "" (echo "%jarPackage%���̲�����") else (
                     echo %date% %time% ��־�仯�����������ڽ������̣���ʼ�������� >> log.txt
                     echo "%jarPackage%���̴��ڣ�׼����������"
                     echo  ɱ���������%%j
                     tskill %%j
                     ping -n 3 -w 30000 localhost >nul
                 )
             
             
             )
             
             goto RESTART
    )


) else (
    echo �շ�ͤ���������־�仯��������ʼ�жϽ����Ƿ���ڡ�
    if "%num%" == "0" (   echo %num%
                          echo û�м�⵽�շ�ͤ�������%jarPackage%���̣�׼������
                          echo %date% %time% ��־�仯������������û����������ʼ�������� >> log.txt
                          start /D "%jarPackagePath%" javaw -Xms%allMemorySize% -Xmx%allMemorySize% -Xmn%newMemorySize% -Xss256k -XX:PermSize=100m -XX:MaxPermSize=200m -jar %jarPackage%
                          echo �������!
    ) else ( echo ����%num%���շ�ͤ�������%jarPackage%���� 
    )
               
)


set logSizeOld=%logSizeNew%
ping -n %sleeptime% -w 30000 localhost >nul
goto RESTART