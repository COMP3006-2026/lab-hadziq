/*
Draw a sphere, the sphere is moving according to the mouse cursor. 
If the SHIFT key is pressed, the sphere is moving 
at the depth direction (along the z-coordinate)
*/

float x, y, z;

void setup() {
  size(600, 600, P3D);
  x = width / 2;
  y = height / 2;
  z = 0;
}

void draw() {
  background(20);
  
  // Lighting to make the sphere look 3D
  ambientLight(60, 60, 60);
  directionalLight(200, 200, 200, 0.5, 0.5, -1);
  
  if (keyPressed && keyCode == SHIFT) {
    // SHIFT held: move in depth (z) based on vertical mouse movement
    // Mouse down → sphere moves toward viewer (positive z)
    // Mouse up → sphere moves away (negative z)
    z = map(mouseY, 0, height, -300, 300);
    // Keep x, y at their last values (don't follow mouse in 2D while shifting)
  } else {
    // Normal: follow mouse in x and y
    x = mouseX;
    y = mouseY;
  }
  
  pushMatrix();
  translate(x, y, z);
  noStroke();
  fill(100, 180, 255);
  sphere(50);
  popMatrix();
}
