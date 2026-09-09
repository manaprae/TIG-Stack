tack
**TIG stack** คือชุดซอฟต์แวร์โอเพนซอร์ส (Open-source) 3 ตัวหลัก ที่ทำงานร่วมกันเพื่อใช้ในการจัดเก็บ แสดงผล และติดตามข้อมูลแบบอนุกรมเวลา (Time-series data) เช่น การตรวจสอบการทำงานของเซิร์ฟเวอร์, ระบบเน็ตเวิร์ก หรือข้อมูลจากเซนเซอร์ IoT

ส่วนประกอบของ TIG Stack

ชื่อ TIG ย่อมาจากชื่อเครื่องมือ 3 ตัว ได้แก่:

-   **T - [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/)**: ทำหน้าที่เป็นตัวเก็บข้อมูล (Agent) คอยดึงหรือรับค่าเมตริก (Metrics) ต่างๆ เช่น การใช้งาน CPU, หน่วยความจำ (RAM), พื้นที่ดิสก์ (Disk) หรือสถิติจาก Docker แล้วส่งต่อไปยังฐานข้อมูล

-   **I - [InfluxDB](https://www.influxdata.com/)**: ทำหน้าที่เป็นระบบจัดการฐานข้อมูล (Time-series Database) ที่ถูกออกแบบมาเพื่อรองรับและค้นหาข้อมูลที่มีประทับเวลา (Timestamp) ปริมาณมากๆ ได้อย่างรวดเร็วและมีประสิทธิภาพ

-   **G - [Grafana](https://grafana.com/)**: ทำหน้าที่เป็นแพลตฟอร์มแปลงข้อมูลดิบจาก InfluxDB ให้กลายเป็นกราฟ แดชบอร์ด (Dashboard) ที่สวยงาม และตั้งค่าระบบแจ้งเตือน (Alerts) ได้

```
git clone https://github.com/manaprae/TIG-Stack.git
cd TIG-Stack
docker compose up influxdb -d
WARN[0000] The "GF_SECURITY_ADMIN_USER" variable is not set. Defaulting to a
 blank string.
 WARN[0000] The "GF_SECURITY_ADMIN_PASSWORD" variable is not set. Defaulting
 to a blank string.
 [+] up 14/14
  ✔ Image influxdb:latest     Pulled                                    21.4s
   ✔ Network tig-stack_default Created                                    0.1s
    ✔ Container influxdb        Started                                   17.7s
    ```
    ไม่เป็นไรจะเห็นมี warning ในส่วนของ User +password ของ grafana
    Login เข้าใช่งาน Influxdb ผ่าน http://<ip-adress>:8086/
    แล้วใส่  user + passwd, Organization Name, Bucket Name  แล้วกด Continue
    จะได้ token มา เอามาใส่ที่ .env
    ```
    cd env_file
    cp env.example .env
    vim .env
    ```
    เอามาใส่ ในส่วนต่างในไฟล์ .env นี้
    ####  Influxdb ####
    INFLUX_CONTAINER_NAME=Influxdb
    INFLUX_HOST="http://ip-server:8086"
    INFLUX_TOKEN=Your_token
    INFLUX_ORG=Your_Org
    INFLUX_BUCKET=Your_Bucket
    แล้วใส่ข้อมูลลง ในไฟล์ .env ในส่วนอื่นๆ ให้ครบ
    #### Grafana ####
    GF_SECURITY_ADMIN_USER=admin
    GF_SECURITY_ADMIN_PASSWORD=Your_passwd

    #### Mqtt-Server ###
    MQTT_SERVER=tcp://<ip-domainneme>:1883
    MQTT_USER=mqtt_user
    MQTT_PASSWORD=mqtt_passwd

    #### Topic-Mqtt ####
    MQTT_TOPICS_1=Topic
    ##MQTT_TOPICS_2=
    ##MQTT_TOPICS_3=
    เมื่อใส่ครบแล้ว
    ```
    docker compose up telegraf -d
    docker compose up grafana -d
    ```
    Login เข้าใช่งาน Grafana ผ่าน http://<ip-adress>:3000/
    แล้วใส่  user + passwd
    ตามที่ set ใว้ใน file .env
