// VISUAL EFFECTS

// Lists of effects
ArrayList<floating_text> list_floating_text = new ArrayList<floating_text>();

class floating_text {
  String text;
  PVector position;
  float timer = 30;
  floating_text(String text, PVector position) {
    this.text = text;
    this.position = position;
  }

  void update() {
    textSize(64);
    fill(255, 255, 255, timer * 8);
    text(text, position.x * CELL_SIZE + CELL_SIZE / 2, position.y * CELL_SIZE + CELL_SIZE / 2);
    position.y -= 0.05;
    timer --;
    if (timer <= 0)
      destroy();
  }
  void destroy() {
    for (int i = 0; i < list_floating_text.size(); i++)
      if (list_floating_text.get(i) == this)
        list_floating_text.remove(i);
  }
}
