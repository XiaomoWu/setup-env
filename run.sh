#!/bin/bash

#--- source ---#
source scripts/functions.sh

#--- Install python ---#
get_user_input "Do you want to install python?" "yes" "yes" "no"
install_python=$input

if [[ "$install_python" == "yes" ]]; then
    bash scripts/python.sh
fi

#--- Config system ---#
get_user_input "Do you want to config the system (e.g., prompt, tmux)?" "yes" "yes" "no"
config_system=$input

if [[ "$config_system" == "yes" ]]; then
    bash scripts/system.sh
fi