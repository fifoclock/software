int[] myLEDArrangement = {6, 3, 5};
color dimColor = color(127, 0, 0);
color clockColor = color(255, 0, 0);
LEDString myString;
Clock myClock;

void setup() {
  fullScreen(P2D);
  //size(600, 400, P2D);
  noStroke();
  noCursor();
  myString = new LEDString(myLEDArrangement);
  myClock = new Clock(myString, clockColor, dimColor, new NormalTime());
}

void draw() {
  background(0);
  myClock.update();
}

class Clock {
  
  private int lastSecond;
  private LEDString ledString;
  private color ledColor;
  private color dimLedColor;
  private Time  myTime;
  
  Clock(LEDString ledString, color ledColor, color dimLedColor, Time myTime) {
    this.ledString = ledString;
    this.ledColor = ledColor;
    this.dimLedColor = dimLedColor;
    this.myTime = myTime;
    lastSecond = myTime.second();
  }
  
  void update() {
    if(newSecond()) {
      boolean[] ledState = new boolean[0];
      
      ledState = concat(ledState, intToBarIndicator(5, myTime.minute() % 10));
      ledState = concat(ledState, intToBarIndicator(3, myTime.minute() / 10));
      ledState = concat(ledState, intToBarIndicator(6, myTime.hour() % 12));
      
      updateString(ledState);
    }
    ledString.show();
  }
  
  private void updateString(boolean[] ledState) {
    for(int i = 0; i < ledState.length; i++) {
      if(ledState[i]) {
        ledString.setPixelColor(i, ledColor);
      } else {
        ledString.setPixelColor(i, dimLedColor);
      }
    }
  }
  
  private boolean[] intToBarIndicator(int size, int num) {
    boolean[] indicator = new boolean[size];
    
    int first = (num <= size) ? 0 : num - size;
    int last = (num <= size) ? num : size;
    
    for(int i = first; i < last; i++) {
      indicator[i] = true;
    }
    return indicator;
  }
  
  private boolean newSecond() {
   if(myTime.second() != lastSecond){
     lastSecond = myTime.second();
     return true;
   }
   return false;
  }
}

class LEDString {
  
  private LED[] ledString;
 
  // cols are the number of leds in each column, from right to left
  LEDString(int[] cols) {
    int xOffset = width/(cols.length + 1);
    int yOffset = height/(max(cols));
    int ledWidth = min(xOffset, yOffset)/3;
    ledString = new LED[sum(cols)];
    
    int stringIndex = 0;
    for(int i = cols.length - 1 ; i >= 0; i--){
      int xPos = xOffset * (i + 1);
      int yPos = (height + (cols[i] - 1) * yOffset)/2;
      
      for(int j = 0; j < cols[i]; j++) {
        ledString[stringIndex] = new LED(xPos, yPos - j * yOffset, ledWidth);
        stringIndex++;
      }
    }
  }
  
  void show() {
   for(LED l : ledString)
     l.show();
  }
  
  void setPixelColor(int index, color c) {
    ledString[index].setColor(c);
  }
  
  void fill(color c, int index, int count) {
    for(int i = index; i < i + count; i++) {
      ledString[i].setColor(c);
    }
  }
}

class LED {
  private int x, y, size;
  private color c = color(0, 0, 256);
 
  // x and y are the position of the center of the led relative to the top-left corner, and size is the side length of the led
  LED(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void show() {
    fill(c);
    square(x - size/2, y-size/2, size);
  }

  void setColor(color c) {
    this.c = c;
  }
}

int sum(int[] array) {
  int sum = 0;
  for(int i : array)
    sum += i;
  return sum;
}

interface Time {
  int second();
  int minute();
  int hour();
}

class FastTime implements Time{
  
  int speed;
  
  FastTime(int speed) {
    this.speed = speed;
  }
  
  int second() {
    return millis()*speed/1000%60;
  }
  
  int minute() {
    return millis()*speed/1000/60%60;
  }
  
  int hour() {
    return millis()*speed/1000/60/60%24;
  }
  
}

class NormalTime implements Time {
  
  NormalTime() {
  }
  
  int second() {
    return PApplet.second();
  }
  
  int minute() {
    return PApplet.minute();
  }
  
  int hour() {
    return PApplet.hour();
  }
  
}
