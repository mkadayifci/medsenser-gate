class AdvertisementPacket {
  static const int packageTypeActiveTime=1;
  static const int packageTypeHistory=2;
  static const int packageTypeExtentedHistory=3;
  static const int packageTypeMEMS=4;
  final int deviceId;
  final int packageType;
  final AdvertisementSubData subData;
  AdvertisementPacket(
      {required this.deviceId,
      required this.packageType,
      required this.subData});
}

class AdvertisementSubData {
  void test() {
    print("dd");
  }
}

class ActiveTimePackageData extends AdvertisementSubData {
  int lastTemp3;
  int lastTemp2;
  int lastTemp1;
  int currentTemp;
  int sequence;
  ActiveTimePackageData(
      {required this.sequence,
      required this.currentTemp,
      required this.lastTemp1,
      required this.lastTemp2,
      required this.lastTemp3});
}

class HistoryPackageData extends AdvertisementSubData {
  int previousTemp5; // 25 min before
  int previousTemp4; // 20 min before
  int previousTemp3; // 15 min before
  int previousTemp2; // 10 min before
  int previousTemp1; // 5 min before

  HistoryPackageData(
      {required this.previousTemp5,
      required this.previousTemp4,
      required this.previousTemp3,
      required this.previousTemp2,
      required this.previousTemp1});
}

class DefaultPackageData extends AdvertisementSubData {
  int currentTemp;
  int battery;
  DefaultPackageData({required this.currentTemp, required this.battery});
}


 