#!/bin/bash
java -jar DBInitGenerator-1.0-SNAPSHOT.jar
/opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -f db_init.sql -q
echo Скрипт успешно выполнен