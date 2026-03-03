/*
Draw a simple human figure by modifying the program
from the lecture note that draws the Zoog. 
The human can be drawn using primitive shapes.
*/

void setup() {
  size(480, 480);
}

void draw() {
  background(255);
  strokeWeight(2);
  
  // Body
  fill(150);
  rectMode(CENTER);
  rect(240, 300, 60, 200);
  
  // Head
  fill(255);
  ellipse(240, 120, 160, 160);  // circle(240, 120, 160)
  
  // Face
  fill(0);
  ellipse(205, 100, 20, 20); // Left Eye
  ellipse(275, 100, 20, 20); // Right Eye
  ellipse(240, 135, 15, 25); // Nose
  ellipse(240, 175, 45, 22); // Mouth
  
  // Limbs
  line(210, 210, 140, 360); // Left Arm
  line(270, 210, 340, 360); // Right Arm
  line(215, 400, 160, 475); // Left Leg
  line(160, 475, 140, 475); // Left Foot
  line(265, 400, 320, 475); // Right Leg
  line(320, 475, 340, 475); // Right Foot
}
