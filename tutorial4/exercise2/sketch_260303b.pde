size(400, 400);

// Draw 4 rectangles on the same position with different colors
float randomX = random(50, 350);
float randomY = random(50, 350);

pushMatrix();
translate(randomX, randomY);
fill(255,0,0);  // RED
rect(0, 0, 100, 100);  // RECTANGLE 1
pushMatrix();
translate(-randomX, -randomY);

randomX = random(50, 350);
randomY = random(50, 350);
pushMatrix();
translate(randomX, randomY);
fill(0,255,0);  // GREEN
rect(0, 0, 100, 100);  // RECTANGLE 2
pushMatrix();
translate(-randomX, -randomY);

randomX = random(50, 350);
randomY = random(50, 350);
pushMatrix();
translate(randomX, randomY);
fill(0,0,255);  // BLUE
rect(0, 0, 100, 100);  // RECTANGLE 3
pushMatrix();
translate(-randomX, -randomY);

popMatrix();
popMatrix();
popMatrix();
popMatrix();
popMatrix();
popMatrix();
fill(127,127,127);  // GREY
rect(0, 0, 100, 100);  // RECTANGLE 4
