/*
Copyright 2016 Joshua Sideris
https://github.com/JSideris/
Use for whatever you want. But use at own risk.
*/

//A bunch of defaults that were convenient for the Arduino Mega.
int pinVss = 52;
int pinVcc = 50;
int pinVee = 48;
int pinRS = 46;
int pinRW = 44;
int pinEN = 42;
int pinD0 = 40;
int pinD1 = 38;
int pinD2 = 36;
int pinD3 = 34;
int pinD4 = 32;
int pinD5 = 30;
int pinD6 = 28;
int pinD7 = 26;
int pinLEDP = 24;
int pinLEDN = 22;


//Call this before init if you want to change the defaults.
void setPins(int vss, int vcc, int vee, int rs, int rw, int en, int d0, int d1, int d2, int d3, int d4, int d5, int d6, int d7, int ledp, int ledn){
  pinVss = vss;
  pinVcc = vcc;
  pinVee = vee;
  pinRS = rs;
  pinRW = rw;
  pinEN = en;
  pinD0 = d0;
  pinD1 = d1;
  pinD2 = d2;
  pinD3 = d3;
  pinD4 = d4;
  pinD5 = d5;
  pinD6 = d6;
  pinD7 = d7;
  pinLEDP = ledp;
  pinLEDN = ledn;
}

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
  while(strptr[index] != '\0'){
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
  //delay(waittime); //Let the others catch up... (not needed, upon testing).
  digitalWrite(pinEN, 1);
  delay(waittime);
  digitalWrite(pinEN, 0);
  //delay(1); //Prevent spamming (not needed, upon testing).
  
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

