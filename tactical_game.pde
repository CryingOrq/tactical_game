int CELL_SIZE = 40;

ArrayList<unit> units = new ArrayList<unit>();
ArrayList<unit> allies = new ArrayList<unit>();
ArrayList<unit> enemies = new ArrayList<unit>();

ArrayList<floating_text> list_floating_text = new ArrayList<floating_text>();

unit active_unit = null;
//int move_delay = 0;
int global_timer = 0;
int info_delay = 15;

void setup() {
  size(800, 600);

  int ally_amount = 5;
  int enemy_amount = 5;

  for (int n = 0; n < 5; n ++)
    allies.add(new unit(get_random_pos(), "allies"));
  for (int n = 0; n < 5; n ++)
    enemies.add(new unit(get_random_pos(), "enemies"));
  sort_units();
  next_unit();
}

void draw() {
  global_timer ++;

  background(50, 50, 75);

  // Draw grid
  int x = CELL_SIZE, y = CELL_SIZE;
  stroke(100);
  strokeWeight(1);
  while (x < width) {
    line(x, 0, x, height);
    x += CELL_SIZE;
  }
  while (y < height) {
    line(0, y, width, y);
    y += CELL_SIZE;
  }

  // Update units
  for (int n = 0; n < units.size(); n ++)
    units.get(n).update();

  // Active unit frame
  if (active_unit != null) {
    fill(255, 255, 255, 0);
    stroke(255, 255, 255, 200 + sin(global_timer / 10) * 55);
    strokeWeight(5);
    rect(active_unit.position.x * CELL_SIZE, active_unit.position.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
  }

  // Mouse pointer
  PVector mouse_pos = pixel_to_grid(new PVector(mouseX, mouseY));
  fill(255, 255, 255, 50 + sin(global_timer / 10) * 25);
  noStroke();
  rect(mouse_pos.x * CELL_SIZE, mouse_pos.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);

  // Draw info
  PVector info_size = new PVector(150, 200);
  unit unit = null;
  for (int i = 0; i < units.size(); i++) {
    if (mouse_pos.x == units.get(i).position.x && mouse_pos.y == units.get(i).position.y) {
      unit = units.get(i);
      break;
    }
  }
  if (unit != null) {
    if (info_delay > 0) {
      info_delay --;
      println(info_delay);
    } else {
      PVector position = new PVector(mouseX, mouseY);
      if (mouseX + info_size.x > width)
        position.x -= info_size.x;
      if (mouseY + info_size.y > height)
        position.y -= info_size.y;

      // pannel
      fill(0);
      rect(position.x, position.y, info_size.x + 2, info_size.y + 2);
      fill(55);
      rect(position.x, position.y, info_size.x, info_size.y);
      fill(35);
      rect(position.x + 4, position.y + 4, info_size.x - 8, info_size.y - 8);
      position.x += 16;
      position.y += 32;
      
      // title
      fill(0);
      textSize(24);
      text(unit.title, position.x + 2, position.y + 1);
      fill(255);
      text(unit.title, position.x, position.y);
      position.y += 8;
      
      // hp bar
      fill(0);
      rect(position.x, position.y, 80 + 2, 8 + 2);
      fill(0, 255, 0);
      float healthbar_length_mod = float(unit.health) / unit.max_health;
      rect(position.x, position.y, 80 * healthbar_length_mod, 8);
      position.y += 32;
      
      // stats
      textSize(16);
      fill(0);
      text("Attack " + unit.attack, position.x + 2, position.y + 1);
      fill(255);
      text("Attack " + unit.attack, position.x, position.y);
      position.y += 24;
      
      fill(0);
      text("Speed " + unit.speed, position.x + 2, position.y + 1);
      fill(255);
      text("Speed " + unit.speed, position.x, position.y);
      position.y += 24;
      
      fill(0);
      text("Initiative " + int(unit.initiative), position.x + 2, position.y + 1);
      fill(255);
      text("Initiative " + int(unit.initiative), position.x, position.y);
    }
  } else
    info_delay = min(info_delay + 1, 15);

  // Update floating text
  for (int n = 0; n < list_floating_text.size(); n ++)
    list_floating_text.get(n).update();
}

void sort_units() {
  ArrayList<unit> unsorted_units = new ArrayList<unit>();
  for (int n = 0; n < allies.size(); n ++)
    unsorted_units.add(allies.get(n));
  for (int n = 0; n < enemies.size(); n ++)
    unsorted_units.add(enemies.get(n));

  int i, j;
  unit temp;
  boolean swapped;
  for (i = 0; i < unsorted_units.size() - 1; i++) {
    swapped = false;
    for (j = 0; j < unsorted_units.size() - i - 1; j++) {
      if (unsorted_units.get(j).initiative > unsorted_units.get(j + 1).initiative) {

        // Swap arr[j] and arr[j+1]
        temp = unsorted_units.get(j);
        unsorted_units.set(j, unsorted_units.get(j + 1));
        unsorted_units.set(j + 1, temp);
        swapped = true;
      }
    }
    if (swapped == false)
      break;
  }
  units = unsorted_units;
}

void next_unit() {
  // Find the next unit
  if (active_unit != null) {
    int new_n = get_unit_n(active_unit) + 1;
    if (new_n >= units.size())
      new_n = 0;
    active_unit = units.get(new_n);
  } else
    // or select the first unit
    active_unit = units.get(0);

  active_unit.move_points = active_unit.speed;
  active_unit.delay = 15;
}
