class userCharacter {
  //A character's current position
  private int xPos;   // x position
  private int yPos;   // y position
  
  //The character's state of motion, which is one of either running, jumping, swimming, or shooting.
  private int state;
  
  //The current active sprite of the character, based on the character's state of motion.
  private PImage protagonist;

  //Since images may vary in height, offsets are provided to place all characters at the same level for all actions.
  private int offset; //Moves character to the right by this amount.
  private int runOffset; //Moves character down by this amount when running.
  private int swimOffset; //Moves character down by this amount when swimming. 
  private int attackOffset; //Moves character down by this amount when attacking.

 //Images for a character, for all motions.
  private PImage runA; // running
  private PImage runB; // running
  private PImage jumps; // jumping
  private PImage swimA; // swimming
  private PImage swimB; //swimming
  private PImage attackA; // attacking
  private PImage attackB; // attacking



  public userCharacter(int xOffset, int offsetRun, int offsetSwim, int offsetAttack, PImage walk1, PImage walk2, PImage jump, PImage down, PImage down2, PImage attack1, PImage attack2) {
    //Save the offset values to their appropriate global variable - these values prevent one character from seeming higher up than other characters due to differences in pixel 
    //height by adjusting the displayed height.
    offset = xOffset; //Offset to indicate how much further to the right this character should be.
    runOffset = offsetRun; //Height adjustment for running mode.
    swimOffset = offsetSwim; //Height adjustment for swimming mode.
    attackOffset = offsetAttack; //Height adjustment for attacking mode.

    //Start the protagonist running from the right side of the screen.
    xPos = 998 + offset; //Let the protagonist begin moving from the right side of the screen.
    yPos = 230; //Place the character at the same y position.
    
    loadImg(walk1, walk2, jump, down, down2, attack1, attack2); //Check 

    protagonist = runA; // main character begins running
  }

  public void resetPos() {
    xPos = 998+offset; // reset the x position of main character
    yPos = 230; // reset y position of main character
    protagonist = runA; // start character as running
  }

  private void loadImg(PImage walk1, PImage walk2, PImage jump, PImage down, PImage down2, PImage attack1, PImage attack2) {
    runA = walk1; // running image
    runB = walk2; // running image
    jumps = jump; // jumping image
    swimA = down; // swimming/crawling image
    swimB = down2; // swimming/crawling image
    attackA = attack1; // attacking image
    attackB = attack2; // attacking image
  }

  public void updatePos() {
    if (xPos <= offset) {
      xPos = 998 + offset;
    } else {
      xPos -= 2; // move character left 2 positions
    }
  }

  public void updateAnimation() {
    if (state == running) { // if char is running
      if (xPos%20 == 0) {// if char is running with first image
        protagonist = runB; // switch to second running image for effects
      } else if (xPos%10 == 0) { // if char is running with second image
        protagonist = runA; // switch to other running image for effects
      }
    } else if (state == swimming) { // if char is swimming
      if (xPos%20 == 0) {// if char is swimming with first image
        protagonist = swimB; // switch to second image for effects
      } else if (xPos%10 == 0) {// if char is swimming with second image
        protagonist = swimA; // switch to other image for effects
      }
    } else if (state == jumping) { // if char is jumping
      protagonist = jumps; // show char in jumping position
    } else if (state == attacking) { // if char is attacking
      if (xPos%20 == 0) { // if on first attacking image
        protagonist = attackB; // switch to second attacking image for effects
      } else if (xPos%10 == 0) { // if on second attacking image
        protagonist = attackA; // switch to other attacking image for effects
      }
    }
  }

  public void setState(int state) {
    this.state = state;

    if (state == running) { // f char is running
      yPos = 230;  // put them on mid level of window
    } else if (state == jumping) { // if char is jumping
      yPos = 100; // put char on higher level of window
    } else if (state == swimming) { // if char is swimming
      yPos = 300; // display char on lower window
    }

    updateAnimation(); // update the image to create real life effects
  }

  int getXPos() {
    return xPos; // x position of users character
  } 

  int getYPos() {
    return yPos; // y position of users character
  }

  void display() {
    if (protagonist == null) { // if no protagonist
      return;
    }

    if (state == running) { // if char is running
      image(protagonist, xPos, yPos+runOffset); // show running image
    } else if (state == swimming) { // if char is swimming
      image(protagonist, xPos, yPos+swimOffset); // show swimming image
    } else if (state == attacking) { // if char is attacking
      image(protagonist, xPos, yPos+attackOffset); // show attacking image
    } else { // otherwise, show normal image
      image(protagonist, xPos, yPos); 
    }
  }
}

