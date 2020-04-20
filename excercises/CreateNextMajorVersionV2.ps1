$assembly =  [Reflection.AssemblyName]::GetAssemblyName("C:\Newtonsoft.Json.dll")
Write-Host $assembly.Version

$updatedMajorVersion = $assembly.Version.Major + 1
$minorVersion = $assembly.Version.Minor
$build = $assembly.Version.Build
$revision = $assembly.Version.Revision

$updatedMajorVersionString = "$updatedMajorVersion.$minorVersion.$build.$revision"
Write-Host $updatedMajorVersionString