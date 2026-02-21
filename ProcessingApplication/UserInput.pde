int age = 0;
String userInput = "";

void drawInputPage(){
  // Display the prompt
  fill(255);
  text("Please enter your age:", width/2, height/2 - 50);
  
  // Display what user has typed
  fill(100);
  rect(width/2 - 100, height/2, 200, 40);
  fill(0);
  text(userInput, width/2, height/2 + 20);
  
  // Instructions
  fill(150);
  textSize(14);
  text("Press ENTER when done", width/2, height/2 + 80);
  textSize(20);
}

void keyPressedUserInput() {
  if (key == ENTER || key == RETURN) {
    // Convert input to age
    if (userInput.length() > 0) {
      age = int(userInput);
      maxHeartRate = 220 - age;
      page = Page.BASE_HEART_RATE;
    }
  } else if (key == BACKSPACE) {
    // Delete last character
    if (userInput.length() > 0) {
      userInput = userInput.substring(0, userInput.length() - 1);
    }
  } else if (key >= '0' && key <= '9') {
    // Only accept numbers
    userInput += key;
  }
}
