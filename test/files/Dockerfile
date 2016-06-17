FROM rails4-onbuild

# wait for mysql db in docker-compose to fully boot up
COPY wait_for_mysql.sh /etc/my_init.d/00_wait_for_mysql.sh
