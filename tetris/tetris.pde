// grid size
final int cols = 10;
final int rows = 20;
final int cellSize = 30;
int score = 0;  // 
PFont font;     // 

// condition
int[][] grid = new int[cols][rows];
color[][] gridColor;

color[] blockColors = {
  color(0),                  // index 0 (空白)
  color(0, 255, 255),        // I ブロック: 水色
  color(255, 255, 0),        // O ブロック: 黄
  color(128, 0, 128),        // T ブロック: 紫
  color(0, 0, 255),          // J ブロック: 青
  color(255, 165, 0),        // L ブロック: オレンジ
  color(0, 255, 0),          // S ブロック: 緑
  color(255, 0, 0)           // Z ブロック: 赤
};


//drop setting
Tetromino current;
int dropInterval = 500;
int lastDropTime = 0;


void settings(){
  int x = cols * cellSize;
  int y = rows *  cellSize;
  size(x, y);  
}
void setup() {
  font = createFont("Arial", 16);
 gridColor = new color[cols][rows];
  frameRate(60);
  current = new Tetromino();
}

void draw() {
  background(0);
  
  // auto-fall
  if (millis() - lastDropTime > dropInterval) {
    if (!current.move(0, 1)) {
      current.lockToGrid();
      clearLines();
      current = new Tetromino();
      if (!current.isValid()) {
        println("Game Over");
        noLoop();
      }
    }
    lastDropTime = millis();
  }
  
  drawGrid();
  current.show();
    // wtite score
  fill(255);
  textFont(font);
  text("Score: " + score, 10, 20);
}

void keyPressed() {
  if (keyCode == LEFT) current.move(-1, 0);
  else if (keyCode == RIGHT) current.move(1, 0);
  else if (keyCode == DOWN) current.move(0, 1);
  else if (key == 'z' || key == 'Z') current.rotate();
}

//-----------------------------
// drawgrid
void drawGrid() {
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      if (grid[x][y] != 0) {
        fill(gridColor[x][y]);
        stroke(50);
        rect(x * cellSize, y * cellSize, cellSize, cellSize);
        
      }
    }
  }
}

//-----------------------------
// clearlines
void clearLines() {
  int linesCleared = 0;
  
  for (int y = rows - 1; y >= 0; y--) {
    boolean full = true;
    for (int x = 0; x < cols; x++) {
      if (grid[x][y] == 0) {
        full = false;
        break;
      }
    }
    if (full) {
      linesCleared++;
      for (int yy = y; yy > 0; yy--) {
        for (int x = 0; x < cols; x++) {
          grid[x][yy] = grid[x][yy - 1];
        }
      }
      for (int x = 0; x < cols; x++) {
        grid[x][0] = 0;
      }
      y++;  // check
    }
  }
    switch (linesCleared) {
    case 1: score += 100; break;
    case 2: score += 300; break;
    case 3: score += 500; break;
    case 4: score += 800; break;
  }
}




//-----------------------------
// teromino
class Tetromino {
    int type;          // 1~7（種類）
  color blockColor;  // 表示色
  int[][][] shapes = {
    {
      {1, 1, 1, 1}
    },
    {
      {1, 1},
      {1, 1}
    },
    {
      {0, 1, 0},
      {1, 1, 1}
    },
    {
      {1, 1, 0},
      {0, 1, 1}
    },
    {
      {0, 1, 1},
      {1, 1, 0}
    }
  };
  
  int[][] shape;
  int x = 3, y = 0;

  Tetromino() {
    type = int(random(1, 8));
    shape = getShape(type);
    blockColor = blockColors[type];
  }

  void show() {
    fill(blockColor);
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j] != 0) {
          rect((x + j) * cellSize, (y + i) * cellSize, cellSize, cellSize);
        }
      }
    }
  }

  boolean move(int dx, int dy) {
    x += dx;
    y += dy;
    if (!isValid()) {
      x -= dx;
      y -= dy;
      return false;
    }
    return true;
  }

  void rotate() {
    int[][] newShape = new int[shape[0].length][shape.length];
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        newShape[j][shape.length - 1 - i] = shape[i][j];
      }
    }
    int[][] oldShape = shape;
    shape = newShape;
    if (!isValid()) {
      shape = oldShape;
    }
  }

  boolean isValid() {
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j] != 0) {
          int newX = x + j;
          int newY = y + i;
          if (newX < 0 || newX >= cols || newY >= rows) return false;
          if (newY >= 0 && grid[newX][newY] != 0) return false;
        }
      }
    }
    return true;
  }

  void lockToGrid() {
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j] != 0) {
          int gx = x + j;
          int gy = y + i;
          if (gx >= 0 && gx < cols && gy >= 0 && gy < rows) {
            grid[gx][gy] = 1;
            gridColor[gx][gy] = blockColor;
        }
        }
      }
    }
  }
  
  // ブロック形状を取得
  int[][] getShape(int type) {
    if (type == 1) return new int[][]{{1, 1, 1, 1}};
    if (type == 2) return new int[][]{{1, 1}, {1, 1}};
    if (type == 3) return new int[][]{{0, 1, 0}, {1, 1, 1}};
    if (type == 4) return new int[][]{{1, 0, 0}, {1, 1, 1}};
    if (type == 5) return new int[][]{{0, 0, 1}, {1, 1, 1}};
    if (type == 6) return new int[][]{{0, 1, 1}, {1, 1, 0}};
    if (type == 7) return new int[][]{{1, 1, 0}, {0, 1, 1}};
    return new int[][]{{1}}; // fallback
  }
}
