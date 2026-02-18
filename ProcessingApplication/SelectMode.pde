// Create buttons
Button button1 = new Button(50, 180, 75, 50, "Fitness");
Button button2 = new Button(160, 180, 75, 50, "Calm");
Button button3 = new Button(275, 180, 75, 50, "Stress");

void mousePressedSelect() {
  if (button1.isClicked()) {
    println(button1.label + " clicked!");
    // Do something for button 1
    page = Page.EXERCISE_PAGE;
  } else if (button2.isClicked()) {
    println(button2.label + " clicked!");
    // Do something for button 2
    page = Page.CALM_MUSIC;
  } else if (button3.isClicked()) {
    println(button3.label + " clicked!");
    // Do something for button 3
    page = Page.STRESS_PAGE;
  }
}

//Or main menu page
void drawSelectPage() {
  background(255);
  
  // Draw title
  fill(0);
  textAlign(CENTER);
  textSize(32);
  text("BioHUB Application", width/2, 80);
  
  // Draw all buttons
  button1.display();
  button2.display();
  button3.display();
}
