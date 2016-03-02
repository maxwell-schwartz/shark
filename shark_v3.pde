Side lside1, lside2, rside1, rside2;
Shark shark;
Tail tail;
ArrayList bubbles, food, enemies;
int counter_food, counter_enemy, highest;
int on_off, boost, flash, b, mode;
float change, up_down, wag_boost;

void setup() {
  size(300, 480);
  smooth();
  mode = 0;
  counter_food = 0;
  counter_enemy = 3;
  highest = 0;
  on_off = 0;
  boost = 0;
  flash = 0;
  change = 0;
  up_down = .5;
  wag_boost = 0;
  b = 50;
  lside1 = new Side(width/50, height/10, 0, 0);
  lside2 = new Side(width/50, height/10, 0, 0-height);
  rside1 = new Side(width/50, height/10, width-width/50, 0);
  rside2 = new Side(width/50, height/10, width-width/50, 0-height);
  shark = new Shark(width/2, height-height/15);
  tail = new Tail();
  
  // the ArrayList object is flexible
  bubbles = new ArrayList();
  for (int i = 0; i < 10; i++) {
    bubbles.add(new Bubble(width/random(25, 30), random(10, width-10),
    random(10-height, height)));
  }
  food = new ArrayList();
  for (int i = 0; i < 10; i++) {
    food.add(new Food(random(10, width-10),
    0-random(10, height)));
  }
  enemies = new ArrayList();
  for (int i = 0; i < 10; i++) {
    enemies.add(new Enemy(random(10, width-10),
    0-random(10, height)));
  }
}

void draw() {
  background(160+flash, 230, 255);
  
  if (mode == 0) {
    start_screen();
  } else if (mode == 1) {
    game_play();
    if ((counter_enemy == 0) && (flash < 1)) {
      if (counter_food > highest) {
        highest = counter_food;
      }
      mode = 2;
    }
  } else if (mode == 2) {
    end_screen();
  }
}

void start_screen() {
  // create each bubble in the ArrayList
  for (int i = 0; i < bubbles.size(); i++) {
    Bubble bub = (Bubble) bubbles.get(i);
    bub.display();
    bub.move();
  }
  fill(200, 0, 255);
  textSize(height/10);
  textAlign(CENTER, BOTTOM);
  text("Sharky", width/2, height/6);
  fill(255, 0, b);
  rect(width/4, height/3, width/2, height/6, 10);
  fill(0, 0, 100);
  textSize(height/12);
  text("Start", width/2, height/2.2);
  fill(0, 100, 0);
  textSize(height/30);
  text("Cursor to move.", width/2, height/1.8);
  fill(0, 180, 0);
  text("Space to boost.", width/2, height/1.8 + height/25);
  fill(0, 100, 0);
  text("Eat the goldfish.", width/2, height/1.8 + height/12.5);
  fill(0, 180, 0);
  text("Avoid the urchins.", width/2, height/1.8 + height/8.33);
  fill(0, 100, 0);
  text("Pop the bubbles for fun.", width/2, height/1.8 + height/6.25);
  fill(75, 0, 255);
  textSize(height/40);
  textAlign(LEFT, BOTTOM);
  text("By Max Schwartz", 5, height-1);
  textAlign(RIGHT, BOTTOM);
  text("Built with Processing", width-5, height-1);
}

void game_play() {
  // create and move the side bars to mimic moving forward
  lside1.display();
  lside2.display();
  rside1.display();
  rside2.display();
  
  lside1.move();
  lside2.move();
  rside1.move();
  rside2.move();
  
  shark.display();
  tail.display();
  shark.move();
  
  // create each bubble in the ArrayList
  for (int i = 0; i < bubbles.size(); i++) {
    Bubble bub = (Bubble) bubbles.get(i);
    bub.display();
    bub.move();
  }
  
  // create all the food
  for (int i = 0; i < food.size(); i++) {
    Food f = (Food) food.get(i);
    f.display();
    f.move();
  }
  
  // create the enemies
  for (int i = 0; i < enemies.size(); i++) {
    Enemy en = (Enemy) enemies.get(i);
    en.display();
    en.move();
  }

  // display the score and lives
  textAlign(CENTER, CENTER);
  textSize(width/20);
  fill(170, 0, 220);
  text("Points: " + counter_food, width/2, 20);
  fill(255, 50, 0);
  text("Lives: " + counter_enemy, width/2, 45);
  
  // every 10 food eaten, a new enemy is added
  if ((counter_food%10 == 0) && (counter_food != 0)) {
    if (on_off%2 == 0) {
      on_off += 1;
      // this is how to add to an ArrayList
      enemies.add(new Enemy(random(10, width-10),
      0-random(10, height)));
    } 
    // this is how to fix the mod problem where it kept adding
  } else if ((counter_food%10 == 1) && (counter_food != 1) && (on_off%2 != 0)){
    on_off += 1;
  }
  
  if (flash > 0) {
    flash -= 10;
  }
  
  if (change == 5) {
   up_down = -.5-wag_boost;
  } else if (change == -5) {
   up_down = .5+wag_boost;
  }
  change += up_down;
}

