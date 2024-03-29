#!/bin/bash

#--- source ---#
source scripts/functions.sh

#--- get user input ---#
get_user_input "Do you want to install python?" "yes" "yes" "no"
install_python=$input

get_user_input "Do you want to config the system (e.g., tmux)?" "yes" "yes" "no"
config_system=$input

get_user_input "Do you want to install R?" "yes" "yes" "no"
install_r=$input

#--- Install python ---#
if [[ "$install_python" == "yes" ]]; then
    bash scripts/python.sh
fi

#--- Install R ---#
if [[ "$install_r" == "yes" ]]; then
    bash scripts/r.sh
fi

#--- Config system ---#
if [[ "$config_system" == "yes" ]]; then
    bash scripts/system.sh
fi