﻿$ErrorActionPreference = 'Stop'
$toolsDir              = Split-Path $MyInvocation.MyCommand.Definition
$pp                    = Get-PackageParameters
$silentArgs            = "/qn /norestart REBOOT=ReallySuppress /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""

if (!($pp['icon'])) {
    $silentArgs += 'NO_DESKTOP_SHORTCUT="1" '
}

if (!($pp['KeepUpdateCheck'])) {
    $silentArgs += 'SKIPAUTOUPDATE="1" '
}

if ($pp['NoStart']) {
    $silentArgs += 'NO_START_MENU_SHORTCUTS="1" '
}

if ($pp['NoShell']) {
    $silentArgs += 'NO_SHELL_EXTENSIONS="1" '
}

if ([Environment]::OSVersion.Version.Major -lt 10) {
	Write-Error "$($env:ChocolateyPackageName) requires Windows 10"
}

if ([Environment]::OSVersion.Version.Build -lt 16299) {
	Write-Error "$($env:ChocolateyPackageName) client requires Windows 10 1709 or newer"
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'MSI'
  file 			= Join-Path $toolsDir 'Nextcloud-3.2.1-x86_x32.msi'
  file64        = Join-Path $toolsDir 'Nextcloud-3.2.1-x64_x64.msi'
  silentArgs    = $silentArgs
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'Nextcloud*'
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item -Force -EA 0 -Path $toolsDir\*.msi
