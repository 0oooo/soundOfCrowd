/**
* Class that keeps a list of bubbles, their moves, draw
* Decide the important ones that will generate the sounds
* Keep a threshold of the max number of bubbles that can generates the background sound. 
*/

class BubbleManager{
  
  //private ArrayList<Bubble> bubbles; 
  private HashMap<Integer, Bubble> bubblesMap;
  private final int MAX_NUMBER_OF_BUBBLES = 3;
  private int numberOfBubbles; 
  private int maxHeightForBubbles;
  private boolean debugOn; 
  private boolean printedDebugMode; 
  private int firstBubbleInList; 
  
  public BubbleManager(int bottomBubbleProjection){
    numberOfBubbles = 0; 
    maxHeightForBubbles = bottomBubbleProjection;
    //bubbles = new ArrayList<Bubble>(); 
    bubblesMap = new HashMap<Integer, Bubble>(); 
    debugOn = false; 
    printedDebugMode = false; 
    firstBubbleInList = 0; 
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
      //bubbles.add(bubble); 
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
  
  private void checkCollision(Bubble bubble){
   for(Map.Entry bubbleInMap : bubblesMap.entrySet()){
      Bubble otherBubble = (Bubble) bubbleInMap.getValue(); 
      bubble.checkCollision(otherBubble); 
    }
  }
  
  public void draw(){
    for(Map.Entry bubbleInMap : bubblesMap.entrySet()){ //<>//
      Bubble bubble = (Bubble) bubbleInMap.getValue(); 
      bubble.update();  //<>//
      bubble.display();  //<>// //<>//
      bubble.checkBoundaryCollision(maxHeightForBubbles); 
      checkCollision(bubble); 
    }
  } 

}
