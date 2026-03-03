// ============================================
//  GAMEPAD DIAGNOSTIC TOOL
//  Run this first to identify your controller
//  axes and button names
// ============================================

import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
ControlDevice gamepad;

int selectedDeviceIndex = 0;
boolean deviceFound = false;

void setup() {
  size(800, 600);
  textFont(createFont("Courier New", 13));

  control = ControlIO.getInstance(this);
  int total = control.getNumberOfDevices();

  println("===========================================");
  println("  DEVICES FOUND: " + total);
  println("===========================================");

  for (int i = 0; i < total; i++) {
    try {
      ControlDevice d = control.getDevice(i);
      println("[" + i + "] " + d.getName()
        + " | Sliders: " + d.getNumberOfSliders()
        + " | Buttons: " + d.getNumberOfButtons());
    }
    catch (Exception e) {
      println("[" + i + "] FAILED: " + e.getMessage());
    }
  }

  // Auto-pick the device with the most sliders (most likely your gamepad)
  int maxSliders = 0;
  for (int i = 0; i < total; i++) {
    try {
      ControlDevice d = control.getDevice(i);
      if (d.getNumberOfSliders() > maxSliders) {
        maxSliders = d.getNumberOfSliders();
        selectedDeviceIndex = i;
      }
    }
    catch (Exception e) {}
  }

  try {
    gamepad = control.getDevice(selectedDeviceIndex);
    deviceFound = true;
    println("\n>>> Auto-selected: [" + selectedDeviceIndex + "] " + gamepad.getName());
    println("===========================================");
    println("  SLIDERS (Analog Axes)");
    println("===========================================");
    for (int i = 0; i < gamepad.getNumberOfSliders(); i++) {
      println("  Slider[" + i + "] name: " + gamepad.getSlider(i).getName());
    }
    println("===========================================");
    println("  BUTTONS");
    println("===========================================");
    for (int i = 0; i < gamepad.getNumberOfButtons(); i++) {
      println("  Button[" + i + "] name: " + gamepad.getButton(i).getName());
    }
    println("===========================================");
  }
  catch (Exception e) {
    println("Could not open device: " + e.getMessage());
  }
}

void draw() {
  background(20, 20, 30);

  // ── Title ──
  fill(200, 230, 255);
  textSize(16);
  textAlign(CENTER);
  text("GAMEPAD DIAGNOSTIC", width/2, 30);

  textSize(12);
  fill(120, 180, 255);
  text("Move sticks, press buttons — watch the live values below", width/2, 52);

  if (!deviceFound) {
    fill(255, 100, 100);
    textAlign(CENTER);
    text("No gamepad detected. Check connection and restart sketch.", width/2, height/2);
    return;
  }

  // ── Device name ──
  fill(255, 220, 80);
  textAlign(LEFT);
  textSize(13);
  text("Device: " + gamepad.getName(), 20, 85);

  // ── Sliders / Analog Axes ──
  fill(200, 230, 255);
  textSize(13);
  text("── ANALOG AXES (Sliders) ──", 20, 115);

  int numSliders = gamepad.getNumberOfSliders();
  for (int i = 0; i < numSliders; i++) {
    ControlSlider s = gamepad.getSlider(i);
    float val = s.getValue();

    // Label
    fill(160, 200, 255);
    text(String.format("  [%d] %-6s : %+.3f", i, s.getName(), val), 20, 140 + i * 28);

    // Bar background
    noStroke();
    fill(50, 50, 70);
    rect(200, 127 + i * 28, 300, 16, 4);

    // Bar fill (center = 0, extends left or right)
    float barCenter = 200 + 150;
    float barLen    = val * 150;
    fill(val > 0.12 || val < -0.12 ? color(80, 200, 120) : color(80, 120, 180));
    rect(barCenter, 127 + i * 28, barLen, 16, 4);

    // Center marker
    stroke(255, 255, 255, 80);
    strokeWeight(1);
    line(barCenter, 125 + i * 28, barCenter, 145 + i * 28);
    noStroke();
  }

  // ── Buttons ──
  int buttonTop = 145 + numSliders * 28 + 20;
  fill(200, 230, 255);
  textSize(13);
  text("── BUTTONS ──", 20, buttonTop);

  int numButtons = gamepad.getNumberOfButtons();
  int cols       = 6;
  int btnSize    = 52;
  int btnPad     = 10;

  for (int i = 0; i < numButtons; i++) {
    ControlButton b = gamepad.getButton(i);
    boolean pressed = b.pressed();

    int col = i % cols;
    int row = i / cols;
    int bx  = 20  + col * (btnSize + btnPad);
    int by  = buttonTop + 18 + row * (btnSize + btnPad);

    // Button box
    noStroke();
    fill(pressed ? color(80, 220, 120) : color(50, 50, 70));
    rect(bx, by, btnSize, btnSize, 6);

    // Button label
    fill(pressed ? color(20, 20, 20) : color(160, 200, 255));
    textSize(10);
    textAlign(CENTER, CENTER);
    text(b.getName(), bx + btnSize/2, by + btnSize/2 - 6);
    textSize(9);
    fill(pressed ? color(20, 40, 20) : color(100, 140, 180));
    text(pressed ? "PRESSED" : "---", bx + btnSize/2, by + btnSize/2 + 8);
  }

  // ── Footer hint ──
  textAlign(LEFT);
  fill(100, 140, 180);
  textSize(11);
  text("Press 1-9 keys to switch device index if wrong controller is shown", 20, height - 15);
}

// Switch device manually with number keys
void keyPressed() {
  if (key >= '0' && key <= '9') {
    int idx = key - '0';
    if (idx < control.getNumberOfDevices()) {
      try {
        gamepad = control.getDevice(idx);
        selectedDeviceIndex = idx;
        println("Switched to device [" + idx + "]: " + gamepad.getName());
      }
      catch (Exception e) {
        println("Could not switch: " + e.getMessage());
      }
    }
  }
}
