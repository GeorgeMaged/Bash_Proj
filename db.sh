#!/bin/bash

DB_PATH="./databases"
mkdir -p $DB_PATH

#Function of main menu creation"
main_menu() {
 echo "Main Menu:
 "
 echo "1. Create Database"
 echo "2. List Databases"
 echo "3. Connect To Database"
 echo "4. Drop Database"
 echo "5. Exit
 "

 read -p "Choose the option you prefer by its number :)
 " choice


 case $choice in 
    1)
        #create_database ;;
        echo "Will create a DB" ;;

    2)
        #list_database ;;
        echo "list" ;;
    3)
        #connect_database ;;
        echo "Will connect to DB" ;;
    4)
        #drop_database ;;
        echo "will delete a DB";;
    5)
        echo "Bye Bye"
        exit 0 ;;
    *)
    echo "Invalid option:Please Try again :)" ;;

 esac   







}

main_menu