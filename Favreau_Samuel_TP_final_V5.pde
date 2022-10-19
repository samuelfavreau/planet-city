/*
 * Titre: EDM4600 Travail final: Planete city
 * Auteur: Samuel Favreau
 * Version: 5.0
 
 * Instructions: Pour ajouter des éléments sur la carte, appuyez sur les boutons prévus à cet effet sur le panneau de contrôle. Pour ajouter plusieurs éléments sur la carte,
                 servez-vous des glissières pour ajuster la largeur et la hauteur du paquet d'éléments à ajouter sur la carte. Pour effacer des éléments, cliquez sur le bouton
                 de l'efface et cliquez sur les éléments à retirer avec la souris. Un tableau indiquant le budget, la qualité de l'air et la quantité de bois est présent pour
                 garder le compte des ressources.
 
 * Description du projet: Le projet est un jeu de gestion dans lequel il faut construire et de gérer une ville sur une planète inconnue en se servant des ressources accessibles.
                          Pour ce faire, il faut ajouter des arbres, des bâtiments et des maisons pour équilibrer la qualité de l'air et le budget. Les bâtiments rapportent de l'argent
                          lorsqu'ils sont accompagnés d'une maison, mais font baisser la qualité de l'air. Les arbres permettent d'augmenter la qualité de l'air, mais ne rapportent aucun profit.
                          Les maisons augmentent le budget s'ils sont accompagnés d'un bâtiment, mais ne peuvent être construits que si un arbre a été coupé au préalable. La partie se termine
                          lorsque le budget tombe à 0$ ou si la qualité de l'air atteint 0%. Occasionnellement, une tornade passera et détruira tout sur son passage.
 
 * Notes: -2 arbres sont nécessaires pour annuler la dégradation de l'air causée par 1 bâtiment.
          -La tornade apparaît aléatoirement dans un intervalle variant entre 30 et 60 secondes.
          -La police de caractère utilisée ne peut pas écrire le caractère "%". C'est pourquoi il n'est pas dans les textes aux endroits appropriés.
          -Le niveau de fumée autour de l'écran est proportionnel à la qualité de l'air.
          -Des cratères sont placés aléatoirement au début de chaque partie. Ils ne peuvent pas être enlevés et rien ne peut être construit dessus.
 
 * Lien: https://samuelfavreau.com/sfavreau_realisation/planet-city/.
 */

//Librairies
import ddf.minim.*;

//Objects
//Building objects
Building tutorialBuilding;
Building[] firstScreenBuilding;

//Button objects
Button treeButton;
Button buildingButton;
Button houseButton;
Button eraserButton;
Button restartButton;
Button skipTutorialButton;
Button yesButton;
Button noButton;

//House objects
House tutorialHouse;
House[] firstScreenHouse;

//Slider objects
Slider widthSlider;
Slider heightSlider;

//Tile objects
Tile[][] tile;

//Tornado objects
Tornado tornado;
Tornado tutorialTornado;

//Tree objects
Tree tutorialTree;
Tree[] firstScreenTree;

//Workers arrays
FloatList workersStartX = new FloatList();
FloatList workersStartY = new FloatList();
FloatList workersEndX = new FloatList();
FloatList workersEndY = new FloatList();
ArrayList<Person> workers = new ArrayList<Person>();

//Fonts
PFont digital_20;
PFont digital_100;

//Sounds
Minim minim;
AudioPlayer backgroundMusic;
AudioPlayer drop;
AudioPlayer wind;
AudioPlayer click;

//Variables
//Map variables
final int COLUMNS_PER_SCREEN = 32;
final int ROWS_PER_SCREEN = 12;
final int EMPTY = 0;
final int TREE = 1;
final int BUILDING = 2;
final int HOUSE = 3;
final int CRATER = 4;
final int TREE_PRICE = 500;
final int BUILDING_PRICE = 1500;
final int HOUSE_PRICE = 1000;
int columns;
int rows;
int tileSize;
int objectType;
int numberOfCrater = int(random(10, 20));
int[] craterCol = new int[numberOfCrater];
int[] craterRow = new int[numberOfCrater];
color groundColor;
float smokeDecal = 0;
float mapDecalX = 0;
float mapDecalY = 0;
float mapSpeed = 20;
boolean tornadoOnMap = false;

//Control pannel variables
float controlPannelPosition;
float controlPannelHeight;
int treeNumber = 0;
int buildingNumber = 0;
int houseNumber = 0;
float moneyLevel = 1000000;
float airQuality = 50;
int woodBank = 0;
int timer;
color greenColor = #33AF32;
color yellowColor = #FAD100;
color redColor = #E8391E;
int buttonXdecal;
int buttonYdecal;

//Gameplay variables
final int NO_MONEY = 1;
final int NO_AIR = 2;
boolean showTutorial = true;
int tutorialSlide = 1;
int numberObjectsTutorial;
int[] listObjectsTutorial;
boolean cantPlay = true;
boolean restartGameQuestion = false;

//Map display variables
float mapDisplayX;
float mapDisplayY;
float mapDisplayWidth;
float mapDisplayHeight;
float mapOpacity = 1;
float mapOpacitySpeed = 0.3;

