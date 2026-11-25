PImage img1, img2, img3, img4, imgHole; // img1: 玩家(頭), img2: 炸彈, img3: 變長道具, img4: 加速道具, imgHole: 地洞
PImage[] bodyImages = new PImage[5];    // 存放 5 張身體圖片
PFont myFont;

// 關卡與地洞相關變數
int level = 1;            // 目前關卡（1 = 第一關, 2 = 第二關）
float xHole, yHole;       // 地洞座標
boolean showHole = false; // 場上是否已出現地洞

// 玩家（蛇頭）相關變數
float x, y;               // 玩家中心座標
float vx = 0, vy = 0;     // 玩家移動速度向量
float baseSpeed = 4;      // 原本的基礎速度
float boostSpeed = 7;     // 加速後的速度
float speed = baseSpeed;  // 目前移動速度
int speedEndTime = 0;     // 加速效果結束的時間點（毫秒）
boolean isSpeedBoosted = false; // 目前是否處於加速狀態
float dirX = 1, dirY = 0; // 最後面對的方向
float playerSize = 50;    // 玩家圖片大小 (50x50)

// 貪食蛇身體跟隨相關變數
int bodyLength = 0;       // 目前增加的身體節數（總長度 = bodyLength + 1）
float bodySpacing = 48;   // 每節身體之間的固定像素距離
ArrayList<PVector> pathHistory = new ArrayList<PVector>(); // 記錄玩家移動軌跡

// 炸彈道具變數
float x2, y2;             // 地上炸彈座標
int bombCount = 0;        // 手上炸彈數
boolean showBomb = true;  // 地上是否有炸彈

// 變長道具變數
float x3, y3;             // 變長道具座標

// 加速道具變數
float x4, y4;             // 加速道具座標

// 飛行中的炸彈清單
ArrayList<float[]> flyingBombs = new ArrayList<float[]>();
float bombSpeed = 8;
float blastWidth = 100;   // 炸彈炸出的缺口寬度 100

// 牆壁清單：每段記錄 {中心X, 中心Y, 寬度W, 高度H, wallID}
ArrayList<float[]> walls = new ArrayList<float[]>();
int targetWalls = 5;      // 場上維持 5 堵主牆
int nextWallID = 1;       // 牆壁專屬編號
float wallLength = 100;   // 新牆壁長度 100
float wallThickness = 12; // 牆壁粗細 12 像素

void setup() {
  size(500, 500);
  
  myFont = createFont("Microsoft JhengHei", 24);
  textFont(myFont);
  
  // 1. 載入所有圖片（請確認檔案都在 data 資料夾內，並依實際副檔名修改）
  img1 = loadImage("long.png");     // 一開始的玩家圖片（蛇頭）
  img2 = loadImage("1.jpg");        // 炸彈圖片
  img3 = loadImage("2.jpg");        // 變長道具圖片
  img4 = loadImage("3.png");        // 加速道具圖片
  imgHole = loadImage("hole.jpg");  // 新增：地洞圖片（請替換為你的實際檔名）
  
  // 2. 設定身體節數使用的 5 張圖片
  bodyImages[0] = img1;
  bodyImages[1] = loadImage("long2.png");
  bodyImages[2] = loadImage("long3.jpg");
  bodyImages[3] = loadImage("long4.jpg");
  bodyImages[4] = loadImage("long5.jpg");
  
  x = width / 2;
  y = height / 2;
  pathHistory.add(new PVector(x, y));
  
  // 生成第一關初始的 5 堵隨機牆壁與道具
  for (int i = 0; i < targetWalls; i++) {
    spawnOneWall();
  }
  spawnBomb();
  spawnFood();
  spawnSpeedItem();
}

