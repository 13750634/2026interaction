// week01_4_painter_background_stroke_strokeWeight
//小畫家，利用mouse畫圖
void setup(){
  size(500,500);
  background(255);//白色背景
  strokeWeight(5);
}
void draw(){
  if(mousePressed){
    if(mouseButton==LEFT) stroke(0);//按右鍵畫黑線
    if(mouseButton==RIGHT) stroke(255);//按左鍵白色擦掉
    line(mouseX,mouseY,pmouseX,pmouseY);
  }
}
