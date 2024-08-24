class MeasurementNode {
  final DateTime timestamp;
  final double temperatureValue;
  MeasurementNode({required this.timestamp, required this.temperatureValue});

  static double convertParcelableTemperature(int parceleableTemperature) 
  {
    if (parceleableTemperature == 1) 
    {
      return double.minPositive;
    } 
    else if (parceleableTemperature == 255) 
    {
      return double.maxFinite;
    } 
    else 
    {
      return (parceleableTemperature * 0.1) + 24.6;
    }
  }
}
