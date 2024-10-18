// attack, health, speed, power, init

unit warrior() {
  unit unit = new unit("Warrior", "Allies", 1, 8, 8, 4, 2, 6);
  
  return unit;
}

unit mage() {
  unit unit = new unit("Mage", "Allies", 1, 2, 4, 4, 10, 4);
  
  return unit;
}

unit priest() {
  unit unit = new unit("Priest", "Allies", 1, 4, 8, 5, 8, 6);
  
  return unit;
}

unit rogue() {
  unit unit = new unit("Rogue", "Allies", 1, 4, 4, 8, 2, 8);
  
  return unit;
}
