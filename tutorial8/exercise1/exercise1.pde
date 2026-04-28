// Rotate a filled circle around the y-axis and x-axis with P3D
void setup() {
  size(400, 400, P3D);
  fill(204);
}

void draw() {
  background(0);
  translate(width/2, height/2, -width);
  rotateY(map(mouseX, 0, width, -PI, PI));
  rotateX(map(mouseY, 0, height, -PI, PI));
  noStroke();
  
  //ellipse(0, 0, 300, 300);
  circle(0, 0, 300);
  
  stroke(255);
  line(0, 0, -200, 0, 0, 200);
}
