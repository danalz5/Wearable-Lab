//Chart variables
color[] chartColors = {color(0, 190, 255), color(65, 245, 130), color(98, 245, 65), color(245, 230, 65), color(245, 160, 65)}; //light, moderate, hard, max

float maximum = 0;
float hard = 0;
float moderate = 0;
float light = 0;
float veryLight = 0;
float minimum = 0;

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

void setHeartRateValues() {
  maximum = maxHeartRate;
  hard = maxHeartRate * 0.9;
  moderate = maxHeartRate * 0.8;
  light = maxHeartRate * 0.7;
  veryLight = maxHeartRate * 0.6;
  minimum = maxHeartRate * 0.5;
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
  //println("This is the 1st loop");
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
  //int lineLength = 10;
  
  //line(chartX, chartY, chartX + lineLength, chartY);  // Y-axis
}

void drawHeartRateLine() {
  //print(millis());
  //println(heartRates.size());
  if (heartRates.size() < 2) return;
  float init_time = timeStamps.get(0);
  float end_time = timeStamps.get(timeStamps.size() - 1);
  
  //println("This is the 2nd loop");
  for (int i = 0; i < heartRates.size() - 2; i++) {
    float hr = heartRates.get(i);
    
    // Set color based on heart rate zone
    if (hr <= veryLight) {
      stroke(chartColors[0]);  // gray - very light
    } else if (hr <= light) {
      stroke(chartColors[1]);  // blue - light
    } else if (hr <= moderate) {
      stroke(chartColors[2]);  // green - moderate
    } else if (hr <= hard) {
      stroke(chartColors[3]);  // yellow - cardio
    } else {
      stroke(chartColors[4]);  // red - peak
    }
    
    strokeWeight(2);
    
    // Map to screen coordinates
    float x1 = map(timeStamps.get(i), init_time, end_time, chartX, chartX + chartWidth);
    float y1 = map(hr, minimum, maximum, chartY + chartHeight, chartY);
    float x2 = map(timeStamps.get(i+1), init_time, end_time, chartX, chartX + chartWidth);
    float y2 = map(heartRates.get(i+1), minimum, maximum, chartY + chartHeight, chartY);
    
    line(x1, y1, x2, y2);
  }
  //println("Finished 2nd loop");
}


void drawHealthGraphPage(){
  createHeader();
  displayExericiseZones();
  displayGraph();
}
