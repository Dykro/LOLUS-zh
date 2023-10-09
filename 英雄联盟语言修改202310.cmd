@echo off
chcp 65001 > nul

set process_name=RiotClientServices.exe
set process2_name=LeagueClient.exe

taskkill /f /im %process_name% >nul 2>nul
if %errorlevel% equ 0 (
    echo 已成功关闭 %process_name%.
) else (
    echo %process_name% 没有在运行.
)

taskkill /f /im %process2_name% >nul 2>nul
if %errorlevel% equ 0 (
    echo 已成功关闭 %process2_name%.
) else (
    echo %process2_name% 没有在运行.
)
echo -------------------------------------------
echo 描述^：英雄联盟外服语言修改
echo 日期^：2023-10-09
echo 版本^：1.2
echo 使用问题联系Discord^：holysweetorange
echo -------------------------------------------
echo 选择您的语言^：
echo -------------------------------------------
echo 1. Chinese
echo 2. English
echo -------------------------------------------
set /p lang=请输入编号(1/2)：
if "%lang%"=="1" (
    set locale=zh_CN
) else if "%lang%"=="2" (
    set locale=en_US
) else (
    echo 无效的输入，请重新运行脚本并输入 1 或 2。
    pause
    exit /b 1
)


setlocal enableDelayedExpansion


set locations=^
"C:\Riot Games\League of Legends" ^n
"D:\Riot Games\League of Legends" ^n
"E:\Riot Games\League of Legends" ^n
"F:\Riot Games\League of Legends" ^n
"C:\Program Files\Riot Games\League of Legends" ^n
"C:\Program Files (x86)\Riot Games\League of Legends" ^n
"D:\Program Files\Riot Games\League of Legends" ^n
"D:\Program Files (x86)\Riot Games\League of Legends" ^n
"E:\Program Files\Riot Games\League of Legends" ^n
"E:\Program Files (x86)\Riot Games\League of Legends" ^n
"F:\Program Files\Riot Games\League of Legends" ^n
"F:\Program Files (x86)\Riot Games\League of Legends"

for %%i in (%locations%) do (
  set folder=%%~i
  if exist "!folder!\LeagueClient.exe" (
    set client=!folder!\LeagueClient.exe
    echo Found client at !client!
    goto :done
  )
)

echo Client not found in standard locations. Searching registry...

set key=HKLM\SOFTWARE\Riot Games\League of Legends
set value=Path
set found=false

for /f "tokens=2*" %%i in ('reg query "%key%" /v "%value%" 2^>nul ^| findstr /r /c:"REG_"') do (
  set client=%%j\LeagueClient.exe
  if exist "!client!" (
    echo Found client at !client!
    set found=true
    goto :done
  )
)

if not %found% == true (
  echo Client not found in registry. Exiting...
  pause
  exit
)

:done
echo Launching client at !client! with --locale=zh_CN...
start "" "!client!" --locale=%locale%
