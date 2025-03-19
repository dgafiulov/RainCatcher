class Stone {
  
  // coordinates are relative to the origin of the field
  private float x;
  private float y;
  private float z;
  private float speed;
  private float diameter;
  private color stoneColor;
  
  private float zMin = -1200;
  private float zMax = -650;
  
  public Stone(float x, float y, float diameter, float speedMin, float speedMax) {
    this.diameter = diameter;
    this.x = x;
    this.y = y;
    z = random(zMin, zMax);
    speed = random(speedMin, speedMax);
    stoneColor = generateColor();
  }
  
  public void move() {
    z += speed;
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public float getZ() {
    return z;
  }
  
  public float getDiameter() {
    return diameter;
  }
  
  public color getColor() {
    return stoneColor;
  }
  
  private color generateColor() {
    color c = color(0);
    while (c == color(0)) {
      c = color(random(0, 255), random(0, 255), random(0, 255));
    }
    return c;
  }
}
