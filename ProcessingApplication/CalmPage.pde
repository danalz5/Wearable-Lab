import ddf.minim.*;

Minim minim;
AudioPlayer calmMusic;
boolean musicStarted = false;

void setupCalmPage() {
  minim = new Minim(this);
  calmMusic = minim.loadFile("Lofi Music.mp3"); // put this in the sketch /data folder
}

void drawCalmPage() {
  background(200, 220, 255);

  // Title
  fill(0);
  textSize(48);
  text("Calm Page", width/2, height/2 - 50);

  // Start music once
  if (!musicStarted) {
    calmMusic.play();
    musicStarted = true;
  }

  // Optional: Show music progress
  fill(60);
  textSize(16);
  int position = calmMusic.position() / 1000;
  int length   = calmMusic.length() / 1000;
  text("Time: " + position + " / " + length + " seconds", width/2, height/2 + 50);

  // Reuse the SAME back-to-menu button (created in ProcessingAPP)
  backToMenuBtn.update();
  backToMenuBtn.display();
}

// Called from ProcessingAPP.serialEvent(...) when page == CALM_MUSIC
void serialEventCalmHelper(Serial p) {
  String line = p.readStringUntil('\n');
  int offset = 5;

  if (line == null) return;
  line = trim(line);
  if (line.length() == 0) return;

  if (line.startsWith("HR:")) {
    float v = int(line.substring(3));

    if (v <= baseHeartRate + offset) {
      println("Heart rate is calm");
    } else {
      println("Heart rate is NOT calm");
    }
    println("Heart rate received: " + v);
  }
}

// Called from ProcessingAPP when user presses Back to Menu on Calm page
void stopCalmAudio() {
  if (calmMusic != null) {
    calmMusic.pause();
    calmMusic.rewind();
  }
  musicStarted = false;
}

// Keep your stop() if you already have it (or add this once)
void stop() {
  if (calmMusic != null) calmMusic.close();
  if (minim != null) minim.stop();
  super.stop();
}
