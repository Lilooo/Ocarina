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

int[] pad = new int[6];

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
  for (int z=0; z < 6; z++) {
    music(z);
  }
}

void music(int i) {
  if (pad[i] == 0) {
    file[i].stop();
    file[i].cue(0);
    println("stop");
  } else {
    file[i].play();
    println("play");
    int x = 0;
    while (true) {
      if (file[i].isPlaying()) {
        x++;
        println("File is still playing after " + x + " seconds");
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
  pad[1] = theOscMessage.get(0).intValue();
  println(" - Pad1: "+pad[1]);
  pad[2] = theOscMessage.get(1).intValue();
  println(" - Pad2: "+pad[2]);
  pad[3] = theOscMessage.get(2).intValue();
  println(" - Pad3: "+pad[3]);
  pad[4] = theOscMessage.get(3).intValue();
  println(" - Pad4: "+pad[4]);
  pad[5] = theOscMessage.get(4).intValue();
  println(" - Pad5: "+pad[5]);
  pad[6] = theOscMessage.get(5).intValue();
  println(" - Pad6: "+pad[6]);
}
