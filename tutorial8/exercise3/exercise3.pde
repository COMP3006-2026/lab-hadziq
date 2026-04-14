import peasy.*;

PeasyCam cam;

// Rotate a filled pentagon with PeasyCam
void setup() {
  size(400, 400, P3D);
  cam = new PeasyCam(this, 400);
  fill(204);
}

void draw() {
  background(0);
  noStroke();
  beginShape();
  for (int i = 0; i < 5; i++) {
    float angle = TWO_PI / 5 * i - HALF_PI;
    float x = cos(angle) * 150;
    float y = sin(angle) * 150;
    vertex(x, y);
  }
  endShape(CLOSE);
  stroke(255);
  line(0, 0, -200, 0, 0, 200);
}
