# TIG-Stack
**TIG stack** คือชุดซอฟต์แวร์โอเพนซอร์ส (Open-source) 3 ตัวหลัก ที่ทำงานร่วมกันเพื่อใช้ในการจัดเก็บ แสดงผล และติดตามข้อมูลแบบอนุกรมเวลา (Time-series data) เช่น การตรวจสอบการทำงานของเซิร์ฟเวอร์, ระบบเน็ตเวิร์ก หรือข้อมูลจากเซนเซอร์ IoT

ส่วนประกอบของ TIG Stack

ชื่อ TIG ย่อมาจากชื่อเครื่องมือ 3 ตัว ได้แก่:

-   **T - [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/)**: ทำหน้าที่เป็นตัวเก็บข้อมูล (Agent) คอยดึงหรือรับค่าเมตริก (Metrics) ต่างๆ เช่น การใช้งาน CPU, หน่วยความจำ (RAM), พื้นที่ดิสก์ (Disk) หรือสถิติจาก Docker แล้วส่งต่อไปยังฐานข้อมูล [[1](https://translate.google.com/translate?u=https://blog.saltdata.ro/self-hosted-monitoring-grafana-influxdb-telegraf&hl=th&sl=en&tl=th&client=sge)]

-   **I - [InfluxDB](https://www.influxdata.com/)**: ทำหน้าที่เป็นระบบจัดการฐานข้อมูล (Time-series Database) ที่ถูกออกแบบมาเพื่อรองรับและค้นหาข้อมูลที่มีประทับเวลา (Timestamp) ปริมาณมากๆ ได้อย่างรวดเร็วและมีประสิทธิภาพ [[1](https://translate.google.com/translate?u=https://www.influxdata.com/blog/tig-stack-guide-influxdb-core/&hl=th&sl=en&tl=th&client=sge), [2](https://translate.google.com/translate?u=https://blog.saltdata.ro/self-hosted-monitoring-grafana-influxdb-telegraf&hl=th&sl=en&tl=th&client=sge)]

-   **G - [Grafana](https://grafana.com/)**: ทำหน้าที่เป็นแพลตฟอร์มแปลงข้อมูลดิบจาก InfluxDB ให้กลายเป็นกราฟ แดชบอร์ด (Dashboard) ที่สวยงาม และตั้งค่าระบบแจ้งเตือน (Alerts) ได้
