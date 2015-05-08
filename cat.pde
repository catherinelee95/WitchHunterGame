class cat extends monster {

  /*
   * Name: cat
   * Purpose: Creates a cat character with
   *          a specified offset for cats.
   */
  public cat() {
    resetPos(); // Find a new position for the black cat
    offset = catOffset; //Adjusts the display height so that differences between the height of varying sprites does not make the sprites seem to be much higher in position than they actually are.
    isVisible = true; // Display the black cat
  }

  /*
   * Name: resetPos
   * Purpose: Places the cat in a random position with
   *          one of three possible y values (top, center, bottom).
   *          This allows the cat to be randomly placed each floor.
   */
  public void resetPos() {
    xPos = witchDecider.nextInt(800); // Get a new x position for cat

    if (charlotte.getXPos()%2 == 1) {
      xPos += 1; // Increment x-pos to move character right
    }

    int witchYSelector = witchDecider.nextInt(3);

    if (witchYSelector == 0) { // If user selects crawl
      yPos = 100; // Character is crawling
    } else if (witchYSelector == 1) { // If user selects jump
      yPos = 300; // Character is jumping
    } else { // Normal position is walking on ground level
      yPos = 230; // Character remains on ground level
    } 

    isVisible = true;
  }

  /*
   * Name: updatePos
   * Purpose: Does nothing, as the cat does not move.
   */
  public void updatePos() {
    return; //Do nothing, since the cat stays in one spot.
  }


  /*
   * Name: resetPos
   * Purpose: Checks if the player character has bumped into
   *          the cat.
   */
  public boolean isBumping(userCharacter chara) {
    // if character x,y positions are overlapping, they must have collided
    if ((chara.getXPos() - monsterBumpDistance)<= xPos && xPos <= (chara.getXPos() +monsterBumpDistance) && yPos == chara.getYPos() && xPos > 0 && isVisible) {
      return true; // Game over
    }

    return false; // Otherwise, continue game
  }

 /*
   * Name: display
   * Purpose: display the cat if it should be visible.
   */
  public void display() {
    if (isVisible) { // If we want cat to be shown
      image(blackCat, xPos, yPos+offset); // Display black cat
    }
  }
}

