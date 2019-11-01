# InstallFest for The Hacking Project

## Description

Scripting aims to automate the installation repairing a working environment for French training The Hacking Project

## Getting Started

### Prerequisites

- A Unix-like operating system: Linux
- `curl` or `wget`should be installed
- The option "Run as a login sheel" must be activated in your terminal's preferences for the installation of RVM

### Installation via curl

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/LinkPhoenix/THP_Installfest/master/Installfest_THP.sh)"

### Installation via wget

    bash -c "$(https://raw.githubusercontent.com/LinkPhoenix/THP_Installfest/master/Installfest_THP.sh -O -)"

### Manual installation

##### 1. Clone the repository:

    git clone git@github.com:LinkPhoenix/THP_Installfest.git

##### 2. Move to the directory:

    cd THP_Installfest

##### 3. Launch the script with bash

    bash THP_Installfest.sh

## Improvements

- [x] Impossible launch if you are no Linux user
- [x] Beautify menu
- [ ] Full reinstall all
- [ ] Install All
- [ ] Check if all is ok
- [ ] Repair
- [x] Better Warning
- [ ] Logs
- [x] Install Oh My ZSH
- [ ] Ask which IDE you want (Atom, VsCode, Sublime...)
- [ ] Install Git
- [ ] Function for Ask random Question
- [x] Install VIM
- [ ] More information about THP
- [ ] Check if you have SSH Key
- [ ] Install TERMINATOR
- [ ] Config Alias and/or config Plugins OH MY ZSH
- [ ] Send notify-send in all step 
