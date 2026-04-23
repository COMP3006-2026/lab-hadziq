PImage img;
//PGraphics buffer;
PImage imgRotated;

void setup() {
  size(400, 400);
  img = loadImage("shapes.png");
  
/*  buffer = createGraphics(img.width, img.height);
  buffer.beginDraw();
    buffer.translate(img.width/2, img.height/2);
    buffer.rotate(PI/2.0);
    buffer.image(img, -img.width/2, -img.height/2);
  buffer.endDraw();
  */
  
  imgRotated = createImage(img.width, img.height, RGB);
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      color c = img.get(x, y);
      imgRotated.set(img.height - 1 - y, x, c);
    }
  }
}

void draw() {
  pushMatrix();
    tint(150, 255);
    translate(img.width/2, img.height/2);
    rotate(PI/2.0);
    image(img, -img.width/2, -img.height/2);
  popMatrix();
  
  noTint();
  //copy(buffer, mouseX-40, mouseY-40, 80, 80, mouseX-40, mouseY-40, 80, 80);
  copy(imgRotated, mouseX-40, mouseY-40, 80, 80, mouseX-40, mouseY-40, 80, 80);
}
