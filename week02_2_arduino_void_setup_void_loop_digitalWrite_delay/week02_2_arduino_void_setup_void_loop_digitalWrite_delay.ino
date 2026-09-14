//week02_2_arduino_void_setup_void_loop_digitalWrite_delay
void setup() {
  // put your setup code here, to run once:
  pinMode(8,OUTPUT);//第8鍵，發出Buzzer 聲音
}

//按勾勾(ctrl-r編譯程式)，指向右的箭頭(ctrl-u上傳電路板)
void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(8,HIGH);//發高電位
  delay(1000);//間隔1秒
  digitalWrite(8,LOW);//發低電位
  delay(1000);//間隔1秒，
}
