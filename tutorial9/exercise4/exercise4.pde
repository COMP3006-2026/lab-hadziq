/*
Use the external library shape3D and the example in lecture note 10 
to construct a complex scene with the Sun, the Earth and the Moon. 
The Sun is rotating by itself, 
while the Earth is orbiting around 
the Sun and the Moon is also orbiting around the Earth. 
Add texture to the Sun, the Earth and the Moon.
*/

import shapes3d.utils.*;
import shapes3d.*;
import peasy.*;

PeasyCam cam;
Ellipsoid sun, earth, moon, stars;
ShapeGroup earth_moon;            // Earth + Moon — Moon orbits Earth

PImage sunImg, earthImg, moonImg, starsImg;
PGraphics pg;

// Earth's orbital state (we compute Earth's position manually)
float earthOrbitAngle = 0;
float earthOrbitRadius = 800;

void setup() {
  size(1000, 1000, P3D);
  pg = createGraphics(1000, 1000, P3D);
  cam = new PeasyCam(this, pg, 1600);
  cam.setMinimumDistance(400);
  cam.setMaximumDistance(4000);
  
  // --- Sun at origin ---
  sun = new Ellipsoid(300, 50, 50);
  sunImg = loadImage("data/sun.jpg");
  sun.texture(sunImg);
  sun.moveTo(0, 0, 0);
  sun.drawMode(Shape3D.TEXTURE);
  
  // --- Earth (position will be updated each frame) ---
  earth = new Ellipsoid(150, 50, 50);
  earthImg = loadImage("data/earth.jpg");
  earth.texture(earthImg);
  earth.drawMode(Shape3D.TEXTURE);
  
  // --- Moon, offset from the Earth ---
  // Position is relative to the earth_moon group's origin (= Earth's center)
  moon = new Ellipsoid(50, 30, 30);
  moonImg = loadImage("data/moon.jpg");
  moon.texture(moonImg);
  moon.moveTo(0, 0, 250);
  moon.drawMode(Shape3D.TEXTURE);
  
  // --- Star background ---
  stars = new Ellipsoid(4000, 50, 50);
  starsImg = loadImage("data/stars01.jpg");
  stars.texture(starsImg);
  stars.drawMode(Shape3D.TEXTURE);
  
  // --- Group Earth + Moon so Moon orbits Earth ---
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
  moon.moveTo(ex, 0, ez + 250);
  
  // Moon orbits Earth. Because rotating the group also rotates the Moon
  // in world space, and the Moon is NOT given an independent spin, the Moon
  // is tidally locked — same face points toward Earth every frame.
  earth_moon.rotateBy(0, radians(2.0), 0);
  
  // Earth spins freely on its own axis (not locked to anything)
  sun.rotateBy(0, radians(0.2), 0);
  earth.rotateBy(0, radians(3.0), 0);
  // moon.rotateBy(...)  <-- REMOVED: this would break tidal locking
  
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
  
  cam.getState().apply(pg);
  image(pg, 0, 0);
}
