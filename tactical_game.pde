// Main
entity active_unit = null;
int global_timer = 0;

battlefield battlefield;

button new_game;

void setup() {
  size(1920, 1080, P2D);
  fullScreen();


  new_game = new button(new PVector(width / 2, height / 2), new PVector(200, 100), 100, "New game", "new_game");
  new_game.active = true;
}

void draw() {
  global_timer ++;

  background(0);

  if (battlefield != null)
    battlefield.update();

  // Update buttons
  if (buttons.size() > 0)
    for (int n = 0; n < buttons.size(); n ++) {
      if (buttons.get(n).active == false)
        continue;
      buttons.get(n).update();
      buttons.get(n).draw();
    }

  // Update floating text
  for (int n = 0; n < list_floating_text.size(); n ++)
    list_floating_text.get(n).update();

  
}
