enum DungeonElement {
  Wall, Ground, Empty
};

enum Direction {
  left, right, up, down
};


// The main interface for a projectile; it's mostly used for program structure purposes
interface Projectile {
  abstract void tick();
  abstract void render();
}  

abstract class DefaultDungeon extends DungeonState {
  // defaults for goblins
  final static int goblinWidth = 30, goblinHeight = 30;
  final int goblinHealth = 15;
  final int framesPerGoblinAttack = 30;
  final int goblinAttack = 2;
  final int goblinSpeed = 6;

  // defaults for zombies
  final static int zombieWidth = 30, zombieHeight = 30;
  final int zombieHealth = 20;
  final int framesPerZombieAttack = 60;
  final float zombieAttack = 10;
  final float zombieSpeed = 1;

  // defaults for skeletons
  final static int skeletonWidth = 30, skeletonHeight = 30;
  final int skeletonHealth = 30;
  final int framesPerSkeletonAttack = 45;
  final float skeletonAttack = 15;
  final float skeletonSpeed = 4;

  // defaults for boss skeleton
  final static int skelKnightWidth=30, skelKnightHeight=30;
  final static int skelKnightHealth=45, framesPerSkelKnightAttack=30, skelKnightAtkRange=10, skelKnightSightRange=800;
  final float skelKnightAtk=20, skelKnightSpeed=5;

  DungeonWorld curWorld; // the current world
  DungeonPlayer curPlayer; // the current player
  PlayerInfo info; // the information on the player
  int curFrame; // a common variable for the current frame

  float sightRangeIncrease = 1.0/6 * 5/3; // the speed at which the sight range of enemies increases in form (blocks / seconds * (constant rate))

  abstract void setup();

  // function for when the dungeon is completed
  void dungeonCompleted() {
    curState = new LevelCompletedState(this);
    storyDungeonsCompleted++;
  }
  // function for when the dungeon is exited
  void dungeonExited() {
    changeEnvironment(previous);
  }
  // Player death mechanics
  void playerDied() {
    // revive the player slightly, giving them a few health buffs
    curWorld.player.character.health = min(curWorld.player.character.maxHealth, 10);
    curState = new DeadScreen(previous, info.playerClass);
  }

  // when the state is exited
  void exitState() {
    stopBackgroundMusic();
  }
  void enterState() {
    playBackgroundMusic();
  }

  void playBackgroundMusic() {
    dungeonBGM.loop();
  }

  void stopBackgroundMusic() {
    dungeonBGM.stop();
  }

  // called when the mouse is pressed
  void mousePressed() {
    if (mouseButton == LEFT) {
      curPlayer.attack1();
      curPlayer.attackSpriteUpdate();
    } else if (mouseButton == RIGHT) {
      curPlayer.attack2();
      curPlayer.attackSpriteUpdate();
    }
  }

  DefaultDungeon(EnvironmentState previous, PlayerInfo character) {
    // initialize variables
    super(previous);
    this.curFrame = 0;
    this.info = character;

    this.setup();
  }

  // tick method - updating per frame
  void tick() {
    // increase the current frame
    curFrame++;
    // get the world to render its logic
    curWorld.tick();

    // move the player based on what is pressed down
    if (isPressed['w'] || codePressed[UP]) {
      curWorld.player.moveUp();
    }
    if (isPressed['a'] || codePressed[LEFT]) {
      curWorld.player.moveLeft();
    }
    if (isPressed['s'] || codePressed[DOWN]) {
      curWorld.player.moveDown();
    }
    if (isPressed['d'] || codePressed[RIGHT]) {
      curWorld.player.moveRight();
    }
  }

  // render function - drawing onto the screen
  void render() {
    curWorld.render();
    drawOverlays();
  }

