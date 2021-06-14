abstract class DungeonState extends EnvironmentState {
  EnvironmentState previous;
  DungeonState(EnvironmentState previous) {
    this.previous = previous;
  }
  abstract void dungeonCompleted();
  abstract void dungeonExited();
}

class CoinsDungeon extends DefaultDungeon {
  Chest curChest = null;
  final static int chestWidth=80, chestHeight=50;

  void dungeonCompleted() {
    curStory.coinDungeonCompleted();
    dungeonExited();
  }

  CoinsDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }

  void tick() {
    super.tick();
    if (curWorld.enemies.size() == 0) {
      curChest = new Chest(78*50, 8 * 50, (int) random(300, 400));
      curWorld.addEntity(curChest);
    }
  }

  void mousePressed() {
    super.mousePressed();
    if (curChest != null) {
      if (curChest.inRange(curWorld.camera.getRealX(mouseX), curWorld.camera.getRealY(mouseY)))
        curChest.pressed();
    }
  }

  void render() {
    super.render();
    if (curChest != null) {
      pushMatrix();
      curWorld.camera.alterMatrix();
      curChest.render(); 
      popMatrix();
    }
  }

  void setup() {
    // create a new player at the spawn location
    curPlayer = getPlayerOf(60, 340, info);

    // load in the world
    curWorld = getWorldOf("dungeon_maps/coin.txt", curPlayer);

    // in the first room, randomly add goblins at each spot
    for (int i = 360; i < 1000; i += 100) {
      for (int c = 210; c < 700; c += 100) {
        float r = random(1);
        if (r > 0.7) {
          curWorld.addEnemy(new Goblin(i, c, 30, 30));
        }
      }
    }

    // in the first room, randomly add goblins with higher probability
    for (int i = 29*50; i < 45*50; i += 100) {
      for (int c = 4*50; c < 12*50; c += 100) {
        float r = random(1);
        if (r > 0.4) {
          curWorld.addEnemy(new Goblin(i, c, 30, 30));
        }
      }
    }

    // in the third room, randomly add goblins and are more condensed
    for (int i = 53*50; i < 70*50; i += 50) {
      for (int c = 2*50; c < 15*50; c += 50) {
        float r = random(1);
        if (r > 0.6) {
          curWorld.addEnemy(new Goblin(i, c, 30, 30));
        }
      }
    }

    // start the background music
    playBackgroundMusic();
  }

  class Chest extends Entity {
    int coins;
    PImage chest;
    Chest(float x, float y, int w, int h, int coins) {
      super(x, y, w, h);
      this.coins = coins;
      chest = coinsDungeonChest;
    }
    Chest(float x, float y, int coins){
     this(x, y, chestWidth, chestHeight, coins); 
    }
    void pressed() {
      curWorld.removeEntity(this);
      curPlayer.character.coins += this.coins;
      dungeonCompleted();
    }
    void render() {
      image(chest, x, y);
    }
  }
}

