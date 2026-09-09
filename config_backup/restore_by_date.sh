#!/bin/bash

#### Load .env ####
ENV_PATH="../env_file/.env"

# 1. Load configurations
if [ -f ./$ENV_PATH ]; then
    set -a
    source ./$ENV_PATH
    set +a
else
    echo "Error: .env file not found."
    exit 1
fi

# --- [ ส่วนที่พี่แก้ไขได้เอง ] ---
TARGET_DATE="2026-02-05"
# ใส่ชื่อ Bucket ที่ต้องการ Restore เว้นวรรคระหว่างชื่อ
#MY_BUCKETS="devices all_status_sky clear_sky mqtt_strings spider_with_PR" 
MY_BUCKETS="all_status_sky clear_sky mqtt_strings spider_with_PR" 
# ------------------------------

echo "--- Starting Bulk Restore Process for Date: $TARGET_DATE ---"

for BUCKET in $MY_BUCKETS; do
    FILE_NAME="${TARGET_DATE}_${BUCKET}.csv"
    TAR_FILE="${FILE_NAME}.tar.gz"

    echo "--------------------------------------------"
    echo "Checking Bucket: $BUCKET"

    # 2. เช็คว่ามีไฟล์ Backup อยู่จริงไหม
    if [ ! -f "$HOST_BACKUP_DIR/$TAR_FILE" ]; then
        echo "Skip: Backup file $TAR_FILE not found."
        continue
    fi

    # 3. แตกไฟล์
    echo "Extracting $TAR_FILE..."
    tar -xzvf $HOST_BACKUP_DIR/$TAR_FILE -C $HOST_BACKUP_DIR

    # 4. Restore เข้า InfluxDB
    echo "Restoring data to bucket: $BUCKET..."
    docker exec -i -e INFLUX_TOKEN=$INFLUX_TOKEN $INFLUX_CONTAINER_NAME influx write \
      --org $INFLUX_ORG \
      --bucket $BUCKET \
      --format csv \
      --file /backup/$FILE_NAME

    # 5. ลบไฟล์ CSV ชั่วคราว
    rm -f $HOST_BACKUP_DIR/$FILE_NAME
    echo "Done for $BUCKET"
done

echo "--------------------------------------------"
echo "--- Bulk Restore Completed ---"