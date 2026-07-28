$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoRoot

$env:OPEN_NOTEBOOK_WORKER_MAX_TASKS = if ($env:OPEN_NOTEBOOK_WORKER_MAX_TASKS) { $env:OPEN_NOTEBOOK_WORKER_MAX_TASKS } else { '1' }
$env:API_URL = 'http://127.0.0.1:5055'
$env:INTERNAL_API_URL = 'http://127.0.0.1:5055'

$composeFile = Join-Path $repoRoot 'examples/docker-compose-dev.yml'

if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host 'Starting SurrealDB via Docker Compose...'
    & docker compose -f $composeFile --project-directory $repoRoot up -d surrealdb
}
elseif (Get-Command surreal -ErrorAction SilentlyContinue) {
    Write-Host 'Starting SurrealDB via local SurrealDB binary...'
    $dbPath = Join-Path $repoRoot 'surreal_data/mydatabase.db'
    New-Item -ItemType Directory -Force -Path (Split-Path $dbPath -Parent) | Out-Null
    Start-Process -FilePath 'surreal' -ArgumentList @('start','--user','root','--pass','root','--bind','127.0.0.1:8000', "rocksdb:$dbPath") -WindowStyle Hidden
}
else {
    throw 'Neither docker nor surreal is available in this environment.'
}

Write-Host 'Starting API backend...'
$api = Start-Process -FilePath 'uv' -ArgumentList @('run','--env-file','.env','run_api.py') -WorkingDirectory $repoRoot -PassThru

Write-Host 'Starting worker...'
$worker = Start-Process -FilePath 'uv' -ArgumentList @('run','--env-file','.env','surreal-commands-worker','--import-modules','commands','--max-tasks',$env:OPEN_NOTEBOOK_WORKER_MAX_TASKS) -WorkingDirectory $repoRoot -PassThru

Write-Host 'Starting frontend...'
$frontend = Start-Process -FilePath 'npm.cmd' -ArgumentList @('run','dev') -WorkingDirectory (Join-Path $repoRoot 'frontend') -PassThru

Write-Host 'Services started.'
Write-Host "API: http://127.0.0.1:5055"
Write-Host "Frontend: http://127.0.0.1:3000"
