// Lists of entities
ArrayList<entity> units = new ArrayList<entity>();     // All units sorted by using init roll
ArrayList<entity> party = new ArrayList<entity>();     // Party members
ArrayList<entity> enemies = new ArrayList<entity>();   // Enemies
ArrayList<entity> objects = new ArrayList<entity>();   // Map's objects

// Units and objects management methods

void create_party() {  // Create a new default party
  // create a delault party
  party.add(warrior());
  party.add(mage());
  party.add(priest());
  party.add(rogue());
}

void create_enemies() {
  for (int n = 0; n < 5; n ++) {
    enemies.add(human());
  }
}

void sort_units() {  // Sort units from Party and Enemies lists using init rolls
  ArrayList<entity> unsorted_units = new ArrayList<entity>();
  for (int n = 0; n < party.size(); n ++)
    unsorted_units.add(party.get(n));
  for (int n = 0; n < enemies.size(); n ++)
    unsorted_units.add(enemies.get(n));

  int i, j;
  entity temp;
  boolean swapped;
  for (i = 0; i < unsorted_units.size() - 1; i++) {
    swapped = false;
    for (j = 0; j < unsorted_units.size() - i - 1; j++) {
      if (unsorted_units.get(j).init_roll < unsorted_units.get(j + 1).init_roll) {

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

int get_unit_n(entity unit) {  // Return a position of the unit in Units list
  int n = 0;
  for (int i = 0; i < units.size(); i++)
    if (units.get(i) == unit)
      n = i;
  return n;
}

void next_unit() {    // Select the next unit in Units list
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
