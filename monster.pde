abstract class monster {
  protected int xPos;   // x position of monster
  protected int yPos;   // y position of monster
  protected int offset;
  protected boolean isVisible; // determine whether monster should be shown

  /*
   * Name: Monster
   * Purpose: Creates a monster character and 
   *          ensures that it's visible.
   */
  public monster() {
    resetPos(); // decide where to place monster
    offset = 0;
    isVisible = true; // begin displaying monster
  }

  /*
   * Name: resetPos
   * Purpose: Resets a monster's position to
   *          a random location for a new floor
   *          or stage.
   */
  private void resetPos() {
  };

  /*
   * Name: updatePos
   * Purpose: Updates the position of the monster
   *          based on its defined motion algorithm.
   */
  public void updatePos() {
  };

  /*
   * Name: display
   * Purpose: display the monster.
   */
  public void display() {
  };

  /*
   * Name: isBumping
   * Purpose: Checks if the given character has violated
   *          any of the conditions set by the monster
   *          that would result in a game loss.
   */
  public boolean isBumping(userCharacter chara) { 
    return true;
  };

  /*
   * Name: tryShoot
   * Purpose: check if the protagonist succesfully 
   *          defeated this monster.
   */
  public void tryShoot(int protagYPos, int protagXPos) {
    if (yPos == protagYPos && xPos < protagXPos) { //If the bullet is along the same height as the monster:
      isVisible = false; //Hide the monster.
    }
  }

  /*
   * Name: getXPos
   * Purpose: Returns the monster's x position.
   */
  public int getXPos() {
    return xPos; // x position for monster
  } 

  /*
   * Name:  getYPos
   * Purpose: Returns the monster's y position.
   */
  public int getYPos() {
    return yPos; // y position for monster
  }
}

