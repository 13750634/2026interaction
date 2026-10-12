//week06_1_arduino_pin_2_button_INOUT_PULLUP
void setup(){
  pinMode(2,INPUT_PULLUP);//預設 pin 2 是 button
  pinMode(8,OUTPUT);//預設 pin 8 是 button 喇叭
  tone(8,523,100);//啟動時，發一下聲音，代表程式沒問題
}//沒發聲就是程式出錯

void loop(){
  if (digitalRead(2) == LOW  ){
    tone(8,523,100);//0.1秒
    delay(100);  //等一下(讓聲音夠長)
  }
}
