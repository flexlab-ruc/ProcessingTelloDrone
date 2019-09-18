# ProcessingTelloDrone :rocket:

A processing sketch to control **Tello Drones**. based on the [java version](https://github.com/flexlab-ruc/TelloDroneJavaConnect) but modified to fit older java version in order to work within a P3 processing sketch

## code example
```java
  TelloDrone drone = new TelloDrone();
  drone.setLogToConsole(true);
  drone.connect();
  drone.getBatteryPercentage();
  drone.takeoff();
  drone.rotateClockwise(360);
  drone.land();
```