void draw() {
  background(255);
  imageMode(CENTER);
  rectMode(CENTER);
  
  // --- 檢查 10 秒加速計時器是否到期（跨關卡依然有效） ---
  if (isSpeedBoosted && millis() >= speedEndTime) {
    isSpeedBoosted = false;
    speed = baseSpeed;
    if (vx != 0 || vy != 0) {
      vx = dirX * speed;
      vy = dirY * speed;
    }
  }
  
  int currentGap = max(1, round(bodySpacing / speed));
  
  // ==========================================
  //              第一關邏輯 (level == 1)
  // ==========================================
  if (level == 1) {
    // 1. 繪製所有黑色牆壁
    fill(0);
    noStroke();
    for (int i = 0; i < walls.size(); i++) {
      float[] w = walls.get(i);
      rect(w[0], w[1], w[2], w[3]);
    }
    
    // 2. 玩家移動與牆壁碰撞偵測
    float nextX = x + vx;
    float nextY = y + vy;
    
    if (hitAnyWall(nextX, nextY, playerSize, playerSize)) {
      vx = 0;
      vy = 0;
    } else {
      if (vx != 0 || vy != 0) {
        x = nextX;
        y = nextY;
        pathHistory.add(0, new PVector(x, y));
        
        int maxHistory = (bodyLength + 2) * currentGap;
        while (pathHistory.size() > maxHistory) {
          pathHistory.remove(pathHistory.size() - 1);
        }
      }
    }
    
    // 3. 畫布邊緣檢測：超出畫框回到正中心，長度、速度與地洞重置
    if (x < 0 || x > width || y < 0 || y > height) {
      x = width / 2;
      y = height / 2;
      vx = 0;
      vy = 0;
      bodyLength = 0;
      showHole = false; // 長度歸零，地洞也隨之消失
      isSpeedBoosted = false;
      speed = baseSpeed;
      pathHistory.clear();
      pathHistory.add(new PVector(x, y));
    }
    
    // 4. 炸彈補給邏輯
    if (!showBomb && bombCount < 5) {
      spawnBomb();
      showBomb = true;
    }
    
    // 5. 玩家撿取地上炸彈
    if (showBomb && dist(x, y, x2, y2) < 45) {
      bombCount++;
      if (bombCount < 5) {
        spawnBomb();
      } else {
        showBomb = false;
      }
    }
    
    // 6. 玩家碰到變長道具：長度 +1
    if (dist(x, y, x3, y3) < 45) {
      bodyLength++;
      spawnFood();
      
      // 當總長度達到 20 (bodyLength + 1 >= 20) 時，在場上隨機生成地洞
      if ((bodyLength + 1) >= 20 && !showHole) {
        spawnHole();
        showHole = true;
      }
    }
    
    // 7. 玩家碰到加速道具：加速 10 秒
    if (dist(x, y, x4, y4) < 45) {
      isSpeedBoosted = true;
      speed = boostSpeed;
      speedEndTime = millis() + 10000;
      if (vx != 0 || vy != 0) {
        vx = dirX * speed;
        vy = dirY * speed;
      }
      spawnSpeedItem();
    }
    
    // 8. 繪製第一關的地上道具（炸彈、變長道具、加速道具）
    if (showBomb) {
      image(img2, x2, y2, 50, 50);
    }
    image(img3, x3, y3, 50, 50);
    image(img4, x4, y4, 50, 50);
    
    // 9. 繪製地洞並偵測玩家是否進入地洞
    if (showHole) {
      image(imgHole, xHole, yHole, 65, 65);
      if (dist(x, y, xHole, yHole) < 45) {
        enterLevel2(); // 進入第二關！
      }
    }
    
    // 10. 更新並繪製飛行中的炸彈
    for (int i = flyingBombs.size() - 1; i >= 0; i--) {
      float[] b = flyingBombs.get(i);
      b[0] += b[2];
      b[1] += b[3];
      
      image(img2, b[0], b[1], 40, 40);
      
      int hitWallIndex = getHitWallIndex(b[0], b[1], 40, 40);
      if (hitWallIndex != -1) {
        explodeWall(hitWallIndex, b[0], b[1]);
        flyingBombs.remove(i);
      } else if (b[0] < 0 || b[0] > width || b[1] < 0 || b[1] > height) {
        flyingBombs.remove(i);
      }
    }
    
    // 11. 繪製貪食蛇的「身體部分」
    for (int i = bodyLength; i >= 1; i--) {
      int historyIndex = i * currentGap;
      if (historyIndex < pathHistory.size()) {
        PVector pos = pathHistory.get(historyIndex);
        PImage segmentImg = bodyImages[(i - 1) % bodyImages.length];
        image(segmentImg, pos.x, pos.y, 46, 46); 
      }
    }
    
    // 12. 繪製玩家（蛇頭）與外框
    drawPlayerHead();
    
    // 13. 顯示第一關左上角狀態文字
    fill(0);
    textSize(14);
    String speedText = isSpeedBoosted ? "加速(" + ceil((speedEndTime - millis()) / 1000.0) + "s)" : "正常";
    text("第1關 | 炸彈:" + bombCount + "/5 | 長度:" + (bodyLength + 1) + "/20 | 速度:" + speedText, 12, 28);
    if (showHole) {
      fill(200, 0, 0);
      text("地洞已出現！快進入通往下一關！", 12, 50);
    }
  } 
  // ==========================================
  //              第二關邏輯 (level == 2)
  //   （第一關所有要素皆已移除，僅保留第一關移速）
  // ==========================================
  else if (level == 2) {
    // 玩家在第二關依然可以自由移動（維持第一關帶過來的 speed）
    x += vx;
    y += vy;
    
    // 第二關畫布邊緣重置（保留目前移速）
    if (x < 0 || x > width || y < 0 || y > height) {
      x = width / 2;
      y = height / 2;
      vx = 0;
      vy = 0;
    }
    
    // 繪製玩家（蛇頭）與外框
    drawPlayerHead();
    
    // 顯示第二關提示與當前延續的移速
    fill(0);
    textSize(16);
    String speedText = isSpeedBoosted ? "加速中(" + ceil((speedEndTime - millis()) / 1000.0) + "s) - 數值:" + int(speed) : "正常 - 數值:" + int(speed);
    text("第 2 關（第一關要素已清空）", 15, 30);
    text("延續移速：" + speedText, 15, 55);
  }
}

