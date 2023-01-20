import processing.net.*;

class NetworkModule implements INetworkModule
{
  Subject<Boolean> Receive = new Subject();
  public IObservable<Boolean> receive() { return Receive; }
  
  Server server = null;
  Client client = null;
  
  String ip = "192.168.10.102";
  int pass = 12345;
  boolean _isServer = false;
  
  public NetworkModule(dassyutuge_mu parent, boolean isServer)
  {
    _isServer = isServer;
    
    if(client != null) 
      {
        client.stop();
        client = null;
      }
      if(server != null)
      {
        server.stop();
        server = null;
      }
    
    if(isServer) server = new Server(parent, pass);
    else client = new Client(parent, ip, pass);
  }
  
  public void Write(String date)
  {
    if(_isServer) server.write(date + ",");
    else client.write(date + ",");
  }
  
  public void Tick()
  {
    String res = "";
    Boolean ret = false;
    
    if( _isServer ) //サーバ側のとき
    {  
      Client nextClient = server.available();  // データ送信しているクライアントの確認
      if( nextClient != null )
      {
        res = nextClient.readString();  //クライアントがあればデータ受信
      }    
    }
    else //クライアント側のとき
    {  
      if( client.available() > 0 )
      {
        res = client.readString();
      }
    }
    
    if(res != "") //受け取った情報があるとき
    {
      String [] data = split( res, ',' );
      int num = int(data[data.length-2]);
      
      if(num == 0) ret = false;
      else ret = true;
      
      Receive.OnNext(ret);
    }
  }
  
  public void Stop()
  {
    if(client != null) 
      {
        client.stop();
        client = null;
      }
      if(server != null)
      {
        server.stop();
        server = null;
      }
  }
}
