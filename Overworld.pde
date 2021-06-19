// enum for the current element in the overworld
enum OverworldElement {
  Wall1, Grass, Path, Hospital, TreeStump, HospitalWall, HospitalDoor, CaveEntrance, Dirt, House1, House2, Sign1, Sign2, Sign3, Sign4
};

// the standard "outdoors" overworld
class OverworldEnvironment extends EnvironmentState {
  Overworld curWorld; // current world
  OverPlayer curPlayer; // current player
  int curFrame = 0; // the current frame

  // enter the hospital
  void enterHospital() {
    changeEnvironment(new HospitalEnvironment(this, curPlayer.character));
  }

  // play/stop the background music
  void playBackgroundMusic() {
    outdoorsBGM.loop();
  }
  void stopBackgroundMusic() {
    outdoorsBGM.stop();
  }

  // made for when we "exit" or "enter" the state (when it is no longer the "active" state)
  void exitState() {
    stopBackgroundMusic();
  }
  void enterState() {
    playBackgroundMusic();
  }

  // enter the dungeons
  void enterStoryDungeon() {
    changeEnvironment(getStoryDungeon(storyDungeonsCompleted, this, curPlayer.character));
  }
  void enterCoinsDungeon() {
    changeEnvironment(new CoinsDungeon(this, curPlayer.character));
  }

  // whether or not the current player is overlapping the door
  boolean stepDoor(float bx, float by, float bw, float bh) {
    if (curPlayer.x >= bx && curPlayer.y >= by && curPlayer.x <= bx + bw && curPlayer.y <= by + bh) {
      return true;
    } 
    return false;
  }

  // draws the overlays for player info
  void drawOverlays() {
    // draw the background rectangle
    fill(0, 0, 0, 100);
    noStroke();
    rect(0, 0, width, 28);

    // if the player is on a door, prompt them to press e
    textFont(mainMenuFont3);
    textSize(20);
    fill(255);
    textAlign(CENTER);
    if (stepDoor(1400, 1250, 50, 50) || stepDoor(5200, 300, 50, 50) || stepDoor(5400, 1050, 50, 50)) {
      text("Press E to enter", width/2, 20);
    }

    // print the number of coins
    textAlign(RIGHT);
    text("Coins: " + curPlayer.character.coins, width, 20);
  }

  // for when the player wants to enter a door
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

  // The constructor for the State
  OverworldEnvironment(PlayerInfo character) {
    curPlayer = getPlayerOf(60, 400, character);
    curWorld = getWorldOf("over_maps/overworld1.txt", curPlayer);
    this.setup();
  }

  // called once at the start of the environment
  void setup() {
    playBackgroundMusic();
  }

  // the class for the overworld
  class Overworld extends World {
    OverPlayer player; // current player
    OverworldElement[][] tileMap; // tilemapping of the world
    PImage grass, wall1, path, hospital, treestump, hospitalwall, hospitaldoor, caveentrance, dirt, house1, house2, sign1, sign2, sign3, sign4; // images for the "tiles"

    // initializing elements
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

    // updating "logic"
    void tick() {
      player.tick();
    }

    // drawing onto the screen
    void render() {
      // move the camera to the player
      camera.centerOnEntity(player);
      // alter the matrix to conform to the camera positions
      pushMatrix();
      camera.alterMatrix();

      // draw images based on the current tile
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

      // draw the player
      player.render();
      popMatrix();
    }
  }

  // the Overworld Player
  abstract class OverPlayer extends Entity {
    Direction lastHorizontal; // last horizontal movement
    PlayerInfo character; // the character detailing the statistics

    PImage idle, walk1, walk2; // the images for the sprites
    final int walkFrames=10; // intervals of the walking frames
    int changeTimer; // the timer for going to the next state
    PImage curSprite; // the current sprite
    int lastWalkFrame; // the last frame in which the player moved

    float frontMargin, backMargin, topMargin, botMargin; // the margins of the image to the actual player bounding box

    final float overworldSpeed = 15; // the speed in the overworld

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