//Workers variables
int numberOfWorkers;


// ..............................................................................................................................................................
//                                                                   SETUP
// ..............................................................................................................................................................

void setup() {
  
  //----------------------------------------------------- General -----------------------------------------------------------
  
  //Initialisation of the canvas size
  size(1280, 720);

  //Import the fonts of different sizes
  digital_20 = loadFont("LCDNormal-20.vlw");
  digital_100 = loadFont("LCDNormal-100.vlw");

  //Initialisation of the color of the ground to a random color to represent a different planet
  colorMode(HSB, 360, 100, 100);
  groundColor = color(random(360), 25, 50);
  
  //----------------------------------------------------- Tutorial -----------------------------------------------------------
  
  //Creation of the button to skip the tutorial
  skipTutorialButton = new Button(width - 100, 30, "Skip tutorial", false);
  
  //Initialisation of the number of objects on the tutorial screen
  numberObjectsTutorial = int((width*0.8)/60) - 1;
  listObjectsTutorial = new int[numberObjectsTutorial];
  
  //Selection of the object dispalyed on the welcome screen (1 = tree, 2 = building, 3 = house)
  for(int i = 0; i < numberObjectsTutorial; i++){
    listObjectsTutorial[i] = int(random(1, 4));
  }
  
  //Creation of enought objects to fill the welcome screen
  firstScreenTree = new Tree[numberObjectsTutorial];
  firstScreenBuilding = new Building[numberObjectsTutorial];
  firstScreenHouse = new House[numberObjectsTutorial];
  
  //Initialisation of the object variables
  int objectsDistance = 60;
  int objectsDecalX = 55;
  int objectsDecalTree = 23;
  int objectsDecalBuilding = 20;
  int objectsDecalHouse = 10;
  
  //Initialisation of the position of every object of the welcome screen
  for(int i = 0; i < numberObjectsTutorial; i++){
   firstScreenTree[i] = new Tree(width/2 - ((width*0.8)/2) + objectsDecalX + i*objectsDistance, height/2 + ((height*0.8)/2) - objectsDecalTree, random(40, 60), random(40, 60));
   firstScreenBuilding[i] = new Building(width/2 - ((width*0.8)/2) + objectsDecalX + i*objectsDistance, height/2 + ((height*0.8)/2) - objectsDecalBuilding, random(40, 60), random(40, 60));
   firstScreenHouse[i] = new House(width/2 - ((width*0.8)/2) + objectsDecalX + i*objectsDistance, height/2 + ((height*0.8)/2) - objectsDecalHouse, random(40, 60), random(40, 60));
  }
  
  //Creation of all of the objects used in the tutorial
  tutorialTree = new Tree(width/5, height/2 - 100, 50, 50);
  tutorialBuilding = new Building(width/5, height/2, 50, 50);
  tutorialHouse = new House(width/5, height/2 + 100, 50, 50);
  tutorialTornado = new Tornado(width/2, height/2);
  
  //----------------------------------------------------- Map -----------------------------------------------------------
  
  //Initialisation of the size for the planet
  columns = int(random(COLUMNS_PER_SCREEN, COLUMNS_PER_SCREEN*2));
  rows = int(random(ROWS_PER_SCREEN, ROWS_PER_SCREEN*2));

  //Creation of the tiles
  tile = new Tile[columns][rows];

  //Initialisation of the size of one tile
  tileSize = width/COLUMNS_PER_SCREEN;

  //Creation of all the tiles
  for (int i = 0; i < columns; i++) {
    for (int j = 0; j < rows; j++) {
      tile[i][j] = new Tile(tileSize*i, tileSize*j, tileSize);
    }
  }

  //Positions of all the craters
  for (int i = 0; i < numberOfCrater; i++) {
    //The first crater is inside the first screen for the tutorial
    if(i == 0){
      craterCol[i] = int(random(0, COLUMNS_PER_SCREEN));
      craterRow[i] = int(random(0, ROWS_PER_SCREEN));
    }
    
    //Every other craters randomly on the map
    else{
      craterCol[i] = int(random(0, columns));
      craterRow[i] = int(random(0, rows));
    }
  }
  
  //Creation of the tornado object
  tornado = new Tornado(columns*tileSize, rows*tileSize, 10);
  
  //----------------------------------------------------- Control pannel -----------------------------------------------------------

  //Initialisation of the control pannel's position
  controlPannelPosition = height - (height-(tileSize*ROWS_PER_SCREEN));
  
  //Initialisation of the control pannel's height
  controlPannelHeight = height - controlPannelPosition;

  //Creation of the slider objects
  widthSlider = new Slider(100, height - controlPannelHeight/2 - 45, 100, "Width :");
  heightSlider = new Slider(100, height - controlPannelHeight/2 + 45, 100, "Height :");

  //Creation of the button objects
  buttonXdecal = 85;
  buttonYdecal = 25;
  treeButton = new Button(width/2 - buttonXdecal, height - controlPannelHeight/2 - buttonYdecal, "Tree  ( " + TREE_PRICE + " $ )", true);  
  buildingButton = new Button(width/2 + buttonXdecal, height - controlPannelHeight/2 - buttonYdecal, "Building  ( " + BUILDING_PRICE + " $ )", true);
  houseButton = new Button(width/2 - buttonXdecal, height - controlPannelHeight/2 + buttonYdecal, "House  ( " + HOUSE_PRICE + " $ )", true);
  eraserButton = new Button(width/2 + buttonXdecal, height - controlPannelHeight/2 + buttonYdecal, "Eraser", true);
  
  //----------------------------------------------------- Gameplay -----------------------------------------------------------
  
  //Creation of the button to restart the game
  restartButton = new Button(width/2, height*0.7, "Restart", true);
  
  //Creation of the button to answer the restart question
  yesButton = new Button(width/2 - buttonXdecal, height*0.7, "Yes", true);
  noButton = new Button(width/2 + buttonXdecal, height*0.7, "No", true);
  
  //----------------------------------------------------- Map display -----------------------------------------------------------
  
  //Initialisation of the display map's position and size
  mapDisplayX = 10;
  mapDisplayY = height - controlPannelHeight - ((rows*tileSize)/10) - 10;
  mapDisplayWidth = (columns*tileSize)/10;
  mapDisplayHeight = (rows*tileSize)/10;
  
  //----------------------------------------------------- Sounds -----------------------------------------------------------
  
  //Initialisation of all of the sound files
  minim = new Minim(this);
  backgroundMusic = minim.loadFile("background_music.mp4");
  drop = minim.loadFile("drop.wav");
  wind = minim.loadFile("wind.wav");
  click = minim.loadFile("click.wav");
  
  //Initialisation of the background music
  backgroundMusic.loop();
}

