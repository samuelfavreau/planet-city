//------------------------------------------------ Tutorial window ---------------------------------------------------

//Creates a window highlighting the area described 
void tutorialWindow(float posX, float posY, float windowWidth, float windowHeight){
  //Draw the transparent rectangles delimiting the highlighted section
  fill(0, 150);
  noStroke();
  rectMode(CORNERS);
  rect(0, 0, posX - windowWidth/2, height); //Draws the left rectangle
  rect(posX + windowWidth/2, 0, width, height); //Draws the right rectangle
  rect(posX - windowWidth/2, 0, posX + windowWidth/2, posY - windowHeight/2); //Draws the top rectangle
  rect(posX - windowWidth/2, posY + windowHeight/2, posX + windowWidth/2, height); //Draws the bottom rectangle
}

//------------------------------------------------ Tutorial ---------------------------------------------------

//Displays the different instruction screens
void tutorial(){
  //Displays the welcome sign if the player is at the slide 1
  if(tutorialSlide == 1){
    //Draws the screen showing what part of the interface is being explained
    tutorialWindow(0, 0, 0, 0);
    
    //Draws the message box that displays the text
    stroke(80);
    strokeWeight(20);
    fill(0);
    rectMode(CENTER);
    rect(width/2, height/2, width*0.8, height*0.8);
    
    //Draws the text explaining the game
    //First section of the text
    fill(255);
    textAlign(CENTER);
    textFont(digital_100, 40);
    text("Welcome to", width/2, height/3.5, width/2, 40);
    
    //Second section of the text
    fill(groundColor);
    textFont(digital_100, 70);    
    text("Planet  city", width/2, height/2.5, width/2, 70);
    
    //Third section of the text
    fill(255);
    textFont(digital_100, 30);
    text("The  game  where  you  will  have  to  build  and  manage  your  own  civilization  on  an  unknown  planet.", width/2, height/1.6, width/2, 3*30);
    
    
    //Draws the object on the first screen of the tutorial from the randomly generated list
    for(int i = 0; i < numberObjectsTutorial; i++){
      //Draws a tree if the index is TREE (1)
      if(listObjectsTutorial[i] == TREE){
        firstScreenTree[i].display(true);
      }
      //Draws a building if the index is BUILDING (2)
      if(listObjectsTutorial[i] == BUILDING){
        firstScreenBuilding[i].display(true);
      }
      //Draws a house if the index is HOUSE (3)
      if(listObjectsTutorial[i] == HOUSE){
        firstScreenHouse[i].display(true);
      }
    }
  }
  
  //Displays the map sign if the player is at the slide 2
  if(tutorialSlide == 2){
    //Draws the screen showing what part of the interface is being explained
    tutorialWindow(width/2, (height - controlPannelHeight)/2, width - 10, height - controlPannelHeight - 10);
    
    //Draws the message box that displays the text
    stroke(80);
    strokeWeight(20);
    fill(0);
    rectMode(CENTER);
    rect(width/2, height - 120, width*0.8, height/4);
    
    //Draws the text explaining the game
    fill(255);
    textAlign(CENTER);
    textFont(digital_100, 30);
    text("This  section  represents  the  space  where  you  can  add  elements.", width/2, height - 120, width*0.6, 60);
  }
  
  //Displays the map display sign if the player is at the slide 3
  if(tutorialSlide == 3){
    //Draws the screen showing what part of the interface is being explained
    tutorialWindow(mapDisplayX + mapDisplayWidth/2, mapDisplayY + mapDisplayHeight/2, mapDisplayWidth + 10, mapDisplayHeight + 10);
    
    //Draws the message box that displays the text
    stroke(80);
    strokeWeight(20);
    fill(0);
    rectMode(CENTER);
    rect(width/2, height - 120, width*0.8, height/4);
    
    //Draws the text explaining the game
    fill(255);
    textAlign(CENTER);
    textFont(digital_100, 30);
    text("To  help  guide  you,  a  small  map  will  show  you  your  position  and  those  of  the  various  elements.", width/2, height - 120, width*0.6, 2*30);
  }
  
  //Displays the crater sign if the player is at the slide 4
  if(tutorialSlide == 4){
    //Draws the screen showing what part of the interface is being explained
    tutorialWindow(tile[craterCol[0]][craterRow[0]].getX(), tile[craterCol[0]][craterRow[0]].getY(), tileSize + 10, tileSize + 10);
    
    //Draws the message box that displays the text
    stroke(80);
    strokeWeight(20);
    fill(0);
    rectMode(CENTER);
    rect(width/2, height - 120, width*0.8, height/4);
    
    //Draws the text explaining the game
    fill(255);
    textAlign(CENTER);
    textFont(digital_100, 30);
    text("Watch  out  for  the  craters.  Nothing  can  be  placed  on  them.", width/2, height - 120, width*0.6, 60);
  }
  
  //Displays the button sign if the player is at the slide 5
  if(tutorialSlide == 5){
    //Draws the screen showing what part of the interface is being explained
    tutorialWindow(width/2, height - controlPannelHeight/2, treeButton.getWidth()*2 + buttonXdecal, (treeButton.getHeight() + buttonYdecal)*2);
    
    //Draws the message box that displays the text
    stroke(80);
    strokeWeight(20);
    fill(0);
    rectMode(CENTER);
    rect(width/2, height/3, width*0.8, height/4);
    
    //Draws the text explaining the game
    fill(255);
    textAlign(CENTER);
    textFont(digital_100, 30);
    text("To  add  an  element to  your  planet,  click  on  it's  corresponding  button.", width/2, height/3, width*0.6, 60);
  }
  
  //Displays the sliders sign if the player is at the slide 6
  if(tutorialSlide == 6){
    //Draws the screen showing what part of the interface is being explained
    tutorialWindow(200, height - controlPannelHeight/2, 350, 200);
    
    //Draws the message box that displays the text
    stroke(80);
    strokeWeight(20);
    fill(0);
    rectMode(CENTER);
    rect(width/2, height/3, width*0.8, height/4);
    
    //Draws the text explaining the game
    fill(255);
    textAlign(CENTER);
    textFont(digital_100, 30);
    text("To  modify  the  number  of  objects  added  to  the  planet,  move  the  width  and  height  sliders.", width/2, height/3, width*0.6, 60);
  }
  
  //Displays the screen sign if the player is at the slide 7
  if(tutorialSlide == 7){
    //Draws the screen showing what part of the interface is being explained
    tutorialWindow(width - 200, height - controlPannelHeight/2, 350, 200);
    
    //Draws the message box that displays the text
    stroke(80);
    strokeWeight(20);
    fill(0);
    rectMode(CENTER);
    rect(width/2, height/3, width*0.8, height/3);
    
    //Draws the text explaining the game
    fill(255);
    textAlign(CENTER);
    textFont(digital_100, 30);
    text("Keep  an  eye  on  the  stats  screen  which  keeps  track  of  your  budget,  the  air  quality  and  how  much  wood  you  have  left.", width/2, height/3, width*0.6, 3*30);
  }
  
  //Displays the object sign if the player is at the slide 8
  if(tutorialSlide == 8){
    //Draws the screen showing what part of the interface is being explained
    tutorialWindow(0, 0, 0, 0);
    
    //Draws the message box that displays the text
    stroke(80);
    strokeWeight(20);
    fill(0);
    rectMode(CENTER);
    rect(width/2, height/2, width*0.8, height*0.8);
    
    
    //Displays the icons representing each object
    tutorialTree.display(true);
    tutorialBuilding.display(true);
    tutorialHouse.display(true);
    
    //Draws the text explaining every objects
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(digital_20, 20);
    text("Trees  increase  the  air  quality.  2  trees  are  necessary  to  counter  the  pollution  caused by  a  building.", width/2 + 100, height/2 - 100, width*0.6, 2*20);
    text("Buildings  increase  the  budget  over  time  if  someone  is  working  there.  They  do,  however,  lower  the  air  quality.", width/2 + 100, height/2, width*0.6, 2*30);
    text("Houses  make  it  so  that  an  employee  will  go  to  work  in  a  building.  However,  you  need  wood  to  build  one.", width/2 + 100, height/2 + 100, width*0.6, 2*30);
  }
  
  //Displays the tornado sign if the player is at the slide 9
  if(tutorialSlide == 9){
    //Draws the screen showing what part of the interface is being explained
    tutorialWindow(0, 0, 0, 0);
    
    //Draws the message box that displays the text
    stroke(80);
    strokeWeight(20);
    fill(0);
    rectMode(CENTER);
    rect(width/2, height/2, width*0.8, height*0.8);
    
    //Displays the icons representing the tornado
    tutorialTornado.display(100);
    
    //Draws the text explaining the game
    //First section of the text
    fill(255);
    textAlign(CENTER);
    textFont(digital_100, 50);
    text("WARNING", width/2, height/4, width*0.6, 3*30);
    
    //Second section of the text
    textFont(digital_100, 30);
    text("Sometimes  a  tornado  will  pass  and  destroy  everything  in  its  path.", width/2, height/1.3, width*0.6, 3*30);
  }
  
  //Displays the restart game sign if the player is at the slide 10
  if(tutorialSlide == 10){
    //Draws the screen showing what part of the interface is being explained
    tutorialWindow(0, 0, 0, 0);
    
    //Draws the message box that displays the text
    stroke(80);
    strokeWeight(20);
    fill(0);
    rectMode(CENTER);
    rect(width/2, height/2, width*0.8, height*0.5);
    
    //Draws the text explaining the game
    fill(255);
    textAlign(CENTER);
    textFont(digital_100, 40);
    text("To  restart  your  game,  press  the  R  key  on  your  keyboard.", width/2, height/2, width*0.6, 40*2);
  }
  
  //Starts the game if all of the slides have been shown
  if(tutorialSlide >= 11){
    cantPlay = false;
    showTutorial = false;
  }
  
  //Displays the skip tutorial button if the tutorial is displayed
  if(showTutorial){
    textFont(digital_20, 20);
    skipTutorialButton.display();
  }

  //If the button is hovered
  if (skipTutorialButton.collision(mouseX, mouseY)) {
    //Makes it the active color
    skipTutorialButton.isActive(true);
    
    //If the button is clicked
    if (mousePressed) {
      cantPlay = false;
      showTutorial = false;
      
      //Plays the click sound
      click.rewind();
      click.play();
    }
  }
  
  //If the button is not hovered
  else {
    //Makes it the normal color
    skipTutorialButton.isActive(false);
  }
}

//When the mouse is clicked when the tutorial is being shown
void mouseClicked(){
  if(showTutorial){
    //Plays the click sound on every slide
    click.rewind();
    click.play();
    
    //Makes the slide variable go up every time the mouse is clicked
    tutorialSlide += 1;
  }
}
