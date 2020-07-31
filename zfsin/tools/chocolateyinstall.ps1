﻿$ErrorActionPreference = 'Stop'; 
$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation          = (Get-ChildItem $toolsDir -Filter "*.exe").FullName
$cerLocation           = Join-Path $toolsDir 'ZFSin.cer'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  file64        = $fileLocation
  softwareName  = 'OpenZFS On Windows'
  silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0) 
}

certutil -addstore -f "TrustedPublisher" $cerLocation

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $fileLocation -force -ea 0 