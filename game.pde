/*
 * Author: Catherine Lee
 * Purpose: Game for Project 2. Players will be able to control the character using
 *         the smart glove's hand motions - up to jump, down swim, and the push button to shoot. 
 *         The character cannot bump into any black cat or pink doll, or it's game over. 
 *         Also, when a cloud of pollution appears, the character can no longer choose to 
 *         move downwards and swim. 
 */

import java.util.Random; 

/***************************************
 Images
 ***************************************/

//Current Background
private PImage bg;

//Background Images
private PImage lv1bg;
private PImage lv1bgMirror;
private PImage lv2bg;
private PImage lv2bgMirror;
private PImage lv3bg;
private PImage lv3bgMirror;

//Protagonist Sprite Images
private PImage walk1;
private PImage walk2;
private PImage jump;
private PImage down;   
private PImage down2;
private PImage attack1;
private PImage attack2;

//Follower Character Sprite Images
private PImage walk1b;
private PImage walk2b;
private PImage jumpb;
private PImage downb;   
private PImage down2b;
private PImage attack1b;
private PImage attack2b;

//Follower Character Sprite Images
private PImage walk1c;
private PImage walk2c;
private PImage jumpc;
private PImage downc;   
private PImage down2c;
private PImage attack1c;
private PImage attack2c;

//Enemy Sprites
private PImage witch; // witch
private PImage blackCat; // black cat
private PImage monster; // monster

//Interlude Screen Images
private PImage loadingScreen; // loading screen 
private PImage endStage; // last stage
private PImage titleScreen; // title screen
private PImage winScreen; // win screen
private PImage instruction; // instructions window

//Load end stage characters
private PImage endStage1; // stage 1
private PImage endStage2; // stage 2
private PImage endStage3; // stage 3

/***************************************
 Constants
 ***************************************/
 
//Constants
private static final int witchOffset = 70; //The number of pixels needed to provide the illusion that the witch is along the same level as the protagonist.
private static final int catOffset = 70; //The number of pixels needed to provide the illusion that the cat is along the same level as the protagonist.
private static final int totalFloors = 3; //The total number of floors per stage.
private static final int totalStages = 2; //The total number of stages in the game.
private static final int maxAmmo  = 5; //The maximum number of times a player can shoot at a monster in the game.
private static final int resetCharPos = 1; //The position that the frontal character can reach before resetting the screen.
private static final int monsterBumpDistance = 3; //How far, in x value, can the character be, along the same y location, from a monster before colliding with it.
private static final int lowerButton = 470; // Second option button
private static final int upperButton = 400; // First option button
private static final int buttonSize = 50; // Button size for options
private static final int buttonRoundness = 7; // Button curve for options

//Constants to represent motion
private static final int running = 0; 
private static final int jumping = 1;
private static final int swimming = 2;
private static final int attacking = 3;


/***************************************
 Global Variables
 ***************************************/
//Random monster generator
private Random witchDecider;

//Booleans to indication where user should be in the game
private boolean loading;
private boolean endStageVal;
private boolean onTitle;
private boolean showInstructions;

//Toggle Button Variables
private int hoverValue = upperButton;

//Load Screen Variables
private int loadCount;
private int loadXPos;
private int loadYPos;

//Global Game Variables
private boolean mirrorBg = false; 
private boolean gameOver = false; // Game begins starting
private int stage = 0; // begin at stage 0
private int floor = 0; // begin on floor 0
private int ammo = maxAmmo; // Start with full/unused amount of ammo

//Characters
private userCharacter homura; // character that user plays
private witch charlotte; // witch - enemy
private poison poison; // poison for enemy to spew out
private cat kitty; // the black cat
private userCharacter kyoko; // character 2 that user plays
private userCharacter sayaka; // character 3 that user plays

//Push Button Status
private boolean shootStatus; // determine if user wants to shoot
private boolean keyClicked; // determine is key pressed

//Fonts
private PFont font; // font 1
private PFont font2; // font 2

//Music
private AudioPlayer player; // initialize music player
private AudioPlayer winSong; // initialize music for win


/*****************************
 Main Game
 ****************************/
 
