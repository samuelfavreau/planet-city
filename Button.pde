class Button {

  //Variables
  //color variables
  color baseColor = #68D66E;
  color selectedColor = #4D8951;
  color currentColor = baseColor;
  
  //Text variables
  String buttonText;
  float textWidth;
  float textHeight = 20;
  
  //Size variables
  float buttonPadding = 15;
  float boxPosX;
  float boxPosY;
  float boxWidth;
  float boxHeight;

  //Constructor
  Button(float _boxPosX, float _boxPosY, String text, boolean baseSize) {
    //Sets the text of the button
    textSize(textHeight);
    
    //Sets the buttonText variable to the text of the parametre
    buttonText = text;
    
    //Sets the width of the text depending on the mode selected in the parametre
    if(baseSize)
      textWidth = 140;
    else
      textWidth = textWidth(buttonText);

    //Sets the dimensions of the box to the parametres
    boxPosX = _boxPosX;
    boxPosY = _boxPosY;
    boxWidth = textWidth + buttonPadding;
    boxHeight = textHeight + buttonPadding;
  }

  //Displays the text and the box
  void display() {
    //Draws the box of the button
    rectMode(CENTER);
    stroke(80);
    strokeWeight(5);
    fill(currentColor);
    rect(boxPosX, boxPosY, boxWidth, boxHeight);

    //Draws the text of the button
    fill(0);
    textAlign(CENTER, CENTER);
    text(buttonText, boxPosX, boxPosY);
  }

  //Check if there is a collision with the button
  boolean collision(float collisionX, float collisionY) {
    return (collisionX > boxPosX - boxWidth/2 && collisionX < boxPosX + boxWidth/2 && collisionY > boxPosY - boxHeight/2 && collisionY < boxPosY + boxHeight/2);
  }

  //Changes the color of the button when it's active
  void isActive(boolean active) {
    //Makes the color the selected color if the button is active
    if (active) {
      currentColor = selectedColor;
    } 
    //Makes the color the base color if the button is not active
    else {
      currentColor = baseColor;
    }
  }
  
  //Returns the width of the button
  float getWidth(){
    return boxWidth;
  }
  
  //Returns the height of the button
  float getHeight(){
    return boxHeight;
  }
}
