/*
  Authors: Daniel Ye, Pradyumn Jha, Kevin Zhan
 Teacher: Philip Guglielmi
 Description: A dungeon game
 NEEDED LIBRARIES: processing.sound, processing.video
 */
import processing.video.*;
import processing.sound.*;

/*
  Usage of State Pattern - each class represents a different state & different conditions change these global variables to other states
    The State Pattern uses inheritance (I used abstract classes and/or interfaces)
  Usage of knowledge about arraylists - the information was previously known, but most of this knowledge also comes from javadoc (https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html)  
*/

// the current state and environment
State curState;
EnvironmentState curEnvironment;

// booleans to see if a key is pressed
boolean[] isPressed = new boolean[500];
boolean[] codePressed = new boolean[500];

// background music, loaded in once
SoundFile dungeonBGM;
SoundFile outdoorsBGM;
SoundFile hospitalBGM;
SoundFile titleBGM;

// the current message to display while loading
String currentMessage;

// the sprites for the different enemies
PImage zombieRight, zombieLeft;
PImage goblinRight, goblinLeft;
PImage skeletonRight, skeletonLeft;

// the sprites for the different "classes"
PImage knightIdle, knightWalk1, knightWalk2, knightAttack;
PImage wizardIdle, wizardWalk1, wizardWalk2, wizardAttack;
PImage archerIdle, archerWalk1, archerWalk2, archerAttack;
PImage dungeonWarrior;

PImage knightIcon, archerIcon, wizardIcon;

// animations
PImage[] loadingAnimation;
PImage[] splashAnimation;
PImage[] knightDeadAnimation;
PImage[] archerDeadAnimation;
PImage[] wizardDeadAnimation;
PImage[] levelCompletedAnimation;
PImage[] dancingPugAnimation;
PImage[] wizidettePoses;
Movie fightDescription;

// the sprites for the enemies in boss dungeons
PImage dungeonDragonBoss;
PImage dungeonSnakeBossUp, dungeonSnakeBossDown;
PImage dungeonGiantBoss;
PImage dungeonDragonBossGuardMeleeRight, dungeonDragonBossGuardMeleeLeft;
PImage dungeonDragonBossGuardRangedRight, dungeonDragonBossGuardRangedLeft;
PImage dungeonSnakeBossGuardRangedRight, dungeonSnakeBossGuardRangedLeft;
PImage dungeonGiantBossGuardMeleeRight, dungeonGiantBossGuardMeleeLeft;
PImage dungeonSkeletonKnightRight, dungeonSkeletonKnightLeft;

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

// exit screen
PImage exitScreen;

// the font for the description of upgrades
PFont upgradingDescription;

// overWorld images
PImage overWorldgrass;
PImage overWorldwall1;
PImage overWorldpath;
PImage overWorldhospital;
PImage overWorldtreestump;
PImage overWorldhospitalwall;
PImage overWorldhospitaldoor;
PImage overWorldcaveentrance;
PImage overWorlddirt;
PImage overWorldhouse1;
PImage overWorldhouse2;
PImage overWorldsign1;
PImage overWorldsign2;
PImage overWorldsign3;
PImage overWorldsign4;


// default dimensions for the different players
final int knightWidth=50, knightHeight=50;
final int archerWidth=50, archerHeight=50;
final int wizardWidth=50, wizardHeight=50;

// images for the CYOA portion of the game
PImage beginCYOAImg, beginCYOAImg2, beginCYOAImg3, beginCYOAImg4, beginCYOAImg5;
PFont beginCYOAFont, beginCYOAFont2;
PImage endCYOAImg, endCYOAImg2, endCYOAImg3, endCYOAImg4;
PFont endCYOAFont;

// number of dungeons completed
int storyDungeonsCompleted;

PFont tutorialFont;

void setup() {
  // set the size
  size(1000, 800);

  // begin with loading things in
  currentMessage = "";
  curState = new LoadingState();

  // begin with 0 story dungeons done (so that we start with the first story dungeon)
  storyDungeonsCompleted = 0;

  frameRate(30);
}

void draw() {
  background(0);
  // extrapolate the behavior to the current state
  curState.tick();
  curState.render();
}

// extrapolate events to the current state
void mousePressed() {
  curState.mousePressed();
}
void mouseReleased() {
  curState.mouseReleased();
}
void keyPressed() {
  // make sure to track which keys are pressed/not pressed
  if (key < 500)
    isPressed[key] = true;
  if (keyCode < 500)
    codePressed[keyCode] = true;
  curState.keyPressed();
}
void keyReleased() {
  // updating which keys are pressed
  if (key < 500)
    isPressed[key] = false;
  if (keyCode < 500)
    codePressed[keyCode] = false;
  curState.keyReleased();
}
void mouseClicked() {
  curState.mouseClicked();
}

// THIS METHOD WAS TAKEN FROM https://processing.org/reference/libraries/video/Movie.html
// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}