// ..............................................................................................................................................................
//                                                                   DRAW
// ..............................................................................................................................................................

void draw() {
  //Reset every frame
  background(groundColor);

  //----------------------------------------------------- Map -----------------------------------------------------------
  
  //----------- Keypress to move the map
  
  //Movement the map on an arrow key press
  if(keyPressed && key == CODED && !cantPlay){
    //Moves the map to the right if it is not on the right edge
    if(keyCode == RIGHT){
      if(mapDecalX > -((columns - COLUMNS_PER_SCREEN)*tileSize))
        mapDecalX -= mapSpeed;
    }
    //Moves the map to the left if it is not on the left edge
    if(keyCode == LEFT){
      if(mapDecalX < 0)
        mapDecalX += mapSpeed;
    }
    //Moves the map down if it is not on the bottom edge
    if(keyCode == DOWN){
      if(mapDecalY > -((rows - ROWS_PER_SCREEN)*tileSize))
         mapDecalY -= mapSpeed;
    }
    //Moves the map up if it is not on the top edge
    if(keyCode == UP){
      if(mapDecalY < 0)
        mapDecalY += mapSpeed;
    }
  }
  
  //----------- Tiles
  
  //Current position of each slider
  int widthSliderPos = widthSlider.getSliderPosition();
  int heightSliderPos = heightSlider.getSliderPosition();
  
  //Positioning of the map depending on the decal values
  push();
  translate(mapDecalX, mapDecalY);
  
  //Determins the number of workers
  numberOfWorkers = min(workersStartX.size(), workersEndX.size());
  
  //Creation of all of the workers and sets their start and end positions
  for(int i = 0; i < numberOfWorkers; i++){
    workers.get(i).setStart(workersStartX.get(i), workersStartY.get(i));
    workers.get(i).setEnd(workersEndX.get(i), workersEndY.get(i));
    workers.get(i).display();
    workers.get(i).animation(tornadoOnMap);
  }
  
  //Creation of craters were objects can't be put from the randomly selected positions
  for (int i = 0; i < numberOfCrater; i++) {
    tile[craterCol[i]][craterRow[i]].setType(CRATER);
    tile[craterCol[i]][craterRow[i]].apply(tile[craterCol[i]][craterRow[i]].getType(), tile[craterCol[i]][craterRow[i]].isFull());
  }

  //Creation of the map by displaying the object present in the tile
  for (int i = 0; i < columns; i++) {
    for (int j = 0; j < rows; j++) {
      //Displays the tiles
      tile[i][j].display();
      //Draws the object placed inside the tile if there is one
      tile[i][j].apply(tile[i][j].getType(), tile[i][j].isFull());

      //If the mouse is on an empty tile while the eraser is off and the player has not lost
      if (objectType != EMPTY && tile[i][j].collision(mouseX - mapDecalX, mouseY - mapDecalY) && tile[i][j].isFull() == false && cantPlay == false && mouseY <= height - controlPannelHeight) {
        //Creation of the size of the selection on the map from the width and height slider's values
        for (int k = 0; k < widthSliderPos; k++) {
          for (int l = 0; l < heightSliderPos; l++) {
            //If the selection is inside the screen
            if (i-k >= 0 && j-l >= 0) {
              //Checks if the tile is empty
              if (tile[i-k][j-l].isFull() == false) {
                //Shows a preview of the object about to be added
                tile[i-k][j-l].preview(objectType);

                //If the mouse is clicked while on an empty tile
                if (mousePressed) {
                  //If the object selected is a house
                  if (objectType == HOUSE) {
                    //If there is still material left to build the house
                    if (woodBank > 0) {
                      //Creatse a halo effect
                      tile[i-k][j-l].startHalo(true);
                      //Draws a house on the tile
                      tile[i-k][j-l].setType(objectType);
                      //Plays the drop sound
                      drop.rewind();
                      drop.play();
                      //Adds the workers start path
                      workersStartX.append(tile[i-k][j-l].getX());
                      workersStartY.append(tile[i-k][j-l].getY());
                      //Adds a new worker
                      workers.add(new Person(tileSize));
                    }
                  }
                  else if(objectType == BUILDING){
                    //Creates a halo effect
                    tile[i-k][j-l].startHalo(true);
                    //Draws the selected object on the tile
                    tile[i-k][j-l].setType(objectType);
                    //Plays the drop sound
                    drop.rewind();
                    drop.play();
                    //Adds the workers end path
                    workersEndX.append(tile[i-k][j-l].getX());
                    workersEndY.append(tile[i-k][j-l].getY());
                  }
                  //If the object selected is not a house
                  else {
                    //Creatse a halo effect
                    tile[i-k][j-l].startHalo(true);
                    //Draws the selected object on the tile
                    tile[i-k][j-l].setType(objectType);
                    //Plays the drop sound
                    drop.rewind();
                    drop.play();
                  }
                  //If the object drawn on the map is a tree
                  if (tile[i][j].getType() == TREE) {
                    //Keeps track of the number of trees on the map
                    treeNumber += 1;
                    //Decreases the budget by the price of the tree
                    moneyLevel -= TREE_PRICE;
                  }
                  //If the object drawn on the map is a building
                  if (tile[i][j].getType() == BUILDING) {
                    //Keeps track of the number of buildings on the map
                    buildingNumber += 1;
                    //Decreases the budget by the price of the building
                    moneyLevel -= BUILDING_PRICE;
                  }
                  //If the object drawn on the map is a house and the wood bank in not empty
                  if (tile[i][j].getType() == HOUSE && woodBank > 0) { 
                    //Keeps track of the number of houses on the map
                    houseNumber += 1;
                    //Decreases the budget by the price of the house
                    moneyLevel -= HOUSE_PRICE;
                    //Decreases the wood bank by the number of houses
                    woodBank -= 1;
                  }
                }
              }
            }
          }
        }
      }

      //If the mouse is on a full tile while the eraser is on and the player has not lost
      if (objectType == EMPTY && tile[i][j].collision(mouseX - mapDecalX, mouseY - mapDecalY) && tile[i][j].isFull() == true && cantPlay == false && mouseY <= height - controlPannelHeight) {
        //If the mouse is clicked
        if (mousePressed) {
          //If the object erased is a tree
          if (tile[i][j].getType() == TREE) {
            //Resets the animation of the tree
            tile[i][j].tree.reset();
            //Keeps track of the number of trees on the map
            treeNumber -= 1;
            //Increases the wood bank by the quantity of cut down trees
            woodBank += 1;
            //Plays the drop sound
            drop.rewind();
            drop.play();
          }
          //If the object erased is a building
          if (tile[i][j].getType() == BUILDING) {
            //Resets the animation of the building
            tile[i][j].building.reset();
            //Keeps track of the number of buildings on the map
            buildingNumber -= 1;
            //Plays the drop sound
            drop.rewind();
            drop.play();
            //Removes the end path of the worker
            for(int n = 0; n < workersEndX.size(); n++){
              if(workersEndX.get(n) == tile[i][j].getX() && workersEndY.get(n) == tile[i][j].getY()){
                workersEndX.remove(n);
                workersEndY.remove(n);
              }
            }
            
          }
          //If the object erased is a house
          if (tile[i][j].getType() == HOUSE) {
            //Resets the animation of the building
            tile[i][j].house.reset();
            //Keeps track of the number of houses on the map
            houseNumber -= 1;
            //Plays the drop sound
            drop.rewind();
            drop.play();
            //Removes the start path of the worker
            for(int n = 0; n < workersStartX.size(); n++){
              if(workersStartX.get(n) == tile[i][j].getX() && workersStartY.get(n) == tile[i][j].getY()){
                workersStartX.remove(n);
                workersStartY.remove(n);
              }
            }
            //Removes a worker
            workers.remove(workers.size() - 1);
            
          }
          //Creatse an explosion effect
          tile[i][j].startExplosion(true);
          //Empties the tile
          tile[i][j].setType(EMPTY);
        }
      }

      //If the tornado hits one of the tiles
      if (tile[i][j].collision(tornado.getX(), tornado.getY()) && tile[i][j].getType() != CRATER) {
        //Checks if the tornato hited a tree
        if (tile[i][j].getType() == TREE) { 
          //Restets the animation of the tree
          tile[i][j].tree.reset();
        }
        //Checks if the tornato hited a building
        if(tile[i][j].getType() == BUILDING){
        //Removes the end path of the worker
          for(int n = 0; n < workersEndX.size(); n++){
            if(workersEndX.get(n) == tile[i][j].getX() && workersEndY.get(n) == tile[i][j].getY()){
              workersEndX.remove(n);
              workersEndY.remove(n);
            }
          }
        }
        //Checks if the tornato hited a house
        if(tile[i][j].getType() == HOUSE){
        //Removes the start path of the worker
          for(int n = 0; n < workersStartX.size(); n++){
            if(workersStartX.get(n) == tile[i][j].getX() && workersStartY.get(n) == tile[i][j].getY()){
              workersStartX.remove(n);
              workersStartY.remove(n);
            }
          }
        }
        //If the tile is not empty
        if(tile[i][j].getType() != EMPTY){
          //Creatse an explosion effect
          tile[i][j].startExplosion(true);
          //Empties the tile
          tile[i][j].setType(EMPTY);
          //Plays the drop sound
          drop.rewind();
          drop.play();
        }
      }
    }
  }

  //-------------- Tornado

  //Displays the tornado
  tornado.display(50, cantPlay);
  
  //If the tornado enters the screen
  if(tornado.getY() > 0 && tornado.getY() <= 1 && !cantPlay){
    //Plays the wind sound 
    wind.rewind();
    wind.play();
    //Initialisation of the tornado on screen variable to true;
    tornadoOnMap = true;
  }
  
  //If the tornado leaves the screen
  if(tornado.getY() >= rows*tileSize + 50){
    //Stops the wind sound
    wind.pause();
    //Initialisation of the tornado on screen variable to false;
    tornadoOnMap = false;
  }
  
  pop();

  //-------------- Smoke trails

  //Creation of the smoke trails on the sides of the screen
  smoke(0, 0, 1, 1, 0); //Top of the screen
  smoke(0, controlPannelPosition, 1, -1, 0); //Bottom of the screen
  smoke(width, 0, 1, 1, 90); //Right side of the screen
  smoke(0, height, 1, 1, 270); //Left side of the screen
  
  //-------------- Map display
  
  //Creation of the map display at the corner of the screen
  mapDisplay(mapDisplayX, mapDisplayY, mapDisplayWidth, mapDisplayHeight);
  
  if(!cantPlay){
    //If the mouse cursor is on the map display
    if(mouseX >= mapDisplayX && mouseX <= mapDisplayX+mapDisplayWidth && mouseY >= mapDisplayY && mouseY <= mapDisplayY+mapDisplayHeight){
      //Makes the map display slowly disapear
      if(mapOpacity > 0)
        mapOpacity -= mapOpacitySpeed;
    }
    //If the mouse cursor is not on the map display
    else{
      //Makes the map display slowly apear
      if(mapOpacity < 1)
        mapOpacity += mapOpacitySpeed;
    }
  }

  //------------------------------------------------ Control pannel ---------------------------------------------------

  //---------------- Body
  //Creation of the body of the control pannel
  noStroke();
  colorMode(RGB, 255, 255, 255);
  fill(150);
  rectMode(CORNER);
  rect(0, controlPannelPosition, width, controlPannelHeight);

  //Creation of the sections of decorative screws
  for (int i = 0; i < width; i+= width/3) {
    for (int j = 30; j < controlPannelHeight; j+= 30) {
      //Draws the circle of the srew
      noStroke();
      fill(200);
      circle(i, controlPannelPosition + j, 10);
      
      //Draws the line of the screw
      fill(0);
      rectMode(CENTER);
      rect(i, controlPannelPosition + j, 8, 1);
    }
  }

  //---------------- Slider
  
  //Initialisation of the fonts and alignments for all of the slider's text
  textFont(digital_20, 20);
  textAlign(CENTER);

  //Displays the width slider
  widthSlider.display();
  
  //Can only move if the player has not lost
  if (cantPlay == false) widthSlider.move(); 
  
  //Initialisation of the minimum and maximum values of the slider
  widthSlider.setSliderPosition(1, 10);
  
  //If the value of the slider changed, plays the click sound
  if(widthSlider.valueChanged() == true){
    click.rewind();
    click.play();
  }

  //Displays the height slider
  heightSlider.display();
  
  //Can only move if the player has not lost
  if (cantPlay == false) heightSlider.move();
  
  //Initialisation of the minimum and maximum values of the slider
  heightSlider.setSliderPosition(1, 10);
  
  //If the value of the slider changed, plays the click sound
  if(heightSlider.valueChanged() == true){
    click.rewind();
    click.play();
  }

  //--------------- Buttons
  
  //Initialisation of the fonts and alignments for all of the button's text
  textFont(digital_20, 20);
  textAlign(CENTER);

  //Displays the buttons of the control pannel
  treeButton.display();
  buildingButton.display();
  houseButton.display();
  eraserButton.display();

  //Only applys the hover effect if the player has not lost
  if (cantPlay == false) {
    //If the tree button is hovered
    if (treeButton.collision(mouseX, mouseY)) {
      //Makes it the active color
      treeButton.isActive(true);
      //If the button is clicked
      if (mousePressed) {
        //Initialisation of the type to tree
        objectType = TREE;
        //Plays the click sound
        click.rewind();
        click.play();
      }
    }
    //If the tree button is not hovered
    else {
      //Makes it the normal color
      treeButton.isActive(false);
    }

    //If the type is tree
    if (objectType == TREE) {
      //Makes the color the active color
      treeButton.isActive(true);
    }


    //If the building button is hovered
    if (buildingButton.collision(mouseX, mouseY)) {
      //Makes it the active color
      buildingButton.isActive(true);
      //If the button is clicked
      if (mousePressed) {
        //Initialisation of the type to building
        objectType = BUILDING;
        //Plays the click sound
        click.rewind();
        click.play();
      }
    }
    //If the building button is not hovered
    else {
      //Makes it the normal color
      buildingButton.isActive(false);
    }

    //If the type is building
    if (objectType == BUILDING) {
      //Makes the color the active color
      buildingButton.isActive(true);
    }


    //If the house button is hovered
    if (houseButton.collision(mouseX, mouseY)) {
      //Makes it the active color
      houseButton.isActive(true);
      //If the button is clicked
      if (mousePressed) {
        //Initialisation of the type to building
        objectType = HOUSE;
        //Plays the click sound
        click.rewind();
        click.play();
      }
    }
    //If the house button is not hovered
    else {
      //Makes it the normal color
      houseButton.isActive(false);
    }

    //If the type is house
    if (objectType == HOUSE) {
      //Makes the color the active color
      houseButton.isActive(true);
    }

    //If the eraser button is hovered
    if (eraserButton.collision(mouseX, mouseY)) {
      //Makes it the active color
      eraserButton.isActive(true);
      //If the button is clicked
      if (mousePressed) {
        //Initialisation of the eraser to true
        objectType = EMPTY;
        //Plays the click sound
        click.rewind();
        click.play();
      }
    }
    //If the eraser button is not hovered
    else {
      //Makes it the normal color
      eraserButton.isActive(false);
    }

    //If the eraser is true
    if (objectType == EMPTY) {
      //Makes the color the active color
      eraserButton.isActive(true);
    }
  }

  //----------- Numbers

  //Execute the code every second if the player has not lost
  if (millis() - timer >= 1000 && cantPlay == false) {
    //Resets the timer
    timer = millis();
    
    //Makes the money go up if there is at least one building and one house (at least one worker)
    moneyLevel += min(buildingNumber, houseNumber)*0.5;
    
    //Makes the air less breathable per building (pollution)
    airQuality -= buildingNumber*0.01;
    
    //If the quality of the air is not at it's fullest
    if (airQuality < 100) {
      //Makes the air more breathable per tree
      airQuality += treeNumber*0.005;
    }
  }

  //Initialisation of the variables for positionning the text
  int boxDecal = 200;
  int textDecal = 10;
  int textSpace = 40;
  
  //Draws the screen that displays the informations
  rectMode(CENTER);
  fill(0);
  stroke(80);
  strokeWeight(10);
  rect(width - boxDecal, height - controlPannelHeight/2, 250, 150);
  
  //Initialisation of the fonts and alignments for all of the screen's text
  textFont(digital_20, 20);
  textAlign(CENTER);

  //Changes the color of the information depending on the money level
  //Makes the text green if the budget is above 50000
  if (moneyLevel > 50000) fill(greenColor);
  //Makes the text yellow if the budget is under 50000 and over 10000
  else if (moneyLevel <= 50000 && moneyLevel > 10000) fill(yellowColor);
  //Makes the text red if the budget is under 10000
  else if (moneyLevel <= 10000) fill(redColor);
  //Draws the text for the money level
  text("Budget : " + moneyLevel + " $", width - boxDecal, height - controlPannelHeight/2 - textSpace + textDecal);

  //Changes the color of the information depending on the air quality
  //Makes the text green if the air quality is above 50
  if (airQuality > 50) fill(greenColor);
  //Makes the text yellow if the air quality is under 50 and over 20
  else if (airQuality <= 50 && airQuality > 20) fill(yellowColor);
  //Makes the text red if the air quality is under 20
  else if (airQuality <= 20) fill(redColor);
  //Draws the text for the air quality
  text("Air  quality : " + int(constrain(airQuality, 0, 100)) + "  */*", width - boxDecal, height - controlPannelHeight/2 + textDecal);

  //Changes the color of the information depending on the quantity of wood
  //Makes the text green if the wood bank is above 100
  if (woodBank > 100) fill(greenColor);
  //Makes the text yellow if the wood bank is under 100 and above 5
  else if (woodBank <= 50 && woodBank > 5) fill(yellowColor);
  //Makes the text red if the wood bank is under 5
  else if (woodBank <= 5) fill(redColor);
  //Draws the text for the quantity of wood
  text("Wood  bank : " + woodBank, width - boxDecal, height - controlPannelHeight/2 + textSpace + textDecal);

  //------------------------------------------------ Gameplay ---------------------------------------------------

  //If the air quality is at 0
  if (airQuality <= 0) {
    //Prevent the player from playing
    cantPlay = true;
    //Draws the pannel indicationg that the game is over
    gameLost(NO_AIR);
  }
  //If the money level is at 0
  if (moneyLevel <= 0) {
    //Prevent the player from playing
    cantPlay = true;
    //Draws the pannel indicationg that the game is over
    gameLost(NO_MONEY);
  }
    
  //---------------- Restart game
  
  //Show the resart question if the variable is true
  if(restartGameQuestion)  
    restartGame();
    
  //-------------------------------------------------- Tutorial ---------------------------------------------------------
  
  //Show the tutorial if it's active
  if(showTutorial)  
    tutorial();
  
}

