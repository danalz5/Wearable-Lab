//Button class to make it easier to manage multiple buttons
class Button {
  int x, y, w, h;
  String label;
  color normalColor, hoverColor;
  
  Button(int x, int y, int w, int h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.normalColor = color(80, 150, 80);
    this.hoverColor = color(100, 180, 100);
  }
  
  void display() {
    // Check if mouse is hovering
    boolean hover = isMouseOver();
    
    // Draw button
    if (hover) {
      fill(hoverColor);
    } else {
      fill(normalColor);
    }
    
    rect(x, y, w, h, 10);  // rounded corners
    
    // Draw text
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(18);
    text(label, x + w/2, y + h/2);
  }
  
  boolean isMouseOver() {
    return mouseX > x && mouseX < x + w &&
           mouseY > y && mouseY < y + h;
  }
  
  boolean isClicked() {
    return isMouseOver();
  }
}
