#!/bin/bash
#https://blog.dorian-depriester.fr/linux/rediriger-les-messages-dun-script-dans-des-fichiers-log
# exec 3>&1 4>&2
# trap 'exec 2>&4 1>&3' 0 1 2 3
# exec 1>log.out 2>&1

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

press_any_key_to_continue() {
    read -n 1 -s -r -p "${GREEN} Press any key to continue `echo $'\n '`${RESET}"
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
    clear
    echo ""
    echo "${YELLOW}#######################################################${RESET}"
    echo ""
    echo "${GREEN}  $1 ${RESET}"
    echo ""
    echo "${YELLOW}#######################################################${RESET}"
    echo ""
    echo ""
}

install_dependencies() {
    header "Dependencies installation for Ruby and RVM"

    press_any_key_to_continue

    sudo apt-get install autoconf automake bison build-essential curl git-core libapr1 libaprutil1 libc6-dev libltdl-dev libsqlite3-0 libsqlite3-dev libssl-dev libtool libxml2-dev libxslt-dev libxslt1-dev libyaml-dev ncurses-dev nodejs openssl sqlite3 zlib1g zlib1g-dev libreadline7

    press_any_key_to_continue
}

install_RVM() {
    header "RVM installation"

    press_any_key_to_continue

    if hash gpg 2>/dev/null; then
        echo "GPG is detected on your system"
        echo "I Will install RVM"
        press_any_key_to_continue
    else
        echo "GPG is not detected in your system"
        echo "I need it for install RVM"
        echo "I will install it with sudo"
        press_any_key_to_continue
        sudo apt install gnupg
        echo "Now I will install RVM"
        press_any_key_to_continue
    fi
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -L get.rvm.io | bash -s stable

    press_any_key_to_continue
}

install_Ruby() {
    header "Ruby installation version 2.5.1 with RVM"

    press_any_key_to_continue

    sudo apt-get install automake
    rvm install 2.5.1
    rvm use 2.5.1
    rvm --default use 2.5.1

    press_any_key_to_continue
}

install_Rails() {
    header "Rails installation version 5.2.3"

    press_any_key_to_continue

    gem install rails -v 5.2.3

    press_any_key_to_continue
}

