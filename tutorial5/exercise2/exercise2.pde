/*
Create a typing program to creating “three-line” text editor. 
If the length of the input string is longer than the line, 
it will be automatically move to the next line.
*/

char notepad [][] = new char[3][50];
int row = 0;
int column = 0;

void setup() {
  size(640, 480);
  textSize(20);
  fill(0);
}

void draw() {
  background(255);
  switch (row) {
     case 2:
       text(new String(notepad[0], 0, 50), 20, 20);  // Draw first line
       text(new String(notepad[1], 0, 50), 20, 50);  // Draw second line
       text(new String(notepad[2], 0, column), 20, 80);  // Draw third line
       break;
     case 1:
       text(new String(notepad[0], 0, 50), 20, 20);  // Draw first line
       text(new String(notepad[1], 0, column), 20, 50);  // Draw second line
       break;
     default:
       text(new String(notepad[0], 0, column), 20, 20);  // Draw first line
  }
}

void keyPressed() {
  notepad[row][column] = key;
  column++;
  if (column == 50) {
     if (row == 2) exit();  // This is to avoid memory pointer error on the array
     else {
       row++;
       column = 0;
     }
  }l
}
