size(100, 100);
background(255);
textSize(20);
textAlign(LEFT, TOP);

int first_color = 255;
int spacex = 20;
int spacey = 20;
for (int i =0; i<5; i++) {
  for(int j =0; j<5;j++){
         fill(first_color);
         text("#", j*spacex, i*spacey);
         first_color-=5;
  }
}
