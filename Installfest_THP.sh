#!/bin/bash
#https://blog.dorian-depriester.fr/linux/rediriger-les-messages-dun-script-dans-des-fichiers-log
# exec 3>&1 4>&2
# trap 'exec 2>&4 1>&3' 0 1 2 3
# exec 1>log.out 2>&1

setup_color() {
    # Only use colors if connected to a terminal
    # Thank your Oh My ZSH
    if [ -t 1 ]; then
        # https://gist.github.com/vratiu/9780109
        # https://misc.flogisoft.com/bash/tip_colors_and_formatting
        #RESET
        RESET=$(printf '\033[m')

        # Regular Colors
        BLACK=$(printf '\033[30m')
        RED=$(printf '\033[31m')
        GREEN=$(printf '\033[32m')
        YELLOW=$(printf '\033[33m')
        BLUE=$(printf '\033[34m')
        MAGENTA=$(printf '\033[35m')
        CYAN=$(printf '\033[36m')
        WHITE=$(printf '\033[37m')

        #BACKGROUND
        BG_BLACK=$(printf '\033[40m')
        BG_RED=$(printf '\033[41m')
        BG_GREEN=$(printf '\033[42m')
        BG_YELLOW=$(printf '\033[43m')
        BG_BLUE=$(printf '\033[44m')
        BG_MAGENTA=$(printf '\033[45m')
        BG_CYAN=$(printf '\033[46m')
        BG_WHITE=$(printf '\033[47m')

        # Formatting
        BOLD=$(printf '\033[1m')
        DIM=$(printf '\033[2m')
        ITALIC=$(printf '\033[3m')
        UNDERLINE=$(printf '\033[4m')
        BLINK=$(printf '\033[5m')
        REVERSE=$(printf '\033[7m')

    else
        RESET=""

        # Regular Colors
        BLACK=""
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        MAGENTA=""
        CYAN=""
        WHITE=""

        #BACKGROUND
        BG_BLACK=""
        BG_RED=""
        BG_GREEN=""
        BG_YELLOW=""
        BG_BLUE=""
        BG_MAGENTA=""
        BG_CYAN=""
        BG_WHITE=""

        # Formatting
        BOLD=""
        DIM=""
        ITALIC=""
        UNDERLINE=""
        BLINK=""
        REVERSE=""
    fi
}

