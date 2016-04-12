/*
Copyright 2016 Joshua Sideris
https://github.com/JSideris/
Use for whatever you want. But use at own risk.
*/

//Don't forget to properly set these.
#define pinVss 52
#define pinVcc 50
#define pinVee 48
#define pinRS 46
#define pinRW 44
#define pinEN 42
#define pinD0 40
#define pinD1 38
#define pinD2 36
#define pinD3 34
#define pinD4 32
#define pinD5 30
#define pinD6 28
#define pinD7 26
#define pinLEDP 24
#define pinLEDN 22


//Call this in setup.
void initLCD() {
  //Vss
  pinMode(pinVss, OUTPUT);
  digitalWrite(pinVss, LOW);
  //Vcc
  pinMode(pinVcc, OUTPUT);
  digitalWrite(pinVcc, HIGH);
  //Vee
  pinMode(pinVee, OUTPUT);
  digitalWrite(pinVee, LOW);
  //E
  pinMode(pinEN, OUTPUT);
  digitalWrite(pinEN, LOW);
  //R
  pinMode(pinRS, OUTPUT);
  digitalWrite(pinRS, LOW);
  //RW
  pinMode(pinRW, OUTPUT);
  digitalWrite(pinRW, LOW);
  
  pinMode(pinLEDN, INPUT);           // set pin to input
  digitalWrite(pinLEDN, HIGH);       // turn on pullup resistors

  pinMode(pinLEDP, OUTPUT);           // set pin to input
  digitalWrite(pinLEDP, HIGH);       // turn on pullup resistors

  pinMode(pinD0, OUTPUT);
  pinMode(pinD1, OUTPUT);
  pinMode(pinD2, OUTPUT);
  pinMode(pinD3, OUTPUT);
  pinMode(pinD4, OUTPUT);
  pinMode(pinD5, OUTPUT);
  pinMode(pinD6, OUTPUT);
  pinMode(pinD7, OUTPUT);
  
  resetLCD();
}

//Resets.
void resetLCD(){
  pinMode(pinLEDN, OUTPUT); //Vcc
  digitalWrite(pinLEDN, LOW);
  pinMode(pinLEDP, OUTPUT); //Vcc
  digitalWrite(pinLEDP, HIGH);
  _cmdprep();
  _sendByte(56, 100);
  _sendByte(1, 100);
  _sendByte(12, 100);
}

void setcurpos(int newpos){
  _cmdprep();
  _sendByte(128 + (newpos % 128), 1);
}

void returnHome(){
  _cmdprep();
  _sendByte(2, 1);
}

//Write text at the current cursor position.
void sendChars(String strptr){
  int index = 0;
  _txtprep();
  while(strptr[index] != '\0' || index == 40){
    _sendByte(strptr[index++], 1);
  }
}

//Send one byte of data, which could be a little cleaner here but since the LCD can be plugged into arbitrary pins, 
//they need to be set one at a time. Called internally.
void _sendByte(char data, int waittime){
  digitalWrite(pinD0, (data) % 2);
  digitalWrite(pinD1, (data >> 1) % 2);
  digitalWrite(pinD2, (data >> 2) % 2);
  digitalWrite(pinD3, (data >> 3) % 2);
  digitalWrite(pinD4, (data >> 4) % 2);
  digitalWrite(pinD5, (data >> 5) % 2);
  digitalWrite(pinD6, (data >> 6) % 2);
  digitalWrite(pinD7, (data >> 7) % 2);
  //delay(waittime); //Let the others catch up...
  digitalWrite(pinEN, 1);
  delay(waittime);
  digitalWrite(pinEN, 0);
  //delay(1);
  
}

//Preps the LCD for command input. Called internally.
void _cmdprep(){
  digitalWrite(pinRS, 0);
  digitalWrite(pinRW, 0);
}

//Preps the LCD for text input. Called internally.
void _txtprep(){
  digitalWrite(pinRS, 1);
  digitalWrite(pinRW, 0);
}

