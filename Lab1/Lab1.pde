import processing.serial.*; //Required for accessing serial port
import org.gicentre.utils.stat.*;   // Requires giCentre Utils

Serial port;

int[] rateTime = {45, 0}; //Minutes, seconds

//Chart variables
XYChart chart;

// Ring buffers
final int N = 800;
float[] bufA = new float[N];
int idx = 0;

float[] xPlot = new float[N];
float[] yPlot = new float[N];

 //Rest, cardio, max
color[] chartColors = {color(65, 245, 130), color(245, 230, 65), color(245, 160, 65)};

void setup() {
  size(400,400);
  textSize(15);
  textAlign(CENTER, CENTER);
  setupPort();
  
  createChart();
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

void createChart() {
  // Generate some sample points from 0 to 160
  //for (int i = 0; i < xPlot.length; i++) {
  //  xPlot[i] = i;  // x values from 0 to 49
  //  yPlot[i] = random(0, 160);  // random y values from 0 to 160
  //}
  
  //Create a chart
  chart = new XYChart(this);
  chart.setData(xPlot, yPlot);
  chart.showXAxis(true);
  chart.showYAxis(true);
  
  // Styles
  chart.setPointSize(0);                       // lines only
  chart.setLineColour(chartColors[0]);     // red-ish for A
  chart.setLineWidth(2);
  chart.setMinX(0); chart.setMaxX(rateTime[0]);
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
  textAlign(LEFT, CENTER);
  fill(0, 0, 0);
  text("Heart Rate", 30, 225);
  
  //Display BEATS per minute
  text("140 BPM", 30, 250);
  
  chart.draw(30, 275, width * 0.8, height / 4.0);
}

// Helper function
float[] convertToArray(ArrayList<Float> list) {
  float[] arr = new float[list.size()];
  for (int i = 0; i < list.size(); i++) {
    arr[i] = list.get(i);
  }
  return arr;
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
  if (line == null) return;
  line = trim(line);
  if (line.length() == 0) return;
  float v = float(line);

  bufA[idx] = v;
  chart.setLineColour((v < 100)? chartColors[0]: (v < 130)? chartColors[1]: chartColors[2]);
  idx = (idx + 1) % N;
}