// 切換至第二關：移除所有第一關要素，僅保留目前移速
void enterLevel2() {
  level = 2;
  
  // 1. 清空第一關所有場上要素與狀態
  walls.clear();         // 移除所有黑色牆壁
  flyingBombs.clear();   // 移除所有飛行中炸彈
  showBomb = false;      // 移除地上炸彈
  showHole = false;      // 移除地洞
  bombCount = 0;         // 清空手上炸彈
  bodyLength = 0;        // 清空第一關增加的身體節數
  pathHistory.clear();   // 清空移動軌跡
  
  // 2. 玩家回到正中心待命
  x = width / 2;
  y = height / 2;
  vx = 0;
  vy = 0;
  
  // 注意：刻意不重置 speed、isSpeedBoosted、speedEndTime，以完整保留第一關的移速！
}

// 繪製玩家蛇頭與外框
void drawPlayerHead() {
  image(img1, x, y, playerSize, playerSize);
  noFill();
  if (isSpeedBoosted) {
    stroke(255, 190, 0); // 加速期間顯示金黃色外框
  } else {
    stroke(255, 40, 40);  // 平時顯示紅色外框
  }
  strokeWeight(4);
  rect(x, y, playerSize + 4, playerSize + 4);
  noStroke();
}

// 隨機生成地洞（避開牆壁與玩家位置）
void spawnHole() {
  int attempts = 0;
  do {
    xHole = random(50, width - 50);
    yHole = random(50, height - 50);
    attempts++;
  } while ((hitAnyWall(xHole, yHole, 75, 75) || dist(xHole, yHole, x, y) < 100) && attempts < 150);
}

void spawnSpeedItem() {
  int attempts = 0;
  do {
    x4 = random(40, width - 40);
    y4 = random(40, height - 40);
    attempts++;
  } while ((hitAnyWall(x4, y4, 60, 60) || dist(x4, y4, x2, y2) < 60 || dist(x4, y4, x3, y3) < 60 || dist(x4, y4, x, y) < 80) && attempts < 100);
}

void spawnFood() {
  int attempts = 0;
  do {
    x3 = random(40, width - 40);
    y3 = random(40, height - 40);
    attempts++;
  } while ((hitAnyWall(x3, y3, 60, 60) || dist(x3, y3, x2, y2) < 60 || dist(x3, y3, x4, y4) < 60 || dist(x3, y3, x, y) < 80) && attempts < 100);
}

void spawnBomb() {
  int attempts = 0;
  do {
    x2 = random(40, width - 40);
    y2 = random(40, height - 40);
    attempts++;
  } while ((hitAnyWall(x2, y2, 60, 60) || dist(x2, y2, x3, y3) < 60 || dist(x2, y2, x4, y4) < 60) && attempts < 100);
}

