#!/bin/bash

DB_PATH="./databases"
mkdir -p $DB_PATH

#Function of main menu creation"

main_menu() {

while true; do

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
        connect_database ;;
        #echo "Will connect to DB" ;;
      4)
        drop_database ;;
        #echo "will delete a DB";;
      5)
        echo "Bye Bye"
        exit 0 ;;
      *)
        echo "Invalid option:Please Try again :)" ;;

    esac   
done
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
#Function to connect to databases
connect_database(){
    read -p "Select which database you want to connect
    " db_name
    if [ -d "$DB_PATH/$db_name" ]; then
        db_menu "$db_name"
    else 
        echo "Database doesn't exist! "
    fi
}

db_menu() {
    local db_name=$1
    while true; do
        echo "What do you want to do with your database '$db_name' ?
        "
        echo "1) Create table"
        echo "2) List table"
        echo "3) Drop table"
        echo "4) Insert into table"
        echo "5) Select from table"
        echo "6) Delete from table"
        echo "7) Update table"
        echo "8) Back"
        read -p "Select what option do you want :)
        " option

        case $option in 
            1)
             create_table "$db_name";;
             #echo "Create Table" ;;
            2)
            #list_table
             echo "List Table" ;; 
            3) 
            #drop_table
              echo "drop table" ;;
            4)
            #insert_into_table
              echo "insert into table" ;;
            5)
            #select_from_table
              echo "select from table" ;;
            6)
            #delete_from_table
              echo "delete from table"  ;;
            7) 
            #update_table
             echo "update table" ;;
            8)
                break;;
            *)
              echo "Invalid option,please try again :)
             "
        esac
    done           

}

create_table()
{ 
    local db_name=$1
    read -p "Name your table: 
    " table_name

    if [ -f "$DB_DIR/$db_name/$table_name" ]; then
        echo "Table already exists!
        "
        return
    fi

    read -p "Enter the number of columns : 
    " num_columns
    while true; do 

        if [[ "$num_columns" =~ ^[0-9]+$ ]]; then
            break
        else
            echo "Invalid input! Please try again."
        fi
    done            

    column_names=()
    column_types=()
    column_specials=()

    for ((i=1;i<=$num_columns;i++)); do
        read -p "Enter name for column number $i: " col_name
        column_names+=("$col_name")   

      
        while true; do
            read -p "Enter datatype for column number $i: 
               The datatypes available are :
                  1-string
                  2-int
                  3-bool
                 Enter datatype for column number $i:   " col_type

            case $col_type in
                1)
                    column_types+=("string")
                    break
                    ;;
                2)
                    column_types+=("int")
                    break
                    ;;    
                3)
                    column_types+=("bool")
                    break
                    ;;
                *)
                    echo "Not supported datatype right now,Please try again :)" 
                    ;;
            esac
        done    
        column_types+=("$col_type") 
    done               

    (
        IFS=,
        echo "${column_names[*]}"
        echo "${column_types[*]}"
    ) > "$DB_PATH/$db_name/$table_name"

    echo "Table '$table_name' is created successfully! :) 
    
    "  

}

list_table() {
    local db_name=$1




}

main_menu