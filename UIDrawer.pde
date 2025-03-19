// This class is responsible for drawing UI elements

class UIDrawer {
  // texts and colors
  private String gameName = "RainCatcher";
  private String author = "by @dgafiulov";
  private String pauseText = "Pause";
  private String backToGameText = "Drücken Sie Backspace, um das Spiel fortzusetzen";
  private String controlsText = "WASD - Bewegung von der Eimer\nZiehen mit der Maus - Winkel zu ändern\nBackspace - Pause\nEnter - auffangen\nWenn Sie 20 oder mehr Tropfen verpassen, ist das Spiel zu Ende\nNach jeden 10 Tropfen wird die Geschwindigkeit höher";
  private String catched = "Gefangen: ";
  private String total = "Total: ";
  private String loseText = "Du hast verloren";
  private String lostStones = "Verpasst: ";
  
  private color pauseAndYouLostColor = color(0, 0, 0, 100);
  private color backgroundColor = color(255);
  private color buttonsTextColor = color(255);
  private color pauseAndYouLostTextColor = color(255);
  private color menuTextColor = color(0);
  private color dangerColor = color(255, 0, 0);
  
  private int headingSize1 = 80;
  private int headingSize2 = 15;
  private int buttonTextSize = 20;
  private int normalTextSize = 25;
  
  // sizes and coordinates of buttons
  private float buttonsWid = width / 3;
  private float buttonsHei = height / 7;
  private float distanceBetweenButtons = 10;
  private float buttonsX = (width - buttonsWid) / 2;
  
  // buttons
  private Button[] menuButtons = new Button[3]; // 0 - start, 1 - controls, 2 - exit
  private String[] menuButtonsTexts = {"Beginnen", "Steuerung", "Spiel verlassen"};
  private Button[] backToMenuButton = new Button[1];
  private String[] backToMenuButtonText = {"Menu"};
  
  public UIDrawer() {
    menuButtons = initButtons(menuButtons, menuButtonsTexts);
    backToMenuButton = initButtons(backToMenuButton, backToMenuButtonText);
  }
  
  private Button[] initButtons(Button[] buttons, String[] buttonsTexts) {
    Button[] initedButtons = new Button[buttons.length];
    for (int i = 0; i < buttons.length; i++) {
      float buttonY = height - (distanceBetweenButtons + buttonsHei) * (buttons.length - i);
      initedButtons[i] = new Button(buttonsTexts[i], buttonsX, buttonY, buttonsWid, buttonsHei);
    }
    return initedButtons;
  }
  
  private void drawButtons(Button[] buttons) {
    textSize(buttonTextSize);
      for (Button button : buttons) {
        fill(button.getColor());
        rect(button.getX(), button.getY(), button.getWid(), button.getHei());
        fill(buttonsTextColor);
        text(button.getText(), button.getX() + button.getWid() / 2, button.getY() + button.getHei() / 2);
      }
  }
  
  public void drawMenu() {
    background(backgroundColor);
    
    textSize(headingSize1);
    fill(menuTextColor);
    float gameNameTextY = (distanceBetweenButtons + buttonsHei) * menuButtons.length / 2;
    text(gameName, width / 2, gameNameTextY);
    textSize(headingSize2);
    text(author, width / 10.0 * 6.8, gameNameTextY + headingSize2 * 2 + 10);
    
    drawButtons(menuButtons);
  }
  
  public void drawControls() {
    background(backgroundColor);
    drawButtons(backToMenuButton);
    fill(menuTextColor);
    textSize(normalTextSize);
    text(controlsText, width / 2, height / 2);
  }
  
  private void drawStop() {
    fill(pauseAndYouLostColor);
    rect(0, 0, width, height);
    drawButtons(backToMenuButton);
  }
  
  public void drawPause() {
    drawStop();
    fill(pauseAndYouLostTextColor);
    textSize(headingSize1);
    text(pauseText, width / 2, height / 4);
    textSize(normalTextSize);
    text(backToGameText, width / 2, height / 3);
  }
  
  public void drawLoseScreen() {
    drawStop();
    fill(pauseAndYouLostTextColor);
    textSize(headingSize1);
    text(loseText, width / 2, height / 4);
  }
  
  private void drawStats(float totalScore, int platformScore) {
    textSize(normalTextSize);
    fill(backgroundColor);
    float boxSize = textWidth(catched + totalScore);
    rect(width - boxSize, 0, boxSize, normalTextSize * 3);
    fill(menuTextColor);
    if (totalScore - platformScore >= 15) {
      fill(dangerColor);
    }
    text(lostStones + round(totalScore - platformScore), width - boxSize / 2, normalTextSize / 2 * 5);
    fill(menuTextColor);
    text(catched + platformScore, width - boxSize / 2, normalTextSize / 2);
    totalScore = totalScore == 0 ? 1 : totalScore;
    text(total + round(platformScore / totalScore * 100) + "%", width - boxSize / 2, normalTextSize / 2 * 3);
  }
  
  public void pressButtons(float x, float y, int UIState) {
    switch (UIState) {
      case 0:
        for (Button button : menuButtons) {
          if (button.isOver(x, y)) {
            button.press();
          }
        }
        break;
      case 2:
      case 3:
      case 4:
        for (Button button : backToMenuButton) {
          if (button.isOver(x, y)) {
            button.press();
          }
        }
    }
  }
  
  public int unpressButtons(int UIState) {
    switch (UIState) {
      case 0:
        for (int i = 0; i < menuButtons.length; i++) {
          if (menuButtons[i].getStatus() == 1) {
            menuButtons[i].unpress();
            switch (i) {
              case 0:
                return 1;
              case 1:
                return 2;
              case 2:
                return 5;
            }
          }
        }
        break;
      case 2:
      case 3:
      case 4:
        for (int i = 0; i < backToMenuButton.length; i++) {
          if (backToMenuButton[i].getStatus() == 1) {
            backToMenuButton[i].unpress();
            return 0;
          }
        }
        break;
    }
    return -1; // code of nothing. No action is happening;
  }
  
  public void updateButtons(int UIState) {
    switch (UIState) {
      case 0:
        for (Button button : menuButtons) {
          button.update();
        }
        break;
      case 2:
      case 3:
      case 4:
        for (Button button : backToMenuButton) {
          button.update();
        }
      }
  }
}
