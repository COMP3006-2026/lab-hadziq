/*
Draw 10 random spheres and boxes 
with different sizes and positions. 
You can use primitives or shape3D library.
*/

int numShapes = 10;
Shape3D[] shapes = new Shape3D[numShapes];

float angleX = 0;
float angleY = 0;

void setup() {
  size(800, 600, P3D);
  generateShapes();
}

void draw() {
  background(25, 30, 45);
  lights();
  
  // Center the scene and apply mouse-based rotation
  translate(width/2, height/2, 0);
  
  if (mousePressed) {
    angleY = map(mouseX, 0, width, -PI, PI);
    angleX = map(mouseY, 0, height, -PI, PI);
  }
  rotateX(angleX);
  rotateY(angleY);
  
  // Draw all shapes
  for (Shape3D s : shapes) {
    s.render();
  }
}

void generateShapes() {
  for (int i = 0; i < numShapes; i++) {
    float x = random(-250, 250);
    float y = random(-200, 200);
    float z = random(-250, 250);
    float size = random(30, 90);
    int type = int(random(2)); // 0 = sphere, 1 = box
    
    shapes[i] = new Shape3D(x, y, z, size, type);
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    generateShapes();
  }
}