press_any_key_to_continue() {
    read -n 1 -s -r -p "${GREEN}${BOLD}Press any key to continue${RESET}"
    printf "\n"
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

footer() {
    echo ""
    echo "${GREEN}${BOLD}#######################################################${RESET}"
    echo ""
    echo "${GREEN}  $1 ${RESET}"
    echo ""
    echo "${GREEN}${BOLD}#######################################################${RESET}"
    echo ""
}

launching_command() {
    echo "${YELLOW}#######################################################${RESET}"
    echo "${BG_BLACK}${ITALIC}  $ $1 ${RESET}"
    echo "${YELLOW}#######################################################${RESET}"
}

warning_text() {
    echo ""
    echo "${RED}#######################################################${RESET}"
    echo "${RED}${BOLD}  $1 ${RESET}"
    echo "${RED}#######################################################${RESET}"
    echo ""
}

detect_text() {
    echo ""
    echo "${GREEN}#######################################################${RESET}"
    echo "${GREEN}${BOLD}  $1 ${RESET}"
    echo "${GREEN}#######################################################${RESET}"
    echo ""
}

install_dependencies() {
    header "Dependencies installation for Ruby and RVM"

    press_any_key_to_continue

    echo "${YELLOW}I will install all dependencies for The Hacking Project${RESET}"
    launching_command "sudo apt-get install autoconf automake bison build-essential curl git-core libapr1 libaprutil1 libc6-dev libltdl-dev libsqlite3-0 libsqlite3-dev libssl-dev libtool libxml2-dev libxslt-dev libxslt1-dev libyaml-dev ncurses-dev nodejs openssl sqlite3 zlib1g zlib1g-dev libreadline7"
    press_any_key_to_continue

    sudo apt-get install autoconf automake bison build-essential curl git-core libapr1 libaprutil1 libc6-dev libltdl-dev libsqlite3-0 libsqlite3-dev libssl-dev libtool libxml2-dev libxslt-dev libxslt1-dev libyaml-dev ncurses-dev nodejs openssl sqlite3 zlib1g zlib1g-dev libreadline7

    footer "DEPENDENCIES INSTALLATION END"

    press_any_key_to_continue
}

install_RVM() {
    header "RVM installation"

    press_any_key_to_continue

    if hash gpg 2>/dev/null; then
        detect_text "GPG is detected on your system"
        echo "${YELLOW}I Will install RVM${RESET}"
        press_any_key_to_continue
    else
        warning_text "GPG is not detected in your system"
        echo "${YELLOW}I need it for install RVM${RESET}"
        echo "${YELLOW}I will install it with sudo${RESET}"
        launching_command "sudo apt install gnupg"
        echo ""
        press_any_key_to_continue
        echo "${YELLOW}$ sudo apt install gnupg${RESET}"
        sudo apt install gnupg
        echo "${YELLOW}Now I will install RVM${RESET}"
        press_any_key_to_continue
    fi
    echo "${YELLOW}Install GPG keys${RESET}"
    launching_command "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"
    echo "${YELLOW}$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB${RESET}"
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    echo "${YELLOW}Install RVM with CURL${RESET}"
    launching_command "curl -L get.rvm.io | bash -s stable"
    curl -L get.rvm.io | bash -s stable
    
    footer "RVM INSTALLATION END"

    press_any_key_to_continue
}

check_rvm_as_function() {
    #https://stackoverflow.com/a/19954212/12317483
    # Load RVM into a shell session *as a function*
    # Loading RVM *as a function* is mandatory
    # so that we can use 'rvm use <specific version>'
    echo "${YELLOW}I will try to add RVM as Source${RESET}"
    if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
      # First try to load from a user install
      source "$HOME/.rvm/scripts/rvm"
      echo "${GREEN}using user install $HOME/.rvm/scripts/rvm${RESET}"
    elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
      # Then try to load from a root install
      source "/usr/local/rvm/scripts/rvm"
      echo "${GREEN}using root install /usr/local/rvm/scripts/rvm${RESET}"
    else
      echo "${RED}ERROR: An RVM installation was not found.${RESET}"
    fi
}

install_Ruby() {
    header "Ruby installation version 2.5.1 with RVM"

    press_any_key_to_continue
    launching_command "sudo apt-get install automake"
    sudo apt-get install automake

    ruby_version=$(ruby -v)
    # echo ${ruby_version}
    if [ "$ruby_version" == "ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]" ]; then
        echo "${GREEN} Ruby version 2.5.1 is already installed ${RESET}"
        press_any_key_to_continue
        echo ""
    else
        echo "${RED} Ruby version 2.5.1 is not installed ${RESET}"
        echo "${YELLOW}I will install it with RVM${RESET}"
        press_any_key_to_continue
        echo ""

        check_rvm_as_function

        launching_command "rvm install 2.5.1"
        rvm install 2.5.1
        launching_command "rvm use 2.5.1"
        rvm use 2.5.1
        launching_command "rvm --default use 2.5.1"
        rvm --default use 2.5.1
    fi

    footer "RUBY INSTALLATION END"

    press_any_key_to_continue
}

install_Rails() {
    header "Rails installation version 5.2.3"

    press_any_key_to_continue

    rails_version=$(rails -v)
    # echo ${rails_version}
    if [ "$rails_version" == "Rails 5.2.3" ]; then
        echo "${GREEN} Rails version 5.2.3 is already installed ${RESET}"
        press_any_key_to_continue
        echo ""
    else
        echo "${RED} Rails version 5.2.3 is not installed ${RESET}"
        echo "${YELLOW}I will install it with GEM command${RESET}"
        press_any_key_to_continue
        echo ""
        launching_command "gem install rails -v 5.2.3"
        gem install rails -v 5.2.3
    fi

    footer "RAILS INSTALLATION END"

    press_any_key_to_continue
}

install_Heroku() {
    header "Heroku installation"

    press_any_key_to_continue

    if hash heroku 2>/dev/null; then
        detect_text "HEROKU is already install on your system"
        press_any_key_to_continue
    else
        echo "${YELLOW}I start install of HEROKU with CURL${RESET}"
        launching_command "curl https://cli-assets.heroku.com/install-ubuntu.sh | sh"
        press_any_key_to_continue
        curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
    fi
    footer "HEROKU INSTALLATION END"

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
    echo "Here is the list of all gems that ${REVERSE}${BOLD}The Hacking Project offers${RESET}"
    echo "${YELLOW}###### List of all gem for The Hacking Project${RESET}"
    echo "${BG_BLACK}${ITALIC}==>${gem_array[*]} ${RESET}"
    echo ""
    echo "you will be able to choose which ones you want to install"
    press_any_key_to_continue

    for gem in "${gem_array[@]}"; do ask_install_gem; done

    footer "GEM INSTALLATION END"

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
            launching_command 'sudo sh -c "echo deb http://apt.postgresql.org/pub/repos/apt/ '$UBUNTU_CODENAME'-pgdg main" > /etc/apt/sources.list.d/pgdg.list"'
            press_any_key_to_continue
            sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ $UBUNTU_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
        else
            echo "Not running an Ubuntu distribution. ID=$ID, VERSION=$VERSION"
            echo "Your system is based on Ubuntu $UBUNTU_CODENAME"
            launching_command 'sudo sh -c "echo deb http://apt.postgresql.org/pub/repos/apt/ '$UBUNTU_CODENAME'-pgdg main" > /etc/apt/sources.list.d/pgdg.list"'
            press_any_key_to_continue
            sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ $UBUNTU_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
        fi
    launching_command "wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -"
    wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
    launching_command "sudo apt update"
    sudo apt update
    launching_command "sudo apt upgrade"
    sudo apt upgrade
    launching_command "sudo apt install postgresql-common"
    sudo apt install postgresql-common
    launching_command "sudo apt install postgresql-9.5 libpq-dev"
    sudo apt install postgresql-9.5 libpq-dev
    else
        WARNING "Not running a distribution with /etc/os-release available
        I can't install the GEM PG with PostgreSQL"
    fi

    footer "PG GEM INSTALLATION END"

    press_any_key_to_continue
}

check_ror_version() {
    header "Check Ruby and Rails versions"

    press_any_key_to_continue

    ruby_version=$(ruby -v)
    rails_version=$(rails -v)
    echo ${ruby_version}
    echo ""
    if [ "$ruby_version" == "ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]" ]; then
        echo "${GREEN} You have the right version of ${RED}Ruby${RESET} ${GREEN}for${RESET} ${REVERSE}${BOLD}The Hacking Project${RESET}"
        press_any_key_to_continue
        echo ""
    else
        echo "${RED} You have not the right version of ${RED}Ruby${RESET} ${RED}for${RESET} ${REVERSE}${BOLD}The Hacking Project${RESET}"
        press_any_key_to_continue
        echo ""
    fi

    echo ${rails_version}
    echo ""
    if [ "$rails_version" == "Rails 5.2.3" ]; then
        echo "${GREEN} You have the right version of ${RED}Rails${RESET} ${GREEN}for${RESET} ${REVERSE}${BOLD}The Hacking Project${RESET}"
        press_any_key_to_continue
        echo ""
    else
        echo ""
        echo "${RED} You have not the right version of ${RED}Rails${RESET} ${RED}for${RESET} ${REVERSE}${BOLD}The Hacking Project${RESET}"
        press_any_key_to_continue
    fi

    if [ "$ruby_version" == "ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]" ] || [ "$rails_version" == "Rails 5.2.3" ]; then
        echo ""
        echo "${GREEN}#################################################################${RESET}"
        echo "${GREEN}You have the right ${RED}Ruby${RESET} ${GREEN}and${RESET} ${RED}Rails${RESET} ${GREEN}version for${RESET} ${REVERSE}${BOLD}The Hacking Project${RESET}"
        echo "${GREEN}You are ready for learning RUBY${RESET}"
        echo "${GREEN}#################################################################${RESET}"
        press_any_key_to_continue
    else
        echo "${RED}#########################################${RESET}"
        echo "${RED}You have not the good versions${RESET}"
        echo "${RED}or ${RED}Ruby${RESET} and/or ${RED}Rails${RESET} ${RED}is not installed yet${RESET}"
        echo "${RED}#########################################${RESET}"
        press_any_key_to_continue
    fi
}

install_oh_my_zsh() {
    header "OH MY ZSH installation"

    press_any_key_to_continue

    if hash zsh 2>/dev/null; then
        detect_text "ZSH has been detected on your system"
        press_any_key_to_continue
    else
        warning_text "Zsh has not detected on your system"
        echo "${YELLOW}I will install it with sudo${RESET}"
        launching_command "sudo apt install zsh"
        press_any_key_to_continue
        sudo apt install zsh
    fi

    if hash curl 2>/dev/null; then
        detect_text "CURL has been detected on your system"
        echo "${YELLOW}I will install OH MY ZSH with it${RESET}"
        launching_command "sh -c \$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        press_any_key_to_continue
        sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    elif hash wget 2>/dev/null; then
        detect_text "WGET has been detected on your system"
        echo "${YELLOW}I will install OH MY ZSH with it${RESET}"
        launching_command "sh -c \$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
        press_any_key_to_continue
        sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    else
        warning_text "CURL and WGET has not detected on your system"
        echo "${YELLOW}I will install CURL with sudo${RESET}"
        echo "${YELLOW}before install Oh-My-Zsh${RESET}"
        launching_command "sudo apt install curl"
        press_any_key_to_continue
        sudo apt install curl
        echo "${YELLOW}Now I will install OH MY ZSH with CURL${RESET}"
        launching_command "sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)""
        press_any_key_to_continue
        sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
    footer "OH MY ZSH INSTALLATION END"
    press_any_key_to_continue
}

install_vim() {
    header "VIM installation"

    press_any_key_to_continue

    if hash vim 2>/dev/null; then
        detect_text "Vim is already installed"
        press_any_key_to_continue
    else
        warning_text "Vim has not detected on your system"
        echo "${YELLOW}I will install it with sudo${RESET}"
        launching_command "sudo apt install vim"
        press_any_key_to_continue
        sudo apt install vim
    fi

    footer "VIM INSTALLATON END"

    press_any_key_to_continue
}

Install_vscode() {
    header "Visual Code Installation"

    press_any_key_to_continue

    if hash code 2>/dev/null; then
        detect_text "Visual Code is already installed"
        press_any_key_to_continue
    else
        warning_text "Visual code has not detected on your system"
        echo "I will install it"
        press_any_key_to_continue
        launching_command "curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg"
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        launching_command "sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/"
        sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
        launching_command "sudo sh -c echo deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main > /etc/apt/sources.list.d/vscode.list"
        sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        launching_command "sudo apt-get install apt-transport-https"
        sudo apt-get install apt-transport-https
        launching_command "sudo apt-get update"
        sudo apt-get update
        launching_command "sudo apt-get install code"
        sudo apt-get install code
    fi

    footer "VISUAL CODE INSTALLATION END"

    press_any_key_to_continue
}

Install_atom() {
    header "Atom Installation"

    press_any_key_to_continue

    if hash atom 2>/dev/null; then
        detect_text "Atom is already installed"
        press_any_key_to_continue
    else
        warning_text "Atom has not detected on your system"
        echo "I will install it"
        press_any_key_to_continue
        launching_command "wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -"
        wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
        launching_command "sudo sh -c echo deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main > /etc/apt/sources.list.d/atom.list"
        sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
        launching_command "sudo apt update"
        sudo apt update
        launching_command "sudo apt-get install atom"
        sudo apt install atom
    fi

    footer "ATOM INSTALLATION END"

    press_any_key_to_continue
}

Install_sublime_text() {
    header "Sublime Text Installation"

    press_any_key_to_continue

    if hash subl 2>/dev/null; then
        detect_text "Sublime Text is already installed"
        press_any_key_to_continue
    else
        warning_text "Sublime Text has not detected on your system"
        echo "I will install it"
        press_any_key_to_continue
        launching_command "wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -"
        wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
        launching_command "sudo apt install apt-transport-https"
        sudo apt install apt-transport-https
        launching_command "echo deb https://download.sublimetext.com/ apt/stable/ | sudo tee /etc/apt/sources.list.d/sublime-text.list"
        echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
        launching_command "sudo apt update"
        sudo apt update
        launching_command "sudo apt-get install sublime-text"
        sudo apt install sublime-text
    fi

    footer "SUBLIME TEXT INSTALLATION END"

    press_any_key_to_continue
}

install_git() {
    if hash git 2>/dev/null; then
        detect_text "GIT is already installed"
        press_any_key_to_continue
    else
        warning_text "GIT has not detected on your system"
        echo "I will install it"
        launching_command "sudo apt update"
        sudo apt update
        launching_command "sudo apt install git"
        sudo apt install git
        press_any_key_to_continue
    fi

    footer "GIT INSTALLATION END"

    press_any_key_to_continue
}

choice_IDE() {
    if hash resize 2>/dev/null; then
        eval `resize`
`       CHOICE=$(whiptail --title "Installfest - The Hacking Project" --menu "By LinkPhoenix" --nocancel --notags --clear $LINES $(( $COLUMNS - 75 )) $(( $LINES - 8 )) \
            "1)" "Visual Code" \
            "2)" "Atom" \
            "3)" "Sublime Text" 3>&2 2>&1 1>&3)
    else
        CHOICE=$(whiptail --title "Installfest - The Hacking Project" --menu "By LinkPhoenix" --nocancel --notags --clear 15 45 5 \
        "1)" "Visual Code" \
        "2)" "Atom" \
        "3)" "Sublime Text" 3>&2 2>&1 1>&3)
    fi

    case $CHOICE in
        "1)") Install_vscode;;
        "2)") Install_atom;;
        "3)") Install_sublime_text;;
    esac
}

extension_vscode() {
    code --install-extension formulahendry.auto-close-tag
    code --install-extension formulahendry.auto-rename-tag
    code --install-extension aaron-bond.better-comments
    code --install-extension thekalinga.bootstrap4-vscode
    code --install-extension coenraads.bracket-pair-colorizer-2
    code --install-extension formulahendry.code-runner
    code --install-extension anseki.vscode-color
    code --install-extension msjsdiag.debugger-for-chrome
    code --install-extension firefox-devtools.vscode-firefox-debug
    code --install-extension mikestead.dotenv
    code --install-extension perkovec.emoji
    code --install-extension giancarlopro.faker-snippets
    code --install-extension donjayamanne.githistory
    code --install-extension codezombiech.gitignore
    code --install-extension eamodio.gitlens
    code --install-extension ivangabriele.vscode-heroku
    code --install-extension sidthesloth.html5-boilerplate
    code --install-extension tht13.html-preview-vscode
    code --install-extension abusaidm.html-snippets
    code --install-extension xabikos.javascriptsnippets
    code --install-extension emilast.logfilehighlighter
    code --install-extension davidanson.vscode-markdownlint
    code --install-extension christian-kohler.path-intellisense
    code --install-extension esbenp.prettier-vscode
    code --install-extension alefragnani.project-manager
    code --install-extension bung87.rails
    code --install-extension jemmyw.rails-fast-nav
    code --install-extension shanehofstetter.rails-i18n
    code --install-extension shanehofstetter.rails-open-partial
    code --install-extension aki77.rails-routes
    code --install-extension noku.rails-run-spec-vscode
    code --install-extension vense.rails-snippets
    code --install-extension asux.rspec-focus
    code --install-extension karunamurti.rspec-snippets
    code --install-extension rebornix.ruby
    code --install-extension hridoy.rails-snippets
    code --install-extension kosai106.ruby-syntax-replacer
    code --install-extension misogi.ruby-rubocop
    code --install-extension miguel-savignano.ruby-symbols
    code --install-extension vortizhe.simple-ruby-erb
    code --install-extension alexcvzz.vscode-sqlite
    code --install-extension xshrim.txt-syntax
    code --install-extension bung87.vscode-gemfile
    code --install-extension vscode-icons-team.vscode-icons
    code --install-extension thadeu.vscode-run-rspec-file
}

end_of_script() {
    clear
    exit
}



menu_whiptail() {
    while [ 1 ]; do

    if hash resize 2>/dev/null; then
        eval `resize`
           CHOICE=$(whiptail --title "Installfest - The Hacking Project" --menu "By LinkPhoenix" --nocancel --notags --clear $LINES $(( $COLUMNS - 75 )) $(( $LINES - 8 )) \
                "1)" "Exit" \
                "2)" "Depencies installation" \
                "3)" "RVM installation" \
                "4)" "Ruby version 2.5.1 installation" \
                "5)" "Rails version 2.5.3 installation" \
                "6)" "Check Ruby and Rails versions" \
                "7)" "Heroku Installation" \
                "8)" "Gem Installation" \
                "9)" "PG's gem installation" \
                "10)" "Install Oh My ZSH" \
                "11)" "Choice my IDE" \
                "12)" "Install VIM" \
                "13)" "Install GIT" \
                "14)" "Install Visual Code Extensions" 3>&2 2>&1 1>&3)
    else
        CHOICE=$(whiptail --title "Installfest - The Hacking Project" --menu "By LinkPhoenix" --nocancel --notags --clear 25 78 16 \
                "1)" "Exit" \
                "2)" "Depencies installation" \
                "3)" "RVM installation" \
                "4)" "Ruby version 2.5.1 installation" \
                "5)" "Rails version 2.5.3 installation" \
                "6)" "Check Ruby and Rails versions" \
                "7)" "Heroku Installation" \
                "8)" "Gem Installation" \
                "9)" "PG's gem installation" \
                "10)" "Install Oh My ZSH" \
                "11)" "Choice my IDE" \
                "12)" "Install VIM" \
                "13)" "Install GIT" \
                "14)" "Install Visual Code Extensions" 3>&2 2>&1 1>&3)
    fi
        case $CHOICE in
        "1)") end_of_script;;
        "2)") install_dependencies;;
        "3)") install_RVM;;
        "4)") install_Ruby;;
        "5)") install_Rails;;
        "6)") check_ror_version;;
        "7)") install_Heroku;;
        "8)") install_all_gem;;
        "9)") install_gem_pg;;
        "10)") install_oh_my_zsh;;
        "11)") choice_IDE;;
        "12)") install_vim;;
        "13)") install_git;;
        "14)") extension_vscode;;
        esac
    done
    exit
}

warning() {
    if (whiptail --title "WARNING" --yesno "This script allows for a step-by-step installation of all the Intallseft of The Hacking Project, the authors will not be in any way responsible for what you made of script.
    
Even if the script was done with love, the author LinkPhoenix of this one is in no way responsible for what you will do in it and is released from all responsibility on the results of this one.
------------------------------------------------------------------------------------------------

By selecting YES you accept it is conditions otherwise please select NO!" 15 100); then
        echo "User selected Yes, exit status was $?."
    else
        echo "User selected No, exit status was $?."
        exit
    fi
}

main() {
    setup_color

    notify-send 'InstallFest' 'His script was written by LinkPhoenix'

header="
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
                                                                                              
"
i=0
while [ $i -lt ${#header} ]; do
    sleep 0.0000001
    echo -ne "${GREEN}${BOLD}${header:$i:1}${RESET}" | tr --delete "%"
    ((i++))
done

info_script="The Hacking Project is a Peer-Learning training based in FRANCE

Created by Félix Gaudé (CEO/Président) and Charles Dacquay (CMO/Directeur Général)
more information at https://www.thehackingproject.org

_______________________________________________________________________________________________

Script information

Author              LinkPhoenix
Github              https://github.com/LinkPhoenix
URL Repository      https://github.com/LinkPhoenix/THP_Installfest

"

i=0
while [ $i -lt ${#info_script} ]; do
    sleep 0.001
    echo -ne "${YELLOW}${BOLD}${info_script:$i:1}${RESET}" | tr --delete "%"
    ((i++))
done

    press_any_key_to_continue
    warning

    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        menu_whiptail
    else
        whiptail --title "Not a linux operating system" --msgbox "This script is only compatible with a linux distribution (linux-gnu)
    
            Max OSx, Windows, MinGW... are not supported
    
                The script will not execute" 12 78
    fi
}

main
