aws_lock() {
    # Check if both AWS_PROFILE and AWS_ACCESS_KEY_ID are set
    if [[ -n "$AWS_PROFILE" && -n "$AWS_ACCESS_KEY_ID" ]]; then
        echo "\033[33m[AWS_PROFILEとAWS_ACCESS_KEY_IDが併存しています]\033[0m" >&2
    fi
}

# Detect shell and set appropriate hook
if [[ -n "$BASH_VERSION" ]]; then
    # Bash
    PROMPT_COMMAND="aws_lock${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
elif [[ -n "$ZSH_VERSION" ]]; then
    # Zsh
    precmd_functions+=(aws_lock)
fi
