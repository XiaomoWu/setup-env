**scripts**
- `python.sh`: script to install python-related packages.
- `requirements.txt`: non-pytorch-related packages
- `requiremsents-pytorch.txt`: pytorch-related packages.

- `r.sh`: scripts to install `r-base` and `r-base-dev`.
    - `r.sh` **WILL NOT** install any R packages as I encounter many issues when using bash scripts.
    - However, `r.sh` **WILL** set the env variable `R_LIBS_USER=$HOME$/R/r-lib`.
- `r-packages.txt`: Frequently used R packages (not used).

- `system.sh`: script to config the system. Currently only `tmux`.
