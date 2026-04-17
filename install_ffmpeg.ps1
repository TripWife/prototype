# TripWife - Portable FFMPEG Installer
# Este script descarga y configura ffmpeg localmente en la carpeta del proyecto.

$InstallDir = Join-Path $PSScriptRoot "tools\ffmpeg"
$ZipFile = Join-Path $PSScriptRoot "ffmpeg.zip"
$Url = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"

if (!(Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Force -Path $InstallDir
}

Write-Host "Descargando FFMPEG (esto puede tardar un momento)..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $Url -OutFile $ZipFile

Write-Host "Extrayendo archivos..." -ForegroundColor Cyan
Expand-Archive -Path $ZipFile -DestinationPath $InstallDir -Force

# Limpieza
Remove-Item $ZipFile

# Buscamos la carpeta bin donde está el ejecutable
$FfmpegExe = Get-ChildItem -Path $InstallDir -Filter "ffmpeg.exe" -Recurse | Select-Object -First 1

if ($FfmpegExe) {
    $BinPath = $FfmpegExe.DirectoryName
    Write-Host "`n¡FFMPEG instalado con éxito en: $BinPath" -ForegroundColor Green
    Write-Host "Para usarlo en tus scripts, usa esta ruta absoluta.`n"
} else {
    Write-Host "Error: No se pudo encontrar ffmpeg.exe tras la extracción." -ForegroundColor Red
}
