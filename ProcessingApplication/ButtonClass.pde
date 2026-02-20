// =========================
// (3) Button.pde
// Modern button: hover lift + press scale + ripple pulse.
// Keeps isClicked() compatibility.
// =========================

class Button {
  int x, y, w, h;
  String label;

  // Theme
  color baseFill   = color(24, 30, 46);
  color hoverFill  = color(34, 44, 70);
  color textColor  = color(242, 244, 250);
  color strokeCol  = color(255, 255, 255, 22);

  // Animation state
  float lift = 0;            // 0..1 (hover)
  float press = 0;           // 0..1 (pressed)
  boolean isPressing = false;

  // Ripple
  float rippleT = 1;         // 0..1, where 1 means "inactive"
  float rippleX = 0;
  float rippleY = 0;

  Button(int x, int y, int w, int h, String label) {
    this.x = x; this.y = y; this.w = w; this.h = h;
    this.label = label;
  }

  void update() {
    // hover animation
    float targetLift = isMouseOver() ? 1 : 0;
    lift  = lerp(lift, targetLift, 0.14);

    // press animation (springy-ish)
    float targetPress = isPressing ? 1 : 0;
    press = lerp(press, targetPress, 0.22);

    // ripple progress
    if (rippleT < 1) {
      rippleT += 0.07;
      if (rippleT > 1) rippleT = 1;
    }
  }

  void display() {
    pushMatrix();

    // Press scale + hover lift
    float scaleAmt = 1.0 - 0.03 * press;
    float yLiftPx  = -6 * lift;

    // Center-based scaling
    translate(x + w/2, y + h/2 + yLiftPx);
    scale(scaleAmt);
    translate(-(x + w/2), -(y + h/2));

    // Drop shadow (soft)
    noStroke();
    fill(0, 0, 0, 90);
    rect(x + 2, y + 6, w, h, 14);

    // Button fill (interpolated)
    color c = lerpColor(baseFill, hoverFill, lift);
    fill(c);
    stroke(strokeCol);
    strokeWeight(1);
    rect(x, y, w, h, 14);

    // Ripple effect (only when active)
    if (rippleT < 1) {
      float r = lerp(0, max(w, h) * 1.2, rippleT);
      float a = lerp(90, 0, rippleT);
      noStroke();
      fill(120, 170, 255, a);
      ellipse(rippleX, rippleY, r, r);
      // clip-like look via overlay (simple, no real clipping)
      fill(c);
      rect(x, y, w, h, 14);
    }

    // Label
    fill(textColor);
    textFont(fontUI);
    textSize(18);
    textAlign(CENTER, CENTER);

    // Slight press down on text
    float textY = y + h/2 + 1.5 * press;
    text(label, x + w/2, textY);

    popMatrix();
  }

  boolean isMouseOver() {
    return mouseX > x && mouseX < x + w &&
           mouseY > y && mouseY < y + h;
  }

  boolean isClicked() {
    // preserves your existing behavior (called inside mousePressedSelect)
    return isMouseOver();
  }

  void onPress() {
    if (isMouseOver()) {
      isPressing = true;
      rippleT = 0;
      rippleX = mouseX;
      rippleY = mouseY;
    }
  }

  void onRelease() {
    isPressing = false;
  }
}
Button backToMenuBtn = new Button(55, 360, 320, 50, "Back to Menu");
