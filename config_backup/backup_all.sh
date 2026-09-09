#!/bin/bash

#### Load .env ####
ENV_PATH="../env_file/.env"

# 1. Load configurations
if [ -f $ENV_PATH ]; then
    export $(grep -v '^#' $ENV_PATH | xargs)
else
    echo "Error: .env file not found."
    exit 1
fi

DATE_NOW=$(date +%Y-%m-%d_%H%M%S)
BACKUP_FULL_NAME="full_backup_$DATE_NOW"
BACKUP_PATH="/backup/$BACKUP_FULL_NAME"

echo "--- Starting FULL System Backup: $DATE_NOW ---"

# 2. สร้างโฟลเดอร์สำหรับเก็บ Backup ภายใน Container volume
mkdir -p $HOST_BACKUP_DIR/$BACKUP_FULL_NAME

# 3. สั่ง Full Backup (เก็บทุกอย่าง: ทุก Bucket, ทุก Org, Metadata)
# คำสั่งนี้ไม่รองรับ --start/--stop เพราะเป็นการสำรองข้อมูลระดับระบบ
docker exec -e INFLUX_TOKEN=$INFLUX_TOKEN $INFLUX_CONTAINER_NAME influx backup \
  --org $INFLUX_ORG \
  $BACKUP_PATH

# 4. บีบอัดไฟล์ทั้งหมดเป็นไฟล์เดียวเพื่อย้ายง่าย
echo "Compressing full backup..."
tar -czvf $HOST_BACKUP_DIR/${BACKUP_FULL_NAME}.tar.gz -C $HOST_BACKUP_DIR $BACKUP_FULL_NAME

# 5. ลบโฟลเดอร์ดิบออก
rm -rf $HOST_BACKUP_DIR/$BACKUP_FULL_NAME

# 6. (Optional) ย้ายไป OMV ถ้าคุณตั้งค่า rclone ไว้
# rclone move $HOST_BACKUP_DIR/${BACKUP_FULL_NAME}.tar.gz omv_backup:/full_backups/

echo "--- Full Backup Completed: ${BACKUP_FULL_NAME}.tar.gz ---"