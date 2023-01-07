void setup()
{
  view v = new view();
  
  v.Ivavava.Subscribe(new fn<Unit>()
    {
      public void func(Unit m){ println("hoge"); }
    }
  );
  
  v.init();
}
