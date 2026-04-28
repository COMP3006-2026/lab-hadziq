import peasy.*;

PeasyCam cam;

float moonAngle = 0;
float shuttleT = 0;
boolean shuttleForward = true;

void setup() {
  size(400, 400, P3D);
  cam = new PeasyCam(this, 800);
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
  translate(600, 0, 0);
  fill(180);
  sphere(30);
  popMatrix();

  // Shuttle
  pushMatrix();
  rotateY(moonAngle * shuttleT);
  float x = lerp(90, 570, shuttleT);
  translate(x, 0, 0);
  fill(255, 200, 0);
  box(15, 8, 25);
  popMatrix();

  // Update moon orbit
  moonAngle += 0.02;

  // Update shuttle position
  if (shuttleForward) {
    shuttleT += 0.005;
    if (shuttleT >= 1) {
      shuttleT = 1;
      shuttleForward = false;
    }
  } else {
    shuttleT -= 0.005;
    if (shuttleT <= 0) {
      shuttleT = 0;
      shuttleForward = true;
    }
  }
}
