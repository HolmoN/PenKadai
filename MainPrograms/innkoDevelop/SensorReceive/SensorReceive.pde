ISensorReceivable model = new SensorReceivabler();
void setup()
{
  model.init(this);
}

void draw()
{
  model.tick();
}
