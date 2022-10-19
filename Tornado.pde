class Tornado{
  
  //Variables
  //Position variables
  float posX;
  float posY;
  
  //Path variables
  float startPositionX;
  float startPositionY;
  float startHandleX;
  float startHandleY;
  float endPositionX;
  float endPositionY;
  float endHandleX;
  float endHandleY;
  float pathPositionX;
  float pathPositionY;
  float timerPath;
  float pathPercentage;
  float pathInitialStart = 60000;
  float pathRestart = pathInitialStart;
  
  //Animation variables
  float timerAnimation;
  
  //Map variables
  float mapWidth;
  float mapHeight;
  float positionPadding;
  float tornadoSize;
  
  //Constructor for a moving tornado
  Tornado(float _mapWidth, float _mapHeight, float _positionPadding){
    //Sets the map variables to the parameters
    mapWidth = _mapWidth;
    mapHeight = _mapHeight;
    positionPadding = _positionPadding;
    
    //Sets the initial positions of the path of the tornado
    resetPath();
  }
  
  //Constructor for a static tornado
  Tornado(float _posX, float _posY){
    //Sets the initial position of the tornado
    posX = _posX;
    posY = _posY;
  }
  
  //Draws the moving tornado
  void display(float size, boolean cantMove){
    //Sets the initial position and size of the tornado
    posX = pathPositionX;
    posY = pathPositionY;
    tornadoSize = size;
    
    //Draws each of the lines that forms the tornado
    for(float i = 0; i <= size; i+= size/5){
      float step = i/size;
      float pointX = bezierPoint(posX, posX + animate(size/2), posX + animate(size/4), posX + animate(-size/10), step);
      float pointY = bezierPoint(posY, posY - size/4, posY - size + size/4, posY - size, step);
      float lineWidth = i;
      
      //Draws lines along the bezier curve
      strokeCap(ROUND);
      stroke(255, 100);
      strokeWeight(size/10);
      line(pointX - lineWidth/2, pointY, pointX + lineWidth/2, pointY);
    }
    
    //Makes the tornado move only if the game is not over
    if(!cantMove){
      path();
    }
    
    //Puts the tornado at the start if the game is over
    else{
      pathPercentage = 0;
    }
  }
  
  //Draws the static tornado
  void display(float size){ 
    //Draws each of the lines that forms the tornado
    for(float i = 0; i <= size; i+= size/5){
      float step = i/size;
      float pointX = bezierPoint(posX, posX + animate(size/2), posX + animate(size/4), posX + animate(-size/10), step);
      float pointY = bezierPoint(posY, posY - size/4, posY - size + size/4, posY - size, step);
      float lineWidth = i;
      
      //Draws lines along the bezier curve
      strokeCap(ROUND);
      stroke(255, 100);
      strokeWeight(size/10);
      line(pointX - lineWidth/2, pointY, pointX + lineWidth/2, pointY);
    }
  }
  
  //Returns the position of one section of the tornado depending on the timer
  float animate(float size){
    //Starts the timer for the tornado animation
    timerAnimation = abs(sin(millis()/100));
    
    //Returns the position of the animation
    return lerp(-size, size, timerAnimation);
  }
  
  //Makes the tornado go around a randomly generated path
  void path(){
    //Starts the timer for the path displacement
    if(millis() - timerPath >= pathRestart){
      
      //Resets the timer
      timerPath = millis();
      
      //Resets the variables of the path
      pathPercentage = 0;
      pathRestart = random(60000, 90000);
      
      //Sets new positions of the path of the tornado
      resetPath();
    }

    //Augments the percentage of the position of the tornado on the fist time it moves
    if(millis() >= pathInitialStart){
      pathPercentage += 0.001;
    }
      
    //Updates the percentage of the position of the tornado
    pathPositionX = bezierPoint(startPositionX, startHandleX, endHandleX, endPositionX, constrain(pathPercentage, 0, 1));
    pathPositionY = bezierPoint(startPositionY, startHandleY, endHandleY, endPositionY, constrain(pathPercentage, 0, 1));
  }
  
  //Sets new positions of the path of the tornado
  void resetPath(){
    startPositionX = random(-mapWidth/positionPadding, mapWidth + mapWidth/positionPadding);
    startPositionY = random(-mapHeight/positionPadding, 0);
    startHandleX = random(-mapWidth/positionPadding, mapWidth + mapWidth/positionPadding);
    startHandleY = random(-mapHeight/positionPadding, 0);
    endPositionX = random(-mapWidth/positionPadding, mapWidth + mapWidth/positionPadding);
    endPositionY = random(mapHeight + tornadoSize*1.5, mapHeight + tornadoSize*1.5 + mapHeight/positionPadding);
    endHandleX = random(-mapWidth/positionPadding, mapWidth + mapWidth/positionPadding);
    endHandleY = random(mapHeight, mapHeight - mapHeight/positionPadding);
  }
  
  //Returns the position X of the tornado
  float getX(){
    return posX;
  }
  
  //Returns the position Y of the tornado
  float getY(){
    return posY;
  }
}
