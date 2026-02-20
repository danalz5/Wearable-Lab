import processing.serial.*; //Required for accessing serial port
import org.gicentre.utils.stat.*;   // Requires giCentre Utils

enum Page {
  AGE_INPUT,
  BASE_HEART_RATE,
  SELECT_MODE,
  //Fitnessmode
  EXERCISE_PAGE,
  HEART_RATE_GRAPH,
  //Calm Mode
  CALM_MUSIC,
  //Stress Mode
  STRESS_PAGE
}

Serial port;
int numSeconds = 0;

//Global Varaibles
Page page = Page.AGE_INPUT;
ArrayList<Float> heartRates = new ArrayList<Float>();
ArrayList<Float> timeStamps = new ArrayList<Float>(); //Seconds
int maxHeartRate = 0;

void setup() {
  size(400,400);
  textSize(15);
  textAlign(CENTER, CENTER);
  setupPort();
  setupDoneButtonProperties();
  setupCalmPage();
  
  
  //Setting varaibles automatically
    age = 25;
    maxHeartRate = 220 - age;
    baseHeartRate = 85;
    setHeartRateValues();
    //Setting the page
    page = Page.SELECT_MODE;
}

void setupPort() {
  println("Ports: ", Serial.list());
  int serial_len = Serial.list().length;
  if (serial_len > 0) {
    for (int i = 0; i < serial_len; i++) {
      String portName = Serial.list()[i];
      if (portName.equals("/dev/cu.usbmodem123456781")) {
        port = new Serial(this, portName, 115200);
        //port.clear();
        break;
      }
    }
  }
}


void draw() {
  background(255);
  
  switch (page) {
    case AGE_INPUT:
      drawInputPage();
      break;
    case BASE_HEART_RATE:
      displayBHRPage();
      break;
    case SELECT_MODE:
      drawSelectPage();
      break;
    case EXERCISE_PAGE:
      drawExercisePage();
      sampleData();
      break;
    case HEART_RATE_GRAPH:
      drawHealthGraphPage();
      break;
    case CALM_MUSIC:
      drawCalmPage();
      break;
    case STRESS_PAGE:
      drawStressModePage();
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
    case BASE_HEART_RATE:
      serialEventBHR(p);
      break;
    case EXERCISE_PAGE:
      //serialEventExercise(p);
      break;
    case CALM_MUSIC:
      serialEventCalm(p);
      break;
    case STRESS_PAGE:
      serialEventStress(p);
      break;
  }
}

void keyPressed() {
  switch (page) {
    case AGE_INPUT:
      keyPressedUserInput();
      break;
    case BASE_HEART_RATE:
      keyPressedBHR();
      break;
    case STRESS_PAGE:
      keyPressedStress();
      break;
  }
}

void mousePressed() {
  switch (page) {
    case SELECT_MODE:
      mousePressedSelect();
      break;
    case EXERCISE_PAGE:
      mousePressedExercise();
      break;
  }
}
