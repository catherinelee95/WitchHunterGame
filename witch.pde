class witch extends monster {

  /*
   * Name: Witch
   * Purpose: Creates a witch character and 
   *          ensures that it's visible.
   */
  public witch() {
    resetPos(); // decide where to place the witch
    offset = witchOffset; //Adjusts the display height so that differences between the height of varying sprites does not make the sprites seem to be much higher in position than they actually are.
    isVisible = true; // begin displaying the witch character
  }
  
  
    /*
   * Name: resetPos
   * Purpose: Resets this witch's position to
   *          a random location for a new floor
   *          or stage. Its height must be one of
   *          the three consistent with the player
   *          character's jumping, swimming, or running
   *          state.
   */
  public void resetPos() {
    xPos = witchDecider.nextInt(800);

    if (xPos%2 == 1) {
      xPos += 1; // increment x position of which
    }

    int witchYSelector = witchDecider.nextInt(3);

    if (witchYSelector == 0) {
      yPos = 100; // put witch on higher level of window
    } else if (witchYSelector == 1) {
      yPos = 300; // put witch on lower level of window
    } else {
      yPos = 230; // put witch on mid/ground level of window
    } 

    isVisible = true; // display the witch
  }

  /*
   * Name: updatePos
   * Purpose: Increments the witch's x position by
   *          4 px each time.
   */
  public void updatePos() {
    xPos += 4; // increment witch position by 4 to the right
  }


  /*
   * Name: isBumping
   * Purpose: Checks if the given character ran into the
   *          witch.
   */
  public boolean isBumping(userCharacter chara) {
    if ((chara.getXPos() - monsterBumpDistance)<= xPos && xPos <= (chara.getXPos() +monsterBumpDistance) && yPos == chara.getYPos() && xPos > 0 && isVisible) {
      return true; // if user ran into which, there must be colision
    }

    return false; // otherwise, there must not be a collision with witch
  }

  /*
   * Name: display
   * Purpose: display the witch if it should be visible.
   */
  public void display() {
    if (isVisible) { // if witch is displayed
      image(witch, xPos, yPos+offset); // show the witch image
    }
  }
}

