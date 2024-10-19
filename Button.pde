// A class of buttons in the game

ArrayList<button> buttons = new ArrayList<button>();

// Buttons


class button {
  PVector position;
  PVector size;
  String text;
  String id;
  int main_color;
  boolean active = false;

  button(PVector position, PVector size, color main_color, String text, String id) {
    this.position = position;
    this.size = size;
    this.main_color = main_color;
    this.text = text;
    this.id = id;

    buttons.add(this);
  }

  void update() {
    if (check_overlap() && mousePressed)
      execute(id);
  }

  boolean check_overlap() {
    if (mouseX > position.x - size.x / 2 && mouseX < position.x + size.x / 2 && mouseY > position.y - size.y / 2 && mouseY < position.y + size.y / 2)
      return true;
    else
      return false;
  }

  void draw() {
    int modified_color = main_color;
    if (check_overlap())
      modified_color = main_color / 3;
    fill(modified_color);
    stroke(modified_color / 2);
    strokeWeight(10);
    rect(position.x - size.x / 2, position.y - size.y / 2, size.x, size.y);
    // Text
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text(text, position.x, position.y);
  }
  
  
}

void execute(String id) {
  switch(id) {
  case "new_game":
    new_game();
    break;
  }
}

void new_game() {
  new_game.active = false;
  battlefield = new battlefield(new PVector(16, 12));
}
