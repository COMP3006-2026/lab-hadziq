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

// For the shuttle
float shuttleX;
float shuttleY;
float pct = 0.0;      // percentage travel (0.0 to 1.0);
float step = 0.0;     // size of each step along the path
float shuttleSpeed = 0;
boolean arrived = false;

void setup() {
  size(500, 500);
  shuttleX = width/2;
  shuttleY = height/2-75;
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
    
    if (!arrived) {
      step += 0.005;                            
      shuttleSpeed = sin(step * PI) * 0.005;    
      pct += shuttleSpeed;                          
    }
    
    if (pct >= 1.0) {
      pct = 1.0;
      arrived = true;
    }
    
    float distX = trailX[0] - shuttleX;
    float distY = trailY[0] - shuttleY;
    shuttleX = shuttleX + (pct * distX);
    shuttleY = shuttleY + (pct * distY);
    
    drawShuttle();
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
    
    if (!arrived) {
      step += 0.005;                            
      shuttleSpeed = sin(step * PI) * 0.005;    
      pct += shuttleSpeed;                          
    }
    
    if (pct >= 1.0) {
      pct = 1.0;
      arrived = true;
    }
    
    float distX = trailX[0] - shuttleX;
    float distY = trailY[0] - shuttleY;
    shuttleX = shuttleX + (pct * distX);
    shuttleY = shuttleY + (pct * distY);
    
    drawShuttle();
  }
  
  angle += angularSpeed;
  frame++;
}

void drawShuttle() {
  pushMatrix();
  translate(shuttleX, shuttleY);
  fill(200, 200, 200);
  stroke(150);
  strokeWeight(1);
  beginShape();
    vertex(15, 0);
    vertex(-10, -7);
    vertex(-18, -12);
    vertex(-10, -4);
    vertex(-12, 0);
    vertex(-10, 4);
    vertex(-18, 12);
    vertex(-10, 7);
  endShape(CLOSE);
  popMatrix();
}
