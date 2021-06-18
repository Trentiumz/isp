abstract class State {
  abstract void render();
  abstract void tick();
  void setup() {
  }
  void mousePressed() {
  }
  void mouseReleased() {
  }
  void keyPressed() {
  }
  void keyReleased() {
  }
  void mouseClicked() {
  }
}

class MainMenuState extends State {
  PFont font;
  PFont font2;
  PFont font3;
  PFont font4;
  PImage img;
  PImage img2;

  MainMenuState() {
    font = mainMenuFont1;
    font2 = mainMenuFont2;
    font3 = mainMenuFont3;
    font4 = mainMenuFont4;
    img = mainMenuImage1;
    img2 = mainMenuImage2;

    titleBGM.loop();
    setup();
  }
  String button = "homePage";

  void startGame() {
    curState = new ClassChoiceState();
  }

  void setup() {
    textAlign(LEFT);
  }

  void drawButtons() {
    stroke(0);
    strokeWeight(2);
    fill(#999553);
    rect(139, 647, 290, 75);

    textFont(font);
    fill(#999553);
    rect(577, 647, 290, 75);

    fill(0);
    textSize(40);
    text("Instructions", 155, 697);

    text("Start Game", 597, 697);

    strokeWeight(1);
    stroke(0);
    fill(#ffffff, 200);
    rect(0, 0, 100, 25);

    textFont(font3);
    fill(#000000);
    textSize (16);
    text("Main Menu", 7, 20);
  }

  void mouseClicked() {

    if (mouseX > 139 && mouseX < 429 && mouseY > 647 && mouseY < 722) {
      button = "instructions";
    }
    if (mouseX > 577 && mouseX < 867 && mouseY > 647 && mouseY < 722) {
      button = "gameStart";
    }
    if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 25) {
      button = "homePage";
    }
  }

  void instructionsPage() { 
    textFont(font4);
    textSize(18.5);
    text("Hello! Welcome to 'Climate Hunters', an action game with choices made by FornaX Fusion Ø Studios. \nThe programmers are Pradyumn J, Daniel Y, and Kevin Z. \nFor action gameplay, utilize the WASD keys to move around the maps. \nLeft click is attack #1, and right click is attack #2. Each attack has different properties. \nAdditionally, there will be an in-game training section, so you can practice there. \nThis program was built with the intent to inform regarding Global Climate Change. \nGlobal Climate Change has a myriad of detrimental effects. \nGreenhouse gas levels are at an all-time high. \nOur oceans are dying. More than 1 million species face extinction. \nDozens of species go extinct every single day. \nWe must each do our part in maintaining the sustainability of our shared planet, for generations to come. \nFor more information regarding Global Climate Change, \ncheck this website (not affiliated with FornaX Fusion Ø Studios): \nhttps://libguides.depaul.edu/c.php?g=253564&p=1690283", 39, 191);
  }

  void tick() {
  }

  void render() {
    background(#E0EEE0);

    strokeWeight(2);
    line(0, 562.5, 1000, 562.5);

    img2.resize(1000, 237);
    image(img2, 0, 563);

    drawButtons();

    if (button == "homePage") {
      img.resize(1000, 563);
      image(img, 0, 0);

      strokeWeight(1);
      stroke(0);
      fill(#ffffff, 200);
      rect(0, 0, 100, 25);
      fill(#000000);
      textFont(font3);
      textSize(16);
      text("Main Menu", 7, 20);

      fill(#c3b091, 150);
      rect(233, 150, 541, 56);
      textFont(font);
      textSize(60);
      fill(#ffffff);
      text("Climate Hunters", 244, 200);
    } 
    if (button == "instructions") {
      strokeWeight(3);
      stroke(#000080);
      fill(#96CDCD, 150);
      rect(31, 167, 952, 311);

      strokeWeight(3);
      stroke(#000080);
      fill(#add8e6);
      rect(0, 61, 1000, 57);
      textFont(font2);
      textSize(60);
      fill(0);
      text("Instructions", 301, 112);

      instructionsPage();
    } 
    if (button == "gameStart") {
      strokeWeight(3);
      stroke(#000080);
      fill(#add8e6);
      rect(0, 61, 1000, 57);
      textFont(font2);
      textSize(60);
      fill(0);
      text("Commencing the Game", 122, 112);
      startGame();
    }
  }
}

class LoadingState extends State {
  final int numFrames = 30;
  int curLoadingFrame;
  final int ringWidth=180, ringHeight=180;

  LoadingState() {
    thread("loadFiles");
    if (!currentMessage.equals("completed")) {
      loadingAnimation = new PImage[numFrames];
      loadFrames();
    }
    curLoadingFrame = 0;
  }

  void loadFrames() {
    for (int i = 0; i < numFrames; ++i) {
      loadingAnimation[i] = loadImage("animations/loading/frame_" + formatAnimationNum(i) + "_delay-0.03s.gif");
    }
    for (int i = 0; i < numFrames; ++i) {
      loadingAnimation[i].resize(ringWidth, ringHeight);
    }
  }

  String formatAnimationNum(int frame) {
    if (frame == 0) {
      return "00";
    } else if (frame < 10) {
      return "0" + frame;
    } else {
      return "" + frame;
    }
  }
  void tick() {
    if (currentMessage.equals("completed")) {
      curState = new SplashState();
    }
  }
  void render() {
    image(loadingAnimation[curLoadingFrame], width / 2 - ringWidth / 2, height / 2 - ringHeight / 2);
    curLoadingFrame = (curLoadingFrame + 1) % numFrames;
    fill(#7C4400);
    textAlign(CENTER);
    text(currentMessage, width / 2, height / 2 + 100);
  }
}

class SplashState extends State {
  float curAnimationFrame;

  final float speed = 0.7;
  SplashState() {
    curAnimationFrame = 0;
  }
  void tick() {
    if (curAnimationFrame >= splashAnimation.length) {
      nextState();
    }
  }
  void mouseClicked() {
    nextState();
  }
  void nextState() {
    curState = new MainMenuState();
  }

  void render() {
    int index = (int) curAnimationFrame % splashAnimation.length;
    image(splashAnimation[index], 0, 0);
    curAnimationFrame += speed;
  }
}

class DefaultState extends State {
  void tick() {
    curEnvironment.tick();
  }
  void render() {
    curEnvironment.render();
  }
  void mousePressed() {
    curEnvironment.mousePressed();
  }
  void mouseReleased() {
    curEnvironment.mouseReleased();
  }
  void keyPressed() {
    curEnvironment.keyPressed();
  }
  void keyReleased() {
    curEnvironment.keyReleased();
  }
  void mouseClicked() {
    curEnvironment.mouseClicked();
  }
}

class DeadScreen extends State {
  PImage[] curAnimation;
  int curFrame;

  DeadScreen(PlayerClass died) {

    curAnimation = knightDeadAnimation;
    curFrame = 0;
  }
  void tick() {
    curFrame++;
    if (curFrame >= curAnimation.length * 2)
      curFrame = 0;
  }
  void mousePressed() {
    curState = new DefaultState();
  }
  void render() {
    image(curAnimation[(curFrame / 2) % curAnimation.length], 0, 0);
  }
}

enum UpgradingButton {
  noButton, health, a1, a2, speed
};

class OverworldMenuState extends State {
  State previous;

  float backX=400, backY=300, backW=200, backH=200;
  float menuX=420, menuY=340, menuW=100, menuH=40;
  float exitX=420, exitY=420, exitW=100, exitH=40;
  int playerImgX=510, playerImgY=350, playerImgW=100, playerImgH=100;

  PImage playerIcon;

  color defaultColor = #FFA2F9;
  color hoverColor = #FF006B;
  OverworldMenuState(State previous, PlayerInfo character) {
    this.previous = previous;

    playerIcon = getIcon(character);
    playerIcon.resize(playerImgW, playerImgH);
  }
  boolean mouseOnMenuButton() {
    return pointInBox(mouseX, mouseY, menuX, menuY, menuW, menuH);
  }
  boolean mouseOnExitButton() {
    return pointInBox(mouseX, mouseY, exitX, exitY, exitW, exitH);
  }
  void tick() {
  }
  void mousePressed() {
    if (mouseOnMenuButton()) {
      curState = new MainMenuState();
      curEnvironment.exitState();
    } else if (mouseOnExitButton()) {
      curState = new ExitState();
      curEnvironment.exitState();
    } else if (pointDistance(mouseX, mouseY, backX + backW, backY) < 25) {
      curState = previous;
    }
  }
  void render() {
    previous.render();

    fill(#FFBC03);
    noStroke();
    rect(backX, backY, backW, backH, 10, 10, 10, 10);

    stroke(255, 0, 0);
    strokeWeight(3);
    textAlign(CENTER);
    textFont(mainMenuFont3);
    textSize(14);

    if (mouseOnMenuButton()) {
      fill(hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(menuX, menuY, menuW, menuH, 10, 10, 10, 10);
    fill(255);
    text("Main Menu", menuX + menuW / 2, menuY + menuH / 2); 

    if (mouseOnExitButton()) {
      fill(hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(exitX, exitY, exitW, exitH, 10, 10, 10, 10);
    fill(255);
    text("Exit", exitX + exitW / 2, exitY + exitH / 2);

    fill(255, 0, 0);
    stroke(255);
    ellipse(backX + backW, backY, 50, 50);
    textSize(20);
    fill(255);
    text("X", backX + backW, backY + 10);

    image(playerIcon, playerImgX, playerImgY);
  }
}


class UpgradingState extends State {
  PlayerInfo character;

  float backX=100, backY=100, backW=800, backH=600;
  float healthX=600, healthY=600, healthW=100, healthH=50;
  float a1AtkX=160, a1AtkY=200, a1AtkW=100, a1AtkH=50;
  float a2AtkX=740, a2AtkY=200, a2AtkW=100, a2AtkH=50;
  float speedX=300, speedY=600, speedW=100, speedH=50;
  int playerX=300, playerY=180, playerW=400, playerH=400;
  PImage playerIcon;

  color defaultColor = #03FFFD;
  color hoverColor = #00B4B3;

  UpgradingButton mouseOn;

  int upgradeCoins;

  final int maxLevel = 6;

  UpgradingState(PlayerInfo character) {
    this.character = character;
    mouseOn = UpgradingButton.noButton;
    updateCost();

    this.playerIcon = getIcon(character);
    this.playerIcon.resize(playerW, playerH);
  }
  void tick() {
    mouseOn = UpgradingButton.noButton;
    if (pointInBox(mouseX, mouseY, healthX, healthY, healthW, healthH)) {
      mouseOn = UpgradingButton.health;
    } else if (pointInBox(mouseX, mouseY, a1AtkX, a1AtkY, a1AtkW, a1AtkH)) {
      mouseOn = UpgradingButton.a1;
    } else if (pointInBox(mouseX, mouseY, a2AtkX, a2AtkY, a2AtkW, a2AtkH)) {
      mouseOn = UpgradingButton.a2;
    } else if (pointInBox(mouseX, mouseY, speedX, speedY, speedW, speedH)) {
      mouseOn = UpgradingButton.speed;
    }
  }
  void updateCost() {
    upgradeCoins = 10 + 20 * max(0, (character.healthLevel + character.a1AtkLevel + character.a2AtkLevel + character.speedLevel - 4));
  }
  void mousePressed() {
    updateCost();
    if (pointDistance(mouseX, mouseY, backX + backW, backY) < 25) {
      curState = new DefaultState();
    } else if (mouseOn == UpgradingButton.health) {
      if (character.coins >= upgradeCoins && character.healthLevel < maxLevel) {
        character.maxHealth *= 1.9;
        character.health = character.maxHealth;
        character.coins -= upgradeCoins;
        character.healthLevel++;
      }
    } else if (mouseOn == UpgradingButton.a1) {
      if (character.coins >= upgradeCoins && character.a1AtkLevel < maxLevel) {
        character.baseA1Attack *= 1.8;
        character.coins -= upgradeCoins;
        character.a1AtkLevel++;
      }
    } else if (mouseOn == UpgradingButton.a2) {
      if (character.coins >= upgradeCoins && character.a2AtkLevel < maxLevel) {
        character.baseA2Attack *= 1.6;
        character.coins -= upgradeCoins;
        character.a2AtkLevel++;
      }
    } else if (mouseOn == UpgradingButton.speed) {
      if (character.coins >= upgradeCoins && character.speedLevel < maxLevel) {
        character.speed *= 1.3;
        character.coins -= upgradeCoins;
        character.speedLevel++;
      }
    }
    updateCost();
  }
  void render() {
    curEnvironment.render();
    fill(#FFBC03);
    noStroke();
    rect(backX, backY, backW, backH, 10, 10, 10, 10);

    fill(defaultColor);
    stroke(0, 0, 255);
    strokeWeight(3);

    if (mouseOn == UpgradingButton.health) {
      fill(hoverColor);
    }
    rect(healthX, healthY, healthW, healthH, 10, 10, 10, 10);

    fill(defaultColor);
    if (mouseOn == UpgradingButton.a1) {
      fill(hoverColor);
    }
    rect(a1AtkX, a1AtkY, a1AtkW, a1AtkH, 10, 10, 10, 10);

    fill(defaultColor);
    if (mouseOn == UpgradingButton.a2) {
      fill(hoverColor);
    }
    rect(a2AtkX, a2AtkY, a2AtkW, a2AtkH, 10, 10, 10, 10);

    fill(defaultColor);
    if (mouseOn == UpgradingButton.speed) {
      fill(hoverColor);
    }
    rect(speedX, speedY, speedW, speedH, 10, 10, 10, 10);

    fill(0);
    textFont(upgradingDescription);
    textSize(12);
    textAlign(CENTER);
    text("Health: L" + character.healthLevel, healthX + healthW / 2, healthY + healthH + 14);
    text("Attack 1 Damage: L" + character.a1AtkLevel, a1AtkX + a1AtkW / 2, a1AtkY + a1AtkH + 14);
    text("Attack 2 Damage: L" + character.a2AtkLevel, a2AtkX + a2AtkW / 2, a2AtkY + a2AtkH + 14);
    text("Speed: L" + character.speedLevel, speedX + speedW / 2, speedY + speedH + 14);

    text("Coins: " + character.coins, 800, 650);
    text("Cost: " + upgradeCoins, 500, 125);

    fill(255, 0, 0);
    stroke(255);
    ellipse(backX + backW, backY, 50, 50);
    textSize(20);
    fill(255);
    text("X", backX + backW, backY + 10);

    image(playerIcon, playerX, playerY);
  }
}

class DungeonMenuState extends State {
  State previous;
  DungeonState dungeonEnvironment;

  float backX=400, backY=300, backW=200, backH=280;
  float menuX=420, menuY=340, menuW=100, menuH=40;
  float exitX=420, exitY=420, exitW=100, exitH=40;
  float hardExitX=420, hardExitY=500, hardExitW=100, hardExitH=40;

  int playerImgX=510, playerImgY=390, playerImgW=100, playerImgH=100;
  PImage playerIcon;

  color defaultColor = #FFA2F9;
  color hoverColor = #FF006B;
  DungeonMenuState(State previous, DungeonState dungeonEnvironment, PlayerInfo character) {
    this.previous = previous;
    this.dungeonEnvironment = dungeonEnvironment;

    playerIcon = getIcon(character);
    playerIcon.resize(playerImgW, playerImgH);
  }
  boolean mouseOnMenuButton() {
    return pointInBox(mouseX, mouseY, menuX, menuY, menuW, menuH);
  }
  boolean mouseOnExitButton() {
    return pointInBox(mouseX, mouseY, exitX, exitY, exitW, exitH);
  }
  boolean mouseOnHardExitButton() {
    return pointInBox(mouseX, mouseY, hardExitX, hardExitY, hardExitW, hardExitH);
  }
  void tick() {
  }
  void mousePressed() {
    if (mouseOnMenuButton()) {
      curState = new MainMenuState();
      changeEnvironment(null);
    } else if (mouseOnHardExitButton()) {
      curState = new ExitState();
      changeEnvironment(null);
    } else if (mouseOnExitButton()) {
      dungeonEnvironment.dungeonExited();
      curState = previous;
    } else if (pointDistance(mouseX, mouseY, backX + backW, backY) < 25) {
      curState = previous;
    }
  }
  void render() {
    previous.render();

    fill(#FFBC03);
    noStroke();
    rect(backX, backY, backW, backH, 10, 10, 10, 10);

    image(playerIcon, playerImgX, playerImgY);

    stroke(255, 0, 0);
    strokeWeight(3);
    textAlign(CENTER);
    textFont(mainMenuFont3);
    textSize(12);

    if (mouseOnMenuButton()) {
      fill(hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(menuX, menuY, menuW, menuH, 10, 10, 10, 10);
    fill(255);
    text("Main Menu", menuX + menuW / 2, menuY + menuH / 2); 

    if (mouseOnExitButton()) {
      fill(hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(exitX, exitY, exitW, exitH, 10, 10, 10, 10);
    fill(255);
    text("Exit Dungeon", exitX + exitW / 2, exitY + exitH / 2);

    if (mouseOnHardExitButton()) {
      fill(hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(hardExitX, hardExitY, hardExitW, hardExitH, 10, 10, 10, 10);
    fill(255);
    text("Exit Game", hardExitX + hardExitW / 2, hardExitY + hardExitH / 2);

    fill(255, 0, 0);
    stroke(255);
    ellipse(backX + backW, backY, 50, 50);
    textSize(20);
    fill(255);
    text("X", backX + backW, backY + 10);
  }
}

class ExitState extends State {
  int curFrame;
  final int framesExist = 30;
  ExitState() {
    curFrame = 0;
  }
  void tick() {
    if (curFrame > framesExist) {
      exit();
    }
    curFrame++;
  }
  void render() {
    image(exitScreen, 0, 0);
  }
}

class ClassChoiceState extends State {
  float backX=250, backY=300, backW=500, backH=280;
  final static int knightX=300, knightY=340, knightW=100, knightH=200;
  final static int archerX=450, archerY=340, archerW=100, archerH=200;
  final static int wizardX=600, wizardY=340, wizardW=100, wizardH=200;

  final static int knightImgX=250, knightImgY=340, knightImgW=200, knightImgH=200;
  final static int archerImgX=400, archerImgY=340, archerImgW=200, archerImgH=200;
  final static int wizardImgX=550, wizardImgY=340, wizardImgW=200, wizardImgH=200;

  PImage knight, wizard, archer;

  ClassChoiceState() {
    this.knight = getIcon(PlayerClass.Knight);
    this.wizard = getIcon(PlayerClass.Wizard);
    this.archer = getIcon(PlayerClass.Archer);

    this.knight.resize(knightImgW, knightImgH);
    this.archer.resize(archerImgW, archerImgH);
    this.wizard.resize(wizardImgW, wizardImgH);
  }
  boolean knightPressed() {
    return pointInBox(mouseX, mouseY, knightX, knightY, knightW, knightH);
  }
  boolean archerPressed() {
    return pointInBox(mouseX, mouseY, archerX, archerY, archerW, archerH);
  }
  boolean wizardPressed() {
    return pointInBox(mouseX, mouseY, wizardX, wizardY, wizardW, wizardH);
  }
  void startGame(PlayerInfo player) {
    curEnvironment = new OverworldEnvironment(player);
    curState = new DefaultState();
    titleBGM.stop();
  }
  void tick() {
  }
  void mousePressed() {
    if (knightPressed()) {
      startGame(getStartingStats(PlayerClass.Knight));
    } else if (archerPressed()) {
      startGame(getStartingStats(PlayerClass.Archer));
    } else if (wizardPressed()) {
      startGame(getStartingStats(PlayerClass.Wizard));
    }
  }
  void render() {
    fill(#00B0FF);
    rect(backX, backY, backW, backH, 10, 10, 10, 10);
    image(knight, knightImgX, knightImgY);
    image(archer, archerImgX, archerImgY);
    image(wizard, wizardImgX, wizardImgY);

    fill(255);
    textFont(mainMenuFont3);
    textAlign(CENTER);
    textSize(24);
    text("Choose your class!", backX + backW / 2, backY + 30);

    textFont(mainMenuFont1);
    fill(255, 0, 0);
    textSize(20);
    text("Knight", knightX + knightW / 2, knightY + knightH + 20);
    text("Archer", archerX + archerW / 2, archerY + archerH + 20);
    text("Wizard", wizardX + wizardW / 2, wizardY + wizardH + 20);
  }
}
