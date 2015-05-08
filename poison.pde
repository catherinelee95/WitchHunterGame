class poison extends monster {
  private int xInc; // x position of poison
  private int yInc; // y position of poison
  private float theta; // angle to shoot poison

  /*
    * Name: Poison
   * Purpose: Creates a poison character and 
   *          ensures that it's visible.
   */
  public poison() {
    resetPos(); //Decide where to place poison 
    offset = 0; //Adjusts the display height so that differences between the height of varying sprites does not make the sprites seem to be much higher in position than they actually are.
    theta = (float) witchDecider.nextDouble(); //Get angle of shooting poison
    isVisible = true; //Display poison
  }

  /*
   * Name: resetPos
   * Purpose: Resets this poison gas's position to
   *          a random location for a new floor
   *          or stage.
   */
  private void resetPos() {
    xPos = witchDecider.nextInt(1000); //Randomly find an x position.
    yPos = yInc = xInc = witchDecider.nextInt(8); //Randomly select a y position and an increment position for the x and y axis.
    isVisible = true; //Make the poison gas visible again.
  }
  
  
  /*
   * Name: updatePos
   * Purpose: Updates the position of the poison 
   *          gas in the motion of an inverted sine
   *          wave with random linear increments in the x and 
   *          y direction.
   */
  public void updatePos() {
    xPos = (int)(300+(sin(theta)*20*yInc)) + xInc; //Calculate the x position based on the random angle and random x and y increments, which are based on the initial y value.
    yPos += yInc; // increase y position to shoot poison
    xInc += 4; // increase x position to shoot poison
    theta += (TWO_PI / 500) * 10; // increase angle of shooting
  }
  

  /*
   * Name: tryShoot
   * Purpose: Overrides the inherited tryShoot function. 
   *          The poison gas cannot be shot at.
   */
  public void tryShoot(int protagYPos, int ProtagXPos) {
    return;
  }



  /*
   * Name: isBumping
   * Purpose: Checks if the given character is swimming while
   *          the poison gas is on the screen.
   */
  public boolean isBumping(userCharacter chara) {
    if (chara.getYPos() == 300 && xPos < 1000 && xPos > 0 && yPos > 0 && yPos < 600 && isVisible) { //If the character is swimming and gas is on screen
      return true; //Return true
    }

    return false; //Otherwise false
  }

  /*
   * Name: display
   * Purpose: display the poison gas if it should be visible.
   */
  public void display() {
    if (isVisible) { // if poison exists
      image(monster, xPos, yPos+offset); // display it
    }
  }
}

