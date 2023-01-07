abstract class fn<A> 
{
  abstract void func(A arg);
}

enum Unit
{
  def
}

class Subject<T> implements IObservable<T>
{
  private ArrayList<fn> fns;
  
  public Subject()
  {
    fns = new ArrayList<fn>();
  }
  
  public void Subscribe(fn<T> f)
  {
    fns.add(f);
  }
  
  public void OnNext(T value)
  {
    for(int i = 0; i < fns.size(); i++) fns.get(i).func(value);
  }
}
