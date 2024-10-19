// A tactical map's class

int CELL_SIZE = 40;

class battlefield {
  PVector size;
  PVector origin;
  String[][] grid_map;

  int info_delay = 15;

  battlefield(PVector size) {
    this.size = size;
    origin = new PVector(width / 2 - size.x * CELL_SIZE / 2, height / 2 - size.y * CELL_SIZE / 2);
    grid_map = new String[int(size.x)][int(size.y)];

    create_party();
    create_enemies();
    sort_units();
    place_units();
    next_unit();
  }

  void update() {

    //draw_frame(8);


    fill(25, 25, 35); //fill(50, 50, 75);
    stroke(200);
    strokeWeight(5);
    rect(origin.x, origin.y, size.x * CELL_SIZE, size.y * CELL_SIZE);

    draw_grid();
    draw_active_unit_frame();

    // Update units
    for (int n = 0; n < units.size(); n ++) {
      entity unit = units.get(n);
      unit.update(origin);
      unit.draw(origin);
    }


    draw_mouse_pointer();
    draw_unit_info();
  }

  void draw_frame(float weight) {  // Draw frame around the battlefield
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
    for (int n = 0; n < units.size(); n ++) {
      units.get(n).grid_position = new PVector(floor(random(size.x)), floor(random(size.y)));
      units.get(n).start_battle();
    }
  }

  void draw_mouse_pointer() {
    if (mouseX > origin.x && mouseX < origin.x + size.x * CELL_SIZE && mouseY > origin.y && mouseY < origin.y + size.y * CELL_SIZE) {
      PVector mouse_pos = pixel_to_grid(new PVector(mouseX, mouseY));
      fill(255, 255, 255, 50 + sin(global_timer / 10) * 25);
      noStroke();
      rect(mouse_pos.x * CELL_SIZE, mouse_pos.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
  }

  void draw_unit_info() {
    PVector mouse_pos = pixel_to_grid(new PVector(mouseX, mouseY).sub(origin));
    PVector info_size = new PVector(150, 200);
    entity unit = null;
    for (int i = 0; i < units.size(); i++) {
      if (mouse_pos.x == units.get(i).grid_position.x && mouse_pos.y == units.get(i).grid_position.y) {
        unit = units.get(i);
        break;
      }
    }
    if (unit != null) {
      if (info_delay > 0) {
        info_delay --;
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
        textAlign(LEFT, BOTTOM);
        text(unit.title, position.x + 2, position.y + 1);
        fill(255);
        text(unit.title, position.x, position.y);
        position.y += 8;

        // hp bar
        fill(0);
        rect(position.x, position.y, 80 + 2, 8 + 2);
        float healthbar_length_mod = float(unit.current_health) / unit.health;
        fill(255 - 255 * healthbar_length_mod, 255 * healthbar_length_mod, 0);
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
        text("Initiative " + int(unit.init), position.x + 2, position.y + 1);
        fill(255);
        text("Initiative " + int(unit.init), position.x, position.y);
      }
    } else
      info_delay = min(info_delay + 1, 15);
  }

  void draw_active_unit_frame() {
    if (active_unit != null) {
      fill(255, 255, 255, 0);
      stroke(255, 255, 255, 200 + sin(global_timer / 10) * 55);
      strokeWeight(8);
      rect(origin.x + active_unit.grid_position.x * CELL_SIZE, origin.y + active_unit.grid_position.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
  }
}
