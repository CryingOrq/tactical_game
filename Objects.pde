class object {
  
  // Data
  PVector position;
  String fraction = "Objects";

  object(PVector position) {
    this.position = position;
  }
  
   void update() {
     fill(255);
     rect(position.x * CELL_SIZE, position.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
   }
}
