// Code for the TCC White Roofs project.
// Collects temperatures from DS18B20 sensors. The sensors are arranged in
// two main daisy chains: one with 8 sensors and one with 9. There is also
// one extra sensor also.
// Designed to relay data as CSV over USB Serial to a Pi.
//
// Designed by Febrio Lunardo and Ashley Gillman
//
// Useful reference:
// https://arduino-info.wikispaces.com/Brick-Temperature-DS18B20

#include <OneWire.h>
#include <DallasTemperature.h>

#define DEBUG 1 // Useful for gaining sensor addresses, set to 1.

#define BUS_0 2 // Indoor
#define BUS_1 3 // Green Roofs
#define BUS_2 4 // Brown Inner + Outdoor
#define PRECISION 9

OneWire wire0(BUS_0);
OneWire wire1(BUS_1);
OneWire wire2(BUS_2);
DallasTemperature dallas0(&wire0);
DallasTemperature dallas1(&wire1);
DallasTemperature dallas2(&wire2);

#define N_BUS_0 1
#define N_BUS_1 9
#define N_BUS_2 8
DeviceAddress* bus0Devs[N_BUS_0];
DeviceAddress* bus1Devs[N_BUS_1];
DeviceAddress* bus2Devs[N_BUS_2];

// Indoor
DeviceAddress d0_0 = { 0x28, 0x55, 0xA5, 0x82, 0x04, 0x00, 0x00, 0x7A };

// Roofs - Green
DeviceAddress d1_0 = { 0x28, 0x49, 0x82, 0x82, 0x04, 0x00, 0x00, 0xF5 }; // Note: none of these are yet correct.
DeviceAddress d1_1 = { 0x28, 0x77, 0xBB, 0x82, 0x04, 0x00, 0x00, 0x7C };
DeviceAddress d1_2 = { 0x28, 0x6A, 0x8B, 0x82, 0x04, 0x00, 0x00, 0xE9 };
DeviceAddress d1_3 = { 0x28, 0x09, 0x00, 0x82, 0x04, 0x00, 0x00, 0xC8 };
DeviceAddress d1_4 = { 0x28, 0xA9, 0x6F, 0x82, 0x04, 0x00, 0x00, 0xEA };
DeviceAddress d1_5 = { 0x28, 0x19, 0x74, 0x82, 0x04, 0x00, 0x00, 0xE1 };
DeviceAddress d1_6 = { 0x28, 0xA8, 0x78, 0x82, 0x04, 0x00, 0x00, 0xF0 };
DeviceAddress d1_7 = { 0x28, 0xAD, 0x8F, 0x82, 0x04, 0x00, 0x00, 0xEC };
// Outdoor - Orange
DeviceAddress d1_8 = { 0x28, 0xAD, 0x8F, 0x82, 0x04, 0x00, 0x00, 0xEC };

// Inner - Brown
DeviceAddress d2_0 = { 0x28, 0xAD, 0x8F, 0x82, 0x04, 0x00, 0x00, 0xEC };
DeviceAddress d2_1 = { 0x28, 0x09, 0x00, 0x82, 0x04, 0x00, 0x00, 0xC8 };
DeviceAddress d2_2 = { 0x28, 0x6A, 0x8B, 0x82, 0x04, 0x00, 0x00, 0xE9 };
DeviceAddress d2_3 = { 0x28, 0x09, 0x00, 0x82, 0x04, 0x00, 0x00, 0xC8 };
DeviceAddress d2_4 = { 0x28, 0xA9, 0x6F, 0x82, 0x04, 0x00, 0x00, 0xEA };
DeviceAddress d2_5 = { 0x28, 0x19, 0x74, 0x82, 0x04, 0x00, 0x00, 0xE1 };
DeviceAddress d2_6 = { 0x28, 0xA8, 0x78, 0x82, 0x04, 0x00, 0x00, 0xF0 };
DeviceAddress d2_7 = { 0x28, 0xAD, 0x8F, 0x82, 0x04, 0x00, 0x00, 0xEC };

