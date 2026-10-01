[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Puti-AI 錄音極致壓縮工具 (轉為 檔名_人聲.m4a)"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Puti-AI 錄音極致壓縮工具 (NotebookLM 專用)" -ForegroundColor Yellow
Write-Host "  目標：單聲道 + 32kbps AAC M4A (3小時約 40MB)" -ForegroundColor White
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $scriptDir) { $scriptDir = (Get-Location).Path }

$ffmpeg = Join-Path $scriptDir "ffmpeg.exe"
if (-not (Test-Path -LiteralPath $ffmpeg)) {
    $ffmpegCmd = Get-Command ffmpeg -ErrorAction SilentlyContinue
    if ($ffmpegCmd) { $ffmpeg = $ffmpegCmd.Source }
}

if (-not (Test-Path -LiteralPath $ffmpeg) -and -not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Write-Host "[錯誤] 找不到 ffmpeg.exe 核心！" -ForegroundColor Red
    Write-Host "請將 ffmpeg.exe 放在與此程式相同的資料夾內。" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "請按 Enter 鍵結束"
    exit
}

if ($args.Count -eq 0) {
    Write-Host "【使用方式】" -ForegroundColor Yellow
    Write-Host "請直接將「錄音檔」或「影片檔」拖曳丟到「壓縮音訊_人聲.bat」圖示上即可！" -ForegroundColor Gray
    Write-Host "支援格式：.mp3, .wav, .m4a, .mp4, .aac, .flac 等" -ForegroundColor Gray
    Write-Host ""
    Read-Host "請按 Enter 鍵結束"
    exit
}

$count = 0
$total = $args.Count
foreach ($item in $args) {
    $count++
    if (Test-Path -LiteralPath $item) {
        $fileInfo = Get-Item -LiteralPath $item
        $dir = $fileInfo.DirectoryName
        $baseName = $fileInfo.BaseName
        $outPath = Join-Path $dir "$($baseName)_人聲.m4a"
        
        Write-Host "[$count/$total 處理中] $($fileInfo.Name) -> $($baseName)_人聲.m4a ..." -ForegroundColor Green
        & $ffmpeg -y -i $item -vn -ac 1 -ar 24000 -c:a aac -b:a 32k $outPath -loglevel error -stats
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   [成功] 已儲存至: $($baseName)_人聲.m4a" -ForegroundColor Cyan
        } else {
            Write-Host "   [失敗] 處理 $($fileInfo.Name) 時發生錯誤！" -ForegroundColor Red
        }
        Write-Host "--------------------------------------------------------" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "所有檔案處理完畢！" -ForegroundColor Green
Write-Host ""
Read-Host "請按 Enter 鍵結束"