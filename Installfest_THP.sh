#!/usr/bin/env bash

setup_color() {
    # Only use colors if connected to a terminal
    if [ -t 1 ]; then
        RED=$(printf '\033[31m')
        GREEN=$(printf '\033[32m')
        YELLOW=$(printf '\033[33m')
        BLUE=$(printf '\033[34m')
        BOLD=$(printf '\033[1m')
        RESET=$(printf '\033[m')
    else
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        BOLD=""
        RESET=""
    fi
}

ask_install_gem() {
    set -- $(locale LC_MESSAGES)
    yesptrn="$1"
    noptrn="$2"
    yesword="$3"
    noword="$4"
    while true; do

        echo ""
        read -p "${YELLOW} Install the Gem "$gem" ? [${yesword}/${noword}]? ${RESET}" yn
        case $yn in
        ${yesptrn##^})
            gem install "$gem"
            break
            ;;
        ${yesword##^})
            gem install "$gem"
            break
            ;;
        ${noptrn##^}) break ;;
        ${noword##^}) break ;;
        *) echo "Answer ${yesword} / ${noword}." ;;
        esac
    done
}

do_you_want_continue() {
    read -n 1 -s -r -p "${GREEN} Press any key to continue ${RESET}"
}

ask() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
    [yY][eE][sS] | [yY])
        $1
        ;;
    *)
        continue
        ;;
    esac
}

header() {
    echo "${YELLOW}#######################################################${RESET}"
    echo ""
    echo "${GREEN}  $1 ${RESET}"
    echo ""
    echo "${YELLOW}#######################################################${RESET}"
}

install_dependencies() {
    header "Dependencies installation for Ruby and RVM"

    do_you_want_continue

    sudo apt-get install autoconf automake bison build-essential curl git-core libapr1 libaprutil1 libc6-dev libltdl-dev libsqlite3-0 libsqlite3-dev libssl-dev libtool libxml2-dev libxslt-dev libxslt1-dev libyaml-dev ncurses-dev nodejs openssl sqlite3 zlib1g zlib1g-dev libreadline7
}

install_RVM() {
    header "RVM installation"

    do_you_want_continue

    sudo apt install gnupg
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -L get.rvm.io | bash -s stable
}

install_Ruby() {
    header "Ruby installation version 2.5.1 with RVM"

    do_you_want_continue

    sudo apt-get install automake
    rvm install 2.5.1
    rvm use 2.5.1
    rvm --default use 2.5.1
}

install_Rails() {
    header "Rails installation version 5.2.3"

    do_you_want_continue

    gem install rails -v 5.2.3
}

install_Heroku() {
    header "Heroku installation"

    do_you_want_continue
    curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
}

gem_installation() {
    header "Gem installation"

    gem_array=(rspec rubocop pry dotenv twitter nokogiri launchy watir selenium-webdriver json colorize sinatra shotgun csv rack sqlite3 faker)

    for gem in "${gem_array[@]}"; do ask_install_gem; done
}

pg_installation() {
    header "PG's gem installation"

    if [[ -r /etc/os-release ]]; then
        . /etc/os-release
        if [[ $ID == ubuntu ]]; then
            read _ UBUNTU_VERSION_NAME <<<"$VERSION"
            echo "Running Ubuntu $UBUNTU_VERSION_NAME"
            sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ $UBUNTU_VERION_NAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
            echo "I add 'deb http://apt.postgresql.org/pub/repos/apt/ $UBUNTU_VERSION_NAME-pgdg main' in /etc/apt/sources.list.d/pgdg.list"
        else
            echo "Not running an Ubuntu distribution. ID=$ID, VERSION=$VERSION"
            sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ $UBUNTU_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
            echo "I add 'deb http://apt.postgresql.org/pub/repos/apt/ $UBUNTU_CODENAME-pgdg main' in /etc/apt/sources.list.d/pgdg.list"
        fi
    else
        echo "Not running a distribution with /etc/os-release available"
    fi
    wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
    sudo apt update
    sudo apt upgrade
    sudo apt install postgresql-common
    sudo apt install postgresql-9.5 libpq-dev
}

