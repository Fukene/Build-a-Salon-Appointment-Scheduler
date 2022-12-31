#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
MAIN_MENU(){

  echo -e "\nWelcome to the hairdresser's. Take a look at our services:\n"
  # get services
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  # display services
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    echo -e "$SERVICE_ID) "$SERVICE""
  done
  echo -e "\nWhich service would you like today?"
   
  read SERVICE_ID_SELECTED
  #If does not exist
  CHECK_SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $CHECK_SERVICE_ID ]]
  then
    MAIN_MENU
  else
      echo -e "\nInsert phone number:"
      read CUSTOMER_PHONE
      CHECK_CUSTOMER_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      if [[ -z $CHECK_CUSTOMER_PHONE ]]
      then
        echo -e "\nInsert your name:"
        read CUSTOMER_NAME
        INSERT_CUSTOMER_DATA=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
      fi
      echo -e "\nGive a time"
      read SERVICE_TIME
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, time, customer_id) VALUES($SERVICE_ID_SELECTED, '$SERVICE_TIME', $CUSTOMER_ID)")
      NAME_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      echo "I have put you down for a $NAME_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi

}
MAIN_MENU
