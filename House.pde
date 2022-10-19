class House{
  
  //Variables
  //Position variables
  float housePositionX;
  float housePositionY;
  float houseSize;
  
  //Animation variables
  float animationSize;
  
  //Color variables
  int rColor = int(random(0, 255));
  int gColor = int(random(0, 255));
  int bColor = int(random(0, 255));
  color randomColor;
  
  //Constructor
  House(float _housePositionX, float _housePositionY, float min, float max){
    //Sets the global variables to the parametres
    housePositionX = _housePositionX;
    housePositionY = _housePositionY;
    houseSize = random(min, max);
    
    //Sets a random color for the house
    colorMode(RGB, 255, 255, 255);
    randomColor = color(rColor, gColor, bColor);
  }
  
  //Draws the animated house
  void display(){
    //Scaling the house for the animation in
    push();
    translate(housePositionX, housePositionY);
    scale(1, scaleAnimation());
    
    //Draws the main structure of the house
    fill(randomColor);
    noStroke();
    arc(0, 0, houseSize, houseSize, PI, TWO_PI);
    
    //Draws the door of the house
    rectMode(CENTER);
    fill(235);
    rect(0 - houseSize/8, 0 - houseSize/8, houseSize/6, houseSize/4);
    
    //Draws the window of the house
    fill(#B7E0FF);
    circle(0 + houseSize/6, 0 - houseSize/4, houseSize/4);
    pop();
  }
  
  //Draws the static house (this function will be called if a boolean is placed as a parameter)
  void display(boolean noAnimation){
    //Draws the main structure of the house
    fill(randomColor);
    noStroke();
    arc(housePositionX, housePositionY, houseSize, houseSize, PI, TWO_PI);
    
    //Draws the door of the house
    rectMode(CENTER);
    fill(235);
    rect(housePositionX - houseSize/8, housePositionY - houseSize/8, houseSize/6, houseSize/4);
    
    //Draws the window of the house
    fill(#B7E0FF);
    circle(housePositionX + houseSize/6, housePositionY - houseSize/4, houseSize/4);
  }
  
  //Scales the building up if it's not at it's full size.
  float scaleAnimation(){
    if(animationSize < 1)
      animationSize += 0.5;
      
    return animationSize;
  }
  
  //Resets the scaling animation
  void reset(){
    animationSize = 0;
  }
  
  //Return the color of the tree for the display map
  color getColor(){
    return randomColor;
  }
}
