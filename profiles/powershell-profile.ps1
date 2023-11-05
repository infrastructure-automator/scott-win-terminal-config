Import-Module -Name Terminal-Icons
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

## Cosmetics
${NORMAL_TEXT_COLOR} = "White"
${HIGHLIGHT_TEXT_COLOR} = "Yellow"

## Daily Update Script
${LAST_RUN_SAVE_LOCATION} = "~\.terminal-config\last-update-script-run.txt"
${TODAYS_DATE} = (Get-Date).ToString("yyyy-MM-dd")
if (Test-Path ${LAST_RUN_SAVE_LOCATION}) { ${LAST_RUN_DATE} = Get-Content ${LAST_RUN_SAVE_LOCATION} }

if (!(${LAST_RUN_DATE} -eq ${TODAYS_DATE})) {
    Set-Content -Path ${LAST_RUN_SAVE_LOCATION} -Value (Get-Date).ToString("yyyy-MM-dd")
    scoop update *
}

## Oh-My-Posh Init
function dft {
    Write-Host -ForegroundColor ${NORMAL_TEXT_COLOR} "Loading Default Prompt (Type `"" -NoNewline
    Write-Host -ForegroundColor ${HIGHLIGHT_TEXT_COLOR} "eft" -NoNewline
    Write-Host -ForegroundColor ${NORMAL_TEXT_COLOR} "`" to switch to Expanded Prompt)"
    oh-my-posh init pwsh --config "~\.terminal-config\oh-my-posh\scott-default.omp.json" | Invoke-Expression    
}

function eft {
    Write-Host -ForegroundColor ${NORMAL_TEXT_COLOR} "Loading Expanded Prompt (Type `"" -NoNewline
    Write-Host -ForegroundColor ${HIGHLIGHT_TEXT_COLOR} "dft" -NoNewline
    Write-Host -ForegroundColor ${NORMAL_TEXT_COLOR} "`" to switch to Default Prompt)"
    oh-my-posh init pwsh --config "~\.terminal-config\oh-my-posh\scott-expanded.omp.json" | Invoke-Expression
}

## Load Default Oh-My-Posh Prompt
dft

## List Directory Shortcuts
Set-Alias -Name ll -Value "dir"
Set-Alias -Name la -Value "dir"
Set-Alias -Name ls -Value "dir"

function lt {
    lsd --tree
}

## NeoVIM shortcut
Set-Alias -Name vim -Value "nvim"

# Quick git Push
function qpush {
    param([string]${commit_message})

    if (-not ${commit_message}) {
        Write-Host "Must Provide a Commit Message" -ForegroundColor ${HIGHLIGHT_TEXT_COLOR}
        return
    }

    try {
        Write-Host; Write-Host "git add ." -ForegroundColor ${HIGHLIGHT_TEXT_COLOR}
        git add .

        Write-Host; Write-Host "git commit -m " -ForegroundColor ${HIGHLIGHT_TEXT_COLOR} -NoNewline
        Write-Host "`"${commit_message}`"" -ForegroundColor ${NORMAL_TEXT_COLOR}
        git commit -m "${commit_message}"

        Write-Host; Write-Host "git push" -ForegroundColor ${HIGHLIGHT_TEXT_COLOR}
        git push
    }

    catch {
        Write-Error "Error occurred during git operations."
    }
}
