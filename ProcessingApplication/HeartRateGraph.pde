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
  
  fill(255, 240);
  textAlign(CENTER, CENTER);
  String date = nf(month(), 2) + "/" + nf(day(), 2) + "/" + nf(year(), 2);
  text(date, width/8, 30);
  
  float duration = (timeStamps.size() > 0) ? (timeStamps.get(timeStamps.size()-1) - timeStamps.get(0)) / 60.0 : 0;
  text(nf(duration, 0, 1) + " min", width/2, 30);
  
  String time = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
  text(time, width * 7 / 8, 30);
}

void displayExericiseZones() {
  if (timeStamps.size() < 2) return; // Need at least two points for time
  
  textAlign(LEFT, CENTER);
  fill(0);
  textSize(16);
  text("Exercise Zones", 30, 70);
  
  float cardioMax = maximum * 0.85;
  
  // Calculate unique time slices
  float peakPct    = percentRage(heartRates, cardioMax, maximum);
  float cardioPct  = percentRage(heartRates, light, cardioMax);
  float fatBurnPct = percentRage(heartRates, minimum, light);
  
  // Get total duration in seconds
  float totalSeconds = timeStamps.get(timeStamps.size() - 1) - timeStamps.get(0);
  int MAX_WIDTH = 135;
  
  // Arrays ordered: Peak(Red), Cardio(Orange), Fat burn(Yellow)
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
    
    // Draw the bar
    fill(colors[i]);
    rect(30, yPos, barWidth, 25);
    
    // FIX: Correct Minute Calculation
    // We multiply totalSeconds by the percentage, then divide by 60.0 (float)
    // Using Math.round() prevents it from always rounding down to 0.
    int zoneMinutes = Math.round((pcts[i] * totalSeconds) / 60.0f);
    
    // If you want to see seconds if minutes are 0, use this instead:
    // int zoneSeconds = Math.round(pcts[i] * totalSeconds);
    
    fill(0);
    textSize(11);
    text(zoneMinutes + " min " + labels[i], 35 + barWidth, yPos + 12);
  }
}

void drawAxes() {
  stroke(0);
  strokeWeight(1);
  // Main Axes
  line(chartX, chartY, chartX, chartY + chartHeight);  
  line(chartX, chartY + chartHeight, chartX + chartWidth, chartY + chartHeight); 
  
  fill(0);
  textSize(10);
  textAlign(RIGHT, CENTER);
  
  // FIX: Draw ticks every 50 BPM
  for (int hrVal = 0; hrVal <= maximum; hrVal += 50) {
    // Map the HR value to the vertical pixel position
    float y = map(hrVal, 0, maximum, chartY + chartHeight, chartY);
    
    line(chartX - 5, y, chartX, y); // Small tick line
    text(hrVal, chartX - 8, y);     // BPM Label (0, 50, 100, 150, etc.)
  }
  
  // X-Axis Label
  textAlign(CENTER, TOP);
  text("Time (Session)", chartX + chartWidth/2, chartY + chartHeight + 8);
}



void drawHealthGraphPage(){
  createHeader();
  displayExericiseZones();
  displayGraph();
}

void displayGraph(){
  drawAxes();
  drawHeartRateLine();
}
