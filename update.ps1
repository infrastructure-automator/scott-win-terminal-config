$install_location = "~\.terminal-config"

$starting_directory = $pwd.Path
$install_location_resolved = Resolve-Path $install_location

Write-Host
Write-Host "Starting Directory is:" $starting_directory
Write-Host "Install Location is:" $install_location_resolved
Write-Host

Write-Host "Copying Windows Terminal Icons to Home Directory"
Copy-Item -Path "${starting_directory}\icons\*" -Destination "${install_location_resolved}\icons" -Recurse -Force

Write-Host "Copying Oh My Posh Profile to Home Directory"
Copy-Item -Path "${starting_directory}\oh-my-posh\*" -Destination "${install_location_resolved}\oh-my-posh" -Recurse -Force

Write-Host "Copying Windows Terminal JSON Settings to Home Directory"
Copy-Item -Path "${starting_directory}\settings\*" -Destination "${install_location_resolved}\settings" -Recurse -Force

Write-Host "Copying Command Line Profiles to Home Directory"
Copy-Item -Path "${starting_directory}\profiles\*" -Destination "${install_location_resolved}\profiles" -Recurse -Force

Write-Host; Write-Host "Reloading Profile"
. $PROFILE