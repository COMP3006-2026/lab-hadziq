PImage img1, img2;

void setup() {
  size(400,400);
  img1 = loadImage("orange.png");
  img2 = loadImage("shapes.png");
}

void draw() {
  background(255);
  image(img1, 0, 0);
  int mx = constrain(mouseX, 0, 360);
  int my = constrain(mouseY, 0, 360);
  copy(img2, mx-40, my-40, 80, 80, mx-40, my-40, 80, 80);
}
