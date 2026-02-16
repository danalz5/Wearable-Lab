int baseHeartRate = 0;
int maxHeartRate = 0;

int bhrPage = 0;  // 0 = instruction, 1 = timer, 2 = success
int timerStart = 0;
int timerDuration = 30;  // 30 seconds

void displayBHRPage() {
  switch(bhrPage) {
    case 0:
      displayInitialInstructions();
      break;
    case 1:
      showTimerPage();
      break;
    case 2:
      displayLastPage();
      break;
  }
}

// Page 0: Initial instruction
void displayInitialInstructions(){
  fill(0);
  text("Sit still for 30 seconds", width/2, height/2 - 30);
  
  fill(150);
  textSize(18);
  text("Press any key to continue", width/2, height/2 + 30);
  textSize(24);
}

// Page 1: 30 second timer
void showTimerPage() {
  int elapsed = (millis() - timerStart) / 1000;
  int remaining = timerDuration - elapsed;
  
  if (remaining > 0) {
    fill(0);
    text("Please remain still...", width/2, height/2 - 50);
    
    // Display countdown
    fill(255, 0, 0);
    textSize(72);
    text(remaining, width/2, height/2 + 30);
    textSize(24);
  }else {
    bhrPage = 2;
    calculateBHR();
  }
}

// Page 2: Success message
void displayLastPage(){
  fill(0, 150, 0);
  text("Success!", width/2, height/2 - 30);
  
  fill(0);
  textSize(15);
  text("Your resting heart rate is " + baseHeartRate, width/2, height/2);
  textSize(18);
  text("Press any key to start the exercise", width/2, height/2 + 30);
  textSize(24);
}

void keyPressedBHR(){
  if (bhrPage == 0) {
    // Move from instruction to timer page
    bhrPage = 1;
    timerStart = millis();  // Start the timer
    
  } else if (bhrPage == 2) {
    // Move from success page to exercise (add your code here)
    page += 1;
    println("Starting exercise!");
    // You can set a flag here to start your heart rate monitoring
  }
}

void calculateBHR() {
  float total = 0;
  for (float heartRate: heartRates) {
    total += heartRate;
  }
  baseHeartRate = (int)(total / heartRates.size());
  maxHeartRate = 220 - baseHeartRate;
  println(baseHeartRate);
  println(heartRates);
  heartRates.clear();
  println(heartRates);
}

void serialEventBHR(Serial p) {
  String line = p.readStringUntil('\n');
  
  //If the 
  if (line == null || !isNumeric(line)) return;
  line = trim(line);
  if (line.length() == 0) return;
  
  float v = float(line);
  heartRates.add(v);
}
