$value =  [Reflection.AssemblyName]::GetAssemblyName("C:\Newtonsoft.Json.dll")
Write-Host $value
$hexString =  ($value.GetPublicKeyToken()|ForEach-Object ToString x2) -join '' 
Write-Host $hexString

