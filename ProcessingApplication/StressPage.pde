import processing.serial.*;

// ---- Stress timer ----
int stressTimerStart = 0;
int stressTimerDuration = 60;   // seconds
boolean stressTimerRunning = false;
boolean stressDone = false;

// ---- HR collection (like your BHR page) ----
ArrayList<Float> stressHeartRates = new ArrayList<Float>();
ArrayList<Integer> stressHeartTimes = new ArrayList<Integer>(); // elapsed seconds for each sample

int stressStartHR = 0;
int stressEndHR   = 0;

// How many seconds to average at the beginning + end
int STRESS_START_WINDOW_SEC = 5;
int STRESS_END_WINDOW_SEC   = 5;

void drawStressModePage() {
  // Start timer when page loads
  if (!stressTimerRunning) {
    stressTimerStart = millis();
    stressTimerRunning = true;

    // reset session state each time Stress opens
    stressDone = false;
    stressHeartRates.clear();
    stressHeartTimes.clear();
    stressStartHR = 0;
    stressEndHR = 0;
  }

  // Reuse the SAME back-to-menu button (bottom)
  backToMenuBtn.update();
  backToMenuBtn.display();

  // Calculate remaining time
  int elapsed = (millis() - stressTimerStart) / 1000;
  int remaining = max(0, stressTimerDuration - elapsed);

  // If timer still running: show countdown + (optional) live HR
  if (!stressDone) {
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
    text(remaining, width/2, height/2 + 50 );

    // Optional: Show "seconds remaining" text
    fill(255);
    textSize(16);
    text("seconds remaining", width/2, height/2 + 120);

    // Optional current HR
    
    // Timer ended -> compute start/end
    if (remaining == 0) {
      stressDone = true;
      calculateStressStartEnd();
    }
  }
  // After timer ends: show start + end
  else {
    fill(255);
    textSize(40);
    text("Done!", width/2, 170);

    fill(255);
    textSize(22);
    text("Starting HR: " + stressStartHR + " bpm", width/2, 250);
    text("Ending HR:   " + stressEndHR   + " bpm", width/2, 290);

    textSize(16);
   
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
    String s = trim(line.substring(3));
    int v = parseInt(s);
    if (v == 0 && !s.equals("0")) return; // parse failed guard

    stressHeartRates.add(float(v));

    // store the elapsed second when this sample arrived
    int t = stressTimerRunning ? ((millis() - stressTimerStart) / 1000) : 0;
    stressHeartTimes.add(t);

    if (v > baseHeartRate + offset) {
      println("User is STRESSED");
      p.write("STRESS\n");
    } else {
      println("User is Not Stressed");
    }
    println("Heart rate received: " + v + " at t=" + t + "s");
  }
}

void calculateStressStartEnd() {
  // If no data, keep zeros
  if (stressHeartRates.size() == 0) {
    stressStartHR = 0;
    stressEndHR = 0;
    return;
  }

  // Average samples in [0, STRESS_START_WINDOW_SEC)
  stressStartHR = averageStressHrInWindow(0, STRESS_START_WINDOW_SEC);

  // Average samples in (stressTimerDuration - STRESS_END_WINDOW_SEC, stressTimerDuration]
  int startEndWindow = max(0, stressTimerDuration - STRESS_END_WINDOW_SEC);
  stressEndHR = averageStressHrInWindow(startEndWindow, stressTimerDuration + 1);

  println("Stress startHR=" + stressStartHR + " endHR=" + stressEndHR);
}

int averageStressHrInWindow(int tStartInclusive, int tEndExclusive) {
  float total = 0;
  int count = 0;

  for (int i = 0; i < stressHeartRates.size(); i++) {
    int t = stressHeartTimes.get(i);
    if (t >= tStartInclusive && t < tEndExclusive) {
      total += stressHeartRates.get(i);
      count++;
    }
  }

  // Fallback: if no samples in that window, use overall average
  if (count == 0) {
    float all = 0;
    for (float hr : stressHeartRates) all += hr;
    return int(all / stressHeartRates.size());
  }

  return int(total / count);
}

// Called when user presses Back to Menu (so timer doesn't resume mid-way)
void resetStressTimer() {
  stressTimerRunning = false;
  stressTimerStart = 0;

  stressDone = false;
  stressHeartRates.clear();
  stressHeartTimes.clear();
  stressStartHR = 0;
  stressEndHR = 0;
}
