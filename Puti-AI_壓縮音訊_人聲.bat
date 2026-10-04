@echo off
setlocal
title Audio Compress Tool
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0compress.ps1" %*