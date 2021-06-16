/*
  Authors: Daniel Ye, Pradyumn Jha, Kevin Zhan
 Teacher: Philip Guglielmi
 Description: A dungeon game
 NEEDED LIBRARIES: processing.sound
 */

// Usage of State Pattern - each class represents a different state & different conditions change these global variables to other states
//   The State Pattern uses inheritance (I used abstract classes and/or interfaces)

// the current story "module", state and environment
StoryModule curStory;
State curState;
EnvironmentState curEnvironment;

// the points for ending 1
int e1Points = 0;
int e2Points = 0;
int e3Points = 0;

// booleans to see if a key is pressed
boolean[] isPressed = new boolean[500];
boolean[] codePressed = new boolean[500];

// background music, loaded in once
SoundFile dungeonBGM;
SoundFile outdoorsBGM;
SoundFile hospitalBGM;
SoundFile guildHQBGM;
SoundFile castleBGM;
SoundFile titleBGM;

// the current message to display while loading
String currentMessage;

// the sprites for the different enemies
PImage zombieRight, zombieLeft;
PImage goblinRight, goblinLeft;
PImage skeletonRight, skeletonLeft;
PImage knightRight, knightLeft;
PImage wizardRight, wizardLeft;
PImage archerRight, archerLeft;
PImage dungeonWarrior;

// animations
PImage[] loadingAnimation;
PImage[] splashAnimation;
PImage[] knightDeadAnimation;

// the sprites for the enemies in boss dungeons
PImage dungeonDragonBoss;
PImage dungeonSnakeBossUp, dungeonSnakeBossDown;
PImage dungeonGiantBoss;
PImage dungeonDragonBossGuardMeleeRight, dungeonDragonBossGuardMeleeLeft;
PImage dungeonDragonBossGuardRangedRight, dungeonDragonBossGuardRangedLeft;
PImage dungeonSnakeBossGuardRangedRight, dungeonSnakeBossGuardRangedLeft;
PImage dungeonGiantBossGuardMeleeRight, dungeonGiantBossGuardMeleeLeft;

// environmental sprites
PImage coinsDungeonChest;
PImage dungeonGroundSprite;
PImage dungeonWallSprite;
PImage dungeonEmptySprite;
PImage dungeonWaterSprite;

// font for the dragon attack indicator
PFont dungeonDragonAttackFont;

// fonts for main menu
PFont mainMenuFont1, mainMenuFont2, mainMenuFont3, mainMenuFont4;
PImage mainMenuImage1, mainMenuImage2;

PFont upgradingDescription;

void setup() {
  // set the size
  size(1000, 800);
  
  // begin with loading things in
  currentMessage = "";
  curStory = new NoStory();
  curState = new LoadingState();

  frameRate(30);
}

void draw() {
  background(0);
  // extrapolate the behavior to the current story
  curStory.tick();
  curStory.render();
}

// extrapolate events to the current story
void mousePressed() {
  curStory.mousePressed();
}
void mouseReleased() {
  curStory.mouseReleased();
}
void keyPressed() {
  // make sure to track which keys are pressed/not pressed
  if (key < 500)
    isPressed[key] = true;
  if (keyCode < 500)
    codePressed[keyCode] = true;
  curStory.keyPressed();
}
void keyReleased() {
  // updating which keys are pressed
  if (key < 500)
    isPressed[key] = false;
  if (keyCode < 500)
    codePressed[keyCode] = false;
  curStory.keyReleased();
}
void mouseClicked() {
  curStory.mouseClicked();
}
