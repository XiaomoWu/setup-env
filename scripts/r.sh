#!/bin/bash

# source functions
source scripts/functions.sh

# install R Interpreter
install_r_interpreter() {
    # update indices
    sudo apt update -qq

    # install two helper packages we need
    sudo apt install --no-install-recommends software-properties-common dirmngr

    # add the signing key (by Michael Rutter) for these repos
    # To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
    # Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
    
    # add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
    # only install if not exists
    if [ ! -f /etc/apt/sources.list.d/cran.list ]; then
        sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
    fi
    # install R
    sudo apt-get install r-base -y
    sudo apt-get install r-base-dev -y
    
    # add the current R 4.0 or later ‘c2d4u’ repository:
    sudo add-apt-repository ppa:c2d4u.team/c2d4u4.0+

}

# install R packages
install_r_packages() {
    # get R library directory
    get_user_input "Directory to R library?" "$HOME/R/r-lib"
    R_LIBS_USER=$input

    # set R_LIBS_USER in .Renviron
    # create .Renviron if not exists
    if [ ! -f "$HOME/.Renviron" ]; then
        touch "$HOME/.Renviron"
    fi
    append_line "R_LIBS_USER=$R_LIBS_USER" "$HOME/.Renviron"

    # Read package names into an array
    readarray -t PACKAGES < "scripts/r-packages.txt"

    # Convert the Bash array to a string of package names separated by commas for R
    PACKAGE_STRING=$(printf ", '%s'" "${PACKAGES[@]}")
    PACKAGE_STRING=${PACKAGE_STRING:2}  # Remove leading comma and space

    # Create the directory if it doesn't exist
    mkdir -p $R_LIBS_USER

    # # Use Rscript to execute the install.packages command
    Rscript --vanilla -e "install.packages(c($PACKAGE_STRING), lib=\"$R_LIBS_USER\", repos='https://cran.rstudio.com/')"
    echo "Packages installed into: $R_LIBS_USER"
}

#--- update system ---#
update_system

#--- install R ---#
# install_r_interpreter

#--- install R packages ---#
install_r_packages