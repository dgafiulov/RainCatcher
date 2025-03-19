// This class is being used only for drawing parts of the game: world, platform, background, stones, puddles. For UI there is a class UIDrawer

class Drawer {
  private Field field;
  private Platform platform;
  private float tileWid = 1;
  private float tileHei = 0.5;
  private float[] fieldScreenCoordinates = new float[8]; // 4 coordinates: x1, y1, x2, y2, x3, y3, x4, y4
  private float[] starsCoordinates;
  
  private float maxTileHei = 0.6;
  private float minTileHei = 0.1;
  
  public Drawer(Field field, Platform platform) {
    this.field = field;
    this.platform = platform;
    platform.setX(0);
    platform.setY(0);
    generateStars(200);
  }
  
  public void drawPlatform() {
    // isometric coordinates
    float x = field.getX() + platform.getX();
    float y = field.getY() + platform.getY();
    float z = platform.getZ();
    float wid = platform.getWid();
    float hei = platform.getHei();
    float depth = platform.getDepth();
    // screen coordinates of top left
    float x1 = isometricToScreenX(x, y);
    float y1 = isometricToScreenY(x, y) - z;
    // screen coordinates of top right
    float x2 = isometricToScreenX(x + wid, y);
    float y2 = isometricToScreenY(x + wid, y) - z;
    // screen coordinates of bottom right
    float x3 = isometricToScreenX(x + wid, y + hei);
    float y3 = isometricToScreenY(x + wid, y + hei) - z;
    // screen coordinates of bottom left
    float x4 = isometricToScreenX(x, y + hei);
    float y4 = isometricToScreenY(x, y + hei) - z;
    // screen coordinates of light signalizing that stone can be catched
    float lightX1 = isometricToScreenX(x + wid, y + hei / 3);
    float lightY1 = isometricToScreenY(x + wid, y + hei / 3) - z;
    float lightX2 = isometricToScreenX(x + wid, y + hei / 3 * 2);
    float lightY2 = isometricToScreenY(x + wid, y + hei / 3 * 2) - z;
    
    // shadow
    fill(20);
    quad(x1, y1 + z, x2, y2 + z, x3, y3 + z, x4, y4 + z);
    
    // bottom
    fill(150);
    quad(x1, y1, x2, y2, x3, y3, x4, y4);
    
    // walls back
    fill(175);
    quad(x1, y1, x2, y2, x2, y2 - depth, x1, y1 - depth);
    quad(x1, y1, x4, y4, x4, y4 - depth, x1, y1 - depth);
    
    // stones 
    color[] stonesInPlatform = platform.getStonesInPlatform();
    int amountOfStonesInPlatform = platform.getAmountOfStonesInPlatform();
    if (amountOfStonesInPlatform > 0) {
      float stonesDepth = ((float) amountOfStonesInPlatform / stonesInPlatform.length) * depth;
      fill(stonesInPlatform[amountOfStonesInPlatform - 1]);
      quad(x1, y1 - stonesDepth, x2, y2 - stonesDepth, x3, y3 - stonesDepth, x4, y4 - stonesDepth);    
    }
    
    // walls front
    fill(255);
    quad(x3, y3, x4, y4, x4, y4 - depth, x3, y3 - depth);
    quad(x3, y3, lightX2, lightY2, lightX2, lightY2 - depth, x3, y3 - depth);
    quad(x2, y2, lightX1, lightY1, lightX1, lightY1 - depth, x2, y2 - depth);
    fill(platform.getColor());
    
    // light
    quad(lightX1, lightY1, lightX2, lightY2, lightX2, lightY2 - depth, lightX1, lightY1 - depth);
  }
  
  private void initFieldCoordinates() {
    float[] fieldIsometricCoordinates = field.getFieldIsometricCoordinates();
    for (int i = 0; i < fieldIsometricCoordinates.length; i += 2) {
      fieldScreenCoordinates[i] = isometricToScreenX(fieldIsometricCoordinates[i], fieldIsometricCoordinates[i + 1]);
      fieldScreenCoordinates[i + 1] = isometricToScreenY(fieldIsometricCoordinates[i], fieldIsometricCoordinates[i + 1]);
    }
  }
  
