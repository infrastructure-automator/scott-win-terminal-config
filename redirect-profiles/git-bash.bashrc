## If not running interactively, don't do anything
case $- in
    *i*) ;;
        *) return;;
esac

## Redirecting Profile to Scott's Terminal Configuration
PROFILE_REDIRECT=~/.terminal-config/profiles/git-bash.bashrc
source ${PROFILE_REDIRECT}
