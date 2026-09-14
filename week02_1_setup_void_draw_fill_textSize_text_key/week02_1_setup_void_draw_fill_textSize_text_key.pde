//week02_1_setup_void_draw_fill_textSize_text_key
//鍵盤的操作
void setup(){
  size(500,500);//設定畫布大小
}
void draw(){
   if(mousePressed) background(#F58A8A); //滑鼠判斷 
   else background(#D6F074);
   fill(0,0,255);
   textSize(80);
   text("key:"+key,200,300);
}
