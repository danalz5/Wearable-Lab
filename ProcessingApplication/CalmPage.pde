import ddf.minim.*;

Minim minim;
AudioPlayer calmMusic;
boolean musicStarted = false;

int offset = 5;

void setupCalmPage() {
  // Initialize Minim
  minim = new Minim(this);
  
  // Load your music file (put it in the sketch's "data" folder)
  calmMusic = minim.loadFile("Lofi Music.mp3");  // change filename to your music file
}

void drawCalmPage() {
  background(200, 220, 255);  // calm blue background
  
  // Display header
  fill(0);
  textSize(48);
  text("Calm Page", width/2, height/2 - 50);
  
  // Start music if not already started
  if (!musicStarted) {
    calmMusic.play();
    musicStarted = true;
  }
  
  // Check if music has ended
  if (!calmMusic.isPlaying() && musicStarted) {
    // PUT YOUR CODE HERE - This runs when the music finishes
    println("Music finished! Moving to next page...");
    
    // Example: Move to next page
    // currentPage = Page.NEXT_PAGE;
    
    // Or call a function
    // onMusicFinished();
    
    // Reset flag to prevent repeated execution
    musicStarted = false;
  }
  
  // Optional: Show music progress
  fill(100);
  textSize(16);
  int position = calmMusic.position() / 1000;  // seconds
  int length = calmMusic.length() / 1000;      // seconds
  text("Time: " + position + " / " + length + " seconds", width/2, height/2 + 50);
}

void stop() {
  // Always close Minim audio classes when done
  calmMusic.close();
  minim.stop();
  super.stop();
}

void serialEventCalm(Serial p) {
  String line = p.readStringUntil('\n');
  
  //If the 
  if (line == null || !isNumeric(line) || startExercise == 0) return;
  line = trim(line);
  if (line.length() == 0) return;
  
  // Parse heart rate data
  if (line.startsWith("HR:")) {
    float v = int(line.substring(3));
    //If the value is higher than expected
    if (v > baseHeartRate + offset) {
      println("Heart rate is calm");
    } else {
      println("Heart rate is NOT calm");
    }
    println("Heart rate received: " + v);
  }
}