class Side {
  float w; // width of side bar
  float h; // height of each box in side bar
  float xPos; // position the bar on the right or left
  float yPos; // bars moving down
  
  Side(float iw, float ih, float ixp, float iyp) {
    w = iw;
    h = ih;
    xPos = ixp;
    yPos = iyp;
  }
  
  void move() {
    yPos += 2+boost;
    if (yPos > height) {
      yPos = 0 - height;
    }
  }
  
  void display() {
    noStroke();
    fill(0, 245, 255);
    for (int i=0; i<10; i++) {
      rect(xPos, yPos+(i*width/5), w, h);
    }
  }
}

class Shark {
  float w, h, xPos, yPos;
  
  Shark(float ixp, float iyp) {
    w = width/20;
    h = width/8;
    xPos = ixp;
    yPos = iyp;
  }
  
  void display() {
    noStroke();
    fill(0, 50, 80);
    ellipse(xPos, yPos, w, h);
    triangle(xPos, yPos-height/35, xPos, yPos+height/45, xPos-width/20,
            yPos+height/35);
    triangle(xPos, yPos-height/35, xPos, yPos+height/45, xPos+width/20,
            yPos+height/35);
  }
  
  void move() {
    if (xPos < mouseX) {
      xPos += (mouseX - xPos)/8;
    } else if (xPos > mouseX){
      xPos -= (xPos - mouseX)/8;
    }
  }
}

class Tail {
  float x2, x3, y2, y3;
  
  Tail() {
  }
  
  void display() {
    x2 = shark.xPos-width/40+change;
    x3 = shark.xPos+width/40+change;
    y2 = shark.yPos+height/20;
    y3 = shark.yPos+height/20;
    triangle(shark.xPos, shark.yPos+height/45, x2, y2, x3, y3);
  }
}

class Bubble {
  float w, xPos, yPos, g;
  
  Bubble(float iw, float ixp, float iyp) {
    w = iw;
    xPos = ixp;
    yPos = iyp;
    g = int(40 + random(215));
  }
  
  void display() {
    strokeWeight(2);
    stroke(20, g, 180);
    fill(240, 240, 255);
    ellipse(xPos, yPos, w, w);
  }
  
  void move() {
    // collision detection
    if (((shark.xPos - shark.w/2) < (xPos+w/1.5)) 
        && ((shark.xPos + shark.w/2) > (xPos-w/1.5))
        && ((shark.yPos - shark.h/2) < (yPos+w)) 
        && ((shark.yPos - shark.h/2) > (yPos-w))) {
      w = width/random(25, 30);
      yPos = 0-random(10, height);
      xPos = random(10, width-10);
      g = int(40 + random(215));
    }
    yPos += 2+boost;
    if (yPos > height+2*int(w)) {
      w = width/random(25, 30);
      yPos = 0-random(10, height);
      xPos = random(10, width-10);
      g = int(40 + random(215));
    }
  }
}

class Food {
  float w, h, xPos, yPos;
  
  Food(float ixp, float iyp) {
    w = width/35;
    h = width/20;
    xPos = ixp;
    yPos = iyp;
  }
  
  void display() {
    noStroke();
    fill(255, 200, 0);
    ellipse(xPos, yPos, w, h);
    triangle(xPos, yPos-height/100, xPos-width/45, yPos-height/40,
            xPos+width/45, yPos-height/40);
  }
  
  void move() {
    // collision detection, mouth oriented
    if (((shark.xPos - shark.w/2) < (xPos+w/1.5)) 
        && ((shark.xPos + shark.w/2) > (xPos-w/1.5))
        && ((shark.yPos - shark.h/2) < (yPos+w)) 
        && ((shark.yPos - shark.h/2) > (yPos-w))) {
      counter_food += 1;
      yPos = 0-random(10, height);
      xPos = random(10, width-10);
    }
    yPos += 4+boost;
    if (yPos > height+2*int(w)) {
      yPos = 0-random(10, height);
      xPos = random(10, width-10);
    }
  }
}

class Enemy {
  float xPos, yPos, x2, y2;
  
  Enemy(float ixp, float iyp) {
    xPos = ixp;
    yPos = iyp;
    x2 = xPos+4;
    y2 = yPos+4;
  }
  
