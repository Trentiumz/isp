/*
  Authors: Daniel Ye
 NEEDED LIBRARIES: processing.sound
 */

// Usage of State Pattern - each class represents a different state & different conditions change these global variables to other states
//   The State Pattern uses inheritance (I used abstract classes and/or interfaces)
StoryModule curStory;
State curState;
EnvironmentState curEnvironment;

int e1Points = 0;
int e2Points = 0;
int e3Points = 0;

// booleans to see if a key is pressed
boolean[] isPressed = new boolean[500];
boolean[] codePressed = new boolean[500];

SoundFile dungeonBGM;
SoundFile outdoorsBGM;
SoundFile hospitalBGM;
SoundFile guildHQBGM;
SoundFile castleBGM;
SoundFile titleBGM;
String currentMessage;

PImage zombieRight, zombieLeft;
PImage goblinRight, goblinLeft;
PImage skeletonRight, skeletonLeft;
PImage knightRight, knightLeft;
PImage wizardRight, wizardLeft;
PImage archerRight, archerLeft;
PImage dungeonWarrior;
PImage[] loadingAnimation;
PImage[] splashAnimation;
PImage[] knightDeadAnimation;

PImage dungeonDragonBoss;
PImage dungeonSnakeBossUp, dungeonSnakeBossDown;
PImage dungeonGiantBoss;
PImage dungeonDragonBossGuardMeleeRight, dungeonDragonBossGuardMeleeLeft;
PImage dungeonDragonBossGuardRangedRight, dungeonDragonBossGuardRangedLeft;
PImage dungeonSnakeBossGuardRangedRight, dungeonSnakeBossGuardRangedLeft;
PImage dungeonGiantBossGuardMeleeRight, dungeonGiantBossGuardMeleeLeft;

PImage coinsDungeonChest;
PImage dungeonGroundSprite;
PImage dungeonWallSprite;
PImage dungeonEmptySprite;
PImage dungeonWaterSprite;

PFont dungeonDragonAttackFont;

PFont mainMenuFont1, mainMenuFont2, mainMenuFont3, mainMenuFont4;
PImage mainMenuImage1, mainMenuImage2;

void setup() {
  size(1000, 800);
  currentMessage = "";
  curStory = new NoStory();
  curState = new LoadingState();

  frameRate(30);
}

void draw() {
  background(0);
  curStory.tick();
  curStory.render();
}
void mousePressed() {
  curStory.mousePressed();
}
void mouseReleased() {
  curStory.mouseReleased();
}
void keyPressed() {
  if (key < 500)
    isPressed[key] = true;
  if (keyCode < 500)
    codePressed[keyCode] = true;
  curStory.keyPressed();
}
void keyReleased() {
  if (key < 500)
    isPressed[key] = false;
  if (keyCode < 500)
    codePressed[keyCode] = false;
  curStory.keyReleased();
}
void mouseClicked() {
  curStory.mouseClicked();
}
