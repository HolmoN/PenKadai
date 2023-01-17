public interface ISensorReceivable
{
  public void init(SensorReceive s);
  public void tick();
  
  public ModuleContainer GetSensorValues();
}