void explodeWall(int index, float bx, float by) {
  float[] w = walls.get(index);
  float wx = w[0];
  float wy = w[1];
  float ww = w[2];
  float wh = w[3];
  float currentID = w[4];
  
  walls.remove(index);
  float minPieceSize = 15;
  
  if (ww > wh) {
    float wallLeft = wx - ww / 2.0;
    float wallRight = wx + ww / 2.0;
    float holeLeft = bx - blastWidth / 2.0;
    float holeRight = bx + blastWidth / 2.0;
    
    float leftLen = holeLeft - wallLeft;
    if (leftLen > minPieceSize) {
      walls.add(new float[]{ wallLeft + leftLen / 2.0, wy, leftLen, wh, currentID });
    }
    
    float rightLen = wallRight - holeRight;
    if (rightLen > minPieceSize) {
      walls.add(new float[]{ holeRight + rightLen / 2.0, wy, rightLen, wh, currentID });
    }
  } else {
    float wallTop = wy - wh / 2.0;
    float wallBottom = wy + wh / 2.0;
    float holeTop = by - blastWidth / 2.0;
    float holeBottom = by + blastWidth / 2.0;
    
    float topLen = holeTop - wallTop;
    if (topLen > minPieceSize) {
      walls.add(new float[]{ wx, wallTop + topLen / 2.0, ww, topLen, currentID });
    }
    
    float bottomLen = wallBottom - holeBottom;
    if (bottomLen > minPieceSize) {
      walls.add(new float[]{ wx, holeBottom + bottomLen / 2.0, ww, bottomLen, currentID });
    }
  }
  
  boolean hasAnyPartLeft = false;
  for (int i = 0; i < walls.size(); i++) {
    if (walls.get(i)[4] == currentID) {
      hasAnyPartLeft = true;
      break;
    }
  }
  
  if (!hasAnyPartLeft) {
    spawnOneWall();
  }
}

void spawnOneWall() {
  boolean validPosition = false;
  int attempts = 0;
  
  while (!validPosition && attempts < 300) {
    attempts++;
    
    boolean isHorizontal = random(1) > 0.5;
    float w = isHorizontal ? wallLength : wallThickness;
    float h = isHorizontal ? wallThickness : wallLength;
    
    float wx = random(w / 2 + 25, width - w / 2 - 25);
    float wy = random(h / 2 + 25, height - h / 2 - 25);
    
    if (rectOverlap(wx, wy, w + 50, h + 50, width / 2, height / 2, playerSize, playerSize)) continue;
    if (rectOverlap(wx, wy, w + 40, h + 40, x, y, playerSize, playerSize)) continue;
    if (showBomb && rectOverlap(wx, wy, w + 30, h + 30, x2, y2, 50, 50)) continue;
    if (rectOverlap(wx, wy, w + 30, h + 30, x3, y3, 50, 50)) continue;
    if (rectOverlap(wx, wy, w + 30, h + 30, x4, y4, 50, 50)) continue;
    if (showHole && rectOverlap(wx, wy, w + 30, h + 30, xHole, yHole, 65, 65)) continue;
    
    boolean overlapOther = false;
    for (int j = 0; j < walls.size(); j++) {
      float[] other = walls.get(j);
      if (rectOverlap(wx, wy, w + 65, h + 65, other[0], other[1], other[2], other[3])) {
        overlapOther = true;
        break;
      }
    }
    
    if (!overlapOther) {
      walls.add(new float[]{ wx, wy, w, h, nextWallID });
      nextWallID++;
      validPosition = true;
    }
  }
}

boolean hitAnyWall(float cx, float cy, float cw, float ch) {
  return getHitWallIndex(cx, cy, cw, ch) != -1;
}

int getHitWallIndex(float cx, float cy, float cw, float ch) {
  for (int i = 0; i < walls.size(); i++) {
    float[] w = walls.get(i);
    if (rectOverlap(cx, cy, cw, ch, w[0], w[1], w[2], w[3])) {
      return i;
    }
  }
  return -1;
}

boolean rectOverlap(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  return abs(x1 - x2) < (w1 + w2) / 2.0 && abs(y1 - y2) < (h1 + h2) / 2.0;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      vx = 0; vy = -speed;
      dirX = 0; dirY = -1;
    } else if (keyCode == DOWN) {
      vx = 0; vy = speed;
      dirX = 0; dirY = 1;
    } else if (keyCode == LEFT) {
      vx = -speed; vy = 0;
      dirX = -1; dirY = 0;
    } else if (keyCode == RIGHT) {
      vx = speed; vy = 0;
      dirX = 1; dirY = 0;
    }
  }
  
  // 只有在第一關才能丟炸彈（第二關已移除第一關要素）
  if (level == 1 && (key == 'f' || key == 'F') && bombCount > 0) {
    bombCount--;
    float[] newBomb = { x, y, dirX * bombSpeed, dirY * bombSpeed };
    flyingBombs.add(newBomb);
  }
}
