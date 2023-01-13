public interface ISensorReceivable
{
  public ArrayList<SensorValue> GetSensorValues();
}

public class SensorValue
{
  String sensorName;
  int sensorValue;
  
  
}