install_Heroku() {
    header "Heroku installation"

    press_any_key_to_continue

    echo "I start install of HEROKU with CURL"
    curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

    press_any_key_to_continue
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

install_all_gem() {
    header "Gem installation"

    press_any_key_to_continue

    gem_array=(rspec rubocop pry dotenv twitter nokogiri launchy watir selenium-webdriver json colorize sinatra shotgun csv rack sqlite3 faker)
    echo "Here is the list of all gems that The Hacking Project offers"
    echo ${gem_array[*]}
    echo "you will be able to choose which ones you want to install"
    press_any_key_to_continue

    for gem in "${gem_array[@]}"; do ask_install_gem; done

    press_any_key_to_continue
}

install_gem_pg() {
    header "PG's gem installation"

    press_any_key_to_continue

    if [[ -r /etc/os-release ]]; then
        . /etc/os-release
        if [[ $ID == ubuntu ]]; then
            read _ UBUNTU_VERSION_NAME <<<"$VERSION"
            echo "Running Ubuntu $UBUNTU_VERSION_NAME"
            echo "I will add 'deb http://apt.postgresql.org/pub/repos/apt/ $UBUNTU_CODENAME-pgdg main' in /etc/apt/sources.list.d/pgdg.list"
            press_any_key_to_continue
            sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ $UBUNTU_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
            press_any_key_to_continue
        else
            echo "Not running an Ubuntu distribution. ID=$ID, VERSION=$VERSION"
            echo "Your system is based on Ubuntu $UBUNTU_CODENAME"
            echo "I add 'deb http://apt.postgresql.org/pub/repos/apt/ $UBUNTU_CODENAME-pgdg main' in /etc/apt/sources.list.d/pgdg.list"
            press_any_key_to_continue
            sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ $UBUNTU_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
            press_any_key_to_continue
        fi
    wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
    sudo apt update
    sudo apt upgrade
    sudo apt install postgresql-common
    sudo apt install postgresql-9.5 libpq-dev
    else
        echo "Not running a distribution with /etc/os-release available"
        echo "I can't install the GEM PG with PostgreSQL"
    fi

    press_any_key_to_continue
}

check_ror_version() {
    ruby_version=$(ruby -v)
    rails_version=$(rails -v)
    echo ${ruby_version}
    if [ "$ruby_version" == "ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]" ]; then
        echo "${GREEN} you have the right version of Ruby for The Hacking Project ${RESET}"
        press_any_key_to_continue
    else
        echo "${RED} You have not the right version of Ruby for The Hacking Project ${RESET}"
        press_any_key_to_continue
    fi

    echo ${rails_version}
    if [ "$rails_version" == "Rails 5.2.3" ]; then
        echo "${GREEN} you have the right version of Rails for The Hacking Project ${RESET}"
        press_any_key_to_continue
    else
        echo "${RED} You have not the right version of Rails for The Hacking Project ${RESET}"
        press_any_key_to_continue
    fi

    if [ "$ruby_version" == "ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]" ] || [ "$rails_version" == "Rails 5.2.3" ]; then
        echo "You have the right Ruby and Rails version for The Hacking Project"
        press_any_key_to_continue
    else
        echo "Something is wrong"
        press_any_key_to_continue
    fi
}

install_oh_my_zsh() {
    header "OH MY ZSH installation"

    press_any_key_to_continue

    if hash zsh 2>/dev/null; then
        echo "ZSH has been detected on your system"
        press_any_key_to_continue
    else
        echo "Zsh has not detected on your system"
        echo "I will install it with sudo"
        press_any_key_to_continue
        sudo apt install zsh
    fi

    if hash curl 2>/dev/null; then
        echo "CURL has been detected on your system"
        echo "I will install OH MY ZSH with it"
        press_any_key_to_continue
        sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    elif hash wget 2>/dev/null; then
        echo "WGET has been detected on your system"
        echo "I will install OH MY ZSH with it"
        press_any_key_to_continue
        sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    else
        echo "CURL and WGET has not detected on your system"
        echo "I will install CURL with sudo"
        echo "before install Oh-My-Zsh"
        press_any_key_to_continue
        sudo apt install curl
        echo "Now I will install OH MY ZSH with CURL"
        press_any_key_to_continue
        sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
    press_any_key_to_continue
}

install_vim() {
    header "VIM installation"

    press_any_key_to_continue

    if hash vim 2>/dev/null; then
        echo "Vim is already installed"
        press_any_key_to_continue
    else
        echo "Vim has not detected on your system"
        echo "I will install it with sudo"
        press_any_key_to_continue
        sudo apt install vim
        press_any_key_to_continue
    fi
}

Install_vscode() {
    header "Visual Code Installation"

    press_any_key_to_continue

    if hash code 2>/dev/null; then
        echo "Visual Code is already installed"
        press_any_key_to_continue
    else
        echo "Visual code has not detected on your system"
        echo "I will install it with snap"
        press_any_key_to_continue
        if hash snap 2>/dev/null; then
            echo "SNAP has not detected on your system"
            echo "I need it for install Visual Code"
            echo "I will install it with sudo"
            press_any_key_to_continue
            sudo apt update
            sudo apt install snapd
        fi
        echo "I will install Visual Code with SNAP"
        press_any_key_to_continue

        snap install code --classic
        
        press_any_key_to_continue
    fi
}

menu_whiptail() {
    while [ 1 ]; do
        CHOICE=$(
            whiptail --title "Installfest - The Hacking Project" --menu "Make your choice" 16 100 9 \
                "1)" "Depencies installation" \
                "2)" "RVM installation" \
                "3)" "Ruby version 2.5.1 installation" \
                "4)" "Rails version 2.5.3 installation" \
                "5)" "Heroku Installation" \
                "6)" "Gem Installation" \
                "7)" "PG's gem installation" \
                "8)" "Install Oh My ZSH" \
                "9)" "Install Visual Code" \
                "10)" "End script" 3>&2 2>&1 1>&3
        )

        case $CHOICE in
        "1)")
            install_dependencies
            ;;
        "2)")
            install_RVM
            ;;

        "3)")
            install_Ruby
            ;;
        "4)")
            install_Rails
            ;;
        "5)")
            install_Heroku
            ;;
        "6)")
            install_all_gem
            ;;
        "7)")
            install_gem_pg
            check_ror_version
            ;;
        "8)")
            install_oh_my_zsh
            ;;
        "9)")
            Install_vscode
            ;;
        "10)")
            clear
            exit
            ;;
        esac
        whiptail --msgbox "Choice $CHOICE is over" 7 25
    done
    exit
}

main() {
    setup_color

    notify-send 'InstallFest' 'His script was written by LinkPhoenix'

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
    press_any_key_to_continue

    if (whiptail --title "WARNING" --yesno "This script allows for a step-by-step installation of all the Inteliseft of The Hacking Project, the authors will not be in any way responsible for what you made of script.
    
Even if the script was done with love, the author LinkPhoenix of this one is in no way responsible for what you will do in it and is released from all responsibility on the results of this one.
------------------------------------------------------------------------------------------------

By selecting YES you accept it is conditions otherwise please select NO!" 15 100); then
        echo "User selected Yes, exit status was $?."
    else
        echo "User selected No, exit status was $?."
        exit
    fi

    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        menu_whiptail
    else
        whiptail --title "Not a linux operating system" --msgbox "This script is only compatible with a linux distribution (linux-gnu)
    
            Max OSx, Windows, MinGW... are not supported
    
                The script will not execute" 12 78
    fi
}

main
