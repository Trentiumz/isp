// template for the different environments
abstract class EnvironmentState {
  abstract void render();
  abstract void tick();
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
  void exitState(){
  }
  void enterState(){
  }
}
