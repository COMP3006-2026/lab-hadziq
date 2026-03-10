int rectSize = 10;

void setup() {
  size (200, 200);
  noLoop();
}

void draw() {
  int i = 0;
  while (i < width/rectSize) {
    int j = 0;
    while (j < height/rectSize) {
      //fill(random(0, 255));
      fill(random(255), random(255), random(255));
      rect(i * rectSize, j * rectSize, rectSize, rectSize);
      j++;
    }
    i++;
  }
}
