# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
     $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
     Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
     Exit
    }
}

Set-ExecutionPolicy -executionPolicy unrestricted -force -scope localMachine

Remove-Item -path $env:windir\temp\zerologon_tester.zip -force -confirm:$false
wget "https://codeload.github.com/DTC-Inc/zerologon-tester/zip/master" -outFile $env:windir\temp\zerologon-tester.zip

# Expand-Archive. Updates zerologon-tester with github master.
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}
$cur=(Get-Location).Path
Unzip $env:windir\temp\zerologon-tester.zip $env:windir\temp\zerologon-tester


$dcname=[System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().PdcRoleOwner.Name.split('.')[0]
$dcip=[System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().PdcRoleOwner.IPAddress
echo "[*] DC: $dcip ($dcname)"
cd $cur\zerologon_tester\
.\bin\zerologon_tester.exe $dcname $dcip


Set-ExecutionPolicy -executionPolicy remoteSigned -force -scope localMachine

