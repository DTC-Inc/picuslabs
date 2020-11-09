#init variables. the install path is passed from a single argument when launching the script.
$installPath = $arg[0]

# Download latest master 
Remove-Item -path $env:windir\temp\zerologon-tester.zip -force -confirm:$false
Remove-Item -path $installPath\temp\zerologon-tester-master -recurse -confirm:$false
wget "https://codeload.github.com/DTC-Inc/zerologon-tester/zip/master" -outFile $env:windir\temp\zerologon-tester.zip

# Expand-Archive. Updates zerologon-tester with github master.
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}
Unzip $env:windir\temp\zerologon-tester.zip $installPath