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
  final int goblinWidth = 30;
  final int goblinHeight = 30;

  final int goblinHealth = 15;
  final int framesPerGoblinAttack = 30;
  final int goblinAttack = 2;
  final int goblinSpeed = 6;

  // defaults for zombies
  final int zombieWidth = 30;
  final int zombieHeight = 30;

  final int zombieHealth = 20;
  final int framesPerZombieAttack = 60;
  final float zombieAttack = 10;
  final float zombieSpeed = 1;

  // defaults for skeletons
  final int skeletonWidth = 30;
  final int skeletonHeight = 30;

  final int skeletonHealth = 30;
  final int framesPerSkeletonAttack = 45;
  final float skeletonAttack = 15;
  final float skeletonSpeed = 4;

  DungeonWorld curWorld;
  DungeonPlayer curPlayer;
  PlayerInfo info;
  int curFrame;

  abstract void setup();

  // function for when the dungeon is completed
  void dungeonCompleted() {
    curStory.storyDungeonCompleted();
    dungeonExited();
  }

  // function for when the dungeon is exited (e.g player died, user exited)
  void dungeonExited() {
    curEnvironment = previous;
    stopBackgroundMusic();
  }

  // Player death mechanics
  void playerDied() {
    // revive the player slightly, giving them a few health buffs
    curWorld.player.character.health = min(curWorld.player.character.maxHealth, 10);
    dungeonExited();
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
      curWorld.player.attack1();
    } else if (mouseButton == RIGHT) {
      curWorld.player.attack2();
    }
  }

  DefaultDungeon(EnvironmentState previous, PlayerInfo character) {
    // initialize variables
    super(previous);
    this.curFrame = 0;
    this.info = character;

    this.loadImages();
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
  }

  // loading in the needed images
  void loadImages() {
    // resize goblins to proper size
    goblinRight.resize(goblinWidth, goblinHeight);
    goblinLeft.resize(goblinWidth, goblinHeight);

    // resize zombies to proper size
    zombieRight.resize(zombieWidth, zombieHeight);
    zombieLeft.resize(zombieWidth, zombieHeight);

    // resize skeletons to proper size
    skeletonRight.resize(skeletonWidth, skeletonHeight);
    skeletonLeft.resize(skeletonWidth, skeletonHeight);
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
      this.tileMap = elements;
      this.enemies = new ArrayList<Enemy>();
      this.projectiles = new ArrayList<Projectile>();
      this.removeEntities = new ArrayList<Entity>();
      this.removedProjectiles = new ArrayList<Projectile>();

      // load in the assets for the ground and wall
      this.ground = loadImage("sprites/dungeon/ground.png");
      this.wall = loadImage("sprites/dungeon/wall.png");
      this.empty = loadImage("sprites/dungeon/empty.png");

      // resize them to the size of each tile
      this.ground.resize(ceil(gridSize), ceil(gridSize));
      this.wall.resize(ceil(gridSize), ceil(gridSize));
      this.empty.resize(ceil(gridSize), ceil(gridSize));
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

    // return the enemy that the current entity is touching, if any. If not, return null  
    Enemy touchingEnemy(Entity query) {
      // Loop through each of the enemies. If the current entity is touching any of them, return it
      for (Enemy other : this.enemies)
        if (query.collided(other))
          return other;
      // otherwise, return null (nothing)
      return null;
    }
    
    void changeElement(int c, int r, DungeonElement newElement){
     tileMap[r][c] = newElement; 
     if(tileMap[r][c] == DungeonElement.Ground){
      walkable[r][c] = true;
     }else{
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
    WizardZap(float attackX, float attackY, float damage) {
      // initalize values
      closestEnemy = null;
      closestDistance = -1;
      this.existFrames = 15;
      // get the closest enemy iteratively
      for (Enemy enemy : curWorld.enemies) {
        float enemyDistance = pointDistance(enemy.x + enemy.w / 2, enemy.y + enemy.h / 2, attackX, attackY);
        if (closestEnemy == null || enemyDistance < closestDistance) {
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

    // The sprites for moving right and left
    PImage right, left;
    // the "margins" between the collision box and actual sprite to the back, front, top and bottom
    float backMargin, frontMargin, topMargin, botMargin;

    DungeonPlayer(float x, float y, int w, int h, float backMargin, float frontMargin, float topMargin, float botMargin, PlayerInfo character, PImage right, PImage left) {
      // Initialize entity to the collision box
      super(x + backMargin, y + topMargin, w - backMargin - frontMargin, h - topMargin - botMargin);
      // set the margins & initialize variables
      this.backMargin = backMargin;
      this.frontMargin = frontMargin;
      this.topMargin = topMargin;
      this.botMargin = botMargin;

      lastHorizontal = Direction.right;
      this.character = character;

      // set the images and resize them
      this.right = right;
      this.left = left;
      this.right.resize(w, h);
      this.left.resize(w, h);
    }
    // moving in the four directions; horizontal movement will update lastHorizontal
    void moveRight() {
      curWorld.moveEntitySoft(this, character.speed, 0);
      lastHorizontal = Direction.right;
    }
    void moveLeft() {
      curWorld.moveEntitySoft(this, -character.speed, 0);
      lastHorizontal = Direction.left;
    }
    void moveUp() {
      curWorld.moveEntitySoft(this, 0, -character.speed);
    }
    void moveDown() {
      curWorld.moveEntitySoft(this, 0, character.speed);
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
      strokeWeight(2);
      rect(x, y, w, h);
    }

    void render() {
      // Draw the player moving right or left depending on lastHorizontal
      if (lastHorizontal == Direction.right) {
        image(this.right, x - backMargin, y - topMargin);
      } else {
        image(this.left, x - frontMargin, y - topMargin);
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
      rect(barLeft, y - 7, barWidth, 5);
      fill(255, 0, 0);
      rect(barLeft, y - 7, barWidth * character.health / character.maxHealth, 5);
    }

    // the command for when the user attacks
    abstract void attack1();
    abstract void attack2();

    // the needed "logic updates" for each frame
    void tick() {
    }
  }

  //     KNIGHT PLAYERS
  class Knight extends DungeonPlayer {
    float range1; // range of its attack
    int lastAttackFrame1; // storing the last frame in which the Knight attacked

    float range2; // range of second attack
    int lastAttackFrame2; // last frame in which the player attacked

    // draw the bounding areas of the knight, and load in the images
    Knight(float x, float y, int w, int h, PlayerInfo character) {
      super(x, y, w, h, w * 0.55, w * 0.15, h * 0.3, h * 0.2, character, loadImage("sprites/knight_right.png"), loadImage("sprites/knight_left.png"));

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
    int lastAttackFrame1; // the last frame of when the wizard attacked

    int lastAttackFrame2; // the last frame of when the wizard attacked

    Wizard(float x, float y, int w, int h, PlayerInfo character) {
      // set boundaries, load in images
      super(x, y, w, h, w * 0.2, w * 0.45, h * 0.2, h * 0.2, character, loadImage("sprites/wizard_right.png"), loadImage("sprites/wizard_left.png"));
      lastAttackFrame1 = -1000;
      lastAttackFrame2 = -1000;
    }
    void attack1() {
      // if the frames from now to the last frame is more than the frames per attack
      if (curFrame - lastAttackFrame1 >= character.framesBetweenA1) {
        // then add a fireball projectile
        curWorld.addProjectile(new WizardFireball(curWorld.camera.getRealX(mouseX), curWorld.camera.getRealY(mouseY), 100, character.baseA1Attack, 30, 5));
        lastAttackFrame1 = curFrame;
      }
    }
    void attack2() {
      // if it's been more frames than the cooldown for attack 2
      if (curFrame - lastAttackFrame2 >= character.framesBetweenA2) {
        // then add a "zap" projectile
        lastAttackFrame2 = curFrame;
        curWorld.addProjectile(new WizardZap(curWorld.camera.getRealX(mouseX), curWorld.camera.getRealY(mouseY), character.baseA2Attack));
      }
    }
  }

  //     ARCHER PLAYERS
  class Archer extends DungeonPlayer {
    int lastAttackFrame1; // the last frame in which the archer attacked
    int lastAttackFrame2; // the last frame in which the archer attacked
    Archer(float x, float y, int w, int h, PlayerInfo character) {
      super(x, y, w, h, w * 0.15, w * 0.2, h * 0.2, h * 0.2, character, loadImage("sprites/archer_right.png"), loadImage("sprites/archer_left.png"));
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
        curWorld.addProjectile(new ArcherArrow(centerX, centerY, 10 * xDiff / mag, 10 * yDiff / mag, character.baseA1Attack, 350, 2));

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
        curWorld.addProjectile(new ArcherArrow(centerX, centerY, cos(angle - PI / 5) * 10, sin(angle - PI / 5) * 10, character.baseA2Attack, 100, 1));
        curWorld.addProjectile(new ArcherArrow(centerX, centerY, cos(angle + PI / 5) * 10, sin(angle + PI / 5) * 10, character.baseA2Attack, 100, 1));

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

    // required methods for updating and rendering
    abstract void tick();
    abstract void render();
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
      } else if (distance(curPlayer) <= sightRange || seesPlayer && distance(curPlayer) <= playerTargettedRange) {
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
      float xDiff = curPlayer.x - x;
      float yDiff = curPlayer.y - y;
      
      // get the magnitude of our movement
      float mag = sqrt(pow(xDiff, 2) + pow(yDiff, 2));
      // get the x and y components that we'll be moving
      float moveX = speed * xDiff / mag;
      float moveY = speed * yDiff / mag;
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

      // draw the health bar above the goblin
      // get the width of the filled portion of the bar
      float barWidth = w * this.health / this.maxHealth;
      // draw the empty box
      fill(0, 0, 0, 0);
      stroke(255);
      strokeWeight(0.5);
      rect(x, y - 7, w, 5);

      // fill in part of the box
      fill(255, 0, 0);
      rect(x, y - 7, barWidth, 5);
    }
  }

  // The zombie
  class Zombie extends MeleeEnemy {
    Zombie(float x, float y, int w, int h) {
      super(x, y, w, h, framesPerZombieAttack, 5, 300, 700, zombieAttack, zombieSpeed, zombieHealth, zombieRight, zombieLeft);
    }
  }

  // A goblin
  class Goblin extends MeleeEnemy {
    Goblin(float x, float y, int w, int h) {
      super(x, y, w, h, framesPerGoblinAttack, 5, 300, 700, goblinAttack, goblinSpeed, goblinHealth, goblinRight, goblinLeft);
    }
  }

  class Skeleton extends MeleeEnemy {
    Skeleton(float x, float y, int w, int h) {
      super(x, y, w, h, framesPerSkeletonAttack, 5, 200, 700, skeletonAttack, skeletonSpeed, skeletonHealth, skeletonRight, skeletonLeft);
    }
    void takeDamage(float amount){
     super.takeDamage(amount);
     this.seesPlayer = true;
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
      return new Knight(x, y, 38, 50, characterOf);
    } else if (characterOf.playerClass == PlayerClass.Archer) {
      return new Archer(x, y, 38, 50, characterOf);
    } else if (characterOf.playerClass == PlayerClass.Wizard) {
      return new Wizard(x, y, 50, 50, characterOf);
    } else {
      // error trapping for invalid inputs
      println("didn't get proper parameters for character creation! Function getPlayerOf");
      return null;
    }
  }
}
