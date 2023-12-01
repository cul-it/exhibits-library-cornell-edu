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
 echo "Waiting for MySQL... (checking status with $CMD)"
 sleep 1
done
echo "MySQL is up and running with ${DATABASE_NAME_PREFIX}_${RAILS_ENV} database at ${DATABASE_HOST}:${DATABASE_PORT}!"
