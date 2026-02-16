import processing.serial.*; //Required for accessing serial port
import org.gicentre.utils.stat.*;   // Requires giCentre Utils

Serial port;
int numSeconds = 0;

//Global Varaibles
int page = 0;
ArrayList<Float> heartRates = new ArrayList<Float>();
ArrayList<Float> timeStamps = new ArrayList<Float>();

void setup() {
  size(400,400);
  textSize(15);
  textAlign(CENTER, CENTER);
  setupPort();
  setupDoneButtonProperties();
  
  age = 25;
  maxHeartRate = 220 - age;
  setHeartRateValues();
  page = 2;
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
      drawExercisePage();
      break;
    case 3:
      drawHealthGraphPage();
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
  switch (page) {
    case 1:
      serialEventBHR(p);
      break;
    case 2:
      serialEventExercise(p);
      break;
  }
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
