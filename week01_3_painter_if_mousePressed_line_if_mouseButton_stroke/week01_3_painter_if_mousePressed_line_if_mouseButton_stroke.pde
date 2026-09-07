// week01_3_painter_if_mousePressed_line_if_mouseButton_stroke
//小畫家，利用mouse畫圖
void setup(){
  size(500,500);
}
void draw(){
  if(mouseButton==LEFT) stroke(255,0,0);
  if(mouseButton==CENTER) stroke(0,255,0);
  if(mouseButton==RIGHT) stroke(0,0,255);
  if(mousePressed)line(mouseX,mouseY,pmouseX,pmouseY);
}
//右鍵find in reference 參考資料可以查詢
