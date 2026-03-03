// Gamepad Circle Controller - Robust Version
// Requires: GameControlPlus library

import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
ControlDevice gamepad;
ControlSlider axisLX, axisLY;

float circleX, circleY;
float circleSize = 60;
float speed = 4;

ArrayList<float[]> trail = new ArrayList<float[]>();
int maxTrail = 30;

void setup() {
  size(800, 600);
  circleX = width / 2;
  circleY = height / 2;

  control = ControlIO.getInstance(this);

  // Try each available device until we find one with analog axes
  int numDevices = control.getNumberOfDevices();
  println("Total devices found: " + numDevices);

  for (int i = 0; i < numDevices; i++) {
    try {
      ControlDevice dev = control.getDevice(i);
      println("Device " + i + ": " + dev.getName());

      // Look for a device that has at least 2 sliders (analog axes)
      if (dev.getNumberOfSliders() >= 2) {
        gamepad = dev;
        axisLX = gamepad.getSlider(0);
        axisLY = gamepad.getSlider(1);
        println(">>> Using device: " + gamepad.getName());
        println("    Axis 0: " + axisLX.getName());
        println("    Axis 1: " + axisLY.getName());
        break;
      }
    }
    catch (Exception e) {
      println("Skipping device " + i + ": " + e.getMessage());
    }
  }

  if (gamepad == null) {
    println("No suitable gamepad found — keyboard fallback active (Arrow keys / WASD).");
  }

  smooth();
}

void draw() {
  background(20, 20, 30);
  drawGrid();

  float dx = 0, dy = 0;

  // Gamepad input
  if (gamepad != null && axisLX != null && axisLY != null) {
    float lx = axisLX.getValue();
    float ly = axisLY.getValue();
    float deadZone = 0.12;
    if (abs(lx) > deadZone) dx = lx * speed;
    if (abs(ly) > deadZone) dy = ly * speed;
  }

  // Keyboard fallback
  if (keyPressed) {
    if (keyCode == LEFT  || key == 'a' || key == 'A') dx = -speed;
    if (keyCode == RIGHT || key == 'd' || key == 'D') dx =  speed;
    if (keyCode == UP    || key == 'w' || key == 'W') dy = -speed;
    if (keyCode == DOWN  || key == 's' || key == 'S') dy =  speed;
  }

  // Update position with edge wrapping
  circleX = (circleX + dx + width  + circleSize) % (width  + circleSize);
  circleY = (circleY + dy + height + circleSize) % (height + circleSize);

  // Trail
  trail.add(new float[]{circleX, circleY});
  if (trail.size() > maxTrail) trail.remove(0);

  for (int i = 0; i < trail.size(); i++) {
    float alpha = map(i, 0, trail.size(), 0, 120);
    float sz    = map(i, 0, trail.size(), 10, circleSize * 0.8);
    noStroke();
    fill(80, 160, 255, alpha);
    ellipse(trail.get(i)[0], trail.get(i)[1], sz, sz);
  }

  drawCircle(circleX, circleY);
  drawHUD(dx, dy);
}

void drawCircle(float x, float y) {
  for (int i = 4; i > 0; i--) {
    noStroke();
    fill(80, 160, 255, 30);
    ellipse(x, y, circleSize + i * 12, circleSize + i * 12);
  }
  fill(80, 160, 255);
  stroke(200, 230, 255);
  strokeWeight(2);
  ellipse(x, y, circleSize, circleSize);
  noStroke();
  fill(255, 255, 255, 80);
  ellipse(x - circleSize * 0.15, y - circleSize * 0.2, circleSize * 0.35, circleSize * 0.25);
}

void drawGrid() {
  stroke(255, 255, 255, 20);
  strokeWeight(1);
  int spacing = 50;
  for (int x = 0; x < width;  x += spacing) line(x, 0, x, height);
  for (int y = 0; y < height; y += spacing) line(0, y, width, y);
  stroke(255, 255, 255, 60);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
}

void drawHUD(float dx, float dy) {
  noStroke();
  fill(0, 0, 0, 140);
  rect(10, 10, 260, 110, 8);
  fill(200, 230, 255);
  textSize(13);
  textAlign(LEFT, TOP);
  String deviceName = (gamepad != null) ? gamepad.getName() : "None";
  if (deviceName.length() > 22) deviceName = deviceName.substring(0, 22) + "…";
  text("Gamepad : " + deviceName,              20, 20);
  text("X : " + nf(circleX,1,1) + "   Y : " + nf(circleY,1,1), 20, 42);
  text("dX: " + nf(dx,1,2)      + "   dY: " + nf(dy,1,2),       20, 64);
  fill(120, 180, 255);
  textSize(11);
  text((gamepad != null ? "Left Stick" : "Arrow Keys / WASD") + "  to move", 20, 90);
}
