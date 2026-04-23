// Shape3D class — handles both spheres and boxes

class Shape3D {
  float x, y, z;
  float size;
  int type; // 0 = sphere, 1 = box
  
  Shape3D(float x, float y, float z, float size, int type) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.size = size;
    this.type = type;
  }
  
  void render() {
    pushMatrix();
    translate(x, y, z);
    
    if (type == 0) {
      sphere(size / 2);
    } else {
      box(size);
    }
    
    popMatrix();
  }
}
