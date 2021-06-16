import processing.sound.*;
// returns whether or not a box defined by (x1, y1, w1, h1) is touching the box defined by (x2, y2, w2, h2)
boolean boxCollided(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  return x1 + w1 > x2 && x1 < x2 + w2 && y1 + h1 > y2 && y1 < y2 + h2;
}

// returns whether or not the line segment (x1, y1)-(x1, y2) touches the line segment (sx2, sy2)-(ex2, ey2)
boolean lineIntersectsVertical(float x1, float y1, float y2, float sx2, float sy2, float ex2, float ey2) {
  // if the two slopes are equal, then they touch only if they have the same x value
  if (ex2==sx2) {
    return sx2 == x1;
  }

  // get the slope and intersect of the second line
  float l2slope = (ey2 - sy2)/(ex2-sx2);
  float l2intersect = sy2 - l2slope * sx2;

  // get the intersection point of the two lines
  float yAtIntersect = l2slope * x1 + l2intersect;

  // return if the intersection point is "inside" both of the line segments
  return sx2 < x1 && x1 < ex2 && y1 < yAtIntersect && yAtIntersect < y2;
}

// returns if the line segment defined by (sx1, sy1)-(ex1, ey1) intersects with the line defined by (sx2, sy2)-(ex2, ey2)
boolean lineIntersects(float sx1, float sy1, float ex1, float ey1, float sx2, float sy2, float ex2, float ey2) {
  // if sx1 is the same as ex1, then the first line is vertical
  if (sx1 == ex1)
    return lineIntersectsVertical(sx1, sy1, ey1, sx2, sy2, ex2, ey2);
  // if sx2 = ex2, then the second line is vertical
  if (sx2 == ex2)
    return lineIntersectsVertical(sx2, sy2, ey2, sx1, sy1, ex1, ey1);

  // get the slope and intersects of both line (to define them as an equation)
  float l1slope = (ey1-sy1)/(ex1-sx1);
  float l2slope = (ey2-sy2)/(ex2-sx2);
  float l1intersect = sy1 - l1slope * sx1;
  float l2intersect = sy2 - l2slope * sx2;

  // if the two slopes are equal, then they are parallel. They are equal if and only if they have a common point at x=0
  if (l1slope == l2slope)
    return l1intersect == l2intersect;

  // a formula for calculating the y coordinate of the intersect of the two lines 
  float intersectY = (l1intersect*l2slope-l2intersect*l1slope)/(l2slope-l1slope);
  float intersectX;
  if (l1slope != 0) {
    // if the first line does not have a slope of 0, then we can solve for the intersection point of the x coordinate
    intersectX = (intersectY - l1intersect) / l1slope;
  } else {
    // if the x coordinate is 0, then we can just use the second slope to calculate the intersection point (note that they can't both be equal to 0 since we checked for equality earlier)
    intersectX = (intersectY - l2intersect) / l2slope;
  }

  // we return if the intersection point is "inside" both of the lines
  return (sy1 < intersectY) == (intersectY < ey1) && (sy2 < intersectY) == (intersectY < ey2) && (sx1 < intersectX) == (intersectX < ex1) && (sx2 < intersectX) == (intersectX < ex2);
}

// returns the distance from (x1,y1) to (x2, y2)
float pointDistance(float x1, float y1, float x2, float y2) {
  return magnitude(x2 - x1, y2 - y1);
}

// returns the clockwise angle of the vector defined by (x,y) from the vector in the direction "right"
float angleOf(float x, float y) {
  if (x > 0)
    return asin(y / sqrt(pow(x, 2) + pow(y, 2)));
  else
    return PI - asin(y / sqrt(pow(x, 2) + pow(y, 2)));
}

// gets the track (usually sound effects or music) at filePath
SoundFile getTrack(String filePath) {
  return new SoundFile(this, filePath);
}

// returns the magnitude of the vector (x,y)
float magnitude (float x, float y) {
  return sqrt(pow(x, 2) + pow(y, 2));
}