/*
 * Class: Game
 * Purpose: Runs an action game, in which the player controls a character to jump, swim, or run forward to
 *          avoid monsters. The white puff of poison does not need to be avoided, but the character cannot
 *          swim, due to pollution, while the poison is floating around the screen. The character can shoot
 *          at any monster that isn't a puff of poison.
 */
class game {

  /*
   * Name: game
   * Purpose: Setup function that initializes the game images, and characters. Thenm,
   *          it brings the player to the opening screen.
   */
  public game() {

    //Initialize global variables
    keyClicked = false; //Set the push button as not pressed initially.
    witchDecider = new Random();  //Create a random number generator for spawning monsters.
    loadAllImg();  //Load images from files.

    //Loading Screen Variables
    loading = false; //Start the game at the main menu, not while loading. 
    loadXPos = 850;  //Set left-most loading block x position.
    loadYPos = 550;  //Set left-most loading block y position.

    //Initialize Fonts
    font = loadFont("Algerian-48.vlw"); //Use a gothic styled text to suit the game.
    font2 = loadFont("BodoniMT-Italic-48.vlw"); //Use a different text for game end screen.
    textFont(font, 32); //Define a default size for text to be displayed as.

    //Initialize  Music
    player = minim.loadFile("m1.mp3"); // regular mode song
    winSong = minim.loadFile("m2.mp3"); // song for winning

    //Initialize the player characters of all three rounds.
    homura = new userCharacter(0, 0, 0, 0, walk1, walk2, jump, down, down2, attack1, attack2);
    kyoko =  new userCharacter(200, 40, 0, 60, walk1b, walk2b, jumpb, downb, down2b, attack1b, attack2b);
    sayaka =  new userCharacter(300, 60, 80, 80, walk1c, walk2c, jumpc, downc, down2c, attack1c, attack2c);

    //Initialize obstacles or monsters that the player must avoid.
    charlotte = new witch(); // the witch character named Charlotte
    poison = new poison(); // the poison that the enemy puffs out
    kitty = new cat(); // the black cat

    //Play the main song on a loop.
    player.loop();

    //Begin on the title screen
    onTitle = true;
  }

  /*
   * Name: playGame
   * Purpose: Runs an action game, in which the player controls a character to jump, swim, or run forward to
   *          avoid monsters. The white puff of poison does not need to be avoided, but the character cannot
   *          swim, due to pollution, while the poison is floating around the screen.
   */
  public void playGame() {
    if (onTitle) { 
      //Determine of the player should be on the title screen.
      loadTitle(); //If it is, load that screen.
    } else if (showInstructions) { 
      //Determine of the player should be on the instruction screen.
      howToPlay();   //If it is, load that screen.
    } else if (loading) {  
      //Determine of the player should be on the loading screen.
      loading(); //If it is, load that screen.
    } else if (endStageVal) {  
      //Determine of the player should be on the stage completion screen.
      loadEndStage();  //If it is, load that screen.
    } else if (!checkLoss() && stage <= totalStages) { 
      //Determine of the player should be on the stage completion screen.
      mainGame();  //If it is, load the main game.
    } else { 
      //Otherwise, the game should be over.
      gameOver(); //Load the game over screen.
    }
  }

  /*
 * Name: mainGame
   * Purpose: Allows the user to play the primary
   *          game.
   */
  private void mainGame() {
    fill(255); //White font is used during the game.
    
    determineState(); //Determine the state the character should be in, given user's hand placement.
    characterUpdatePos(); //Update and display the characters accordingly.

    if (homura.getXPos() <= resetCharPos) { //If the main character reaches the end of the screen.
      resetMonsters(); //Reset all positions.
      updateFloor(); //And proceed to the next stage.
    } else { 
      updateMonsters(); //Update the horizontal position of dynamic characters.
    }
  }

  /********************************************
   Interlude Screen Functions
   ********************************************/

