//  From the Open Sound Control (OSC) library for the ESP8266/ESP32
#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <OSCMessage.h>
// Capactive Sensors
#include <Wire.h>
#include "Adafruit_MPR121.h"

////////////////////////////////////////////////////////////////////////////////
char ssid[] = "Tardis";                // TODO: your network SSID (name)
char pass[] = "SuperLapin";             // TODO: your network password
const IPAddress outIp(192,168,43,33); // TODO: remote IP of your computer
////////////////////////////////////////////////////////////////////////////////


const unsigned int localPort = 8888;  // local port to listen for OSC packets (not used for sending)
const unsigned int outPort = 4559;    // remote port to receive OSC
WiFiUDP Udp;                          // A UDP instance to let us send and receive packets over UDP


#ifndef _BV
#define _BV(bit) (1 << (bit)) 
#endif

int val[6];

// You can have up to 4 on one i2c bus but one is enough for testing!
Adafruit_MPR121 cap = Adafruit_MPR121();

// Keeps track of the last pins touched
// so we know when buttons are 'released'
uint16_t lasttouched = 0;
uint16_t currtouched = 0;

void setup() {
    Serial.begin(115200);

    // Connect to WiFi network
    Serial.print("\nConnecting to ");
    Serial.println(ssid);
    WiFi.begin(ssid, pass);

    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("\nWiFi connected - IP address: ");
    Serial.println(WiFi.localIP());

    Serial.println("Starting UDP");
    Udp.begin(localPort);

    Serial.print("Local port: ");
    Serial.println(Udp.localPort());
    
    while (!Serial) { // needed to keep leonardo/micro from starting too fast!
      delay(10);
    }
    
    Serial.println("Adafruit MPR121 Capacitive Touch sensor test"); 
    // Default address is 0x5A, if tied to 3.3V its 0x5B
    // If tied to SDA its 0x5C and if SCL then 0x5D
    if (!cap.begin(0x5A)) {
      Serial.println("MPR121 not found, check wiring?");
      while (1);
    }
    Serial.println("MPR121 found!");
}

void loop() {
  
    // Get the currently touched pads
    currtouched = cap.touched();

    for (uint8_t i = 0; i < 6; i++) {
      // it if *is* touched and *wasnt* touched before, alert!
      if ((currtouched & _BV(i)) && !(lasttouched & _BV(i)) ) {
        Serial.print(i); Serial.println(" touched");
      }
      // if it *was* touched and now *isnt*, alert!
      if (!(currtouched & _BV(i)) && (lasttouched & _BV(i)) ) {
        Serial.print(i); Serial.println(" released");
      }
    }

    // reset our state
    lasttouched = currtouched;
    
    for (int x=0; x < 6; x++) {
      if (cap.touched() & (1 << x)) {
        val[x] = 1;
      } else {
        val[x] = 0;
      }
    }
    
    OSCMessage msg("/touch");
    msg.add(val[0]);
    msg.add(val[1]);
    msg.add(val[2]);
    msg.add(val[3]);
    msg.add(val[4]);
    msg.add(val[5]);
    Udp.beginPacket(outIp, outPort);
    msg.send(Udp);
    Udp.endPacket();
    msg.empty();
}
