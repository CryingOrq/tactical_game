class unit {

  // Data
  String title = "Untitled";
  String fraction;
  int level = 1;

  PVector position;
  int move_points;
  int init_roll;
  int delay = 0;

  // Stats
  int attack = 5;
  int health = 5;
  int speed = 5;
  int power = 5;
  int init = 5;

  int max_health = health;

  unit(String title, String fraction, int level, int attack, int health, int speed, int power, int init) {
    this.title = title;
    this.fraction = fraction;
    this.level = level;
    this.attack = attack;
    this.health = health;
    this.speed = speed;
    this.power = power;
    this.init = init;
  }

  // Main
  void update() {

    if (active_unit == this)
      if (delay == 0)
        active();
      else
        delay --;

    draw();
  }

  // // //
  void active() {
    switch(fraction) {
    case "allies":
      control_input(this);
      break;
    case "enemies":
      control_ai(this);
      break;
    case "objects":
      break;
    case "walls":
      break;
    }
  }

  void draw() {

    // Draw unit
    switch(fraction) {
    case "allies":
      fill(155, 255, 55);
      break;
    case "enemies":
      fill(255, 55, 55);
      break;
    }
    stroke(0);
    strokeWeight(1);
    rect(position.x * CELL_SIZE, position.y * CELL_SIZE, CELL_SIZE, CELL_SIZE
      );

    // Draw health bar
    if (health < max_health) {
      fill(0);
      rect(position.x * CELL_SIZE, position.y * CELL_SIZE + CELL_SIZE - 8, CELL_SIZE, 8);
      float healthbar_length_mod = float(health) / max_health;
      fill(255 - 255 * healthbar_length_mod, 255 * healthbar_length_mod, 0);
      rect(position.x * CELL_SIZE, position.y * CELL_SIZE + CELL_SIZE - 8, CELL_SIZE * healthbar_length_mod, 8);
    }
    fill(255);
    textSize(32);
    text(move_points, position.x * CELL_SIZE + 14, position.y * CELL_SIZE + 32);
  }

  void move(PVector new_position) {
    println("MOVE");
    position = new_position;
    move_points --;
    if (move_points <= 0)
      next_unit();
    delay = 15;
  }

  void attack(unit target) {
    println("ATTACK!");
    target.health -= roll() + attack;
    move_points --;
    if (move_points <= 0)
      next_unit();
    list_floating_text.add(new floating_text(str(attack), target.position.copy()));
    if (target.health <= 0)
      target.die();
    delay = 15;
  }

  void bump() {
    println("BUMP");
    delay = 15;
    if (fraction == "enemies")
      next_unit();
  }

  void die() {
    println(title + " is killed");
    if (active_unit == this)
      next_unit();
    units.remove(get_unit_n(this));
    for (int i = 0; i < allies.size(); i++)
      if (allies.get(i) == this)
        allies.remove(i);
    for (int i = 0; i < enemies.size(); i++)
      if (enemies.get(i) == this)
        enemies.remove(i);
  }
}

int get_unit_n(unit unit) {
  int n = 0;
  for (int i = 0; i < units.size(); i++)
    if (units.get(i) == unit)
      n = i;
  return n;
}

void control_input(unit unit) {
  PVector direction = new PVector(0, 0);
  if (keyPressed)
    switch(key) {
    case 'w':
      direction.y -= 1;
      break;
    case 'a':
      direction.x -= 1;
      break;
    case 's':
      direction.y += 1;
      break;
    case 'd':
      direction.x += 1;
      break;
    case ' ':
      next_unit();
      break;
    }

  if (mousePressed) {
    direction = (pixel_to_grid(new PVector(mouseX, mouseY)).sub(unit.position)).normalize();
    direction = new PVector(round(direction.x), round(direction.y));
  }


  if (direction.mag() == 0)
    return;

  PVector pot_position = unit.position.copy().add(direction);
  unit collider = check_collision(pot_position);
  if (collider == null)
    unit.move(pot_position);
  else if (collider.fraction != unit.fraction)
    unit.attack(collider);
  else
    unit.bump();
}

void control_ai(unit unit) {
  // Find target
  ArrayList<unit> targets = new ArrayList<unit>();
  unit target = null;
  // Define enemies' list
  switch(unit.fraction) {
  case "allies":
    targets = enemies;
    break;
  case "enemies":
    targets = allies;
    break;
  }
  // Find the nearest enemy
  for (int i = 0; i < targets.size(); i++) {
    if (target == null)
      target = targets.get(i);
    else
      if (unit.position.dist(targets.get(i).position) < unit.position.dist(target.position))
        target = targets.get(i);
  }
  if (target == null)  // No target
    return;

  // Calc direction

  float[] angles = {0, PI / 4, -PI / 4, PI / 2, -PI / 2, 0, PI / 4, -PI / 4, PI / 2, -PI / 2};
  boolean attack_objects = false;
  PVector direction = (target.position.copy().sub(unit.position)).normalize();

  for (int i = 0; i < angles.length; i++) {
    PVector modified_dir = direction.rotate(angles[i]);
    PVector offset = new PVector(round(modified_dir.x), round(modified_dir.y));
    PVector pot_position = unit.position.copy().add(direction);
  }
  //direction = new PVector(round(direction.x), round(direction.y));
  //PVector pot_position = unit.position.copy().add(direction);
  unit collider = check_collision(pot_position);
  if (collider == null)
    unit.move(pot_position);
  else if (collider.fraction != unit.fraction)
    unit.attack(collider);
  else
    unit.bump();
}

unit check_collision(PVector position) {
  unit unit = null;
  for (int i = 0; i < units.size(); i++)
    if (position.x == units.get(i).position.x && position.y == units.get(i).position.y)
      unit = units.get(i);
  return unit;
}
