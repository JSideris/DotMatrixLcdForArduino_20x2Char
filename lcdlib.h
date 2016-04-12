/*
  LCDLib.h - Library for controlling an LCD.
  Created by Joshua Sideris, 2011.
*/

#ifndef LCDLibCLASS
#define LCDLibCLASS

#include "WProgram.h"

class LCDLib{
public:
	
	int pinVss;
	int pinVcc;
	int pinVee;
	int pinRS;
	int pinRW;
	int pinEN;
	int pinD0;
	int pinD1;
	int pinD2;
	int pinD3;
	int pinD4;
	int pinD5;
	int pinD6;
	int pinD7;
	int pinLEDP;
	int pinLEDN;

	void setpins();
	void setpins(int pinVss, int pinVcc, int pinVee, int pinRS, int pinRW, int pinEN, int pinD0, int pinD1, int pinD2, int pinD3, int pinD4, int pinD5, int pinD6, int pinD7, int pinLEDP, int pinLEDN);
	
	void initLCD();
	void resetLCD();
	void setcurpos(int newpos);
	void returnHome();
	void sendByte(char data, int waittime);
	void sendChars(String strptr);
	void cmdprep();
	void txtprep();
	private:
};

#endif