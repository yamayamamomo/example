int cols = 12;    
int rows = 22;    
float spacing = 30;

void setup() {
  size(400, 700);
  background(255);
  rectMode(CENTER);
  noFill();
  stroke(0);

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float xpos = 30 + x * spacing;
      float ypos = 30 + y * spacing;

      pushMatrix();
      translate(xpos, ypos);

      // Increase the strength of the shimmer by row"
      float maxAngle = radians(y * 2);
      float angle = random(-maxAngle, maxAngle);
      rotate(angle);

      float maxOffset = y * 1.3;
      float xOffset = random(-maxOffset, maxOffset);
      float yOffset = random(-maxOffset, maxOffset);
      translate(xOffset, yOffset);

      rect(0, 0, 30, 30);
      popMatrix();
    }
  }
}
