class TutorialState extends State {
  PlayerInfo info; // the current character
  String[] wizidetteDialogue; // array of lines for the wizard to say

  int curDialogue; // the current index of the current thing to say
  final int rectX=width-650, rectY=100, rectW=500, rectH=80; // dimensions for the background for the text
  final int wizardX=width-150, wizardY=75, wizardW=150, wizardH=150; // dimensions for the wizidette trainer in the background

  TutorialState(PlayerInfo character) {
    this.info = character; // initializing variables
    // initialize the dialogue
    wizidetteDialogue = new String[]{
      "Hello! I am cheollin, working as a wizidette, and your trainer to get you accustomed to being a first time adventurer!", 
      "It's also my first time... but please bear with me!", 
      "At any point in time, press 'g' to exit the tutorial", 
      "To start, you can move around using the WASD controls (make sure caps lock is off!), and clicking 'm' opens the ingame menu", 
      "When you enter a dungeon, you'll be able to attack by using the mouse buttons (LMB & RMB)", 
      "Since it's your first time wielding your weapon, I advise you to experiment around once you're in a dungeon", 
      "Regardless, now I'm going to get you used to the buildings you'll need to know about as an adventurer", 
      "Please follow the green line, and enter the hospital", 
      "This is the hospital, where we wizards can perform all kinds of tricks on your body~", 
      "In the top right, you'll have the ability to heal free of cost!", 
      "In the bottom right, we have the upgrading station, where you can improve your stats and make yourself stronger!", 
      "As you make yourself a more well established adventurer, your level cap for each skill will increase", 
      "allowing us to make you stronger!", 
      "Upgrading also requires coins, which you can get from dungeons", 
      "Finally, in the bottom left, you have the ability to exit the hospital, do that when you're ready to leave", 
      "I finally got through the first stage of social interaction... yayyyyyyy~", 
      "Oh- oh hello, you're back", 
      "Next on the list is the coins dungeon, please follow the green line", 
      "The coins dungeon has mobs of all sorts, most of them have recently been guarding our stashes of treasure... ", 
      "So of course we'll want someone to defeat them for us!", 
      "You get awarded coins for defeating monsters, and in the coins dungeon, there's a chest at the end", 
      "Retrieve it and you'll be rewarded handsomely!", 
      "The coins dungeon is a great way to get the money needed to upgrade your stats!", 
      "Finally, let's go to the story dungeon, follow the green line please~", 
      "The story dungeon is where you go to fight push back the enemies, and in doing so defend this village", 
      "It's a dangerous place, but it's how you progress in the story!", 
      "By doing story dungeons, you also become more mentally capable, and that means that we can upgrade you to even higher levels!", 
      "In other words, doing story dungeons allows you to increase your max level, so make sure to do them!", 
      "Oh- you want to know why we're so adament on protecting this place?", 
      "Well, the outside world is a dark and gloomy place...", 
      "Don't tell anybody, but I actually tried running away from this village once...", 
      "and the air suddenly became... unbearably hot, I suddenly started coughing, and I could barely even breathe.", 
      "It's a miracle I even made it back alive!", 
      "So, I think we have to defend this place because there's no where else to run to", 
      "You know the legend about how this village came to be? The part where the mages erected a barrier? ", 
      "Perhaps it wasn't to keep monsters away, ", 
      "but to keep us safe from the very smoke that our ancient factories hundreds of kilometres away spew out to provide us with energy", 
      "And now that I think about it, maybe these monsters were just trying to find a better place to live, ", 
      "and have simply adapted to the horrid the conditions out there", 
      "R-R-Regardless, good luck on your adventure!", 
      "Sorry for getting carried away! I think I said something I shouldn't have... please forget it!", 
      "I recommend you start with the first story dungeon!", 
      "Have a good day! Goodbye!"
    };
    
    // set the current environment to the "tutorial overworld"
    curDialogue = 0;
    changeEnvironment(new TutorialOver(info));
  }
  void tick() {
    // let the current environment also update its logic
    curEnvironment.tick();

    // if the conversation is done, then throw the wizard into a new world
    if (curDialogue >= wizidetteDialogue.length) {
      curState = new DefaultState();
      changeEnvironment(new OverworldEnvironment(info));
    }
  }
  void render() {
    // get the environment to render
    curEnvironment.render();
    
    // draw the background rectangle
    fill(#03D7FF);
    stroke(#03A9FF);
    strokeWeight(5);
    rectMode(CORNER);
    rect(rectX, rectY, rectW, rectH);

    // draw the text for the dialogue
    textFont(tutorialFont);
    textSize(18);
    textAlign(CENTER);
    fill(0);
    if (curDialogue < wizidetteDialogue.length) {
      text(wizidetteDialogue[curDialogue], rectX+5, rectY+5, rectW-10, rectH-10);
    }

    // draw the current pose (we alternate between the poses for wizidette)
    image(wizidettePoses[curDialogue % wizidettePoses.length], wizardX, wizardY);
  }

  // altered overworld environment made for the tutorial
  class TutorialOver extends OverworldEnvironment {
    TutorialOver(PlayerInfo character) {
      super(character);
    }
    void tick() {
      super.tick();
      
      // if the wizidette is prompting the user to go to the coins dungeon, or the story dungeon, then when the user has actually gotten there, we continue the conversation
      if (curDialogue == 17 && curPlayer.x > 97 * World.gridSize && curPlayer.y < 11 * World.gridSize) {
        curDialogue = 18;
      }
      if (curDialogue == 23 && curPlayer.x > 97 * World.gridSize && curPlayer.y > 21 * World.gridSize) {
        curDialogue = 24;
      }
    }
    void enterHospital() {
      // go into the tutorial hospital
      changeEnvironment(new TutorialHospital(this, curPlayer.character));
      
      // continue the conversation once the person has entered
      if (curDialogue == 7) {
        curDialogue = 8;
      }
    }
    // overriding enter doors, so that the player can only enter the hospital in the tutorial
    void enterDoors() {
      // we only ever check for the hospital (we don't go into dungeons in the tutorial)
      if (stepDoor(1400, 1250, 50, 50)) {
        enterHospital();
      }
    }
    void render() {
      super.render();

      // we're drawing the world, so we need to alter the matrix to conform to the camera
      pushMatrix();
      curWorld.camera.alterMatrix();
      stroke(#02A000);
      strokeWeight(5);
      
      // if we're going to the hospital, then we draw lines to the hospital (from the user's spawn point)
      if (curDialogue == 7) {
        line(5*World.gridSize, 10*World.gridSize, 10*World.gridSize, 11*World.gridSize);
        line(10*World.gridSize, 11*World.gridSize, 11*World.gridSize, 19*World.gridSize);
        line(11*World.gridSize, 19*World.gridSize, 19*World.gridSize, 27 * World.gridSize);
        line(19*World.gridSize, 27 * World.gridSize, 28.5*World.gridSize, 27*World.gridSize);
        line(28.5*World.gridSize, 27*World.gridSize, 28.5*World.gridSize, 25 * World.gridSize);
      } else if (curDialogue == 17) {
        // draw lines to the coins dungeon (from the hospital)
        line(10*World.gridSize, 11*World.gridSize, 11*World.gridSize, 19*World.gridSize);
        line(11*World.gridSize, 19*World.gridSize, 19*World.gridSize, 27 * World.gridSize);
        line(19*World.gridSize, 27 * World.gridSize, 28.5*World.gridSize, 27*World.gridSize);
        line(28.5*World.gridSize, 27*World.gridSize, 28.5*World.gridSize, 25 * World.gridSize); 
        line(10*World.gridSize, 11 * World.gridSize, 19*World.gridSize, 11*World.gridSize);
        line(19*World.gridSize, 11*World.gridSize, 38*World.gridSize, 14*World.gridSize);
        line(38*World.gridSize, 14*World.gridSize, 82*World.gridSize, 14 * World.gridSize);
        line(82*World.gridSize, 14 * World.gridSize, 103 * World.gridSize, 8 * World.gridSize);
      } else if (curDialogue == 23) {
        // draw lines to the story dungeon (from the hospital)
        line(82*World.gridSize, 14 * World.gridSize, 103 * World.gridSize, 8 * World.gridSize);
        line(82*World.gridSize, 14 * World.gridSize, 97*World.gridSize, 23 * World.gridSize);
        line(97*World.gridSize, 23 * World.gridSize, 110 * World.gridSize, 24 * World.gridSize);
      }
      popMatrix();
    }
    void keyPressed() {
      // we enter the places if and only if we're currently prompting the user to enter them (i.e the wizard isn't in an active conversation with them)
      if ((key == 'e' || key == 'E') && (curDialogue == 7 || curDialogue == 14 || curDialogue == 17 || curDialogue == 23)) {
        enterDoors();
      }

      // open the menu when 'm' is clicked
      if (key == 'm' || key == 'M') {
        curState = new OverworldMenuState(curState, curPlayer.character);
      }
    }
  }

  // we continue the dialogue if we're not prompting the user to move somewhere
  void mousePressed() {
    if (curDialogue != 7 && curDialogue != 14 && curDialogue != 17 && curDialogue != 23) {
      curDialogue++;
    }
  }

  void keyPressed() {
    curEnvironment.keyPressed();
    // if 'g' is pressed, then we go to the end of the conversation
    if (key == 'g' || key == 'G') {
      curDialogue = wizidetteDialogue.length + 1;
    }
  }

  class TutorialHospital extends HospitalEnvironment {
    TutorialHospital(OverworldEnvironment previous, PlayerInfo character) {
      super(previous, character);
    }
    // when we exit the hospital
    void exitHospitalClicked() { 
      changeEnvironment(previous);
      // if we were prompted to leave the hospital, then continue the conversation
      if (curDialogue == 14) {
        curDialogue = 15;
      }
    }
    void render() {
      super.render();
      // once again we're drawing in the world and conforming to the camera
      pushMatrix();
      curWorld.camera.alterMatrix();
      
      // draw boxes for if and when the wizidette is mentioning them
      fill(0, 0, 0, 0);
      stroke(0, 0, 255);
      strokeWeight(2);
      
      // draw the rectangle and different coordinates depending on what the wizidette is currently saying
      if (curDialogue == 9) {
        rect(450, 50, 50, 50);
      } else if (curDialogue == 10 || curDialogue == 11 || curDialogue == 12 || curDialogue == 13) {
        rect(450, 450, 50, 50);
      } else if (curDialogue == 14) {
        rect(50, 450, 50, 50);
      }
      
      popMatrix();
    }
    void keyPressed() {
      // only allow them to click things if the wizard isn't actively talking to them
      if ((key == 'e' || key == 'E') && (curDialogue == 7 || curDialogue == 14 || curDialogue == 17 || curDialogue == 23)) {
        enterDoors();
      }

      // open the menu when 'm' is clicked
      if (key == 'm' || key == 'M') {
        curState = new OverworldMenuState(curState, curPlayer.character);
      }
    }
  }
}
