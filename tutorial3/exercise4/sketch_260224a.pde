size (640, 640);

for (int x=0; x<width; x++) {
  float n = norm(x, 0.0, float(width));
  float y = 1 - pow(n, 4);
  y = y*width;
  println(y);
  point(x, y);
}
