//size (640, 640);

//beginShape();
//vertex(20, 320);
//bezierVertex(20, 20, width-20, 20, width-20, 320);
//bezierVertex(width-20, height-20, 20, height-20, 20, 320);
//endShape();

/**
 * Guitar silhouette with cubic Bézier segments
 * - Uses beginShape() + bezierVertex()
 * - Shows anchors (●), control points (×), and handle lines
 * - Labels each anchor/control so you can understand how the curve is built
 *
 * Controls:
 *   g - toggle guides (anchors, controls, labels)
 *   b - toggle body fill/strokes
 */

import java.util.ArrayList;

boolean showGuides = true;
boolean showBody = true;

void setup() {
  size(900, 1000);
  smooth(8);
  noLoop();
}

void draw() {
  background(250);
  translate(width * 0.5, 80); // center horizontally, small top margin
  drawGuitar();
}

void keyPressed() {
  if (key == 'g' || key == 'G') { showGuides = !showGuides; redraw(); }
  if (key == 'b' || key == 'B') { showBody   = !showBody;   redraw(); }
}

// ---------------- Data types ----------------

class Pt {
  float x, y;
  String name;
  Pt(float x, float y, String name) { this.x = x; this.y = y; this.name = name; }
  Pt copy() { return new Pt(x, y, name); }
}

class Seg {
  Pt p0;   // anchor FROM (implicit vertex in path)
  Pt c1;   // control from p0 side
  Pt c2;   // control toward p3 side
  Pt p3;   // anchor TO
  String name;
  Seg(Pt p0, Pt c1, Pt c2, Pt p3, String name) {
    this.p0 = p0; this.c1 = c1; this.c2 = c2; this.p3 = p3; this.name = name;
  }
}

// ---------------- Point helpers (GLOBAL SCOPE) ----------------

// Mirror across the vertical centerline (x = 0)
Pt mirrorX(Pt p, String newName) { return new Pt(-p.x, p.y, newName); }

// Convenience for offsetting controls
Pt cx(Pt p, float dx, String n){ return new Pt(p.x + dx, p.y, n); }               // horizontal
Pt cy(Pt p, float dy, String n){ return new Pt(p.x, p.y + dy, n); }               // vertical
Pt cxy(Pt p, float dx, float dy, String n){ return new Pt(p.x + dx, p.y + dy, n); } // diagonal

// ---------------- Main drawing ----------------

