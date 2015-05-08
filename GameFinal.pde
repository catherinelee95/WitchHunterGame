
import processing.serial.*; // Import serial port library
game Game; // Game object

import ddf.minim.*; // Import music file library
Minim minim; // Music object

/*****************************
 Main Game
 ****************************/


/*
 * Name: Setup
 * Purpose: Initializes the window, game, and music.
 */
void setup () {
  // set the window size:
  size(1000, 600);  // Use P3D render mode to process graphics faster
  minim = new Minim(this); // Initialize music object 
  Game = new game(); // Initialize game
}


void draw () {
  Game.playGame(); // Begin game
}



