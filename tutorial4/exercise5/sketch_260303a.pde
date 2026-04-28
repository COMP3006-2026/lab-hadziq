size(400, 400);
rectMode(CENTER);

float randomX, randomY, randomAngle;

pushMatrix();
randomX = random(50, 350);
randomY = random(50, 350);
randomAngle = random(TWO_PI);
fill(255,0,0);  // RED
translate(randomX, randomY);
rotate(randomAngle);
rect(0, 0, 100, 100);  // RECTANGLE 1
popMatrix();
// Draw the duplicate (45 degree rotated about its center)
pushMatrix();
fill(255,0,0);  // RED
translate(randomX, randomY);
rotate(randomAngle + 45 * PI / 180);
rect(0, 0, 100, 100);  // The duplicate of RECTANGLE 1
popMatrix();

pushMatrix();
randomX = random(50, 350);
randomY = random(50, 350);
randomAngle = random(TWO_PI);
fill(0,255,0);  // GREEN
translate(randomX, randomY);
rotate(randomAngle);
for (int i=0; i < 3; i++) {
  println("scale");
  scale(1.3);
}
rectMode(CORNER);
rect(0, 0, 100, 100);  // RECTANGLE 2
popMatrix();
// Draw the duplicate (90 degree rotated about its top left corner)
pushMatrix();
fill(0,255,0);  // GREEN
translate(randomX, randomY);
rotate(randomAngle + 90 * PI / 180);
for (int i=0; i < 3; i++) {
  println("scale");
  scale(1.3);
}
rect(0, 0, 100, 100);  // The duplicate of RECTANGLE 1
popMatrix();

pushMatrix();
randomX = random(50, 350);
randomY = random(50, 350);
randomAngle = random(TWO_PI);
fill(0,0,255);  // BLUE
translate(randomX, randomY);
rotate(randomAngle);
rectMode(CENTER);
rect(0, 0, 100, 100);  // RECTANGLE 3
popMatrix();

pushMatrix();
randomX = random(50, 350);
randomY = random(50, 350);
randomAngle = random(TWO_PI);
fill(127,127,127);  // GREY
translate(randomX, randomY);
rotate(randomAngle);
rect(0, 0, 100, 100);  // RECTANGLE 4
popMatrix();
