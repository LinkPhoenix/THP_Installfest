# InstallFest for The Hacking Project

# Description

Scripting aims to automate the installation repairing a working environment for French training The Hacking Project

# How to use

## Prerequisites

- A Unix-like operating system: Linux
- `curl` or `get`should be installed
- The option "Run as a login sheel" must be activated in your terminal's preferences

## With curl

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/LinkPhoenix/THP_Installfest/master/Installfest_THP.sh)"

## With wget

    bash -c "$(https://raw.githubusercontent.com/LinkPhoenix/THP_Installfest/master/Installfest_THP.sh -O -)"

## Manual installation

##### 1. Clone the repository:

    git clone git@github.com:LinkPhoenix/THP_Installfest.git

##### 2. Move to the directory:

    cd THP_Installfest

##### 3. Launch the script with bash

    bash THP_Installfest.sh

# Improvements

- [ ] Impossible launch if you are no Linux user
- [ ] Beautify menu
- [ ] Full reinstall all
- [ ] Install All
- [ ] Check if all is ok
- [ ] Repair
- [ ] Better Warning
- [ ] Logs
- [ ] Install Oh My ZSH
- [ ] Ask which IDE you want (Atom, VsCode, Sublime...)
- [ ] Ask install Git
- [ ] Function for Ask random Question
- [ ] Ask install VIM
- [ ] Ask more information about THP
- [ ] Check if you have SSH Key
