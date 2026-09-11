$ErrorActionPreference = "Stop"
$Godot = if ($env:GODOT_BIN) { $env:GODOT_BIN } else { "godot" }
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Out = Join-Path $Root "web/build"
New-Item -ItemType Directory -Force -Path $Out | Out-Null
& $Godot --headless --path $Root --export-release "Web" (Join-Path $Out "index.html")
Write-Host "Web build criada em $Out"