// ..............................................................................................................................................................
//                                                                   FUNCTIONS
// ..............................................................................................................................................................

//------------------------------------------------ Smoke ---------------------------------------------------

//Draw a line of smoke
void smoke(float positionX, float positionY, int scaleX, int scaleY, float rotate) {
  //Initialisation of the size of one cloud of smoke
  float smokeCloudSize = 100;
  
  //Initialisation of the speed of the smoke clouds
  smokeDecal += 0.1;
  
  //If the smoke trail goes far enought outside the screen, restart the animation
  if (smokeDecal >= smokeCloudSize/3) {
    smokeDecal = 0;
  }

  //Draws the trail from the clouds
  push();
  translate(positionX, positionY);
  rotate(radians(rotate)); //Makes it so the line can be rotated to fit the other sides of the screen
  scale(scaleX, scaleY);
  for (float i = -smokeCloudSize/2; i <= width+smokeCloudSize/2; i += smokeCloudSize/3) {
    for (float j = -smokeCloudSize/2; j <= smokeCloudSize; j += smokeCloudSize/2) {
      //Draws a smoke cloud
      colorMode(RGB, 255, 255, 255);
      fill(100, map(airQuality, 0, 100, 50, 0));//Initialisation of the opacity proportionally to the air quality
      noStroke();
      circle(i + smokeDecal, map(j, 0, smokeCloudSize, smokeCloudSize/3, smokeCloudSize), map(j, 0, smokeCloudSize, smokeCloudSize, smokeCloudSize/3));
    }
  }
  pop();
}