  /*
   * Name: gameOver
   * Purpose: Displays the game over screen.
   */
  private void gameOver() {
    //Show a black background.
    background(0);

    //Display "Game Over" in larger words in the center of the screen.
    fill(255); //Use white font.
    textFont(font, 70); //Size 70 font.
    text("GAME OVER", 300, 300); //Display words.

    //Display message for resetting the game.
    textFont(font, 20); //Use smaller text.
    text("PRESS THE PUSH BUTTON TO PLAY AGAIN", 590, 580); //Display words

    textFont(font, 32); //Reset font to the default font for other functionalities.

    //Check for values and reset game if the push button has been pressed.
    if (keyPressed) {
      if (key == CODED) { 
        if (keyCode == RIGHT && keyClicked == false) {
          keyClicked = true; //Set the key pressed state so that a long key press will not be read twice.
          resetGame(); //Reset the game.
          onTitle = true; //Return to the main menu.
        }
      }
    } else {
      keyClicked = false; //If the push button has not been pressed, set the key pressed state to false, so it can be pressed again.
    }
  }

  /*
   * Name: howToPlay
   * Purpose: Displays the instruction screen.
   */
  private void howToPlay() {
    //Display the instructions in a picture.
    background(instruction); 

    //Display the instructions title.
    textFont(font, 70); //Use a large font size.
    fill(255); //Use white text.
    text("HOW TO PLAY", 300, 65); //Display the words.

    //Check for values and return to the main menu if the push button has been pressed.
    if (keyPressed) {
      if (key == CODED) {
        if (keyCode == RIGHT && keyClicked == false) { 
          keyClicked = true; //Set the key pressed state so that a long key press will not be read twice.
          showInstructions = false; //Leave the instruction screen.
          onTitle = true; //Return to the main menu.
        }
      }
    } else {
      keyClicked = false; //If the push button has not been pressed, set the key pressed state to false, so it can be pressed again.
    }
  }


  /*
   * Name: runLoad
   * Purpose: Activates the loading screen
   */
  private void runLoad() {
    loadCount = 0; //Start counting at 0 to create a delay.
    loading = true; //Activate loading screen.
  }

