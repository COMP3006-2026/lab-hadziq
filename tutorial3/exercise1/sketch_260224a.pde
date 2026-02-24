float tblX = 120;   // left of tabletop
float tblY = 140;   // top of tabletop
float tblW = 360;   // tabletop width
float tblH = 24;    // tabletop thickness
float legW = 24;    // leg width
float legH = 160;   // leg height (downwards)


void setup() {
  size(640, 400);
  noStroke();
  background(245);
  drawTable2D();
}

void drawTable2D() {
  fill(170, 120, 70);  // tabletop color
  drawQuad(tblX,          tblY,
           tblX+tblW,     tblY,
           tblX+tblW,     tblY+tblH,
           tblX,          tblY+tblH);
           
  fill(140, 90, 50);     // legs color

  // Left leg
  float leftLegX = tblX + 28;
  drawQuad(leftLegX,           tblY + tblH,
           leftLegX + legW,    tblY + tblH,
           leftLegX + legW,    tblY + tblH + legH,
           leftLegX,           tblY + tblH + legH);
  leftLegX = tblX + 60;
  drawQuad(leftLegX,           tblY + tblH,
           leftLegX + legW * 0.8,    tblY + tblH,
           leftLegX + legW * 0.8,    tblY + tblH + legH * 0.8,
           leftLegX,           tblY + tblH + legH *0.8);

  // Right leg
  float rightLegX = tblX + tblW - 28 - legW;
  drawQuad(rightLegX,          tblY + tblH,
           rightLegX + legW,   tblY + tblH,
           rightLegX + legW,   tblY + tblH + legH,
           rightLegX,          tblY + tblH + legH);
  rightLegX = tblX + tblW - 60 - legW;
  drawQuad(rightLegX,          tblY + tblH,
           rightLegX + legW * 0.8,   tblY + tblH,
           rightLegX + legW * 0.8,   tblY + tblH + legH * 0.8,
           rightLegX,          tblY + tblH + legH * 0.8);

// Optional center stretcher bar (for sturdiness)
  //fill(120, 75, 40);
  //float barY = tblY + tblH + legH * 0.6;
  //float barH = 12;
  //float barInset = 70;
  //drawQuad(tblX + barInset,           barY,
  //         tblX + tblW - barInset,    barY,
  //         tblX + tblW - barInset,    barY + barH,
  //         tblX + barInset,           barY + barH);
}

void drawQuad(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  beginShape(QUADS);
  vertex(x1, y1);
  vertex(x2, y2);
  vertex(x3, y3);
  vertex(x4, y4);
  endShape();
}
