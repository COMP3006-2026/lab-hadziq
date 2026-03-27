/*
Draw multiple shapes on a sketch that includes at least 
2 points, 
1 line, 
1 rectangle, 
1 circle, 
1 ellipse, 
1 triangle 
and 1 quadrilateral.
*/

size(640, 640);
strokeWeight(10);
ellipse(320, 320, 600, 300);
point(160, 320); point(480, 320);
line(180, 320, 460, 320);
rect(10, 10, 100, 100);
circle(580, 60, 100);
triangle(320, 360, 160, 480, 480, 480);
quad(160, 500, 480, 500, 400, 600, 100, 600);
