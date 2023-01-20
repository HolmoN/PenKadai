NetworkModule module = new NetworkModule(this, true);

void setup()
{
  module.receive().Subscribe(new fn<Boolean>(){ public void func(Boolean rec)
    {
      println(rec);
    }});
}

void draw()
{
  module.Tick();
}

void mousePressed()
{
  module.Write("0");
}

void stop()
{
  
}
