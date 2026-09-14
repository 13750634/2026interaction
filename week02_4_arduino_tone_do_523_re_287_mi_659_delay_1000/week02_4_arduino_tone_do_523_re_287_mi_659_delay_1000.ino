//week02_4_arduino_tone_do_523_re_287_mi_659_delay_1000
void setup() {
  // put your setup code here, to run once:
  pinMode(8,OUTPUT);
  
  //上面 setup() 只會執行一次
  tone(8,523,1000);//do
  delay(1000);
  tone(8,587,1000);//re
  delay(1000);
  tone(8,659,1000);//mi
  delay(1000);
}

void loop() {
  // put your main code here, to run repeatedly:
  //下面會一直做迴圈
}
