private static final int STRIPS = 20;
private static final int BACKWARDS_STRIPS = 5;
private static final int FORWARD_STRIPS = STRIPS - BACKWARDS_STRIPS;
private static final int LENGTH = 100;

private static final int WINDOW_WIDTH = 75;
private static final int WINDOW_HEIGHT = WINDOW_WIDTH; // Needs to be the same!
private static final int WINDOW_Y = 125;
private static final float PIXEL_RADIUS = 1.0f;

private int frame = LENGTH * STRIPS * 4;

void setup() {
  size(1520, 210); // WINDOW_Y + WINDOW_HEIGHT);
  background(0);
}

void draw() {
  renderAsBox();
  renderAsStrips();
}

void renderAsBoxCounter() {
  frame++;
  int strip = (frame / LENGTH) % STRIPS;
  int stripId = frame % LENGTH;
  
  set(strip, stripId, 0xffffffff);
}

int multiples = 5;
int currentIndex = 0;
void renderAsBox() {
  /* Perform a "prime seive" as a rendering technique */
  frame++;
  
  currentIndex += multiples;
  if (currentIndex > STRIPS * LENGTH) {
    currentIndex = 0;
    multiples++;
    if (multiples > 10) {
      multiples = 1;
      fillStroke(0);
      rect(0, 0, STRIPS, LENGTH);
    }
  }
  switch (multiples % 6) {
    case 0: fillStroke(0, 255, 0); break;
    case 1: fillStroke(255, 0, 0); break;
    case 2: fillStroke(0, 0, 255); break;
    case 3: fillStroke(255, 255, 0); break;
    case 4: fillStroke(0, 255, 255); break;
    case 5: fillStroke(255, 0, 255); break;
  }
  
  rect(currentIndex / LENGTH, currentIndex % LENGTH, 0, 0);
}

void renderAsStrips() {
  fill(get(0, 0));
  
  for (int x = 0; x < STRIPS; x++) {
    /* Fill up this strip */
    int[] ps = new int[LENGTH];
    for (int i = 0; i < ps.length; i++) {
      ps[i] = get(x, i);
    }
    /* Is this window backwards? */
    boolean backwards = x > FORWARD_STRIPS;
    
    /* Calculate the angle */
    int thetaX = x;
    if (backwards) {
      thetaX = FORWARD_STRIPS - (x % FORWARD_STRIPS) + 1;
    }
    float theta = -(PI / 4.0) * ((float)thetaX / (float)FORWARD_STRIPS);
    
    renderWindow(x * WINDOW_WIDTH, WINDOW_Y, ps, theta, backwards);
  }
}

void renderWindow(int x, int y, int[] colors, 
                  float theta, boolean backwards) {
  PVector start = new PVector(backwards ? (x + WINDOW_WIDTH) : x, y + WINDOW_HEIGHT);
  PVector dir   = new PVector(cos(theta), sin(theta)).mult(PIXEL_RADIUS);
  if (backwards) {
    dir.x *= -1;
  }
  
  for (int i = 0; i < colors.length; i++) {
    fill(colors[i]);
    stroke(colors[i]);
    ellipse(start.x, start.y, PIXEL_RADIUS, PIXEL_RADIUS);
    start.add(dir);
    if (start.x - x > WINDOW_WIDTH) {
      break;
    }
  }
}

private void fillStroke(int r, int g, int b){
  fill(r, g, b);
  stroke(r, g, b);
}

private void fillStroke(int c) {
  fill(c);
  stroke(c);
}