#!/usr/bin/env zsh

dialog --backtitle "Installer" --checklist "Choose please" 0 0 4 \
  1 Cheese on\
  2 Jelly off\
  3 Another off 2> tmp1


choice=$(cat tmp1)
echo $choice # This converts your answer to a variable "choice"
    case $choice in # This takes your answer as read from the variable and executes the associated command
        1 ) echo "Cheese" ;;
        2 ) echo "Jelly"  ;;
        3) echo "Another" ;;
    esac

#    rm tmp1
