#!/bin/bash

#### Load .env ####
ENV_PATH="../env_file/.env"

# 1. Load configurations
if [ -f $ENV_PATH ]; then
    set -a            # สั่งให้ตัวแปรที่ถูกประกาศหลังจากนี้เป็น export โดยอัตโนมัติ
    source ./$ENV_PATH       # อ่านไฟล์ .env ตรงๆ
    set +a            # ปิดโหมด auto-export
else
    echo "Error: .env file not found."
    exit 1
fi

# DATE_SUFFIX=$(date -d "yesterday" +%Y-%m-%d)
# # ตั้งช่วงเวลาสำหรับ Query (เมื่อวาน)
# START_TIME=$(date -d "yesterday 00:00" --utc +%Y-%m-%dT%H:%M:%SZ)
# STOP_TIME=$(date -d "yesterday 23:59" --utc +%Y-%m-%dT%H:%M:%SZ)

# echo "--- Starting Daily Data Export for $DATE_SUFFIX ---"

# แก้ไขช่วงเวลาให้เป็นเมื่อ 90 วันที่แล้ว
DATE_SUFFIX=$(date -d "90 days ago" +%Y-%m-%d)
START_TIME=$(date -d "91 days ago 00:00" --utc +%Y-%m-%dT%H:%M:%SZ)
STOP_TIME=$(date -d "90 days ago 00:00" --utc +%Y-%m-%dT%H:%M:%SZ)

echo "--- Starting Backup for data from 90 days ago ($DATE_SUFFIX) ---"

# 2. ดึงรายชื่อ Bucket (ปรับปรุงตัวกรองให้แม่นยำขึ้น)
BUCKETS=$(docker exec -e INFLUX_TOKEN=$INFLUX_TOKEN $INFLUX_CONTAINER_NAME influx bucket list --org $INFLUX_ORG | awk 'NR>1 {print $2}' | grep -E '^[a-zA-Z0-9]')

for BUCKET in $BUCKETS; do
    # ข้าม Bucket ระบบ
    [[ "$BUCKET" == _* ]] && continue
    
    echo "Exporting data from bucket: $BUCKET"
    
    FILE_NAME="${DATE_SUFFIX}_${BUCKET}.csv"
    
    # 3. ใช้ Flux Query เพื่อดึงข้อมูลเฉพาะช่วงเวลาออกมาเป็น CSV
    # วิธีนี้จะทำให้คุณเลือกช่วงเวลา "เมื่อวาน" ได้ตามที่ต้องการเป๊ะๆ
    QUERY="from(bucket: \"$BUCKET\") |> range(start: $START_TIME, stop: $STOP_TIME)"
    
    docker exec -e INFLUX_TOKEN=$INFLUX_TOKEN $INFLUX_CONTAINER_NAME influx query \
      --org $INFLUX_ORG \
      "$QUERY" --raw > $HOST_BACKUP_DIR/$FILE_NAME

    # 4. บีบอัดไฟล์ CSV
    if [ -s "$HOST_BACKUP_DIR/$FILE_NAME" ]; then
        tar -czvf $HOST_BACKUP_DIR/${FILE_NAME}.tar.gz -C $HOST_BACKUP_DIR $FILE_NAME
        rm -f $HOST_BACKUP_DIR/$FILE_NAME
    else
        echo "No data found for $BUCKET on $DATE_SUFFIX, skipping..."
        rm -f $HOST_BACKUP_DIR/$FILE_NAME
    fi
done

# 5. ลบไฟล์เก่า
find $HOST_BACKUP_DIR -type f -name "*.tar.gz" -mtime +$RETENTION_FILES -exec rm {} \;

echo "--- All exports completed for $DATE_SUFFIX ---"
