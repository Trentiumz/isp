enum OverworldElement {
  Wall1, Grass, Path, Hospital, TreeStump, HospitalWall, HospitalDoor, CaveEntrance, Dirt, House1, House2, Sign1, Sign2, Sign3, Sign4
};
class OverworldEnvironment extends EnvironmentState {
  Overworld curWorld;
  OverPlayer curPlayer;
  int curFrame = 0;

  void enterHospital() {
    changeEnvironment(new HospitalEnvironment(this, curPlayer.character));
  }

  void playBackgroundMusic() {
    outdoorsBGM.loop();
  }
  void stopBackgroundMusic() {
    outdoorsBGM.stop();
  }

  void exitState() {
    stopBackgroundMusic();
  }
  void enterState() {
    playBackgroundMusic();
  }

  void enterStoryDungeon() {
    changeEnvironment(getStoryDungeon(storyDungeonsCompleted, this, curPlayer.character));
  }

  void enterCoinsDungeon() {
    changeEnvironment(new CoinsDungeon(this, curPlayer.character));
  }

  boolean stepDoor(float bx, float by, float bw, float bh) {
    if (curPlayer.x >= bx && curPlayer.y >= by && curPlayer.x <= bx + bw && curPlayer.y <= by + bh) {
      return true;
    } 
    return false;
  }

  void drawOverlays() {
    fill(0, 0, 0, 100);
    noStroke();
    rect(0, 0, width, 28);

    textFont(mainMenuFont3);
    textSize(20);
    fill(255);
    textAlign(CENTER);
    if (stepDoor(1400, 1250, 50, 50) || stepDoor(5200, 300, 50, 50) || stepDoor(5400, 1050, 50, 50)) {
      text("Press E to enter", width/2, 20);
    }
    textAlign(RIGHT);
    text("Coins: " + curPlayer.character.coins, width, 20);
  }

  void enterDoors() {
    if (stepDoor(1400, 1250, 50, 50)) {
      enterHospital();
    }
    if (stepDoor(5200, 300, 50, 50)) {
      enterCoinsDungeon();
    }
    if (stepDoor(5400, 1050, 50, 50)) {
      enterStoryDungeon();
    }
  }

  OverworldEnvironment(PlayerInfo character) {
    curPlayer = getPlayerOf(60, 400, character);
    curWorld = getWorldOf("over_maps/overworld1.txt", curPlayer);
    this.setup();
  }

  void setup() {
    playBackgroundMusic();
  }

  class Overworld extends World {
    OverPlayer player;
    OverworldElement[][] tileMap;
    PImage grass, wall1, path, hospital, treestump, hospitalwall, hospitaldoor, caveentrance, dirt, house1, house2, sign1, sign2, sign3, sign4;


