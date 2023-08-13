#!/bin/bash


# Database credentials


# Backup filename details with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILENAME="${DB_NAME}_db_backup_$TIMESTAMP.sql"

# Dump the database to a file
pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -F c -b -v -f "/tmp/$BACKUP_FILENAME" $DB_NAME

# Check if pg_dump was successful
if [ $? -ne 0 ]; then
  echo "Database backup failed."
  exit 1
fi

# Upload to S3
aws s3 cp "/tmp/$BACKUP_FILENAME" "s3://s4-bucket-100/$BACKUP_FILENAME"

# Check if AWS CLI command was successful
if [ $? -ne 0 ]; then
  echo "Failed to upload backup to S3."
  rm -f "/tmp/$BACKUP_FILENAME"
  exit 1
fi

# Remove the temporary backup file from the VM
rm -f "/tmp/$BACKUP_FILENAME"

echo "Database backup completed successfully and uploaded to S3."
