// =========================
// (2) HomePage_SelectMode.pde
// Modern, sleek "Halo Heart Incorporated" landing screen.
// Keeps same functional navigation (Fitness/Calm/Stress).
// =========================

// Create buttons (same positions/labels, but modern sizing + spacing)
Button button1 = new Button(52, 220, 316, 54, "Start Workout");
Button button2 = new Button(52, 288, 316, 54, "Relaxation");
Button button3 = new Button(52, 356, 316, 54, "Stress");

void mousePressedSelect() {
  // Keep functional behavior exactly: click => change page
  if (button1.isClicked()) {
    println(button1.label + " clicked!");
    page = Page.EXERCISE_PAGE;
  } else if (button2.isClicked()) {
    println(button2.label + " clicked!");
    page = Page.CALM_MUSIC;
  } else if (button3.isClicked()) {
    println(button3.label + " clicked!");
    page = Page.STRESS_PAGE;
  }
}

void drawSelectPage() {
  // Solid background
  background(BG);

  // --- Light blue arc / glow (your existing look)
  noStroke();
  for (int i = 0; i < 60; i++) {
    float a = map(i, 0, 59, 26, 0);
    fill(120, 170, 255, a);
    ellipse(width * 0.5, 0, width * 1.3, 220 - i*2);
  }

  // --- GOLD LINING between light and dark (bottom edge of the arc)
  // We approximate the boundary as the last (smallest) ellipse in the loop.
  // If you change the glow sizes, just tweak goldYShift / goldH.
  float cx = width * 0.5;
  float goldW = width * 1.3;
  float goldH = 220 - 59*2;   // matches the last ellipse height
  float goldY = 0;            // same center as your ellipses
  float goldYShift = 0;       // move +/- a few px if needed

  // glow stroke
  noFill();
  stroke(212, 175, 55, 120); // gold w/ transparency
  strokeWeight(8);
  ellipse(cx, goldY + goldYShift, goldW, goldH);

  // crisp stroke
  stroke(212, 175, 55);      // #D4AF37
  strokeWeight(3);
  ellipse(cx, goldY + goldYShift, goldW, goldH);

  // --- Title + subtitle (unchanged)
  noStroke();
  fill(TEXT_MAIN);
  textFont(fontTitle);
  textSize(30);
  text("Heart Halo", width/2, 105);

  fill(TEXT_SUB);
  textFont(fontUI);
  textSize(14);
  text("Choose A Mode To Begin", width/2, 138);

  // --- Buttons (unchanged)
  button1.update();
  button2.update();
  button3.update();

  button1.display();
  button2.display();
  button3.display();

  // Footer hint (unchanged)
  fill(140, 148, 168);
  textSize(12);
  text("Fitness • Relaxation • Stress", width/2, 188);
}
