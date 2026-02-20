int stressTimerStart = 0;
int stressTimerDuration = 60;  // 60 seconds
boolean stressTimerRunning = false;

void drawStressModePage() {
  // Start timer when page loads
  if (!stressTimerRunning) {
    stressTimerStart = millis();
    stressTimerRunning = true;
  }

  // Reuse the SAME back-to-menu button (bottom)
  backToMenuBtn.update();
  backToMenuBtn.display();

  // Calculate remaining time
  int elapsed = (millis() - stressTimerStart) / 1000;
  int remaining = stressTimerDuration - elapsed;

  if (remaining > 0) {
    // Display header
    fill(255);
    textSize(48);
    text("Stress Mode", width/2, 100);

    // Display instruction text
    textSize(18);
    fill(255);
    text("Recall a time when you felt stressed", width/2, 180);

    // Display countdown timer
    fill(255, 60, 60);
    textSize(72);
    text(remaining, width/2, height/2 + 50);

    // Optional: Show "seconds remaining" text
    fill(255);
    textSize(16);
    text("seconds remaining", width/2, height/2 + 120);

  } else {
    println("Stress mode complete!");
    page = Page.SELECT_MODE;
    stressTimerRunning = false;
  }
}

// Called when user presses Back to Menu (so timer doesn't resume mid-way)
void resetStressTimer() {
  stressTimerRunning = false;
  stressTimerStart = 0;
}

// FOR DEBUGGING ONLY
void keyPressedStress() {
  if (key == 's' || key == 'S') {
    println("Manually sending STRESS command");
    if (port != null) port.write("STRESS\n");
  }
}

// Called from ProcessingAPP.serialEvent(...) when page == STRESS_PAGE
void serialEventStressHelper(Serial p) {
  final int offset = 5;

  String line = p.readStringUntil('\n');
  if (line == null) return;
  line = trim(line);
  if (line.length() == 0) return;
  println(line);

  if (line.startsWith("HR:")) {
    float v = int(line.substring(3));

    if (v > baseHeartRate + offset) {
      println("User is STRESSED");
      p.write("STRESS\n");
    } else {
      println("User is Not Stressed");
    }
    println("Heart rate received: " + v);
  }
}
