public interface INetworkModule
{
  public IObservable<Boolean> receive();
  
  public void Write();
  public void Tick();
}
