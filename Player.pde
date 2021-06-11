enum PlayerClass {
  Knight, Wizard, Archer
};
class PlayerInfo {
  float health;
  float maxHealth;
  float baseA1Attack;
  float baseA2Attack;
  int framesBetweenA1;
  int framesBetweenA2;
  int coins;
  float speed;
  PlayerClass playerClass;
  PlayerInfo(float maxHealth, float A1Damage, float A2Damage, int A1Frames, int A2Frames, float speed, int coins, PlayerClass currentClass) {
    this.health = maxHealth;
    this.maxHealth = maxHealth;
    baseA1Attack = A1Damage;
    baseA2Attack = A2Damage;
    framesBetweenA1 = A1Frames;
    framesBetweenA2 = A2Frames;
    this.coins = coins;
    this.playerClass = currentClass;
    this.speed = speed;
  }
}

class OverworldPlayer{
  
}

class DungeonPlayer{
  
}
