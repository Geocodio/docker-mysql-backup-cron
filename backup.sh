#!/bin/bash

# Generate a (gzipped) dumpfile for each database specified in ${DBS}.
# Upload to S3.

. /etc/container_environment.sh

# Bailout if any command fails
set -e

# Create a temporary directory to hold the backup files.
DIR=$(mktemp -d)

# Generate a timestamp to name the backup files with.
TS=$(date +%Y-%m-%d-%H%M%S)
YEAR=$(date +%Y)

mkdir -p $DIR/$YEAR

# Backup all databases, unless a list of databases has been specified
if [ -z "$DBS" ]
then
	# Backup all DB's in bulk
	mysqldump -u "$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOSTNAME" --single-transaction --quick --all-databases | gzip > $DIR/$YEAR/all-databases-$TS.sql.gz
else
	# Backup each DB separately
	for DB in $DBS
	do
		mysqldump -u "$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOSTNAME" --single-transaction --quick -B $DB | gzip > $DIR/$YEAR/$DB-$TS.sql.gz
	done
fi

# Upload the backups to S3 --region=$REGION
s3cmd --access_key=$ACCESS_KEY --secret_key=$SECRET_KEY --region=$REGION sync $DIR/ s3://$BUCKET

# Clean up
rm -rf $DIR
