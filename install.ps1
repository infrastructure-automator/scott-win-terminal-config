###############################################
## Install Scott's Windows Terminal Settings ##
###############################################

${install_location} = "~\.terminal-config"

## Cosmetics
${Normal_Text_Color} = "White"
${Highlight_Text_Color} = "Yellow"
${Command_Text_Color} = "Cyan"
${Error_Text_Color} = "Red"

if (${skip_script_confirmation} -eq $true) {
    Write-Host
    Write-Host -ForegroundColor ${Highlight_Text_Color} "Skipping Confirmation"
    Write-Host
} else {
    ## Continue Confirmation
    Write-Host
    Write-Host -ForegroundColor ${Highlight_Text_Color} "Warning! " -NoNewLine
    Write-Host -ForegroundColor ${Normal_Text_Color} "This Script will overwrite the current PowerShell Profile, Windows bashrc, and WSL 2 bashrc"

    ${continue_response} = read-host "Press enter to continue or any other key (and then enter) to abort"
    ${abort_confirmed} = [bool]${continue_response}

    Write-Host; Write-Host "Abort_Confirmed = ${abort_confirmed}"

    if (${abort_confirmed}) {
        Write-Host -ForegroundColor ${Highlight_Text_Color} "Aborting Script"
        return
    }

    Write-Host -ForegroundColor ${Highlight_Text_Color} "Continuing..."
    Write-Host
}

New-Item -ItemType Directory -Path ${install_location} -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path "$([Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments))\PowerShell" -ErrorAction SilentlyContinue

${starting_directory} = $pwd.Path
${starting_directory_resolved} = Resolve-Path ${install_location}

function profile-update {
    param (
        [Parameter(Mandatory= ${true})]
        [string]${profile_name},

        [Parameter(Mandatory= ${true})]
        [string]${current_file},

        [Parameter(Mandatory= ${true})]
        [string]${backup_file},

        [Parameter(Mandatory= ${true})]
        [string]${redirect_source}
    )

    Write-Host
    Write-Host -ForegroundColor ${Normal_Text_Color} "Processing Profile: " -NoNewLine
    Write-Host -ForegroundColor ${Highlight_Text_Color} "${profile_name}"
    Write-Host -ForegroundColor ${Normal_Text_Color} "Live Path: " -NoNewLine
    Write-Host -ForegroundColor ${Highlight_Text_Color} "${current_file}"
    Write-Host -ForegroundColor ${Normal_Text_Color} "Backup Path: " -NoNewLine
    Write-Host -ForegroundColor ${Highlight_Text_Color} "${backup_file}"
    Write-Host -ForegroundColor ${Normal_Text_Color} "Redirect Path: " -NoNewLine
    Write-Host -ForegroundColor ${Highlight_Text_Color} "${redirect_source}"

    if (Test-Path ${current_file}) {
        Write-Host -ForegroundColor ${Normal_Text_Color} "Backing Up Current Profile"
        Copy-Item -Force -Path ${current_file} -Destination ${backup_file}
    } else {
        Write-Host -ForegroundColor ${Highlight_Text_Color} "${current_file} " -NoNewLine
        Write-Host -ForegroundColor ${Normal_Text_Color} "Not Found. Creating..."
    }

    if (Test-Path ${redirect_source}) {
        Write-Host -ForegroundColor ${Normal_Text_Color} "Replacing with Overwrite Profile"
        Copy-Item -Force -Path ${redirect_source} -Destination ${current_file}
    } else {
        Write-Host -ForegroundColor ${Normal_Text_Color} "${redirect_source} " -NoNewLine
        Write-Host -ForegroundColor ${Error_Text_Color} "Not Found"
    }
}

