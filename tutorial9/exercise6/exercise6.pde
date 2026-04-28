/*
Use PeasyCam library to add a mouse-drive camera into the scene in question 4.
*/

import shapes3d.utils.*;
import shapes3d.*;
import peasy.*;

PeasyCam cam;
Ellipsoid sun, earth, moon, stars;
ShapeGroup earth_moon;
PImage sunImg, earthImg, moonImg, starsImg;
PGraphics pg;

// Earth's orbital state
float earthOrbitAngle = 0;
float earthOrbitRadius = 267;

void setup() {
  size(1000, 1000, P3D);
  pg = createGraphics(1000, 1000, P3D);
  cam = new PeasyCam(this, pg, 600);
  cam.setMinimumDistance(150);
  cam.setMaximumDistance(1500);
  
  // --- Sun at origin ---
  sun = new Ellipsoid(100, 50, 50);
  sunImg = loadImage("../exercise4/data/sun.jpg");
  sun.texture(sunImg);
  sun.moveTo(0, 0, 0);
  sun.drawMode(Shape3D.TEXTURE);
  
  // --- Earth ---
  earth = new Ellipsoid(50, 50, 50);
  earthImg = loadImage("../exercise4/data/earth.jpg");
  earth.texture(earthImg);
  earth.drawMode(Shape3D.TEXTURE);
  
  // --- Moon ---
  moon = new Ellipsoid(17, 10, 10);
  moonImg = loadImage("../exercise4/data/moon.jpg");
  moon.texture(moonImg);
  moon.moveTo(0, 0, 83);
  moon.drawMode(Shape3D.TEXTURE);
  
  // --- Star background ---
  stars = new Ellipsoid(1333, 50, 50);
  starsImg = loadImage("../exercise4/data/stars.jpg");
  stars.texture(starsImg);
  stars.drawMode(Shape3D.TEXTURE);
  
  // --- Group Earth + Moon ---
  earth_moon = new ShapeGroup();
  earth_moon.addChild(earth);
  earth_moon.addChild(moon);
}

void draw() {
  pg.beginDraw();
  pg.background(0);
  
  // --- Animate ---
  earthOrbitAngle += radians(0.5);
  float ex = cos(earthOrbitAngle) * earthOrbitRadius;
  float ez = sin(earthOrbitAngle) * earthOrbitRadius;
  earth.moveTo(ex, 0, ez);
  moon.moveTo(ex, 0, ez + 83);
  
  earth_moon.rotateBy(0, radians(2.0), 0);
  sun.rotateBy(0, radians(0.2), 0);
  earth.rotateBy(0, radians(3.0), 0);
  stars.rotateBy(0, 0, radians(0.05));
  
  // --- Pass 1: Earth & Moon lit by the Sun ---
  pg.ambientLight(30, 30, 40);
  pg.pointLight(255, 250, 230, 0, 0, 0);
  earth_moon.draw(pg);
  
  // --- Pass 2: Sun, self-illuminated ---
  pg.noLights();
  pg.ambientLight(255, 255, 255);
  sun.draw(pg);
  
  // --- Pass 3: Starfield ---
  pg.noLights();
  pg.ambientLight(200, 200, 200);
  stars.draw(pg);
  
  pg.endDraw();
  
  // Apply PeasyCam transform and blit offscreen buffer to main canvas
  cam.getState().apply(pg);
  image(pg, 0, 0);
}
