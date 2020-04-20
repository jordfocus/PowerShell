$majorVersion = "8.18.241.0".Split(".") | select-object -first 1
$updatedMajorVersion = (($majorVersion -as [int]) + 1)

$updatedMajorVersionString = "$updatedMajorVersion.0.0.0"
Write-Host $updatedMajorVersionString