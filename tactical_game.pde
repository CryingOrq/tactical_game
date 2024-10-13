int CELL_SIZE = 40;

ArrayList<unit> units = new ArrayList<unit>();
ArrayList<unit> allies = new ArrayList<unit>();
ArrayList<unit> enemies = new ArrayList<unit>();

ArrayList<floating_text> list_floating_text = new ArrayList<floating_text>();

unit active_unit = null;
//int move_delay = 0;
int global_timer = 0;


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
  test();
  global_timer ++;
  
  background(50, 50, 75);
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

  for (int n = 0; n < units.size(); n ++)
    units.get(n).update();

  for (int n = 0; n < list_floating_text.size(); n ++)
    list_floating_text.get(n).update();

}

void test() {
  //println("HELLO");
  if(keyPressed){
    print(key);
  }
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

PVector get_random_pos() {
  int x = floor(random(width / CELL_SIZE));
  int y = floor(random(height / CELL_SIZE));
  return new PVector(x, y);
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