// load the files
void loadFiles() {
  // load music
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

  // load enemy sprites
  currentMessage = "Loading dungeon enemy sprites...";
  zombieRight = loadImage("sprites/dungeon/zombie_right.png");
  zombieLeft = loadImage("sprites/dungeon/zombie_left.png");
  goblinRight = loadImage("sprites/dungeon/goblin_right.png");
  goblinLeft = loadImage("sprites/dungeon/goblin_left.png");
  skeletonRight = loadImage("sprites/dungeon/skeleton_right.png");
  skeletonLeft = loadImage("sprites/dungeon/skeleton_left.png");
  dungeonWarrior = loadImage("sprites/dungeon/cursedWarrior.png");

  dungeonWarrior.resize(WarriorDungeon.warriorWidth, WarriorDungeon.warriorHeight);
  goblinRight.resize(DefaultDungeon.goblinWidth, DefaultDungeon.goblinHeight);
  goblinLeft.resize(DefaultDungeon.goblinWidth, DefaultDungeon.goblinHeight);
  zombieRight.resize(DefaultDungeon.zombieWidth, DefaultDungeon.zombieHeight);
  zombieLeft.resize(DefaultDungeon.zombieWidth, DefaultDungeon.zombieHeight);
  skeletonRight.resize(DefaultDungeon.skeletonWidth, DefaultDungeon.skeletonHeight);
  skeletonLeft.resize(DefaultDungeon.skeletonWidth, DefaultDungeon.skeletonHeight);

  // loading the boss dungeon sprites
  dungeonDragonBossGuardMeleeRight = loadImage("sprites/dungeon/dragonGuardMelee_right.png");
  dungeonDragonBossGuardMeleeLeft = loadImage("sprites/dungeon/dragonGuardMelee_left.png");
  dungeonDragonBossGuardRangedLeft = loadImage("sprites/dungeon/dragonGuardRanged_left.png");
  dungeonDragonBossGuardRangedRight = loadImage("sprites/dungeon/dragonGuardRanged_right.png");
  dungeonSnakeBossGuardRangedRight = loadImage("sprites/dungeon/serpantGuard_right.png");
  dungeonSnakeBossGuardRangedLeft = loadImage("sprites/dungeon/serpantGuard_left.png");
  dungeonGiantBossGuardMeleeRight = loadImage("sprites/dungeon/giantGuardMelee_right.png");
  dungeonGiantBossGuardMeleeLeft = loadImage("sprites/dungeon/giantGuardMelee_left.png");

  dungeonGiantBossGuardMeleeRight.resize(GiantBossDungeon.giantGuardWidth, GiantBossDungeon.giantGuardHeight);
  dungeonGiantBossGuardMeleeLeft.resize(GiantBossDungeon.giantGuardWidth, GiantBossDungeon.giantGuardHeight);
  dungeonDragonBossGuardMeleeRight.resize(DragonBossDungeon.meleeWidth, DragonBossDungeon.meleeHeight);
  dungeonDragonBossGuardMeleeLeft.resize(DragonBossDungeon.meleeWidth, DragonBossDungeon.meleeHeight);
  dungeonDragonBossGuardRangedRight.resize(DragonBossDungeon.rangedWidth, DragonBossDungeon.rangedHeight);
  dungeonDragonBossGuardRangedLeft.resize(DragonBossDungeon.rangedWidth, DragonBossDungeon.rangedHeight);
  dungeonSnakeBossGuardRangedRight.resize(SerpantBossDungeon.rangedWidth, SerpantBossDungeon.rangedHeight);
  dungeonSnakeBossGuardRangedLeft.resize(SerpantBossDungeon.rangedWidth, SerpantBossDungeon.rangedHeight);

  dungeonDragonBoss = loadImage("sprites/dungeon/dragon.png");
  dungeonSnakeBossUp = loadImage("sprites/dungeon/serpant_up.png");
  dungeonSnakeBossDown = loadImage("sprites/dungeon/serpant_down.png");
  dungeonGiantBoss = loadImage("sprites/dungeon/giant.png");

  dungeonGiantBoss.resize(GiantBossDungeon.giantWidth, GiantBossDungeon.giantHeight);
  dungeonDragonBoss.resize(DragonBossDungeon.dragonWidth, DragonBossDungeon.dragonHeight);
  dungeonSnakeBossUp.resize(SerpantBossDungeon.snakeWidth, SerpantBossDungeon.snakeHeight);
  dungeonSnakeBossDown.resize(SerpantBossDungeon.snakeWidth, SerpantBossDungeon.snakeHeight);

  // load dungeon elements
  currentMessage = "Loading dungeon elements...";
  dungeonGroundSprite = loadImage("sprites/dungeon/ground.png");
  dungeonWallSprite = loadImage("sprites/dungeon/wall.png");
  dungeonEmptySprite = loadImage("sprites/dungeon/empty.png");
  coinsDungeonChest = loadImage("sprites/dungeon/chest.png");
  dungeonWaterSprite = loadImage("sprites/dungeon/water.jpg");

  dungeonGroundSprite.resize(World.gridSize, World.gridSize);
  dungeonWallSprite.resize(World.gridSize, World.gridSize);
  dungeonEmptySprite.resize(World.gridSize, World.gridSize);
  dungeonWaterSprite.resize(World.gridSize, World.gridSize);
  coinsDungeonChest.resize(CoinsDungeon.chestWidth, CoinsDungeon.chestHeight);

  // load player sprites
  currentMessage = "Loading player sprites...";
  knightRight = loadImage("sprites/knight_right.png");
  knightLeft = loadImage("sprites/knight_left.png");
  wizardRight = loadImage("sprites/wizard_right.png");
  wizardLeft = loadImage("sprites/wizard_left.png");
  archerRight = loadImage("sprites/archer_right.png");
  archerLeft = loadImage("sprites/archer_left.png");

  knightRight.resize(DefaultDungeon.knightWidth, DefaultDungeon.knightHeight);
  knightLeft.resize(DefaultDungeon.knightWidth, DefaultDungeon.knightHeight);
  archerRight.resize(DefaultDungeon.archerWidth, DefaultDungeon.archerHeight);
  archerLeft.resize(DefaultDungeon.archerWidth, DefaultDungeon.archerHeight);
  wizardRight.resize(DefaultDungeon.wizardWidth, DefaultDungeon.wizardHeight);
  wizardLeft.resize(DefaultDungeon.wizardWidth, DefaultDungeon.wizardHeight);

  // load fonts
  currentMessage = "Loading fonts...";
  dungeonDragonAttackFont = loadFont("LucidaBright-Demi-16.vlw");
  upgradingDescription = loadFont("BookAntiqua-BoldItalic-14.vlw");

  // loading main menu elements
  currentMessage = "Loading menu...";
  mainMenuImage1 = loadImage("mainMenu/forestDungeonBackground.png");
  mainMenuImage2 = loadImage("mainMenu/buttonsBackground.jpg");
  mainMenuFont1 = loadFont("mainMenu/Algerian-48.vlw");
  mainMenuFont2 = loadFont("mainMenu/Broadway-48.vlw");
  mainMenuFont3 = loadFont("mainMenu/CourierNewPS-BoldMT-48.vlw");
  mainMenuFont4 = loadFont("mainMenu/KristenITC-Regular-48.vlw");

  // load in the splash screen
  currentMessage = "Loading splash screen...";
  int numSplashFrames = 101;
  splashAnimation = new PImage[numSplashFrames];
  for (int i = 0; i < numSplashFrames; ++i) {
    String sNum = numTo3Characters(i + 1);
    splashAnimation[i] = loadImage("animations/splash/ezgif-frame-" + sNum + ".png");
    splashAnimation[i].resize(width, height);
  }

  // load in death animations
  currentMessage = "loading death animations..";
  loadDeathAnimations();

  // it is completed... this is also used for the loading state to know that we can progress to progress
  currentMessage = "completed";
}