void drawGuitar() {
  /*
   * Coordinate plan (origin after translate is the vertical centerline of the guitar):
   *  - x grows to the RIGHT, y grows DOWN (Processing default).
   *  - We build anchors top→right side→bottom center→left side→back to top center.
   *
   * Key vertical stations (y values):
   *   yHeadTop   : very top of headstock
   *   yNut       : nut / top of fingerboard (narrowest neck)
   *   yNeckEnd   : where neck meets body
   *   yUpperMax  : max width of upper bout
   *   yWaist     : minimum width (waist)
   *   yLowerMax  : max width of lower bout
   *   yTail      : very bottom center of body
   */

  // --- Vertical positions (px) ---
  float yHeadTop  =  20;
  float yNut      = 110;
  float yNeckEnd  = 220;
  float yUpperMax = 280;
  float yWaist    = 380;
  float yLowerMax = 520;
  float yTail     = 720;

  // --- Half widths (px) at those stations ---
  float halfHead    =  55;  // headstock half-width
  float halfNeck    =  22;  // nut half-width (narrow neck)
  float halfNeckEnd =  28;  // slight flare where neck joins body
  float halfUpper   =  95;  // upper bout max
  float halfWaist   =  68;  // waist min
  float halfLower   = 128;  // lower bout max

  // --- ANCHORS (right side) ---
  Pt A0_center = new Pt(  0, yTail,        "A0 TailCenter");
  Pt A1_lower  = new Pt(halfLower, yLowerMax, "A1 LowerBout_R");
  Pt A2_waist  = new Pt(halfWaist, yWaist,    "A2 Waist_R");
  Pt A3_upper  = new Pt(halfUpper, yUpperMax, "A3 UpperBout_R");
  Pt A4_neckJ  = new Pt(halfNeckEnd, yNeckEnd, "A4 NeckJoint_R");
  Pt A5_nut    = new Pt(halfNeck, yNut,       "A5 Nut_R");
  Pt A6_headR  = new Pt(halfHead, yHeadTop,   "A6 HeadTop_R");
  Pt A7_topCtr = new Pt(0, yHeadTop,          "A7 HeadTop_Center");

  // --- MIRRORED LEFT SIDE ANCHORS ---
  Pt B6_headL  = mirrorX(A6_headR, "B6 HeadTop_L");
  Pt B5_nut    = mirrorX(A5_nut,   "B5 Nut_L");
  Pt B4_neckJ  = mirrorX(A4_neckJ, "B4 NeckJoint_L");
  Pt B3_upper  = mirrorX(A3_upper, "B3 UpperBout_L");
  Pt B2_waist  = mirrorX(A2_waist, "B2 Waist_L");
  Pt B1_lower  = mirrorX(A1_lower, "B1 LowerBout_L");

  // ---------------- Control parameters (tweak these) ----------------
  float outStrong =  80; // horizontal outward pull near lower bout
  float outSoft   =  40; // softer outward pull
  float upMed     = -60; // upward (negative y) pull
  float upSoft    = -30;
  float dnSoft    =  30;
  float dnMed     =  60;

  // ---------------- Build cubic segments ----------------
  ArrayList<Seg> segs = new ArrayList<Seg>();

  // Right side: A0 -> A1 -> A2 -> A3 -> A4 -> A5 -> A6 -> A7
  segs.add(new Seg(
    A0_center,
    cx(A0_center, +outStrong, "C1 S0"),
    cxy(A1_lower, +outSoft, -20, "C2 S0"),
    A1_lower,
    "S0 Tail→LowerBout_R"
  ));

  segs.add(new Seg(
    A1_lower,
    cy(A1_lower, upMed, "C1 S1"),
    cxy(A2_waist, +30, +10, "C2 S1"),
    A2_waist,
    "S1 LowerBout_R→Waist_R"
  ));

  segs.add(new Seg(
    A2_waist,
    cxy(A2_waist, +25, upSoft, "C1 S2"),
    cy(A3_upper, dnSoft, "C2 S2"),
    A3_upper,
    "S2 Waist_R→UpperBout_R"
  ));

  segs.add(new Seg(
    A3_upper,
    cy(A3_upper, upSoft, "C1 S3"),
    cx(A4_neckJ, +18, "C2 S3"),
    A4_neckJ,
    "S3 UpperBout_R→NeckJoint_R"
  ));

  segs.add(new Seg(
    A4_neckJ,
    cx(A4_neckJ, -12, "C1 S4"),
    cx(A5_nut,   +12, "C2 S4"),
    A5_nut,
    "S4 NeckJoint_R→Nut_R"
  ));

  segs.add(new Seg(
    A5_nut,
    cx(A5_nut, -10, "C1 S5"),
    cx(A6_headR, +10, "C2 S5"),
    A6_headR,
    "S5 Nut_R→HeadTop_R"
  ));

  segs.add(new Seg(
    A6_headR,
    cx(A6_headR, -20, "C1 S6"),
    cx(A7_topCtr, +10, "C2 S6"),
    A7_topCtr,
    "S6 HeadTop_R→HeadTop_C"
  ));

  // Left side: A7 -> B6 -> B5 -> B4 -> B3 -> B2 -> B1 -> A0
  segs.add(new Seg(
    A7_topCtr,
    cx(A7_topCtr, -10, "C1 L6"),
    cx(B6_headL,  +20, "C2 L6"),
    B6_headL,
    "L6 HeadTop_C→HeadTop_L"
  ));

  segs.add(new Seg(
    B6_headL,
    cx(B6_headL, -10, "C1 L5"),
    cx(B5_nut,   +10, "C2 L5"),
    B5_nut,
    "L5 HeadTop_L→Nut_L"
  ));

  segs.add(new Seg(
    B5_nut,
    cx(B5_nut,   -12, "C1 L4"),
    cx(B4_neckJ, +12, "C2 L4"),
    B4_neckJ,
    "L4 Nut_L→NeckJoint_L"
  ));

  segs.add(new Seg(
    B4_neckJ,
    cx(B4_neckJ, -18, "C1 L3"),
    cy(B3_upper, dnSoft, "C2 L3"),
    B3_upper,
    "L3 NeckJoint_L→UpperBout_L"
  ));

  segs.add(new Seg(
    B3_upper,
    cy(B3_upper, upSoft, "C1 L2"),
    cxy(B2_waist, -25, +10, "C2 L2"),
    B2_waist,
    "L2 UpperBout_L→Waist_L"
  ));

  segs.add(new Seg(
    B2_waist,
    cxy(B2_waist, -30, upSoft, "C1 L1"),
    cy(B1_lower, dnMed, "C2 L1"),
    B1_lower,
    "L1 Waist_L→LowerBout_L"
  ));

  segs.add(new Seg(
    B1_lower,
    cxy(B1_lower, -outSoft, -20, "C1 L0"),
    cx(A0_center, -outStrong, "C2 L0"),
    A0_center,
    "L0 LowerBout_L→Tail"
  ));

  // ---------------- Draw body path ----------------
  if (showBody) {
    // Fill + Stroke
    noStroke();
    fill(202, 152, 102); // body color
    beginShape();
    vertex(segs.get(0).p0.x, segs.get(0).p0.y);
    for (Seg s : segs) {
      bezierVertex(s.c1.x, s.c1.y, s.c2.x, s.c2.y, s.p3.x, s.p3.y);
    }
    endShape(CLOSE);

    // Edge highlight
    noFill();
    stroke(70, 40, 20);
    strokeWeight(2.2);
    beginShape();
    vertex(segs.get(0).p0.x, segs.get(0).p0.y);
    for (Seg s : segs) {
      bezierVertex(s.c1.x, s.c1.y, s.c2.x, s.c2.y, s.p3.x, s.p3.y);
    }
    endShape(CLOSE);
  }

  // ---------------- Draw neck + headstock guides (simple rectangles) ----------------
  stroke(40, 30, 20, 180);
  fill(60, 50, 40, 140);
  float neckW  = halfNeck * 2;
  float neckH  = (yNeckEnd - yNut);
  rectMode(CENTER);
  rect(0, (yNeckEnd + yNut)/2.0, neckW, neckH, 6);

  // Headstock rectangle
  float headW = halfHead * 2;
  float headH = max(30, (yNut - yHeadTop));
  fill(60, 50, 40, 150);
  stroke(40, 30, 20, 180);
  rect(0, (yHeadTop + yNut)/2.0, headW, headH, 4);

  // ---------------- Guides: anchors, controls, handle lines, labels ----------------
  if (showGuides) {
    // Handle lines
    stroke(60, 120, 220, 150); // control handle lines
    strokeWeight(1.2);
    for (Seg s : segs) {
      line(s.p0.x, s.p0.y, s.c1.x, s.c1.y);
      line(s.p3.x, s.p3.y, s.c2.x, s.c2.y);
    }

    // Anchors
    noStroke();
    fill(220, 40, 40); // anchors red
    for (Seg s : segs) {
      drawPoint(s.p0.x, s.p0.y, s.p0.name);
    }
    // Close-path final anchor
    Seg lastSeg = segs.get(segs.size()-1);
    drawPoint(lastSeg.p3.x, lastSeg.p3.y, lastSeg.p3.name);

    // Control points
    fill(40, 100, 230); // controls blue
    for (Seg s : segs) {
      drawCross(s.c1.x, s.c1.y, s.c1.name);
      drawCross(s.c2.x, s.c2.y, s.c2.name);
    }

    // Segment labels at midpoints
    textAlign(CENTER, BOTTOM);
    fill(20, 20, 20, 180);
    for (Seg s : segs) {
      float mx = (s.p0.x + s.p3.x) * 0.5f;
      float my = (s.p0.y + s.p3.y) * 0.5f;
      text(s.name, mx, my - 8);
    }

    // Centerline
    stroke(0, 60);
    strokeWeight(1);
    line(0, yHeadTop - 30, 0, yTail + 30);
    noStroke();
    fill(0, 120);
    textAlign(LEFT, CENTER);
    text("Centerline x=0", 6, (yHeadTop + yTail)/2.0);
  }
}

// ---------------- Small drawing utilities ----------------

void drawPoint(float x, float y, String label) {
  float r = 4.5;
  ellipse(x, y, r*2, r*2);
  // label
  fill(10, 10, 10, 200);
  textAlign(LEFT, CENTER);
  text(label, x + 8, y);
}

void drawCross(float x, float y, String label) {
  float s = 5.5;
  stroke(40, 100, 230);
  strokeWeight(1.2);
  line(x - s, y - s, x + s, y + s);
  line(x - s, y + s, x + s, y - s);
  noStroke();
  fill(10, 10, 10, 200);
  textAlign(LEFT, CENTER);
  text(label, x + 8, y);
}
