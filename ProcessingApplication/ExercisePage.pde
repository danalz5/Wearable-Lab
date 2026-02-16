// Button properties
int buttonX, buttonY, buttonW, buttonH;
float startExercise = 0;
float endExercise = 0;

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
  fill(0);
  text("Exercise", width/2, height/2 - 80);
  
  textSize(18);
  fill(80);
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
  rect(buttonX, buttonY, buttonW, buttonH, 10);  // 10 = rounded corners
  
  // Button text
  fill(255);
  textSize(20);
  text("Done", width/2, buttonY + buttonH/2);
}

void mousePressed() {
  if (page == 2) {
    // Check if Done button was clicked
    if (mouseX > buttonX && mouseX < buttonX + buttonW &&
        mouseY > buttonY && mouseY < buttonY + buttonH) {
      println("Done button clicked!");
      endExercise = millis();
      page = 3;  // Move to next page
    }
  }
}

void serialEventExercise(Serial p) {
  String line = p.readStringUntil('\n');
  
  //If the 
  if (line == null || !isNumeric(line) || startExercise == 0) return;
  line = trim(line);
  if (line.length() == 0) return;
  
  float v = float(line);
  float currentTime = (millis() - startExercise) / 1000.0;  // seconds
  timeStamps.add(currentTime);
  heartRates.add(v);
  println(timeStamps);
  println(heartRates);
  println(timeStamps.size() == heartRates.size());
}
