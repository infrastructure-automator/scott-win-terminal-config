# Scott's Windows Terminal Configuration
Made so I can easily sync Windows Terminal Settings between my Personal, Work, and Client Computers. 

## Dependencies
1. Oh My Posh (https://ohmyposh.dev/) for stylized prompt
1. LSD (https://github.com/Peltoche/lsd) to improve 'list directory' command
1. WSL (https://learn.microsoft.com/en-us/windows/wsl/about)
1. Clink (https://chrisant996.github.io/clink/) to use Oh My Posh in Command Prompt
1. Caskaydia Cove Nerd Font (https://www.nerdfonts.com/font-downloads)
1. NeoVim (https://neovim.io/) to enhance Vim

## High Level Instructions
1. Clone Repository
1. Open a Native Elevated PowerShell Prompt (Not Windows Terminal PowerShell)
1. Navigate to the copied repository
1. run `./install.ps1`

Note: The Elevated Prompt can be skipped, but manually updating the Windows Terminal Settings JSON will be required.  

## PowerShell Script Descriptions
Script Name | Description
---|---
./install.ps1 | Setup Redirect Profiles in PowerShell, WSL, and Git Bash
./update.ps1 | Updates CLI Profiles and Windows Terminal Settings

## Screenshot
Screenshot of the Windows Terminal Setup showing git-bash, PowerShell, Ubuntu WSL2, and Command Prompt
![Scott's Windows Terminal Screenshot](https://github.com/infrastructure-automator/scott-win-terminal-config/blob/main/screenshot/terminal.png?raw=true)