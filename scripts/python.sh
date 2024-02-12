#!/bin/bash

# source functions
source functions.sh


# install python interpreter
install_python_interpreter() {
    # add deadsnake ppa (the python versions from the default repo are OUTDATED)

    # Define the PPA
    PPA="deadsnakes/ppa"

    # only add the PPA if it's not already added
    if ! grep -q "^deb .*$PPA" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        echo "Adding $PPA"
        sudo add-apt-repository -y ppa:$PPA
        sudo apt-get update
    else
        echo "$PPA is already added."
    fi

    # install python
    sudo apt-get install "$python_version_long"-full -y  # python
    sudo apt-get install "$python_version_long"-dev -y  # dev tools
    sudo apt-get install python3-pip  -y  # pip
}

# create python env
create_python_env() {
    local line
    local python_version2
    local act_string
    local last_non_blank_line

    python_env_dir="$python_env_root/$python_env_name"  # e.g., /home/yu/python-env/py311.5-base
    python_interpreter_path="$python_env_dir/bin/python"  # the path to the python interpreter
    python_activate_path="$python_env_dir/bin/activate"  # the path to the activate file

    "/bin/$python_version_long" -m venv --upgrade-deps --copies --clear "$python_env_dir"

    if [[ "$activate_env" == "yes" ]]; then
        act_string="source $python_activate_path # activate the chosen env with the start of a terminal"
        append_line "$act_string" "$HOME/.bashrc"
    else
        echo "The env \"$python_env_name\" is not activated with the start of the terminal."
    fi

    # add python env to alias
    line="alias $python_env_name='source $python_activate_path'"
    append_line "$line" "$HOME/.bash_aliases"
    echo "alias \"$python_env_name\" is added to ~/.bash_aliases"

    source "$HOME/.bashrc"
    source "$python_activate_path"

}

# install python packages
install_python_package() {
    local package

    # install requirements.txt
    $python_interpreter_path -m pip install -r requirements.txt

    # install pytorch-related packages
    if [[ "$install_pytorch" == "yes" ]]; then
        # install pytorch
        $python_interpreter_path -m pip install torch torchvision torchaudio

        # install deepspeed
        $python_interpreter_path -m pip install deepspeed
    fi

}

# config jupyter
config_jupyter() {
    # create the ipython_config.py file
    "${python_env_dir}/bin/ipython" profile create
    ipython_config_path="$HOME/.ipython/profile_default/ipython_config.py"

    # print out *all* the results of a cell, not just the last one
    sed -i "/c.InteractiveShell.ast_node_interactivity/ { s/^# //; s/'last_expr'/'all'/; }" "$ipython_config_path"
}


#--- get variables ---#

# python version (e.g., 3.11)
get_user_input "Please select the python version you want to install" "3.11" "3.10" "3.11" "3.12"
python_version=$input

# python version full (e.g., python3.11)
python_version_long="python${python_version}"

# python version2 (e.g., 311.5)
python_version2=$($python_version_long --version)  # e.g, Python 3.11.5
python_version2="${python_version2//Python /}"  # remove "Python " from the string
python_version2="${python_version2/./}"  # "3.11.5" -> "311.5

# python env suffix (e.g., py311.5-"base")
get_user_input "Please enter the python env suffix. The suffix should not contain any special characters (e.g., - or _):" "base"
python_env_suffix=$input

# python env name
python_env_name="py${python_version2}-$python_env_suffix"  # e.g., py311.5-base

# whether to install pytorch-related packages
get_user_input "Do you want to install the "latest" Pytorch-related packages? Make sure your CUDA version meet the Pytorch requirements." "no" "yes" "no"
install_pytorch=$input

# whether activate the chosen env with the start of a terminal
get_user_input "Do you want to activate \"$python_env_name\" with the start of the terminal?" "no" "yes" "no"
activate_env=$input

# python envs root directory (e.g., /home/yu/python-env)
get_user_input "Please enter the python envs root directory. The directory should either be absolute (e.g., /home/yu/python-env) or only contains a \"~\" (e.g., ~/python-env):" "~/Software/python/python-env"
python_env_root=$input
python_env_root=${python_env_root/#\~/$HOME}  # expand "~""

#--- update the system ---#
update_system

#--- install python interpreter---#
install_python_interpreter

#--- create python env ---
create_python_env

#--- install python packages ---
install_python_package

#--- config jupyter ---#
config_jupyter

