/*
  Authors: Pradyumn Jha, Daniel Ye, Kevin Zhan
 */

// the common state for all of the dungeons
abstract class DungeonState extends EnvironmentState {
  EnvironmentState previous;
  DungeonState(EnvironmentState previous) {
    this.previous = previous;
  }
  abstract void dungeonCompleted();
  abstract void dungeonExited();
}

// the recurring dungeon for coins
class CoinsDungeon extends DefaultDungeon {
  Chest curChest = null; // the chest for extra loot
  final static int chestWidth=80, chestHeight=50; // dimensions of chest

  // overriding the behavior for when you completed a dungeon (as it isn't going to progress in the story)
  void dungeonCompleted() {
    curState = new LevelCompletedState(this);
  }

  CoinsDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }

  // tick method
  void tick() {
    super.tick();
    // if all players defeated then give the player the chest
    if (curWorld.enemies.size() == 0 && curChest == null) {
      curChest = new Chest(78*50, 8 * 50, (int) random(300, 400));
      curWorld.addEntity(curChest);
    }
  }

  void mousePressed() {
    super.mousePressed();
    // check to see if the chest was pressed
    if (curChest != null) {
      if (curChest.inRange(curWorld.camera.getRealX(mouseX), curWorld.camera.getRealY(mouseY)))
        curChest.pressed();
    }
  }

  void render() {
    super.render();
    // draw the chest onto the screen
    if (curChest != null) {
      pushMatrix();
      curWorld.camera.alterMatrix();
      curChest.render(); 
      popMatrix();
    }
  }

  void drawOverlays() {
    super.drawOverlays();
    textFont(mainMenuFont3);
    fill(255);
    textAlign(RIGHT);
    textSize(20);
    text("Coins: " + curPlayer.character.coins, width, 20);
  }

  void setup() {
    // create a new player at the spawn location
    curPlayer = getPlayerOf(60, 340, info);

    // load in the world
    curWorld = getWorldOf("dungeon_maps/coin.txt", curPlayer);
    
    // add enemies
    addEnemies();

    // start the background music
    playBackgroundMusic();
  }

  void addEnemies(){
    // in the first room, randomly add goblins at each spot
    for (int i = 360; i < 1000; i += 100) {
      for (int c = 210; c < 700; c += 100) {
        float r = random(1);
        if (r > 0.7) {
          curWorld.addEnemy(new Goblin(i, c));
        }
      }
    }

    // in the second room, randomly add goblins and zombies with higher probability
    for (int i = 29*50; i < 45*50; i += 100) {
      for (int c = 4*50; c < 12*50; c += 100) {
        float r = random(1);
        if (r > 0.4) {
          // a randomizer for what enemy to add
          float enemyRandom = random(1);
          if (enemyRandom < 0.5) {
            curWorld.addEnemy(new Goblin(i, c));
          } else {
            curWorld.addEnemy(new Zombie(i, c));
          }
        }
      }
    }

    // in the third room, randomly add enemies with highest probability
    for (int i = 53*50; i < 70*50; i += 50) {
      for (int c = 2*50; c < 15*50; c += 50) {
        float r = random(1);
        if (r > 0.6) {
          float enemyRandom = random(1);
          if (enemyRandom < 0.33) {
            curWorld.addEnemy(new Goblin(i, c));
          } else if (enemyRandom < 0.66) {
            curWorld.addEnemy(new Zombie(i, c));
          } else {
            curWorld.addEnemy(new Skeleton(i, c));
          }
        }
      }
    } 
  }

  // The chest that is used here
  class Chest extends Entity {
    int coins;
    PImage chest;

    ArrayList<Coin> animationCoins;
    final static float coinLiveDistance = 100;
    boolean clicked;
    final static int clickedAnimationFrames = 90;
    int clickedAnimationTimer;
    float coinChance = 1.0 / 6;

    Chest(float x, float y, int w, int h, int coins) {
      // initialize variables
      super(x, y, w, h);
      this.coins = coins;
      chest = coinsDungeonChest;

      animationCoins = new ArrayList<Coin>();
    }

    // another constructor giving in default values
    Chest(float x, float y, int coins) {
      this(x, y, chestWidth, chestHeight, coins);
    }

    // if pressed
    void pressed() {
      if (!clicked) {
        clicked = true;
        curPlayer.character.coins += this.coins;
        clickedAnimationTimer = clickedAnimationFrames;
      }
    }

    // draw the image onto the screen
    void render() {
      image(chest, x, y);
      textFont(mainMenuFont3);
      textSize(14);
      textAlign(LEFT);
      fill(255);
      text("Click the chest!", x, y - 14);

      if (clicked) {
        --clickedAnimationTimer;
        if (clickedAnimationTimer <= 0) {
          curWorld.removeEntity(this);
          dungeonCompleted();
        }

        ArrayList<Coin> toRemove = new ArrayList<Coin>();
        for (Coin coin : animationCoins) {
          coin.render();
          if (pointDistance(coin.x, coin.y, centerX(), centerY()) > coinLiveDistance) {
            toRemove.add(coin);
          }
        }
        for (Coin coin : toRemove) {
          animationCoins.remove(coin);
        }

        float rand = random(1);
        if (rand < coinChance) {
          float angle = random(PI * 7/6, PI * 11/6);
          animationCoins.add(new Coin(centerX(), centerY(), 3 * cos(angle), 3 * sin(angle)));
        }
      }
    }

    // coins
    class Coin {
      float x, y, xDiff, yDiff;
      Coin(float x, float y, float xDiff, float yDiff) {
        this.x = x;
        this.y = y;
        this.xDiff = xDiff;
        this.yDiff = yDiff;
      }
      void render() {
        x += xDiff;
        y += yDiff;

        fill(#FFE308);
        stroke(#FFBC00);
        strokeWeight(5);
        ellipse(x, y, 20, 20);
      }
    }
  }
}

// The maze level
class MazeDungeon extends DefaultDungeon {
  MazeDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }

  void tick() {
    super.tick();
    // if the player reaches the top, then they have reached the end of the maze
    if (curPlayer.y <= 75) {
      dungeonCompleted();
    }
  }

  void setup() {

    // create a new player at the spawn location
    curPlayer = getPlayerOf(1000, 2400, info);

    // load in the world
    curWorld = getWorldOf("dungeon_maps/l2.txt", curPlayer);
    addZombies();

    // start the background music
    playBackgroundMusic();
  }

  // add the zombies - they are positioned at various nooks and crannies of the maze
  void addZombies() {
    curWorld.addEnemy(new Zombie(22*50, 45*50, 30, 30));
    curWorld.addEnemy(new Zombie(23*50, 45*50, 30, 30));
    curWorld.addEnemy(new Zombie(24*50, 45*50, 30, 30));
    for (int i = 34; i <= 45; ++i) {
      curWorld.addEnemy(new Zombie(38 * 50, i * 50, 30, 30));
    }
    curWorld.addEnemy(new Zombie(9*50, 39*50, 30, 30));
    curWorld.addEnemy(new Zombie(530, 39*50, 30, 30));
    curWorld.addEnemy(new Zombie(560, 39*50, 30, 30));

    curWorld.addEnemy(new Zombie(33*50, 12*50, 30, 30));
    curWorld.addEnemy(new Zombie(42*50, 4*50, 30, 30));

    curWorld.addEnemy(new Zombie(7*50, 10*50, 30, 30));
    curWorld.addEnemy(new Zombie(21*50, 10*50, 30, 30));
    curWorld.addEnemy(new Zombie(22*50, 10*50, 30, 30));
    curWorld.addEnemy(new Zombie(19*50, 10*50, 30, 30));
    curWorld.addEnemy(new Zombie(20*50, 10*50, 30, 30));
  }

  void render() {
    super.render();
    pushMatrix();
    curWorld.camera.alterMatrix();

    fill(#00ECFF, 150);
    rect(22*World.gridSize, 1 * World.gridSize, 3 * World.gridSize, World.gridSize);
    fill(0);
    textFont(mainMenuFont3);
    textSize(12);
    textAlign(CENTER);
    text("Step here", 22 * World.gridSize + 1.5 * World.gridSize, World.gridSize + World.gridSize / 2);
    popMatrix();
  }
}

// the third level dungeon - 3 rooms of skeleton knights
class L3RoomDungeon extends DefaultDungeon {
  int curRoom = 1;

  L3RoomDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }
  void setup() {
    // create new player at spawn location
    curPlayer = getPlayerOf(50, 8 * 50, info);

    // load in the world
    curWorld = getWorldOf("dungeon_maps/l3.txt", curPlayer);

    // add enemy
    curWorld.addEnemy(new Skeleton(11*50, 5*50, skeletonWidth, skeletonHeight));

    // play background music
    playBackgroundMusic();

    // set up the initial config
    addEnemiesToRoom1();
  }

  void tick() {
    super.tick();
    if (curWorld.enemies.size() == 0) {
      // if the room has been defeated (no enemies)
      curRoom += 1;
      if (curRoom == 2) {
        // add enemies to the second room
        addEnemiesToRoom2();

        // open a path to room 2
        curWorld.changeElement(21, 7, DungeonElement.Ground);
        curWorld.changeElement(21, 8, DungeonElement.Ground);
        curWorld.changeElement(21, 9, DungeonElement.Ground);
      } else if (curRoom == 3) {
        // add enemies to the third room
        addEnemiesToRoom3();

        // open a path to room 3
        curWorld.changeElement(46, 7, DungeonElement.Ground);
        curWorld.changeElement(46, 8, DungeonElement.Ground);
        curWorld.changeElement(46, 9, DungeonElement.Ground);
      } else {
        // if the third room has been defeated, then we complete the dungeon
        dungeonCompleted();
      }
    }

    // "lock" the player in if they reach the next room
    if (curPlayer.x > 22*50 + 10) {
      curWorld.changeElement(21, 7, DungeonElement.Wall);
      curWorld.changeElement(21, 8, DungeonElement.Wall);
      curWorld.changeElement(21, 9, DungeonElement.Wall);
    }
    if (curPlayer.x > 47*50 + 10) {
      curWorld.changeElement(46, 7, DungeonElement.Wall);
      curWorld.changeElement(46, 8, DungeonElement.Wall);
      curWorld.changeElement(46, 9, DungeonElement.Wall);
    }
  }

  // code for adding enemies to the first room
  void addEnemiesToRoom1() {
    // two for loops, which spawn enemies "in a grid"
    for (int c = 8 * 50; c <= 18*50; c += 50) {
      for (int r = 5 * 50; r <= 7*50; r += 50) {
        if (random(1) > 0.6) {
          curWorld.addEnemy(new Skeleton(c, r, skeletonWidth, skeletonHeight));
        }
      }
    }
    for (int c = 8 * 50; c <= 16*50; c += 50) {
      for (int r = 9 * 50; r <= 11*50; r += 50) {
        if (random(1) > 0.6) {
          curWorld.addEnemy(new Skeleton(c, r));
        }
      }
    }
  }

  // adding a random enemy that spawns in room 2
  void addRandomR2Enemy(float c, float r) {
    float enemyRandom = random(1);
    if (enemyRandom < 0.5) {
      curWorld.addEnemy(new Goblin(c, r));
    } else {
      curWorld.addEnemy(new Zombie(c, r));
    }
  }

  // code for adding enemies to the second room
  void addEnemiesToRoom2() {
    // two for loops, which spawn enemies "in a grid"
    for (int c = 30 * 50; c <= 34*50; c += 50) {
      for (int r = 5 * 50; r <= 7*50; r += 50) {
        if (random(1) > 0.6) {
          addRandomR2Enemy(c, r);
        }
      }
    }
    for (int c = 36 * 50; c <= 41*50; c += 50) {
      for (int r = 5 * 50; r <= 7*50; r += 50) {
        if (random(1) > 0.6) {
          addRandomR2Enemy(c, r);
        }
      }
    }
  }

  // adds a random enemy for the third room
  void addRandomR3Enemy(float c, float r) {
    float enemyRandom = random(1);
    if (enemyRandom < 0.33) {
      curWorld.addEnemy(new Goblin(c, r));
    } else if (enemyRandom < 0.66) {
      curWorld.addEnemy(new Zombie(c, r));
    } else {
      curWorld.addEnemy(new Skeleton(c, r));
    }
  }

  // add enmies to the third room
  void addEnemiesToRoom3() {
    // four for loops, adding enemies "in a grid" at various spots
    for (int c = 56 * 50; c <=68*50; c += 50) {
      for (int r = 7 * 50; r <= 9*50; r += 50) {
        if (random(1) > 0.6) {
          addRandomR3Enemy(c, r);
        }
      }
    }
    for (int c = 58* 50; c <= 66*50; c += 50) {
      for (int r = 2 * 50; r <= 5*50; r += 50) {
        if (random(1) > 0.6) {
          addRandomR3Enemy(c, r);
        }
      }
    }
    for (int c = 56 * 50; c <= 66*50; c += 50) {
      for (int r = 11 * 50; r <= 15*50; r += 50) {
        if (random(1) > 0.6) {
          addRandomR3Enemy(c, r);
        }
      }
    }
    for (int c = 70 * 50; c <= 70*50; c += 50) {
      for (int r = 2 * 50; r <= 15*50; r += 50) {
        if (random(1) > 0.6) {
          addRandomR3Enemy(c, r);
        }
      }
    }

    // adding a few outliers to make it more "interesting"
    curWorld.addEnemy(new Skeleton(54*50, 7*50, skeletonWidth, skeletonHeight));
    curWorld.addEnemy(new Skeleton(54*50, 8*50, skeletonWidth, skeletonHeight));
    curWorld.addEnemy(new Skeleton(54*50, 9*50, skeletonWidth, skeletonHeight));
    curWorld.addEnemy(new Skeleton(54*50, 10*50, skeletonWidth, skeletonHeight));
  }
}