//--------------------------------------------- Map display --------------------------------------------------------

//Draw a little display indicating the position of the player on the map
void mapDisplay(float mapPositionX, float mapPositionY, float mapWidth, float mapHeight){
  //Initialisation of the opacity animation of the map
  float animationOpacity = lerp(0, 100, mapOpacity);
  float lineOpacity = lerp(0, 255, mapOpacity);
  
  //Draws a representation of the craters on the map
  for(int i = 0; i < numberOfCrater; i++){
    noStroke();
    fill(0, animationOpacity);
    circle(mapPositionX + (tile[craterCol[i]][craterRow[i]].getX()*mapWidth)/(columns*tileSize), mapPositionY + (tile[craterCol[i]][craterRow[i]].getY()*mapHeight)/(rows*tileSize), 3);
  }
  
  //Draw a representation of the objects on the map
  for (int i = 0; i < columns; i++) {
    for (int j = 0; j < rows; j++) {
      if(tile[i][j].getType() != EMPTY){
        noStroke();
        fill(tile[i][j].getColor(), animationOpacity);
        circle(mapPositionX + (tile[i][j].getX()*mapWidth)/(columns*tileSize), mapPositionY + (tile[i][j].getY()*mapHeight)/(rows*tileSize), 3);
      }
    }
  }
  
  //Draws a representation of the tornado on the map
  noStroke();
  fill(255, animationOpacity);
  circle(mapPositionX + constrain((tornado.getX()*mapWidth)/(columns*tileSize), 0, mapWidth), mapPositionY + constrain((tornado.getY()*mapHeight)/(rows*tileSize), 0, mapHeight), 3);
  
  //Initialisation of the common styles of the squares
  noFill();
  stroke(255, lineOpacity);
  rectMode(CORNER);
  
  //Draws the representation of the main map
  strokeWeight(3);
  rect(mapPositionX, mapPositionY, mapWidth, mapHeight);
  
  //Draws the representation of the main map
  strokeWeight(3);
  rect(mapPositionX - (mapDecalX*mapWidth)/(columns*tileSize), mapPositionY - (mapDecalY*mapHeight)/(rows*tileSize), ((COLUMNS_PER_SCREEN*tileSize)*mapWidth)/(columns*tileSize), ((ROWS_PER_SCREEN*tileSize)*mapHeight)/(rows*tileSize));
}