    Overworld(OverworldElement[][] elements, boolean[][] walkable, OverPlayer player) {
      super(walkable);
      this.player = player;
      this.tileMap = elements;

      this.grass = overWorldgrass;
      this.wall1 = overWorldwall1;
      this.path = overWorldpath;
      this.hospital = overWorldhospital;
      this.treestump = overWorldtreestump;
      this.hospitalwall = overWorldhospitalwall;
      this.hospitaldoor = overWorldhospitaldoor;
      this.caveentrance = overWorldcaveentrance;
      this.dirt = overWorlddirt;
      this.house1 = overWorldhouse1;
      this.house2 = overWorldhouse2;
      this.sign1 = overWorldsign1;
      this.sign2 = overWorldsign2;
      this.sign3 = overWorldsign3;
      this.sign4 = overWorldsign4;
    }
    void tick() {
      player.tick();
    }
    void render() {
      camera.centerOnEntity(player);
      pushMatrix();
      camera.alterMatrix();
      for (int r = 0; r < tileMap.length; ++r) {
        for (int c = 0; c < tileMap[r].length; ++c) {
          if (tileMap[r][c] == OverworldElement.Grass) {
            image(grass, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.Path) {
            image(path, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.Wall1) {
            image(wall1, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.Hospital) {
            image(hospital, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.TreeStump) {
            image(treestump, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.HospitalWall) {
            image(hospitalwall, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.HospitalDoor) {
            image(hospitaldoor, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.CaveEntrance) {
            image(caveentrance, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.Dirt) {
            image(dirt, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.House1) {
            image(house1, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.House2) {
            image(house2, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.Sign1) {
            image(sign1, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.Sign2) {
            image(sign2, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.Sign3) {
            image(sign3, gridSize * c, gridSize * r);
          } else if (tileMap[r][c] == OverworldElement.Sign4) {
            image(sign4, gridSize * c, gridSize * r);
          }
        }
      }
      player.render();
      popMatrix();
    }

    boolean touchingWall(Entity query) {
      // get which "path squares" are within the range of the player
      int startX = (int) (query.x / gridSize);
      int startY = (int) (query.y / gridSize);
      int endX = (int) ((query.x + query.w) / gridSize);
      int endY = (int) ((query.y + query.h) / gridSize);

      for (int y = max(0, startY - 1); y <= min(walkable.length - 1, endY + 1); ++y)
        for (int x = max(0, startX - 1); x <= min(walkable[y].length - 1, endX + 1); ++x)
          if (!walkable[y][x] &&  
            boxCollided(query.x, query.y, query.w, query.h, x * gridSize, y * gridSize, gridSize, gridSize))
            return true;
      return false;
    }
  }

  abstract class OverPlayer extends Entity {
    Direction lastHorizontal;
    PlayerInfo character;

    PImage idle, walk1, walk2;
    final int walkFrames=10;
    int changeTimer;
    PImage curSprite;
    int lastWalkFrame;

    float frontMargin, backMargin, topMargin, botMargin;
    final float speedMultiplier = 3;

    final float overworldSpeed = 15;

    OverPlayer(float x, float y, int w, int h, float backMargin, float frontMargin, float topMargin, float botMargin, PlayerInfo character, PImage idle, PImage walk1, PImage walk2) {
      super(x + backMargin, y + topMargin, w - backMargin - frontMargin, h - topMargin - botMargin);
      // set the margins & initialize variables
      this.backMargin = backMargin;
      this.frontMargin = frontMargin;
      this.topMargin = topMargin;
      this.botMargin = botMargin;

      lastHorizontal = Direction.right;
      this.character = character;

      this.idle = idle;
      this.walk1 = walk1;
      this.walk2 = walk2;

      this.changeTimer = 0;
      curSprite = idle;
      lastWalkFrame = -1000;
    }
    void movedSpriteUpdate() {
      if (curSprite != walk1 && curSprite != walk2) {
        curSprite = walk1;
        changeTimer = walkFrames;
      }
      lastWalkFrame = curFrame;
    }
    void moveRight() {
      curWorld.moveEntitySoft(this, overworldSpeed, 0);
      lastHorizontal = Direction.right;
      movedSpriteUpdate();
    }
    void moveLeft() {
      curWorld.moveEntitySoft(this, -overworldSpeed, 0);
      lastHorizontal = Direction.left;
      movedSpriteUpdate();
    }
    void moveUp() {
      curWorld.moveEntitySoft(this, 0, -overworldSpeed);
      movedSpriteUpdate();
    }
    void moveDown() {
      curWorld.moveEntitySoft(this, 0, overworldSpeed);
      movedSpriteUpdate();
    }
    void tick() {
      if (curFrame - lastWalkFrame > 3) {
        curSprite = idle;
      }
      if (curSprite == walk1 && changeTimer <= 0) {
        curSprite = walk2;
        changeTimer = walkFrames;
      }
      if (curSprite == walk2 && changeTimer <= 0) {
        curSprite = walk1;
        changeTimer = walkFrames;
      }
      changeTimer--;
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

      // draws the health bar
      float barLeft = centerX() - 20;
      float barWidth = 40;
      fill(0, 0, 0, 0);
      stroke(255);
      strokeWeight(0.5);
      rect(barLeft, y - 5 - topMargin, barWidth, 5);
      fill(255, 0, 0);
      rect(barLeft, y - 5 - topMargin, barWidth * character.health / character.maxHealth, 5);
    }
  }

  Overworld getWorldOf(String filePath, OverPlayer player) {
    String[] lines = loadStrings(filePath);
    int rows = Integer.parseInt(lines[0].split(" ")[0]);
    int cols = Integer.parseInt(lines[0].split(" ")[1]);
    String[] mapLines = new String[lines.length - 1];
    for (int i = 0; i < mapLines.length; ++i)
      mapLines[i] = lines[i + 1];

    OverworldElement[][] elements = new OverworldElement[rows][cols];
    boolean[][] walkable = new boolean[rows][cols];
    for (int r = 0; r < rows; ++r) {
      for (int c = 0; c < cols; ++c) {
        if (mapLines[r].charAt(c) == 'G') {
          elements[r][c] = OverworldElement.Grass;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == 'W') {
          elements[r][c] = OverworldElement.Wall1;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == 'P') {
          elements[r][c] = OverworldElement.Path;
          walkable[r][c] = true;
        } else if (mapLines[r].charAt(c) == 'H') {
          elements[r][c] = OverworldElement.Hospital;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == 'T') {
          elements[r][c] = OverworldElement.TreeStump;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == 'R') {
          elements[r][c] = OverworldElement.HospitalWall;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == 'D') {
          elements[r][c] = OverworldElement.HospitalDoor;
          walkable[r][c] = true;
        } else if (mapLines[r].charAt(c) == 'C') {
          elements[r][c] = OverworldElement.CaveEntrance;
          walkable[r][c] = true;
        } else if (mapLines[r].charAt(c) == 'L') {
          elements[r][c] = OverworldElement.Dirt;
          walkable[r][c] = true;
        } else if (mapLines[r].charAt(c) == '5') {
          elements[r][c] = OverworldElement.House1;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == '6') {
          elements[r][c] = OverworldElement.House2;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == '1') {
          elements[r][c] = OverworldElement.Sign1;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == '1') {
          elements[r][c] = OverworldElement.Sign1;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == '2') {
          elements[r][c] = OverworldElement.Sign2;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == '3') {
          elements[r][c] = OverworldElement.Sign3;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == '4') {
          elements[r][c] = OverworldElement.Sign4;
          walkable[r][c] = false;
        }
      }
    }
    return new Overworld(elements, walkable, player);
  }

  class Knight extends OverPlayer {
    Knight(float x, float y, int w, int h, PlayerInfo character) {
      super(x, y, w, h, w * 0.35, w * 0.4, h * 0.2, h * 0.2, character, knightIdle, knightWalk1, knightWalk2);
    }
  }

  class Wizard extends OverPlayer {
    Wizard(float x, float y, int w, int h, PlayerInfo character) {
      super(x, y, w, h, w * 0.4, w * 0.35, h * 0.25, h * 0.2, character, wizardIdle, wizardWalk1, wizardWalk2);
    }
  }

  class Archer extends OverPlayer {
    Archer(float x, float y, int w, int h, PlayerInfo character) {
      super(x, y, w, h, w * 0.35, w * 0.3, h * 0.2, h * 0.2, character, archerIdle, archerWalk1, archerWalk2);
    }
  }

  void tick() {
    curFrame++;
    curWorld.tick();
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

  void render() {
    background(0);
    curWorld.render();
    drawOverlays();
  }

  void keyPressed() {
    if (key == 'e' || key == 'E') {
      enterDoors();
    }
    if (key == 'm' || key == 'M') {
      curState = new OverworldMenuState(curState, curPlayer.character);
    }
  }

  OverPlayer getPlayerOf(float x, float y, PlayerInfo character) {
    if (character.playerClass == PlayerClass.Knight) {
      return new Knight(x, y, knightWidth, knightHeight, character);
    } else if (character.playerClass == PlayerClass.Archer) {
      return new Archer(x, y, archerWidth, archerHeight, character);
    } else if (character.playerClass == PlayerClass.Wizard) {
      return new Wizard(x, y, wizardWidth, wizardHeight, character);
    } else {
      println("Unidentified player class (in overworld.getPlayerOf)!");
      return null;
    }
  }
}

enum HospitalElement {
  Wall, Floor, Health, Upgrade, Exit
};

class HospitalEnvironment extends EnvironmentState {
  Hospital curWorld;
  HospitalPlayer curPlayer;
  int curFrame = 0;
  OverworldEnvironment previous;

  HospitalEnvironment(OverworldEnvironment previous, PlayerInfo character) {
    curPlayer = getPlayerOf(60, 400, character);
    curWorld = getWorldOf("over_maps/hospital.txt", curPlayer);
    this.previous = previous;
  }

  void enterState() {
    playBackgroundMusic();
  }
  void exitState() {
    stopBackgroundMusic();
  }
  void playBackgroundMusic() {
    hospitalBGM.loop();
  }
  void stopBackgroundMusic() {
    hospitalBGM.stop();
  }


  void exitHospitalClicked() { 
    changeEnvironment(previous);
  }
  void healing() { 
    curPlayer.character.health = curPlayer.character.maxHealth;
  }
  void upgrades() { 
    curState = new UpgradingState(curPlayer.character);
  }


  boolean stepDoor(float bx, float by, float bw, float bh) {
    if (curPlayer.x >= bx && curPlayer.y >= by && curPlayer.x <= bx + bw && curPlayer.y <= by + bh) {
      return true;
    } 
    return false;
  }

  class Hospital extends World {
    HospitalPlayer player;
    HospitalElement[][] tileMap;
    PImage wall, floor, health, upgrade, exit;


    Hospital(HospitalElement[][] elements, boolean[][] walkable, HospitalPlayer player) {
      super(walkable);
      this.player = player;
      this.tileMap = elements;
      this.wall = loadImage("sprites/hospital_map/pillar.png");
      this.floor = loadImage("sprites/hospital_map/floor.png");
      this.health = loadImage("sprites/hospital_map/health.png");
      this.upgrade = loadImage("sprites/hospital_map/upgrade.png");
      this.exit = loadImage("sprites/hospital_map/exit.png");

      this.wall.resize(ceil(gridSize), ceil(gridSize));
      this.floor.resize(ceil(gridSize), ceil(gridSize));
      this.health.resize(ceil(gridSize), ceil(gridSize));
      this.upgrade.resize(ceil(gridSize), ceil(gridSize));
      this.exit.resize(ceil(gridSize), ceil(gridSize));
    }
    void tick() {
      player.tick();
    }
    void render() {
      camera.centerOnEntity(player);
      pushMatrix();
      camera.alterMatrix();
      for (int r = 0; r < tileMap.length; ++r) {
        for (int c = 0; c < tileMap[r].length; ++c) {
          if (tileMap[r][c] == HospitalElement.Wall) {
            image(wall, gridSize * c, gridSize * r);
          }
          if (tileMap[r][c] == HospitalElement.Floor) {
            image(floor, gridSize * c, gridSize * r);
          }
          if (tileMap[r][c] == HospitalElement.Health) {
            image(health, gridSize * c, gridSize * r);
          }
          if (tileMap[r][c] == HospitalElement.Upgrade) {
            image(upgrade, gridSize * c, gridSize * r);
          }
          if (tileMap[r][c] == HospitalElement.Exit) {
            image(exit, gridSize * c, gridSize * r);
          }
        }
      }
      player.render();
      popMatrix();
    }

    boolean touchingWall(Entity query) {
      // get which "path squares" are within the range of the player
      int startX = (int) (query.x / gridSize);
      int startY = (int) (query.y / gridSize);
      int endX = (int) ((query.x + query.w) / gridSize);
      int endY = (int) ((query.y + query.h) / gridSize);

      for (int y = max(0, startY - 1); y <= min(walkable.length - 1, endY + 1); ++y)
        for (int x = max(0, startX - 1); x <= min(walkable[y].length - 1, endX + 1); ++x)
          if (!walkable[y][x] &&  
            boxCollided(query.x, query.y, query.w, query.h, x * gridSize, y * gridSize, gridSize, gridSize))
            return true;
      return false;
    }
  }

  abstract class HospitalPlayer extends Entity {
    Direction lastHorizontal;
    PlayerInfo character;

    PImage idle, walk1, walk2;
    final int walkFrames=10;
    int changeTimer;
    PImage curSprite;
    int lastWalkFrame;

    float frontMargin, backMargin, topMargin, botMargin;
    final float speedMultiplier = 1;

    HospitalPlayer(float x, float y, int w, int h, float backMargin, float frontMargin, float topMargin, float botMargin, PlayerInfo character, PImage idle, PImage walk1, PImage walk2) {
      super(x + backMargin, y + topMargin, w - backMargin - frontMargin, h - topMargin - botMargin);
      // set the margins & initialize variables
      this.backMargin = backMargin;
      this.frontMargin = frontMargin;
      this.topMargin = topMargin;
      this.botMargin = botMargin;

      lastHorizontal = Direction.right;
      this.character = character;

      this.idle = idle;
      this.walk1 = walk1;
      this.walk2 = walk2;

      this.changeTimer = 0;
      curSprite = idle;
      lastWalkFrame = -1000;
    }
    void movedSpriteUpdate() {
      if (curSprite != walk1 && curSprite != walk2) {
        curSprite = walk1;
        changeTimer = walkFrames;
      }
      lastWalkFrame = curFrame;
    }
    void moveRight() {
      curWorld.moveEntitySoft(this, character.speed * speedMultiplier, 0);
      lastHorizontal = Direction.right;
      movedSpriteUpdate();
    }
    void moveLeft() {
      curWorld.moveEntitySoft(this, -character.speed * speedMultiplier, 0);
      lastHorizontal = Direction.left;
      movedSpriteUpdate();
    }
    void moveUp() {
      curWorld.moveEntitySoft(this, 0, -character.speed * speedMultiplier);
      movedSpriteUpdate();
    }
    void moveDown() {
      curWorld.moveEntitySoft(this, 0, character.speed * speedMultiplier);
      movedSpriteUpdate();
    }
    void tick() {
      if (curFrame - lastWalkFrame > 3) {
        curSprite = idle;
      }
      if (curSprite == walk1 && changeTimer <= 0) {
        curSprite = walk2;
        changeTimer = walkFrames;
      }
      if (curSprite == walk2 && changeTimer <= 0) {
        curSprite = walk1;
        changeTimer = walkFrames;
      }
      changeTimer--;
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

      // draws the health bar
      float barLeft = centerX() - 20;
      float barWidth = 40;
      fill(0, 0, 0, 0);
      stroke(255);
      strokeWeight(0.5);
      rect(barLeft, y - 5 - topMargin, barWidth, 5);
      fill(255, 0, 0);
      rect(barLeft, y - 5 - topMargin, barWidth * character.health / character.maxHealth, 5);
    }
  }

  Hospital getWorldOf(String filePath, HospitalPlayer player) {
    String[] lines = loadStrings(filePath);
    int rows = Integer.parseInt(lines[0].split(" ")[0]);
    int cols = Integer.parseInt(lines[0].split(" ")[1]);
    String[] mapLines = new String[lines.length - 1];
    for (int i = 0; i < mapLines.length; ++i)
      mapLines[i] = lines[i + 1];

    HospitalElement[][] elements = new HospitalElement[rows][cols];
    boolean[][] walkable = new boolean[rows][cols];
    for (int r = 0; r < rows; ++r) {
      for (int c = 0; c < cols; ++c) {
        if (mapLines[r].charAt(c) == 'W') {
          elements[r][c] = HospitalElement.Wall;
          walkable[r][c] = false;
        } else if (mapLines[r].charAt(c) == 'F') {
          elements[r][c] = HospitalElement.Floor;
          walkable[r][c] = true;
        } else if (mapLines[r].charAt(c) == 'H') {
          elements[r][c] = HospitalElement.Health;
          walkable[r][c] = true;
        } else if (mapLines[r].charAt(c) == 'U') {
          elements[r][c] = HospitalElement.Upgrade;
          walkable[r][c] = true;
        } else if (mapLines[r].charAt(c) == 'E') {
          elements[r][c] = HospitalElement.Exit;
          walkable[r][c] = true;
        }
      }
    }
    return new Hospital(elements, walkable, player);
  }


  class Knight extends HospitalPlayer {
    Knight(float x, float y, int w, int h, PlayerInfo character) {
      super(x, y, w, h, w * 0.35, w * 0.4, h * 0.2, h * 0.2, character, knightIdle, knightWalk1, knightWalk2);
    }
  }

  class Wizard extends HospitalPlayer {
    Wizard(float x, float y, int w, int h, PlayerInfo character) {
      super(x, y, w, h, w * 0.4, w * 0.35, h * 0.25, h * 0.2, character, wizardIdle, wizardWalk1, wizardWalk2);
    }
  }

  class Archer extends HospitalPlayer {
    Archer(float x, float y, int w, int h, PlayerInfo character) {
      super(x, y, w, h, w * 0.35, w * 0.3, h * 0.2, h * 0.2, character, archerIdle, archerWalk1, archerWalk2);
    }
  }

  void keyPressed() {
    if (key == 'e' || key == 'E') {
      if (stepDoor(50, 450, 50, 50)) {
        exitHospitalClicked();
      }
      if (stepDoor(450, 50, 50, 50)) {
        healing();
      }
      if (stepDoor(450, 450, 50, 50)) {
        upgrades();
      }
    }
  }

  void tick() {
    curFrame++;
    curWorld.tick();
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

  HospitalPlayer getPlayerOf(float x, float y, PlayerInfo character) {
    if (character.playerClass == PlayerClass.Knight) {
      return new Knight(x, y, knightWidth, knightHeight, character);
    } else if (character.playerClass == PlayerClass.Archer) {
      return new Archer(x, y, archerWidth, archerHeight, character);
    } else if (character.playerClass == PlayerClass.Wizard) {
      return new Wizard(x, y, wizardWidth, wizardHeight, character);
    } else {
      println("Unidentified player class (in hospital.getPlayerOf)!");
      return null;
    }
  }


  void drawOverlays() {
    fill(0, 0, 0, 100);
    noStroke();
    rect(0, 0, width, 28);

    textFont(mainMenuFont3);
    textSize(20);
    fill(255);
    textAlign(CENTER);
    if (stepDoor(50, 450, 50, 50)) {
      text("Press E to exit", width/2, 20);
    } else if (stepDoor(450, 50, 50, 50)) {
      text("Press E to heal", width/2, 20);
    } else if (stepDoor(450, 450, 50, 50)) {
      text("Press E to upgrade", width/2, 20);
    }

    textAlign(RIGHT);
    text("Coins: " + curPlayer.character.coins, width, 20);
  }

  void render() {
    background(0);
    curWorld.render();
    drawOverlays();
  }
}
