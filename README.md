# MySQL Backup Cron

This will take periodic MySQL or MariaDB backups, gzip them and upload the files to Amazon S3.

This is based off of the excellent [docker-mysql-backup-cron](https://github.com/nickbreen/docker-mysql-backup-cron) image by [nickbreen](https://github.com/nickbreen)

## Configuration

Per default, the cronjob will run every 8 hours, but any of the settings can be overwritten with the following environment variables:

```
ACCESS_KEY=YOUR_AWS_ACCESS_KEY
SECRET_KEY=YOUR_AWS_SECRET_KEY
BUCKET=YOUR_AWS_S3_BUCKET_NAME
MYSQL_USERNAME=YOUR_MYSQL_USERNAME
MYSQL_PASSWORD=YOUR_MYSQL_PASSWORD
MYSQL_HOSTNAME=YOUR_MYSQL_HOSTNAME
DBS=DATABASE_NAME_OR_LEAVE_EMPTY_FOR_ALL_DBS
REGION=us-east-1
```

```
# Every 8 hours
CRON_D_BACKUP="0 1,9,17 * * * root /backup.sh | logger"

# Every night at 1am
CRON_D_BACKUP="0 1 * * * root /backup.sh | logger"
```

> See also `.env.example`

## Releasing

```
# Build docker image
make build

# Push docker image
make deploy

# Run docker image (using .env file)
make run
```
