class Button {
  private String text;
  private float x;
  private float y;
  private float wid;
  private float hei;
  private int colorUnpressed = 120;
  private int colorPressed = 50;
  private int currentColor;
  //private boolean isPressed;
  private int status = 0; // 0 is rest, 1 is pressed, 2 is unpressed 
  private float speed = 10;
  
  public Button(String text, float x, float y, float wid, float hei) {
    this.text = text;
    this.x = x;
    this.y = y;
    this.wid = wid;
    this.hei = hei;
    currentColor = colorUnpressed;
  }
  
  public String getText() {
    return text;
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public float getWid() {
    return wid;
  }
  
  public float getHei() {
    return hei;
  }
  
  public color getColor() {
    return color(currentColor);
  }
  
  public int getStatus() {
    return status;
  }
  
  public boolean isOver(float x, float y) {
    return (x >= this.x && x <= this.x + wid) && (y >= this.y && y <= this.y + hei);
  }
  
  public void press() {
    status = 1;
  }
  
  public void unpress() {
    status = 2;
  }
  
  public void update() {
    
    if (status == 1) {
      if (currentColor > colorPressed) {
        currentColor -= speed;
      }
    } else if (status == 2) {
      if (currentColor != colorUnpressed) {
        status = 0;
        currentColor = colorUnpressed;
      }
    }
  }
}
