

import processing.serial.*;           //Required for accessing serial port
import org.gicentre.utils.stat.*;     // Requires giCentre Utils

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

// --- Modern theme (solid background + clean palette)
final color BG        = color(12, 16, 26);
final color TEXT_MAIN = color(242, 244, 250);
final color TEXT_SUB  = color(170, 178, 196);

PFont fontTitle, fontUI;


void setup() {
  size(420, 440);
  smooth(8);

  fontTitle = createFont("SF Pro Display", 30, true);
  fontUI    = createFont("SF Pro Text", 16, true);
  textFont(fontUI);
  textAlign(CENTER, CENTER);

  setupPort();
  setupDoneButtonProperties();
  setupCalmPage();   // in Calm file

  ////Setting varaibles automatically
  //age = 25;
  //maxHeartRate = 220 - age;
  //baseHeartRate = 85;
  //setHeartRateValues();

  //page = Page.SELECT_MODE;
}

void setupPort() {
  println("Ports: ", Serial.list());
  int serial_len = Serial.list().length;
  if (serial_len > 0) {
    for (int i = 0; i < serial_len; i++) {
      String portName = Serial.list()[i];
      if (portName.equals("/dev/cu.usbmodem123456781")) {
        port = new Serial(this, portName, 115200);
        break;
      }
    }
  }
}

void draw() {
  background(BG);

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
      //sampleData();
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
  if (strNum == null) return false;
  try { Double.parseDouble(strNum); }
  catch (NumberFormatException nfe) { return false; }
  return true;
}

// Called from Serial object (MUST be named serialEvent)
void serialEvent(Serial p) {
  switch (page) {
    case BASE_HEART_RATE:
      serialEventBHR(p);
      break;
    case EXERCISE_PAGE:
      serialEventExercise(p);
      break;
    case CALM_MUSIC:
      serialEventCalmHelper(p);   // helper in Calm file
      break;
    case STRESS_PAGE:
      serialEventStressHelper(p); // helper in Stress file (below)
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
      //keyPressedStress();
      break;
  }
}

void mousePressed() {
  switch (page) {
    case SELECT_MODE:
      button1.onPress(); button2.onPress(); button3.onPress();
      mousePressedSelect();
      break;

    case EXERCISE_PAGE:
      mousePressedExercise();
      break;

    case HEART_RATE_GRAPH:
      backToMenuBtn.onPress();
      mousePressedBackToMenu();
      break;

    case CALM_MUSIC:
      backToMenuBtn.onPress();
      mousePressedBackToMenu();
      break;

    case STRESS_PAGE:
      backToMenuBtn.onPress();
      mousePressedBackToMenu();
      break;
  }
}

void mouseReleased() {
  if (page == Page.SELECT_MODE) {
    button1.onRelease(); button2.onRelease(); button3.onRelease();
  } else if (page == Page.HEART_RATE_GRAPH || page == Page.CALM_MUSIC || page == Page.STRESS_PAGE) {
    backToMenuBtn.onRelease();
  }
}

// Works for Graph + Calm + Stress
void mousePressedBackToMenu() {
  if (!(page == Page.HEART_RATE_GRAPH || page == Page.CALM_MUSIC || page == Page.STRESS_PAGE)) return;

  if (backToMenuBtn.isClicked()) {
    println("Back to Menu clicked!");

    if (page == Page.CALM_MUSIC) stopCalmAudio();     // in Calm file
    if (page == Page.STRESS_PAGE) resetStressTimer(); // in Stress file

    page = Page.SELECT_MODE;
  }
}

// --- Tiny helper you can use anywhere (optional)
float easeTo(float current, float target, float amt) {
  return lerp(current, target, constrain(amt, 0, 1));
}
