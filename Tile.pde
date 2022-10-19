class Tile{
  
  //Imports the tree object
  Tree tree;
  //Imports the building object
  Building building;
  //Imports the house object
  House house;
  //Imports the particles object
  ArrayList<Particles> particles = new ArrayList<Particles>();
  //Imports the halo object
  ArrayList<Halo> halo = new ArrayList<Halo>();
  
  //Variables
  //Tiles variables
  float tilePosX;
  float tilePosY;
  float tileSize;
  int type;
  
  //Explosion variables
  boolean showExplosion = false;
  color explosionColor;
  
  //Halo variables
  float timerHalo;
  boolean showHalo = false;
  
  //Constructor
  Tile(int _tilePosX, int _tilePosY, int size){
    //Sets the variables of one tile to the parameters
    tilePosX = _tilePosX;
    tilePosY = _tilePosY;
    tileSize = size;
    
    //Creates a tree object
    tree = new Tree(_tilePosX+size/2, _tilePosY+size/2, size*0.1, size*0.8);
    
    //Creates a building object
    building = new Building(_tilePosX+size/2, _tilePosY+size/2, size*0.5, size);
    
    //Creates a house object
    house = new House(_tilePosX+size/2, _tilePosY+size*0.75, size*0.5, size);
  }
  
  //Displays a tile
  void display(){
    //Draws the cross signs indicating the tiles
    strokeWeight(1);
    stroke(0, 255/4);
    noFill();
    line(getX() - tileSize/2 - 5, getY() - tileSize/2, getX() - tileSize/2 + 5, getY() - tileSize/2);
    line(getX() - tileSize/2, getY() - tileSize/2 - 5, getX() - tileSize/2, getY() - tileSize/2 + 5);
    
    //Keeps track of the color of the tile's last object for the particles
    if(getColor() != 0){
      explosionColor = getColor();
    }
    
    //Shows the explosion effect or the halo effest if the object is not a crater
    if(this.type != CRATER){
      explosion();
      halo();
    }
  }
  
  //Shows a preview of the object about to be added
  void preview(int type){
    //Sets the base style of all the previews
    strokeWeight(1);
    stroke(0);
    noFill();
    
    //If the selected object is a tree
    if(type == TREE){
      //Preview a circle
      circle(getX(), getY(), 20);
    }
    
    //If the selected object is a building
    else if(type == BUILDING){
      //Preview a square
      square(getX(), getY(), 20);
    }
    
    //If the selected object is a house
    else if(type == HOUSE){
      //Preview an arc
      arc(getX(), getY(), 20, 20, PI, TWO_PI);
    }
  }
  
  //Draws the object depending on the selected type
  void apply(int type, boolean isFull){
    //If the selected object is a tree and the tile is full
    if(type == TREE && isFull){
      //Draw a tree
      tree.display();
    }
    
    //If the selected object is a building and the tile is full
    else if(type == BUILDING && isFull){
      //Draw a building
      building.display();
    }
    
    //If the selected object is a building and the tile is full
    else if(type == HOUSE && isFull){
      //Draw a building
      house.display();
    }
    
    //If the selected object is a crater and the tile is full
    else if(type == CRATER && isFull){
      //Draws the body of the crater
      noStroke();
      fill(0, 50);
      quad(getX() - 10, getY() - 5,
           getX() + 10, getY() - 5,
           getX() + 15, getY() + 10,
           getX() - 15, getY() + 10);
           
      //Draws the hole of the crater
      fill(0);
      ellipse(getX(), getY() - 5, 20, 10);
    }
  }
  
  //Draws the explosion effect
  void explosion(){
    //Creates and rotates all of the particles to give an explosion effect
    push();
    translate(getX(), getY());
    for(int i = 0; i < particles.size(); i++){
      //Rotates the particle
      rotate(radians((360/particles.size())*i));
      
      //Sets the particle's position and color
      particles.get(i).setColor(explosionColor);
      particles.get(i).setPosition(0, 0);
      
      //Displays the particle
      particles.get(i).display(random(2, 5), showExplosion);
      
      //Animates the particle
      particles.get(i).update(showExplosion);
      
      //Removes the particle when it's no longer visible
      if(particles.get(i).remove())
        particles.remove(i);
    }
    pop();
  }
  
  //Checks if the explosion can start
  void startExplosion(boolean start){
    //Starts the explosion
    showExplosion = start;
    
    //Resets the explosion animation
    for(int i = 0; i < 20; i++){
      particles.add(new Particles(random(10, 20)));
    }
  }
  
  //Draw the halo effect
  void halo(){
    for(int i = 0; i < halo.size(); i++){
      
      //Draws a halo every 80 milliseconds
      if(millis() - timerHalo >= 80*i){
        
        //Animate and displays the halo
        halo.get(i).update(showHalo);
        halo.get(i).display();
        
        //Remove the halo when it's no longer visible
        if(halo.get(i).remove())
          halo.remove(i);
      }
    }
  }
  
  //Checks if the halo can start
  void startHalo(boolean start){
    //Restarts the halo timer
    timerHalo = millis();
    
    //Starts the halo
    showHalo = start;
    
    //Creates new halos
    for(int i = 0; i < 3; i++){
      halo.add(new Halo(getX(), getY()));
    }
  }
  
  //Returns the X position of the tile
  float getX(){
    return tilePosX + tileSize/2;
  }
  
  //Returns the Y position of the tile
  float getY(){
    return tilePosY + tileSize/2;
  }
  
  //Sets the type of the object added to the tile
  void setType(int type){
    this.type = type;
  }
  
  //Returns the type of the object added to the tile
  int getType(){
    return this.type;
  }
  
  //Checks if the tile is full
  boolean isFull(){
    return (this.type != 0);
  }
  
  //Check if there is a collision with the tile
  boolean collision(float collisionX, float collisionY){
    return (collisionX > getX() - tileSize/2 && collisionX < getX() + tileSize/2 && collisionY > getY() - tileSize/2 && collisionY < getY() + tileSize/2);
  }
  
  //Return the color of the tree for the display map
  color getColor(){
    //Return the tree color if the tile has a tree on it
    if(this.type == TREE)
      return tree.getColor();
      
    //Return the building color if the tile has a building on it  
    else if(this.type == BUILDING)
      return building.getColor();
      
    //Return the house color if the tile has a house on it
    else if(this.type == HOUSE)
      return house.getColor();
    
    //Return black if none are selected
    else return 0;
  } 
}
