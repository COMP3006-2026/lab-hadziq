int rectSize = 10;

void setup() {
  size (200, 200);
}

void draw() {
  for (int i = 0; i < width/rectSize; i++) {
    for (int j = 0; j < height/rectSize; j++) {
      //fill(random(0, 255));
      fill(random(255), random(255), random(255));
      rect(i * rectSize, j * rectSize, rectSize, rectSize);
    }
  }
  //noLoop();
}
