$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $projectRoot
$nodeExe = (Get-Command node -ErrorAction Stop).Source
if (!(Test-Path 'mock_server/node_modules/json-server')) {
  if (Get-Command npm -ErrorAction SilentlyContinue) {
    Push-Location mock_server
    npm ci
    Pop-Location
  } else {
    $npmCli = Join-Path $projectRoot '.tools/package/bin/npm-cli.js'
    if (!(Test-Path $npmCli)) {
      New-Item -ItemType Directory -Force .tools | Out-Null
      Invoke-WebRequest 'https://registry.npmjs.org/npm/-/npm-10.9.2.tgz' -OutFile '.tools/npm.tgz'
      tar -xzf '.tools/npm.tgz' -C '.tools'
    }
    Push-Location mock_server
    & $nodeExe $npmCli ci
    Pop-Location
  }
  if ($LASTEXITCODE -ne 0) { throw 'npm install failed.' }
}
if (!(Test-Path 'build/web/index.html')) {
  flutter pub get
  flutter build web --no-web-resources-cdn
  if ($LASTEXITCODE -ne 0) { throw 'Flutter build failed.' }
}
foreach ($service in @(@{Port=3000;Script='mock_server/server.cjs'},@{Port=8080;Script='scripts/serve-web.cjs'})) {
  $listener = Get-NetTCPConnection -LocalPort $service.Port -State Listen -ErrorAction SilentlyContinue
  if (!$listener) {
    Start-Process -FilePath $nodeExe -ArgumentList $service.Script -WorkingDirectory $projectRoot -WindowStyle Hidden
  }
}
Start-Sleep -Seconds 2
$items=Invoke-RestMethod 'http://localhost:3000/items'
if ($items[0].id -ne 1 -or !$items[0].location) { throw 'Unexpected server on port 3000.' }
Invoke-WebRequest 'http://localhost:8080' -UseBasicParsing | Out-Null
Start-Process 'http://localhost:8080'
Write-Host 'Demo ready: http://localhost:8080. Local servers remain running.'
