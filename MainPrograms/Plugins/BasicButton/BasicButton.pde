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