// formulate each address group into a convenient array
void assignAddresses() {
  bus0Devs[0] = &d0_0;
  
  bus1Devs[0] = &d1_0;
  bus1Devs[1] = &d1_1;
  bus1Devs[2] = &d1_2;
  bus1Devs[3] = &d1_3;
  bus1Devs[4] = &d1_4;
  bus1Devs[5] = &d1_5;
  bus1Devs[6] = &d1_6;
  bus1Devs[7] = &d1_7;
  bus2Devs[8] = &d1_8;
  
  bus2Devs[0] = &d2_0;
  bus2Devs[1] = &d2_1;
  bus2Devs[2] = &d2_2;
  bus2Devs[3] = &d2_3;
  bus2Devs[4] = &d2_4;
  bus2Devs[5] = &d2_5;
  bus2Devs[6] = &d2_6;
  bus2Devs[7] = &d2_7;
}

void setup() {
  // Begin
  Serial.begin(9600);
  assignAddresses();
  dallas0.begin();
  dallas1.begin();
  dallas2.begin();
  
  // Get the addresses of connected devices.
  if (DEBUG) {
    Serial.println("Beginning.");
    Serial.print("Locating devices on ch. 0... Found ");
    Serial.print(dallas0.getDeviceCount(), DEC);
    Serial.println(" devices.");
    
    DeviceAddress tempDev;
    dallas0.requestTemperatures();
    for (int i=0; i<dallas0.getDeviceCount(); ++i) {
      if (!dallas0.getAddress(tempDev, i)) {
        Serial.print("  Unable to find address for Device ");
        Serial.println(i);
      } else {
        printAddress(tempDev);
        Serial.println(dallas0.getTempC(tempDev));
      }
    }
    
    Serial.print("Locating devices on ch. 1... Found ");
    Serial.print(dallas1.getDeviceCount(), DEC);
    Serial.println(" devices.");
    
    dallas1.requestTemperatures();
    for (int i=0; i<dallas1.getDeviceCount(); ++i) {
      if (!dallas1.getAddress(tempDev, i)) {
        Serial.print("  Unable to find address for Device ");
        Serial.println(i);
      } else {
        printAddress(tempDev);
        Serial.println(dallas1.getTempC(tempDev));
      }
    }
    
    
    Serial.print("Locating devices on ch. 2... Found ");
    Serial.print(dallas2.getDeviceCount(), DEC);
    Serial.println(" devices.");
    
    dallas2.requestTemperatures();
    for (int i=0; i<dallas2.getDeviceCount(); ++i) {
      if (!dallas2.getAddress(tempDev, i)) {
        Serial.print("  Unable to find address for Device ");
        Serial.println(i);
      } else {
        printAddress(tempDev);
        Serial.println(dallas2.getTempC(tempDev));
      }
    }
  }
}

void loop() {
  assignAddresses(); // Unsure why we have to do this every time, but we do
  // Update temperature readings
  dallas0.requestTemperatures();
  dallas1.requestTemperatures();
  dallas2.requestTemperatures();
  
  // Roofs
  for (int i=0; i<N_BUS_1; ++i) {
    float temp = dallas1.getTempC(*bus1Devs[i]);
    Serial.print(temp);
    Serial.print(", ");
  }
  
  // Inners + Outdoor
  for (int i=0; i<N_BUS_1; ++i) {
    float temp = dallas2.getTempC(*bus1Devs[i]);
    Serial.print(temp);
    Serial.print(", ");
  }
  
  // Indoor
  for (int i=0; i<N_BUS_0; ++i) {
    float temp = dallas0.getTempC(*bus0Devs[i]);
    Serial.print(temp);
    Serial.print(", ");
  }
  
  // end line, wait
  Serial.println();
  delay(15*1000);
}

// print a device address in format that can be copy pasted
// to the definitions at the beginning.
void printAddress(DeviceAddress deviceAddress)
{
  for (uint8_t i = 0; i < 8; i++)
  {
    Serial.print("0x");
    // zero pad the address if necessary
    if (deviceAddress[i] < 16) Serial.print("0");
    Serial.print(deviceAddress[i], HEX);
    Serial.print(", ");
  }
}