  void display() {
    noStroke();
    fill(50, 50, 0);
    triangle(xPos, yPos, x2, y2, xPos-width/20, yPos);
    triangle(xPos, yPos, x2, y2, xPos+width/20, yPos);
    triangle(xPos, yPos, x2, y2, xPos, yPos-width/20);
    triangle(xPos, yPos, x2, y2, xPos, yPos+width/20);
    triangle(xPos-2, yPos, x2+2, yPos, x2-width/25, yPos-width/25);
    triangle(xPos, yPos, x2, y2, xPos-width/25, yPos+width/25);
    triangle(xPos, yPos, x2, y2, xPos+width/25, yPos-width/25);
    triangle(xPos+2, yPos, x2-2, y2, xPos+width/25, yPos+width/25);;
  }
  
  void move() {
    // collision detection
    if (((shark.xPos - shark.w/2) < (xPos+width/25)) 
        && ((shark.xPos + shark.w/2) > (xPos-width/25))
        && ((shark.yPos - shark.h/2) < (yPos+width/25)) 
        && ((shark.yPos - shark.h/2) > (yPos-width/25))) {
      flash = 95;
      if (counter_enemy > 0) {
        counter_enemy -= 1;
      }
      yPos = 0-random(10, height);
      y2 = yPos+4;
      xPos = random(10, width-10);
      x2 = xPos+4;
    } else if (((shark.xPos - shark.w/2) < (xPos+width/25)) 
              && ((shark.xPos + shark.w/2) > (xPos-width/25))
              && ((shark.yPos) < (yPos+width/25)) 
              && ((shark.yPos) > (yPos-width/25))) {
       flash = 95;
       if (counter_enemy > 0) {
         counter_enemy -= 1;
       }
       yPos = 0-random(10, height);
       y2 = yPos+4;
       xPos = random(10, width-10);
       x2 = xPos+4;
     }
    yPos += 1+boost;
    y2 += 1+boost;
    if (yPos > height+width/20) {
      yPos = 0-random(10, height);
      y2 = yPos+4;
      xPos = random(10, width-10);
      x2 = xPos+4;
    }
  }
}

void end_screen() {
  // create each bubble in the ArrayList
  for (int i = 0; i < bubbles.size(); i++) {
    Bubble bub = (Bubble) bubbles.get(i);
    bub.display();
    bub.move();
  }
  textSize(height/11);
  fill(255, 50, 0);
  textAlign(CENTER, BOTTOM);
  text("Game Over", width/2, height/4);
  fill(255, 0, b);
  rect(width/4, height/3, width/2, height/6, 10);
  fill(0, 0, 100);
  textSize(height/12);
  text("Start", width/2, height/2.2);
  textSize(height/30);
  fill(20, 80, 20);
  text("Score: " + counter_food, width/2, height - height/2.5);
  fill(80, 150, 20);
  text("Highest: " + highest, width/2, height - height/3);
}

void mousePressed() {
  if ((mouseX > width/4) && (mouseX < width-width/4)
      && (mouseY > height/3) && (mouseY < height/3 + height/6)) {
    if ((mode == 0) || (mode == 2)) {
      b = 100;
    }
  } 
}

void mouseReleased() {
  if ((mouseX > width/4) && (mouseX < width-width/4)
      && (mouseY > height/3) && (mouseY < height/3 + height/6)) {
        if (mode == 0) {
          b = 50;
          mode = 1;
        } else if (mode == 2) {
            counter_food = 0;
            counter_enemy = 3;
            on_off = 0;
            boost = 0;
            flash = 0;
            change = 0;
            up_down = .5;
            b = 50;
            lside1 = new Side(width/50, height/10, 0, 0);
            lside2 = new Side(width/50, height/10, 0, 0-height);
            rside1 = new Side(width/50, height/10, width-width/50, 0);
            rside2 = new Side(width/50, height/10, width-width/50, 0-height);
            shark = new Shark(width/2, height-height/15);
            tail = new Tail();
            
            food = new ArrayList();
            for (int i = 0; i < 10; i++) {
              food.add(new Food(random(10, width-10),
              0-random(10, height)));
            }
            enemies = new ArrayList();
            for (int i = 0; i < 10; i++) {
              enemies.add(new Enemy(random(10, width-10),
              0-random(10, height)));
            }
            mode = 1;
        }
      } else {
        b = 50;
      }
}

void keyPressed() {
  if (key == ' ') {
    boost = 2;
    wag_boost = .5;
  } 
}

void keyReleased() {
  boost = 0;
  wag_boost = 0;
}