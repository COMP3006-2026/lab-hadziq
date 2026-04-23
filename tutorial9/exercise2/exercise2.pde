/*
Modify the exercise 1 by adding attributes to each shapes randomly, 
including either with fill (or noFill), with outline (or noOutline) 
and a random colour of either Red, Green or Blue.
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
    
    // Random attributes
    boolean useFill   = random(1) < 0.5;
    boolean useStroke = random(1) < 0.5;
    
    // Guard against invisible shapes (no fill AND no stroke)
    if (!useFill && !useStroke) {
      // Force one of them on
      if (random(1) < 0.5) useFill = true;
      else useStroke = true;
    }
    
    // Random color: 0 = Red, 1 = Green, 2 = Blue
    int colorChoice = int(random(3));
    color c;
    if (colorChoice == 0) {
      c = color(220, 60, 60);    // Red
    } else if (colorChoice == 1) {
      c = color(60, 200, 90);    // Green
    } else {
      c = color(70, 120, 230);   // Blue
    }
    
    shapes[i] = new Shape3D(x, y, z, size, type, c, useFill, useStroke);
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    generateShapes();
  }
}
