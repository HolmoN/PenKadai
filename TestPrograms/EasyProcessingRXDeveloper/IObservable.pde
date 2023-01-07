interface IObservable<T>
{
  public void Subscribe(fn<T> f);
}
