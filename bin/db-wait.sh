#! /bin/sh

# Wait for MySQL
CMD="nc -z -v -w30 $DATABASE_HOST $DATABASE_PORT"
echo "-----------------------------------"
echo " "
echo "bin/db-wait.sh -- The following command will run to check if MySQL is running..."
echo "bin/db-wait.sh -- $CMD"
echo " "
echo "-----------------------------------"
until nc -z -v -w30 $DATABASE_HOST $DATABASE_PORT; do
 echo 'Waiting for MySQL...'
 sleep 1
done
echo "MySQL is up and running!"