class MazeDungeon extends DefaultDungeon {
  MazeDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }

  void tick() {
    super.tick();
    if (curPlayer.y <= 75) {
      dungeonCompleted();
    }
  }

  void setup() {

    // create a new player at the spawn location
    curPlayer = getPlayerOf(1000, 2400, info);

    // load in the world
    curWorld = getWorldOf("dungeon_maps/l2.txt", curPlayer);

    // add the zombies
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

    // start the background music
    playBackgroundMusic();
  }
}

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

    curWorld.addEnemy(new Skeleton(11*50, 5*50, skeletonWidth, skeletonHeight));

    playBackgroundMusic();

    addEnemiesToRoom1();
  }

  void tick() {
    super.tick();
    if (curWorld.enemies.size() == 0) {
      curRoom += 1;
      if (curRoom == 2) {
        addEnemiesToRoom2();
        curWorld.changeElement(21, 7, DungeonElement.Ground);
        curWorld.changeElement(21, 8, DungeonElement.Ground);
        curWorld.changeElement(21, 9, DungeonElement.Ground);
      } else if (curRoom == 3) {
        addEnemiesToRoom3();
        curWorld.changeElement(46, 7, DungeonElement.Ground);
        curWorld.changeElement(46, 8, DungeonElement.Ground);
        curWorld.changeElement(46, 9, DungeonElement.Ground);
      } else {
        dungeonCompleted();
      }
    }

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

  void addEnemiesToRoom1() {
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
          curWorld.addEnemy(new Skeleton(c, r, skeletonWidth, skeletonHeight));
        }
      }
    }
  }

  void addEnemiesToRoom2() {
    for (int c = 30 * 50; c <= 34*50; c += 50) {
      for (int r = 5 * 50; r <= 7*50; r += 50) {
        if (random(1) > 0.6) {
          curWorld.addEnemy(new Skeleton(c, r, skeletonWidth, skeletonHeight));
        }
      }
    }
    for (int c = 36 * 50; c <= 41*50; c += 50) {
      for (int r = 5 * 50; r <= 7*50; r += 50) {
        if (random(1) > 0.6) {
          curWorld.addEnemy(new Skeleton(c, r, skeletonWidth, skeletonHeight));
        }
      }
    }
  }

  void addEnemiesToRoom3() {
    for (int c = 56 * 50; c <=68*50; c += 50) {
      for (int r = 7 * 50; r <= 9*50; r += 50) {
        if (random(1) > 0.6) {
          curWorld.addEnemy(new Skeleton(c, r, skeletonWidth, skeletonHeight));
        }
      }
    }
    for (int c = 58* 50; c <= 66*50; c += 50) {
      for (int r = 2 * 50; r <= 5*50; r += 50) {
        if (random(1) > 0.6) {
          curWorld.addEnemy(new Skeleton(c, r, skeletonWidth, skeletonHeight));
        }
      }
    }
    for (int c = 56 * 50; c <= 66*50; c += 50) {
      for (int r = 11 * 50; r <= 15*50; r += 50) {
        if (random(1) > 0.6) {
          curWorld.addEnemy(new Skeleton(c, r, skeletonWidth, skeletonHeight));
        }
      }
    }
    for (int c = 70 * 50; c <= 70*50; c += 50) {
      for (int r = 2 * 50; r <= 15*50; r += 50) {
        if (random(1) > 0.6) {
          curWorld.addEnemy(new Skeleton(c, r, skeletonWidth, skeletonHeight));
        }
      }
    }
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

  final float dragonHealth = 700;
  final float dragonSlashDamage = 30;
  final static int dragonWidth=100, dragonHeight=50;
  final int dragonFPA=30;
  PImage dragon;

  final int fireballRadius = 15;
  final float fireballDespawnX = 18 * 50;
  final float fireballDamage = 10;
  final float fireballSpeed = 10;
  final float fireballTrailSize = 200;

  final float blowBackSpeed = 20;
  final float blowBackFrames = 30;
  float blowBackTimer;

  final int meleeGuardFPA=45;
  final static int meleeWidth=45, meleeHeight=50;
  final float meleeDamage=20, meleeAttackRange=5, meleeSightRange=300, meleeTargettedRange=550, meleeSpeed=2, meleeStartingHealth=70;
  PImage meleeRight, meleeLeft;

  final int rangedGuardFPA=30;
  final static int rangedWidth=20, rangedHeight=30;
  final float rangedDamage=10, rangedAttackRange=700, rangedSpeed=4, rangedStartingHealth=25, rangedProjectileSpeed=5;
  PImage rangedRight, rangedLeft;

  int curStage; // 0 for fighting guardians, 1 for fighting dragon

  ArrayList<Enemy> toSpawn;

  DragonBossDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }
  void setup() {
    lastLitFrame = -1000;
    dragon = dungeonDragonBoss;
    blowBackTimer = 0;

    meleeLeft = dungeonDragonBossGuardMeleeLeft;
    meleeRight = dungeonDragonBossGuardMeleeRight;

    rangedLeft = dungeonDragonBossGuardRangedLeft;
    rangedRight = dungeonDragonBossGuardRangedRight;

    curStage = 0;
    curPlayer = getPlayerOf(60, 8 * 50, info);
    curWorld = getWorldOf("dungeon_maps/dragon.txt", curPlayer);

    toSpawn = new ArrayList<Enemy>();
    playBackgroundMusic();
    fillGuardianRoom();
  }
  void tick() {
    super.tick();
    if (fireTimer <= 0) {
      if (curFrame - lastLitFrame <= fireFrames) {
        curPlayer.takeDamage(fireDamage);
        fireTimer = fireInterval;
      }
    } else {
      fireTimer--;
    }

    if (blowBackTimer > 0) {
      curWorld.moveEntity(curPlayer, -blowBackSpeed, 0);
      blowBackTimer--;
    }

    if (curWorld.enemies.size() == 0) {
      if (curStage == 0) {
        curWorld.changeElement(18, 7, DungeonElement.Ground);
        curWorld.changeElement(18, 8, DungeonElement.Ground);
        curWorld.changeElement(18, 9, DungeonElement.Ground);
        if (curPlayer.x > 19*50) {
          curStage = 1;
          curWorld.changeElement(18, 7, DungeonElement.Wall);
          curWorld.changeElement(18, 8, DungeonElement.Wall);
          curWorld.changeElement(18, 9, DungeonElement.Wall);
          curWorld.addEnemy(new Dragon(56*50, 8*50));
        }
      } else if (curStage == 1) {
        dungeonCompleted();
      }
    }

    if (toSpawn.size() > 0) {
      for (Enemy enemy : toSpawn) {
        curWorld.addEnemy(enemy);
      }
      toSpawn.clear();
    }
  }

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
    MeleeGuard(float x, float y) {
      super(x, y, meleeWidth, meleeHeight, meleeGuardFPA, meleeAttackRange, meleeSightRange, meleeTargettedRange, meleeDamage, meleeSpeed, meleeStartingHealth, meleeRight, meleeLeft);
    }
  }

  class RangedGuard extends RangedEnemy {
    float damage;
    float bulletSpeed;

    RangedGuard(float x, float y, int w, int h, int framesPerAttack, float range, float attack, float speed, float startingHealth, float bulletSpeed) {
      super(x, y, w, h, framesPerAttack, range, speed, startingHealth, rangedRight, rangedLeft);
      this.damage = attack;
      this.bulletSpeed = bulletSpeed;
    }
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

  class FireProjectile implements Projectile {
    float x, y;
    float startX, startY;
    float xDiff, yDiff;
    float existDist;
    float damage;

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
      this.x += xDiff;
      this.y += yDiff;
      if (curPlayer.inRange(x, y)) {
        curPlayer.takeDamage(damage);
        lastLitFrame = curFrame;
        curWorld.removeProjectile(this);
      }
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
      stroke(255, 0, 0);
      strokeWeight(2);
      line(-30, 0, 0, 0);

      fill(255, 0, 0);
      noStroke();
      ellipse(0, 0, 5, 5);
      popMatrix();
    }
  }

  class Dragon extends Enemy {
    int attackInterval;
    int rageAttackInterval;
    int attackTimer;
    float slashDamage;

    int curAttack; // identifier for the current attack (0 is fireball, 1 is strike, 2 is blowback, 3 is summon)

    Dragon(float x, float y, int w, int h, int attackInterval, float slashDamage) {
      super(x, y, w, h, dragonHealth);
      this.attackInterval = attackInterval;
      rageAttackInterval = attackInterval / 2;
      this.attackTimer = attackInterval;
      this.slashDamage = slashDamage;

      curAttack = 0;
    }

    Dragon(float x, float y) {
      this(x, y, dragonWidth, dragonHeight, dragonFPA, dragonSlashDamage);
    }

    void throwFireball() {
      curWorld.addProjectile(new DragonFireball(this.centerX(), curPlayer.centerY()));
    }
    void spawnMinions() {
      for (float x = 35*50; x <= 39*50; x += 60) {
        for (float y = 7*50; y <= 9 * 50; y += 50) {
          Skeleton toAdd = new Skeleton(x, y, skeletonWidth, skeletonWidth, 10000, 10000);
          toAdd.seesPlayer = true;
          toSpawn.add(toAdd);
        }
      }
    }

    void tick() {
      if (attackTimer <= 0) {
        attackTimer = attackInterval;
        curAttack = (curAttack + 1) % 4;

        if (curAttack == 0) {
          throwFireball();
        } else if (curAttack == 1) {
          if (curPlayer.distance(this) <= 400) {
            curWorld.addProjectile(new DragonSlash(slashDamage));
          } else {
            throwFireball();
          }
        } else if (curAttack == 2) {
          if (this.distance(curPlayer) <= 200) {
            blowBackTimer = blowBackFrames;
          } else {
            throwFireball();
          }
        } else if (curAttack == 3) {
          spawnMinions();
        } else {
          println("Invalid attack for dragon!");
        }
      } else {
        attackTimer--;
      }
      if (this.health <= this.maxHealth / 2) {
        this.attackInterval = rageAttackInterval;
      }
    }
    void render() {
      image(dragon, x, y);
      this.drawHealthBar(this.x, this.y - 10, w, 10);

      // draw text for the attack number
      textFont(dungeonDragonAttackFont);
      fill(255);
      textAlign(CENTER);
      text((curAttack + 1), centerX(), y + h + 6);
    }
  }

  class DragonFireball implements Projectile {
    float cx, cy;
    int r;
    float deadX;
    float speed;
    float damage;

    float fireTrailStartX;
    final float checkAngleInc = PI / 16;

    boolean damagedPlayer;
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
    DragonFireball(float x, float y) {
      this(x, y, fireballRadius, fireballDespawnX, fireballSpeed, fireballDamage);
    }
    void tick() {
      if (abs(fireTrailStartX - cx) > fireballTrailSize) {
        fireTrailStartX = cx + fireballTrailSize;
      } 

      if (cx <= deadX) {
        fireTrailStartX -= speed; 
        if (fireTrailStartX < cx) {
          curWorld.removeProjectile(this);
        }
      } else {
        this.cx -= speed;
      }
      for (float angle = 0; angle < 2 * PI; angle += checkAngleInc) {
        if (curPlayer.inRange(cx + cos(angle) * this.r, cy + sin(angle) * this.r) && !damagedPlayer) {
          curPlayer.takeDamage(this.damage);
          damagedPlayer = true;
          lastLitFrame = curFrame;
        }
        if (curPlayer.hitsBox(cx, cy - r, abs(fireTrailStartX - cx), 2 * r)) {
          lastLitFrame = curFrame;
        }
      }
    }
    void render() {
      fill(255, 137, 10, 100);
      noStroke();
      rect(cx, cy - r, abs(fireTrailStartX - cx), 2 * r);

      fill(255, 0, 0, 255);
      stroke(255, 255, 0);
      strokeWeight(2);
      ellipse(cx, cy, 2 * r, 2 * r);
    }
  }

  class DragonSlash implements Projectile {
    final int animationFrames = 5;
    int slashFrame;
    DragonSlash(float damage) {
      slashFrame = 0;
      curPlayer.takeDamage(damage);
    }
    void tick() {
      if (slashFrame > animationFrames) {
        curWorld.removeProjectile(this);
      } else {
        slashFrame += 1;
      }
    }
    void render() {
      float lx = 30 / animationFrames * slashFrame;
      float ly = 30 / animationFrames * slashFrame;

      float sideX = 20 / animationFrames * slashFrame;
      float sideY = 20 / animationFrames * slashFrame;
      line(curPlayer.centerX() - 15, curPlayer.centerY() - 15, curPlayer.centerX() - 15 + lx, curPlayer.centerY() - 15 + ly);
      line(curPlayer.centerX() - 10, curPlayer.centerY() - 20, curPlayer.centerX() - 10 + sideX, curPlayer.centerY() - 20 + sideY);
      line(curPlayer.centerX() - 10, curPlayer.centerY(), curPlayer.centerX() - 10 + sideX, curPlayer.centerY() + sideY);
    }
  }
}

