class view
{
  private Subject<Unit> vavava = new Subject();
  public IObservable<Unit> Ivavava = vavava;
  
  void init()
  {
    delay(1000);
    
    vavava.OnNext(Unit.def);
  }
}
