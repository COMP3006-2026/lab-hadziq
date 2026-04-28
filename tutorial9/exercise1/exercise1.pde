/*
Draw 10 random spheres and boxes 
with different sizes and positions. 
You can use primitives or shape3D library.
*/

int numShapes = 10;
Shape3D[] shapes = new Shape3D[numShapes];

void setup() {
  size(800, 600, P3D);
  generateShapes();
}

void draw() {
  background(25, 30, 45);
  lights();
  
  // Center the scene
  translate(width/2, height/2, 0);
  
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
