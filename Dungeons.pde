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
      println(curRoom);
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
