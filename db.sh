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
             list_table "$db_name" ;;
             #echo "List Table" ;; 
            3) 
             drop_table "$db_name";;
             #echo "drop table" ;;
            4)
             insert_into_table "$db_name";;
             #echo "insert into table" ;;
            5)
             select_from_table "$db_name";;
            #echo "select from table" ;;
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
    pk_flag=false 
    read -p "Name your table: 
    " table_name

    if [ -f "$DB_PATH/$db_name/$table_name" ]; then
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
    if ! $pk_flag; then
        read -p "Is this column a PK? (y/n): " is_pk
        if [[ $is_pk == "Y" || $is_pk == "y" ]]; then
            column_specials+=("PK")
            pk_flag=true
        else
            column_specials+=("-")
        fi
    else
        column_specials+=("-")
    fi                

       # column_types+=("$col_type") 
    done               

    (
        IFS=,
        echo "${column_names[*]}"
        echo "${column_types[*]}"
        echo "${column_specials[*]}"

    ) > "$DB_PATH/$db_name/$table_name"

    echo "Table '$table_name' is created successfully! :) 
    
    "  

}

list_table() {
    local db_name=$1
    echo "The tables inside your database '$db_name' are :
    "
    ls $DB_PATH/$db_name/

}

drop_table() {
    local db_name=$1
    read -p "Enter name of table to drop: 
            Here is a reminder of this database tables:
            $(list_table "$1")
            so which one to drop from them? " table_name

    if [ -f "$DB_PATH/$db_name/$table_name" ] ; then
        rm "$DB_PATH/$db_name/$table_name"
        echo "Table '$table_name' is removed ! 
        "
    else
        echo "Table does not exist"
    fi         

}



insert_into_table()
{
  local db_name=$1
  read -p "Enter table name: 
          " table_name

  if [ ! -f "$DB_PATH/$db_name/$table_name" ]; then 

    echo "Table does not exist!
    "
    return
  fi 


  touch $DB_PATH/$db_name/${table_name}.data
  IFS=, read -r -a column_names <<< "$(sed -n '1p' "$DB_PATH/$db_name/$table_name")"
  IFS=, read -r -a column_types <<< "$(sed -n '2p' "$DB_PATH/$db_name/$table_name")"
  IFS=, read -r -a column_specials <<< "$(sed -n '3p' "$DB_PATH/$db_name/$table_name")"



  pk_index=-1
  for ((i=0;i<${#column_specials[@]};i++)); do

    if [[ ${column_specials[i]} == "PK" ]]; then

        pk_index=$i
        break
    fi
  done

  if [ $pk_index -eq -1 ]; then
    echo "No Primary key found."
    #return
  fi


  values=()
  for ((i=0;i<${#column_names[@]};i++)); do
    col_name=${column_names[$i]}
    col_type=${column_types[$i]}
    col_special=${column_specials[$i]}

    while true ; do

        read -p "Enter value for $col_name ($col_type) : 
                " value

        if [[ $col_type == "int" && ! $value =~ ^[0-9]+$ ]]; then
                echo "Invalid input: $col_name should be an integer."
                continue
        elif [[ $col_type == "bool" && ! $value =~ ^(true|false)$ ]]; then
                echo "Invalid input: $col_name should be true or false."
                continue
        elif [[ $col_type == "string" && ! $value =~ ^[a-zA-Z]+$ ]]; then
                echo "Invalid input: $col_name should be a string."
                continue
        fi

        #echo " column_specials = ${column_specials} "

        if [[ $col_special == "PK" ]]; then
            #echo " I AM IN! "
            duplicate=false
            while IFS=, read -r -a row; do
                if [[ "${row[$pk_index]}" == "$value" ]]; then
                    #echo " I AM IN IN ! "
                    duplicate=true
                    break
                fi
            done < "$DB_PATH/$db_name/${table_name}.data"

            if $duplicate; then
                    echo "Error:Duplicate value for primary key $col_name. "
                    continue 
            fi
        fi

        values+=("$value")
        break

    done

  done   


  (
        IFS=,
        echo "${values[*]}"
  ) >> "$DB_PATH/$db_name/$table_name.data"

  echo "Data inserted into table '$table_name'.
  
  "

}           



select_from_table() 
{
    
    local db_name=$1
    read -p "What table you want to select from , Reminder of tables you have:
        $(list_table "$1")" table_name

    if [! -f $DB_PATH/$db_name/${table_name}.data ]; then

        echo " Table does not exist! "
        return

    fi

    IFS=, read -r -a column_names_data <<< "$(sed -n '1p' "$DB_PATH/$db_name/$table_name.data")"
    IFS=, read -r -a column_types_data <<< "$(sed -n '2p' "$DB_PATH/$db_name/$table_name.data")"
    IFS=, read -r -a column_specials_data <<< "$(sed -n '3p' "$DB_PATH/$db_name/$table_name.data")"
    IFS=, read -r -a column_names <<< "$(sed -n '1p' "$DB_PATH/$db_name/$table_name")"
    IFS=, read -r -a column_types <<< "$(sed -n '2p' "$DB_PATH/$db_name/$table_name")"
    IFS=, read -r -a column_specials <<< "$(sed -n '3p' "$DB_PATH/$db_name/$table_name")"

    echo "Columns in table '$table_name':"
    for ((i=0;i<${#column_names[@]};i++)); do
        echo "$((i+1)). ${column_names[$i]}"
    done      

    read -p "Enter the columns you want to read comma-seperated (1,2..etc) or all : " value

    if [[ $value == "all" ]]; then
        columns_display=("${column_names_data[@]}")
    else
        IFS=, read -r -a columns_selected <<< "$value"
        columns_display=()
      #  for col in "${columns_selected[@]}"; do
         #  if (( col > 0 && col <= ${#column_names[@]} )); then

        











}





main_menu