Drawer drawer;
UIDrawer uiDrawer;
Field field;
Platform platform;
boolean[] moveDirection = {false, false, false, false}; // 0 - W, 1 - D, 2 - A, 3 - S
ArrayList<Stone> stones;
ArrayList<Puddle> puddles;
boolean enterIsPressed = false;
int gameState = 0; // 0 is start menu, 1 is game, 2 is controls, 3 is pause, 4 is lose screen, 5 is exit
int totalScore;
boolean gameInited = false;
float speedMin;
float speedMax;
int lastAcceleration = 0;

// for stones
private float diameterMax = 40;
private float diameterMin = 25;

void setup() {
  size(800, 600);
  frameRate(100);
  textAlign(CENTER, CENTER);
  uiDrawer = new UIDrawer();
}

void draw() {
  switch (gameState) {
    case 0: 
      uiDrawer.drawMenu();
      uiDrawer.updateButtons(gameState);
      break;
    case 1:
      if (!gameInited) {
        gameInit();
        gameInited = true;
      }
      drawer.drawBackground();
      platformMotion();
      stonesCreation();
      stonesMotion();
      stoneAbleToCatch();
      puddlesDisappear();
      checkIfNotLost(platform.getScore());
      drawer.drawField();
      drawer.drawStonesShadow(stones);
      drawer.drawPuddles(puddles);
      drawer.drawPlatform();
      drawer.drawStones(stones);
      uiDrawer.drawStats(totalScore, platform.getScore());
      break;
    case 2:
      uiDrawer.drawControls();
      uiDrawer.updateButtons(gameState);
      break;
    case 3:
      drawer.drawField();
      drawer.drawStonesShadow(stones);
      drawer.drawPuddles(puddles);
      drawer.drawPlatform();
      drawer.drawStones(stones);
      uiDrawer.drawStats(totalScore, platform.getScore());
      uiDrawer.drawPause();
      uiDrawer.updateButtons(gameState);
      break;
    case 4:
      drawer.drawField();
      drawer.drawStonesShadow(stones);
      drawer.drawPuddles(puddles);
      drawer.drawPlatform();
      drawer.drawStones(stones);
      uiDrawer.drawStats(totalScore, platform.getScore());
      uiDrawer.updateButtons(gameState);
      uiDrawer.drawLoseScreen();
      uiDrawer.updateButtons(gameState);
      break;
    case 5:
      exit();
      break;
  }
}

void keyPressed() {
  if (key == ENTER) {
    enterIsPressed = true;
  }
  if (key == BACKSPACE) {
    if (gameState == 1) {
      gameState = 3;
    } else if (gameState == 3) {
      gameState = 1;
    }
  }
  if ((key == 'w') || (key == 'W')) {
    moveDirection[0] = true;
  } 
  if ((key == 'd') || (key == 'D')) {
    moveDirection[1] = true;
  } 
  if ((key == 'a') || (key == 'A')) {
    moveDirection[2] = true;
  } 
  if ((key == 's') || (key == 'S')) {
    moveDirection[3] = true;
  }
}

void mousePressed() {
  uiDrawer.pressButtons(mouseX, mouseY, gameState);
}

void mouseReleased() {
  int currentState = uiDrawer.unpressButtons(gameState);
  if (currentState != -1) {
    gameState = currentState;
    if (currentState == 0) {
      gameInited = false;
    }
  }
}

void keyReleased() {
  if (key == ENTER) {
    enterIsPressed = false;
  }
  if ((key == 'w') || (key == 'W')) {
    moveDirection[0] = false;
  } 
  if ((key == 'd') || (key == 'D')) {
    moveDirection[1] = false;
  } 
  if ((key == 'a') || (key == 'A')) {
    moveDirection[2] = false;
  } 
  if ((key == 's') || (key == 'S')) {
    moveDirection[3] = false;
  }
}

void mouseDragged() {
  if (gameState == 1) {
    drawer.rotate();
  }
}

void gameInit() {
  totalScore = 0;
  speedMin = 0.5;
  speedMax = 2;
  lastAcceleration = 0;
  field = new Field(700, 700, 70);
  platform = new Platform(5, 200, 100, 10);
  drawer = new Drawer(field, platform);
  stones = new ArrayList<>();
  puddles = new ArrayList<>();
}

void platformMotion() {
  if (moveDirection[0] && platform.canMoveUp(field.getHei())) {
    platform.moveY(-1);
  }
  else if (moveDirection[1] && platform.canMoveRight(field.getWid())) {
    platform.moveX(1);
  }
  else if (moveDirection[2] && platform.canMoveLeft(field.getWid())) {
    platform.moveX(-1);
  }
  else if (moveDirection[3] && platform.canMoveDown(field.getHei())) {
    platform.moveY(1);
  }
}

void stonesMotion() {
  int i = 0;
  while (i < stones.size()) {
    Stone currentStone = stones.get(i);
    currentStone.move();
    if (currentStone.getZ() >= 0 - currentStone.getDiameter() / 2) {
      totalScore += 1;
      stones.remove(i);
      puddles.add(new Puddle(currentStone.getX(), currentStone.getY(), currentStone.getDiameter(), currentStone.getColor()));
    }
    else {
      i++;
    }
  }
}

void stoneAbleToCatch() {
  int i = 0;
  platform.setColor(color(255, 0, 0));
  while (i < stones.size()) {
    Stone currentStone = stones.get(i);
    if (currentStone.getZ() >= -platform.getDepth() * 5) {
      float stoneX = currentStone.getX();
      float stoneY = currentStone.getY();
      float platformX = platform.getX();
      float platformY = platform.getY();
      float platformWid = platform.getWid();
      float platformHei = platform.getHei();
      boolean fitsHorizontally = stoneX >= platformX && stoneX <= platformX + platformWid;
      boolean fitsVertically = stoneY >= platformY && stoneY <= platformY + platformHei;
      
        if (fitsHorizontally && fitsVertically) {
          platform.setColor(color(0, 255, 0));
          if (enterIsPressed) {
            platform.scorePlus();
            stones.remove(i);
            enterIsPressed = false;
            platform.addStoneInPlatform(currentStone.getColor());
            totalScore += 1;
          } else {
            i++;
          }
        } else {
          i++;
        }
      } else {
      i++;
    } 
  }
}

void stonesCreation() {
  while (stones.size() < 3) {
    float fieldWid = field.getWid();
    float fieldHei = field.getHei();
    float diameter = random(diameterMin, diameterMax);
    float x = random(-fieldWid / 2 + diameter, fieldWid / 2 - diameter);
    float y = random(-fieldHei / 2 + diameter, fieldHei / 2 - diameter);
    stones.add(new Stone(x, y, diameter, speedMin, speedMax));
  }
}

void puddlesDisappear() {
  int i = 0;
  while (i < puddles.size()) {
    if (puddles.get(i).getTime() <= 0) {
      puddles.remove(i);
    } else {
      puddles.get(i).timePass();
      i++;
    }
  }
}

void checkIfNotLost(int platformScore) {
  if (totalScore % 10 == 0 && totalScore > 0 && totalScore / 10 != lastAcceleration) {
    lastAcceleration = totalScore / 10;
    speedMin *= 1.1;
    speedMax *= 1.1;
  }
  if (totalScore - platformScore >= 20) {
    gameState = 4;
  }
}