class DragonBossDungeon extends DefaultDungeon {
  final int fireFrames = 60; // the frames a fire lasts for
  final int fireInterval = 15; // the interval of the fire
  final float fireDamage = 10; // the damage of the fire
  int lastLitFrame; // the last frame in which the fire was lit 
  int fireTimer; // a timer variable for when to check to see if the fire was lit

  // stats for the dragon
  final float dragonHealth = 700;
  final float dragonSlashDamage = 30;
  final static int dragonWidth=100, dragonHeight=50;
  final int dragonFPA=30; // FPA = frames per attack
  PImage dragon;

  // stats for the fireball
  final int fireballRadius = 15;
  final float fireballDespawnX = 18 * 50;
  final float fireballDamage = 10;
  final float fireballSpeed = 10;
  final float fireballTrailSize = 200;

  // stats for the speed at which to blow back the player
  final float blowBackSpeed = 20;
  final float blowBackFrames = 30;
  float blowBackTimer; // this is just a timer to keep track of how much longer to keep the player blown

  // stats for the melee guardian for the dragon
  final int meleeGuardFPA=45;
  final static int meleeWidth=45, meleeHeight=50;
  final float meleeDamage=20, meleeAttackRange=5, meleeSightRange=300, meleeTargettedRange=550, meleeSpeed=2, meleeStartingHealth=70;
  PImage meleeRight, meleeLeft;

  // stats for the ranged guardian for the dragon
  final int rangedGuardFPA=30;
  final static int rangedWidth=20, rangedHeight=30;
  final float rangedDamage=10, rangedAttackRange=700, rangedSpeed=4, rangedStartingHealth=25, rangedProjectileSpeed=5;
  PImage rangedRight, rangedLeft;

  int curStage; // 0 for fighting guardians, 1 for fighting dragon

  // enemies to spawn (when a dragon spawns enemies, this prevents concurrentmodificationerror)
  ArrayList<Enemy> toSpawn;

  // maximum total number of enemies with dragon
  final int totalDragonEnemies = 20;

  DragonBossDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }

  void setup() {
    // initialize variables and sprites
    lastLitFrame = -1000;
    dragon = dungeonDragonBoss;
    blowBackTimer = 0;

    meleeLeft = dungeonDragonBossGuardMeleeLeft;
    meleeRight = dungeonDragonBossGuardMeleeRight;

    rangedLeft = dungeonDragonBossGuardRangedLeft;
    rangedRight = dungeonDragonBossGuardRangedRight;

    // we start with fighting the guardians
    curStage = 0;
    curPlayer = getPlayerOf(60, 8 * 50, info);
    curWorld = getWorldOf("dungeon_maps/dragon.txt", curPlayer);

    // initialize toSpawn, play music and set up the guardian room
    toSpawn = new ArrayList<Enemy>();
    playBackgroundMusic();
    fillGuardianRoom();
  }


  void tick() {
    super.tick();
    // whenever the fireTimer hits 0
    if (fireTimer <= 0) {
      // we check for if a player has been hit 
      if (curFrame - lastLitFrame <= fireFrames) {
        curPlayer.takeDamage(fireDamage);
      }
      fireTimer = fireInterval;
    } else {
      // otherwise, continue the timer
      fireTimer--;
    }

    // if we're still blowing back the player, move it back
    if (blowBackTimer > 0) {
      curWorld.moveEntity(curPlayer, -blowBackSpeed, 0);
      blowBackTimer--;
    }

    // if all the enemies have been defeated
    if (curWorld.enemies.size() == 0) {
      // if the current stage were guardians
      if (curStage == 0) {
        // open up the room to the dragon
        curWorld.changeElement(18, 7, DungeonElement.Ground);
        curWorld.changeElement(18, 8, DungeonElement.Ground);
        curWorld.changeElement(18, 9, DungeonElement.Ground);
        if (curPlayer.x > 19*50) {
          // if the player goes into the dragon room, set the stage to the dragon stage
          curStage = 1;
          curWorld.changeElement(18, 7, DungeonElement.Wall);
          curWorld.changeElement(18, 8, DungeonElement.Wall);
          curWorld.changeElement(18, 9, DungeonElement.Wall);
          curWorld.addEnemy(new Dragon(56*50, 8*50));
        }
      } else if (curStage == 1) {
        // if the dragon was defeated, complete the dungeon
        dungeonCompleted();
      }
    }

    // for all enemies we need to spawn, we add them
    if (toSpawn.size() > 0) {
      for (Enemy enemy : toSpawn) {
        curWorld.addEnemy(enemy);
      }
      toSpawn.clear();
    }
  }

  // fills the guardian room
  void fillGuardianRoom() {
    curWorld.addEnemy(new MeleeGuard(4*50, 6*50));
    curWorld.addEnemy(new MeleeGuard(13*50, 6*50));
    curWorld.addEnemy(new MeleeGuard(4*50, 11*50));
    curWorld.addEnemy(new MeleeGuard(13*50, 11*50));
    curWorld.addEnemy(new MeleeGuard(8*50, 8*50));

    curWorld.addEnemy(new RangedGuard(17*50, 6*50));
    curWorld.addEnemy(new RangedGuard(9*50, 6*50));
    curWorld.addEnemy(new RangedGuard(2*50, 6*50));
    curWorld.addEnemy(new RangedGuard(17*50, 13*50));
    curWorld.addEnemy(new RangedGuard(9*50, 13*50));
    curWorld.addEnemy(new RangedGuard(2*50, 13*50));

    curWorld.addEnemy(new MeleeGuard(12*50, 125));
    curWorld.addEnemy(new RangedGuard(17*50, 125));
    curWorld.addEnemy(new MeleeGuard(12*50, 16*50));
    curWorld.addEnemy(new RangedGuard(17*50, 16*50));
  }

  class MeleeGuard extends MeleeEnemy {
    // initialize a melee guard with predetermined stats
    MeleeGuard(float x, float y) {
      super(x, y, meleeWidth, meleeHeight, meleeGuardFPA, meleeAttackRange, meleeSightRange, meleeTargettedRange, meleeDamage, meleeSpeed, meleeStartingHealth, meleeRight, meleeLeft);
    }
  }

  class RangedGuard extends RangedEnemy {
    float damage; // damage of the bullet
    float bulletSpeed; // speed of the bullet

    // constructor
    RangedGuard(float x, float y, int w, int h, int framesPerAttack, float range, float attack, float speed, float startingHealth, float bulletSpeed) {
      super(x, y, w, h, framesPerAttack, range, speed, startingHealth, rangedRight, rangedLeft);
      this.damage = attack;
      this.bulletSpeed = bulletSpeed;
    }

    // constructor but initializing with default values
    RangedGuard(float x, float y) {
      this(x, y, rangedWidth, rangedHeight, rangedGuardFPA, rangedAttackRange, rangedDamage, rangedSpeed, rangedStartingHealth, rangedProjectileSpeed);
    }
    void attack() {
      // get the vector to the player's center
      float xDiff = curPlayer.centerX() - this.centerX();
      float yDiff = curPlayer.centerY() - this.centerY();
      float mag = magnitude(xDiff, yDiff);

      // add a fire projectile
      curWorld.addProjectile(new FireProjectile(centerX(), centerY(), bulletSpeed * xDiff / mag, bulletSpeed * yDiff / mag, range, this.damage));
    }
  }

  // A projectile shot by the ranged guard
  class FireProjectile implements Projectile {
    // current coords, starting coords, the direction to move in, the distance it should travel for, the damage
    float x, y;
    float startX, startY;
    float xDiff, yDiff;
    float existDist;
    float damage;

    // constructor with just initializing all of these variables
    FireProjectile(float x, float y, float xDiff, float yDiff, float existDist, float damage) {
      this.x = x;
      this.y = y;
      startX = x;
      startY = y;
      this.xDiff = xDiff;
      this.yDiff = yDiff;
      this.existDist = existDist;
      this.damage = damage;
    }

    void tick() {
      // move the current projectile
      this.x += xDiff;
      this.y += yDiff;

      // if the projectile hits the player, damage him and remove this projectile
      if (curPlayer.inRange(x, y)) {
        curPlayer.takeDamage(damage);
        lastLitFrame = curFrame;
        curWorld.removeProjectile(this);
      }

      // if the projectile has hit a wall or is past the distance it should exist, remove it
      if (curWorld.touchingWall(new Entity(x, y, 0, 0))) {
        curWorld.removeProjectile(this);
      }
      if (pointDistance(this.x, this.y, this.startX, this.startY) > existDist) {
        curWorld.removeProjectile(this);
      }
    }
    void render() {
      pushMatrix();
      translate(x, y);
      rotate(angleOf(xDiff, yDiff));

      // draw a red line for the arrow
      stroke(255, 0, 0);
      strokeWeight(2);
      line(-30, 0, 0, 0);

      fill(255, 0, 0);
      noStroke();
      // draw a red circle for the fire arrowhead
      ellipse(0, 0, 5, 5);
      popMatrix();
    }
  }

  // The dragon boss
  class Dragon extends Enemy {
    // attack intervals
    int attackInterval;
    int rageAttackInterval;

    // the timer for its attack
    int attackTimer;

    // damage from its slash
    float slashDamage;

    int curAttack; // identifier for the current attack (0 is fireball, 1 is strike, 2 is blowback, 3 is summon)

    Dragon(float x, float y, int w, int h, int attackInterval, float slashDamage) {
      // initialize variables
      super(x, y, w, h, dragonHealth);
      this.attackInterval = attackInterval;
      rageAttackInterval = attackInterval / 2;
      this.attackTimer = attackInterval;
      this.slashDamage = slashDamage;

      curAttack = 0;
    }

    // a constructor initializing with default values
    Dragon(float x, float y) {
      this(x, y, dragonWidth, dragonHeight, dragonFPA, dragonSlashDamage);
    }

    // attack for throwing a fireball
    void throwFireball() {
      curWorld.addProjectile(new DragonFireball(this.centerX(), curPlayer.centerY()));
    }

    // attack for spawning minions
    void spawnMinions() {
      for (float x = 35*50; x <= 39*50; x += 60) {
        for (float y = 7*50; y <= 9 * 50 && toSpawn.size() + curWorld.enemies.size() < totalDragonEnemies; y += 50) {
          Skeleton toAdd = new Skeleton(x, y, skeletonWidth, skeletonWidth, 10000, 10000);
          toAdd.seesPlayer = true;
          toSpawn.add(toAdd);
        }
      }
    }

    void tick() {
      // if the dragon should attack now
      if (attackTimer <= 0) {
        // rest the timer
        attackTimer = attackInterval;

        // use the next attack
        curAttack = (curAttack + 1) % 4;

        if (curAttack == 0) {
          // throw a fireball
          throwFireball();
        } else if (curAttack == 1) {
          // "slash" the player if he's close enough. Otherwise throw a fireball
          if (curPlayer.distance(this) <= 400) {
            curWorld.addProjectile(new DragonSlash(slashDamage));
          } else {
            throwFireball();
          }
        } else if (curAttack == 2) {
          // blow back the player if he's close enough. Otherwise throw a fireball
          if (this.distance(curPlayer) <= 200) {
            blowBackTimer = blowBackFrames;
          } else {
            throwFireball();
          }
        } else if (curAttack == 3) {
          // spawn minions
          spawnMinions();
        } else {
          // error trapping
          println("Invalid attack for dragon!");
        }
      } else {
        // otherwise continue the timer
        attackTimer--;
      }

      // if the health is below half, then the dragon begins "rage"
      if (this.health <= this.maxHealth / 2) {
        this.attackInterval = rageAttackInterval;
      }
    }

    void render() {
      // draw the dragon and healthbar
      image(dragon, x, y);
      this.drawHealthBar(this.x, this.y - 10, w, 10);

      // draw text for the attack number
      textFont(dungeonDragonAttackFont);
      fill(255);
      textAlign(CENTER);
      // people are generally more familiar with 1-indexed numbers, so we add 1
      text((curAttack + 1), centerX(), y + h + 6);
    }
  }

  class DragonFireball implements Projectile {
    // starting coordinates, radius of the fireball and other stats
    float cx, cy;
    int r;
    float speed;
    float damage;

    // the coordinate in which it should die
    float deadX;

    // the fire trail's x coordinate
    float fireTrailStartX;

    // the intervals at which we should check 
    final float checkAngleInc = PI / 16;

    // a boolean for whether or not we've damaged the player (since we only want to do this once)
    boolean damagedPlayer;

    // constructor for initializing variables
    DragonFireball(float x, float y, int r, float deadX, float speed, float damage) {
      this.cx = x;
      this.cy = y;
      this.r = r;
      this.deadX = deadX;
      this.speed = speed;
      this.damage = damage;

      fireTrailStartX = x;
      damagedPlayer = false;
    }

    // constructor with default values
    DragonFireball(float x, float y) {
      this(x, y, fireballRadius, fireballDespawnX, fireballSpeed, fireballDamage);
    }

    void tick() {
      // keep the firetrail within relative distance of this
      if (abs(fireTrailStartX - cx) > fireballTrailSize) {
        fireTrailStartX = cx + fireballTrailSize;
      } 

      // if the fireball has travelled so far it has reached the end of the map
      if (cx <= deadX) {
        // continue to move the firetrail
        fireTrailStartX -= speed; 
        // if the fire trail has reached the fireball, then it is useless and we remove it
        if (fireTrailStartX < cx) {
          curWorld.removeProjectile(this);
        }
      } else {
        // otherwise, continue to move the fireball
        this.cx -= speed;
      }
      for (float angle = 0; angle < 2 * PI; angle += checkAngleInc) {
        // if we the fireball has hit the player
        if (curPlayer.inRange(cx + cos(angle) * this.r, cy + sin(angle) * this.r) && !damagedPlayer) {
          // damage the player and light the player on fire
          curPlayer.takeDamage(this.damage);
          damagedPlayer = true;
          lastLitFrame = curFrame;
        }
        // if the player hits the fire trail, light him on fire
        if (curPlayer.hitsBox(cx, cy - r, abs(fireTrailStartX - cx), 2 * r)) {
          lastLitFrame = curFrame;
        }
      }
    }
    void render() {
      // draw a rectangle for the fire trail
      fill(255, 137, 10, 100);
      noStroke();
      rect(cx, cy - r, abs(fireTrailStartX - cx), 2 * r);

      // draw a circle with radius r for the fireball
      fill(255, 0, 0, 255);
      stroke(255, 255, 0);
      strokeWeight(2);
      ellipse(cx, cy, 2 * r, 2 * r);
    }
  }

  // the slash attack of the dragon
  class DragonSlash implements Projectile {
    // the frames for the slash & the current frame
    final int animationFrames = 5;
    int slashFrame;

    // initialize variables, damage the player
    DragonSlash(float damage) {
      slashFrame = 0;
      curPlayer.takeDamage(damage);
    }

    void tick() {
      // if the animation is done, remove this projectile
      if (slashFrame > animationFrames) {
        curWorld.removeProjectile(this);
      } else {
        // otherwise, continue the animation
        slashFrame += 1;
      }
    }
    void render() {
      // the lengths of the line based on the current frame
      float lx = 30 / animationFrames * slashFrame;
      float ly = 30 / animationFrames * slashFrame;

      // the dimensions of the the lines on top and to the bottom based on the current frame
      float sideX = 20 / animationFrames * slashFrame;
      float sideY = 20 / animationFrames * slashFrame;

      // draw the lines through the center of the player
      line(curPlayer.centerX() - 15, curPlayer.centerY() - 15, curPlayer.centerX() - 15 + lx, curPlayer.centerY() - 15 + ly);
      //... and above and below the center line
      line(curPlayer.centerX() - 10, curPlayer.centerY() - 20, curPlayer.centerX() - 10 + sideX, curPlayer.centerY() - 20 + sideY);
      line(curPlayer.centerX() - 10, curPlayer.centerY(), curPlayer.centerX() - 10 + sideX, curPlayer.centerY() + sideY);
    }
  }
}