//------------------------------------------------ Game lost ---------------------------------------------------

//Draws the pannel indicating that the game is over
void gameLost(int message) {
  //Draws the dark background
  fill(0, 150);
  noStroke();
  rectMode(CENTER);
  rect(width/2, height/2, width, height);

  //Draws the screen displaying the message
  stroke(80);
  strokeWeight(20);
  fill(0);
  rect(width/2, height/2, width*0.8, height*0.8);

  //Draws the Game over message
  fill(255);
  textAlign(CENTER);
  textFont(digital_100, 50);
  text("Game  Over", width/2, height*0.3, width/2, 50);

  //Draws the message explaining why the player lost
  textFont(digital_100, 30);
  
  //If the player lost because of poor air quality
  if (message == NO_AIR)
    text("Unfortunately,  the  air  quality  in  your  city  is  too  low  for  life  to  be  possible.", width/2, height*0.45, width/2, 2*30);
  //If the player lost because of a lack of budget
  if (message == NO_MONEY)
    text("Unfortunately, you  have  used  up  your  entire  budget.", width/2, height*0.45, width/2, 2*30);


  //Draws the players statistics
  text("Budget : " + max(0, moneyLevel) + " $", width/4, height*0.6, width*0.8, 30);
  text("Air  quality : " + int(constrain(airQuality, 0, 100)) + "  */*", width/2, height*0.6, width*0.8, 30);
  text("Wood  bank : " + woodBank, width - width/4, height*0.6, width*0.8, 30);

  //Displays the restart button
  textFont(digital_20, 20);
  restartButton.display();

  //If the button is hovered
  if (restartButton.collision(mouseX, mouseY)) {
    //Makes it the active color
    restartButton.isActive(true);
    //If the button is clicked
    if (mousePressed) {
      reset();
      //Plays the click sound
      click.rewind();
      click.play();
    }
  }
  //If the button is not hovered
  else {
    //Makes it the normal color
    restartButton.isActive(false);
  }
}

