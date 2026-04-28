/*
Draw two shapes on the sketch (e.g. a rectangle and a circle with random size). 
Use the mouse to select and drag any shape to anywhere on the sketch.
*/

int[] x = {200, 440}; // the x values of rectangle and circle
int[] y = {240, 240};
int n = 1;
boolean[] keys = new boolean[256]; // tracks held keys
int extend = 100;

void setup() {
  size(640, 480);
  rectMode(CENTER);
}

void draw() {
  background(127);
  
  if (keyPressed) {
    // OBJECT SELECTION
    if (keys['1']) n = 1;
    else if (keys['2']) n = 2;
    
    //LEFT 37 x--
    if (keys[37]) {
      x[n-1]-=5;
    }
    //UP 38 y--
    if (keys[38]) {
      y[n-1]-=5;
    }
    //RIGHT 39 x++
    if (keys[39]) {
      x[n-1]+=5;
    }
    //DOWN 40 y++
    if (keys[40]) {
      y[n-1]+=5;
    }
  }
  
  rect(x[1-1], y[1-1], extend, extend);
  circle(x[2-1], y[2-1], extend);
}

void keyPressed()  { if (keyCode < 256) keys[keyCode] = true; }
void keyReleased() { if (keyCode < 256) keys[keyCode] = false; }

void mousePressed() {
  // Check if it is inside rectangle
  if (mouseX > (x[1-1] - extend/2) && mouseX < (x[1-1] + extend/2) &&
      mouseY > (y[1-1] - extend/2) && mouseY < (y[1-1] + extend/2)) {
     
    println("rectangle");
  }
  // Check if it is inside circle
  else if (mouseX > (x[2-1] - extend/2) && mouseX < (x[2-1] + extend/2) &&
           mouseY > (y[2-1] - extend/2) && mouseY < (y[2-1] + extend/2)) {
           
    println("circle");           
  }
}
