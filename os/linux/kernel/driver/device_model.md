# Device Model

kernelがhardwareとdriverを体系的に管理するための概念

* object model
  * すべてのdeviceを`struct device` として表現

  ```c
  struct device {
      struct device   *parent;
      struct bus_type *bus;
      struct device_driver *driver;
      struct kobject  kobj;
      void            *platform_data;
      ...
  };
  ```

  ```text
  Bus ── Device ── Driver
            │
          Class
  ```

* binding
* lifecycle
  * 登録/削除
  * 電源管理
* userspaceとの連携
  * `/sys/devices/...`
