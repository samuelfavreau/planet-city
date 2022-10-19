class Building{
  
  //Variables
  //Building variables
  float buildingPositionX;
  float buildingPositionY;
  float buildingWidth;
  float buildingHeight;
  float opacityLerp;
  float buildingBrightness = random(40, 100);
  color buildingColor;
  color windowColor = #FFEF74;
  color chemneyColor = #B3A0BC;
  float size;
  
  //animation variables
  float animationLerp;
  float animationOffset = 0;
  
  //Constructor
  Building(float _buildingPositionX, float _buildingPositionY, float min, float max){
    //Sets the global variables to the parametres
    buildingPositionX = _buildingPositionX;
    buildingPositionY = _buildingPositionY;
    buildingWidth = random(min, max);
    buildingHeight = random(min, max);
    //Sets a random color for the building
    buildingColor = color(281, 48, buildingBrightness);
  }
  
  //Draws the animated building
  void display(){
    //Scaling the building for the animation in
    push();
    translate(buildingPositionX, buildingPositionY);
    scale(1, scaleAnimation());

    //Draws the face of the building
    rectMode(CENTER);
    colorMode(HSB, 360, 100, 100);
    fill(buildingColor);
    noStroke();
    rect(0, 0-buildingHeight/4, buildingWidth, buildingHeight);
    
    //Draws the window of the building
    fill(windowColor);
    rect(0, 0-buildingHeight/2, buildingWidth*0.70, buildingHeight/10);
    
    //Draws the roof of the building
    roof(0, 0-buildingHeight+buildingHeight/4, buildingWidth, buildingHeight/4);
    pop();
    
    //Creates the smoke animation of the buliding when the animation in is over
    if(size == 1)
      animation();
  }
  
  //Draws the static building (this function will be called if a boolean is placed as a parameter)
  void display(boolean noAnimation){
    //Draws the face of the building
    rectMode(CENTER);
    colorMode(HSB, 360, 100, 100);
    fill(buildingColor);
    noStroke();
    rect(buildingPositionX, buildingPositionY-buildingHeight/4, buildingWidth, buildingHeight);
    
    //Draws the window of the building
    fill(windowColor);
    rect(buildingPositionX, buildingPositionY-buildingHeight/2, buildingWidth*0.70, buildingHeight/10);
    
    //Draws the roof of the building
    roof(buildingPositionX, buildingPositionY-buildingHeight+buildingHeight/4, buildingWidth, buildingHeight/4);
    
    //Creates the smoke animation of the buliding
    animation();
  }
  
  //Draws the roof of the building
  void roof(float positionX, float positionY, float roofWidth, float roofHeight){
    //Roof of the building
    rectMode(CENTER);
    colorMode(HSB, 360, 100, 100);
    fill(281, 48, buildingBrightness - 30);
    noStroke();
    rect(positionX, positionY, roofWidth, roofHeight);
    
    //Chimney of the building
    fill(chemneyColor);
    rect(positionX, positionY-roofHeight/2, roofWidth/2, roofHeight);
    fill(0);
    arc(positionX, positionY-roofHeight, roofWidth/2, roofWidth/4, 0, PI);
  }
  
  //Creates the smoke animation of the buliding
  void animation(){
    //Sets the speed of the animation
    animationOffset += 0.01;
    
    //Sets the percentage of the animation and the opacity
    animationLerp = lerp(0, 20, animationOffset);
    opacityLerp = lerp(255, 0, animationOffset);
    
    //Restart the animation if it reaches 100%
    if(animationOffset >= 1){
      animationOffset = 0;
    }
    
    //Draws the smoke cloud
    noStroke();
    fill(100, opacityLerp);
    circle(buildingPositionX, buildingPositionY-buildingHeight - (animationOffset*20), animationLerp);
  }
  
  //Scales the building up if it's not at it's full size.
  float scaleAnimation(){
    if(size < 1)
      size += 0.5;
      
    return size;
  }
  
  //Resets the scaling animation
  void reset(){
    size = 0;
  }
  
  //Return the color of the tree for the display map
  color getColor(){
    return buildingColor;
  }
}
