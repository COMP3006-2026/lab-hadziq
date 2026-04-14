import peasy.*;

PeasyCam cam;

float moonAngle = 0;

void setup() {
  size(400, 400, P3D);
  cam = new PeasyCam(this, 500);
}

void draw() {
  background(0);
  lights();

  // Earth
  noStroke();
  fill(0, 100, 255);
  sphere(80);

  // Moon
  pushMatrix();
  rotateY(moonAngle);
  translate(200, 0, 0);
  fill(180);
  sphere(30);
  popMatrix();

  moonAngle += 0.02;
}
