class Slider{
  
  //Variables
  //Position variables
  float sliderPosX;
  float sliderPosY;
  float sliderSize;
  
  //Handle variables
  float handleCurrentPos;
  float handleSize = 30;
  float minimunValue;
  float maximumValue;
  int handleValue;
  int[] handlePreviousValue = new int[2];
  
  //Text variables
  String sliderTitle;
  
  //Constructor
  Slider(float posX, float posY, float size, String title){
    //Sets the global variables to the parametres
    sliderPosX = posX;
    sliderPosY = posY;
    sliderSize = size;
    sliderTitle = title;
    
    //Sets the initial position of the slider
    handleCurrentPos = sliderPosX - size/2;
    
    //Sets the initial values in the array (prevents a click sound at the begining)
    handlePreviousValue[0] = 1;
    handlePreviousValue[1] = 1;
  }
  
  //Displays a slider
  void display(){
    //Draws the slider's path
    rectMode(CENTER);
    noStroke();
    fill(0);
    rect(sliderPosX, sliderPosY, sliderSize, handleSize/3);
    
    //Draws the slider's handle
    fill(210);
    rect(handleCurrentPos, sliderPosY, sliderSize/10, handleSize);
    
    //Draws the slider's value
    textValue(sliderPosX + sliderSize, sliderPosY - handleSize/6, sliderTitle);
  }
  
  //Changes the position of the handle if the mouse is over it
  void move(){
    if(mousePressed && mouseX >= sliderPosX-sliderSize/2 && mouseX <= sliderPosX+sliderSize/2 && mouseY >= sliderPosY-handleSize/2 && mouseY <= sliderPosY+handleSize/2)
      handleCurrentPos = constrain(mouseX, sliderPosX-sliderSize/2, sliderPosX+sliderSize/2);
  }
  
  //Changes the value of the slider based on the position of the handle and the desired values
  void setSliderPosition(float min, float max){
    minimunValue = min;
    maximumValue = max + 0.5; //The  + 0.5 creates a buffer to get the maximum value more easly
    handleValue = int(map(handleCurrentPos, sliderPosX-sliderSize/2, sliderPosX+sliderSize/2, minimunValue, maximumValue));
    
    //Keeps track of the handle's current value and it's previous value
    handlePreviousValue[0] = handlePreviousValue[1];
    handlePreviousValue[1] = handleValue;
  }
  
  //Returns the slider's current value
  int getSliderPosition(){
    return handleValue;
  }
  
  //Draws the lable indicating the slider's function
  void textValue(float positionX, float positionY, String text){
    //Draws the display screen
    rectMode(CORNER);
    fill(0);
    stroke(80);
    strokeWeight(10);
    rect(positionX - 30, positionY - 25, 150, 50);
    
    //Draws the text inside the screen
    fill(255);
    textSize(20);
    textAlign(LEFT, CENTER);
    text(text + " " + handleValue, positionX, positionY);
  }
  
  //Checks if the value of the slider changed
  boolean valueChanged(){
    return (handlePreviousValue[0] != handlePreviousValue[1]);
  }
}
