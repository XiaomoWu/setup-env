#!/bin/bash

# source general functions
source scripts/functions.sh

#--- script-specific functions ---#
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

    echo "tmux config done!"
}

#--- tmux config ---#
tmux_config