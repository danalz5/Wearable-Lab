int stressTimerStart = 0;
int stressTimerDuration = 60;  // 60 seconds
boolean stressTimerRunning = false;

void drawStressModePage() {
  // Start timer when page loads
  if (!stressTimerRunning) {
    stressTimerStart = millis();
    stressTimerRunning = true;
  }
  
  // Calculate remaining time
  int elapsed = (millis() - stressTimerStart) / 1000;
  int remaining = stressTimerDuration - elapsed;
  
  if (remaining > 0) {
    // Display header
    fill(0);
    textSize(48);
    text("Stress Mode", width/2, 100);
    
    // Display instruction text
    textSize(18);
    fill(80);
    text("Recall a time when you felt stressed", width/2, 180);
    
    // Display countdown timer
    fill(255, 0, 0);
    textSize(72);
    text(remaining, width/2, height/2 + 50);
    
    // Optional: Show "seconds remaining" text
    fill(100);
    textSize(16);
    text("seconds remaining", width/2, height/2 + 120);
    
  } else {
    // ===== PUT YOUR CODE HERE =====
    // This runs when the 60 second timer finishes
    
    println("Stress mode complete!");
    page = Page.SELECT_MODE;  // move to next page
    stressTimerRunning = false;  // reset timer
    
    // You could also:
    // - Save stress-related heart rate data
    // - Calculate average heart rate during stress
    // - Display stress results
    // - Compare calm vs stress heart rates
    
    // ==============================
  }
}

//FOR DEBUGGING ONLY
void keyPressedStress() {
  if (key == 's' || key == 'S') {
    println("Manually sending STRESS command");
    port.write("STRESS\n");
  }
}

void serialEventStress(Serial p) {
  final int offset = 5;
  
  //Get data from Serial
  String line = p.readStringUntil('\n');
  if (line == null) return;
  line = trim(line);
  if (line.length() == 0) return;
  println(line);
  
  // Parse heart rate data
  if (line.startsWith("HR:")) {
    float v = int(line.substring(3));
    
    //If the value is higher than expected
    if (v > baseHeartRate + offset) {
      println("User is STRESSED");
      p.write("STRESS\n");
    } else {
      println("User is Not Stressed");
    }
    println("Heart rate received: " + v);
  }
}
