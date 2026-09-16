
#!/bin/bash
psql -c "CREATE DATABASE \"Adventureworks\";"
psql -d Adventureworks < /docker-entrypoint-initdb.d/init.sql

