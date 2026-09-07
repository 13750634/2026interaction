// week01_5_gooogle_genini_mouse_wheel_void_mousewheel_MouseEvent_getCount
float circleSize = 50; // 初始圓形大小

void setup() {
  size(400, 400);
}

void draw() {
  background(220);
  
  // 繪製圓形
  ellipse(width/2, height/2, circleSize, circleSize);
}

// 捕捉滑鼠滾輪事件
void mouseWheel(MouseEvent event) {
  float e = event.getCount(); // 取得滾輪捲動值
  
  // event.getCount() 如果是正數(1)代表往下滾，負數(-1)代表往上滾
  circleSize -= e * 5; 
  
  // 限制圓形大小，避免變成負數或太大
  circleSize = constrain(circleSize, 10, 300);
}