  // draws the overlays and adds more info on 
  void drawOverlays() {
    // draw a health bar
    float barWidth = 200;
    float filledWidth = barWidth * curPlayer.character.health / curPlayer.character.maxHealth;
    fill(0, 0, 0, 0);
    stroke(255);
    strokeWeight(2);
    rect(10, 10, barWidth, 20);
    fill(255, 0, 0);
    rect(10, 10, filledWidth, 20);

    // draw cooldowns for the two attacks
    //   variables for the size of the indicator circles
    float attackIndicatorRadius = 50;
    float center1 = 10+barWidth+40;
    float center2 = 10+barWidth+100;
    //   draw indicator circles 
    fill(#00C4C9);
    noStroke();
    ellipse(center1, 30, attackIndicatorRadius, attackIndicatorRadius);
    ellipse(center2, 30, attackIndicatorRadius, attackIndicatorRadius);
    //   fill in circles based on cooldown
    fill(255, 255, 255, 100);
    float firstAngle = 2 * PI * (curFrame - curPlayer.lastAttackFrame1) / curPlayer.character.framesBetweenA1;
    float secondAngle = 2 * PI * (curFrame - curPlayer.lastAttackFrame2) / curPlayer.character.framesBetweenA2;
    arc(center1, 30, attackIndicatorRadius, attackIndicatorRadius, 0, firstAngle);
    arc(center2, 30, attackIndicatorRadius, attackIndicatorRadius, 0, secondAngle);
  }

  // DUNGEON WORLD CODE - MORE OR LESS FOCUSING ON THE WORLD ITSELF ----------------------------------------------------------------------------

  // The main class for a "dungeon world"
  class DungeonWorld extends World {
    ArrayList<Enemy> enemies; // The enemies in this world
    ArrayList<Projectile> projectiles; // the projectiles in this world
    DungeonPlayer player; // the main player
    DungeonElement[][] tileMap; // The floor and walls are rendered as a bunch of "tiles"; this stores the tiles

    PImage ground, wall, empty; // The different images for the different types of tiles
    ArrayList<Entity> removeEntities; // We remove dead enemies at the end of each tick function, allowing us to avoid concurrentModificationException
    ArrayList<Projectile> removedProjectiles; // same as above, but for projectiles that have been hit

    DungeonWorld(DungeonElement[][] elements, boolean[][] walkable, DungeonPlayer player) {
      // The world includes the "walkable areas"
      super(walkable);
      // initialize the players, tilemap, and lists
      this.player = player;
      addEntity(this.player);
      this.tileMap = elements;
      this.enemies = new ArrayList<Enemy>();
      this.projectiles = new ArrayList<Projectile>();
      this.removeEntities = new ArrayList<Entity>();
      this.removedProjectiles = new ArrayList<Projectile>();

      // load in the assets for the ground and wall
      this.ground = dungeonGroundSprite;
      this.wall = dungeonWallSprite;
      this.empty = dungeonEmptySprite;
    }
    // Called at the start of each frame. This is the "logic" part of each frame
    void tick() {
      // Gets the players, enemies and projectiles to do whatever they're supposed to do each frame. Make sure that if an entity is supposed to be removed, that we don't let them tick
      player.tick();
      for (Enemy e : enemies)
        if (!removeEntities.contains(e))
          e.tick();
      for (Projectile p : projectiles)
        if (!removedProjectiles.contains(p))
          p.tick();

      // remove all of the entities
      for (Entity toRemove : removeEntities) {
        enemies.remove(toRemove);
        entities.remove(toRemove);
      }
      // remove all of the projectiles
      for (Projectile toRemove : removedProjectiles) {
        projectiles.remove(toRemove);
      }

      // since all elements needed have been removed, we can clear these lists
      removeEntities.clear();
      removedProjectiles.clear();
    }

    // Called after tick in each frame. "draws" everything onto the screen
    void render() {
      // center the camera on the player
      camera.centerOnEntity(player);
      pushMatrix();
      // move the camera(matrix) so that every element drawn in the "current world" will be placed at the screen in the correct position
      camera.alterMatrix();

      // draw the tiles
      drawTiles();

      // get all of the enemies to draw themselves
      for (Enemy e : enemies)
        e.render();
      // draw the player
      player.render();
      // get all of the projectiles to draw themselves
      for (Projectile p : projectiles)
        p.render();

      // since the world has been drawn, anything else that must be drawn won't be in the world, and so won't need to be affected by the camera
      popMatrix();
    }

    // draws the tiles of the map
    void drawTiles() {
      // for each row and column, see what the current element is and draw it in its position
      for (int r = 0; r < tileMap.length; ++r) {
        for (int c = 0; c < tileMap[r].length; ++c) {
          if (tileMap[r][c] == DungeonElement.Ground) {
            image(ground, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == DungeonElement.Empty) {
            image(empty, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == DungeonElement.Wall) {
            image(wall, gridSize * c, gridSize * r);
          } else {
            println("Somehow the current dungeon element isn't the ground, empty, or a wall!");
          }
        }
      }
    }

    // add an enemy to this world
    void addEnemy(Enemy toAdd) {
      this.enemies.add(toAdd);
      addEntity(toAdd);
    }

    // add a projectile to this world
    void addProjectile(Projectile toAdd) {
      this.projectiles.add(toAdd);
    }

    // remove an Entity from this world (usually when an enemy dies)
    void removeEntity(Entity toRemove) {
      removeEntities.add(toRemove);
    }

    // remove a projectile from this world
    void removeProjectile(Projectile toRemove) {
      removedProjectiles.add(toRemove);
    }

    // A boolean for whether or not an entity is touching the wall
    boolean touchingWall(Entity query) {
      // get which "path squares" are within the range of the player
      int startX = (int) (query.x / gridSize);
      int startY = (int) (query.y / gridSize);
      int endX = (int) ((query.x + query.w) / gridSize);
      int endY = (int) ((query.y + query.h) / gridSize);

      // for each tile in its range, if it's a "wall" and the entity is currently collided with it, return true.
      for (int y = max(0, startY - 1); y <= min(walkable.length - 1, endY + 1); ++y)
        for (int x = max(0, startX - 1); x <= min(walkable[y].length - 1, endX + 1); ++x)
          if (!walkable[y][x] &&  
            boxCollided(query.x, query.y, query.w, query.h, x * gridSize, y * gridSize, gridSize, gridSize))
            return true;
      return false;
    }

    // A boolean for whether or not a box is touching the wall
    boolean touchingWall(float x, float y, float w, float h) {
      // get which "path squares" are within the range of the box
      int startX = (int) (x / gridSize);
      int startY = (int) (y / gridSize);
      int endX = (int) ((x + w) / gridSize);
      int endY = (int) ((y + h) / gridSize);

      // for each tile in its range, if it's a "wall" and the entity is currently collided with it, return true.
      for (int sy = max(0, startY - 1); sy <= min(walkable.length - 1, endY + 1); ++sy)
        for (int sx = max(0, startX - 1); sx <= min(walkable[sy].length - 1, endX + 1); ++sx)
          if (!walkable[sy][sx] &&  
            boxCollided(x, y, w, h, x * gridSize, y * gridSize, gridSize, gridSize))
            return true;
      return false;
    }

    // return the enemy that the current entity is touching, if any. If not, return null  
    Enemy touchingEnemy(Entity query) {
      // Loop through each of the enemies. If the current entity is touching any of them, return it
      for (Enemy other : this.enemies)
        if (query.collided(other))
          return other;
      // otherwise, return null (nothing)
      return null;
    }

    void changeElement(int c, int r, DungeonElement newElement) {
      tileMap[r][c] = newElement; 
      if (tileMap[r][c] == DungeonElement.Ground) {
        walkable[r][c] = true;
      } else {
        walkable[r][c] = false;
      }
    }
  }

  // DIFFERENT TYPES OF PROJECTILES ----------------------------------------------------------------------------

  //    KNIGHT ATTACKS
  class KnightShortSlash implements Projectile {
    // The slash starts at startAngle and ends at curAngle. The slash moves in a circle with radius [radius], and when hit, does [damage] damage
    // curAngle is used to keep track of the current angle of the drawn arc
    float startAngle, curAngle, endAngle, radius, damage;

    // the intervals at which to check for enemies
    final float angIncrease = PI / 64;
    // The speed at which the angle should be animated
    final float animateAngleSpeed = PI / 4;
    KnightShortSlash(float startAngle, float endAngle, float radius, float damage) {
      // initialize the values
      this.startAngle = startAngle;
      this.curAngle = startAngle;
      this.endAngle = endAngle;
      this.radius = radius;
      this.damage = damage;

      // for each enemy, check to see if the arc which the slash follows will hit any of them
      for (Enemy enemy : curWorld.enemies) {
        boolean enemyDamaged = false; // tracks if the enemy has been damaged. If it has, then we don't "damage it again"
        for (float angle = startAngle; angle <= endAngle && !enemyDamaged; angle += angIncrease) {
          float x = curPlayer.centerX() + cos(angle) * radius;
          float y = curPlayer.centerY() + sin(angle) * radius;
          // if the sword hits, then damage the enemy
          if (enemy.lineHits(curPlayer.centerX(), curPlayer.centerY(), x, y)) {
            enemy.takeDamage(this.damage);
            enemyDamaged = true;
          }
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
      stroke(255);
      strokeWeight(3);
      fill(0, 0, 0, 0);
      // draw an arc from startAngle to curAngle
      arc(curPlayer.centerX(), curPlayer.centerY(), radius * 2, radius * 2, startAngle, curAngle, OPEN);
    }
  }

  // The second knight attack: a long, slow slash
  class KnightLongSlash implements Projectile {
    // the current angle, the angle to end on, the size of the sword, the damage of the sword
    float curAngle, endAngle, radius, damage;
    // the speed at which to swing the sword
    float angleIncrease = PI / 16;
    // Since we only want to attack each enemy once, we keep a list of the enemies that have been attacked
    ArrayList<Enemy> attacked;

    KnightLongSlash(float startAngle, float endAngle, float radius, float damage) {
      // initialize properties
      this.curAngle = startAngle;
      this.endAngle = endAngle;
      this.radius = radius;
      this.damage = damage;

      attacked = new ArrayList<Enemy>();
    }
    void tick() {
      // if the slash is finished, then remove the projectile
      if (curAngle > endAngle)
        curWorld.removeProjectile(this);

      // get the center of the player
      float centerX = curPlayer.centerX();
      float centerY = curPlayer.centerY();
      // for each enemy, if the line defining the sword hits any of them and they haven't been attacked before by this attack, then damage them
      for (Enemy enemy : curWorld.enemies) {
        if (enemy.lineHits(centerX, centerY, centerX + cos(curAngle) * radius, centerY + sin(curAngle) * radius) && !attacked.contains(enemy)) {
          enemy.takeDamage(damage);
          attacked.add(enemy);
        }
      }

      // move the sword (go to the next angle)
      curAngle += angleIncrease;
    }
    void render() {
      // get the center of the player
      float centerX = curPlayer.centerX();
      float centerY = curPlayer.centerY();
      stroke(255);
      strokeWeight(4);
      // draw a line to the current end of the sword
      line(centerX, centerY, centerX + cos(curAngle) * radius, centerY + sin(curAngle) * radius);
    }
  }

  //     WIZARD ATTACKS
  // Continuous "pulses" of damaging anyone in a circle
  class WizardFireball implements Projectile {
    // parameters defining the circle
    float centerX, centerY, radius;
    // the frames in between each attack and the number of attacks to do
    int framesBetween, numAttacks;
    // the damage of each attack
    float damage;
    int timer;  // timer for when to do the next attack
    float green;  // the parameter for the color - increasing green changes the red to an orange
    WizardFireball(float cx, float cy, float r, float damage, int frameInterval, int numAttacks) {
      // initalize variables
      centerX = cx;
      centerY = cy;
      radius = r;
      framesBetween = frameInterval;
      this.numAttacks = numAttacks;
      this.damage = damage;
      this.timer = 0;
      this.green = 0;
    }
    void tick() {
      // if the timer is 0, then do the attack
      if (this.timer == 0) {
        // the circle should now by red
        this.green = 0;
        // For each enemy, if the center of the enemy is inside the circle, then damage it
        for (Enemy enemy : curWorld.enemies) {
          if (pointDistance(this.centerX, this.centerY, enemy.centerX(), enemy.centerY()) < this.radius) {
            enemy.takeDamage(this.damage);
          }
        }
        // reset the timer, reduce the number of attacks left
        this.timer = framesBetween;
        numAttacks--;

        // if we have no more attacks, then destroy this projectile
        if (numAttacks == 0) {
          curWorld.removeProjectile(this);
        }
      } else {
        // increase the "fade" to orange
        float amtIncrease = 150 / framesBetween;
        this.green += amtIncrease;
        // count down the timer
        timer--;
      }
    }
    void render() {
      // set the fill & stroke, and draw the circle
      fill(255, this.green, 0, 100);
      stroke(255);
      strokeWeight(2);
      ellipse(centerX, centerY, 2 * radius, 2 * radius);
    }
  }

  // "Zaps" the closest enemy
  class WizardZap implements Projectile {
    // get the closest Enemy and the distance from that enemy
    Enemy closestEnemy;
    float closestDistance;

    int spawnFrame; // frame in which the zap was spawned (for animation)
    int existFrames; // the amount of time the zap should stay on the screen

    final float maxRange = 200;
    WizardZap(float attackX, float attackY, float damage) {
      // initalize values
      closestEnemy = null;
      closestDistance = -1;
      this.existFrames = 15;
      // get the closest enemy iteratively
      for (Enemy enemy : curWorld.enemies) {
        float enemyDistance = pointDistance(enemy.x + enemy.w / 2, enemy.y + enemy.h / 2, attackX, attackY);
        if ((closestEnemy == null || enemyDistance < closestDistance) && enemyDistance < maxRange) {
          closestEnemy = enemy;
          closestDistance = enemyDistance;
        }
      }
      // if there even is a closest enemy, then we damage that enemy
      if (closestEnemy != null) {
        closestEnemy.takeDamage(damage);
      }

      spawnFrame = curFrame;
    }
    void tick() {
      // once the "zap" has existed longer than existFrames, then remove the projectile
      if (curFrame - spawnFrame > existFrames) {
        curWorld.removeProjectile(this);
      }
    }
    void render() {
      // draw a transcluscent circle at the center of the enemy
      if (closestEnemy != null) {
        float opacity = 255 - 255 * (curFrame - spawnFrame) / this.existFrames;
        fill(0, 100, 255, opacity);
        stroke(0);
        strokeWeight(1);
        ellipse(closestEnemy.centerX(), closestEnemy.centerY(), 15, 15);
      }
    }
  }

  //     ARCHER ATTACKS
  class ArcherArrow implements Projectile {
    float startX, startY; // starting coordinate
    float existDistance; // the distance that this arrow should travel to

    float x, y; // current coordinates
    float xInc, yInc; // the speed and direction the arrow should go in (as a vector)
    float damage; // the damage of this arrow
    int enemiesHitLeft; // the number of enemies it can hit

    ArrayList<Enemy> enemiesHit; // List of enemies that have been hit
    ArcherArrow(float x, float y, float xInc, float yInc, float damage, float distance, int enemiesToHit) {
      // initialize variables
      this.x = x;
      this.y = y;
      this.xInc = xInc;
      this.yInc = yInc;
      this.startX = x;
      this.startY = y;
      this.damage = damage;

      this.existDistance = distance;
      this.enemiesHitLeft = enemiesToHit;
      this.enemiesHit = new ArrayList<Enemy>();
    }
    void tick() {
      // move the arrow
      this.x += xInc;
      this.y += yInc;

      // for each enemy in its range, hit the enemy
      for (Enemy enemy : curWorld.enemies) {
        // if the arrow is touching them, we can still hit enemies, and we haven't hit them before
        if (enemy.inRange(this.x, this.y) && this.enemiesHitLeft > 0 && !enemiesHit.contains(enemy)) {
          // then damage them, reduce the number of enemies we can hit and add them to enemiesHit
          enemy.takeDamage(this.damage);
          enemiesHitLeft--;
          enemiesHit.add(enemy);
        }
      }
      // If we hit a wall, if we can't hit any more enemies, or we travel out of range, then destroy the projectile
      if (this.enemiesHitLeft <= 0 || curWorld.touchingWall(new Entity(x, y, 0, 0)) || pointDistance(startX, startY, x, y) > existDistance) {
        curWorld.removeProjectile(this);
      }
    }
    void render() {
      // move the matrix to the current position and rotate it in the direction of travel
      pushMatrix();
      translate(x, y);
      float angle = angleOf(xInc, yInc);
      rotate(angle);

      // draw a line and triangle for the arrow
      stroke(#7C4400);
      strokeWeight(3);
      line(-24, 0, -7, 0);

      noStroke();
      fill(255);
      triangle(-7, 3, 0, 0, -7, -3);

      popMatrix();
    }
  }

  // CODE FOR EACH TYPE OF PLAYER (INCLUDING CLASS AND ATTACK) ----------------------------------------------------------------------------

  // Generic class for a dungeon player; automatically adds a smaller "bounding box" and renders the player
  abstract class DungeonPlayer extends Entity {
    // The last horizontal movement of the player
    Direction lastHorizontal;
    // The current character and player info
    PlayerInfo character;

    // The sprites for idling, walking and attacking (they're all "facing left")
    PImage idle, walk1, walk2, attack;
    PImage curSprite; // the current sprite to display
    int changeTimer; // we display each sprite for some timer; this is the timer
    int lastWalkFrame; // the last frame in which we walked

    // the number of frames each animation should last for
    final int walkFrames = 10;
    final int attackFrames = 10;

    // the "margins" between the collision box and actual sprite to the back, front, top and bottom
    float backMargin, frontMargin, topMargin, botMargin;

    // the last frames in which each player did attack 1 and attack 2
    int lastAttackFrame1;
    int lastAttackFrame2;

    DungeonPlayer(float x, float y, int w, int h, float backMargin, float frontMargin, float topMargin, float botMargin, PlayerInfo character, PImage idle, PImage walk1, PImage walk2, PImage attack) {
      // Initialize entity to the collision box
      super(x + backMargin, y + topMargin, w - backMargin - frontMargin, h - topMargin - botMargin);
      // set the margins & initialize variables
      this.backMargin = backMargin;
      this.frontMargin = frontMargin;
      this.topMargin = topMargin;
      this.botMargin = botMargin;

      lastHorizontal = Direction.right;
      this.character = character;
      lastWalkFrame = -1000;

      // set the images
      this.idle = idle;
      this.walk1 = walk1;
      this.walk2 = walk2;
      this.attack = attack;
      curSprite = idle;
    }

    // function for updating variables for when this player has moved
    void moved() {
      lastWalkFrame = curFrame;
      if (curSprite != walk1 && curSprite != walk2 && curSprite != attack) {
        curSprite = walk1;
        changeTimer = walkFrames;
      }
    }

    // moving in the four directions; horizontal movement will update lastHorizontal
    void moveRight() {
      curWorld.moveEntitySoft(this, character.speed, 0);
      lastHorizontal = Direction.right;
      moved();
    }
    void moveLeft() {
      curWorld.moveEntitySoft(this, -character.speed, 0);
      lastHorizontal = Direction.left;
      moved();
    }
    void moveUp() {
      curWorld.moveEntitySoft(this, 0, -character.speed);
      moved();
    }
    void moveDown() {
      curWorld.moveEntitySoft(this, 0, character.speed);
      moved();
    }

    // Take damage; reduce the health left and call playerDied if this player is dead
    void takeDamage(float amount) {
      character.health = max(0, character.health - amount);
      if (character.health == 0) {
        playerDied();
      }
    }

    // used for debugging. Draws the collision box of the current player
    void drawBoundingRect() {
      fill(0, 0, 0, 0);
      stroke(255);
      strokeWeight(1);
      rect(x, y, w, h);
    }

    void render() {
      // Draw the player moving right or left depending on lastHorizontal
      if (lastHorizontal == Direction.left) {
        image(curSprite, x - frontMargin, y - topMargin);
      } else {
        // draw in the "flipped direction" by using a pushmatrix and flipping the x axis
        pushMatrix();
        translate(x + w + frontMargin, y - topMargin);
        scale(-1, 1);

        image(curSprite, 0, 0);
        popMatrix();
      }
      if (lastHorizontal != Direction.right && lastHorizontal != Direction.left) {
        // error trapping for if lastHorizontal isn't horizontal
        println("Last horizontal wasn't right or left! Called from Dungeon Player");
      }

      // draws the health bar
      float barLeft = centerX() - 20;
      float barWidth = 40;
      fill(0, 0, 0, 0);
      stroke(255);
      strokeWeight(0.5);
      rect(barLeft, y - topMargin - 7, barWidth, 5);
      fill(255, 0, 0);
      rect(barLeft, y - topMargin - 7, barWidth * character.health / character.maxHealth, 5);
    }

    // the command for when the user attacks
    void attackSpriteUpdate() {
      curSprite = attack;
      changeTimer = attackFrames;
    }
    abstract void attack1();
    abstract void attack2();

    // the needed "logic updates" for each frame
    void tick() {
      if (curFrame - lastWalkFrame > 3 && (curSprite == walk1 || curSprite == walk2)) {
        curSprite = idle;
      }
      if ((curSprite == walk1 || curSprite == walk2) && changeTimer <= 0) {
        if (curSprite == walk1) {
          curSprite = walk2;
        } else {
          curSprite = walk1;
        }
        changeTimer = walkFrames;
      }
      if (curSprite == attack && changeTimer <= 0) {
        curSprite = idle;
      }
      changeTimer--;
    }
  }

  //     KNIGHT PLAYERS
  class Knight extends DungeonPlayer {
    float range1; // range of its attack

    float range2; // range of second attack

    // draw the bounding areas of the knight, and load in the images
    Knight(float x, float y, int w, int h, PlayerInfo character) {
      super(x, y, w, h, w * 0.35, w * 0.4, h * 0.2, h * 0.2, character, knightIdle, knightWalk1, knightWalk2, knightAttack);

      // iniitialize variables
      this.range1 = 50;
      this.lastAttackFrame1 = -1000; // this is set to -1000 as a placeholder
      this.range2 = 120;
      this.lastAttackFrame2 = -1000;
    }
    void attack1() {
      // if the frames between now and the last attack frame is larger than or equal to the cooldown per attack
      if (curFrame - lastAttackFrame1 >= character.framesBetweenA1) {
        // then we get the coordinate of the center of this player and the coordinate the mouse was clicked on (in the world)
        float cx = centerX();
        float cy = centerY();
        float clickY = curWorld.camera.getRealY(mouseY);
        float clickX = curWorld.camera.getRealX(mouseX);
        float angleToMouse = angleOf(clickX - cx, clickY - cy);

        // add the projectile
        curWorld.addProjectile(new KnightShortSlash(angleToMouse - PI / 4, angleToMouse + PI / 4, this.range1, this.character.baseA1Attack));

        // set the last time we attackd to now
        lastAttackFrame1 = curFrame;
      }
    }
    void attack2() {
      // if the cooldown has finished
      if (curFrame - lastAttackFrame2 >= character.framesBetweenA2) {
        // get the center of the player
        float cx = this.x + this.w / 2;
        float cy = this.y + this.h / 2;
        // get the coordinate in which the mouse was clicked
        float clickY = curWorld.camera.getRealY(mouseY);
        float clickX = curWorld.camera.getRealX(mouseX);
        // get angle between the mouse and character
        float angleToMouse = angleOf(clickX - cx, clickY - cy);

        // add the attack to the world
        curWorld.addProjectile(new KnightLongSlash(angleToMouse - PI / 3, angleToMouse + PI / 3, this.range2, this.character.baseA2Attack));

        // set last time frame in which we attacked to now
        lastAttackFrame2 = curFrame;
      }
    }
  }

  //     WIZARD PLAYERS
  class Wizard extends DungeonPlayer {
    final float wizardRange = 400;

    Wizard(float x, float y, int w, int h, PlayerInfo character) {
      // set boundaries, load in images
      super(x, y, w, h, w * 0.4, w * 0.35, h * 0.25, h * 0.2, character, wizardIdle, wizardWalk1, wizardWalk2, wizardAttack);
      lastAttackFrame1 = -1000;
      lastAttackFrame2 = -1000;
    }
    void attack1() {
      // if it's been more frames than the cooldown for attack 2
      if (curFrame - lastAttackFrame1 >= character.framesBetweenA1) {
        // then add a "zap" projectile
        lastAttackFrame1 = curFrame;
        curWorld.addProjectile(new WizardZap(curWorld.camera.getRealX(mouseX), curWorld.camera.getRealY(mouseY), character.baseA1Attack));
      }
    }
    void attack2() {
      // if the frames from now to the last frame is more than the frames per attack
      if (curFrame - lastAttackFrame2 >= character.framesBetweenA2) {
        // then add a fireball projectile
        curWorld.addProjectile(new WizardFireball(curWorld.camera.getRealX(mouseX), curWorld.camera.getRealY(mouseY), 100, character.baseA2Attack, 30, 5));
        lastAttackFrame2 = curFrame;
      }
    }
  }

  //     ARCHER PLAYERS
  class Archer extends DungeonPlayer {
    Archer(float x, float y, int w, int h, PlayerInfo character) {
      super(x, y, w, h, w * 0.35, w * 0.3, h * 0.2, h * 0.2, character, archerIdle, archerWalk1, archerWalk2, archerAttack);
      this.lastAttackFrame1 = -1000;
    }
    void attack1() {
      // if the time from the last attack is longer than the time needed for the cooldown for attack 1
      if (curFrame - lastAttackFrame1 >= character.framesBetweenA1) {
        // get the center coordinate
        float centerX = x + w / 2;
        float centerY = y + h / 2;
        // get the direction and to the mouse
        float xDiff = curWorld.camera.getRealX(mouseX) - centerX;
        float yDiff = curWorld.camera.getRealY(mouseY) - centerY;

        // get the magnitude of the vector (xDiff, yDiff)
        float mag = pointDistance(curWorld.camera.getRealX(mouseX), curWorld.camera.getRealY(mouseY), centerX, centerY);

        // add an arrow, giving it a speed of 10 (we first normalize xDiff and yDiff)
        curWorld.addProjectile(new ArcherArrow(centerX, centerY, 10 * xDiff / mag, 10 * yDiff / mag, character.baseA1Attack, 400, 2));

        // the last time the archer attacked is now
        lastAttackFrame1 = curFrame;
      }
    }
    void attack2() {
      // if the time from the last attack is longer than the time needed for the cooldown for attack 1
      if (curFrame - lastAttackFrame2 >= character.framesBetweenA2) {
        // get the center coordinate
        float centerX = x + w / 2;
        float centerY = y + h / 2;
        // get the direction and to the mouse
        float xDiff = curWorld.camera.getRealX(mouseX) - centerX;
        float yDiff = curWorld.camera.getRealY(mouseY) - centerY;

        // get the angle from the archer to the mouse 
        float angle = angleOf(xDiff, yDiff);

        // add 3 arrow, giving it a speed of 10
        curWorld.addProjectile(new ArcherArrow(centerX, centerY, cos(angle) * 10, sin(angle) * 10, character.baseA2Attack, 150, 2));
        curWorld.addProjectile(new ArcherArrow(centerX, centerY, cos(angle - PI / 5) * 10, sin(angle - PI / 10) * 10, character.baseA2Attack, 100, 1));
        curWorld.addProjectile(new ArcherArrow(centerX, centerY, cos(angle + PI / 5) * 10, sin(angle + PI / 10) * 10, character.baseA2Attack, 100, 1));

        // set the last time we attacked to now
        lastAttackFrame2 = curFrame;
      }
    }
  }

  // DIFFERENT TYPES OF ENEMIES ----------------------------------------------------------------------------

  abstract class Enemy extends Entity {
    // each enemy has a current health and maximum health
    float health;
    float maxHealth;
    Enemy(float x, float y, int w, int h, float health) {
      // initialize parameters
      super(x, y, w, h);
      this.health = health;
      this.maxHealth = health;
    }

    // the function for this enemy to take damage
    void takeDamage(float amount) {
      // subtract the damage
      this.health -= amount;
      // if we have less than 0 health or 0 health, then remove this Enemy
      if (this.health <= 0) {
        curWorld.removeEntity(this);
        curPlayer.character.coins += 1;
      }
    }

    // draws a health bar for the current enemy in the rectangle (x,y, w, h)
    void drawHealthBar(float x, float y, float w, float h) {
      float barWidth = w * health / maxHealth;
      fill(0, 0, 0, 0);
      stroke(255);
      strokeWeight(1);
      rect(x, y, w, h);
      fill(255, 0, 0);
      rect(x, y, barWidth, h);
    }

    // required methods for updating and rendering
    abstract void tick();
    abstract void render();
  }

  // A "normal" enemy which maintains a specific distance from the player, and attacks when in range 
  abstract class RangedEnemy extends Enemy {
    float range, framesPerAttack; // range of the attack, the frame interval of attacking
    float optimalDist; // the optimal distance this should try to maintain
    float speed; // the speed of this enemy
    float lastAttackFrame; // the last frame in which it attacked
    Direction playerSide; // the side of the player compared to this enemy
    PImage right, left; // the sprites for when the player is to the right and to the left

    RangedEnemy(float x, float y, int w, int h, int framesPerAttack, float range, float speed, float startingHealth, PImage right, PImage left) {
      // initialize variables
      super(x, y, w, h, startingHealth);
      this.framesPerAttack = framesPerAttack;
      this.range = range;
      this.speed = speed;
      optimalDist = range / 2;
      lastAttackFrame = -1000;
      this.playerSide = Direction.right;

      this.right = right;
      this.left = left;
    }

    // function for updating the logic for the enemy
    void tick() {
      // if the player is within this enemy's range
      if (curPlayer.distance(this) < range) {
        // information for the "vector" to the current player's center
        float xDiff = curPlayer.centerX() - this.centerX();
        float yDiff = curPlayer.centerY() - this.centerY();
        float mag = magnitude(xDiff, yDiff);

        // if the player is to the right/left, update the direction that this entity is looking in
        if (xDiff > 0) {
          playerSide = Direction.right;
        } else {
          playerSide = Direction.left;
        }

        // if the player is further than we would like, move towards the player
        if (curPlayer.distance(this) > optimalDist) {
          curWorld.moveEntity(this, speed * xDiff / mag, speed * yDiff / mag);
        }

        // a timer for attacking
        if (curFrame - lastAttackFrame >= framesPerAttack) {
          lastAttackFrame = curFrame;
          attack();
        }
      }
    }

    // draw the enemy
    void render() {
      // draw it facing the player
      if (playerSide == Direction.right) {
        image(right, x, y);
      } else {
        image(left, x, y);
      }
      // draws the health bar
      this.drawHealthBar(x, y - 7, w, 5);
    }

    // the function for attacking
    abstract void attack();
  }

  // A "normal" enemy which just attacks the player once its in range
  class MeleeEnemy extends Enemy {
    int framesPerAttack; // the frames per attack
    int lastAttackFrame; // the last frame in which this enemy attacked
    float range, sightRange; // the range for attack, the range to see the player
    float attack; // the damage of this entity
    float speed; // the speed of this entity

    float playerTargettedRange; // the range when it sees the player
    boolean seesPlayer; // whether or not it sees the player
    Direction lastHorizontal; // the last horizontal direction

    PImage right, left;

    MeleeEnemy(float x, float y, int w, int h, int framesPerAttack, float range, float sightRange, float playerTargettedRange, float attack, float speed, float startingHealth, PImage right, PImage left) {
      // initialize variables
      super(x, y, w, h, startingHealth);
      lastAttackFrame = -1000;
      this.range = range;
      this.sightRange = sightRange;
      this.attack = attack;
      this.framesPerAttack = framesPerAttack;
      this.speed = speed;
      this.playerTargettedRange = playerTargettedRange;

      seesPlayer = false;
      lastHorizontal = Direction.right;

      this.right = right;
      this.left = left;
    }
    void tick() {
      // as time goes on, the enemies in a dungeon will have longer and longer sight range; prevents long drawn out plays
      sightRange = min(playerTargettedRange, (sightRange + sightRangeIncrease));

      // if this player is within its range
      if (distance(curPlayer) <= range) {
        // the time between now and our last attack is past the cooldown
        if (curFrame - lastAttackFrame >= framesPerAttack) {
          // then attack the player
          curPlayer.takeDamage(this.attack);
          lastAttackFrame = curFrame;
        }

        // make sure we're facing the player
        if (curPlayer.x > this.x)
          lastHorizontal = Direction.right;
        else
          lastHorizontal = Direction.left;
      }
      if (distance(curPlayer) <= sightRange || seesPlayer && distance(curPlayer) <= playerTargettedRange) {
        moveTowardsPlayer();
      }

      // if the player moves out of range, then we can no longer see him/her
      if (distance(curPlayer) > playerTargettedRange) {
        seesPlayer = false;
      }
    }
    // move this entity towards the player
    void moveTowardsPlayer() {
      // get the vector to the player
      float xDiff = curPlayer.centerX() - centerX();
      float yDiff = curPlayer.centerY() - centerY();

      // get the magnitude of our movement
      float mag = sqrt(pow(xDiff, 2) + pow(yDiff, 2));
      // get the x and y components that we'll be moving
      float moveX = min(speed, mag) * xDiff / mag;
      float moveY = min(speed, mag) * yDiff / mag;
      // try to move in this direction (but we won't collide into another entity)
      curWorld.moveEntitySoft(this, moveX, moveY);

      // make sure we see the player
      if (xDiff > 0)
        lastHorizontal = Direction.right;
      else
        lastHorizontal = Direction.left;

      // set that we can see the player to true
      seesPlayer = true;
    }

    void render() {
      // draw the goblin facing the player
      if (lastHorizontal == Direction.right) {
        image(this.right, x, y);
      } else {
        image(this.left, x, y);
      }

      this.drawHealthBar(x, y - 7, w, 5);
    }
  }

  // The zombie
  class Zombie extends MeleeEnemy {
    Zombie(float x, float y, int w, int h) {
      super(x, y, w, h, framesPerZombieAttack, 5, 300, 700, zombieAttack, zombieSpeed, zombieHealth, zombieRight, zombieLeft);
    }
    Zombie(float x, float y) {
      this(x, y, zombieWidth, zombieHeight);
    }
  }

  // A goblin
  class Goblin extends MeleeEnemy {
    Goblin(float x, float y, int w, int h) {
      super(x, y, w, h, framesPerGoblinAttack, 5, 300, 700, goblinAttack, goblinSpeed, goblinHealth, goblinRight, goblinLeft);
    }
    Goblin(float x, float y) {
      this(x, y, goblinWidth, goblinHeight);
    }
  }

  // a skeleton
  class Skeleton extends MeleeEnemy {
    Skeleton(float x, float y, int w, int h, float sightRange, float targettedRange) {
      super(x, y, w, h, framesPerSkeletonAttack, 5, sightRange, targettedRange, skeletonAttack, skeletonSpeed, skeletonHealth, skeletonRight, skeletonLeft);
    }

    Skeleton(float x, float y, int w, int h) {
      super(x, y, w, h, framesPerSkeletonAttack, 5, 200, 700, skeletonAttack, skeletonSpeed, skeletonHealth, skeletonRight, skeletonLeft);
    }

    Skeleton(float x, float y) {
      this(x, y, skeletonWidth, skeletonHeight);
    }
    // is "smarter", will target the player when it's attacked
    void takeDamage(float amount) {
      super.takeDamage(amount);
      this.seesPlayer = true;
    }
  }

  // a very strong skeleton knight, should only be spawned through bosses
  class SkeletonKnight extends MeleeEnemy {
    SkeletonKnight(float x, float y) {
      super(x, y, skelKnightWidth, skelKnightHeight, framesPerSkelKnightAttack, skelKnightAtkRange, skelKnightSightRange, skelKnightSightRange, skelKnightAtk, skelKnightSpeed, skelKnightHealth, dungeonSkeletonKnightRight, dungeonSkeletonKnightLeft);
      seesPlayer = true;
    }
  }

  // TOOL FUNCTIONS ---------------------------------------------------------------------
  // convert a text "mapping" of the world into an actual dungeon world
  DungeonWorld getWorldOf(String filePath, DungeonPlayer player) {
    // load in the lines of the map
    String[] lines = loadStrings(filePath);
    // the first line will be "[rows] [cols]"
    int rows = Integer.parseInt(lines[0].split(" ")[0]);
    int cols = Integer.parseInt(lines[0].split(" ")[1]);

    // get the lines of the map (which are the remaining lines)
    String[] mapLines = new String[lines.length - 1];
    for (int i = 0; i < mapLines.length; ++i)
      mapLines[i] = lines[i + 1];

    // Initialize a 2d array for the tiles of the dungeons
    DungeonElement[][] elements = new DungeonElement[rows][cols];
    boolean[][] walkable = new boolean[rows][cols];

    for (int r = 0; r < rows; ++r) {
      for (int c = 0; c < cols; ++c) {
        // The ground is walkable, a wall and "empty object" is not
        if (mapLines[r].charAt(c) == 'G') {
          elements[r][c] = DungeonElement.Ground;
          walkable[r][c] = true;
        } else if (mapLines[r].charAt(c) == 'W') {
          elements[r][c] = DungeonElement.Wall;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == 'E') {
          elements[r][c] = DungeonElement.Empty;
          walkable[r][c] = false;
        } else {
          // error trapping for unrecognized characters
          println("Unrecognized character in dungeon text mapping: " + lines[r].charAt(c));
        }
      }
    }

    // return the dungeon world
    return new DungeonWorld(elements, walkable, player);
  } 

  // get a player based on the character we want and the type of player
  DungeonPlayer getPlayerOf(float x, float y, PlayerInfo characterOf) {
    // we take into account the current player class, as well as the type of attack (which should be chosen in the dungeon start screen)
    if (characterOf.playerClass == PlayerClass.Knight) {
      return new Knight(x, y, knightWidth, knightHeight, characterOf);
    } else if (characterOf.playerClass == PlayerClass.Archer) {
      return new Archer(x, y, archerWidth, archerHeight, characterOf);
    } else if (characterOf.playerClass == PlayerClass.Wizard) {
      return new Wizard(x, y, wizardWidth, wizardHeight, characterOf);
    } else {
      // error trapping for invalid inputs
      println("didn't get proper parameters for character creation! Function getPlayerOf");
      return null;
    }
  }

  void keyPressed() {
    if (key == 'm' || key == 'M') {
      curState = new DungeonMenuState(curState, this, curPlayer.character);
    }
  }
}
