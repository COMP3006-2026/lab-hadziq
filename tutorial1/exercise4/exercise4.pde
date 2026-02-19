/*
Improve the drawing of the human by using drawing attributes, 
including fill, stroke and colour.
*/

void setup() {
  size(480, 480);
}

void draw() {
  background(135, 206, 235); // A "Sky Blue" background
  strokeWeight(3);
  
  // Body
  fill(34, 139, 34);         // Forest Green
  stroke(20, 80, 20);
  rectMode(CENTER);
  rect(240, 300, 60, 200);
  
  // Head
  fill(240, 190, 150);       // Warm Skin Tone
  stroke(180, 130, 90);
  ellipse(240, 120, 160, 160);  // circle(240, 120, 160)
  
  // Face
  fill(60, 30, 10);          // Deep Brown
  noStroke();                // Remove outlines from eyes/nose for a cleaner look
  ellipse(205, 100, 20, 20); // Left Eye
  ellipse(275, 100, 20, 20); // Right Eye
  ellipse(240, 135, 15, 25); // Nose
  fill(200, 80, 80);         // Muted Red/Pink for Mouth
  ellipse(240, 175, 45, 22); // Mouth
  
  // Limbs
  stroke(240, 190, 150);     
  strokeWeight(10);          // Thicker lines for "meaty" arms/legs
  line(210, 210, 140, 360); // Left Arm
  line(270, 210, 340, 360); // Right Arm
  line(215, 400, 160, 475); // Left Leg
  line(160, 475, 140, 475); // Left Foot
  line(265, 400, 320, 475); // Right Leg
  line(320, 475, 340, 475); // Right Foot
}
