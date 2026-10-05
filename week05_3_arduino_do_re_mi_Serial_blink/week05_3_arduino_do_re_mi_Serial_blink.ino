//week05_3_arduino_do_re_mi_Serial_blink
// 修改自 week05_2_arduino_do_re_mi_Serial_tone_noTone
//會有對應的燈號
void setup() {
  pinMode(8,OUTPUT);// buzzer 8聲音
  pinMode(10,OUTPUT);
  pinMode(11,OUTPUT);
  pinMode(12,OUTPUT);
  pinMode(13,OUTPUT);
  
  Serial.begin(9600); // USB Serial 開始傳輸，速度 9600 bps
  tone(8, 523, 100);delay(200); // Do
  tone(8, 587, 100); delay(200); // Re
  tone(8, 659, 100); delay(200);// Mi
  tone(8, 587, 100); delay(200); // Re
  tone(8, 523, 100); delay(200);// Do
}

char c = '0';//在外面宣告變數，0:沒有聲音，1:Do 2:Re 3:Mi
void loop() {
  if (Serial.available()){ // 如果 USB Serial 有收到資料
    c = Serial.read(); // 就讀進來
  }
  for(int i=10;i<=13;i++) digitalWrite(i,LOW);
  if(c>='0' && c<='3') digitalWrite(c-'0'+10,HIGH);
  
  if (c=='0') noTone(8); // 沒有聲音
  if (c=='1') tone(8, 523); // Do一直發聲
  if (c=='2') tone(8, 587); // Re一直發聲 
  if (c=='3') tone(8, 659); // Mi一直發聲
}
