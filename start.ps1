# Download latest master 
Remove-Item -path $env:windir\temp\zerologon-tester.zip -force -confirm:$false
Remove-Item -path $env:windir\temp\zerologon-tester-master -recurse -confirm:$false
wget "https://codeload.github.com/DTC-Inc/zerologon-tester/zip/master" -outFile $env:windir\temp\zerologon-tester.zip

# Expand-Archive. Updates zerologon-tester with github master.
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}
Unzip $env:windir\temp\zerologon-tester.zip $env:windir\temp


& "$env:windir\temp\zerologon-tester-master\test.ps1"

pause