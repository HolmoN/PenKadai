public interface INetworkConnectable
{
  //金庫のシーン(2人プレイ)における、鍵を手に入れたかどうかのフラグを送る
  public void Send(Boolean bl);
  //金庫のシーン(2人プレイ)における、鍵を手に入れたかどうかのフラグを受け取る
  public Boolean Receive();
  
  public void Stop();
  
  //このプログラムを起動しているコンピューターが、サーバーとしてふるまうかどうか渡される
  public void IsServer(boolean isServer,dassyutuge_mu d);
}
