public interface INetworkModule
{
  public IObservable<Boolean> receive();
  
  public void Write(String date);
  public void Tick();
  public void Stop();
}