${profiles_to_redirect} = @(
    @(
        "Windows Terminal Settings", 
        "~\scoop\apps\windows-terminal\current\settings\settings.json", 
        "${starting_directory}\.backups\settings.json", 
        "${starting_directory}\settings\settings.json"
    ),
    @(
        "PowerShell 7 Profile Redirect", 
        "$([Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments))\PowerShell\Microsoft.PowerShell_profile.ps1", 
        "${starting_directory}\.backups\powershell-profile.ps1", 
        "${starting_directory}\redirect-profiles\powershell-profile.ps1"
    ),
    @(
        "Git Bash Profile Redirect", 
        "~\.bashrc", 
        "${starting_directory}\.backups\.bashrc", 
        "${starting_directory}\redirect-profiles\git-bash.bashrc"
    ),
    @(
        "Clink Lua Script Redirect", 
        "~\AppData\local\clink\oh-my-posh.lua", 
        "${starting_directory}\.backups\.bashrc", 
        "${starting_directory}\redirect-profiles\clink.lua"
    )
)

foreach (${target_profile} in ${profiles_to_redirect}) {
    profile-update `
        -profile_name ${target_profile}[0] `
        -current_file ${target_profile}[1] `
        -backup_file ${target_profile}[2] `
        -redirect_source ${target_profile}[3]
}

Write-Host
Write-Host -ForegroundColor ${Normal_Text_Color} "Disable Git editing line endings"
Write-Host -ForegroundColor ${Command_Text_Color} "git config --system core.autocrlf false"
git config --system core.autocrlf false

function setup-redirect-wsl-profile {
    param (
        [Parameter(Mandatory= ${true})]
        [string]${wsl_distribution}
    )

    Write-Host
    Write-Host -ForegroundColor ${Normal_Text_Color} "Backup then Overwrite ${wsl_distribution} WSL .bashrc Profile with a Redirect"
    Invoke-Expression "wsl -d ${wsl_distribution} -- cp ~/.bashrc ~/.bashrc.backup"
    $wsl_bashrc_profile_translated_path = "/mnt/" + ("${pwd}\redirect-profiles\wsl.bashrc").replace("\", "/").replace(":", "").ToLower()
    Invoke-Expression "wsl -d ${wsl_distribution} -- cp ${wsl_bashrc_profile_translated_path} ~/.bashrc"
}

${wsl_distributions} = @(
    "Ubuntu"
    "Debian"
)

foreach (${distributions} in ${wsl_distributions}) {
    setup-redirect-wsl-profile -wsl_distribution ${distributions}
}

if (Test-Path ${install_location}) {
    Write-Host
    Write-Host -ForegroundColor ${Highlight_Text_Color} "Removing old Terminal Settings: "
    Write-Host -ForegroundColor ${Command_Text_Color} "Remove-Item -Path ${install_location} -Recurse -Force -ErrorAction SilentlyContinue"
    Write-Host
    Remove-Item -Path ${install_location} -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host
Write-Host -ForegroundColor ${Highlight_Text_Color} "Creating new Terminal Settings: " 
Write-Host -ForegroundColor ${Command_Text_Color} "New-Item -ItemType Directory -Path `"${install_location}`""
Write-Host
New-Item -ItemType Directory -Path "${install_location}" 
New-Item -ItemType Directory -Path "${install_location}\icons"
New-Item -ItemType Directory -Path "${install_location}\oh-my-posh"
New-Item -ItemType Directory -Path "${install_location}\settings"
New-Item -ItemType Directory -Path "${install_location}\profiles"

. "${starting_directory}/update.ps1"

## Application Specific Settings
Write-Host
Write-Host -ForegroundColor ${Normal_Text_Color} "Run Clink Automatically"
Write-Host -ForegroundColor ${Command_Text_Color} "clink autorun install"
Write-Host
clink autorun install

Write-Host
Write-Host -ForegroundColor ${Normal_Text_Color} "Install Terminal-Icons"
Write-Host -ForegroundColor ${Command_Text_Color} "Install-Module -Scope CurrentUser -Name Terminal-Icons -Repository PSGallery -Force"
Write-Host
Install-Module -Name Terminal-Icons -Scope CurrentUser -Repository PSGallery -Force
