size(480, 200);
background(200);
fill(0);

beginShape();
vertex(5, 200);
int topLeftTrapeX = 25;
int topRightTrapeX = width - 25;
int topTrapeLength = topRightTrapeX - topLeftTrapeX;
int nTriangle = 10;
int gapLength = topTrapeLength / (2 * nTriangle - 1);
vertex(topLeftTrapeX, 135);  // top left of trapezoid

int cursorX = topLeftTrapeX;
for (int i = 0; i < nTriangle; i++) {
  cursorX = cursorX + gapLength / 2;
  vertex(cursorX, 10);
  cursorX = cursorX + gapLength / 2;
  vertex(cursorX, 135);
  if (i != nTriangle - 1) {
    cursorX = cursorX + gapLength;
    vertex(cursorX, 135);
  }
}

vertex(topRightTrapeX, 135);  // top right of trapezoid
vertex(width - 5, 200);
endShape(CLOSE);
