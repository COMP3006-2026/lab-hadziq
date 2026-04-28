int rect1X;
int rect2X;
int rect3X;
int rectSize = 100;
int rectY = 100;

void setup() {
  size (500, 300);
  background (255);
  fill (127);
  rect1X = 50;
  rect2X = 200;
  rect3X = 350;
}

void draw() {
  color rect1Color = color(127, 127, 127);
  color rect2Color = color(127, 127, 127);
  color rect3Color = color(127, 127, 127);
  
  if (mouseX > rect1X && mouseY > rectY && mouseX < rect1X + rectSize && mouseY < rectY + rectSize)
    rect1Color = color(255, 0 , 0); // Red Button
  else if (mouseX > rect2X && mouseY > rectY && mouseX < rect2X + rectSize && mouseY < rectY + rectSize)
    rect2Color = color(0, 255, 0);  // Green Button
  else if (mouseX > rect3X && mouseY > rectY && mouseX < rect3X + rectSize && mouseY < rectY + rectSize)
    rect3Color = color(0, 0, 255);  // Blue Button
  
  fill (rect1Color);
  rect (rect1X, rectY, rectSize, rectSize);
  fill (rect2Color);
  rect (rect2X, rectY, rectSize, rectSize);
  fill (rect3Color);
  rect (rect3X, rectY, rectSize, rectSize);
}
