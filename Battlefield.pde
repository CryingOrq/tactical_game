class battlefield {
  PVector size;
  PVector origin;

  battlefield(PVector size) {
    this.size = size;
    origin = new PVector(width / 2 - size.x * CELL_SIZE / 2, height / 2 - size.y * CELL_SIZE / 2);
  }

  void update() {

    //draw_flame(8);

    fill(25, 25, 35); //fill(50, 50, 75);
    rect(origin.x, origin.y, size.x * CELL_SIZE, size.y * CELL_SIZE);

    draw_grid();
  }

  void draw_flame(float weight) {  // Draw frame around the battlefield
    fill(200);
    rect(origin.x - weight - weight / 2, origin.y - weight - weight / 2, size.x * CELL_SIZE + weight * 2 + weight, size.y * CELL_SIZE + weight * 2 + weight);
    fill(255);
    rect(origin.x - weight - weight / 2, origin.y - weight - weight / 2, size.x * CELL_SIZE + weight * 2 + weight / 2, size.y * CELL_SIZE + weight * 2 + weight / 2);
    fill(100);
    rect(origin.x - weight, origin.y - weight, size.x * CELL_SIZE + weight * 2 + weight / 2, size.y * CELL_SIZE + weight * 2 + weight / 2);
    fill(200);
    rect(origin.x - weight, origin.y - weight, size.x * CELL_SIZE + weight * 2, size.y * CELL_SIZE + weight * 2);
  }

  void draw_grid() {  // Draw a tactical grid
    float x = origin.x, y = origin.y;
    stroke(100);
    strokeWeight(1);
    while (x <= origin.x + size.x * CELL_SIZE) {
      line(x, origin.y, x, origin.y + size.y * CELL_SIZE);
      x += CELL_SIZE;
    }
    while (y <= origin.y + size.y * CELL_SIZE) {
      line(origin.x, y, origin.x + size.x * CELL_SIZE, y);
      y += CELL_SIZE;
    }
  }
  
  void place_units() {
    
  }
}
