#Requires -Version 5.1
<#
  activate-desktop.ps1 — 让桌面端真正加载已打补丁的 resources\app

  背景：官方桌面把代码装在 resources\app.asar 里，插件只能改解开的 resources\app。
  asar 还在时 Electron 优先读 asar，代码补丁等于没打（提示词注入不受影响）。
  这个脚本：结束进程 → 把 app.asar 改名备份 → 重新启动。

  用法：
    powershell -ExecutionPolicy Bypass -File scripts\activate-desktop.ps1
    powershell -ExecutionPolicy Bypass -File scripts\activate-desktop.ps1 -Revert

  注意：会强制结束 "DeepSeek Harness" 全部进程。
#>
param(
  [switch]$Revert,
  [string]$Resources = "D:\trea\dsh\resources",
  [string]$Exe = "D:\trea\dsh\DeepSeek Harness.exe"
)

$asar = Join-Path $Resources "app.asar"
$bak = Join-Path $Resources "app.asar.bak"
$app = Join-Path $Resources "app"

function Stop-Harness {
  Get-Process -Name "DeepSeek Harness" -ErrorAction SilentlyContinue |
    ForEach-Object { $_.Kill(); "killed pid $($_.Id)" }
  Start-Sleep -Seconds 3
}

if (-not (Test-Path $app)) { throw "missing unpacked app dir: $app" }

if ($Revert) {
  Stop-Harness
  if (-not (Test-Path $bak)) { throw "no backup to restore: $bak" }
  if (Test-Path $asar) { Remove-Item -LiteralPath $asar -Force }
  Rename-Item -LiteralPath $bak -NewName "app.asar"
  "reverted: app.asar restored"
  if (Test-Path $Exe) { Start-Process $Exe; "started $Exe" }
  return
}

if (-not (Test-Path $asar)) {
  "app.asar already absent — patched app dir is active; nothing to do"
  if (-not (Get-Process -Name "DeepSeek Harness" -ErrorAction SilentlyContinue)) {
    if (Test-Path $Exe) { Start-Process $Exe; "started $Exe" }
  }
  return
}

Stop-Harness

try {
  Rename-Item -LiteralPath $asar -NewName "app.asar.bak" -ErrorAction Stop
  "renamed app.asar -> app.asar.bak"
} catch {
  throw "rename failed (still locked?): $($_.Exception.Message)"
}

if (Test-Path $Exe) { Start-Process $Exe; "started $Exe" } else { "WARN: exe not found, start it manually: $Exe" }
"done. rollback: -Revert"