    // updating the sprite for when it moved
    void movedSpriteUpdate() {
      if (curSprite != walk1 && curSprite != walk2) {
        curSprite = walk1;
        changeTimer = walkFrames;
      }
      lastWalkFrame = curFrame;
    }

    // functions for moving in the 4 directions
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

    // updating the "logic"
    void tick() {
      // if we haven't walked in a while, then go back to idling
      if (curFrame - lastWalkFrame > 3) {
        curSprite = idle;
      }

      // once the change timer has run out and we're currently walking, then go to the other walk frame
      if (curSprite == walk1 && changeTimer <= 0) {
        curSprite = walk2;
        changeTimer = walkFrames;
      }
      if (curSprite == walk2 && changeTimer <= 0) {
        curSprite = walk1;
        changeTimer = walkFrames;
      }

      // continue the timer
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

  // convert a text file and the player into an overworld
  Overworld getWorldOf(String filePath, OverPlayer player) {
    // get the lines
    String[] lines = loadStrings(filePath);

    // the first line gives the dimensions
    int rows = Integer.parseInt(lines[0].split(" ")[0]);
    int cols = Integer.parseInt(lines[0].split(" ")[1]);

    // the lines for the map itself
    String[] mapLines = new String[lines.length - 1];
    for (int i = 0; i < mapLines.length; ++i)
      mapLines[i] = lines[i + 1];

    // initialize the elements and grids
    OverworldElement[][] elements = new OverworldElement[rows][cols];
    boolean[][] walkable = new boolean[rows][cols];

    // fill out the elements and walkable grid
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

    // create a new overworld with these elements
    return new Overworld(elements, walkable, player);
  }

  // starting statistics for the knight, wizard and archer
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

  // updating the "logic" of this state
  void tick() {
    // go to the next frame
    curFrame++;
    // get the world to "tick"
    curWorld.tick();

    // move the player
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

  // draw the player onto the screen
  void render() {
    background(0);
    curWorld.render();
    drawOverlays();
  }

  void keyPressed() {
    // if 'e' is pressed, then try and enter any doors within its proximity
    if (key == 'e' || key == 'E') {
      enterDoors();
    }

    // open the menu when 'm' is clicked
    if (key == 'm' || key == 'M') {
      curState = new OverworldMenuState(curState, curPlayer.character);
    }
  }

  // get the player given its stats in PlayerInfo
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

// the elements of a hospital
enum HospitalElement {
  Wall, Floor, Health, Upgrade, Exit
};

class HospitalEnvironment extends EnvironmentState {
  Hospital curWorld; // current world
  HospitalPlayer curPlayer; // current player
  int curFrame = 0; // current frame
  OverworldEnvironment previous; // previous world

  // constructor with initializing variables
  HospitalEnvironment(OverworldEnvironment previous, PlayerInfo character) {
    curPlayer = getPlayerOf(60, 400, character);
    curWorld = getWorldOf("over_maps/hospital.txt", curPlayer);
    this.previous = previous;
  }

  // states for when the hospital environment becomes or stops being the "active" state
  void enterState() {
    playBackgroundMusic();
  }
  void exitState() {
    stopBackgroundMusic();
  }

  // play/stop background music
  void playBackgroundMusic() {
    hospitalBGM.loop();
  }
  void stopBackgroundMusic() {
    hospitalBGM.stop();
  }

  // when various parts of the hospital are clicked
  void exitHospitalClicked() { 
    changeEnvironment(previous);
  }
  void healing() { 
    curPlayer.character.health = curPlayer.character.maxHealth;
  }
  void upgrades() { 
    curState = new UpgradingState(curPlayer.character);
  }

  // returns if the player has stepped on a door
  boolean stepDoor(float bx, float by, float bw, float bh) {
    if (curPlayer.x >= bx && curPlayer.y >= by && curPlayer.x <= bx + bw && curPlayer.y <= by + bh) {
      return true;
    } 
    return false;
  }

  // the world of the hospital
  class Hospital extends World {
    HospitalPlayer player; // current player
    HospitalElement[][] tileMap; // tilemapping
    PImage wall, floor, health, upgrade, exit; // images for different types of tiles

    // constructor initializing variables
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

    // the "logic" updating each frame
    void tick() {
      player.tick();
    }

    // drawing the world onto the screen
    void render() {
      // center the camera on the player and alter the matrix so that we only see the proper part of the world
      camera.centerOnEntity(player);
      pushMatrix();
      camera.alterMatrix();

      // draw the tiles onto the screen
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

      // get the player to render
      player.render();
      popMatrix();
    }
  }

  // the hospital player
  abstract class HospitalPlayer extends Entity {
    Direction lastHorizontal; // last horizontal direction
    PlayerInfo character; // the info for the player

    PImage idle, walk1, walk2; // different images for walking and idling
    final int walkFrames=10; // the interval to switch steps
    int changeTimer; // the timer for switching to the next step
    PImage curSprite; // current image
    int lastWalkFrame; // last frame in which the player "walked"

    float frontMargin, backMargin, topMargin, botMargin; // the margins between the actual player and the image
    final float speedMultiplier = 1; // how much faster the player is than their "base speed"

    // constructor initializing values
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

    // update the sprite for when we moved
    void movedSpriteUpdate() {
      if (curSprite != walk1 && curSprite != walk2) {
        curSprite = walk1;
        changeTimer = walkFrames;
      }
      lastWalkFrame = curFrame;
    }

    // event handling for moving in the 4 main directions
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

    // updating the "logic" of the program each frame0
    void tick() {
      // if we haven't walked for 3 frames, go back to idling
      if (curFrame - lastWalkFrame > 3) {
        curSprite = idle;
      }

      // if the change Timer is done, then swap the step
      if (curSprite == walk1 && changeTimer <= 0) {
        curSprite = walk2;
        changeTimer = walkFrames;
      }
      if (curSprite == walk2 && changeTimer <= 0) {
        curSprite = walk1;
        changeTimer = walkFrames;
      }

      // continue the timer for changing the step
      changeTimer--;
    }

    // drawing onto the screen
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

  // converts a text file into a hospital world
  Hospital getWorldOf(String filePath, HospitalPlayer player) {
    // get the lines of the text file
    String[] lines = loadStrings(filePath);

    // the dimensions are on the first line of the text file
    int rows = Integer.parseInt(lines[0].split(" ")[0]);
    int cols = Integer.parseInt(lines[0].split(" ")[1]);

    // the lines for maps
    String[] mapLines = new String[lines.length - 1];
    for (int i = 0; i < mapLines.length; ++i)
      mapLines[i] = lines[i + 1];

    // elements that the program can actually understand
    HospitalElement[][] elements = new HospitalElement[rows][cols];
    boolean[][] walkable = new boolean[rows][cols];

    // fill out the elements and whether or not it is walkable at that tile
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

    // return a hospital with these statistics
    return new Hospital(elements, walkable, player);
  }

  // the default players for the 3 classes
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

  // handling key presses
  void keyPressed() {
    // when 'e' is pressed, see if we're at any door
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
    
    // open the menu when 'm' is clicked
    if (key == 'm' || key == 'M') {
      curState = new OverworldMenuState(curState, curPlayer.character);
    }
  }

  // "logic" updates each frame
  void tick() {
    // go to the next frame
    curFrame++;

    // get the world to do whatever logic is necessary
    curWorld.tick();

    // move the player
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

  // create a player for the hospital given the statistics of the player
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

  // draw overlays for the hospital
  void drawOverlays() {
    // draw background rectangle
    fill(0, 0, 0, 100);
    noStroke();
    rect(0, 0, width, 28);

    // draw the different prompts for when we're at an upgrade station, healing station, or exit
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

    // draw the number of coins the player has
    textAlign(RIGHT);
    text("Coins: " + curPlayer.character.coins, width, 20);
  }

  // drawing onto the screen
  void render() {
    background(0);
    curWorld.render();
    drawOverlays();
  }
}
