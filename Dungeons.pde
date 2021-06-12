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
      curChest = new Chest(78*50, 8 * 50, 80, 50, (int) random(300, 400));
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
      chest = loadImage("sprites/dungeon/chest.png");
      chest.resize(w, h);
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
  final float fireDamage = 5; // the damage of the fire
  int lastLitFrame; // the last frame in which the fire was lit 
  int fireTimer; // a timer variable for when to check to see if the fire was lit

  final float dragonHealth = 700;
  final float dragonSlashDamage = 30;
  final int dragonWidth=100, dragonHeight=50;
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

  final int meleeGuardFPA=45, meleeWidth=45, meleeHeight=50;
  final float meleeDamage=20, meleeAttackRange=5, meleeSightRange=300, meleeTargettedRange=550, meleeSpeed=2, meleeStartingHealth=70;
  PImage meleeRight, meleeLeft;

  final int rangedGuardFPA=30, rangedWidth=20, rangedHeight=30;
  final float rangedDamage=10, rangedAttackRange=700, rangedSpeed=4, rangedStartingHealth=25, rangedProjectileSpeed=5;
  PImage rangedRight, rangedLeft;

  int curStage; // 0 for fighting guardians, 1 for fighting dragon

  ArrayList<Enemy> toSpawn;

  DragonBossDungeon(EnvironmentState previous, PlayerInfo character) {
    super(previous, character);
  }
  void setup() {
    lastLitFrame = -1000;
    dragon = loadImage("sprites/dungeon/dragon.png");
    dragon.resize(dragonWidth, dragonHeight);
    blowBackTimer = 0;

    meleeLeft = loadImage("sprites/dungeon/dragonGuardMelee_left.png");
    meleeRight = loadImage("sprites/dungeon/dragonGuardMelee_right.png");

    rangedLeft = loadImage("sprites/dungeon/dragonGuardRanged_left.png");
    rangedRight = loadImage("sprites/dungeon/dragonGuardRanged_right.png");

    meleeLeft.resize(meleeWidth, meleeHeight);
    meleeRight.resize(meleeWidth, meleeHeight);
    rangedLeft.resize(rangedWidth, rangedHeight);
    rangedRight.resize(rangedWidth, rangedHeight);

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

  class RangedGuard extends Enemy {
    float range, damage, framesPerAttack;
    float optimalDist;
    float speed;
    float lastAttackFrame;
    float bulletSpeed;
    Direction playerSide;

    RangedGuard(float x, float y, int w, int h, int framesPerAttack, float range, float attack, float speed, float startingHealth, float bulletSpeed) {
      super(x, y, w, h, startingHealth);
      this.framesPerAttack = framesPerAttack;
      this.range = range;
      this.damage = attack;
      this.speed = speed;
      optimalDist = range / 2;
      lastAttackFrame = -1000;
      this.bulletSpeed = bulletSpeed;
      this.playerSide = Direction.right;
    }
    RangedGuard(float x, float y) {
      this(x, y, rangedWidth, rangedHeight, rangedGuardFPA, rangedAttackRange, rangedDamage, rangedSpeed, rangedStartingHealth, rangedProjectileSpeed);
    }
    void tick() {
      if (curPlayer.distance(this) < range) {
        float xDiff = curPlayer.centerX() - this.centerX();
        float yDiff = curPlayer.centerY() - this.centerY();
        float mag = magnitude(xDiff, yDiff);
        if (xDiff > 0) {
          playerSide = Direction.right;
        } else {
          playerSide = Direction.left;
        }
        if (curPlayer.distance(this) > optimalDist) {
          curWorld.moveEntity(this, speed * xDiff / mag, speed * yDiff / mag);
        }
        if (curFrame - lastAttackFrame >= framesPerAttack) {
          lastAttackFrame = curFrame;
          curWorld.addProjectile(new FireProjectile(centerX(), centerY(), bulletSpeed * xDiff / mag, bulletSpeed * yDiff / mag, range, this.damage));
        }
      }
    }
    void render() {
      if (playerSide == Direction.right) {
        image(rangedRight, x, y);
      } else {
        image(rangedLeft, x, y);
      }
      this.drawHealthBar(x, y - 7, w, 5);
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
      textFont(createFont("Arial", 16));
      textSize(14);
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
    final int animationFrames=4;
    int curFrame;
    DragonSlash(float damage) {
      curFrame = 0;
      curPlayer.takeDamage(damage);
    }
    void tick() {
      if (curFrame > animationFrames) {
        curWorld.removeProjectile(this);
      }else{
       curFrame += 1; 
      }
    }
    void render() {
      float lx = 30 / animationFrames * curFrame;
      float ly = 30 / animationFrames * curFrame;
      line(curPlayer.centerX() - 15, curPlayer.centerY() - 15, curPlayer.centerX() - 15 + lx, curPlayer.centerY() - 15 + ly);
    }
  }
}
