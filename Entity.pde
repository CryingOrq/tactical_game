// A base class for all objects and units on the battlefield

class entity {

  // Data
  String title = "Untitled";
  String fraction;
  int level = 0;

  PVector grid_position;

  int delay = 0;

  // Stats
  int attack = 0;
  int health = 0;
  int speed = 0;
  int power = 0;
  int init = 0;

  int current_health = health;
  int init_roll;
  int move_points;

  entity(String title, String fraction, int level, int attack, int health, int speed, int power, int init) {
    this.title = title;
    this.fraction = fraction;
    this.level = level;
    this.attack = attack;
    this.health = health;
    this.speed = speed;
    this.power = power;
    this.init = init;
    grid_position = new PVector(5, 5);
  }

  // Main
  void update(PVector origin) {

    if (active_unit == this)
      if (delay == 0)
        active(origin);
      else
        delay --;
  }

  // // //
  void active(PVector origin) {
    switch(fraction) {
    case "Party":
      control_input(origin);
      break;
    case "Enemies":
      control_ai();
      break;
    case "Objects":
      break;
    }
  }

  void draw(PVector origin) {

    PVector position = origin.copy().add(grid_position.copy().mult(CELL_SIZE));
    // Draw unit
    switch(fraction) {
    case "Party":
      fill(155, 255, 55);
      break;
    case "Enemies":
      fill(255, 55, 55);
      break;
    }
    stroke(0);
    strokeWeight(1);
    rect(position.x, position.y, CELL_SIZE, CELL_SIZE);

    // Draw health bar
    if (current_health < health) {
      fill(0);
      rect(position.x, position.y + CELL_SIZE - 8, CELL_SIZE, 8);
      float healthbar_length_mod = float(current_health) / health;
      fill(255 - 255 * healthbar_length_mod, 255 * healthbar_length_mod, 0);
      rect(position.x, position.y + CELL_SIZE - 8, CELL_SIZE * healthbar_length_mod, 8);
    }
    //fill(255);
    //textSize(32);
    //text(move_points, grid_position.x * CELL_SIZE + 14, grid_position.y * CELL_SIZE + 32);
  }

  void action(PVector direction) {
    float[] angles = {0, PI / 4, -PI / 4, PI / 2, -PI / 2, 0, PI / 4, -PI / 4, PI / 2, -PI / 2};
    boolean attack_objects = false;

    for (int i = 0; i < angles.length; i++) {
      println(i);
      PVector modified_dir = direction.copy().rotate(angles[i]);
      PVector offset = new PVector(round(modified_dir.x), round(modified_dir.y));
      PVector pot_position = grid_position.copy().add(offset);
      entity collider = check_collision(pot_position);
      if (collider == null) {
        move(pot_position);
        return;
      } else if (collider.fraction != fraction) {
        attack(collider);
        return;
      }
      //else{
      //  bump();
      //  return;
      //}
    }
  }

  void move(PVector new_position) {
    println("MOVE");
    grid_position = new_position;
    move_points --;
    if (move_points <= 0)
      next_unit();
    delay = 15;
  }

  void attack(entity target) {
    println("ATTACK!");
    target.health -= roll() + attack;
    list_floating_text.add(new floating_text(str(attack), target.grid_position.copy()));
    if (target.health <= 0)
      target.die();
    move_points --;
    if (move_points <= 0)
      next_unit();
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
    for (int i = 0; i < party.size(); i++)
      if (party.get(i) == this)
        party.remove(i);
    for (int i = 0; i < enemies.size(); i++)
      if (enemies.get(i) == this)
        enemies.remove(i);
  }

  void start_battle() {
    init_roll = roll() + init;
    move_points = speed;
  }







  void control_input(PVector origin) {
    PVector direction = new PVector(0, 0);
    if (keyPressed)
      switch(key) {
      case 'w':
        direction.y -= 1;
        break;
      case 'e':
        direction.x += 1;
        direction.y -= 1;
        break;
      case 'd':
        direction.x += 1;
        break;
      case 'c':
        direction.x += 1;
        direction.y += 1;
        break;
      case 'x':
        direction.y += 1;
        break;
      case 'z':
        direction.x -= 1;
        direction.y += 1;
        break;
      case 'a':
        direction.x -= 1;
        break;
      case 'q':
        direction.x -= 1;
        direction.y -= 1;
        break;


      case ' ':
        next_unit();
        break;
      }

    if (mousePressed) {
      println("PRESSED");
      direction = (pixel_to_grid(new PVector(mouseX, mouseY).sub(origin)).sub(grid_position)).normalize();
      direction = new PVector(round(direction.x), round(direction.y));
    }


    if (direction.mag() == 0)
      return;

    action(direction);
  }

  void control_ai() {
    // Find target
    ArrayList<entity> targets = new ArrayList<entity>();
    entity target = null;
    // Define enemies' list
    switch(fraction) {
    case "Party":
      targets = enemies;
      break;
    case "Enemies":
      targets = party;
      break;
    }
    // Find the nearest enemy
    for (int i = 0; i < targets.size(); i++) {
      if (target == null)
        target = targets.get(i);
      else
        if (grid_position.dist(targets.get(i).grid_position) < grid_position.dist(target.grid_position))
          target = targets.get(i);
    }
    if (target == null)  // No target
      return;

    // Calc direction


    PVector direction = (target.grid_position.copy().sub(grid_position)).normalize();

    action(direction);
    //direction = new PVector(round(direction.x), round(direction.y));
    //PVector pot_position = unit.position.copy().add(direction);
  }
}

entity check_collision(PVector grid_position) {
  entity unit = null;
  for (int i = 0; i < units.size(); i++)
    if (grid_position.x == units.get(i).grid_position.x && grid_position.y == units.get(i).grid_position.y)
      unit = units.get(i);
  return unit;
}
