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
        create_database ;;
        #echo "Will create a DB" ;;

    2)
        list_database ;;
        #echo "list" ;;
    3)
        #connect_database ;;
        echo "Will connect to DB" ;;
    4)
        drop_database ;;
        #echo "will delete a DB";;
    5)
        echo "Bye Bye"
        exit 0 ;;
    *)
    echo "Invalid option:Please Try again :)" ;;

 esac   

}
#Function of creating the database
create_database() {
    read -p "Enter your database name: " db_name
    if [ -d "$DB_PATH/$db_name" ]; then
        echo "Database already exists!"
        ls "$DB_PATH"
    else   
        mkdir -p "$DB_PATH/$db_name"
        echo "Database '$db_name' is created :) and here is a proof: "
        ls "$DB_PATH"

    fi    
}

#Function to delete the database
drop_database() {
    read -p "Enter the name of your databse to drop.
    " db_name
    if [ -d "$DB_PATH/$db_name" ]; then
        echo "The databases before are :"
        ls "$DB_PATH"
        rm -r "$DB_PATH/$db_name"
        echo "Your database '$db_name' is dropped and here is a proof:"
        ls "$DB_PATH"

    else 
        echo "Database doesn't exist."    

    fi    
}

#Function to list the databases
list_database() {
    echo "Your Databases:
    "
    ls -l "$DB_PATH"
}



main_menu