@echo off
chcp 65001 >nul
title 音訊極限壓縮工具 - 產出「檔名_人聲.m4a」 (Drag & Drop)

echo ========================================================
echo   語音/演講音訊極限壓縮工具 (支援拖曳多個檔案)
echo   目標：轉為 單聲道 + 32kbps AAC M4A (3小時音檔約 40MB)
echo   輸出：檔名_人聲.m4a
echo ========================================================
echo.

if "%~1"=="" (
    echo 【使用說明】
    echo 請直接將「錄音檔 / 影片檔 (mp3, wav, m4a, mp4 等)」
    echo 拖曳到這個 .bat 檔案圖示上即可自動轉檔！
    echo.
    pause
    exit /b
)

:LOOP
if "%~1"=="" goto END

set "INPUT_FILE=%~1"
set "OUTPUT_FILE=%~dpn1_人聲.m4a"

echo 正在壓縮: "%~nx1" ...
ffmpeg -y -i "%INPUT_FILE%" -vn -ac 1 -ar 24000 -c:a aac -b:a 32k "%OUTPUT_FILE%" -loglevel error -stats

if %ERRORLEVEL% equ 0 (
    echo [成功] 已產出: "%~nx1" -^> "%~n1_人聲.m4a"
) else (
    echo [失敗] 處理 "%~nx1" 時發生錯誤。
)
echo --------------------------------------------------------

shift
goto LOOP

:END
echo.
echo 所有檔案處理完畢！
echo 檔案已儲存在原檔案相同目錄下。
echo.
pause
