/**
* Creates a bar that goes from left to right in 10 seconds
* Takes the list of detected people and put them on the screen
* Depth changes the y-position and x is just their x-position
*/
class MelodyVisualisation {
  
  private int startMelodyArea; 
  private int bottomOfProjection;
  private int heightMelodyArea; 
  private int xPosition; 
  private int widthProjection; 
  private int[] listOfPeople; 
  private float widthOfPeopleSlot; 
  private float radius;
  private final int NUMBER_OF_BEATS = 8; 
  private final int MAX_DEPTH = 9; 
  private boolean debugOn; 
  private boolean printedDebugMode; 
  
  MelodyVisualisation(int startMelodyArea, int bottomOfProjection, int widthProjection){
      this.startMelodyArea = startMelodyArea; 
      this.bottomOfProjection = bottomOfProjection;
      heightMelodyArea = bottomOfProjection - startMelodyArea;
      xPosition = 0;
      this.widthProjection = widthProjection;
      listOfPeople = new int[8]; 
      widthOfPeopleSlot = widthProjection / NUMBER_OF_BEATS;
      radius = (heightMelodyArea / MAX_DEPTH );
      printedDebugMode = false; 
  }
  
  public void setDebugOn(){
    if(printedDebugMode == false){
      println("Melody Visualisation, debug mode on");
      printedDebugMode = true; 
    }
    this.debugOn = true; 
  }
  
  public void setDebugOff(){
    this.debugOn = false;
  }
  
  public void updateListOfPeople(int[] listOfPeople){
    this.listOfPeople = listOfPeople; 
  }
  
  private void updateXPosition(){
    if(xPosition == widthProjection){
      xPosition = 0; 
    } else{
      xPosition++;
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
  
  private void drawPeople(){
    for(int i = 0; i < listOfPeople.length; i++){ 
      if(listOfPeople[i] > 0){
        noStroke(); 
        fill(51, 128, 204);
        ellipse(getXPosition(i), getYPosition(listOfPeople[i]), radius*2, radius*2);
      }
    }
  }
  
  private void drawLine(){
    strokeWeight(4); 
    stroke(245, 229, 83);
    line(xPosition, startMelodyArea, xPosition, bottomOfProjection);   
  }
  
  private void drawPeopleSlot(){
    for(int i = 0; i < widthProjection; i += widthOfPeopleSlot){
      fill(10 + (i/ 10));
      rect(i, startMelodyArea, widthOfPeopleSlot, heightMelodyArea);
    }
  }
  
  public void draw(){ 
    
    drawPeopleSlot(); 
    drawPeople();
    
    updateXPosition();
    drawLine(); 
  }

}
