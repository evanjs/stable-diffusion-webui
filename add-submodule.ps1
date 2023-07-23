$inn=$args[0]
Write-Output "Found argument $inn"
$name=(Write-Output "$inn" | Split-String -Separator '/')[4]
Write-Output "Name: $name"
git submodule add $inn "./external/$name"
New-Item -Type Junction -Target $PWD/external/$name $PWD/extensions/$name
