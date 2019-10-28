#!/bin/bash
# Bash Menu Script Example

read -p "enter choice: " choice
    case $choice in
        1)
            echo "you chose choice 1"
            ;;
        2)
            echo "you chose choice 2"
            ;;
        3)
            echo "you chose choice $REPLY which is $opt"
            ;;
        "q" | "Q")
            exit 0
            ;;
        *) echo "invalid option $REPLY";;
    esac