check() {
    ruby_version=$(ruby -v)
    rails_version=$(rails -v)
    echo ${ruby_version}
    if [ $ruby_version = "ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]" ]; then
        echo "${GREEN} you have the right version of Ruby ${RESET}"
    else
        echo "${RED} You have not the right version of Ruby ${RESET}"
    fi

    echo ${rails_version}
    if [ $rails_version = "Rails 5.2.3" ]; then
        echo "${GREEN} you have the right version of Rails ${RESET}"
    else
        echo "${RED} You have not the right version of Rails ${RESET}"
    fi
}

menu() {
    clear
    echo "#######################################"
    echo "################# menu ################"
    echo "#######################################"
    echo "     1: Dependencies installation"
    echo "     2: RVM installation"
    echo "     3: Ruby version 2.5.1 installation"
    echo "     4: Rails version 2.5.3 installation"
    echo "     5: Heroku Installation"
    echo "     6: Gem Installation"
    echo "     7: PG's gem installation"
    echo "     q: quit"
    echo "#######################################"
    echo "                             "
    read -p "Enter your choice: " choice
    case "$choice" in
    1)
        install_dependencies
        menu
        ;;
    2)
        install_RVM
        menu
        ;;
    3)
        install_Ruby
        menu
        ;;
    4)
        install_Rails
        menu
        ;;
    5)
        install_Heroku
        menu
        ;;
    6)
        gem_installation
        menu
        ;;
    7)
        pg_installation
        check
        menu
        ;;
    "q" | "q")
        echo "See you next time ..."
        ;;
    *) echo "Bad choice" ;;
    esac
}

display_center(){
    columns="$(tput cols)"
    while IFS= read -r line; do
        printf "%*s\n" $(( (${#line} + columns) / 2)) "$line"
    done < "$1"
}

main() {
    setup_color

    echo "${GREEN}
  _______ _            _    _            _    _               _____           _           _   
 |__   __| |          | |  | |          | |  (_)             |  __ \         (_)         | |  
    | |  | |__   ___  | |__| | __ _  ___| | ___ _ __   __ _  | |__) | __ ___  _  ___  ___| |_ 
    | |  |  _ \ / _ \ |  __  |/ _  |/ __| |/ / |  _ \ / _  | |  ___/  __/ _ \| |/ _ \/ __| __|
    | |  | | | |  __/ | |  | | (_| | (__|   <| | | | | (_| | | |   | | | (_) | |  __/ (__| |_ 
    |_|  |_| |_|\___| |_|  |_|\__,_|\___|_|\_\_|_| |_|\__, | |_|   |_|  \___/| |\___|\___|\__|
                                                       __/ |                _/ |              
                                                      |___/                |__/               
  _____           _        _ _  __          _                                                 
 |_   _|         | |      | | |/ _|        | |                                                
   | |  _ __  ___| |_ __ _| | | |_ ___  ___| |_                                               
   | | |  _ \/ __| __/ _  | | |  _/ _ \/ __| __|                                              
  _| |_| | | \__ \ || (_| | | | ||  __/\__ \ |_                                               
 |_____|_| |_|___/\__\__,_|_|_|_| \___||___/\__|                                              
                                                                                              
${RESET}"
    do_you_want_continue

    if (whiptail --title "WARNING" --yesno "This script allows for a step-by-step installation of all the Inteliseft of The Hacking Progress, the authors will not be in any way responsible for what you made of script.
    
Even if the script was done with love, the author LinkPhoenix of this one is in no way responsible for what you will do in it and is released from all responsibility on the results of this one.
------------------------------------------------------------------------------------------------

By selecting YES you accept it is conditions otherwise please select NO!" 15 100); then
        echo "User selected Yes, exit status was $?."
    else
        echo "User selected No, exit status was $?."
        exit
    fi

    echo "${RED}WARNING
This script allows for a step-by-step installation of all the Inteliseft of The Hacking Progress, the authors will not be in any way responsible for what you made of script${RESET}"
    menu
}

main