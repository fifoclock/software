int[] myLEDArrangement = {5, 5, 2, 6};
LEDString myString;

void setup() {
  fullScreen(P2D);
  //size(600, 400, P2D);
  noStroke();
  myString = new LEDString(myLEDArrangement);
}

void draw() {
  background(50);
  myString.show();
}

class LEDString {
  
  private LED[] ledString;
 
  // cols are the number of leds in each column, from right to left
  LEDString(int[] cols) {
    int xOffset = width/(cols.length + 1);
    int yOffset = height/(max(cols));
    int ledWidth = min(xOffset, yOffset)/2;
    ledString = new LED[sum(cols)];
    
    int stringIndex = 0;
    for(int i = 0; i < cols.length; i++){
      int xPos = width - xOffset * (i + 1);
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
  
  
}

class LED {
  private int x, y, size;
  private color c = color(50, 50, 200);
  private boolean enabled = true;
 
  // x and y are the position of the center of the led relative to the top-left corner, and size is the side length of the led
  LED(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void show() {
    if(enabled) {
      fill(c);
      square(x - size/2, y-size/2, size);
    }
  }
  
}

int sum(int[] array) {
  int sum = 0;
  for(int i : array)
    sum += i;
  return sum;
}