class SerpantBossDungeon extends DefaultDungeon {
  final int waterEffectFrames = 30;
  float waterSpeedRatio = 0.5;
  int waterSlowTimer;

  final int poisonFrames = 360;
  float poisonDamage = 0.5;
  int lastPoisonFrame;

  PImage waterSprite;

  WaterWorld curWaterWorld;

  PImage rangedRight, rangedLeft;
  final float rangedHealth=40, rangedBulletDamage=10, rangedBulletSpeed=15, rangedRange=900, rangedSpeed=4;
  final static int rangedWidth=15, rangedHeight=30;
  final int rangedFPA=20;
  float rangedOnWaterDamageReduction = 0.7;

  int curDungeonState; // 0 for round 1, 1 for round 2, 2 for if we wait for player to go to next room, 3 for boss fight

  PImage snakeUp, snakeDown;
  final static int snakeWidth=50, snakeHeight=150;
  final int snakeVenomFPA=10, snakeSmashFPA=25, snakeSummonFPA=60;
  final float snakeHealth=700, snakeVenomSpeed=15, snakeSmashSpeed=50, snakeSmashDamage=60;

  ArrayList<Enemy> enemiesToAdd;

  SerpantBossDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }
  void setup() {
    curPlayer = getPlayerOf(50, 8*50, info);
    curWaterWorld = getWaterWorldOf("dungeon_maps/serpant.txt", curPlayer);
    curWorld = curWaterWorld;

    waterSprite = dungeonWaterSprite;

    rangedRight = dungeonSnakeBossGuardRangedRight;
    rangedLeft = dungeonSnakeBossGuardRangedLeft;

    snakeUp = dungeonSnakeBossUp;
    snakeDown = dungeonSnakeBossDown;

    enemiesToAdd = new ArrayList<Enemy>();

    spawnGuardianRoom1();
    curDungeonState = 0;

    playBackgroundMusic();
  }
  void tick() {
    super.tick();
    waterSlowTimer--;
    if (curWaterWorld.touchingWater(curPlayer)) {
      waterSlowTimer = waterEffectFrames;
    }
    if (curWorld.enemies.size() == 0) {
      if (curDungeonState == 0) {
        spawnGuardianRoom2();
        curDungeonState = 1;
      } else if (curDungeonState == 1) {
        curWorld.changeElement(23, 7, DungeonElement.Ground);
        curWorld.changeElement(23, 8, DungeonElement.Ground);
        curWorld.changeElement(23, 9, DungeonElement.Ground);
        curDungeonState = 2;
      } else if (curDungeonState == 3) {
        dungeonCompleted();
      }
    }
    if (curDungeonState == 2 && curPlayer.x > 27*50) {
      curWorld.addEnemy(new SerpantBoss(random(27*50, 49*50 - snakeWidth), random(2*50, 18*50 - snakeHeight)));
      curWorld.changeElement(26, 7, DungeonElement.Wall);
      curWorld.changeElement(26, 8, DungeonElement.Wall);
      curWorld.changeElement(26, 9, DungeonElement.Wall);
      curDungeonState = 3;
    }
    if (curFrame - lastPoisonFrame <= poisonFrames) {
      curPlayer.takeDamage(poisonDamage);
    }

    for (Enemy enemy : enemiesToAdd) {
      curWorld.addEnemy(enemy);
    }
    enemiesToAdd.clear();
  }

  void spawnRangedGuardInRange(int fx, int fy, int sx, int sy, float xIncrement, float yIncrement, float probability) {
    for (float x = fx; x <= sx; x += xIncrement)
      for (float y = fy; y <= sy; y += yIncrement) {
        float num = random(1);
        if (num > 1 - probability) {
          curWorld.addEnemy(new RangedGuard(x, y));
        }
      }
  }

  void spawnGuardianRoom1() {
    spawnRangedGuardInRange(2*50, 2 * 50, 13*50, 3*50, 100, 100, 0.7);
    spawnRangedGuardInRange(2*50, 14*50, 13*50, 15*50, 100, 100, 0.7);
    spawnRangedGuardInRange(20*50, 3 * 50, 22*50, 15*50, 100, 100, 0.4);
    spawnRangedGuardInRange(9*50, 8 * 50, 13*50, 12*50, 50, 50, 0.4);
  }

  void spawnGuardianRoom2() {
    spawnRangedGuardInRange(2*50, 2 * 50, 13*50, 3*50, 100, 100, 1);
    spawnRangedGuardInRange(2*50, 14*50, 13*50, 15*50, 100, 100, 1);
    spawnRangedGuardInRange(20*50, 3 * 50, 22*50, 15*50, 100, 100, 1);
    spawnRangedGuardInRange(9*50, 8 * 50, 13*50, 12*50, 50, 50, 1);
  }

  class SerpantBoss extends Enemy {
    int venomFPA, smashFPA, summonFPA;
    int lastVenomFrame, lastSmashFrame, lastSummonFrame;
    float venomSpeed, smashSpeed;
    float smashDamage;

    boolean damagedPlayer;
    Direction direction;

    PImage up, down;

    int curState; // 0 for invisible, 1 for in middle of smash

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

    SerpantBoss(float x, float y) {
      this(x, y, snakeWidth, snakeHeight, snakeHealth, snakeVenomFPA, snakeSmashFPA, snakeSummonFPA, snakeVenomSpeed, snakeSmashSpeed, snakeSmashDamage);
    }
    void tick() {
      if (curFrame - lastSummonFrame >= summonFPA) {
        summon();
        lastSummonFrame = curFrame;
      }

      if (curFrame - lastVenomFrame >= venomFPA) {
        shootProjectile();
      }
      if (curState == 1) {
        if (direction == Direction.down) {
          y += smashSpeed;
        } else if (direction == Direction.up) {
          y -= smashSpeed;
        } else {
          println("direction is not down or up for snake boss");
        }

        if (this.collided(curPlayer) && !damagedPlayer) {
          curPlayer.takeDamage(smashDamage);
          this.damagedPlayer = true;
        }
      }

      setState();
    }
    void summon() {
      for (int x = 35*50; x <= 37*50; x += 50) {
        for (int y = 7*50; y <= 9*50; y += 50) {
          Skeleton toAdd = new Skeleton(x, y, skeletonWidth, skeletonHeight);
          toAdd.seesPlayer = true;
          enemiesToAdd.add(toAdd);
        }
      }
    }

    void setState() {
      if (curState == 0) {
        if (curFrame - lastSmashFrame >= smashFPA) {
          curState = 1;
          if (direction == Direction.down)
            direction = Direction.up;
          else
            direction = Direction.down;

          this.x = min(49*50 - this.w, max(27*50, curPlayer.centerX() - this.w / 2));
          if (direction == Direction.up) {
            this.y = 18*50 - this.h;
          } else {
            this.y = 2*50;
          }

          damagedPlayer = false;
        }
      } else if (curState == 1) {
        if (direction == Direction.up && this.y < 2 * 50 || direction == Direction.down && this.y > 18*50 - this.h) {
          curState = 0;
        }

        lastSmashFrame = curFrame;
      }
    }
    void shootProjectile() {
      float xDiff = curPlayer.centerX() - this.centerX();
      float yDiff = curPlayer.centerY() - this.centerY();
      float mag = magnitude(xDiff, yDiff);
      curWorld.addProjectile(new Venom(centerX(), centerY(), xDiff / mag * venomSpeed, yDiff / mag * venomSpeed));
      lastVenomFrame = curFrame;
    }
    void render() {
      if (direction == Direction.up) {
        image(up, x, y);
      } else if (direction == Direction.down) {
        image(down, x, y);
      }

      drawHealthBar(this.x, this.y - 11, this.w, 10);
    }
  }

  class Venom implements Projectile {
    float x, y;
    float xDiff, yDiff;

    Venom(float x, float y, float xDiff, float yDiff) {
      this.x = x;
      this.y = y;
      this.xDiff = xDiff;
      this.yDiff = yDiff;
    }
    void tick() {
      this.x += xDiff;
      this.y += yDiff;
      if (curPlayer.inRange(x, y)) {
        lastPoisonFrame = curFrame;
        curWorld.removeProjectile(this);
      }
    }
    void render() {
      fill(#0EFF03);
      noStroke();
      ellipse(x, y, 10, 10);
    }
  }

  class WaterWorld extends DungeonWorld {
    boolean[][] water;
    WaterWorld(DungeonElement[][] elements, boolean[][] walkable, boolean[][] water, DungeonPlayer player) {
      super(elements, walkable, player);
      this.water = water;
    }
    void moveEntitySoft(Entity toMove, float xDiff, float yDiff) {
      if (toMove == curPlayer && waterSlowTimer > 0) {
        xDiff *= waterSpeedRatio;
        yDiff *= waterSpeedRatio;
      }
      super.moveEntitySoft(toMove, xDiff, yDiff);
    }

    boolean touchingWater(Entity query) {
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

  class RangedGuard extends RangedEnemy {
    float bulletSpeed, bulletDamage;

    RangedGuard(float x, float y, int w, int h, int framesPerAttack, float range, float speed, float startingHealth, float bulletSpeed, float bulletDamage) {
      super(x, y, w, h, framesPerAttack, range, speed, startingHealth, rangedRight, rangedLeft);
      this.bulletSpeed = bulletSpeed;
      this.bulletDamage = bulletDamage;
    }

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

    void takeDamage(float amount) {
      if (curWaterWorld.touchingWater(this))
        amount *= rangedOnWaterDamageReduction;
      super.takeDamage(amount);
    }
  }

  class WaterBullet implements Projectile {
    float x, y;
    float xDiff, yDiff;
    float damage;
    WaterBullet(float x, float y, float xDiff, float yDiff, float damage) {
      this.x = x;
      this.y = y;
      this.xDiff = xDiff;
      this.yDiff = yDiff;
      this.damage = damage;
    }

    void tick() {
      x += xDiff;
      y += yDiff;

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

      fill(#03FCF6);
      noStroke();
      ellipse(0, 0, 7, 7);

      stroke(#03FCF6);
      strokeWeight(3);
      line(-10, 0, 0, 0);

      popMatrix();
    }
  }

  WaterWorld getWaterWorldOf(String filePath, DungeonPlayer curPlayer) {
    String[] lines = loadStrings(filePath);
    int rows = Integer.parseInt(lines[0].split(" ")[0]);
    int cols = Integer.parseInt(lines[0].split(" ")[1]);

    DungeonElement[][] elements = new DungeonElement[rows][cols];
    boolean[][] walkable = new boolean[rows][cols];
    boolean[][] water = new boolean[rows][cols];
    for (int r = 0; r < rows; ++r) {
      for (int c = 0; c < cols; ++c) {
        char cur = lines[r + 1].charAt(c);
        water[r][c] = (cur == 'L');
        walkable[r][c] = (cur == 'G' || cur == 'L');

        if (cur == 'E') {
          elements[r][c] = DungeonElement.Empty;
        } else if (cur == 'W') {
          elements[r][c] = DungeonElement.Wall;
        } else {
          elements[r][c] = DungeonElement.Ground;
        }
      }
    }

    return new WaterWorld(elements, walkable, water, curPlayer);
  }
}

class GiantBossDungeon extends DefaultDungeon {
  PImage guardRight, guardLeft;

  final static int giantGuardWidth=45, giantGuardHeight=50;
  final int giantGuardFPA=30;
  final float giantGuardRange=5, giantGuardSightRange=300, giantGuardPlayerTargettedRange=600, giantGuardDamage=40, giantGuardSpeed=3, giantGuardHealth=400;

  PImage giant;
  final static int giantWidth=123, giantHeight=100;
  final int giantFPA=30, giantKnockbackFrames=15, giantNumDaggers=10, giantBoulderDamageInterval=15, giantBoulderEF=120, giantDaggerEF=20;
  final float giantBoulderDamage=30, giantDaggerDamage=10, giantSmashDamage=60, giantKnockbackSpeed=15, giantHealth=1000, giantSpeed=3, giantSmashRange=125, giantBoulderSpeed=5, giantDaggerSpeed=18, giantBoulderRadius=40, giantDaggerAngleVariation=PI/10;

  int curState; // 0 for guards, 1 for guards completed (still moving to the next room), 2 for boss fight

  GiantBossDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }
  void setup() {
    curPlayer = getPlayerOf(60, 8*50, info);
    curWorld = getWorldOf("dungeon_maps/giant.txt", curPlayer);

    guardRight = dungeonGiantBossGuardMeleeRight;
    guardLeft = dungeonGiantBossGuardMeleeLeft;

    giant = dungeonGiantBoss;

    curState = 0;
    guardRoom();

    playBackgroundMusic();
  }
  void tick() {
    super.tick();

    println(curWorld.entities.size());

    if (curState == 0 && curWorld.enemies.size() == 0) {
      curState = 1;
      curWorld.changeElement(23, 7, DungeonElement.Ground);
      curWorld.changeElement(23, 8, DungeonElement.Ground);
      curWorld.changeElement(23, 9, DungeonElement.Ground);
    }
    if (curState == 1 && curPlayer.x > 27*50) {
      curState = 2;
      curWorld.changeElement(26, 7, DungeonElement.Wall);
      curWorld.changeElement(26, 8, DungeonElement.Wall);
      curWorld.changeElement(26, 9, DungeonElement.Wall);

      curWorld.addEnemy(new Giant(38*50, 6*50));
    }
    if (curState == 2 && curWorld.enemies.size() == 0) {
      dungeonCompleted();
    }
  }

  class Giant extends Enemy {
    int framesPerAttack;
    int knockbackFrames;
    float knockbackSpeed;
    float boulderDamage, daggerDamage, smashDamage;
    float speed;
    int numDaggers;
    float smashRange;

    int boulderExistFrames;
    int boulderDamageInterval;
    float boulderSpeed;
    float boulderRadius;

    float daggerSpeed;
    int daggerExistFrames;
    float daggerAngleVariation;

    int attackTimer;
    int curAttack; // 0 for smash, 1 for boulder, 2 for dagger
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
    Giant(float x, float y) {
      this(x, y, giantWidth, giantHeight, giantHealth, giantFPA, giantKnockbackFrames, giantKnockbackSpeed, giantBoulderDamage, giantDaggerDamage, giantSmashDamage, giantSpeed, giantNumDaggers, giantSmashRange, giantBoulderDamageInterval, 
        giantBoulderEF, giantBoulderRadius, giantBoulderSpeed, giantDaggerSpeed, giantDaggerEF, giantDaggerAngleVariation);
    }
    void tick() {
      float xDiff = curPlayer.centerX() - this.centerX();
      float yDiff = curPlayer.centerY() - this.centerY();
      float mag = magnitude(xDiff, yDiff);

      curWorld.moveEntitySoft(this, xDiff / mag * speed, yDiff / mag * speed);

      attackTimer -= 1;
      if (attackTimer <= 0) {
        if (curAttack == 0) {
          curWorld.addProjectile(new Smash(this.centerX(), this.centerY(), this.knockbackFrames, this.knockbackSpeed, this.boulderDamage, this.smashRange));
          curAttack = 1;
        } else if (curAttack == 1) {
          curWorld.addProjectile(new Boulder(this.centerX(), this.centerY(), xDiff / mag * boulderSpeed, yDiff / mag * boulderSpeed, boulderRadius, boulderExistFrames, boulderDamage, boulderDamageInterval));
          curAttack = 2;
        } else if (curAttack == 2) {
          for (int i = 0; i < numDaggers; ++i) {
            float toPlayer = angleOf(xDiff, yDiff);
            float daggerAngle = toPlayer + random(-daggerAngleVariation, daggerAngleVariation);
            curWorld.addProjectile(new Dagger(centerX(), centerY(), daggerSpeed * cos(daggerAngle), daggerSpeed * sin(daggerAngle), daggerDamage));
          }
          curAttack = 0;
        }

        attackTimer = framesPerAttack;
      }
    }
    void render() {
      image(giant, x, y);
      drawHealthBar(x, y - 11, w, 10);
    }
  }

  class Dagger implements Projectile {
    float x, y;
    float xDiff, yDiff;
    float damage;
    Dagger(float x, float y, float xDiff, float yDiff, float damage) {
      this.x = x;
      this.y = y;
      this.xDiff = xDiff;
      this.yDiff = yDiff;
      this.damage = damage;
    }
    void tick() {
      x += xDiff;
      y += yDiff;
      if (curPlayer.inRange(x, y)) {
        curPlayer.takeDamage(damage); 
        curWorld.removeProjectile(this);
      }
    }
    void render() {
      pushMatrix();
      translate(x, y);
      rotate(angleOf(xDiff, yDiff));
      fill(0, 255, 0);
      noStroke();
      triangle(-10, -5, 0, 0, -10, 5);
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
