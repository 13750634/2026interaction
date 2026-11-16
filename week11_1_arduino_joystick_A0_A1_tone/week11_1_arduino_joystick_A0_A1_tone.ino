//week11_1_arduino_joystick_A0_A1_tone
//要把joystick 的 A0、A1 接起來，讀資料
void setup(){
}

void loop(){
  int x = analogRead(A0);
  int y = analogRead(A1);
  tone(8,x);
}
