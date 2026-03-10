/*
Draw two shapes on the sketch (e.g. a rectangle and a circle). 
Use the UP, DOWN, LEFT and RIGHT keys to control the movement of the selected shape. 
A shape is selected by either pressing a key ‘1’ or or key ‘2’ 
so that shape 1 or shape 2 can be picked up respectively.
*/
int[] x = {200, 440}; // the x values of rectangle and circle
int[] y = {240, 240};
int n = 1;

void setup() {
  size(640, 480);
  rectMode(CENTER);
}

void draw() {
  background(127);
  
  if (keyPressed) {
    // OBJECT SELECTION
    if (key == '1') n = 1;
    else if (key == '2') n = 2;
    
    //LEFT 37 x--
    if (keyCode == 37) {
      x[n-1]-=5;
    }
    //UP 38 y--
    if (keyCode == 38) {
      y[n-1]-=5;
    }
    //RIGHT 39 x++
    if (keyCode == 39) {
      x[n-1]+=5;
    }
    //DOWN 40 y++
    if (keyCode == 40) {
      y[n-1]+=5;
    }
  }
  
  rect(x[1-1], y[1-1], 100, 100);
  circle(x[2-1], y[2-1], 100);
}

/*
void keyPressed() {
  // OBJECT SELECTION
  if (key == '1') n = 1;
  else if (key == '2') n = 2;
  
  //LEFT 37 x--
  if (keyCode == 37) {
    x[n-1]-=5;
  }
  //UP 38 y--
  if (keyCode == 38) {
    y[n-1]-=5;
  }
  //RIGHT 39 x++
  if (keyCode == 39) {
    x[n-1]+=5;
  }
  //DOWN 40 y++
  if (keyCode == 40) {
    y[n-1]+=5;
  }
}
*/
