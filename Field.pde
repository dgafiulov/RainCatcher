class Field {
  private float wid; // field width
  private float hei; // field height
  private float depth; // field depth
  private float[] fieldIsometricCoordinates = new float[8]; // 4 coordinates: x1, y1, x2, y2, x3, y3, x4, y4
  private float x = 0;
  private float y = 0;
  
  public Field(float wid, float hei, float depth) {
    this.wid = wid;
    this.hei = hei;
    this.depth = depth;
  }
  
  public void initFieldIsometricCoordinates() {
    float x1 = x - (wid / 2);
    float y1 = y - (hei / 2);
    fieldIsometricCoordinates[0] = x1;
    fieldIsometricCoordinates[1] = y1;
    fieldIsometricCoordinates[2] = x1 + wid;
    fieldIsometricCoordinates[3] = y1;
    fieldIsometricCoordinates[4] = x1 + wid;
    fieldIsometricCoordinates[5] = y1 + hei;
    fieldIsometricCoordinates[6] = x1;
    fieldIsometricCoordinates[7] = y1 + hei;
  }
  
  public float getWid() {
    return wid;
  }
  
  public float getHei() {
    return hei;
  }
  
  public float[] getFieldIsometricCoordinates() {
    return fieldIsometricCoordinates;
  }
  
  public void setX(float x) {
    this.x = x;
  }
  
  public void setY(float y) {
    this.y = y;
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public float getDepth() {
    return depth;
  }
}
