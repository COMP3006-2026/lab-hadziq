import peasy.*;

PeasyCam cam;
PImage img;
int[][] rvalues, gvalues, bvalues;
float[][] avgValues;
float angle = 0;
float sphereRadius = 150;
float pulseAmount = 0;

void setup() {
  size(600, 600, P3D);
  // Load your image here
  //img = loadImage("https://processing.org/img/processing-web.png");
  img = loadImage("images.jpg");
  if (img == null) {
    // Create a fallback gradient image
    img = createImage(100, 100, RGB);
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      int x = i % img.width;
      int y = i / img.width;
      img.pixels[i] = color(x * 2.5, y * 2.5, (x + y) * 1.2);
    }
    img.updatePixels();
  }

  img.resize(100, 100);

  rvalues = new int[img.width][img.height];
  gvalues = new int[img.width][img.height];
  bvalues = new int[img.width][img.height];
  avgValues = new float[img.width][img.height];

  img.loadPixels();
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      color c = img.pixels[y * img.width + x];
      rvalues[x][y] = (int) red(c);
      gvalues[x][y] = (int) green(c);
      bvalues[x][y] = (int) blue(c);
      avgValues[x][y] = (rvalues[x][y] + gvalues[x][y] + bvalues[x][y]) / 3.0;
    }
  }

  cam = new PeasyCam(this, 400);
}

void draw() {
  background(0);
  lights();

  angle += 0.005;
  pulseAmount = sin(frameCount * 0.03) * 20;

  float currentRadius = sphereRadius + pulseAmount;

  for (int y = 0; y < img.height; y++) {
    // Map y index to latitude angle: -PI/2 to PI/2
    float lat = map(y, 0, img.height - 1, -HALF_PI, HALF_PI);

    for (int x = 0; x < img.width; x++) {
      // Map x index to longitude angle: -PI to PI
      float lon = map(x, 0, img.width - 1, -PI, PI) + angle;

      float avg = avgValues[x][y];

      // Z-depth offset based on average RGB
      float zOffset;
      if (avg < 127) {
        zOffset = -map(avg, 0, 126, 30, 0);
      } else {
        zOffset = map(avg, 127, 255, 0, 30);
      }

      float r = currentRadius + zOffset;

      // Convert spherical to cartesian coordinates
      float px = r * cos(lat) * cos(lon);
      float py = r * sin(lat);
      float pz = r * cos(lat) * sin(lon);

      // Color with original pixel color and brightness-based alpha
      stroke(rvalues[x][y], gvalues[x][y], bvalues[x][y], map(avg, 0, 255, 100, 255));
      strokeWeight(2);
      point(px, py, pz);
    }
  }
}
