@echo off
chcp 65001 > nul
setlocal

set FOUND=0

:: 尝试从 C 到 Z 盘搜索 ProgramData\Riot Games 目录
for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%D:\ProgramData\Riot Games\Metadata\league_of_legends.live\league_of_legends.live.product_settings.yaml (
        set CONFIG_PATH=%%D:\ProgramData\Riot Games\Metadata\league_of_legends.live\league_of_legends.live.product_settings.yaml
        set FOUND=1
	goto found
    )
)
:found
if %FOUND%==1 (
    	echo Found configuration at %CONFIG_PATH%
) else (
    	echo Configuration file not found on any drive.
	goto end
)



set "process_name=RiotClientServices.exe"
set "process2_name=LeagueClient.exe"

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
echo 日期^：2024-05-11
echo 版本^：2.1
echo 使用问题联系Discord^：holysweetorange
echo -------------------------------------------
echo 请选择^：
echo -------------------------------------------
echo 1. 设置为中文简体语言包+语音包;
echo 2. 重置语言设置;
echo -------------------------------------------
set /p lang=请输入编号(1/2)：


echo Modifying permissions to grant write access...
icacls "%CONFIG_PATH%" /grant Administrators:(F)
echo Removing read-only attribute...
attrib -r "%CONFIG_PATH%"

if "%lang%" NEQ "1" (
 	goto end
)

:: 创建原文件的备份
echo Creating backup...
copy "%CONFIG_PATH%" "%CONFIG_PATH%.bak"
if %ERRORLEVEL% neq 0 (
    echo Backup failed. Script will now exit.
    goto end
)

:: 使用PowerShell添加zh_CN到available_locales列表中的正确位置，并更新locale设置
echo Updating available_locales and setting locale to zh_CN...
powershell -Command "$file = Get-Content '%CONFIG_PATH%'; $updated = $false; $output = @(); $zhCNExists = $file -contains '    - \"zh_CN\"'; foreach ($line in $file) { $output += $line; if (-not $updated -and -not $zhCNExists -and $line -match 'pt_BR') { $output += '    - \"zh_CN\"'; $updated = $true; } }; $output -replace 'locale: .+', 'locale: \"zh_CN\"' | Set-Content '%CONFIG_PATH%'"

echo Setting file to read-only...
attrib +r "%CONFIG_PATH%"

echo Modifying permissions to deny write access...
icacls "%CONFIG_PATH%" /deny Administrators:(WD,AD,WEA,WA)
echo -------------------------------------------
echo 语言设置已完成，请手动打开英雄联盟客户端。
echo -------------------------------------------
echo 语言设置成功后下次可以直接启动游戏，无需进入脚本
echo 如果想更改其他语言请重新打开脚本，选择2重置语言
echo -------------------------------------------
:end
pause
endlocal
