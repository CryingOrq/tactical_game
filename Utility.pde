PVector pixel_to_grid(PVector pixel_pos) {
  int x = floor(pixel_pos.x / CELL_SIZE);
  int y = floor(pixel_pos.y / CELL_SIZE);
  return new PVector(x, y);
}

PVector grid_to_pixel(PVector grid_pos) {
  float x = grid_pos.x * CELL_SIZE;
  float y = grid_pos.y * CELL_SIZE;
  return new PVector(x, y);
}
