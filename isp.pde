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

void loadFiles(){
  currentMessage = "Loading dungeon.wav...";
  dungeonBGM = getTrack("music/dungeon.wav");
  
  currentMessage = "Loading outdoors.wav...";
  outdoorsBGM = getTrack("music/outdoors.wav");
  
  currentMessage = "Loading hospital.wav...";
  hospitalBGM = getTrack("music/hospital.wav");
  
  currentMessage = "Loading guild_hq.wav...";
  guildHQBGM = getTrack("music/guild_hq.wav");
  
  currentMessage = "Loading castle.wav...";
  castleBGM = getTrack("music/castle.wav");
  
  currentMessage = "Loading title.wav...";
  titleBGM = getTrack("music/title.wav");
  
  currentMessage = "Loading dungeon enemy sprites...";
  zombieRight = loadImage("sprites/dungeon/zombie_right.png");
  zombieLeft = loadImage("sprites/dungeon/zombie_left.png");
  goblinRight = loadImage("sprites/dungeon/goblin_right.png");
  goblinLeft = loadImage("sprites/dungeon/goblin_left.png");
  skeletonRight = loadImage("sprites/dungeon/skeleton_right.png");
  skeletonLeft = loadImage("sprites/dungeon/skeleton_left.png");
  
  currentMessage = "Loading player sprites...";
  knightRight = loadImage("sprites/knight_right.png");
  knightLeft = loadImage("sprites/knight_left.png");
  wizardRight = loadImage("sprites/wizard_right.png");
  wizardLeft = loadImage("sprites/wizard_left.png");
  archerRight = loadImage("sprites/archer_right.png");
  archerLeft = loadImage("sprites/archer_left.png");
  
  currentMessage = "completed";
}

void setup() {
  size(800, 600);
  curStory = new NoStory();
  curState = new LoadingState();
  currentMessage = "";
  
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