//------------------------------------------------ Restart ---------------------------------------------------

//Checks if a key was pressed
void keyPressed(){
  //Only checks if the game is on
  if(!cantPlay){
    //Makes the reset question variable true if the "R" key is pressed
    if(key == 'r' || key == 'R'){
      restartGameQuestion = true;
    }
  }
}

//Draws the pannel asking if the game needs to be restarted
void restartGame(){
  //Draws the dark background
  fill(0, 150);
  noStroke();
  rectMode(CENTER);
  rect(width/2, height/2, width, height);

  //Draws the screen displaying the message
  stroke(80);
  strokeWeight(20);
  fill(0);
  rect(width/2, height/2, width*0.8, height*0.8);

  //Draws the restart message
  fill(255);
  textAlign(CENTER);
  textFont(digital_100, 50);
  text("Restart", width/2, height*0.3, width/2, 50);
  
  //Draws the restart question
  textFont(digital_100, 30);
  text("Do  you  really  want  to  restart  your  game?", width/2, height*0.45, width/2, 2*30);
  
  //Displays the quetion buttons
  textFont(digital_20, 20);
  yesButton.display();
  noButton.display();
  
  //If the yes button is hovered
  if (yesButton.collision(mouseX, mouseY)) {
    //Makes it the active color
    yesButton.isActive(true);
    //If the button is clicked
    if (mousePressed) {
      reset();
      restartGameQuestion = false;
      //Plays the click sound
      click.rewind();
      click.play();
    }
  }
  //If the button is not hovered
  else {
    //Makes it the normal color
    yesButton.isActive(false);
  }
  
  //If the no button is hovered
  if (noButton.collision(mouseX, mouseY)) {
    //Makes it the active color
    noButton.isActive(true);
    //If the button is clicked
    if (mousePressed) {
      restartGameQuestion = false;
      //Plays the click sound
      click.rewind();
      click.play();
    }
  }
  //If the button is not hovered
  else {
    //Makes it the normal color
    noButton.isActive(false);
  }
}

