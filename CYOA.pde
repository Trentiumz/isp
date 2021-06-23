/*
  Description: The CYOA code
 */
// the Choose your own adventure state done before the game
class BeginCYOAState extends State {

  void gameExit() {
    println("continue");
    epilogueMusic.stop();
  }
  // "logic" updates
  void tick() {
  }
  // drawing onto the screen
  void render() {
    draw();
  }
  // once the "fight begins", we continue to the next state
  void raidersFightTextAnimation() {
    curState = new FightDescriptionState();
  }

  // constructor
  BeginCYOAState() {
    setup();
  }

  PVector buttonSize = new PVector (150, 30); // size of the buttons

  int levelNumber; // current level
  // what to display at various levels
  String textForMyLevel [];
  String buttonOneText [];
  String buttonTwoText [];
  // the choice the player made
  int playerChoice; 

  // images and fonts
  PImage img;
  PImage img2;
  PImage img3;
  PImage img4;
  PImage img5;
  PFont font;
  PFont font2;

  // run at the start of the state
  void setup() {
    // load in the fonts
    font = beginCYOAFont;
    font2 = beginCYOAFont2;
    img = beginCYOAImg;
    img2 = beginCYOAImg2;
    img3 = beginCYOAImg3;
    img4 = beginCYOAImg4;
    img5 = beginCYOAImg5;

    // initialize the current level and choices
    levelNumber = 0;
    playerChoice = 0;
    textForMyLevel = new String [9];

    // initialize the text to display
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

  // drawing onto the screen (called each frame)
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
  // printing the text for the buttons
  void PrintMyButtonTexts() {
    textFont(font2, 18);
    fill(0);
    text(buttonOneText[levelNumber], width/2 - buttonSize.x - 100, height - 150 + buttonSize.y);
    if (!buttonTwoText[levelNumber].equals(buttonOneText[levelNumber])) {
      text(buttonTwoText[levelNumber], width/2 + 100, height - 150 + buttonSize.y);
    }
  }
  // -----------------------------------------------------
  // handling when the mouse is pressed
  void mousePressed() {
    playerChoice = buttonSelection ();
  }

  // handling events for button presses
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
  // functions for the various levels
  void LevelZero () {
    // depending on choice, we change the current level
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
    // depending on choice, we change the current level
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
    // depending on choice, we change the current level
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
    // depending on choice, we change the current level
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
  // print the text for the current level
  void PrintMyLevelText() {
    textFont(font, 20);
    fill(#000080);
    text(textForMyLevel[levelNumber], 50, 37.5);
  }
}


// the end screen
class EndState extends State {
  // images & fonts
  PImage img;
  PImage img2;
  PImage img3;
  PImage img4;
  PImage img5;
  PImage img6;
  PImage img7;
  PImage img8;
  PImage img9;
  PImage img10;
  PImage img11;
  PImage img12;

  PFont font;
  PFont font2;

  // size of the button
  PVector buttonSize = new PVector (150, 30);

  int levelNumber; // current "level"
  String textForMyLevel []; // text for each "level"
  String buttonOneText []; // text for the button of each "level"
  String buttonTwoText []; // text for the second button, if any, for each "level"
  int playerChoice; // storing the current player's choice

  int curFrame; // the current frame
  void gameExit() {
    epilogueMusic.stop();
    curState = new MainMenuState();
  }

  EndState() {
    setup();
  }

  void tick() {
    curFrame++;
  }

  void render() {
    // a "draw method" is better when testing in a standalone application, so we just call draw instead of render
    this.draw();
  }

  void setup() {
    // initialize variables
    epilogueMusic.loop();

    img = epilogueImg;
    img2 = epilogueImg2;
    img3 = epilogueImg3;
    img4 = epilogueImg4;
    img5 = epilogueImg5;
    img6 = epilogueImg6;
    img7 = epilogueImg7;
    img8 = epilogueImg8;
    img9 = epilogueImg9;
    img10 = epilogueImg10;
    img11 = epilogueImg11;
    img12 = epilogueImg12;

    font = epilogueFont;
    font2 = epilogueFont2;

    levelNumber = 0;
    playerChoice = 0;
    textForMyLevel = new String [9];

    // generate in the text needed
    textForMyLevel[0] = "Blinding light fills your vision as you defeat the serpent, the final boss. You remember striking the final blow, \nwhen some sort of shockwave KO’d you. Dazed, you wake up to find yourself outside of the dungeon. \nA stone tablet lays in front of you. It pulses in a neon blue glow. You pick it up and begin reading.";
    textForMyLevel[1] = "“If you are seeing this tablet, then by now you probably have defeated the dragon, giant, and serpent. \nYou may have also uncovered the other creatures lurking around within the dungeons. You might think that \nthese beings are of evil origin, but if so, then you are mistaken. You see, all of these beings you fought, were \nactually mutations caused by Global Climate Change. You see, Global Climate Change is destroying the \nworld, and that is what created these creatures dwelling in these dungeons. The dragon mutated from a \nlizard, the giant mutated from a tree sapling, and the serpent mutated from a baby worm. They had no fault, \nthey were produced by the Global Climate Change you humans have created. It is not too late to save the \nworld from its climate perils. You need to take action to save this planet.”";
    textForMyLevel[2] = "You are shocked. You knew that the climate was feeling different. There were more wildfires, more droughts, \nmore hurricanes near the coastal regions, more tornados. But you weren’t aware that this was all caused by \nhuman actions. You realize that defeating the dungeons was just the beginning.";
    textForMyLevel[3] = "You have to bring this to the attention of the King and his advisors. You set off to visit the castle. After a few \nhours of non-stop trekking, you reach the palace. Although before you even reach inside, thousands of \npeople are cheering your name. They must have heard about your journey in defeating the creatures of the \ndungeons. You are welcomed into the throne room of the palace, where the king is sitting, along with two of \nhis advisors. \n“Hello, I am Prady. I am the advisor for King Shance. This here is Kev, another advisor. We have heard a lot \nabout your journey to the dungeon, and are thankful for your act of courage.” \n“Uh it’s an honor, thank you” you reply, still unable to believe that you are in THE palace. \nShance, the king, talks. “You have done well. As a reward, you can ask for anything you wish, and as long as it \nis reasonable, feasible, and just, then we can.” \n“You see Sir, after I emerged from the dungeons, I found this tablet” you say, passing the tablet to Prady. \nHe reads it and understands. “Ohh, it makes sense now. I had a hypothesis, but this adds some more proof. \nWe must take action against this Global Climate Change” Prady says. \n“Exactly!” you reply, hoping that change can happen.";
    textForMyLevel[4] = "“Shance, I think that we should consider some more eco policies. We should aim to plant 2 trees for every 1 \nwe cut down, as well as plant more trees in general. We should also reduce any activities which emit a lot of \npollution.” Prady says, addressing Shance and Kev. \n“What you say makes sense. I will sign orders for that to be implemented after reaching a consensus with \nthe court. Kev, assemble a meeting with all the advisors and delegates in 4 hours, this is a pressing matter \nand we must discuss it soon.” Shance proclaims. \n“Yes, I will do that now” Kev says, as he leaves to assemble the meeting. \n“And for you, seeing as this journey required a lot of courage and bravery, I would like to award you with \nland, gold, and elite gear. In fact, you may need this for a future adventure.” Shance says in a serious voice. \n“What?” you ask.";
    textForMyLevel[5] = "Shane responds. “You see, we have heard of a 'relic' which might be able to aid us in preventing Global \nClimate Change. And we want our best team on it. You will be working with renowned adventurers: \nCheollin the sorceress, Aron the knight, and Fatma the archer. I have also heard of your friend, Trent. I heard \nof how he and you defended your town from raiders. He too is welcome to join this quest. And meanwhile I \nwill do all I can to pass more eco policies.” \n“This is an honor” you reply. You know that this is an opportunity to change the world for the better. \n“And I’m looking forward to working with Cheollin, Aron, and Fatma. And Trent too is probably willing to aid \nin this cause.” you say. \nPrady replies. “Great, I’ll brief you on the situation. You can return to your town, we will send communication \nand arrange for transportation. Also, your town will receive gold, repairs, and resources, as a token of our \nrespect and gratitude.” \n“Thank you so much! I’m looking forward to finding this relic. Let’s do this.”";
    textForMyLevel[6] = "You emerge back into the courtyard of the palace, knowing that you have an opportunity to save the world. \nThe cheers can still be heard, everyone celebrating your victory. Deep down you know that you \nmust defend the earth, our only home. And so motivated, you set off back to your home, \ndetermined to make a positive change.";
    textForMyLevel[7] = "";

    // generate in the text for the buttons
    buttonOneText = new String [9];
    buttonOneText[0] = "Continue";
    buttonOneText[1] = "Continue";
    buttonOneText[2] = "Continue";
    buttonOneText[3] = "Continue";
    buttonOneText[4] = "Continue";
    buttonOneText[5] = "Continue";
    buttonOneText[6] = "Continue";
    buttonOneText[7] = "The end, for now :D";

    buttonTwoText = new String [9];
    buttonTwoText[0] = "Continue";
    buttonTwoText[1] = "Continue";
    buttonTwoText[2] = "Continue";
    buttonTwoText[3] = "Continue";
    buttonTwoText[4] = "Continue";
    buttonTwoText[5] = "Continue";
    buttonTwoText[6] = "Continue";
    buttonTwoText[7] = "The end, for now :D";

    // start with a left text align
    textAlign(LEFT);
    curFrame = 0;
  }

  void draw() {
    background(#E0EEE0);

    // draw a "seperator" from the content text and the buttons for player choice
    strokeWeight(3);
    stroke(#000000);
    line(0, 643, 1000, 643);

    // draw a rectangle as the "panel" for the player choices
    strokeWeight(2);
    stroke(0);
    fill(#F0FFFF, 150);
    rect(0, 644, 1000, 642);

    // draw a rectangle for the left button; and if the right button has a different option, for the right button as well
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
    } else if (levelNumber == 4) {
      LevelFour();
    } else if (levelNumber == 5) {
      LevelFive();
    } else if (levelNumber == 6) {
      LevelSix();
    } else if (levelNumber == 7) {
      LevelSeven();
    }
  }

  // -----------------------------------------------------
  // draws the text for each button in the correct spot
  void PrintMyButtonTexts() {
    textFont(font, 18);
    fill(0);
    text(buttonOneText[levelNumber], width/2 - buttonSize.x - 100, height - 150 + buttonSize.y);
    if (!buttonTwoText[levelNumber].equals(buttonOneText[levelNumber])) {
      text(buttonTwoText[levelNumber], width/2 + 100, height - 150 + buttonSize.y);
    }
  }
  // -----------------------------------------------------

  void mousePressed() {
    // have a small delay before registering the click (since the user might be "spamming" while fighting the boss)
    if (curFrame > 15) {
      playerChoice = buttonSelection ();
    }
  }

  // returns either 1 or 2, depending on if the button is "inside" the button on the left or right
  int buttonSelection () {
    // default 
    int thingToReturn = 0;

    // collision for left button
    if (mouseX >= (width/2 - buttonSize.x - 100) && mouseX <= (width/2 - 100) && mouseY >= (height - 100) && mouseY <= (height - 100 + buttonSize.y)) {
      if (mousePressed) {
        thingToReturn = 1;
      }
    } else if (mouseX >= (width/2 + 100) && mouseX <= (width/2 + 100 + buttonSize.x) && mouseY >= (height - 100) && mouseY <= (height - 100 + buttonSize.y)) {
      // collision for right button
      if (mousePressed) {
        thingToReturn = 2;
      }
    }

    // returns the stored button
    return thingToReturn;
  }

  // -----------------------------------------------------

  void LevelZero () {
    // register player choice
    if (playerChoice == 1) {
      levelNumber = 1;
      playerChoice = 0;
    } else if (playerChoice == 2) {
      levelNumber = 1;
      playerChoice = 0;
    }

    // draw background for the text
    strokeWeight(3);
    stroke(#000080);
    fill(#add8e6, 65);
    rect(35, 15, 930, 80);

    // draw a corresponding image
    image(img5, 192, 164);
  }

  void LevelOne () {
    // register player choice
    if (playerChoice == 1) {
      levelNumber = 2;
      playerChoice = 0;
    } else if (playerChoice == 2) {
      levelNumber = 2;
      playerChoice = 0;
    }

    // draw background for the text
    strokeWeight(3);
    stroke(#000080);
    fill(#add8e6, 65);
    rect(35, 15, 930, 190);

    // draw corresponding images for the current "level"
    image(img6, 605, 278);

    image(img7, 152, 270);
  }

  void LevelTwo () {
    // register player choice
    if (playerChoice == 1) {
      levelNumber = 3;
      playerChoice = 0;
    } else if (playerChoice == 2) {
      levelNumber = 3;
      playerChoice = 0;
    }

    // draws the background for the text
    strokeWeight(3);
    stroke(#000080); 
    fill(#add8e6, 65);
    rect(35, 15, 930, 75);

    // draw corresponding images for the current "level"
    image(img8, 35, 140);

    image(img9, 587, 144);
  }

  void LevelThree() {
    // register player choice
    if (playerChoice == 1) {
      levelNumber = 4;
      playerChoice = 0;
    } else if (playerChoice == 2) {
      levelNumber = 4;
      playerChoice = 0;
    }

    // draw the background for the text
    strokeWeight(3);
    stroke(#000080);
    fill(#add8e6, 65);
    rect(35, 15, 930, 306);

    // draw the corresponding image for the current "level"
    img.resize(488, 285); 
    image(img, 263, 338);
  }

  void LevelFour() {
    // register player choice
    if (playerChoice == 1) {
      levelNumber = 5;
      playerChoice = 0;
    } else if (playerChoice == 2) {
      levelNumber = 5;
      playerChoice = 0;
    }

    // draw the background for the text
    strokeWeight(3);
    stroke(#000080);
    fill(#add8e6, 65);
    rect(35, 15, 930, 219);

    // draw the corresponding images for the current "level"
    image(img10, 35, 272);

    image(img11, 515, 291);
  }

  void LevelFive() {
    // register player choice
    if (playerChoice == 1) {
      levelNumber = 6;
      playerChoice = 0;
    } else if (playerChoice == 2) {
      levelNumber = 6;
      playerChoice = 0;
    }

    // draw the background for the text
    strokeWeight(3);
    stroke(#000080);
    fill(#add8e6, 65);
    rect(35, 15, 930, 262);

    // draw the "avatars" for the different side characters
    img2.resize(250, 300);
    image(img2, 10, 326);

    img3.resize(250, 300);
    image(img3, 316, 326);

    img4.resize(250, 300);
    image(img4, 645, 326);
  }

  void LevelSix() {
    // register player choice
    if (playerChoice == 1) {
      levelNumber = 7;
      playerChoice = 0;
    } else if (playerChoice == 2) {
      levelNumber = 7;
      playerChoice = 0;
    }

    // draw in the background for the level
    strokeWeight(3);
    stroke(#000080);
    fill(#add8e6, 65);
    rect(35, 15, 930, 95);

    // draw in the image for the level
    image(img12, 102, 157);
  }

  void LevelSeven() {
    // register player choice
    if (playerChoice == 1) {
      gameExit();
      playerChoice = 0;
    } else if (playerChoice == 2) {
      gameExit();
      playerChoice = 0;
    }

    // draw background of the text
    strokeWeight(3);
    stroke(#000080);
    fill(#add8e6, 65);
    rect(35, 161, 930, 200);

    // write in text
    textFont(font2);
    textSize(30);
    fill(0);
    text("Thank you so much for playing Climate Hunters! \nThe adventure continues in Part 2, with a new team, \nbut the same goals of reducing Global Climate Change. \n(Disclaimer, not part of the ISP lol) \nFrom the developers, thank you!", 45, 205);

    // draw an image of the current frame for the "dancing pug animation"
    image(dancingPugAnimation[curFrame % dancingPugAnimation.length], width / 2 - 100, 400);
  }

  // -----------------------------------------------------

  // print the text corresponding to the current level
  void PrintMyLevelText() {
    textFont(font, 18);
    fill(#000080);
    text(textForMyLevel[levelNumber], 50, 37.5);
  }

  // -----------------------------------------------------
}
