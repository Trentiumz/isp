/*
  Description: The different types of states that are common (ingame menu, main menu, etc.)
 */

// template for the current state
abstract class State {
  // render is for drawing onto the screen
  abstract void render();
  // tick is for logic updates: updating variables, calculating most of the program, continuing to the "next frame"
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

// code for handling the main menu
class MainMenuState extends State {
  // assets for the main menu
  PFont font;
  PFont font2;
  PFont font3;
  PFont font4;
  PImage img;
  PImage img2;

  // constructor - initializes variables and plays the title
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

  // starts the game
  void startGame() {
    curState = new BeginCYOAState();  
    // begin with 0 story dungeons done (so that we start with the first story dungeon)
    storyDungeonsCompleted = 0;
  }

  void setup() {
    textAlign(LEFT);
  }

  // draws the buttons for the current state
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

  // handling mouse clicked
  void mouseClicked() {
    // changing the button clicked based on the ranges in which the mouse button was clicked on
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

  // the code for the instructions page
  void instructionsPage() {
    // print out the instructions onto the page
    textFont(font4);
    textSize(18.5);
    text("Hello! Welcome to 'Climate Hunters', an action game with choices made by FornaX Fusion Ø Studios. \nThe programmers are Pradyumn J, Daniel Y, and Kevin Z. \nFor action gameplay, utilize the WASD keys to move around the maps. \nLeft click is attack #1, and right click is attack #2. Each attack has different properties. \n Press 'e' to interact with doors and other interactive objects. Press 'm' to access the in-game menu. \nThis program was built with the intent to inform regarding Global Climate Change. \nGlobal Climate Change has a myriad of detrimental effects. \nGreenhouse gas levels are at an all-time high. \nOur oceans are dying. More than 1 million species face extinction. \nDozens of species go extinct every single day. \nWe must each do our part in maintaining the sustainability of our shared planet, for generations to come. \nFor more information regarding Global Climate Change, \ncheck this website (not affiliated with FornaX Fusion Ø Studios): \nhttps://libguides.depaul.edu/c.php?g=253564&p=1690283", 39, 191);
  }

  void tick() {
  }

  // drawing onto the screen (equivalent of draw)
  void render() {
    background(#E0EEE0);

    strokeWeight(2);
    line(0, 562.5, 1000, 562.5);

    img2.resize(1000, 237);
    image(img2, 0, 563);

    drawButtons();

    // if the current page is the home page
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
    // if the current page is the instructions page
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

    // if the current page is the "game start" page (shouldn't be on the screen at all, or at most for a frame or two)
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

// the state for drawing the loading animation and for "kickstarting" loading in the images
class LoadingState extends State {
  // information on the ring animation
  final int numFrames = 30;
  int curLoadingFrame;
  final int ringWidth=180, ringHeight=180;

  // constructor
  LoadingState() {
    // start a thread to load in the files
    thread("loadFiles");
    // if we aren't done, then we begin the animation
    if (!currentMessage.equals("completed")) {
      loadingAnimation = new PImage[numFrames];
      loadFrames();
    }
    // the current loading frame
    curLoadingFrame = 0;
  }

  // load in the frames for the animation (is blocking)
  void loadFrames() {
    for (int i = 0; i < numFrames; ++i) {
      loadingAnimation[i] = loadImage("animations/loading/frame_" + formatAnimationNum(i) + "_delay-0.03s.gif");
    }
    for (int i = 0; i < numFrames; ++i) {
      loadingAnimation[i].resize(ringWidth, ringHeight);
    }
  }

  // format the animation number
  String formatAnimationNum(int frame) {
    if (frame == 0) {
      return "00";
    } else if (frame < 10) {
      return "0" + frame;
    } else {
      return "" + frame;
    }
  }

  // "logic" updating
  void tick() {
    if (currentMessage.equals("completed")) {
      curState = new SplashState();
    }
  }

  // drawing onto the screen
  void render() {
    // draw the current frame
    image(loadingAnimation[curLoadingFrame], width / 2 - ringWidth / 2, height / 2 - ringHeight / 2);
    curLoadingFrame = (curLoadingFrame + 1) % numFrames;

    // print out the message (what we're currently loading in)
    fill(#7C4400);
    textAlign(CENTER);
    text(currentMessage, width / 2, height / 2 + 100);
  }
}

// code for drawing the splash screen
class SplashState extends State {
  // the current animation frame (is float to allow for fractional slowing
  float curAnimationFrame;
  final float speed = 0.7; // speed of the animation
  SplashState() {
    curAnimationFrame = 0;
  }
  void tick() {
    // once the animation is done, we continue
    if (curAnimationFrame >= splashAnimation.length) {
      nextState();
    }
  }
  // mouse overrides allow for us to skip the splash screen as well
  void mouseClicked() {
    nextState();
  }

  // go to the next state
  void nextState() {
    curState = new MainMenuState();
  }

  // drawing onto the screen
  void render() {
    // draw the current index
    int index = (int) curAnimationFrame % splashAnimation.length;
    image(splashAnimation[index], 0, 0);
    curAnimationFrame += speed;
  }
}

// the default state, or idling state just passes on the events to the current environment
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

// screen for when a player died
class DeadScreen extends State {
  // current animation and frame
  PImage[] curAnimation;
  int curFrame;

  // what to change to after the animation
  EnvironmentState changeTo;

  DeadScreen(EnvironmentState changeTo, PlayerClass died) {
    // set the current animation & frame
    if (died == PlayerClass.Knight) {
      curAnimation = knightDeadAnimation;
    } else if (died == PlayerClass.Archer) {
      curAnimation = archerDeadAnimation;
    } else {
      curAnimation = wizardDeadAnimation;
    }
    curFrame = 0;
    this.changeTo = changeTo;
  }
  void tick() {
    // continue the frame
    curFrame++;
    // if the frame has passed the animation length, then loop it
    if (curFrame >= curAnimation.length * 2)
      curFrame = 0;
  }

  void mousePressed() {
    // continue the game once the user pressed their mouse button
    curState = new DefaultState();
    changeEnvironment(changeTo);
  }
  void render() {
    // draw the current image
    image(curAnimation[(curFrame / 2) % curAnimation.length], 0, 0);
  }
}

// ingame menu for the overworld
class OverworldMenuState extends State {
  State previous;

  // coordinates of the buttons
  float backX=400, backY=300, backW=200, backH=200;
  float menuX=420, menuY=340, menuW=100, menuH=40;
  float exitX=420, exitY=420, exitW=100, exitH=40;
  int playerImgX=510, playerImgY=350, playerImgW=100, playerImgH=100;

  PImage playerIcon; // the icon of the player

  color defaultColor = #FFA2F9; // default color of buttons
  color hoverColor = #FF006B; // color for hovering of buttons

  // constructor for initializing variables
  OverworldMenuState(State previous, PlayerInfo character) {
    this.previous = previous;

    playerIcon = getIcon(character);
    playerIcon.resize(playerImgW, playerImgH);
  }

  // whether or not the mouse is on the menu and exit button
  boolean mouseOnMenuButton() {
    return pointInBox(mouseX, mouseY, menuX, menuY, menuW, menuH);
  }
  boolean mouseOnExitButton() {
    return pointInBox(mouseX, mouseY, exitX, exitY, exitW, exitH);
  }
  void tick() {
  }

  // event handling for button presses
  void mousePressed() {
    // go back to main menu if menubutton pressed
    if (mouseOnMenuButton()) {
      curState = new MainMenuState();
      curEnvironment.exitState();
    } else if (mouseOnExitButton()) {
      // exit the game if exit button pressed
      curState = new ExitState();
      curEnvironment.exitState();
    } else if (pointDistance(mouseX, mouseY, backX + backW, backY) < 25) {
      // close the window if the "exit circle" is pressed
      curState = previous;
    }
  }

  // rendering
  void render() {
    // get the previous state to render
    previous.render();

    // draw in the background
    fill(#FFBC03);
    noStroke();
    rect(backX, backY, backW, backH, 10, 10, 10, 10);

    // set up the strokes for the buttons
    stroke(255, 0, 0);
    strokeWeight(3);
    textAlign(CENTER);
    textFont(mainMenuFont3);
    textSize(14);

    // set the color for hovering vs not hovering
    if (mouseOnMenuButton()) {
      fill(hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(menuX, menuY, menuW, menuH, 10, 10, 10, 10);
    fill(255);
    text("Main Menu", menuX + menuW / 2, menuY + menuH / 2); 

    // set the color for hovering vs not hovering
    if (mouseOnExitButton()) {
      fill(hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(exitX, exitY, exitW, exitH, 10, 10, 10, 10);
    fill(255);
    text("Exit", exitX + exitW / 2, exitY + exitH / 2);

    // draw a red circle with an X on it for the exit button
    fill(255, 0, 0);
    stroke(255);
    ellipse(backX + backW, backY, 50, 50);
    textSize(20);
    fill(255);
    text("X", backX + backW, backY + 10);

    // draw the player icon on the right
    image(playerIcon, playerImgX, playerImgY);
  }
}

// the buttons that are available to you when upgrading
enum UpgradingButton {
  noButton, health, a1, a2, speed
};
// state for when the player is upgrading
class UpgradingState extends State {
  PlayerInfo character;

  // coordinates and dimensions of the buttons
  float backX=100, backY=100, backW=800, backH=600;
  float healthX=600, healthY=600, healthW=100, healthH=50;
  float a1AtkX=160, a1AtkY=200, a1AtkW=100, a1AtkH=50;
  float a2AtkX=740, a2AtkY=200, a2AtkW=100, a2AtkH=50;
  float speedX=300, speedY=600, speedW=100, speedH=50;
  int playerX=300, playerY=180, playerW=400, playerH=400;
  PImage playerIcon;

  color defaultColor = #00D3D1; // default color of buttons
  color hoverColor = #00B4B3; // color of buttons when the mouse is hovering over it

  UpgradingButton mouseOn; // the button the mouse is on

  int upgradeCoins; // the coins needed for upgrading

  State previous;

  // constructor initializing variables
  UpgradingState(State previous, PlayerInfo character) {
    this.character = character;
    mouseOn = UpgradingButton.noButton;
    updateCost();

    this.playerIcon = getIcon(character);
    this.playerIcon.resize(playerW, playerH);

    this.previous = previous;
  }

  void tick() {
    // update the button the mouse is currently on
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
  // returns the upgrade cose
  void updateCost() {
    // cost = 10 + 20 * max(0, sum of character levels - 4)
    upgradeCoins = 10 + 20 * max(0, (character.healthLevel + character.a1AtkLevel + character.a2AtkLevel + character.speedLevel - 4));
  }
  void mousePressed() {
    // update the cost
    updateCost();

    // calculate the maximum level
    int maxLevel = storyDungeonsCompleted + 1;

    // handling the events for various buttons (for most of the buttons, they will upgrade the player and multiply his/her statistics before reducing the coins and increasing the level)
    if (pointDistance(mouseX, mouseY, backX + backW, backY) < 25) {
      curState = previous;
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
    // update the cost of the 
    updateCost();
  }
  // drawing onto the screen
  void render() {
    // draw the current environment
    curEnvironment.render();
    // draw the back of the menu
    fill(#FFBC03);
    noStroke();
    rect(backX, backY, backW, backH, 10, 10, 10, 10);

    // set the stroke and the current color
    fill(defaultColor);
    stroke(0, 0, 255);
    strokeWeight(3);

    // draw the health button
    if (mouseOn == UpgradingButton.health) {
      fill(hoverColor);
    }
    rect(healthX, healthY, healthW, healthH, 10, 10, 10, 10);

    // draw the upgrade atk 1 button
    fill(defaultColor);
    if (mouseOn == UpgradingButton.a1) {
      fill(hoverColor);
    }
    rect(a1AtkX, a1AtkY, a1AtkW, a1AtkH, 10, 10, 10, 10);

    // draw the upgrade atk 2 button
    fill(defaultColor);
    if (mouseOn == UpgradingButton.a2) {
      fill(hoverColor);
    }
    rect(a2AtkX, a2AtkY, a2AtkW, a2AtkH, 10, 10, 10, 10);

    // draw the upgrade speed button
    fill(defaultColor);
    if (mouseOn == UpgradingButton.speed) {
      fill(hoverColor);
    }
    rect(speedX, speedY, speedW, speedH, 10, 10, 10, 10);

    // draw in the descriptions for each of the buttons
    fill(0);
    textFont(upgradingDescription);
    textSize(12);
    textAlign(CENTER);
    text("Health: L" + character.healthLevel, healthX + healthW / 2, healthY + healthH + 14);
    text("Attack 1 Damage: L" + character.a1AtkLevel, a1AtkX + a1AtkW / 2, a1AtkY + a1AtkH + 14);
    text("Attack 2 Damage: L" + character.a2AtkLevel, a2AtkX + a2AtkW / 2, a2AtkY + a2AtkH + 14);
    text("Speed: L" + character.speedLevel, speedX + speedW / 2, speedY + speedH + 14);

    textSize(18);
    // draw the coins that the character has as well as the cost of the current upgrade
    text("Coins: " + character.coins, 800, 650);
    text("Cost: " + upgradeCoins, 500, 125);

    // draw the button for exiting the menu
    fill(255, 0, 0);
    stroke(255);
    ellipse(backX + backW, backY, 50, 50);
    textSize(20);
    fill(255);
    text("X", backX + backW, backY + 10);

    // the the icon of the player
    image(playerIcon, playerX, playerY);

    // draw in the maximum level for each upgrade
    textFont(upgradingDescription);
    textSize(18);
    textAlign(CENTER);
    fill(0);
    int maxLevel = storyDungeonsCompleted + 1;
    text("Max Level: " + maxLevel, 300, 125);
  }
}

// state for the ingame menu in a dungeon
class DungeonMenuState extends State {
  State previous;
  DungeonState dungeonEnvironment;

  // the positions and dimensions of various buttons
  float backX=400, backY=300, backW=200, backH=280;
  float menuX=420, menuY=340, menuW=100, menuH=40;
  float exitX=420, exitY=420, exitW=100, exitH=40;
  float hardExitX=420, hardExitY=500, hardExitW=100, hardExitH=40;

  // the position of the player icon
  int playerImgX=510, playerImgY=390, playerImgW=100, playerImgH=100;
  PImage playerIcon;

  // the colors for the buttons when hovered/by default
  color defaultColor = #FFA2F9;
  color hoverColor = #FF006B;

  // constructor initializing variables
  DungeonMenuState(State previous, DungeonState dungeonEnvironment, PlayerInfo character) {
    this.previous = previous;
    this.dungeonEnvironment = dungeonEnvironment;

    playerIcon = getIcon(character);
    playerIcon.resize(playerImgW, playerImgH);
  }
  // booleans for if each button was clicked
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

  // handling event for when mouse is pressed
  void mousePressed() {
    // handling events for each of the 3 types of buttons
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
      // handling for when the player wants to exit the menu
      curState = previous;
    }
  }

  // drawing onto the screen
  void render() {
    // get the previous state to draw first
    previous.render();

    // draw in the background
    fill(#FFBC03);
    noStroke();
    rect(backX, backY, backW, backH, 10, 10, 10, 10);

    // draw the player icon
    image(playerIcon, playerImgX, playerImgY);

    // set up the default colors and fonts
    stroke(255, 0, 0);
    strokeWeight(3);
    textAlign(CENTER);
    textFont(mainMenuFont3);
    textSize(12);

    // draw in the main menu button
    if (mouseOnMenuButton()) {
      fill(hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(menuX, menuY, menuW, menuH, 10, 10, 10, 10);
    fill(255);
    text("Main Menu", menuX + menuW / 2, menuY + menuH / 2); 

    // draw the exit dungeon button
    if (mouseOnExitButton()) {
      fill(hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(exitX, exitY, exitW, exitH, 10, 10, 10, 10);
    fill(255);
    text("Exit Dungeon", exitX + exitW / 2, exitY + exitH / 2);

    // draw the exit game button
    if (mouseOnHardExitButton()) {
      fill(hoverColor);
    } else {
      fill(defaultColor);
    }
    rect(hardExitX, hardExitY, hardExitW, hardExitH, 10, 10, 10, 10);
    fill(255);
    text("Exit Game", hardExitX + hardExitW / 2, hardExitY + hardExitH / 2);

    // draw the button to exit the menu
    fill(255, 0, 0);
    stroke(255);
    ellipse(backX + backW, backY, 50, 50);
    textSize(20);
    fill(255);
    text("X", backX + backW, backY + 10);
  }
}

// the state just before the program exits
class ExitState extends State {
  // current frame in the animation
  int curFrame;
  final int framesExist = 30;
  ExitState() {
    curFrame = 0;
  }
  void tick() {
    // once we get past the final frame to exist, we exit the program
    if (curFrame > framesExist) {
      exit();
    }
    curFrame++;
  }
  void render() {
    // draw the screen
    image(exitScreen, 0, 0);
  }
}

// state for when the player should choose the class
class ClassChoiceState extends State {
  // position of the background
  float backX=250, backY=300, backW=500, backH=280;

  // position of the buttons for the different classes
  final static int knightX=300, knightY=340, knightW=100, knightH=200;
  final static int archerX=450, archerY=340, archerW=100, archerH=200;
  final static int wizardX=600, wizardY=340, wizardW=100, wizardH=200;

  // position of the images for the different classes
  final static int knightImgX=250, knightImgY=340, knightImgW=200, knightImgH=200;
  final static int archerImgX=400, archerImgY=340, archerImgW=200, archerImgH=200;
  final static int wizardImgX=550, wizardImgY=340, wizardImgW=200, wizardImgH=200;

  // image for each of the classes
  PImage knight, wizard, archer;

  ClassChoiceState() {
    // initialize and resize images
    this.knight = getIcon(PlayerClass.Knight);
    this.wizard = getIcon(PlayerClass.Wizard);
    this.archer = getIcon(PlayerClass.Archer);

    this.knight.resize(knightImgW, knightImgH);
    this.archer.resize(archerImgW, archerImgH);
    this.wizard.resize(wizardImgW, wizardImgH);
  }

  // whether the mouse is on each "class button"
  boolean knightPressed() {
    return pointInBox(mouseX, mouseY, knightX, knightY, knightW, knightH);
  }
  boolean archerPressed() {
    return pointInBox(mouseX, mouseY, archerX, archerY, archerW, archerH);
  }
  boolean wizardPressed() {
    return pointInBox(mouseX, mouseY, wizardX, wizardY, wizardW, wizardH);
  }

  // start the game (when a class has been chosen)
  void startGame(PlayerInfo player) {
    curState = new TutorialState(player);
    titleBGM.stop();
  }
  void tick() {
  }

  // when a mouse is pressed
  void mousePressed() {
    // handle starting the game for when each of the classes have been clicked
    if (knightPressed()) {
      startGame(getStartingStats(PlayerClass.Knight));
    } else if (archerPressed()) {
      startGame(getStartingStats(PlayerClass.Archer));
    } else if (wizardPressed()) {
      startGame(getStartingStats(PlayerClass.Wizard));
    }
  }
  // drawing onto the screen
  void render() {
    // draw the background and the classes
    fill(#00B0FF);
    rect(backX, backY, backW, backH, 10, 10, 10, 10);
    image(knight, knightImgX, knightImgY);
    image(archer, archerImgX, archerImgY);
    image(wizard, wizardImgX, wizardImgY);

    // prompt the player to choose a class
    fill(255);
    textFont(mainMenuFont3);
    textAlign(CENTER);
    textSize(24);
    text("Choose your class!", backX + backW / 2, backY + 30);

    // tells the player what each class is
    textFont(mainMenuFont1);
    fill(255, 0, 0);
    textSize(20);
    text("Knight", knightX + knightW / 2, knightY + knightH + 20);
    text("Archer", archerX + archerW / 2, archerY + archerH + 20);
    text("Wizard", wizardX + wizardW / 2, wizardY + wizardH + 20);
  }
}

// state for playing the animation when a level is complete
class LevelCompletedState extends State {
  DungeonState previous;  // the dungeon state that was completed
  int curFrame; // current frame of the animation

  // constructor initializing variables
  LevelCompletedState(DungeonState previous) {
    this.previous = previous;
    curFrame = 0;
  }

  // method to continue the game
  void nextState() {
    previous.dungeonExited();
    curState = new DefaultState();
  }

  void tick() {
    // go to the next frame in the animation
    curFrame++;
    // once the animation is done, go to the next state
    if (curFrame >= levelCompletedAnimation.length) {
      nextState();
    }
  }

  // event handling for when the mouse is pressed
  void mousePressed() {
    nextState();
  }
  // draw the current frame
  void render() {
    image(levelCompletedAnimation[curFrame % levelCompletedAnimation.length], 0, 0);
  }
}

// the description of the fight after the cyoa
class FightDescriptionState extends State {
  Movie video;
  FightDescriptionState() {
    this.video = fightDescription;
    // play the video
    video.play();
  }
  void tick() {
    // if the difference between the current time and the duration is less that 0.2 seconds, then we know it has completed
    if (abs(video.time() - video.duration()) < 0.2) {
      nextState();
    }
  }
  void mousePressed() {
    // when mouse pressed, skip the cutscene
    nextState();
  }
  // get the player to choose their class
  void nextState() {
    if (video.time() > 1) {
      video.stop();
      curState = new ClassChoiceState();
    }
  }
  void render() {
    // draw the current frame
    pushMatrix();
    scale(1000.0 / 640, 800.0 / 480);
    image(fightDescription, 0, 0);
    popMatrix();
  }
}
