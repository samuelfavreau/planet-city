class Tree{
  
  //Variables
  //Position variables
  float treePositionX;
  float treePositionY;
  float treeWidth;
  float treeHeight;
  
  //Animation variables
  float timerAnimationIn;
  float growingTime = 5000;
  boolean canGrow = true;
  float widthPercentage;
  float heightPercentage;
  
  //Color variables
  color yellow;
  color orange;

  //Constructor
  Tree(float _treePositionX, float _treePositionY, float min, float max){
    //Sets the global variables to the parameters
    treePositionX = _treePositionX;
    treePositionY = _treePositionY;
    treeWidth = random(min, max);
    treeHeight = random(min, max);
    
    //Sets a random color for the tree
    colorMode(HSB, 360, 100, 100);
    orange = color(31, 92, random(70, 100));
    yellow = color(57, random(50, 100), 93);
  }
  
  //Draws the animated tree
  void display(){
    //Draws the trunk of the tree
    rectMode(CENTER);
    fill(orange);
    noStroke();
    rect(treePositionX, treePositionY - heightPercentage/4, widthPercentage/3, heightPercentage);

    //Draws the leafs of the tree
    fill(yellow);
    noStroke();
    circle(treePositionX, treePositionY - heightPercentage/2-heightPercentage/4, widthPercentage);
    
    //Starts the growing animation
    animationIn();
  }
  
  //Draws the static tree (this function will be called if a boolean is placed as a parameter)
  void display(boolean noAnimation){
    //Draws the trunk of the tree
    rectMode(CENTER);
    fill(orange);
    noStroke();
    rect(treePositionX, treePositionY - treeHeight/4, treeWidth/3, treeHeight);
    
    //Draws the leafs of the tree
    fill(yellow);
    noStroke();
    circle(treePositionX, treePositionY - treeHeight/2-treeHeight/4, treeWidth);
  }
  
  //Makes the growing animation
  void animationIn(){
    //Makes the tree stop growing after the indicated growing time
    if(timerAnimationIn == 0 || millis() - timerAnimationIn >= growingTime && canGrow){
      timerAnimationIn = millis();
      canGrow = false;
    }
    
    //Animates the size of the trees growing
    widthPercentage = lerp(0, treeWidth, min(1, (millis() - timerAnimationIn)/growingTime));
    heightPercentage = lerp(0, treeHeight, min(1, (millis() - timerAnimationIn)/growingTime));
  }
  
  //Checks if the tree can grow
  boolean isGrowing(){
    return canGrow;
  }
  
  
  //Resets the animation of the tree
  void reset(){
    canGrow = true;
    widthPercentage = 0;
    heightPercentage = 0;
  }
  
  //Return the color of the tree for the display map
  color getColor(){
    return yellow;
  }
}