  public void drawField() {
    float depth = field.getDepth();
    field.setX(screenToIsometricX(width / 2, height / 2));
    field.setY(screenToIsometricY(width / 2, height / 2));
    field.initFieldIsometricCoordinates();
    initFieldCoordinates();
    fill(210);
    beginShape();
    int fieldScreenCoordinatesLength = fieldScreenCoordinates.length;
    for (int i = 0; i < fieldScreenCoordinatesLength + 2; i += 2) {
      vertex(fieldScreenCoordinates[i % fieldScreenCoordinatesLength], fieldScreenCoordinates[(i + 1) % fieldScreenCoordinatesLength]);
    }
    endShape();
    fill(150);
    quad(fieldScreenCoordinates[6], fieldScreenCoordinates[7], fieldScreenCoordinates[4], fieldScreenCoordinates[5], fieldScreenCoordinates[4], fieldScreenCoordinates[5] + depth, fieldScreenCoordinates[6], fieldScreenCoordinates[7] + depth);
    fill(230);
    quad(fieldScreenCoordinates[2], fieldScreenCoordinates[3], fieldScreenCoordinates[4], fieldScreenCoordinates[5], fieldScreenCoordinates[4], fieldScreenCoordinates[5] + depth, fieldScreenCoordinates[2], fieldScreenCoordinates[3] + depth);
  }
  
  public float isometricToScreenX(float x, float y) {
    return (x - y) * (tileWid / 2);
  }
  
  public float isometricToScreenY(float x, float y) {
    return (x + y) * (tileHei / 2);
  }
  
  public float screenToIsometricX(float x, float y) {
    return (x / (tileWid / 2) + y / (tileHei / 2)) / 2;
  }
  
  public float screenToIsometricY(float x, float y) {
    return (y / (tileHei / 2) - x / (tileWid / 2)) / 2;
  }
  
  public void drawBackground() {
    background(0);
    fill(255);
    for (int i = 0; i < starsCoordinates.length; i += 2) {
      circle(starsCoordinates[i], starsCoordinates[i + 1], 2);
    }
  }
  
  public void generateStars(int amount) {
    starsCoordinates = new float[amount * 2];
    for (int i = 0; i < amount; i++) {
      starsCoordinates[i * 2] = random(width);
      starsCoordinates[i * 2 + 1] = random(height);
    }
  }
  
  public void rotate() {
    float change = 0;
    if (mouseY - pmouseY != 0) {
      change = 0.25 * (((float) mouseY - pmouseY) / (height / 2));
      if ((change > 0 && tileHei + change < maxTileHei) || (change < 0 && tileHei + change > minTileHei)) {
        tileHei += change;
      }
    }
  }
  
  public void drawStones(ArrayList<Stone> stones) {
    for (Stone stone : stones) {
      float x = isometricToScreenX(field.getX() + stone.getX(), field.getY() + stone.getY());
      float y = isometricToScreenY(field.getX() + stone.getX(), field.getY() + stone.getY()) + stone.getZ();
      fill(stone.getColor());
      circle(x, y, stone.getDiameter()); // falling stones
    }
  }
  
  public void drawStonesShadow(ArrayList<Stone> stones) {
    for (Stone stone : stones) {
      float x = isometricToScreenX(field.getX() + stone.getX(), field.getY() + stone.getY());
      float y = isometricToScreenY(field.getX() + stone.getX(), field.getY() + stone.getY());
      noStroke();
      fill(210 + 255 * 10 / stone.getZ());
      ellipse(x, y, stone.getDiameter() * tileWid, stone.getDiameter() * tileHei); // shadow
      stroke(2);
    }
  }
  
  public void drawPuddles(ArrayList<Puddle> puddles) {
    for (Puddle puddle : puddles) {
      float x = isometricToScreenX(field.getX() + puddle.getX(), field.getY() + puddle.getY());
      float y = isometricToScreenY(field.getX() + puddle.getX(), field.getY() + puddle.getY());
      noStroke();
      fill(puddle.getColor());
      ellipse(x, y, puddle.getDiameter() * tileWid, puddle.getDiameter() * tileHei); // shadow
      stroke(2);
    }
  }
}
