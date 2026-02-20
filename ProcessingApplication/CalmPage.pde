import ddf.minim.*;
import processing.serial.*;

// --- Existing Global Variables ---
Minim minim;
AudioPlayer calmMusic;
boolean musicStarted = false;

// Variables used by the original functions (ensure these are in your main sketch)
float baseHeartRate = 70; 
float lastMeasuredHR = 0;
float startExercise = 1; // Used in your serial check

void setup() {
  size(450, 500);
  setupCalmPage();
}

void draw() {
  drawCalmPage();
}

void setupCalmPage() {
  // Initialize Minim
  minim = new Minim(this);
  
  // Load your music file (put it in the sketch's "data" folder)
  calmMusic = minim.loadFile("Lofi Music.mp3");  
}

void drawCalmPage() {
  background(200, 220, 255);  // calm blue background
  
  // Display header
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(48);
  
  // Start music if not already started
  if (!musicStarted) {
    calmMusic.play();
    musicStarted = true;
  }
  
  // Logic: Check if we are in the 30-second measurement window
  int positionMillis = calmMusic.position();
  int secondsElapsed = positionMillis / 1000;

  if (secondsElapsed < 30) {
    // Phase 1: Measuring
    text("Calming...", width/2, height/2 - 50);
    
    textSize(20);
    text("Measuring Heart Rate: " + secondsElapsed + " / 30s", width/2, height/2 + 20);
    
    // Optional progress bar
    stroke(0);
    noFill();
    rect(width/2 - 100, height/2 + 50, 200, 10);
    fill(100, 150, 255);
    rect(width/2 - 100, height/2 + 50, map(secondsElapsed, 0, 30, 0, 200), 10);
  } else {
    // Phase 2: Results Display (After 30 seconds)
    text("Results", width/2, height/2 - 80);
    
    textSize(22);
    fill(50);
    text("Base Heart Rate: " + int(baseHeartRate) + " BPM", width/2, height/2 - 10);
    
    // Display the most recent measured HR
    text("Measured Calm HR: " + int(lastMeasuredHR) + " BPM", width/2, height/2 + 30);
    
    // Success/Failure feedback
    textSize(18);
    if (lastMeasuredHR <= baseHeartRate + 5) {
      fill(0, 120, 0); // Green
      text("Success: You reached a calm state!", width/2, height/2 + 80);
    } else {
      fill(150, 0, 0); // Red
      text("Heart rate still high. Keep breathing.", width/2, height/2 + 80);
    }
  }
  
  // Check if music has ended
  if (!calmMusic.isPlaying() && musicStarted) {
    println("Music finished! Moving to next page...");
    musicStarted = false;
  }
  
  // Show music progress (Original logic)
  fill(100);
  textSize(14);
  int position = calmMusic.position() / 1000;
  int length = calmMusic.length() / 1000;
  text("Music Time: " + position + " / " + length + " seconds", width/2, height - 30);
}

void serialEventCalm(Serial p) {
  String line = p.readStringUntil('\n');
  int offset = 5;
  
  // Original validation logic
  if (line == null || startExercise == 0) return;
  line = trim(line);
  if (line.length() == 0) return;
  
  // Parse heart rate data
  if (line.startsWith("HR:")) {
    float v = float(line.substring(3));
    lastMeasuredHR = v; // Store the value to display on screen
    
    // Comparison Logic: Check if calm based on the offset
    if (v <= baseHeartRate + offset) {
      println("Heart rate is calm: " + v);
    } else {
      println("Heart rate is NOT calm: " + v);
    }
  }
}

void stop() {
  // Always close Minim audio classes when done
  calmMusic.close();
  minim.stop();
  super.stop();
}
