int buttonX, buttonY, buttonW, buttonH;
float startExercise = 0;
float endExercise = 0;

float sampleValue = 110;

void setupDoneButtonProperties(){
  // Define button position and size
  buttonW = 150;
  buttonH = 50;
  buttonX = width/2 - buttonW/2;
  buttonY = height/2 + 80;
}

void drawExercisePage(){
  if (startExercise == 0) {
    startExercise = millis();
  }

  // Page 3: Exercise page
  textSize(32);
  fill(255); // WHITE
  text("Exercise", width/2, height/2 - 80);

  textSize(18);
  fill(255); // WHITE
  text("Whenever you are done, press the done button", width/2, height/2 - 20);

  // Draw the Done button
  drawButton();
}

void drawButton() {
  // Check if mouse is hovering over button
  boolean hover = mouseX > buttonX && mouseX < buttonX + buttonW &&
                  mouseY > buttonY && mouseY < buttonY + buttonH;

  // Button color (changes on hover)
  if (hover) {
    fill(100, 180, 100);  // lighter green on hover
  } else {
    fill(80, 150, 80);    // normal green
  }

  // Draw button rectangle
  rect(buttonX, buttonY, buttonW, buttonH, 10);

  // Button text
  fill(255); // WHITE
  textSize(20);
  text("Done", width/2, buttonY + buttonH/2);
}

void mousePressedExercise() {
  if (page == Page.EXERCISE_PAGE) {
    // Check if Done button was clicked
    if (mouseX > buttonX && mouseX < buttonX + buttonW &&
        mouseY > buttonY && mouseY < buttonY + buttonH) {
      println("Done button clicked!");
      endExercise = millis();
      setHeartRateValues();
      page = Page.HEART_RATE_GRAPH;  // Move to next page
    }
  }
}

void sampleData() {
  float currentTime = (millis() - startExercise) / 1000.0;  // seconds
  timeStamps.add(currentTime);
  heartRates.add(sampleValue);

  sampleValue += random(-2, 2);
  //sampleValue = Math.min(maxHeartRate, Math.max(0, sampleValue));
  sampleValue = Math.min(maxHeartRate, Math.max(light, sampleValue));
}

void serialEventExercise(Serial p) {
  String line = p.readStringUntil('\n');

  if (line == null || startExercise == 0) return;
  line = trim(line);
  if (line.length() == 0) return;

  // Parse heart rate data
  if (line.startsWith("HR:")) {
    float v = int(line.substring(3));
    float currentTime = (millis() - startExercise) / 1000.0;  // seconds
    timeStamps.add(currentTime);

    if (v == 0) {
      float latestElement = heartRates.get(heartRates.size() - 1);
      heartRates.add(latestElement);
      return;
    }

    heartRates.add(v);
    println("Heart rate received: " + v);
  }
}
