class Platform {
  
  // coordinates are relative to the origin of the field
  // so (0, 0) means bottom left point is in the center of the field
  private float x; // bottom left point x
  private float y; // bottom left point y
  private float z; // distance between floor and platform
  private float wid; // width of platform
  private float hei; // height of platform
  private float depth; // depth of platform = height of walls
  private float speed = 10;
  private int score = 0; // amount of catched stones
  private color ableToCatchColor; // green color of phantom zone, meaning that stone can be cathed
  private color[] stonesInPlatform;
  
  public Platform(float z, float wid, float hei, float depth) {
    this.z = z;
    this.wid = wid;
    this.hei = hei;
    this.depth = depth;
    ableToCatchColor = color(0, 255, 0);
    stonesInPlatform = new color[10];
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
  
  public void setX(float x) {
    this.x = x;
  }
  
  public void setY(float y) {
    this.y = y;
  }
  
  public void moveX(float step) {
    x += step * speed;
  }
  
  public void moveY(float step) {
    y += step * speed;
  }
  
  public float getWid() {
    return wid;
  }
  
  public float getHei() {
    return hei;
  }
  
  public float getDepth() {
    return depth;
  }
  
  public boolean canMoveLeft(float fieldWid) {
    if (x <= -(fieldWid / 2)) {
      return false;
    }
    return true;
  }
  
  public boolean canMoveRight(float fieldWid) {
    if (x + wid >= (fieldWid / 2)) {
      return false;
    }
    return true;
  }
  
  public boolean canMoveUp(float fieldHei) {
    if (y <= -(fieldHei / 2)) {
      return false;
    }
    return true;
  }
  
  public boolean canMoveDown(float fieldHei) {
    if (y + hei >= (fieldHei / 2)) {
      return false;
    }
    return true;
    
  }
    
  public void scorePlus() {
    score += 1;
  }
  
  public int getScore() {
    return score;
  }
  
  public color getColor() {
    return ableToCatchColor;
  }
  
  public void setColor(color ableToCatchColor) {
    this.ableToCatchColor = ableToCatchColor;
  }
  
  public color[] getStonesInPlatform() {
    return stonesInPlatform;
  }
  
  public void addStoneInPlatform(color stone) {
    int amountOfStonesInPlatform = getAmountOfStonesInPlatform();
    if (amountOfStonesInPlatform == 10) {
      stonesInPlatform = new color[10];
      stonesInPlatform[0] = stone;
    } else {
      stonesInPlatform[amountOfStonesInPlatform] = stone;
    }
  }
  
  public int getAmountOfStonesInPlatform() {
    for (int i = 0; i < stonesInPlatform.length; i++) {
      if (stonesInPlatform[i] == 0) {
        return i;
      }
    }
    return 10;
  }
}
