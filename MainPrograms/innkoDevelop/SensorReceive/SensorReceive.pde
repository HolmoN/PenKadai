SensorReceivabler sensor = new SensorReceivabler();
void setup()
{
  sensor.init(this);
}

void draw()
{
  sensor.tick();
}
