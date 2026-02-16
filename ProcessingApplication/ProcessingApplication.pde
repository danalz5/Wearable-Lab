import processing.serial.*; //Required for accessing serial port
import org.gicentre.utils.stat.*;   // Requires giCentre Utils

Serial port;
int numSeconds = 0;

//Global Varaibles
int page = 0;

void setup() {
  size(400,400);
  textSize(15);
  textAlign(CENTER, CENTER);
  setupPort();
}

void setupPort() {
  println("Ports: ", Serial.list());
  int serial_len = Serial.list().length;
  if (serial_len > 0) {
    for (int i = 0; i < serial_len; i++) {
      String portName = Serial.list()[i];
      if (portName.equals("/dev/cu.usbmodem123456781")) {
        port = new Serial(this, portName, 115200);
        port.clear();
        break;
      }
    }
  }
}

void createHeader() {
  //Creates rectangle
  fill(12, 55, 84);
  stroke(0);
  rect(0, 0, width, 50);
  
  fill(255, 240);
  textAlign(CENTER, CENTER);
  // Format and display date
  String date = nf(month(), 2) + "/" + nf(day(), 2) + "/" + nf(year(), 2);
  text(date, width/8, 30);
  
  //Display time in app
  String timeInApp = "43:33 min";
  text(timeInApp, width/2, 30);
  
  // Format and display time
  String time = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
  text(time, width * 7 / 8, 30);
}


void draw() {
  background(255);
  
  switch (page) {
    case 0:
      drawInputPage();
      break;
    case 1:
      displayBHRPage();
      break;
   case 2:
    drawHealthGRaphPage();
    break;
  }
}

boolean isNumeric(String strNum) {
    if (strNum == null) {
        return false;
    }
    try {
        double d = Double.parseDouble(strNum);
    } catch (NumberFormatException nfe) {
        return false;
    }
    return true;
}

//Called from Serial object!
void serialEvent(Serial p) {
  String line = p.readStringUntil('\n');
  
  //If the 
  if (line == null || !isNumeric(line)) return;
  line = trim(line);
  if (line.length() == 0) return;
  
  float v = float(line);
  float currentTime = millis() / 1000.0;  // seconds
  timeStamps.add(currentTime);
  heartRates.add(v);
}

void keyPressed() {
  switch (page) {
    case 0:
      keyPressedUserInput();
      break;
    case 1:
      keyPressedBHR();
      break;
  }
}
