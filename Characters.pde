// Stats for characters
// title, fraction, level, attack, health, speed, power, init

entity warrior() {
  entity entity = new entity("Warrior", "Party", 1, 8, 8, 4, 2, 6);

  return entity;
}

entity mage() {
  entity entity = new entity("Mage", "Party", 1, 2, 4, 4, 10, 4);

  return entity;
}

entity priest() {
  entity entity = new entity("Priest", "Party", 1, 4, 8, 5, 8, 6);

  return entity;
}

entity rogue() {
  entity entity = new entity("Rogue", "Party", 1, 4, 4, 8, 2, 8);

  return entity;
}
