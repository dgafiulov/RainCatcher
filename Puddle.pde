class Puddle {
  private float x;
  private float y;
  private float red;
  private float green;
  private float blue;
  private float diameter;
  private float time; // percentage: from 0 to 100
  private float timeStep = 0.1; // with what step will be time reduced
  
  public Puddle(float x, float y, float diameter, color puddleColor) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
    red = red(puddleColor);
    green = green(puddleColor);
    blue = blue(puddleColor);
    time = 100;
  }
  
  public void timePass() {
    time -= timeStep;
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public color getColor() {
    return color(red, green, blue, abs((time / 100) * 255));
  }
  
  public float getDiameter() {
    return diameter;
  }
  
  public float getTime() {
    return time;
  }
}