  /*
   * Name: loading
   * Purpose: Displays the loading screen
   */
  private void loading() {

    if (loadCount < 100) { //Create a short delay to display the loading screen.
      //Display the loading screen background.
      background(loadingScreen);

      //Show the words loading.
      fill(#330019); //Use a purple font.
      text("LOADING", 690, 580); //Display the text.

      //Generate boxes to create loading animation
      noStroke(); //Use no stroke.
      fill(#660066, 75); //Use a purple color at 75% opacity.
      rect(850, loadYPos, 30, 30); //Load the left most block.
      rect(900, loadYPos, 30, 30); //Load the middle block.
      rect(950, loadYPos, 30, 30); //Load the right most block.
      rect(loadXPos, loadYPos, 30, 30); //Place a block at the starting position initially, and change its location to create a loading animation.

      //Move an overlapping block across the screen during the wait time to provide the illusion that one block is darker in color than the other two.
      if (loadCount == 60) { //At 60, display the block at the left most corner.
        loadXPos = 850;
      } else if (loadCount == 40 || loadCount == 100) { //At 40 and 100, display the block at the right-most position.
        loadXPos = 950;
      } else if (loadCount == 20 || loadCount == 80) { //At 20 and 80, display the block at the left-most position.
        loadXPos = 900;
      }

      loadCount++; //Increment the count.
    } else {
      loadCount = 0; //Reset the count of the count has reached 100.
      loading = false;  //Leave the loading state.
    }
  }

  /*
   * Name: loadTitle
   * Purpose: Loads the main title screen.
   */
  private void loadTitle() {
    //Display the title background.
    background(titleScreen); 

    //Display the title.
    fill(255); //Use white text.
    textFont(font, 72);  //Use a large font.
    text("WITCH HUNTER", 250, 70); //Display the words.

    //Display menu option rectangles.
    fill(#660066, 75); //Display them in purple with 75% opacity.
    rect(buttonSize, upperButton, 250, buttonSize, buttonRoundness); //Display the top rectangle.
    rect(buttonSize, lowerButton, 250, buttonSize, buttonRoundness); //Display the bottom rectangle.

    //Display menu option text.
    fill(255); //Use a white color.
    textFont(font, 32); //Use a standard size.
    text("INSTRUCTIONS", 75, 440); //Display instructions on top block.
    text("PLAY", 140, 510); //Display play on bottom block.

    //Overlap the menu options with a slightly transparent purple block to provide the illusion of selection.
    fill(#660066, 75);

    //Determine the y position of the block based on how the user's hand is place.
    if (keyPressed) {
      if (key == CODED) {
        if (keyCode == UP) {
          hoverValue = upperButton; //Move to the upper block.
        }
        if (keyCode == DOWN) {
          hoverValue = lowerButton; //Move to the lower block.
        }
        if (keyCode == RIGHT && keyClicked == false) {
          keyClicked = true; //Set the key press to ignore subsequent push button values until the button has been released and pressed again.
          if (hoverValue == lowerButton) { //If it's on the lower block.
            runLoad();  //Run the game.
            onTitle = false; //Leave the title screen.
          } else { //Otherwise it's on the top block.
            showInstructions = true; //Load the instruction screen.
            onTitle = false; //Leave the title screen.
          }
        }
      }
    } else {
      keyClicked = false; //If the push button has not been pressed, set the key pressed state to false, so it can be pressed again.
    }
    rect(buttonSize, hoverValue, 250, buttonSize, buttonRoundness); //Show the rectangle in the user's selected position.
  }

  /*
   * Name: displayEndScreen
   * Purpose: Loads a special screen when the player finishes the
   *          game.
   */
  void displayEndScreen() {
    //Display the end of game background.
    background(winScreen);
   
    //Replace the music
    player.pause(); //Stop the in-game music.
    winSong.play(); //Play a different song.
    
    //Display final words
    textFont(font2, 20); //Use a smaller font size and different font style.
    text("Through preserverence, I finally found you again.", 100, 60); //Display first line of text.
    text("The witches are gone, so you have no more to fear.", 300, 90); //Display second line of text.

    //Display menu options
    textFont(font, 32); //Set the font back to the standard size.
    fill(255); //Set the color to white.
    text("TWEET", 120, 440); //Show menu option to tweet.
    text("PLAY AGAIN", 80, 510); //Show menu option to return to the main menu.
    
    fill(#4C0B5F, 75); //Create blue blocks at 75% opacity.
  }

  /*
   * Name: displayStageScreen
   * Purpose: Loads a special screen when the player finishes a
   *          stage.
   */
  void displayStageScreen(int completionVal) {
    //Load the end of stage background.
    background(endStage); 
    
    //Display text.
    fill(#FFCCE5); //Set the color as purple.
    text("COMPLETION " + completionVal + "%", buttonSize, buttonSize); //Show how much of the game has been completed.
    text("STAGE " + stage + " COMPLETE", 690, 580); //Write "stage complete" at the bottom corner.

    //Show a progress bar.
    fill(#FF33FF, 75); //Set the color to purple.
    stroke(3); //Provide an outline.
    rect(buttonSize, 70, 300, 20, buttonRoundness); //Display a base for the bar.
    noStroke(); //Create another bar without an outline.
    rect(buttonSize, 70, (stage+1)*100, 20, buttonRoundness); //Display on top to of first bar to color in completion.

    fill(255); // Use white text
    text("TWEET", 120, 440); // Display option for tweeting
    text("CONTINUE", 100, 510); // Display option for continuing
    fill(#66B2FF, 75);
  }

  /*
   * Name: loadEndStage
   * Purpose: Loads the interlude screen between stages. 
   */
  void loadEndStage() {
    int completionVal = (stage+1)*33; //Display how much of the game the user has completed.

    if (stage == totalStages) { 
      displayEndScreen(); //Display background and text for the final stage.
    } else {
      displayStageScreen(completionVal); //Display background and text for every other stage.
    }

    //Display options as rectangles.
    rect(buttonSize, upperButton, 250, buttonSize, buttonRoundness); //Display the upper button
    rect(buttonSize, lowerButton, 250, buttonSize, buttonRoundness); //Display the lower button

    //Determine the location of the block based on hand placement.
    if (keyPressed) { // If key has been pressed
      if (key == CODED) {
        if (keyCode == UP) { // If pressed up arrow
          hoverValue = upperButton; //Up position translates to upper block.
        }
        if (keyCode == DOWN) { // If pressed down arrow
          hoverValue = lowerButton; //Down position translates to lower block.
        }
        if (keyCode == RIGHT && keyClicked == false) { // If pressed right arrow 
          keyClicked = true; //Note that key has been pressed.

          if (hoverValue == lowerButton) { //If the continue or play again button has been selected.
            if (stage == totalStages) { //If we are at the end of the game.
              resetGame(); //Reset character positions and other global variables to their initial state.
              endStageVal = false; //We are no longer at the end of a stage.
              
              //Resume normal music
              winSong.pause(); //Stop the current song.
              player.loop(); //Switch to the regularly played song.
              onTitle = true; //Display the title screen.
            } else { //When we're still in the middle of the game:
              runLoad(); //Display the loading screen.
              floor = 0; //Reset the floor to 0.
              stage ++;  //Proceed to the next stage.
              selectBG(); //Change the background accordingly.
              endStageVal = false; //Note that we are no longer at the end of a stage.
            }
          } else {
            //Send tweet
          }
        }
      }
    } else {
      keyClicked = false; //If no key is pressed, reset the push button status.
    }

    rect(buttonSize, hoverValue, 250, buttonSize, buttonRoundness); //Place another rectangle to show which menu option is selected.
  }


/***************************
   Image Loading Functions
****************************/

  /*
   * Name: loadAllImg
   * Purpose: Load all the images.
   */
  void loadAllImg() {
    loadProtagImg(); // Load character image 
    loadFollowImg(); // Load characters following image
    loadMonsterImg(); // Load monster image
    loadInterlude(); // Load interlude image
    loadEndStageChar(); // Load final stage character
    loadBGs(); // Load all backgrounds
  }

  /*
   * Name: loadMonsterImg
   * Purpose: Loads the monster sprites
   */
  private void loadMonsterImg() {
    witch = loadImage("witch1.png"); // Load witch image
    blackCat = loadImage("darkcat.png");   // Load black cat image
    monster = loadImage("monster.png"); // Load monster image
  }

  /*
   * Name: loadProtagImg
   * Purpose: Load the main character's sprites
   */
  private void loadProtagImg() {
    walk1 = loadImage("run1.png"); // Load character movement 1 
    walk2 = loadImage("run2.png"); // Load character movement 2
    jump = loadImage("jump.png"); // Load character jumping
    down = loadImage("crawl1.png"); // Load character crawl image
    down2 = loadImage("crawl2.png");    // Load second crawl image 
    attack1 = loadImage("attack1.png"); // Load character attacking images
    attack2 = loadImage("attack2.png"); // Load second attacking image
  }

  /*
   * Name: loadFollowImg
   * Purpose: Load the secondary character sprites
   */
  private void loadFollowImg() {
    walk1b = loadImage("run1_b.png"); // Load character movements
    walk2b = loadImage("run2_b.png"); 
    jumpb = loadImage("jump_b.png"); // Load character jumping image
    downb = loadImage("crawl1_b.png"); // Load character crawling
    down2b = loadImage("crawl2_b.png");   
    attack1b = loadImage("attack1_b.png"); // Load characters attacking image
    attack2b = loadImage("attack2_b.png");

    walk1c = loadImage("run1_c.png"); // Load 2nd character movements
    walk2c = loadImage("run2_c.png");
    jumpc = loadImage("jump_c.png"); // Load 2nd character jumpinh
    downc = loadImage("crawl1_c.png");// Load 2nd character crawling
    down2c = loadImage("crawl2_c.png"); 
    attack1c = loadImage("attack1_c.png");// Load 2nd character attackin
    attack2c = loadImage("attack2_c.png");
  }

  /*
   * Name: loadProtagImg
   * Purpose: Load the main character's sprites
   */
  private void loadBGs() {
    lv1bg = loadImage("bgimg.png");
    lv1bgMirror = loadImage("bgmirror.png");
    lv2bg = loadImage("bgimglv2.png");
    lv2bgMirror = loadImage("bgmirrorlv2.png");
    lv3bg = loadImage("bgimglv3.png");
    lv3bgMirror = loadImage("bgmirrorlv3.png");

    bg = lv1bg; //Set the background to the first level's background.
  }

  /*
   * Name: loadInterlude
   * Purpose: Load the interlude background images.
   */
  private void loadInterlude() {
    loadingScreen = loadImage("Loading.png"); // Load background for loading screen
    endStage = loadImage("endStageImg.png"); // Load background for last stage
    titleScreen = loadImage("title.png");// Load background for title screen
    winScreen = loadImage("win.png");// Load background for win screen
    instruction = loadImage("instruction.png");// Load background for instruction screen
  }

  /*
   * Name: loadEdStageChar
   * Purpose: Load sprites that appear at the end of 
   *          each stage.
   */
  private void loadEndStageChar() {
    endStage1 = loadImage("stage1end.png");// Load background for end of stage 1
    endStage2 = loadImage("stage2end.png");// Load background for end of stage 2
    endStage3 = loadImage("stage3end.png");// Load background for end of stage 3
  }

  /*************************************
   Check for game status
   *************************************/

  /*
   * Name: checkLoss
   * Purpose: Check to see if a character is bumped
   *          into a monster, or if a swim was attempted
   *          while poison is present.
   */
  private boolean checkLoss() {
    if (charlotte.isBumping(homura) || poison.isBumping(homura) || kitty.isBumping(homura)) { //Main character is always on screen.
      return true; //Death if this character meets any of the death conditions set by the monster on screen.
    }

    if (stage> 0 && (charlotte.isBumping(kyoko) || poison.isBumping(kyoko) || kitty.isBumping(kyoko))) { //Character on screen after stage 0
      return true; //Death if this character meets any of the death conditions set by the monster on screen.
    }

    if (stage > 1 && (charlotte.isBumping(sayaka) || poison.isBumping(sayaka) || kitty.isBumping(sayaka))) { //Character on screen after stage 1
      return true; //Death if this character meets any of the death conditions set by the monster on screen.
    }

    return false; //Otherwise, the game is still running.
  }

  /*************************************
   Updating characters and background
   **************************************/

  /*
   * Name: charaSetState
   * Param(s): stateVal - the state, running, jumping, or swimming, that the characters are in
   *                      due to the user's hand motion.
   * Requires: Must be an interger of value 0, 1, or 2, which corresponds to the constants: running,
   *           jumping, and swimming.
   * Purpose: Changes the character's motion and position to the defined state.
   */
  private void charaSetState(int stateVal) { 
    homura.setState(stateVal); // Set character 1's state
    kyoko.setState(stateVal);// Set character 2's state
    sayaka.setState(stateVal);// Set character 3's state
  }

  /*
   * Name: updatesMonsters
   * Purpose: Updates any moving monsters' position
   *          based on their specified motion algorithms.
   */
  private void updateMonsters() {
    charlotte.updatePos();// Update witch position
    poison.updatePos();// Update poison position
  }

  /*
   * Name: resetMonsters
   * Purpose: Places monsters at their starting positions.
   */
  private void resetMonsters() {
    charlotte.resetPos(); // Find new position for witch
    poison.resetPos(); // Find new position for poison
    kitty.resetPos(); // Find new position for cat
  }


  /*
   * Name: checkStageDisplay
   * Purpose: Determine if a sprite should
   *          be displayed at the end of a stage,
   *          and dispays it.
   */
  private void checkStageDisplay() {
    if (floor == totalFloors) {
      if (stage == 0) { // If on stage 1
        image(endStage1, buttonSize, 250); 
      } 
      if (stage == 1) { // If on stage 2
        image(endStage2, buttonSize, 300);
      }
      if (stage == 2) { // If on stage 3
        image(endStage3, buttonSize, 300);
      }
    }
  }


  /*
   * Name: determineState
   * Purpose: Parses user input information to determine
   *          what action the player character(s) should be
   *          performing at this time.
   */
  private void determineState() {
    if (keyPressed) {
      if (key == CODED) {
        if (keyCode == UP) { // If pressed up arrow
          charaSetState(jumping); //If the hand is positioned upwards, set the characters' state to jumping.
          displayContent(); //Display the change.
        } else if (keyCode == DOWN) { // If pressed down arrow
          charaSetState(swimming); //If the hand is positioned downwards, set the characters' state to swimming. 
          displayContent(); //Display the change.
        } else if (keyCode == LEFT && ammo > 0) { // If pressed left arrow and has ammo left
          charaSetState(attacking); //If the push button has been pressed and we have ammo, set the characters' state to shooting.
          displayContent();  //Display the change.

          if (keyClicked == false) { //If we are pressing the button after it has been released.
            keyClicked = true;  //Note that we are pressing the button.
            charlotte.tryShoot(homura.getYPos(), homura.getXPos()); //Try to shoot the witch.
            kitty.tryShoot(homura.getYPos(), homura.getXPos()); //Attempt shooting at the cat.
            ammo--; //Decrease ammo each time the player fires.
          }
        }
      }
    } else {
      keyClicked = false; //When no key is pressed, reset the push button status so we can press again.
      charaSetState(running); //Characters are running otherwise.
      displayContent(); //Display the updated graphics.
    }
  }

  /*
   * Name: characterUpdatePos
   * Purpose: Moves the characters forward, across the
   *          screen.
   */
  private void characterUpdatePos() {
    homura.updatePos(); // Update character 1 position
    kyoko.updatePos(); // Update character 2 position
    sayaka.updatePos(); // Update character 3 position
  }

  /*
   * Name: updateFloor
   * Purpose: Updates the floor, so that
   *          the player is at the next
   *          floor or stage.
   */
  private void updateFloor() {
    if (floor >= totalFloors) { //If we reach the last floor
      endStageVal = true; //Display the end stage screen.
    } else { 
      floor++; //Update the floor otherwise.
    }

    selectBG(); //Set the background accordingly.
  }

  /*
   * Name: selectBG
   * Purpose: Determines which background to 
   *          display and displays it. Backgrounds
   *          switch between mirrored and non-mirrored
   *          image visibly change the background
   *          for a new floor.
   */
  private void selectBG() {
    if (mirrorBg == false) { //Check if we do not need to mirror the background image.
      if (stage == 0) { //Purple background for stage 0.
        bg = lv1bg; 
      } else if (stage == 1) { //Blue background for stage 1.
        bg = lv2bg;
      } else {
        bg = lv3bg; //Pink background for stage 2.
      }
    } else { //Otherwise we mirror the background image.
      if (stage == 0) {
        bg = lv1bgMirror;
      } else if (stage == 1) {
        bg = lv2bgMirror;
      } else {
        bg = lv3bgMirror;
      }
    }

    mirrorBg = !mirrorBg; //Change the mirror background status so we switch between mirrored and not mirrored.
  }


  /*
   * Name: displayContent
   * Purpose: Displays the current background, characters, 
   *          and other game information.
   */
  private void displayContent() {
    if (homura.getXPos()%10 == 0) { //Update whenever the main character's position is a multiple of 10.
     //Display the current background.
      background(bg); 
      
      //Show current statistics
      text("Stage: " + stage + "  Floor: " + floor + "  Ammo: " + ammo, 10, 30); 
      
      //Display characters and monsters.
      homura.display(); // display character
      charlotte.display();   // display witch
      kitty.display(); // display cat
      poison.display(); // display poison


      //If stage above 0, also display the first follower character.
      if (stage > 0) {
        kyoko.display(); // if passed stage 1, display second character
      }

      //If stage is above 1, also display the second follower character.
      if (stage > 1) { // if passed stage 2, display third character
        sayaka.display();
      }

      checkStageDisplay(); //Check to see if we need additional sprites for the last floor.
    }
  }

  /*
   * Name: resetGame
   * Purpose: Sets all monsters and characters back at 
   *          their initial position to start a new stage.
   */
  void resetGame() {
    stage = 0; // stage goes back to 0
    floor = 0; // floor goes back to 0
    resetMonsters(); // reset enemies
    homura.resetPos(); // reset main character
    kyoko.resetPos(); // reset character 2
    sayaka.resetPos(); // reset character 3
    ammo = maxAmmo; // refill ammo
    gameOver = false;  // game is restarting
    selectBG(); // decide which background to display
  }
}

/* void serialEvent (Serial myPort) {
 // get the ASCII string:
 String inString = myPort.readStringUntil('\n');
 //  int colorFactor = 0; //A factor used to change the stroke color easily.
 
 if (inString != null) {
 // trim off any whitespace:
 inString = trim(inString);
 // convert to an int and map to the screen height:
 float inByte = float(inString); 
 float value = inByte;
 
 }*/