class SerpantBossDungeon extends DefaultDungeon {
  final int waterEffectFrames = 30; // the number of frames that water should slow down the player
  float waterSpeedRatio = 0.5; // the amount of "slowing" it should do
  int waterSlowTimer; // a timer for the water effect

  final int poisonFrames = 360; // the time the poison should work for
  float poisonDamage = 0.5; // the damage of the poison each frame
  int lastPoisonFrame; // the last frame in which poison was inflicted

  PImage waterSprite; // the sprite for the water tile

  WaterWorld curWaterWorld; // a special world for this dungeon (has water)

  // stats for the ranged guard
  PImage rangedRight, rangedLeft;
  final float rangedHealth=40, rangedBulletDamage=10, rangedBulletSpeed=15, rangedRange=900, rangedSpeed=4;
  final static int rangedWidth=15, rangedHeight=30;
  final int rangedFPA=20;
  float rangedOnWaterDamageReduction = 0.7;

  int curDungeonState; // 0 for round 1, 1 for round 2, 2 for if we wait for player to go to next room, 3 for boss fight

  // stats for the snake
  PImage snakeUp, snakeDown;
  final static int snakeWidth=50, snakeHeight=150;
  final int snakeVenomFPA=10, snakeSmashFPA=25, snakeSummonFPA=60;
  final float snakeHealth=700, snakeVenomSpeed=15, snakeSmashSpeed=50, snakeSmashDamage=60;

  // enemies to add (can't add them directly, as it causes concurrentmodificationexception)
  ArrayList<Enemy> enemiesToAdd;

  // maximum number of total spawned enemies
  final int totalSerpantEnemies = 20;

  SerpantBossDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }

  void setup() {
    // initialize the player and the world
    curPlayer = getPlayerOf(50, 8*50, info);
    curWaterWorld = getWaterWorldOf("dungeon_maps/serpant.txt", curPlayer);
    curWorld = curWaterWorld;

    // initialize the water tile
    waterSprite = dungeonWaterSprite;

    // initialize sprites for the dungeon
    rangedRight = dungeonSnakeBossGuardRangedRight;
    rangedLeft = dungeonSnakeBossGuardRangedLeft;
    snakeUp = dungeonSnakeBossUp;
    snakeDown = dungeonSnakeBossDown;

    // initialize the enemiesToAdd arraylist
    enemiesToAdd = new ArrayList<Enemy>();

    // spawn the initial guardian room
    spawnGuardianRoom1();
    curDungeonState = 0;

    playBackgroundMusic();
  }
  void tick() {
    super.tick();
    // continue the timer for the water slowing down the player
    waterSlowTimer--;
    // if the player is touching water, reset the timer
    if (curWaterWorld.touchingWater(curPlayer)) {
      waterSlowTimer = waterEffectFrames;
    }

    // if the current room has been defeated
    if (curWorld.enemies.size() == 0) {
      // for the first stage, once defeated we spawn another stage
      if (curDungeonState == 0) {
        spawnGuardianRoom2();
        curDungeonState = 1;
      } else if (curDungeonState == 1) {
        // once the second stage is defeated, we open up the room to the boss fight
        curWorld.changeElement(23, 7, DungeonElement.Ground);
        curWorld.changeElement(23, 8, DungeonElement.Ground);
        curWorld.changeElement(23, 9, DungeonElement.Ground);
        curDungeonState = 2;
      } else if (curDungeonState == 3) {
        // if the boss fight is also defeated, then we completed the dungeon
        dungeonCompleted();
      }
    }

    // if we're at the state where the player should move towards the boss room, then we check for if they have moved into the room
    if (curDungeonState == 2 && curPlayer.x > 27*50) {
      // if they have, then we spawn the boss and lock the player in the room
      curWorld.addEnemy(new SerpantBoss(random(27*50, 49*50 - snakeWidth), random(2*50, 18*50 - snakeHeight)));
      curWorld.changeElement(26, 7, DungeonElement.Wall);
      curWorld.changeElement(26, 8, DungeonElement.Wall);
      curWorld.changeElement(26, 9, DungeonElement.Wall);
      curDungeonState = 3;
    }

    // if the poison effect is ongoing, damage the player
    if (curFrame - lastPoisonFrame <= poisonFrames) {
      curPlayer.takeDamage(poisonDamage);
    }

    // add all enemies that we need to add
    for (Enemy enemy : enemiesToAdd) {
      curWorld.addEnemy(enemy);
    }
    enemiesToAdd.clear();
  }

  // spawn guardians in a grid - this is a tool method
  void spawnRangedGuardInRange(int fx, int fy, int sx, int sy, float xIncrement, float yIncrement, float probability) {
    for (float x = fx; x <= sx; x += xIncrement)
      for (float y = fy; y <= sy; y += yIncrement) {
        float num = random(1);
        if (num > 1 - probability) {
          curWorld.addEnemy(new RangedGuard(x, y));
        }
      }
  }

  // spawns the guardians for the first iteration of the first room
  void spawnGuardianRoom1() {
    // spawn guardians in 4 "rectangles"
    spawnRangedGuardInRange(2*50, 2 * 50, 13*50, 3*50, 100, 100, 0.7);
    spawnRangedGuardInRange(2*50, 14*50, 13*50, 15*50, 100, 100, 0.7);
    spawnRangedGuardInRange(20*50, 3 * 50, 22*50, 15*50, 100, 100, 0.4);
    spawnRangedGuardInRange(9*50, 8 * 50, 13*50, 12*50, 50, 50, 0.4);
  }

  // spawns guardians for the second iteration of the first room
  void spawnGuardianRoom2() {
    // spawn guardians in 4 "rectangles"
    spawnRangedGuardInRange(2*50, 2 * 50, 13*50, 3*50, 100, 100, 1);
    spawnRangedGuardInRange(2*50, 14*50, 13*50, 15*50, 100, 100, 1);
    spawnRangedGuardInRange(20*50, 3 * 50, 22*50, 15*50, 100, 100, 1);
    spawnRangedGuardInRange(9*50, 8 * 50, 13*50, 12*50, 50, 50, 1);
  }

  class SerpantBoss extends Enemy {
    int venomFPA, smashFPA, summonFPA; // the frames per attack (attack interval/speed) for venom, smashing and summoning
    int lastVenomFrame, lastSmashFrame, lastSummonFrame; // keeps track of the last time the snake did each of these attacks
    float venomSpeed, smashSpeed; // the speed of the venom projectile and the "smash" attack
    float smashDamage; // damage from smash

    boolean damagedPlayer; // a boolean for whether the smash attack has damaged the player
    Direction direction; // the direction of the smash attack

    PImage up, down; // the images for up and down

    int curState; // 0 for invisible, 1 for in middle of smash

    // constructor for initializing the variables
    SerpantBoss(float x, float y, int w, int h, float health, int venomFPA, int smashFPA, int summonFPA, float venomSpeed, float smashSpeed, float smashDamage) {
      super(x, y, w, h, health);

      this.venomFPA = venomFPA;
      this.smashFPA = smashFPA;
      this.lastVenomFrame = curFrame;
      this.lastSmashFrame = curFrame;
      this.venomSpeed = venomSpeed;
      this.smashSpeed = smashSpeed;
      this.smashDamage = smashDamage;
      this.summonFPA = summonFPA;

      this.damagedPlayer = false;
      this.direction = Direction.up;
      this.curState = 0;

      this.lastVenomFrame = 0;
      this.lastSmashFrame = 0;
      this.lastSummonFrame = 0;

      this.up = snakeUp;
      this.down = snakeDown;
    }

    // constructor which initializes with default values
    SerpantBoss(float x, float y) {
      this(x, y, snakeWidth, snakeHeight, snakeHealth, snakeVenomFPA, snakeSmashFPA, snakeSummonFPA, snakeVenomSpeed, snakeSmashSpeed, snakeSmashDamage);
    }

    void tick() {
      // if the time between the last time we summoned has reached a certain point, then summon enemies
      if (curFrame - lastSummonFrame >= summonFPA) {
        summon();
        lastSummonFrame = curFrame;
      }

      // wait until the interval for shooting venom has been reached 
      if (curFrame - lastVenomFrame >= venomFPA) {
        shootProjectile();
      }

      // if we're doing the "smash attack", then move the snake
      if (curState == 1) {
        if (direction == Direction.down) {
          y += smashSpeed;
        } else if (direction == Direction.up) {
          y -= smashSpeed;
        } else {
          println("direction is not down or up for snake boss");
        }

        // check to see if we hit the player. If so, then we damage it
        if (this.collided(curPlayer) && !damagedPlayer) {
          curPlayer.takeDamage(smashDamage);
          this.damagedPlayer = true;
        }
      }

      // update the current attack
      setState();
    }
    void summon() {
      // summon skeletons in a grid
      for (int x = 35*50; x <= 37*50; x += 50) {
        for (int y = 7*50; y <= 9*50 && enemiesToAdd.size() + curWorld.enemies.size() < totalSerpantEnemies; y += 50) {
          Skeleton toAdd = new Skeleton(x, y, skeletonWidth, skeletonHeight);
          toAdd.seesPlayer = true;
          enemiesToAdd.add(toAdd);
        }
      }
    }

    // a function for detecting what state to be in
    void setState() {
      // if we're currently "idling"
      if (curState == 0) {
        // check to see if we've idled long enough
        if (curFrame - lastSmashFrame >= smashFPA) {
          // if so, then we begin the smash attack
          curState = 1;
          if (direction == Direction.down)
            direction = Direction.up;
          else
            direction = Direction.down;

          // move the snake so that it "smashes into" the player
          this.x = min(49*50 - this.w, max(27*50, curPlayer.centerX() - this.w / 2));

          // if we're going up, start the attack at the bottom and vice versa
          if (direction == Direction.up) {
            this.y = 18*50 - this.h;
          } else {
            this.y = 2*50;
          }

          damagedPlayer = false;
        }
      } else if (curState == 1) {
        // if we've reached the end of the attack, then we go back to idling
        if (direction == Direction.up && this.y < 2 * 50 || direction == Direction.down && this.y > 18*50 - this.h) {
          curState = 0;
        }

        lastSmashFrame = curFrame;
      }
    }
    // the code for when we want to do our "venom attack"
    void shootProjectile() {
      // get the vector to the player
      float xDiff = curPlayer.centerX() - this.centerX();
      float yDiff = curPlayer.centerY() - this.centerY();
      float mag = magnitude(xDiff, yDiff);

      // shoot a venom projectile towards the player
      curWorld.addProjectile(new Venom(centerX(), centerY(), xDiff / mag * venomSpeed, yDiff / mag * venomSpeed));
      lastVenomFrame = curFrame;
    }
    void render() {
      // draw the snake based on the direction it is moving in
      if (direction == Direction.up) {
        image(up, x, y);
      } else if (direction == Direction.down) {
        image(down, x, y);
      }

      // draw its health bar
      drawHealthBar(this.x, this.y - 11, this.w, 10);
    }
  }

  // The venom projectile
  class Venom implements Projectile {
    float x, y; // coordinates of the venom
    float xDiff, yDiff; // the direction it should go in

    // initializing variables
    Venom(float x, float y, float xDiff, float yDiff) {
      this.x = x;
      this.y = y;
      this.xDiff = xDiff;
      this.yDiff = yDiff;
    }

    void tick() {
      // move the projectile
      this.x += xDiff;
      this.y += yDiff;

      // if it hits the player, then damage the player
      if (curPlayer.inRange(x, y)) {
        lastPoisonFrame = curFrame;
        curWorld.removeProjectile(this);
      }

      // if the projectile moves out of bounds, then remove the projectile
      if (this.x > curWorld.worldWidth || this.x < 0 || this.y > curWorld.worldHeight || this.y < 0) {
        curWorld.removeProjectile(this);
      }
    }

    void render() {
      // draw a green circle for the venom
      fill(#0EFF03);
      noStroke();
      ellipse(x, y, 10, 10);
    }
  }

  // A special world that also handles water
  class WaterWorld extends DungeonWorld {
    boolean[][] water; // the grid for which parts have water

    // initialize variables
    WaterWorld(DungeonElement[][] elements, boolean[][] walkable, boolean[][] water, DungeonPlayer player) {
      super(elements, walkable, player);
      this.water = water;
    }

    void moveEntitySoft(Entity toMove, float xDiff, float yDiff) {
      // first see if the player is in water. If so, slow them down
      if (toMove == curPlayer && waterSlowTimer > 0) {
        xDiff *= waterSpeedRatio;
        yDiff *= waterSpeedRatio;
      }
      super.moveEntitySoft(toMove, xDiff, yDiff);
    }

    boolean touchingWater(Entity query) {
      // returns if an entity is in water
      int startX = (int) (query.x / gridSize);
      int startY = (int) (query.y / gridSize);
      int endX = (int) (query.x / gridSize);
      int endY = (int) (query.y / gridSize);

      for (int x = startX; x <= endX; ++x) {
        for (int y = startY; y <= endY; ++y) {
          if (water[y][x] && query.hitsBox(gridSize * x, gridSize * y, gridSize, gridSize)) {
            return true;
          }
        }
      }
      return false;
    }

    // draws the tiles but this time with water
    void drawTiles() {
      super.drawTiles();
      for (int r = 0; r < water.length; ++r) {
        for (int c = 0; c < water[r].length; ++c) {
          if (water[r][c]) {
            image(waterSprite, gridSize * c, gridSize * r);
          }
        }
      }
    }
  }

  // the ranged guard for this dungeon
  class RangedGuard extends RangedEnemy {
    float bulletSpeed, bulletDamage; // the parameters for the bullet

    // constructor for initializing variables
    RangedGuard(float x, float y, int w, int h, int framesPerAttack, float range, float speed, float startingHealth, float bulletSpeed, float bulletDamage) {
      super(x, y, w, h, framesPerAttack, range, speed, startingHealth, rangedRight, rangedLeft);
      this.bulletSpeed = bulletSpeed;
      this.bulletDamage = bulletDamage;
    }

    // adds defaults for the hyperparameters
    RangedGuard(float x, float y) {
      this(x, y, rangedWidth, rangedHeight, rangedFPA, rangedRange, rangedSpeed, rangedHealth, rangedBulletSpeed, rangedBulletDamage);
    }

    void attack() {
      // get the vector to the player's center
      float xDiff = curPlayer.centerX() - this.centerX();
      float yDiff = curPlayer.centerY() - this.centerY();
      float mag = magnitude(xDiff, yDiff);

      curWorld.addProjectile(new WaterBullet(centerX(), centerY(), bulletSpeed * xDiff / mag, bulletSpeed * yDiff / mag, bulletDamage));
    }

    // if we're touching water, we take less damage
    void takeDamage(float amount) {
      if (curWaterWorld.touchingWater(this))
        amount *= rangedOnWaterDamageReduction;
      super.takeDamage(amount);
    }
  }

  // The water bullet shot by the ranged enemy in the snake dungeon
  class WaterBullet implements Projectile {
    float x, y; // current position
    float xDiff, yDiff; // direction to move in
    float damage; // damage of the bullet

    // initializing variables
    WaterBullet(float x, float y, float xDiff, float yDiff, float damage) {
      this.x = x;
      this.y = y;
      this.xDiff = xDiff;
      this.yDiff = yDiff;
      this.damage = damage;
    }

    void tick() {
      // move the bullet
      x += xDiff;
      y += yDiff;

      // if the player is hit, damage them, slow them down, remove the projectile
      if (curPlayer.inRange(x, y)) {
        curPlayer.takeDamage(damage);
        waterSlowTimer = waterEffectFrames;
        curWorld.removeProjectile(this);
      }
    }
    void render() {
      pushMatrix();
      translate(x, y);
      rotate(angleOf(xDiff, yDiff));

      // draw a circle for the head
      fill(#03FCF6);
      noStroke();
      ellipse(0, 0, 7, 7);

      // draw a line for the back
      stroke(#03FCF6);
      strokeWeight(3);
      line(-10, 0, 0, 0);

      popMatrix();
    }
  }

  // parsing a custom text file into a waterworld
  WaterWorld getWaterWorldOf(String filePath, DungeonPlayer curPlayer) {
    // load strings
    String[] lines = loadStrings(filePath);

    // get rows and cols specified on the first line
    int rows = Integer.parseInt(lines[0].split(" ")[0]);
    int cols = Integer.parseInt(lines[0].split(" ")[1]);

    // create a grid for the world
    DungeonElement[][] elements = new DungeonElement[rows][cols];
    boolean[][] walkable = new boolean[rows][cols];
    boolean[][] water = new boolean[rows][cols];

    // for each coordinate
    for (int r = 0; r < rows; ++r) {
      for (int c = 0; c < cols; ++c) {
        // we get the current element
        char cur = lines[r + 1].charAt(c);
        // L = water
        water[r][c] = (cur == 'L');
        walkable[r][c] = (cur == 'G' || cur == 'L');

        // add the elements for what we pass to the 'parent world' of a water world
        if (cur == 'E') {
          elements[r][c] = DungeonElement.Empty;
        } else if (cur == 'W') {
          elements[r][c] = DungeonElement.Wall;
        } else {
          elements[r][c] = DungeonElement.Ground;
        }
      }
    }

    // return a world using the parameters from the file
    return new WaterWorld(elements, walkable, water, curPlayer);
  }
}

class GiantBossDungeon extends DefaultDungeon {
  // parameters for the guard of giants
  PImage guardRight, guardLeft;
  final static int giantGuardWidth=45, giantGuardHeight=50;
  final int giantGuardFPA=30;
  final float giantGuardRange=5, giantGuardSightRange=300, giantGuardPlayerTargettedRange=600, giantGuardDamage=40, giantGuardSpeed=3, giantGuardHealth=200;

  // parameters/stats for the giant itself
  PImage giant;
  final static int giantWidth=123, giantHeight=100;
  final int giantFPA=30, giantKnockbackFrames=15, giantNumDaggers=10, giantBoulderDamageInterval=15, giantBoulderEF=120, giantDaggerEF=20;
  final float giantBoulderDamage=30, giantDaggerDamage=10, giantSmashDamage=60, giantKnockbackSpeed=15, giantHealth=1000, giantSpeed=3, giantSmashRange=125, giantBoulderSpeed=5, giantDaggerSpeed=18, giantBoulderRadius=40, giantDaggerAngleVariation=PI/10;

  int curState; // 0 for guards, 1 for guards completed (still moving to the next room), 2 for boss fight

  GiantBossDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }
  void setup() {
    // initialize variables
    curPlayer = getPlayerOf(60, 8*50, info);
    curWorld = getWorldOf("dungeon_maps/giant.txt", curPlayer);

    // "load in" sprites
    guardRight = dungeonGiantBossGuardMeleeRight;
    guardLeft = dungeonGiantBossGuardMeleeLeft;

    giant = dungeonGiantBoss;

    // set the current state and spawn in guards
    curState = 0;
    guardRoom();

    playBackgroundMusic();
  }
  void tick() {
    super.tick();

    // if we're fighting guards and they're all defeated
    if (curState == 0 && curWorld.enemies.size() == 0) {
      // "open" the door and go to the next state
      curState = 1;
      curWorld.changeElement(23, 7, DungeonElement.Ground);
      curWorld.changeElement(23, 8, DungeonElement.Ground);
      curWorld.changeElement(23, 9, DungeonElement.Ground);
    }

    // if we've moved into the next room
    if (curState == 1 && curPlayer.x > 27*50) {
      // go to the next state
      curState = 2;
      // "lock" the player in the room
      curWorld.changeElement(26, 7, DungeonElement.Wall);
      curWorld.changeElement(26, 8, DungeonElement.Wall);
      curWorld.changeElement(26, 9, DungeonElement.Wall);

      // add the boss
      curWorld.addEnemy(new Giant(38*50, 6*50));
    }

    // if the boss is defeated, complete the dungeon
    if (curState == 2 && curWorld.enemies.size() == 0) {
      dungeonCompleted();
    }
  }

  class Giant extends Enemy {
    // the attack speed
    int framesPerAttack;

    // stats for the "smash" attack
    int knockbackFrames;
    float knockbackSpeed;
    float smashDamage;
    float speed;
    float smashRange;

    // stats for the boulder attack
    int boulderExistFrames;
    int boulderDamageInterval;
    float boulderSpeed;
    float boulderRadius;
    float boulderDamage;

    // stats for the dagger attack
    int numDaggers;
    float daggerSpeed;
    int daggerExistFrames;
    float daggerAngleVariation;
    float daggerDamage;

    int attackTimer; //  a timer for attacking
    int curAttack; // 0 for smash, 1 for boulder, 2 for dagger

    // initialize parameters from the parameters in the constructor
    Giant(float x, float y, int w, int h, float health, int framesPerAttack, int knockbackFrames, float knockbackSpeed, float boulderDamage, float daggerDamage, float smashDamage, 
      float speed, int numDaggers, float smashRange, int boulderDamageInterval, int boulderExistFrames, float boulderRadius, float boulderSpeed, float daggerSpeed, int daggerExistFrames, float daggerAngleVar) {
      super(x, y, w, h, health);
      this.framesPerAttack = framesPerAttack;
      this.knockbackFrames = knockbackFrames;
      this.knockbackSpeed = knockbackSpeed;
      this.boulderDamage = boulderDamage;
      this.daggerDamage = daggerDamage;
      this.smashDamage = smashDamage;
      this.speed = speed;
      this.numDaggers = numDaggers;
      this.smashRange = smashRange;

      this.boulderExistFrames = boulderExistFrames;
      this.boulderDamageInterval = boulderDamageInterval;
      this.boulderSpeed = boulderSpeed;
      this.boulderRadius = boulderRadius;

      this.daggerSpeed = daggerSpeed;
      this.daggerExistFrames = daggerExistFrames;
      this.daggerAngleVariation = daggerAngleVar;

      this.attackTimer = framesPerAttack;
      this.curAttack = 0;
    }

    // constructor for initializing with default values
    Giant(float x, float y) {
      this(x, y, giantWidth, giantHeight, giantHealth, giantFPA, giantKnockbackFrames, giantKnockbackSpeed, giantBoulderDamage, giantDaggerDamage, giantSmashDamage, giantSpeed, giantNumDaggers, giantSmashRange, giantBoulderDamageInterval, 
        giantBoulderEF, giantBoulderRadius, giantBoulderSpeed, giantDaggerSpeed, giantDaggerEF, giantDaggerAngleVariation);
    }
    void tick() {
      // get the vector towards the player
      float xDiff = curPlayer.centerX() - this.centerX();
      float yDiff = curPlayer.centerY() - this.centerY();
      float mag = magnitude(xDiff, yDiff);

      // move towards the player
      curWorld.moveEntitySoft(this, xDiff / mag * speed, yDiff / mag * speed);

      // continue the timer
      attackTimer -= 1;
      // if the timer hits zero, we attack
      if (attackTimer <= 0) {
        if (curAttack == 0) {
          // do "smash attack"
          curWorld.addProjectile(new Smash(this.centerX(), this.centerY(), this.knockbackFrames, this.knockbackSpeed, this.boulderDamage, this.smashRange));
          curAttack = 1;
        } else if (curAttack == 1) {
          // launch a boulder
          curWorld.addProjectile(new Boulder(this.centerX(), this.centerY(), xDiff / mag * boulderSpeed, yDiff / mag * boulderSpeed, boulderRadius, boulderExistFrames, boulderDamage, boulderDamageInterval));
          curAttack = 2;
        } else if (curAttack == 2) {
          // launch numDaggers daggers
          for (int i = 0; i < numDaggers; ++i) {
            float toPlayer = angleOf(xDiff, yDiff);
            float daggerAngle = toPlayer + random(-daggerAngleVariation, daggerAngleVariation);
            curWorld.addProjectile(new Dagger(centerX(), centerY(), daggerSpeed * cos(daggerAngle), daggerSpeed * sin(daggerAngle), daggerDamage));
          }
          curAttack = 0;
        }

        // reset the timer
        attackTimer = framesPerAttack;
      }
    }
    void render() {
      // draw a giant and its health bar
      image(giant, x, y);
      drawHealthBar(x, y - 11, w, 10);
    }
  }

  // the projectile launched from the giant's "dagger attack"
  class Dagger implements Projectile {
    float x, y; // current coordinates
    float xDiff, yDiff; // direction
    float damage; // damage

    // A constructor for initializing variables
    Dagger(float x, float y, float xDiff, float yDiff, float damage) {
      this.x = x;
      this.y = y;
      this.xDiff = xDiff;
      this.yDiff = yDiff;
      this.damage = damage;
    }

    void tick() {
      // move the dagger
      x += xDiff;
      y += yDiff;

      // if it hits the player, damage him and remove the projectile
      if (curPlayer.inRange(x, y)) {
        curPlayer.takeDamage(damage); 
        curWorld.removeProjectile(this);
      }
    }
    void render() {
      pushMatrix();
      translate(x, y);
      rotate(angleOf(xDiff, yDiff));

      // draw the arrowhead for the dagger
      fill(0, 255, 0);
      noStroke();
      triangle(-10, -5, 0, 0, -10, 5);

      // draw the "back line" of the dagger
      stroke(#835600);
      strokeWeight(3);
      line(-20, 0, -10, 0);
      popMatrix();
    }
  }

  class Smash implements Projectile {
    final int animationFrames = 10;
    int curAnimFrame;

    float xDiff, yDiff;
    int knockbackTimer;

    float finalRadius;

    float cx, cy;
    Smash(float cx, float cy, int backFrames, float backSpeed, float damage, float radius) {
      this.finalRadius = radius;
      curAnimFrame = 0;

      if (curPlayer.distance(cx, cy) <= finalRadius) {
        curPlayer.takeDamage(damage);

        float xDiff = curPlayer.centerX() - cx;
        float yDiff = curPlayer.centerY() - cy;
        float mag = magnitude(xDiff, yDiff);

        this.xDiff = xDiff / mag * backSpeed;
        this.yDiff = yDiff / mag * backSpeed;

        knockbackTimer = backFrames;
      } else {
        knockbackTimer = -1;
      }

      this.cx = cx;
      this.cy = cy;
    }
    void tick() {
      curAnimFrame++;
      knockbackTimer--;

      if (curAnimFrame > animationFrames && knockbackTimer <= 0) {
        curWorld.removeProjectile(this);
      }
      if (knockbackTimer > 0) {
        curWorld.moveEntity(curPlayer, xDiff, yDiff);
      }
    }
    void render() {
      if (curAnimFrame <= animationFrames) {
        float curRad = finalRadius * curAnimFrame / animationFrames;
        fill(0, 0, 0, 0);
        stroke(255);
        strokeWeight(3);

        ellipse(cx, cy, 2 * curRad, 2 * curRad);
      }
    }
  }

  class Boulder implements Projectile {
    float cx, cy;
    int existTimer;
    float xDiff, yDiff;
    float radius;

    float damage;
    int damageInterval;
    int damageTimer;
    Boulder(float cx, float cy, float xDiff, float yDiff, float radius, int framesExist, float damage, int damageInterval) {
      this.cx = cx;
      this.cy = cy;
      this.xDiff = xDiff;
      this.yDiff = yDiff;
      this.radius = radius;
      this.existTimer = framesExist;

      this.damage = damage;
      this.damageInterval = damageInterval;
      this.damageTimer = 0;
    }
    void tick() {
      damageTimer -= 1;
      existTimer -= 1;

      if (!curWorld.touchingWall(cx - radius, cy - radius, cx + radius, cy + radius)) {
        cx += xDiff;
        cy += yDiff;
      }
      if (existTimer <= 0) {
        curWorld.removeProjectile(this);
      }
      if (curPlayer.distance(cx, cy) <= radius) {
        if (damageTimer <= 0) {
          curPlayer.takeDamage(damage);
          damageTimer = damageInterval;
        }
      }
    }
    void render() {
      fill(100);
      stroke(0);
      strokeWeight(2);
      ellipse(cx, cy, 2 * radius, 2 * radius);
    }
  }

  void guardRoom() {
    for (int x = 7*50; x <= 20*50; x += 200)
      for (int y = 2 * 50; y <= 14*50; y += 200) {
        curWorld.addEnemy(new GiantGuard(x, y));
      }
  }

  class GiantGuard extends MeleeEnemy {
    GiantGuard(float x, float y, int w, int h, int framesPerAttack, float range, float sightRange, float playerTargettedRange, float attack, float speed, float startingHealth) {
      super(x, y, w, h, framesPerAttack, range, sightRange, playerTargettedRange, attack, speed, startingHealth, guardRight, guardLeft);
    }
    GiantGuard(float x, float y) {
      this(x, y, giantGuardWidth, giantGuardHeight, giantGuardFPA, giantGuardRange, giantGuardSightRange, giantGuardPlayerTargettedRange, giantGuardDamage, giantGuardSpeed, giantGuardHealth);
    }
  }
}

class WarriorDungeon extends DefaultDungeon {
  final static int warriorWidth=40, warriorHeight=60;
  final int warriorMovementChangeInterval=15, warriorAttackInterval=5;
  final float warriorSpeed=15, warriorHealth=400, warriorDamage=20, warriorAttackAngleDiff=PI/2, warriorLongRadius=130, warriorShortRadius=50;
  PImage warrior;

  WarriorDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }
  void setup() {
    curPlayer = getPlayerOf(9*50, 17*50, info);
    curWorld = getWorldOf("dungeon_maps/warrior.txt", curPlayer);
    playBackgroundMusic();

    curWorld.addEnemy(new Warrior(9*50, 2*50));
    warrior = dungeonWarrior;
  }

  void tick() {
    super.tick();
    if (curWorld.enemies.size() == 0) {
      dungeonCompleted();
    }
  }

  class Warrior extends Enemy {
    int moveChangeInterval, atkInterval;
    float speed, damage;
    float attackPadding, longRadius, shortRadius;

    int moveChangeTimer, atkTimer;
    boolean towardsPlayer;
    Warrior(float x, float y, int w, int h, float health, float speed, float damage, int moveChangeInterval, int attackInterval, float attackPadding, float longRad, float shortRad) {
      super(x, y, w, h, health);
      this.speed = speed;
      this.damage = damage;
      this.moveChangeInterval = moveChangeInterval;
      this.atkInterval = attackInterval;
      this.attackPadding = attackPadding;
      this.longRadius = longRad;
      this.shortRadius = shortRad;

      moveChangeTimer = moveChangeInterval;
      towardsPlayer = true;
      atkTimer = attackInterval;
    }
    Warrior(float x, float y) {
      this(x, y, warriorWidth, warriorHeight, warriorHealth, warriorSpeed, warriorDamage, warriorMovementChangeInterval, warriorAttackInterval, warriorAttackAngleDiff, warriorLongRadius, warriorShortRadius);
    }
    void tick() {
      --moveChangeTimer;
      --atkTimer;
      if (moveChangeTimer <= 0) {
        moveChangeTimer = moveChangeInterval;
        if (random(1) < 0.5)
          towardsPlayer = !towardsPlayer;
      }
      if (atkTimer <= 0) {
        float angle = random(0, 2 * PI);
        if (random(1) < 0.5) {
          // do short attack 
          curWorld.addProjectile(new WarriorShortSlash(angle - attackPadding, angle + attackPadding, shortRadius, damage, centerX(), centerY()));
        } else {
          // do long attack 
          curWorld.addProjectile(new WarriorLongSlash(angle - attackPadding, angle + attackPadding, longRadius, damage, this));
        }
        atkTimer = atkInterval;
      }

      float xDiff = curPlayer.centerX() - centerX();
      float yDiff = curPlayer.centerY() - centerY();
      float mag = magnitude(xDiff, yDiff);
      if (towardsPlayer) {
        curWorld.moveEntitySoft(this, xDiff / mag * speed, yDiff / mag * speed);
      } else {
        curWorld.moveEntitySoft(this, -xDiff / mag * speed, -yDiff / mag * speed);
      }
    }
    void render() {
      image(warrior, x, y);
      drawHealthBar(x, y - 7, w, 7);
    }
  }

  class WarriorShortSlash implements Projectile {
    // The slash starts at startAngle and ends at curAngle. The slash moves in a circle with radius [radius], and when hit, does [damage] damage
    // curAngle is used to keep track of the current angle of the drawn arc
    float startAngle, curAngle, endAngle, radius, damage;

    // the intervals at which to check for enemies
    final float angIncrease = PI / 64;
    // The speed at which the angle should be animated
    final float animateAngleSpeed = PI / 4;

    // center coordinate for the circle defining the slash
    float cx, cy;
    WarriorShortSlash(float startAngle, float endAngle, float radius, float damage, float cx, float cy) {
      // initialize the values
      this.startAngle = startAngle;
      this.curAngle = startAngle;
      this.endAngle = endAngle;
      this.radius = radius;
      this.damage = damage;
      this.cx = cx;
      this.cy = cy;

      boolean playerDamaged = false; // tracks if the enemy has been damaged. If it has, then we don't "damage it again"
      for (float angle = startAngle; angle <= endAngle && !playerDamaged; angle += angIncrease) {
        float x = cx + cos(angle) * radius;
        float y = cy + sin(angle) * radius;
        // if the sword hits, then damage the enemy
        if (curPlayer.lineHits(cx, cy, x, y)) {
          curPlayer.takeDamage(this.damage);
          playerDamaged = true;
        }
      }
    }
    void tick() {
      // this is purely for animating
      // increase the angle at which to draw the arc
      this.curAngle += animateAngleSpeed;
      // if we reach the end angle, then we remove the projectile
      if (this.curAngle > endAngle) {
        curWorld.removeProjectile(this);
      }
    }
    void render() {
      // set a white, moderately thick stroke
      stroke(#CE03FC);
      strokeWeight(3);
      fill(0, 0, 0, 0);
      // draw an arc from startAngle to curAngle
      arc(cx, cy, radius * 2, radius * 2, startAngle, curAngle, OPEN);
    }
  }

  // The second knight attack: a long, slow slash
  class WarriorLongSlash implements Projectile {
    // the current angle, the angle to end on, the size of the sword, the damage of the sword
    float curAngle, endAngle, radius, damage;
    // the speed at which to swing the sword
    float angleIncrease = PI / 16;
    // Since we only want to attack each enemy once, we keep a list of the enemies that have been attacked
    boolean hitPlayer;

    // center coordinate of circle defining slash
    Entity toFollow;

    WarriorLongSlash(float startAngle, float endAngle, float radius, float damage, Entity toFollow) {
      // initialize properties
      this.curAngle = startAngle;
      this.endAngle = endAngle;
      this.radius = radius;
      this.damage = damage;

      this.toFollow = toFollow;

      hitPlayer = false;
    }
    void tick() {
      float cx = toFollow.centerX();
      float cy = toFollow.centerY();
      // if the slash is finished, then remove the projectile
      if (curAngle > endAngle)
        curWorld.removeProjectile(this);

      // for each enemy, if the line defining the sword hits any of them and they haven't been attacked before by this attack, then damage them
      if (curPlayer.lineHits(cx, cy, cx + cos(curAngle) * radius, cy + sin(curAngle) * radius) && !hitPlayer) {
        curPlayer.takeDamage(damage);
        hitPlayer = true;
      }

      // move the sword (go to the next angle)
      curAngle += angleIncrease;
    }
    void render() {
      float cx = toFollow.centerX();
      float cy = toFollow.centerY();
      stroke(#CE03FC);
      strokeWeight(4);
      // draw a line to the current end of the sword
      line(cx, cy, cx + cos(curAngle) * radius, cy + sin(curAngle) * radius);
    }
  }
}
