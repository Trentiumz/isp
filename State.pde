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
    PlayerInfo samplePlayer = getStartingStats(PlayerClass.Knight);
    curEnvironment = new CoinsDungeon(null, samplePlayer);
    curState = new DefaultState();
    titleBGM.stop();
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

class EndGameState extends State {
  void tick() {
  }
  void render() {
  }
}

class CreditsState extends State {
  void tick() {
  }
  void render() {
  }
}

class InventoryState extends State {
  State previous;
  void tick() {
  }
  void render() {
  }
  void exitInventory() {
    curState = previous;
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
  int curAnimationFrame;

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
    int index = curAnimationFrame % splashAnimation.length;
    image(splashAnimation[index], 0, 0);
    curAnimationFrame += 1;
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
    if (died == PlayerClass.Knight) {
      curAnimation = knightDeadAnimation;
    }
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

class UpgradingState extends State {
  PlayerInfo character;

  float backX=100, backY=100, backW=800, backH=600;
  float healthX=450, healthY=600, healthW=100, healthH=50;
  float a1AtkX=160, a1AtkY=130, a1AtkW=100, a1AtkH=50;
  float a2AtkX=740, a2AtkY=130, a2AtkW=100, a2AtkH=50;
  float a1SpeedX=160, a1SpeedY=400, a1SpeedW=100, a1SpeedH=50;
  float a2SpeedX=740, a2SpeedY=400, a2SpeedW=100, a2SpeedH=50;

  int upgradeCoins = 30;

  UpgradingState(PlayerInfo character) {
    this.character = character;
  }
  void tick() {
  }
  void mousePressed() {
    if (pointDistance(mouseX, mouseY, backX + backW, backY) < 50) {
      curState = new DefaultState();
    } else if (pointInBox(mouseX, mouseY, healthX, healthY, healthW, healthH)) {
      if (character.coins >= upgradeCoins) {
        character.health *= 1.3;
        character.coins -= upgradeCoins;
      }
    } else if (pointInBox(mouseX, mouseY, a1AtkX, a1AtkY, a1AtkW, a1AtkH)) {
      if (character.coins >= upgradeCoins) {
        character.baseA1Attack *= 1.5;
        character.coins -= upgradeCoins;
      }
    } else if (pointInBox(mouseX, mouseY, a2AtkX, a2AtkY, a2AtkW, a2AtkH)) {
      if (character.coins >= upgradeCoins) {
        character.baseA2Attack *= 1.5;
        character.coins -= upgradeCoins;
      }
    } else if (pointInBox(mouseX, mouseY, a1SpeedX, a1SpeedY, a1SpeedW, a1SpeedH)) {
      if (character.coins >= upgradeCoins && character.framesBetweenA1 > 0) {
        character.framesBetweenA1 = max(0, min(character.framesBetweenA1 - 1, (int) (character.framesBetweenA1 * 0.8)));
        character.coins -= upgradeCoins;
      }
    } else if (pointInBox(mouseX, mouseY, a2SpeedX, a2SpeedY, a2SpeedW, a2SpeedH)) {
      if (character.coins >= upgradeCoins && character.framesBetweenA2 > 0) {
        character.framesBetweenA2 = max(0, min(character.framesBetweenA2 - 1, (int) (character.framesBetweenA2 * 0.8)));
        character.coins -= upgradeCoins;
      }
    }
  }
  void render() {
    curEnvironment.render();
    fill(#FFBC03);
    noStroke();
    rect(backX, backY, backW, backH, 10, 10, 10, 10);

    fill(0, 0, 255);
    stroke(255);
    strokeWeight(3);
    rect(healthX, healthY, healthW, healthH, 10, 10, 10, 10);
    rect(a1AtkX, a1AtkY, a1AtkW, a1AtkH, 10, 10, 10, 10);
    rect(a2AtkX, a2AtkY, a2AtkW, a2AtkH, 10, 10, 10, 10);
    rect(a1SpeedX, a1SpeedY, a1SpeedW, a1SpeedH, 10, 10, 10, 10);
    rect(a2SpeedX, a2SpeedY, a2SpeedW, a2SpeedH, 10, 10, 10, 10);

    fill(0);
    textFont(upgradingDescription);
    textSize(12);
    textAlign(CENTER);
    text("Health: " + character.health, healthX + healthW / 2, healthY + healthH + 14);
    text("Attack 1 Damage: " + (int) character.baseA1Attack, a1AtkX + a1AtkW / 2, a1AtkY + a1AtkH + 14);
    text("Attack 2 Damage: " + (int) character.baseA2Attack, a2AtkX + a2AtkW / 2, a2AtkY + a2AtkH + 14);
    text("Attack 1 Interval: " + (int) character.framesBetweenA1, a1SpeedX + a2SpeedW / 2, a1SpeedY + a1SpeedH + 14);
    text("Attack 2 Interval: " + (int) character.framesBetweenA2, a2SpeedX + a2SpeedW / 2, a2SpeedY + a2SpeedH + 14);

    text("Coins: " + character.coins, 800, 650);

    fill(255, 0, 0);
    ellipse(backX + backW, backY, 50, 50);
    textSize(20);
    fill(255);
    text("X", backX + backW, backY + 10);
  }
}
