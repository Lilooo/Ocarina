/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;
import processing.sound.*;

SoundFile[] file;

OscP5 oscP5;

int pad1;
int pad2;
int pad3;
int pad4;
int pad5;
int pad6;

// Define the number of samples 
int numsounds = 6;

void setup() {
  size(400, 400);
  //frameRate(250);
  // Create a Sound renderer and an array of empty soundfiles
  file = new SoundFile[numsounds];

  // Load 6 soundfiles from a folder in a for loop. By naming
  // the files 1.aif, 2.aif, 3.aif, ..., n.aif it is easy to iterate
  // through the folder and load all files in one line of code.
  for (int i = 0; i < numsounds; i++) {
    file[i] = new SoundFile(this, (i+1) + ".aif");
  }
  
  /* start oscP5, listening for incoming messages at port 4559 */
  oscP5 = new OscP5(this, 4559);

}

void draw() {
  music();
}

void music() {
  if (pad1 == 0) {
    file[1].stop();
    file[1].cue(0);
    println("stop");
  } else {
    file[1].play();
    println("play");
    int i = 0;
    while (true) {
      delay(1000);
      if (file[1].isPlaying()) {
        i++;
        println("File is still playing after " + i + " seconds");
      } else {
        break;
      }
    }
    println("Soundfile finished playing!");
    }
  if (pad2 == 0) {
    file[2].stop();
    file[2].cue(0);
    println("stop");
  } else {
    file[2].play();
    println("play");
    int i = 0;
    while (true) {
      delay(1000);
      if (file[2].isPlaying()) {
        i++;
        println("File is still playing after " + i + " seconds");
      } else {
        break;
      }
    }
    println("Soundfile finished playing!");
    }
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the content of the received OscMessage */
  println("addrpattern: "+theOscMessage.addrPattern());
  pad1 = theOscMessage.get(0).intValue();
  println(" - Pad1: "+pad1);
  pad2 = theOscMessage.get(1).intValue();
  println(" - Pad2: "+pad2);
  pad3 = theOscMessage.get(2).intValue();
  println(" - Pad3: "+pad3);
  pad4 = theOscMessage.get(3).intValue();
  println(" - Pad4: "+pad4);
  pad5 = theOscMessage.get(4).intValue();
  println(" - Pad5: "+pad5);
  pad6 = theOscMessage.get(5).intValue();
  println(" - Pad6: "+pad6);
}
