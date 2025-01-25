class SensorData {
  double pitch;
  double yaw;
  double roll;

  double xAcc;
  double yAcc;
  double zAcc;

  SensorData(this.roll, this.pitch, this.yaw, this.xAcc, this.yAcc, this.zAcc);

@override
  String toString() {
    return "Sensordata:{roll:$roll,pitch:$pitch,yaw:$yaw,xAcc:$xAcc,yAcc:$yAcc,zAcc:$zAcc}";
  }}