$inn=$args[0]
Write-Output "Found argument $inn"

$base_folder=(Get-Item $inn -ErrorAction Stop)
$base_name=(Get-Item $inn).BaseName
Write-Output "Base name: $base_name"


$target="$PWD/external/$base_name"
Write-Output "Target: $target"

$path="$PWD/extensions/$base_name"
Write-Output "Path: $path"


Write-Output "Linking $target -> $path"
New-Item -Type Junction -Target $target -Path $path
