# If not running interactively, don't do anything
case $- in
    *i*) ;;
        *) return;;
esac

## Redirecting Profile to Scott's Terminal Configuration
windows_username=$(powershell.exe -NoProfile '$env:UserName' | tr -d '\r')
PROFILE_REDIRECT="/mnt/c/Users/$windows_username/.terminal-config/profiles/wsl.bashrc"
source ${PROFILE_REDIRECT}
