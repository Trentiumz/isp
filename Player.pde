/*
  Description: Code for the character
*/

// the different classes
enum PlayerClass {
  Knight, Wizard, Archer
};

// the information for the player - this should be persisted throughout the game
class PlayerInfo {
  // basic statistics
  float health;
  float maxHealth;
  float baseA1Attack;
  float baseA2Attack;
  int framesBetweenA1;
  int framesBetweenA2;
  int coins;
  float speed;
  PlayerClass playerClass;
  
  // the "levels" of its stats; keeps track of how many times something has been upgraded so that we can implement a "level cap"
  int healthLevel;
  int speedLevel;
  int a1AtkLevel;
  int a2AtkLevel;
  
  PlayerInfo(float maxHealth, float A1Damage, float A2Damage, int A1Frames, int A2Frames, float speed, int coins, PlayerClass currentClass) {
    // initialize variables
    this.health = maxHealth;
    this.maxHealth = maxHealth;
    baseA1Attack = A1Damage;
    baseA2Attack = A2Damage;
    framesBetweenA1 = A1Frames;
    framesBetweenA2 = A2Frames;
    this.coins = coins;
    this.playerClass = currentClass;
    this.speed = speed;
    
    healthLevel = 1;
    speedLevel = 1;
    a1AtkLevel = 1;
    a2AtkLevel = 1;
  }
}
