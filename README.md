<h1 align="center">
  <a href="https://www.thehackingproject.org/">
    <img alt="spaceship →~ prompt" src="https://user-images.githubusercontent.com/33618968/68535560-68417080-0344-11ea-9874-bfe991c361cf.jpg" width="400">
  </a>
  <br>The Hacking Project<br>
</h1>

<h4 align="center">
  <a href="https://installfest.railsbridge.org/installfest/" target="_blank"><code>InstallFest</code></a>
</h4>

<p align="center">
  <a href="https://twitter.com/the_hacking_pro">
    <img src="https://img.shields.io/badge/twitter-%40The_Hacking_Pro-00ACEE.svg?style=flat-square"
      alt="The Hacking project Twitter" />
  </a>

  <a href="https://www.instagram.com/the_hacking_project">
    <img src="https://img.shields.io/badge/instagram-%40The_Hacking_Project-C42E73.svg?style=flat-square"
      alt="The Hacking project Twitter" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/LinkPhoenix">
    <img src="https://img.shields.io/github/followers/LinkPhoenix?style=social"
      alt="Followers" />
  </a>

  <a href="https://github.com/LinkPhoenix/THP_Installfest/commits/master">
    <img src="https://img.shields.io/github/last-commit/LinkPhoenix/THP_Installfest?style=flat-square"
      alt="Commits" />
  </a>

</p>

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
