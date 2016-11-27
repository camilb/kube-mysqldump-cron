#!/bin/bash

DB_USER=${DB_USER:-${MYSQL_ENV_DB_USER}}
DB_PASS=${DB_PASS:-${MYSQL_ENV_DB_PASS}}
DB_NAME=${DB_NAME:-${MYSQL_ENV_DB_NAME}}
DB_HOST=${DB_HOST:-${MYSQL_ENV_DB_HOST}}
ALL_DATABASES=${ALL_DATABASES}

if [[ ${DB_USER} == "" ]]; then
	echo "Missing DB_USER env variable"
	exit 1
fi
if [[ ${DB_PASS} == "" ]]; then
	echo "Missing DB_PASS env variable"
	exit 1
fi
if [[ ${DB_HOST} == "" ]]; then
	echo "Missing DB_HOST env variable"
	exit 1
fi
if [[ ${ALL_DATABASES} == "" ]]; then
	if [[ ${DB_NAME} == "" ]]; then
		echo "Missing DB_NAME env variable"
		exit 1
	fi
	mysql --user="${DB_USER}" --password="${DB_PASS}" --host="${DB_HOST}" "$@" "${DB_NAME}" < /mysqldump/"${DB_NAME}".sql
else
	cd /mysqldump
	databases=`for f in *.sql; do
    	printf '%s\n' "${f%.sql}"
	done`
for db in $databases; do
	  if [[ "$db" != "information_schema.sql" ]] && [[ "$db" != "performance_schema.sql" ]] && [[ "$db" != "mysql.sql" ]] && [[ "$db" != _* ]]; then
	      echo "Importing database: $db"
	      mysql --user="${DB_USER}" --password="${DB_PASS}" --host="${DB_HOST}" "$@" "$db" < /mysqldump/$db.sql
	  fi
done
fi
