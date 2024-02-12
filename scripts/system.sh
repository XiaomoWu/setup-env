#!/bin/bash

# source general functions
source functions.sh

#--- script-specific functions ---#
nicer_prompt() {
    # delete .bash_prompt if it exists
    rm -f "$HOME/.bash_prompt"

    # add the following lines to .bash_prompt
    lines='BRACKET_COLOR="\[\033[01;32m\]"  # \[\033[38;5;35m\] is the original color
        CLOCK_COLOR="\[\033[01;32m\]"
        JOB_COLOR="\[\033[01;32m\]"
        PATH_COLOR="\[\033[38;5;33m\]"
        LINE_COLOR="\[\033[38;5;248m\]"

        # uncommend if you want to show "number of suspended jobs"
        # tty -s && export PS1="$LINE_COLOR$LINE_UPPER_CORNER$LINE_STRAIGHT$LINE_STRAIGHT$BRACKET_COLOR$VIRTUAL_ENV_PROMPT[$CLOCK_COLOR\t$BRACKET_COLOR]$LINE_COLOR$LINE_STRAIGHT$BRACKET_COLOR[$JOB_COLOR\j$BRACKET_COLOR]$LINE_COLOR$LINE_STRAIGHT$BRACKET_COLOR[\H:\]$PATH_COLOR\w$BRACKET_COLOR]\n$LINE_COLOR$LINE_BOTTOM_CORNER$LINE_STRAIGHT$LINE_BOTTOM$END_CHARACTER\[$(tput sgr0)\] "

        tty -s && export PS1="$LINE_COLOR┌──$BRACKET_COLOR$VIRTUAL_ENV_PROMPT[$CLOCK_COLOR\t$BRACKET_COLOR]$LINE_COLOR-$BRACKET_COLOR[\H:\]$PATH_COLOR\w$BRACKET_COLOR]
        $LINE_COLOR└──|\[$(tput sgr0)\] "
        '
    # remove leading whitespace
    lines=$(echo "$lines" | sed 's/^[ \t]*//')

    # add the lines to .bash_prompt
    echo "$lines" > "$HOME/.bash_prompt"

    # source .bash_prompt in bin/activate
    add_line "source $HOME/.bash_prompt" "$python_activate_path"

    source "$HOME/.bashrc"

}

tmux_config() {
    # delete .bash_prompt if it exists
    rm -f "$HOME/.tmux.conf"

    # add the following lines to .bash_prompt
    lines='# Set the base-index to 1 rather than 0
        set -g base-index 1
        set-window-option -g pane-base-index 1

        # Send prefix
        set-option -g prefix C-a
        unbind-key C-a
        bind-key C-a send-prefix

        # Use Alt-arrow keys to switch panes
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # Shift arrow to switch windows
        bind -n S-Left previous-window
        bind -n S-Right next-window

        # Mouse mode
        setw -g mouse on

        # Set easier window split keys
        bind-key v split-window -h
        bind-key h split-window -v

        # Eassily reorder windows with CTRL+SHIFT+Arrow
        bind-key -n C-S-Left swap-window -t -1
        bind-key -n C-S-Right swap-window -t +1

        # Easy config reload
        bind-key r source-file ~/.tmux.conf \; display-message "~/.tmux.conf reloaded."

        # Synchronize panes
        bind-key y set-window-option synchronize-panes\; display-message "synchronize mode toggled."
        '
    # remove leading whitespace
    lines=$(echo "$lines" | sed 's/^[ \t]*//')

    # add the lines to .tmux.conf
    echo "$lines" > "$HOME/.tmux.conf"
}

#--- nicer prompt ---#
nicer_prompt

#--- tmux config ---#
tmux_config