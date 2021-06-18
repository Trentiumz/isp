class BeginCYOAState extends State {
  void tick() {
  }
  void render() {
    draw();
  }
  void raidersFightTextAnimation() {
    curState = new ClassChoiceState();
  }

  BeginCYOAState() {
    setup();
  }

  PVector buttonSize = new PVector (150, 30);

  int levelNumber;
  String textForMyLevel [];
  String buttonOneText [];
  String buttonTwoText [];
  int playerChoice; 

  PImage img;
  PImage img2;
  PImage img3;
  PImage img4;
  PImage img5;
  PFont font;
  PFont font2;

  void setup() {
    size(1000, 800);
    font = beginCYOAFont;
    font2 = beginCYOAFont2;
    img = beginCYOAImg;
    img2 = beginCYOAImg2;
    img3 = beginCYOAImg3;
    img4 = beginCYOAImg4;
    img5 = beginCYOAImg5;

    levelNumber = 0;
    playerChoice = 0;
    textForMyLevel = new String [9];

    textForMyLevel[0] = "It is the year 1378 on Earth-024. \nYou are an apprentice to a successful merchant in your town. The life of a merchant’s apprentice is a tad mundane. \nThis occupation does give you access to a fairly high education and an adept understanding of financial matters, however you yearn for adventure. \nOne scorching evening, you are near the outskirts of the town on your way to the town square with a friend of yours, Trent, \nwho you’ve known for 10 years. Trent is a squire for a prominent knight from the city. \n“He is so lucky, he gets to go on so many adventures” you think to yourself. \nWhile on the way, you notice something peculiar near the outpost fences. You think you notice a flicker of movement within the shadows. \n“Wait, did you see that?” you ask Trent. \n“Huh? What? Nah it’s probably the wind. Besides, it’s getting late, let’s get going.” \n Not feeling reassured, you:";
    textForMyLevel[1] = "“I don’t know man, it feels weird. It might be something important, let’s check it out.” you say. \n“Well if you say so. It’s probably nothing. Let’s hurry up so that we can get back.” \nYou and Trent approach the outpost fence. \nBeyond the fence is a forest, which unfortunately happens to be dying due to the increasing temperatures in the region. \nYou scan across the landscape, trying to assess what could have possibly been in the shadows. \n“Are we done yet? I told you, there is absolutely nothing here.” Trent cuts in, slightly annoyed by the delay. \nHe is about to say more, when you hear something. “Be quiet! Stay still!” you urgently whisper. \nJust ahead in the clearing, you can make out shapes moving. Clearly, something is up. \nYou can see about 5 people, armed with crossbows and daggers, in a huddle discussing something in hushed tones. \n“What is it?” Trent worriedly asks. You wordlessly point ahead. \n“This is bad, this is really bad. We’ve got to leave now!” Trent says frantically. \nYou consider the scenarios.";
    textForMyLevel[2] = "“You know what, you might be right.” you say to Trent, as both of you pick up the pace to head to the Town Square. \nYou continue on your way to the Town Square, albeit a little apprehensive and what you may have witnessed. \nYou reach the Town Square and are about to carry on with your tasks, but you consider notifying the town guard of the strange sightings. \nSuddenly, you hear rumbling from the direction you just arrived from. You gaze towards the bystanders, but the looks on their face are that of fear. \nPerplexed, you turn around. “Shoot.” Trent says in a low tone. \nUp ahead, about 100 metres or so, the 5 people you saw earlier are charging towards the village. At full speed. Armed with their weapons. \nThe buffest of the group, probably the leader, yells in a gruff voice “Raiders, ATTACK!” Things are not looking good. \n“Uh, oops.” Trent says nervously, as he begins to back away into the crowd. \nOther bystanders immediately begin to scramble, running in all directions away from the incoming threat. \n“Alert the town guard!” you proclaim, but you realize that backup won’t be able to reach in time. \nBefore you can make a move, the raiders enter the town and begin looting. \nYou look at the vulnerable bystanders running around, and realize how defenseless the town is. You know what you have to do. \nPeople are counting on you. You have to defend.";
    textForMyLevel[3] = "“Turning the other way might lead to unforeseen consequences, especially considering how these people seem like trouble.” you calmly proclaim. \nKeeping a cool head, you inform Trent of your plan. \n“Let’s get closer and see what these people are planning, it’s unusual for us to get foreign visitors, we should see what’s up. \nBesides, I have a gut feeling that things aren’t as they seem.” \nTrent, clearly not in the mood for taking risks right now, but still a loyal friend, begrudgingly accepts to join. “Fiiiine, let’s get this over with.” \nYou both creep closer to the clearing, when suddenly a twig snaps. “WHO IS THERE?” a rather buff man, probably the leader of the group, yells out. \nThinking quick, you step out into the clearing. \n“Uh, hello good Sir. I was just collecting berries to sell at the market.” you say, hoping that your attempt at an excuse works. \n“Uh yeah, and I’m the assistant, I just follow along. I was also helping collect berries.” Trent nervously chimes in. \nThe leader seems apprehensive at your excuse. “Hmm. Berry-pickers you say, perhaps you’d care to share with us? We’re visitors and we are famished.” \nThe man deviously grins. You realize that he has seen through your excuse. \n“Uhh” is all you manage to say, before the man suddenly leaps at you with his weapons raised. “RAIDERS, ATTACK THESE INTRUDERS.” \n“Uhh technically, you’re the intruders in our town” Trent says, before just jumping out of the axe’s reach. \n“Now’s not the time for jokes, Trent.” you say in a low voice, focused on defusing the situation. You realize that running is your best bet right now. \n“Surrender, and we’ll end this quickly.” the leader says. You immediately come up with a plan. You signal Trent with your hands, and he understands. \nYou crouch to the ground, pretending to empty your pockets, when you immediately pick up sand from the ground and toss it in the eyes of the raiders. \nMeanwhile, Trent lights a small fire using some rocks, and spreads the fire in between the raiders and yourselves, providing a barrier and distraction. \nYou both immediately run back to the town square. However, they quickly gain ground on you. \nAfter a few minutes of intense running, you reach the town. The raiders are still following you. \nYou realize that the town is unguarded, and so you yell at the top of your voice “EVERYONE EVACUATE, WE ARE UNDER ATTACK.” \nIt is a long shot, but surprisingly everyone listened and it worked! \nEveryone immediately begins to run around, trying to find a safe place to shelter in. You turn back and look at the raiders. \nYou know that it will take time for help to arrive, and these raiders mean serious trouble. \nYou realize that you have to make your stand to defend the town. \nYou look towards Trent, but he is already getting his sword ready. “Let’s do this, let’s get these guys.” Trent says, determined to defend the town. \nYou too get ready, and hope for the best.";

    buttonOneText = new String [9];
    buttonOneText[0] = "Check what the noise is.";
    buttonOneText[1] = "You confront the mysterious group.";
    buttonOneText[2] = "Continue";
    buttonOneText[3] = "Continue";

    buttonTwoText = new String [9];
    buttonTwoText[0] = "Ignore it and quickly proceed to the town square.";
    buttonTwoText[1] = "You head back to the Town Square.";
    buttonTwoText[2] = "Continue";
    buttonTwoText[3] = "Continue";
  }

  void draw () {
    background(#E0EEE0);

    // the stuff for all levels
    image(img, 0, 660);
    strokeWeight(2);
    stroke(#000000);
    line(0, 660, 1000, 660);

    strokeWeight(3);
    stroke(#000000);
    fill(#999553);

    rect(width/2 - buttonSize.x - 100, height - 100, buttonSize.x, buttonSize.y);
    if (!buttonTwoText[levelNumber].equals(buttonOneText[levelNumber]))
      rect(width/2 + 100, height - 100, buttonSize.x, buttonSize.y); 

    PrintMyButtonTexts();
    PrintMyLevelText();

    // stuff depending on levelNumber 
    if (levelNumber == 0) {
      LevelZero();
    } else if (levelNumber == 1) {
      LevelOne();
    } else if (levelNumber == 2) {
      LevelTwo();
    } else if (levelNumber == 3) {
      LevelThree();
    }
  }

  // -----------------------------------------------------

  void PrintMyButtonTexts() {
    textFont(font2, 18);
    fill(0);
    text(buttonOneText[levelNumber], width/2 - buttonSize.x - 100, height - 150 + buttonSize.y);
    if (!buttonTwoText[levelNumber].equals(buttonOneText[levelNumber])) {
      text(buttonTwoText[levelNumber], width/2 + 100, height - 150 + buttonSize.y);
    }
  }
  // -----------------------------------------------------

  void mousePressed() {
    playerChoice = buttonSelection ();
  }

  int buttonSelection () {
    // default 
    int thingToReturn = 0;

    if (mouseX >= (width/2 - buttonSize.x - 100) && mouseX <= (width/2 - 100) && mouseY >= (height - 100) && mouseY <= (height - 100 + buttonSize.y)) {
      if (mousePressed) {
        thingToReturn = 1;
      }
    } else if (mouseX >= (width/2 + 100) && mouseX <= (width/2 + 100 + buttonSize.x) && mouseY >= (height - 100) && mouseY <= (height - 100 + buttonSize.y)) {
      if (mousePressed) {
        thingToReturn = 2;
      }
    }

    return thingToReturn;
  }

  // -----------------------------------------------------

  void LevelZero () {

    if (playerChoice == 1) {
      levelNumber = 1;
      playerChoice = 0;
    } else if (playerChoice == 2) {
      levelNumber = 2;
      playerChoice = 0;
    }

    strokeWeight(3);
    stroke(#000080);
    fill(#add8e6, 65);
    rect(35, 15, 928, 247);

    image(img2, 35, 270);
  }

  void LevelOne () {
    if (playerChoice == 1)
    {
      levelNumber = 3;
      playerChoice = 0;
    } else if (playerChoice == 2) {
      levelNumber = 2;
      playerChoice = 0;
    }

    strokeWeight(3);
    stroke(#000080);
    fill(#add8e6, 65);
    rect(35, 15, 760, 292);

    image(img3, 35, 313);
  }

  void LevelTwo () {
    if (playerChoice == 1) {
      playerChoice = 0;
      raidersFightTextAnimation();
    }

    strokeWeight(3);
    stroke(#000080); 
    fill(#add8e6, 65);
    rect(35, 15, 926, 313);

    image(img5, 35, 336.5);
  }

  void LevelThree() {
    if (playerChoice == 1) {
      playerChoice = 0;
      raidersFightTextAnimation();
    }

    strokeWeight(3);
    stroke(#000080);
    fill(#add8e6, 65);
    rect(35, 15, 955, 615);

    image(img4, 607, 661);
  }


  // -----------------------------------------------------

  void PrintMyLevelText() {
    textFont(font, 20);
    fill(#000080);
    text(textForMyLevel[levelNumber], 50, 37.5);
  }
}
