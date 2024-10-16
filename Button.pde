class button {
  PVector position;
  PVector size;
  String text;
  String id;
  color main_color;

  button(PVector position, PVector size, color main_color, String text, String id) {
    this.position = position;
    this.size = size;
    this.main_color = main_color;
    this.text = text;
    this.id = id;
  }

  void update() {
  }

  void draw() {
    // Button
    fill(main_color);
    stroke(main_color / 2);
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
  case "create_party":
    create_party();
    break;
  }
}

void create_party() {
  
}