void loadDeathAnimations() {
  int numKnightFrames = 56;
  knightDeadAnimation = new PImage[numKnightFrames];
  for (int i = 0; i < numKnightFrames; ++i) {
    String sNum = numTo2Characters(i);
    knightDeadAnimation[i] = loadImage("animations/dead/knight/frame_" + sNum + "_delay-0.1s.gif");
    knightDeadAnimation[i].resize(width, height);
  }
}

// converts a number and "buffs" it up to 2 characters - returning a string
String numTo2Characters(int num) {
  if (num < 10) {
    return "0" + num;
  } else {
    return "" + num;
  }
}

// converts a number and "buffs" it up to 3 characters - returning the string
String numTo3Characters(int num) {
  String sNum = "" + num;
  if (sNum.length() == 1) {
    sNum = "00" + sNum;
  } else if (sNum.length() == 2) {
    sNum = "0" + sNum;
  }
  return sNum;
}

// gets the starting statistics for a player of some class
PlayerInfo getStartingStats(PlayerClass chosen) {
  if (chosen == PlayerClass.Knight) {
    return new PlayerInfo(100, 7, 4, 7, 30, 3, 100, PlayerClass.Knight);
  } else if (chosen == PlayerClass.Wizard) {
    return new PlayerInfo(70, 7, 4, 30, 60, 3, 100, PlayerClass.Wizard);
  } else if (chosen == PlayerClass.Archer) {
    return new PlayerInfo(70, 7, 7, 16, 30, 5, 100, PlayerClass.Archer);
  } else {
    println("somehow the chosen class isn't a class!");
    return null;
  }
}

// returns if a point is inside a box
boolean pointInBox(float px, float py, float bx, float by, float bw, float bh){
 return bx < px && px < bx + by && by < py && py < by + bh; 
}
