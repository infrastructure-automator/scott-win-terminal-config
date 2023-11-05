## If not running interactively, don't do anything
case $- in
    *i*) ;;
        *) return;;
esac

## Text Formats
FORMAT_WHITE=$(tput sgr0; tput setaf 15)
FORMAT_BOLD_YELLOW=$(tput sgr0; tput bold; tput setaf 226)
FORMAT_BOLD_PURPLE=$(tput sgr0; tput bold; tput setaf 4)
FORMAT_BOLD_CYAN=$(tput sgr0; tput bold; tput setaf 14)

## Designate Text Formats
NORMAL_TEXT=${FORMAT_WHITE}
HIGHLIGHT_TEXT=${FORMAT_BOLD_YELLOW}
MAIN_TEXT=${FORMAT_BOLD_CYAN}

## Oh-My-Posh Init
function dft {
    echo ${NORMAL_TEXT}"Loading Default Prompt (Type \"${HIGHLIGHT_TEXT}eft${NORMAL_TEXT}\" to switch to Expanded Prompt)"${NORMAL_TEXT}
    eval "$(oh-my-posh --init --shell bash --config ~/.terminal-config/oh-my-posh/scott-default.omp.json )"
}

function eft {
    echo ${NORMAL_TEXT}"Loading Expanded Prompt (Type \"${HIGHLIGHT_TEXT}dft${NORMAL_TEXT}\" to switch to Default Prompt)"${NORMAL_TEXT}
    eval "$(oh-my-posh --init --shell bash --config ~/.terminal-config/oh-my-posh/scott-expanded.omp.json )"
}

## Oh-My-Posh Load Default Prompt
dft

## List Directory Shortcuts
alias ls='lsd        2> /dev/null || ls'
alias ll='lsd -AlF   2> /dev/null || ls -AlF'
alias la='lsd -Al    2> /dev/null || ls -Al'
alias lt='lsd --tree 2> /dev/null || ls'

## Kubectl shortcut
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k

## NeoVIM shortcut
alias vim='nvim 2> /dev/null || vim'

## Quick git Push
function qpush {
    commit_message=${1}

    if [[ -z "${commit_message}" ]]; then
        echo ${HIGHLIGHT_TEXT}"Must Provide a Commit Message"
        return
    fi

    {
        echo; echo ${HIGHLIGHT_TEXT}"git add ."${NORMAL_TEXT}
        git add .
    } && {
        echo; echo ${HIGHLIGHT_TEXT}"git commit -m \""${MAIN_TEXT}"${commit_message}"${HIGHLIGHT_TEXT}\"${NORMAL_TEXT}
        git commit -m "${commit_message}"
    } && {
        echo; echo ${HIGHLIGHT_TEXT}"git push"${NORMAL_TEXT}
        git push
        echo
    }
}
