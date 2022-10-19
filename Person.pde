class Person {
  
  //Variables
  //Positions variables
  float posX;
  float posY;
  float startX;
  float startY;
  float endX;
  float endY;
  float tileSize;
  
  //Timing variables
  float timer;
  float totalTime;
  float timePart1;
  float timePart2;
  float timePart3;
  float timePart4;
  float timePart5;
  
  //Path variables
  float pathTotalDistance;
  float pathPart1;
  float pathPart2;
  float pathPart3;
  float pathPart4;
  float pathPart5;
  
  //Lerp variables
  float lerpPath1;
  float lerpPath2;
  float lerpPath3;
  float lerpPath4;
  float lerpPath5;
  
  //Character variables
  float walking;
  color outfitColor = 50;
  color skinColor;
  color helmetColor;
  
  //Constructor
  Person(float _tileSize) {
    //Sets the size of one tile from the parameter
    tileSize = _tileSize;
    
    //Sets the colors of a person
    colorMode(HSB, 360, 100, 100);
    skinColor = color(31, 38, random(47, 99));
    helmetColor = color(57, 5, 95);
  }
  
  //Displays a person walking
  void display(){
    //Sets all of the path and timing informations
    pathManager();
    
    //Creates a walking animation
    walking = sin(radians(millis()*2));
    
    //Draws a person walking on the path
    drawPerson(posX, posY + walking, 5);
  }
  
  //Sets all of the path and timing informations
  void pathManager(){
    //Checks the distance of each section of the path the person will take 
    pathPart1 = dist(startX, startY, startX, startY + tileSize/2);
    pathPart2 = dist(startX, startY + tileSize/2, startX + tileSize/2, startY + tileSize/2);
    pathPart3 = dist(startX + tileSize/2, startY + tileSize/2, startX + tileSize/2, endY + tileSize/2);
    pathPart4 = dist(startX + tileSize/2, endY + tileSize/2, endX, endY + tileSize/2);
    pathPart5 = dist(endX, endY + tileSize/2, endX, endY - tileSize/3);
    
    //Check the total distance of the path
    pathTotalDistance = pathPart1 + pathPart2 + pathPart3 + pathPart4 + pathPart5;
    
    //Calculates the time the person will take to walk the path
    totalTime = pathTotalDistance*10;
    
    //Splits the time for each section of the path
    timePart1 = (pathPart1*totalTime)/pathTotalDistance;
    timePart2 = (pathPart2*totalTime)/pathTotalDistance;
    timePart3 = (pathPart3*totalTime)/pathTotalDistance;
    timePart4 = (pathPart4*totalTime)/pathTotalDistance;
    timePart5 = (pathPart5*totalTime)/pathTotalDistance;
    
    //Makes a smooth transition between each section of the path
    lerpPath1 = lerp(startY, startY + tileSize/2, min((millis()-timer)/timePart1, 1));
    lerpPath2 = lerp(startX, startX + tileSize/2, min((millis()-timer-timePart1)/timePart2, 1));
    lerpPath3 = lerp(startY + tileSize/2, endY + tileSize/2, min((millis()-timer-timePart1-timePart2)/timePart3, 1));
    lerpPath4 = lerp(startX + tileSize/2, endX, min((millis()-timer-timePart1-timePart2-timePart3)/timePart4, 1));
    lerpPath5 = lerp(endY + tileSize/2, endY - tileSize/3, min((millis()-timer-timePart1-timePart2-timePart3-timePart4)/timePart5, 1));
  }
  
  //Draws a little character
  void drawPerson(float _posX, float _posY, float _size){
    //Draws the body
    rectMode(CENTER);
    fill(outfitColor);
    noStroke();
    rect(_posX, _posY - _size/6, _size/2, _size);
    
    //Draws the head
    fill(skinColor);
    noStroke();
    circle(_posX, _posY - _size, _size);
    
    //Draws the helmet
    fill(helmetColor);
    arc(_posX, _posY - _size - 1, _size, _size, radians(190), radians(350));
  }
  
  //Manages the position an the timing of the character placement
  void animation(boolean tornadoAlert){
    //If the character is on the 1rst part of the path, sets their's positions on that path
    if(millis()-timer <= timePart1){
      posX = startX;
      posY = lerpPath1;
    }
    
    //If the character is on the 2nd part of the path, sets their's positions on that path
    if(millis()-timer > timePart1 && millis()-timer <= timePart1 + timePart2){
      posX = lerpPath2;
      posY = lerpPath1;
    }
    
    //If the character is on the 3rd part of the path, sets their's positions on that path
    if(millis()-timer > timePart1 + timePart2 && millis()-timer <= timePart1 + timePart2 + timePart3){
      posX = lerpPath2;
      posY = lerpPath3;
    }
    
    //If the character is on the 4th part of the path, sets their's positions on that path
    if(millis()-timer > timePart1 + timePart2 + timePart3 && millis()-timer <= timePart1 + timePart2 + timePart3 + timePart4){
      posX = lerpPath4;
      posY = lerpPath3;
    }
    
    //If the character is on the 5th part of the path, sets their's positions on that path
    if(millis()-timer > timePart1 + timePart2 + timePart3 + timePart4 && millis()-timer <= timePart1 + timePart2 + timePart3 + timePart4 + timePart5){
      posX = lerpPath4;
      posY = lerpPath5;
    }
    
    //If the character has reached the end of the path, one second has passed and no tornado is on the map
    if(millis()-timer > totalTime + 1000 && !tornadoAlert){
      //Reset the animation
      setTimer();
    }
    
  }
  
  //Sets the character's starting position
  void setStart(float _startX, float _startY){
    startX = _startX;
    startY = _startY;
  }
  
  //Sets the character's end position
  void setEnd(float _endX, float _endY){
    endX = _endX;
    endY = _endY;
  }
  
  //Resets the timer
  void setTimer(){
    timer = millis();
  }
}
