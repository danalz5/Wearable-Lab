import ddf.minim.*;
import processing.serial.*;

// ---- Audio ----
Minim minim;
AudioPlayer calmMusic;
boolean musicStarted = false;

// ---- Calm timer ----
int calmTimerStart = 0;
int calmTimerDuration = 30;   // seconds
boolean calmTimerRunning = false;
boolean calmDone = false;

// ---- HR collection (like your BHR page) ----
ArrayList<Float> calmHeartRates = new ArrayList<Float>();
ArrayList<Integer> calmHeartTimes = new ArrayList<Integer>(); // elapsed seconds for each sample

int calmStartHR = 0;
int calmEndHR   = 0;

// How many seconds to average at the beginning + end
int START_WINDOW_SEC = 5;
int END_WINDOW_SEC   = 5;

void setupCalmPage() {
  minim = new Minim(this);
  calmMusic = minim.loadFile("Lofi Music.mp3"); // put in /data

  // reset session state each time Calm opens
  calmTimerRunning = false;
  calmDone = false;
  calmTimerStart = 0;

  calmHeartRates.clear();
  calmHeartTimes.clear();
  calmStartHR = 0;
  calmEndHR = 0;

  musicStarted = false;
}

void drawCalmPage() {
  background(200, 220, 255);

  // Start timer on first draw
  if (!calmTimerRunning) {
    calmTimerStart = millis();
    calmTimerRunning = true;
  }

  int elapsed = (millis() - calmTimerStart) / 1000;
  int remaining = max(0, calmTimerDuration - elapsed);

  // Title
  fill(0);
  textSize(48);
  text("Calm Mode", width/2, 100);

  // Start music once
  if (!musicStarted) {
    calmMusic.play();
    musicStarted = true;
  }

  // If timer still running: show countdown + (optional) live HR
  if (!calmDone) {
    fill(0);
    textSize(20);
    text("Relax and breathe…", width/2, 170);

    fill(0, 120, 255);
    textSize(72);
    text(remaining, width/2, 250);

    // Optional current HR
    fill(0);
    textSize(18);
    if (calmHeartRates.size() > 0) {
      int last = int(calmHeartRates.get(calmHeartRates.size() - 1));
      text("Current HR: " + last + " bpm", width/2, 330);
    } else {
      text("Current HR: —", width/2, 330);
    }

    // Timer ended -> compute start/end
    if (remaining == 0) {
      calmDone = true;
      calculateCalmStartEnd();
    }
  }
  // After timer ends: show start + end
  else {
    fill(0, 150, 0);
    textSize(40);
    text("Done!", width/2, 170);

    fill(0);
    textSize(22);
    text("Starting HR: " + calmStartHR + " bpm", width/2, 250);
    text("Ending HR:   " + calmEndHR   + " bpm", width/2, 290);

    textSize(16);
   
  }

  // Shared Back button
  backToMenuBtn.update();
  backToMenuBtn.display();
}

// Called from ProcessingAPP.serialEvent(...) when page == CALM_MUSIC
void serialEventCalmHelper(Serial p) {
  String line = p.readStringUntil('\n');
  if (line == null) return;
  line = trim(line);
  if (line.length() == 0) return;

  if (line.startsWith("HR:")) {
    String s = trim(line.substring(3));
    int v = parseInt(s);
    if (v == 0 && !s.equals("0")) return; // parse failed guard

    calmHeartRates.add(float(v));

    // store the elapsed second when this sample arrived
    int t = calmTimerRunning ? ((millis() - calmTimerStart) / 1000) : 0;
    calmHeartTimes.add(t);

    println("Calm HR received: " + v + " at t=" + t + "s");
  }
}

void calculateCalmStartEnd() {
  // If no data, keep zeros
  if (calmHeartRates.size() == 0) {
    calmStartHR = 0;
    calmEndHR = 0;
    return;
  }

  // Average samples in [0, START_WINDOW_SEC)
  calmStartHR = averageHrInWindow(0, START_WINDOW_SEC);

  // Average samples in (calmTimerDuration - END_WINDOW_SEC, calmTimerDuration]
  int startEndWindow = max(0, calmTimerDuration - END_WINDOW_SEC);
  calmEndHR = averageHrInWindow(startEndWindow, calmTimerDuration + 1);

  println("Calm startHR=" + calmStartHR + " endHR=" + calmEndHR);
}

int averageHrInWindow(int tStartInclusive, int tEndExclusive) {
  float total = 0;
  int count = 0;

  for (int i = 0; i < calmHeartRates.size(); i++) {
    int t = calmHeartTimes.get(i);
    if (t >= tStartInclusive && t < tEndExclusive) {
      total += calmHeartRates.get(i);
      count++;
    }
  }

  // Fallback: if no samples in that window, use overall average
  if (count == 0) {
    float all = 0;
    for (float hr : calmHeartRates) all += hr;
    return int(all / calmHeartRates.size());
  }

  return int(total / count);
}

// Called from ProcessingAPP when user presses Back to Menu on Calm page
void stopCalmAudio() {
  if (calmMusic != null) {
    calmMusic.pause();
    calmMusic.rewind();
  }
  musicStarted = false;

  // reset calm session so it re-captures next time
  calmTimerRunning = false;
  calmDone = false;
  calmTimerStart = 0;

  calmHeartRates.clear();
  calmHeartTimes.clear();
  calmStartHR = 0;
  calmEndHR = 0;
}

// Keep your stop() if you already have it (or add this once)
void stop() {
  if (calmMusic != null) calmMusic.close();
  if (minim != null) minim.stop();
  super.stop();
}
