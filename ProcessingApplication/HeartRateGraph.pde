color[] chartColors = {color(150, 150, 150), color(0, 190, 255), color(65, 245, 130), color(98, 245, 65), color(245, 160, 65)}; 

float maximum = 0;
float hard = 0;
float moderate = 0;
float light = 0;
float veryLight = 0;
float minimum = 0;

int chartX = 55;
int chartY = 220;    // Shifted up from 250/300 to make room
int chartWidth = 320; 
int chartHeight = 100;

void setHeartRateValues() {
  maximum = maxHeartRate;
  hard = maxHeartRate * 0.9;
  moderate = maxHeartRate * 0.8;
  light = maxHeartRate * 0.7;
  veryLight = maxHeartRate * 0.6;
  minimum = maxHeartRate * 0.5;
}

float percentRage(ArrayList<Float> values, float min, float max) {
  if (values.size() == 0) return 0;
  int count = 0;
  for (float value : values) {
    if (value >= min && value < max) {
      count++;
    }
  }
  return (float)count / values.size();
}

void createHeader() {
  fill(12, 55, 84);
  stroke(0);
  rect(0, 0, width, 50);
  
  fill(255, 240);              // already white-ish
  textAlign(CENTER, CENTER);
  String date = nf(month(), 2) + "/" + nf(day(), 2) + "/" + nf(year(), 2);
  text(date, width/8, 30);
  
  float duration = (timeStamps.size() > 0) ? (timeStamps.get(timeStamps.size()-1) - timeStamps.get(0)) / 60.0 : 0;
  text(nf(duration, 0, 1) + " min", width/2, 30);
  
  String time = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
  text(time, width * 7 / 8, 30);
}

void displayExericiseZones() {
  if (timeStamps.size() < 1) return;
  
  textAlign(LEFT, CENTER);
  fill(255);                   // WHITE
  textSize(16);
  text("Exercise Zones", 30, 70);
  
  float cardioMax = maximum * 0.85;
  
  float peakPct    = percentRage(heartRates, cardioMax, maximum);
  float cardioPct  = percentRage(heartRates, light, cardioMax);
  float fatBurnPct = percentRage(heartRates, minimum, light);
  
  float totalSeconds = timeStamps.get(timeStamps.size() - 1) - timeStamps.get(0);
  int MAX_WIDTH = 135;
  
  String[] labels = {"Peak", "Cardio", "Fat burn"};
  float[] pcts    = {peakPct, cardioPct, fatBurnPct};
  color[] colors  = {
    color(255, 60, 60),   // Red
    color(255, 160, 0),   // Orange
    color(255, 220, 0)    // Yellow
  };
  
  int yOffset = 35; 

  for (int i = 0; i < labels.length; i++) {
    int yPos = 85 + (yOffset * i); 
    float barWidth = pcts[i] * MAX_WIDTH;
    
    fill(colors[i]);
    rect(30, yPos, barWidth, 25);
    
    fill(255);                 // WHITE text labels
    textSize(11);
    int zoneMinutes = (int)((pcts[i] * totalSeconds) / 60);
    text(zoneMinutes + "m " + labels[i], 35 + barWidth, yPos + 12);
  }
}

void drawAxes() {
  stroke(255);                 // OPTIONAL: make axes white too (looks better on dark bg)
  strokeWeight(1);

  // Main Axes
  line(chartX, chartY, chartX, chartY + chartHeight);  
  line(chartX, chartY + chartHeight, chartX + chartWidth, chartY + chartHeight); 
  
  fill(255);                   // WHITE
  textSize(10);
  textAlign(RIGHT, CENTER);
  
  // Draw ticks every 50 BPM
  for (int hrVal = 0; hrVal <= maximum; hrVal += 50) {
    float y = map(hrVal, 0, maximum, chartY + chartHeight, chartY);
    
    line(chartX - 5, y, chartX, y); // Small tick line
    text(hrVal, chartX - 8, y);     // WHITE BPM label
  }
  
  // X-Axis Label
  textAlign(CENTER, TOP);
  text("Time (Session)", chartX + chartWidth/2, chartY + chartHeight + 8); // WHITE
}

void drawHeartRateLine() {
  if (heartRates.size() < 2) return;
  float init_time = timeStamps.get(0);
  float end_time = timeStamps.get(timeStamps.size() - 1);
  
  for (int i = 0; i < heartRates.size() - 1; i++) {
    float hr1 = heartRates.get(i);
    float hr2 = heartRates.get(i + 1);
    
    // Zone Color Logic
    if (hr1 <= veryLight) stroke(chartColors[0]);
    else if (hr1 <= light) stroke(chartColors[1]);
    else if (hr1 <= moderate) stroke(chartColors[2]);
    else if (hr1 <= hard) stroke(chartColors[3]);
    else stroke(chartColors[4]);
    
    strokeWeight(2);
    
    float x1 = map(timeStamps.get(i), init_time, end_time, chartX, chartX + chartWidth);
    float x2 = map(timeStamps.get(i+1), init_time, end_time, chartX, chartX + chartWidth);
    
    float y1 = map(hr1, 0, maximum, chartY + chartHeight, chartY);
    float y2 = map(hr2, 0, maximum, chartY + chartHeight, chartY);
    
    line(x1, y1, x2, y2);
  }
}
void drawHealthGraphPage(){
  createHeader();
  displayExericiseZones();
  displayGraph();

  // --- Back button (bottom)
  backToMenuBtn.update();
  backToMenuBtn.display();
}



void displayGraph(){
  drawAxes();
  drawHeartRateLine();
}
