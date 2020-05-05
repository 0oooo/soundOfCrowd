/**
* Class that keeps a list of bubbles, their moves, draw
* Decide the important ones that will generate the sounds
* Keep a threshold of the max number of bubbles that can generates the background sound. 
*/

class BubbleManager extends Thread{
  
  private HashMap<Integer, Bubble> bubblesMap;
  public BubbleFactory bubbleFactory; 
  private final int MAX_NUMBER_OF_BUBBLES = 10;
  private int numberOfBubbles; 
  private int maxHeightForBubbles;
  private boolean debugOn; 
  private boolean printedDebugMode; 
  private int firstBubbleInList; 

  
  public BubbleManager(int bottomBubbleProjection){
    numberOfBubbles = 0; 
    maxHeightForBubbles = bottomBubbleProjection;
    bubblesMap = new HashMap<Integer, Bubble>(); 
    debugOn = false; 
    printedDebugMode = false; 
    firstBubbleInList = 0; 
    bubbleFactory = new BubbleFactory(); 
  }
  
  private void removeFirstBubble(){
    bubblesMap.remove(firstBubbleInList); 
    firstBubbleInList++;  //<>// //<>//
  }
  
 public void setDebugOn(){
   if(printedDebugMode == false){
      println("Bubble Manager, debug mode on"); 
      printedDebugMode = true; 
    }
    this.debugOn = true; 
  }
  
  public void setDebugOff(){
    this.debugOn = false;
  }
  
  public void addBubble(Bubble bubble){  
    if(numberOfBubbles < MAX_NUMBER_OF_BUBBLES){
      bubblesMap.put(bubble.getId(), bubble); 
      numberOfBubbles++; 
    } else {
      removeFirstBubble(); 
      numberOfBubbles--; 
    }
    
   if(debugOn){
      print("Number of bubbles = " + numberOfBubbles); 
      print("MAX_NUMBER_OF_BUBBLES = " + MAX_NUMBER_OF_BUBBLES);
    }
  }
  
  public boolean isDebugOn(){
    return debugOn; 
  }
  
  private void checkCollision(Bubble bubble){
   for(Map.Entry bubbleInMap : bubblesMap.entrySet()){
      Bubble otherBubble = (Bubble) bubbleInMap.getValue(); 
      bubble.checkCollision(otherBubble); 
    }
  }

  
  public void peopleDectectionFrequencyGenerator(){
    for(int i = 0; i < peopleToBeat.length; i++){
      if(peopleToBeat[i] == lastPeopleDetected[i] && peopleToBeat[i] > 0){
        peopleDetectionFrequency[i]++; 
      }else{
        peopleDetectionFrequency[i] = 0;
      }
    }
  }
  
  public void run(){
   if (frameCount % FRAME_COUNT_FOR_8_SECONDS == 0) { 
      peopleDectectionFrequencyGenerator();
      bubbleFactory.createBubble(); 
    }
  }
  
  public void draw(){
    for(Map.Entry bubbleInMap : bubblesMap.entrySet()){ //<>//
      Bubble bubble = (Bubble) bubbleInMap.getValue(); 
      bubble.update();  //<>//
      bubble.display();  //<>//
      bubble.checkBoundaryCollision(maxHeightForBubbles); 
      checkCollision(bubble); 
    }
  } 

}
