// Shape3D class — handles both spheres and boxes

class Shape3D {
  float x, y, z;
  float size;
  int type; // 0 = sphere, 1 = box
  color col;
  boolean useFill;
  boolean useStroke;
  
  Shape3D(float x, float y, float z, float size, int type,
          color col, boolean useFill, boolean useStroke) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.size = size;
    this.type = type;
    this.col = col;
    this.useFill = useFill;
    this.useStroke = useStroke;
  }
  
  void render() {
    pushMatrix();
    translate(x, y, z);
    
    // Apply fill attribute
    if (useFill) {
      fill(col);
    } else {
      noFill();
    }
    
    // Apply stroke attribute
    if (useStroke) {
      stroke(col);
      strokeWeight(1.2);
    } else {
      noStroke();
    }
    
    if (type == 0) {
      sphere(size / 2);
    } else {
      box(size);
    }
    
    popMatrix();
  }
}
