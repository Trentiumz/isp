abstract class StoryModule {
  StoryModule next;
  abstract void tick();
  abstract void render();
  void moduleCompleted() {
    curStory = next;
  }
  void mousePressed() {
    curState.mousePressed();
  }
  void mouseReleased() {
    curState.mouseReleased();
  }
  void keyPressed() {
    curState.keyPressed();
  }
  void keyReleased() {
    curState.keyReleased();
  }
  void mouseClicked() {
    curState.mouseClicked();
  }
  void coinDungeonStarted() {
  }
  void storyDungeonStarted() {
  }
  void coinDungeonCompleted() {
  }
  void storyDungeonCompleted() {
  }
  void npcConversationEnded(String name) {
  }
}

class CutScene extends StoryModule{
 void tick(){
   
 }
 void render(){
   
 }
}

class NoStory extends StoryModule{
 void tick(){
  curState.tick(); 
 }
 void render(){
  curState.render(); 
 }
}
