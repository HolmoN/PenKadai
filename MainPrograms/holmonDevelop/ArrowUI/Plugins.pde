//EasyProcessingRX

interface IObservable<T>
{
  public void Subscribe(fn<T> f);
}

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

///////////////////////////////////////////////////////////////
//BasicButton

class CircleButton
{
  float x;
  float y;
  float r;
  
  public boolean OnClicked()
  {
    boolean result = false;
    
    if(dist(x, y, mouseX, mouseY) < r) result = true;
    
    return result;
  }
  
  public void ReDraw()
  {
    ellipse(x, y, r*2, r*2);
  }
  
  CircleButton(float _x, float _y, float _r)
  {
    x=_x;
    y=_y;
    r=_r;
    
    ellipse(x, y, r*2, r*2);
  }
}

class RectButton
{
  float x;
  float y;
  float w;
  float h;
  
  public boolean OnClicked()
  {
    boolean result = false;
    
    if(x<mouseX && mouseX<x+w)
    {
      if(y<mouseY && mouseY<y+h) result = true;
    }
    
    return result;
  }
  
  public void ReDraw()
  {
    rect(x, y, w, h);
  }
  
  RectButton(float _x, float _y, float _w, float _h)
  {
    x=_x;
    y=_y;
    w=_w;
    h=_h;
    
    rect(x, y, w, h);
  }
}

///////////////////////////////////////////////////////////////
//WindowObject
class WindowObject
{
  float x = 50;
  float y = 500;
  float w = 700;
  float h = 250;
  
  float textX = 100;
  float textY = 600;
  int textSize = 50;
  
  String text = "";
  
  public void ReDraw()
  {
    fill(150);
    rect(x, y, w, h);
    fill(0);
    textSize(textSize);
    textAlign(LEFT);
    text(text, textX, textY);
  }
  
  public boolean OnClicked()
  {
    boolean result = false;
    
    if(x<mouseX && mouseX<x+w)
    {
      if(y<mouseY && mouseY<y+h) result = true;
    }
    
    return result;
  }
  
  public void SetText(String _text)
  {
    text = _text;
  }
}

///////////////////////////////////////////////////////////////
//ModuleContainer
//モジュールの値を保存するクラス
class ModuleContainer
{
  int DistanceValue;
  int TemperatureValue;
  int LightValue;
}
