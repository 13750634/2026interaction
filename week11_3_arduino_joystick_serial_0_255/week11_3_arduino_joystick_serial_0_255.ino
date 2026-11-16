// week11_3_arduino_joystick_serial_0_255
// 將要跟 Processing 互溝通
void setup() {
  Serial.begin(9600);
  pinMode(2, INPUT_PULLUP);
}

int myAnalogRead(int pin) {
  // 利用 map() 函數， 把 0..1023 對應 0..255
  return map( analogRead(pin), 0, 1023, 0, 255);
}

void loop() {
  delay(30);
  Serial.write( myAnalogRead(A0) );
  Serial.write( myAnalogRead(A1) );
  if (digitalRead(2)==LOW) Serial.println("D"); // Down 按
  else Serial.print("U"); // Up 沒按
}
