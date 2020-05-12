/**
* Creates a bar that goes from left to right in 10 seconds
* Takes the list of detected people and put them on the screen
* Depth changes the y-position and x is just their x-position
*/
class PeopleVisualisation{
  
  private int startMelodyArea; 
  private int bottomOfProjection;
  private int heightMelodyArea; 
  private float xPosition; 
  private int widthProjection; 
  private int[] listOfPeople; 
  private int[] leftSideOfPeople; 
  private boolean[] hasSomeoneIn; 
  private float widthOfPeopleSlot; 
  private float radius;
  private final int NUMBER_OF_BEATS = 8; 
  private final int MAX_DEPTH = 9; 
  private boolean debugOn; 
  private boolean printedDebugMode;
  private float speed; 
  private MelodyMaster melodyMaster; 
  
  PeopleVisualisation(int startMelodyArea, int bottomOfProjection, int widthProjection, float speed){
      this.startMelodyArea = startMelodyArea; 
      this.bottomOfProjection = bottomOfProjection;
      heightMelodyArea = bottomOfProjection - startMelodyArea;
      xPosition = 0;
      this.widthProjection = widthProjection;
      listOfPeople = new int[8]; 
      widthOfPeopleSlot = widthProjection / NUMBER_OF_BEATS;
      radius = (heightMelodyArea / MAX_DEPTH );
      printedDebugMode = false; 
      this.speed = speed; 
      melodyMaster = new MelodyMaster(); 
      
      leftSideOfPeople = new int[NUMBER_OF_BEATS];       
      hasSomeoneIn = new boolean[NUMBER_OF_BEATS];
      fillListsOfSide();
  }
  
  private void fillListsOfSide(){
    for (int i = 0; i < leftSideOfPeople.length; i++){
      float totalBlankSpace = widthOfPeopleSlot - (2 * radius);
      float sideBlankSpace = totalBlankSpace / 2; 
      leftSideOfPeople[i] =  round(sideBlankSpace + i * widthOfPeopleSlot);
      hasSomeoneIn[i] = false; 
    }
  }
  
  public void setDebugOff(){
    this.debugOn = false;
  }
  
  public void updateListOfPeople(int[] listOfPeople){
    this.listOfPeople = listOfPeople; 
  }
  
  private void updateXPosition(){
    if(xPosition >= widthProjection){ 
      xPosition = 0; 
    } else{
      xPosition = xPosition + speed;
    }
  }
  
  private float getXPosition(int positionInArray){
    return ((positionInArray+1) * widthOfPeopleSlot) -  (widthOfPeopleSlot / 2);
  }
  
  private float getYPosition(int depth){
    if(debugOn){
      print("vertical slot = " + heightMelodyArea / MAX_DEPTH); 
      print("\n heightMelodyArea = " + heightMelodyArea); 
      print("\n startMelodyArea = " + startMelodyArea); 
      print("\n returns => " + ((depth *  heightMelodyArea / MAX_DEPTH) + startMelodyArea ));
    }
    return (depth *  heightMelodyArea / MAX_DEPTH) + startMelodyArea ; 
  }
  
  private void drawPeople(PApplet app){
    for(int i = 0; i < listOfPeople.length; i++){ 
      if(listOfPeople[i] > 0){
        app.noStroke(); 
        app.fill(51, 128, 204);
        app.ellipse(getXPosition(i), getYPosition(listOfPeople[i]), radius*2, radius*2);
        
        hasSomeoneIn[i] = true; 
      } else{
        hasSomeoneIn[i] = false;
      }
    }
  }
  
  private void drawPeopleSlot(PApplet app){
    for(int i = 0; i < widthProjection; i += widthOfPeopleSlot){
      app.fill(10 + (i/ 10));
      app.rect(i, startMelodyArea, widthOfPeopleSlot, heightMelodyArea);
    }
  }
  
  private void drawLine(PApplet app){
    app.strokeWeight(4); 
    app.stroke(245, 229, 83);
    app.line(xPosition, startMelodyArea, xPosition, bottomOfProjection);   
  }
  
  public int isTouchingPeople(){ 
    int slotIndex = floor(xPosition / widthOfPeopleSlot); 
    if(slotIndex < NUMBER_OF_BEATS){
      if(hasSomeoneIn[slotIndex]){
        if(debugOn)
          print("People detected in slot " + slotIndex + " with xPosition = " + xPosition + "\n"); 
        int xpos = round(xPosition);
        if(xpos == leftSideOfPeople[slotIndex]){
          if(debugOn)
            print("WE'RE TOUCHING CAPTAIN\n");
          return slotIndex;  
        }
      }else{
        if(debugOn)
          print("NO ONE IN SLOT " + slotIndex + " with xPosition = " + xPosition + "\n"); 
      }
    }
    return -1; 
  }
  
  
  
  public boolean isAtStartPoint(){
    return (xPosition <= 1);
  }
  
  public void draw(PApplet app){ 
    
    drawPeopleSlot(app); 
    drawPeople(app);
    
    updateXPosition();
    if(isTouchingPeople() > 0){
      int note = listOfPeople[isTouchingPeople()];
      melodyMaster.update(note); //todo make that nicer
    }
    drawLine(app); 
  }
  
  
  //------------------------------------------------------------
  //----------------------DEBUG FUNCTIONS---------------------
  //------------------------------------------------------------
  
    public void setDebugOn(){
    if(printedDebugMode == false){
      println("Melody Visualisation, debug mode on");
      printedDebugMode = true; 
    }
    this.debugOn = true; 
    melodyMaster.setDebugOn(); 
  }
  
  private void printLeftSideOfPeople(){
    for(float people : leftSideOfPeople){
      print(people + " ");
    }
    print("\n"); 
  }
  
    private void printLeftOfBool(){
    for(boolean someoneIn : hasSomeoneIn){
      print(someoneIn + " ");
    }
    print("\n"); 
  }

}
