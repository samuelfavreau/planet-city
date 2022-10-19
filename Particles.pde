class Particles{
  
  //Variables
  //Position variables
  float positionX;
  float positionY;
  float positionXOffset;
  
  //Animation variables
  float opacity = 255;
  float speed;
  
  //Color variables
  color particleColor;

  //Constructor
  Particles(float _speed) {
    //Sets the speed to the parameter
    speed = _speed;
  }
  
  //Displays one of the particles
  void display(float size, boolean canShow){
    //Draws one of the particles if it can be showen
    if(canShow){
      fill(particleColor, opacity);
      noStroke();
      circle(getX(), positionY, size);
    }
  }
  
  //Sets the positions of the particles
  void setPosition(float posX, float posY) { 
    positionX = posX;
    positionY = posY;
  }
  
  //Returns the X position
  float getX() {
    return positionX + positionXOffset;
  }
  
  //Returns the Y position
  float getY() {
    return positionY;
  }
  
  //Sets the color of the particles
  void setColor(color objectColor){
    particleColor =  objectColor;
  }
  
  //Updates the position and the opacity of the particles if it can update
  void update(boolean canUpdate){
    if(canUpdate){
      positionXOffset -= speed;
      opacity -= speed*2;
    }
  }
  
  //Checks if the particle can be removed
  boolean remove(){
    return (opacity <= 0);
  }
  
  //Resets the position and the opacity of the particles
  void reset(){
    positionXOffset = 0;
    opacity = 255;
  }
}
