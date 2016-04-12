/*
Copyright 2011 Joshua Sideris
https://github.com/JSideris/
Use for whatever you want. But use at own risk.
*/

#include "Arduino.h"
#include "lcdlib.h"

//A bunch of defaults that were convenient for the Arduino Mega.
void LCDLib::setpins(){
	setpins(52, 50, 48, 46, 44, 42, 40, 38, 36, 34, 32, 30, 28, 26, 24, 22);
}

//Call this before init if you want to change the defaults.
void LCDLib::setpins(int pinVss, int pinVcc, int pinVee, int pinRS, int pinRW, int pinEN, int pinD0, int pinD1, int pinD2, int pinD3, int pinD4, int pinD5, int pinD6, int pinD7, int pinLEDP, int pinLEDN){
	this->pinVss = pinVss;
	this->pinVcc = pinVcc;
	this->pinVee = pinVee;
	this->pinRS = pinRS;
	this->pinRW = pinRW;
	this->pinEN = pinEN;
	this->pinD0 = pinD0;
	this->pinD1 = pinD1;
	this->pinD2 = pinD2;
	this->pinD3 = pinD3;
	this->pinD4 = pinD4;
	this->pinD5 = pinD5;
	this->pinD6 = pinD6;
	this->pinD7 = pinD7;
	this->pinLEDP = pinLEDP;
	this->pinLEDN = pinLEDN;
}

//Call this in setup.
void LCDLib::initLCD() {
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

void LCDLib::resetLCD(){
  
  pinMode(pinLEDN, OUTPUT); //Vcc
  digitalWrite(pinLEDN, LOW);
  pinMode(pinLEDP, OUTPUT); //Vcc
  digitalWrite(pinLEDP, HIGH);
  _cmdprep();
  _sendByte(56, 100);
  _sendByte(1, 100);
  _sendByte(12, 100);
}

void LCDLib::setcurpos(int newpos){
  _cmdprep();
  _sendByte(128 + (newpos % 128), 1);
}

void LCDLib::returnHome(){
  _cmdprep();
  _sendByte(2, 1);
}

void LCDLib::printInt(int prInt){
	sendChars(String(prInt, DEC));
}

void LCDLib::sendChars(String strptr){
  int index = 0;
  txtprep();
  while(strptr[index] != '\0'){
    _sendByte(strptr[index++], 1);
  }
}

//Send one byte of data, which could be a little cleaner here but since the LCD can be plugged into arbitrary pins, 
//they need to be set one at a time. Called internally.
void LCDLib::_sendByte(char data, int waittime){
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
void LCDLib::_cmdprep(){
  digitalWrite(pinRS, 0);
  digitalWrite(pinRW, 0);
}

//Preps the LCD for text input. Called internally.
void LCDLib::txtprep(){
  digitalWrite(pinRS, 1);
  digitalWrite(pinRW, 0);
}
