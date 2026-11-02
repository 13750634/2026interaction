//week09_1_arduino_ai_makerUNO_PCM_D8
//目的MakerUNO() 發出多元的聲音
// Q1: MakerUNO 本身可以用 pin 8 的 buzzer 利用 tone() 來發出單調的聲音。
// 有辦法發出比較精彩的聲音嗎? ex. wav or mp3
// Q2: 請幫我找 PCM 相關的 libraries 我想試試看

// Maker UNO: turn ON the onboard BUZZER slide switch.
// Board selection: Arduino Uno / ATmega328P / 16 MHz.
// This sketch uses the local modified PCM.cpp, NOT the original D11 library.
#include "PCM.h"
#include "sounddata.h"

void setup() {
  startPlayback(sounddata_data, sounddata_length);
}

void loop() {
  // One-shot sample plays for 1 second. Press RESET to play again.
}
