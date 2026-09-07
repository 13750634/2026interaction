// week01_6_mousewheel_strokeWeight_circleSize_ellipse
//整合week01-4 and week01-5
float circleSize = 5;

void setup(){
  size(500,500);
  background(255);
}
void draw(){
  strokeWeight(circleSize);
  if(mousePressed){
    if(mouseButton==LEFT) stroke(0);//按右鍵畫黑線
    if(mouseButton==RIGHT) stroke(255);//按左鍵白色擦掉
    line(mouseX,mouseY,pmouseX,pmouseY);
   }
   noStroke();//不要畫外框
   rect(0,0,100,100);
   stroke(0);//黑色的線
   strokeWeight(1);//左上角小圈的框
   ellipse(50,50,circleSize,circleSize);//劃出圈
}

void mouseWheel(MouseEvent e) {
  circleSize = circleSize - e.getCount(); 
}