//------------------------------------------------ Reset ---------------------------------------------------

//Resets the game
void reset() {
  //Removes all of the objects on the map
  for (int i = 0; i < columns; i++) {
    for (int j = 0; j < rows; j++) {
      tile[i][j].setType(EMPTY);
    }
  }
  
  //Initialisation of a new size for the planet
  columns = int(random(COLUMNS_PER_SCREEN, COLUMNS_PER_SCREEN*2));
  rows = int(random(ROWS_PER_SCREEN, ROWS_PER_SCREEN*2));
  
  //Creation of the sqares were the objects can be placed
  tile = new Tile[columns][rows];
  
  //Creation of all the tiles from the size, the number of rows and the number of columns
  for (int i = 0; i < columns; i++) {
    for (int j = 0; j < rows; j++) {
      tile[i][j] = new Tile(tileSize*i, tileSize*j, tileSize);
    }
  }

  //Selects random positions for all of the craters
  for (int i = 0; i < numberOfCrater; i++) {
    craterCol[i] = int(random(0, columns));
    craterRow[i] = int(random(0, rows));
  }

  //Initialisation of the variables to their original values
  treeNumber = 0;
  buildingNumber = 0;
  houseNumber = 0;
  moneyLevel = 1000000;
  airQuality = 50;
  woodBank = 0;
  mapDecalX = 0;
  mapDecalY = 0;
  
  //Removes all or the workers starting points
  for(int n = 0; n < workersStartX.size(); n++){
    workersStartX.remove(n);
    workersStartY.remove(n);
  }
  
  //Removes all or the workers end points
  for(int n = 0; n < workersEndX.size(); n++){
    workersEndX.remove(n);
    workersEndY.remove(n);
  }
  
  //Removes all of the workers
  for(int n = 0; n < numberOfWorkers; n++){
    workers.remove(n);
  }

  //Initialisation of the color of the ground to a random color to represent a different planet
  colorMode(HSB, 360, 100, 100);
  groundColor = color(random(360), 25, 50);

  //Allows the player to play
  cantPlay = false;
}
