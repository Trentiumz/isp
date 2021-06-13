abstract class State {
  abstract void render();
  abstract void tick();
  void setup() {
  }
  void mousePressed() {
  }
  void mouseReleased() {
  }
  void keyPressed() {
  }
  void keyReleased() {
  }
  void mouseClicked() {
  }
}

class MainMenuState extends State {
  void tick() {
  }
  void render() {
  }
}

class InstructionsState extends State {
  void tick() {
  }
  void render() {
  }
}

class EndGameState extends State {
  void tick() {
  }
  void render() {
  }
}

class CreditsState extends State {
  void tick() {
  }
  void render() {
  }
}

class InventoryState extends State {
  State previous;
  void tick() {
  }
  void render() {
  }
  void exitInventory() {
    curState = previous;
  }
}

class LoadingState extends State {
  LoadingState(){
    thread("loadFiles");
  }
  void tick() {
    if (currentMessage.equals("completed")) {
      PlayerInfo samplePlayer = new PlayerInfo(9999, 100, 20, 5, 10, 5, 0, PlayerClass.Knight);
      curEnvironment = new SerpantBossDungeon(null, samplePlayer);
      curState = new DefaultState();
    }
  }
  void render() {
    fill(#7C4400);
    text(currentMessage, width / 2 - 100, height / 2 - 100);
  }
}

class DefaultState extends State {
  void tick() {
    curEnvironment.tick();
  }
  void render() {
    curEnvironment.render();
  }
  void mousePressed() {
    curEnvironment.mousePressed();
  }
  void mouseReleased() {
    curEnvironment.mouseReleased();
  }
  void keyPressed() {
    curEnvironment.keyPressed();
  }
  void keyReleased() {
    curEnvironment.keyReleased();
  }
  void mouseClicked() {
    curEnvironment.mouseClicked();
  }
}
