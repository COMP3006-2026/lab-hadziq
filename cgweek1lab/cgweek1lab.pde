size(200, 200, P2D);
background(255);
smooth(8);

// Set ellpises and rets to Center mode
ellipseMode(CENTER);
rectMode(CENTER);

// Draw Zoog's body
stroke(0);
fill(150);
rect(100, 100, 20, 100);

// Draw Zoog's head
fill(255);
ellipse(100, 70, 60, 60);

// Draw Zoog's eyes
fill(255, 0, 0);
ellipse(81, 70, 16, 32);
ellipse(119, 70, 16, 32);

// Draw Zoog's leg
stroke(0, 0, 255);
line(90, 150, 80, 160);
line(110, 150, 120, 160);

// Draw the rope curve
stroke(0, 255, 0);
noFill(); // fill(0, 0, 0, 0);
bezier(20, 100, 20, 200, 180, 200, 180, 100);
