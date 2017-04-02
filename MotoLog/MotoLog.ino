// Librerias
#include <TinyGPS++.h>
#include <SPI.h>
#include <SD.h>
#include <Wire.h>  // Comes with Arduino IDE
#include <LiquidCrystal_I2C.h>
#include <EEPROM.h>
#include <Sim800l.h>

// SIM
Sim800l Sim800l;  //to declare the library
char* text;
char* number="+34622102026";
bool error; //to catch the response of sendSms

// Laptimer
const double latMeta=41.680971, lonMeta=-0.886370;
/* zuera 41.827793, -0.811826
 * cps 41.680971, -0.886370
 * 
 */
// clases
File myFile;
TinyGPSPlus gps;

//LCD
LiquidCrystal_I2C lcd(0x27, 2, 1, 0, 4, 5, 6, 7, 3, POSITIVE);  // Set the LCD I2C address

//SD setup
Sd2Card card;
SdVolume volume;
SdFile root;

// MicroSD
const int chipSelect = 10;


// Acelerometro
const int xPin = 2;
const int yPin = 1;
const int zPin = 0;

int xVal = 0;
int yVal = 0;
int zVal = 0;
int oneg = 0;
/*  x 276 343 414
    y 279 351 418
    z 285 353 423 */
// Logica
boolean movingState=false;
boolean end_ = true;


//EEPROM setup
int address = 0;
byte value;

void setup() {

  // Serials
  Serial.begin(9600); //PC
  Serial1.begin(9600); //GPS
  Sim800l.begin(); 
  // MicroSD
  card.init(SPI_HALF_SPEED, chipSelect);
  SD.begin(chipSelect);  
  volume.init(card); // abrimos la tarjeta sd

  //LCD
  lcd.begin(16,2);   // initialize the lcd for 16 chars 2 lines, turn on backlight
  lcd.backlight();
  lcd.clear();  
  lcd.setCursor(0,0);
  lcd.print("Calibrando...");
  delay(10000);
  

 //Acelerometro
  xVal = analogRead(xPin);
  yVal = analogRead(yPin);
  zVal = analogRead(zPin);
  oneg = yVal - zVal;
  //LCD final
  lcd.clear();
  lcd.setCursor(0,0); 
  lcd.print("MotoStudent");  
  lcd.setCursor(0,1); 
  lcd.print("UNIZAR");  
}


void loop(void) {

  if(end_){
    movingState = checkMoving();
  }

  if (movingState || gps.speed.kmph()>10) { //If the switch is pressed
    if (gps.speed.kmph()<10) {
      movingState = checkMoving();
    }
    if (end_) {              //If we have close the file      
      lcd.clear();
      delay(1000);
      lcd.setCursor(0,0);
      lcd.print("Telemetria on");
      delay(1000);      
      if(EEPROM.read(address)==255){
        EEPROM.write(0 ,address);
      }
      int archivo = (EEPROM.read(address)+1);
      EEPROM.write(archivo ,address);
      
      String nombre =  String(archivo) + ".csv";
      if (SD.exists(nombre)) {
        SD.remove(nombre);
      }
      myFile = SD.open(nombre, FILE_WRITE);
      end_ = false;
      
    }
    while (Serial1.available() > 0) {
      gps.encode(Serial1.read());
      if (gps.location.isUpdated())
      {
        writeGPS();
        writeAcel();
        lapTimer();
      }
    }

  }
  else  {
    
    if (!end_) {
      myFile.close();
      end_ = true;
      lcd.setCursor(0,0);
      lcd.print("Telemetria off");
      delay(1000);
    }
    /*if(analogRead(zPin)>(zVal+15)){
      delay(2000);    
      if(analogRead(zPin)>(zVal+15)){
        damageReport();
      }
    }*/
  }
}


void writeGPS()
{
  myFile.print(gps.location.lat(), 6);
  myFile.print(F(","));
  myFile.print(gps.location.lng(), 6);
  myFile.print(F(","));
}

void writeAcel()
{
  float xRead = (float)(analogRead(xPin) - xVal) / oneg; //Lee los valores analogicos del acelerometro
  float yRead = (float)(analogRead(yPin) - yVal) / oneg;
  float zRead = (float)(analogRead(zPin) - zVal) / oneg;
  zRead = zRead +1;

  myFile.print(xRead);
  myFile.print(",");
  myFile.print(yRead);
  myFile.print(",");
  myFile.print(zRead);
  myFile.print(F(","));
  myFile.print(gps.speed.kmph(), 3);

}

void damageReport()
{
  double latitud = gps.location.lat();
  double longitud = gps.location.lng();
  String _buffer;
  
  lcd.clear();
  lcd.setCursor(0,0); 
  lcd.print("Accidente");
  /*buttonState = digitalRead(buttonPin);
  
  // check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:
  if (buttonState == HIGH) {*/
  text = "Accidente en";
  Serial2.print (F("AT+CMGF=1\r")); //set sms to text mode
  _buffer=Serial2.readString();
  Serial2.print (F("AT+CMGS=\""));  // command to send sms
  Serial2.print (number);
  Serial2.print(F("\"\r"));
  _buffer=Serial2.readString();
  Serial2.print (text);
  Serial2.print ("\r");
  delay(100);  
  _buffer=Serial2.readString();  
  Serial2.print ("Latitud: ");
  Serial2.print (latitud, 6);
  Serial2.print ("\r");
  delay(100);  
  _buffer=Serial2.readString();
  Serial2.print ("Longitud: ");
  Serial2.print (longitud, 6);
  Serial2.print ("\r");
  delay(100);
  Serial2.print((char)26);
  _buffer=Serial2.readString();
  delay(200000);
}
bool checkMoving()
{
   while (Serial1.available() > 0) {
      gps.encode(Serial1.read());
      if(gps.speed.kmph()>10){
        return true;
      }
      else{
        return false;
      }
   }
      
}
void lapTimer()
{
  static unsigned long lastLap = millis();
  static int bestMin=59, bestSec=0;
  static String vueltaActual;
  static String vueltaMejor; 
  fiveSecs(vueltaActual);
  unsigned long distanciaMeta =
  (unsigned long)TinyGPSPlus::distanceBetween(
      gps.location.lat(),
      gps.location.lng(),
      latMeta, 
      lonMeta);
  unsigned long currentLap  = millis()-lastLap;   
  myFile.println(currentLap); 
  if(currentLap > 20000){  
    if(distanciaMeta < 20){
      currentLap=currentLap/1000;
      int segundos = currentLap%60; 
      int minutos = currentLap/60;      
      lastLap = millis();
      if(bestMin*60+bestSec > minutos*60+segundos){        
        bestMin = minutos;
        bestSec = segundos;
      }  
      lcd.setCursor(0,0); 
      vueltaActual = "CL: " +  String(minutos) + ":" +  String(segundos) + "   ";
      lcd.print(vueltaActual);
      lcd.setCursor(0,1); 
      vueltaMejor = "BL: " +  String(bestMin) + ":" +  String(bestSec) + "   ";
      lcd.print(vueltaMejor);        
    }
  }      
}
void fiveSecs(String vuelta)
{
  static unsigned long lastTime = millis();
  long incremento = millis()-lastTime;
  if(incremento > 5000)
  {
    lcd.setCursor(0,0); 
    lcd.print(vuelta);    
  }
}

