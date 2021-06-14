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
  final int numFrames = 30;
  int curLoadingFrame;
  final int ringWidth=180, ringHeight=180;

  LoadingState() {
    thread("loadFiles");
    if (!currentMessage.equals("completed")) {
      loadingAnimation = new PImage[numFrames];
      loadFrames();
    }
    curLoadingFrame = 0;
  }

  void loadFrames() {
    for (int i = 0; i < numFrames; ++i) {
      loadingAnimation[i] = loadImage("animations/loading/frame_" + formatAnimationNum(i) + "_delay-0.03s.gif");
    }
    for (int i = 0; i < numFrames; ++i) {
      loadingAnimation[i].resize(ringWidth, ringHeight);
    }
  }

  String formatAnimationNum(int frame) {
    if (frame == 0) {
      return "00";
    } else if (frame < 10) {
      return "0" + frame;
    } else {
      return "" + frame;
    }
  }
  void tick() {
    if (currentMessage.equals("completed")) {
      curState = new SplashState();
    }
  }
  void render() {
    image(loadingAnimation[curLoadingFrame], width / 2 - ringWidth / 2, height / 2 - ringHeight / 2);
    curLoadingFrame = (curLoadingFrame + 1) % numFrames;
    fill(#7C4400);
    textAlign(CENTER);
    text(currentMessage, width / 2, height / 2 + 100);
  }
}

class SplashState extends State {
  int numFrames = 51;
  int curAnimationFrame;

  SplashState() {
    curAnimationFrame = 0;
  }
  void tick() {
    if (curAnimationFrame >= splashAnimation.length) {
      PlayerInfo samplePlayer = new PlayerInfo(9999, 100, 20, 5, 10, 5, 0, PlayerClass.Knight);
      curEnvironment = new DragonBossDungeon(null, samplePlayer);
      curState = new DefaultState();
    }
  }
  void render() {
    int index = curAnimationFrame % numFrames;
    image(splashAnimation[index], 0, 0);
    curAnimationFrame += 1;
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
