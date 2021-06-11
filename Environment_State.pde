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
  void npcClicked(String name) {
    // TODO add default NPC states and also get overrides
  }
}

class OutdoorState extends EnvironmentState {
  PlayerInfo stats;
  public OutdoorState(PlayerInfo player) {
    this.stats = player;
  }
  void tick() {
  }
  void render() {
  }
  void enterHospital() {
    curEnvironment = new HospitalInteriorState(this.stats, this);
  }
  void enterNormalDungeon() {
    
  }
  void enterProgressiveDungeon() {
  }
  void guildHQ() {
    curEnvironment = new GuildHQState(this.stats, this);
  }
  void enterCastle() {
    curEnvironment = new CastleInteriorState(this.stats, this);
  }
}

class HospitalInteriorState extends EnvironmentState {
  PlayerInfo stats;
  EnvironmentState previous;
  public HospitalInteriorState(PlayerInfo player, EnvironmentState previous) {
    this.stats = player;
    this.previous = previous;
  }
  void tick() {
  }
  void render() {
  }
  void exitHospital() {
    curEnvironment = previous;
  }
}

class CastleInteriorState extends EnvironmentState {
  PlayerInfo stats;
  EnvironmentState previous;
  public CastleInteriorState(PlayerInfo player, EnvironmentState previous) {
    this.stats = player;
    this.previous = previous;
  }
  void tick() {
  }
  void render() {
  }
  void exitCastle() {
    curEnvironment = previous;
  }
}


class GuildHQState extends EnvironmentState {
  PlayerInfo stats;
  EnvironmentState previous;
  public GuildHQState(PlayerInfo player, EnvironmentState previous) {
    this.stats = player;
    this.previous = previous;
  }
  void tick() {
  }
  void render() {
  }
  void exitGuildHQ() {
    curEnvironment = previous;
  }
}
