PImage[] earth = new PImage[240];
PImage moon;
int frame = 0;
float angle = 0;
float dMoonToEarth = 240;
float angularSpeed = 0.025;

// Blur/trail level
int trailLength = 10;
float[] trailX = new float[trailLength];
float[] trailY = new float[trailLength];
float[] trailAngle = new float[trailLength];

void setup() {
  size(500, 500);
  for (int i=0; i<240; i++) {
    earth[i] = loadImage("../earth/" + i + ".gif");
  }
  moon = loadImage("../moon-icon.png");
  moon.resize(50,50);
  frameRate(30);
  imageMode(CENTER);
  
  // Initialize trail positions
  for (int i = 0; i < trailLength; i++) {
    float a = angle - i * angularSpeed;
    trailX[i] = sin(a) * dMoonToEarth + 250;
    trailY[i] = cos(a) * dMoonToEarth * 0.2 + 250;
    trailAngle[i] = a;
  }
}

void draw() {
  background(0);
  
  // Update trail, shift old positions back
  for (int i = trailLength - 1; i > 0; i--) {
    trailX[i] = trailX[i-1];
    trailY[i] = trailY[i-1];
    trailAngle[i] = trailAngle[i-1];
  }
  trailX[0] = sin(angle) * dMoonToEarth + 250;
  trailY[0] = cos(angle) * dMoonToEarth * 0.2 + 250;
  trailAngle[0] = angle;
  
  boolean moonInFront = cos(trailAngle[0]) >= 0;
  
  // Draw back half of trail (behind the Earth)
  for (int i = trailLength - 1; i >= 0; i--) {
    if (cos(trailAngle[i]) < 0) {
      float alpha = map(i, 0, trailLength - 1, 255, 0);
      fill(200, 200, 200, alpha);
      noStroke();
      circle(trailX[i], trailY[i], 50);
    }
  }
  
  if (!moonInFront) {
    image(moon, trailX[0], trailY[0]);
  }
  
  image(earth[frame%240], 250, 250);
  
  // Draw front half of trail (in front of the Earth)
  for (int i = trailLength - 1; i >= 0; i--) {
    if (cos(trailAngle[i]) >= 0) {
      float alpha = map(i, 0, trailLength - 1, 255, 0);
      fill(200, 200, 200, alpha);
      noStroke();
      circle(trailX[i], trailY[i], 50);
    }
  }
  
  if (moonInFront) {
    image(moon, trailX[0], trailY[0]);
  }
  
  angle += angularSpeed;
  frame++;
}
