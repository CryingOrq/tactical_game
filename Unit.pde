class unit {

  // Data
  int id;
  String fraction;
  PVector position;
  int move_points;
  String title = "Untitled";
  int delay = 0;

  // Stats
  int health = 10;
  int attack = 5;
  int speed = 5;
  float initiative = 5 * random(5);

  unit(PVector position, String fraction) {
    this.position = position;
    this.fraction = fraction;
  }

  // Main
  void update() {

    if (active_unit == this)
      if (delay == 0)
        active();
      else
        delay --;

    _draw();
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
    }
  }

  void _draw() {
    switch(fraction) {
    case "allies":
      fill(155, 255, 55);
      break;
    case "enemies":
      fill(255, 55, 55);
      break;
    }
    stroke(255);
    strokeWeight(1);
    rect(position.x * CELL_SIZE, position.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);

    fill(255);
    text(move_points, position.x * CELL_SIZE + 10, position.y * CELL_SIZE + 10);

    if (active_unit == this) {
      fill(255, 255, 255, 0);
      stroke(255, 255, 255, 200 + sin(global_timer / 10) * 55);
      strokeWeight(5);
      rect(position.x * CELL_SIZE, position.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
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
    target.health -= attack;
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
  PVector direction = (target.position.copy().sub(unit.position)).normalize();
  direction = new PVector(round(direction.x), round(direction.y));
  PVector pot_position = unit.position.copy().add(direction);
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
