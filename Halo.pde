class Halo {

  //Variables
  float posX;
  float posY;
  float haloSize;
  float haloOpacity;
  
  //Constructor
  Halo(float _posX, float _posY) {
    //Sets the variables
    posX = _posX;
    posY = _posY;
    
    //Resets the size and opacity
    reset();
  }
  
  //Displays a halo circle
  void display() {
    //Draws a halo circle
    noFill();
    stroke(255, haloOpacity);
    strokeWeight(2);
    ellipse(posX, posY, haloSize, haloSize*0.8);
  }
  
  //Animates the halo growing and fading if it can update and it's still visible
  void update(boolean canUpdate) {
    if (canUpdate && haloOpacity >= 0) {
      haloSize += 10;
      haloOpacity -= 40;
    }
  }
  
  //Checks if the halo can be removed
  boolean remove(){
    return (haloOpacity <= 0);
  }

  //Resets the size and opacity
  void reset() {
    haloSize = 0;
    haloOpacity = 255;
  }
}
