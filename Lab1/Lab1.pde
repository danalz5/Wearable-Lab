import processing.serial.*; //Required for accessing serial port
import org.gicentre.utils.stat.*;   // Requires giCentre Utils

Serial port;
int numSeconds = 0;

//Chart variables
ArrayList<Float> heartRates = new ArrayList<Float>();
ArrayList<Float> timeStamps = new ArrayList<Float>();

color[] chartColors = {color(65, 245, 130), color(245, 230, 65), color(245, 160, 65)}; //Rest, cardio, max

int chartX = 50;
int chartY = 250;
int chartWidth = 250;
int chartHeight = 100;

// Ring buffers
final int N = 800;
float[] bufA = new float[N];
int idx = 0;

float[] xPlot = new float[N];
float[] yPlot = new float[N];

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

void displayExericiseZones() {
  textAlign(LEFT, CENTER);
  fill(0, 0, 0);
  text("Exercise Zones", 30, 75);
  
  String[] labels = {"Peak", "Cardio", "Fat burn"};
  int[] widths = {60, 120, 240};
  color[] colors = {color(255, 150, 150), color(230, 160, 75), color(230, 215, 75)};
  int yOffset = 45;

  // Loop through each heart rate zone
  for (int i = 0; i < labels.length; i++) {
    fill(colors[i]);
    rect(30, 90 + yOffset * i, widths[i], 30);
    fill(0, 0, 0);
    text(labels[i], 45 + widths[i], 105 + yOffset * i);
  }
}

void displayGraph(){
  // Draw axes
  drawAxes();
  // Draw heart rate line with zone colors
  drawHeartRateLine();
}

void drawAxes() {
  stroke(0);
  strokeWeight(1);
  line(chartX, chartY, chartX, chartY + chartHeight);  // Y-axis
  line(chartX, chartY + chartHeight, chartX + chartWidth, chartY + chartHeight);  // X-axis
  
  // Add labels, tick marks as needed
}

void drawHeartRateLine() {
  //print(millis());
  //println(heartRates.size());
  if (heartRates.size() < 2) return;
  
  
  for (int i = 0; i < heartRates.size() - 2; i++) {
    float hr = heartRates.get(i);
    
    // Set color based on heart rate zone
    if (hr <= 100) {
      stroke(chartColors[0]);  // green - fat burn
    } else if (hr <= 130) {
      stroke(chartColors[1]);  // yellow - cardio
    } else {
      stroke(chartColors[2]);  // red - peak
    }
    
    strokeWeight(2);
    
    // Map to screen coordinates
    float x1 = map(timeStamps.get(i), 0.0, millis()/1000.0, chartX, chartX + chartWidth);
    float y1 = map(hr, 0, 160, chartY + chartHeight, chartY);
    float x2 = map(timeStamps.get(i+1), 0.0, millis()/1000.0, chartX, chartX + chartWidth);
    float y2 = map(heartRates.get(i+1), 0.0, 160, chartY + chartHeight, chartY);
    
    line(x1, y1, x2, y2);
  }
}

void draw() {
  background(255);
  
  createHeader();
  displayExericiseZones();
  displayGraph();
}

//Called from Serial object!
void serialEvent(Serial p) {
  String line = p.readStringUntil('\n');
  
  //If the 
  if (line == null) return;
  line = trim(line);
  if (line.length() == 0) return;
  
  float v = float(line);
  float currentTime = millis() / 1000.0;  // seconds
  timeStamps.add(currentTime);
  heartRates.add(v);
}
