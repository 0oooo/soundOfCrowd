/**
* Class that keeps a list of bubbles, their moves, draw
* Decide the important ones that will generate the sounds
* Keep a threshold of the max number of bubbles that can generates the background sound. 
*/

class BubbleManager{
  
  private ArrayList<Bubble> bubbles; 
  private final int MAX_NUMBER_OF_BUBBLES = 3;
  private int numberOfBubbles; 
  private int maxHeightForBubbles;
  
  public BubbleManager(int bottomBubbleProjection){
    numberOfBubbles = 0; 
    maxHeightForBubbles = bottomBubbleProjection;
    bubbles = new ArrayList<Bubble>(); 
  }
  
  private void removeFirstBubble(){
    ArrayList<Bubble> newBubbles =  new ArrayList<Bubble>(); 
    for (int i = 1; i < numberOfBubbles - 1; i++){ //<>//
      newBubbles.add(bubbles.get(i)); //<>//
    }
    bubbles = newBubbles; 
    numberOfBubbles = 0; 
  }
  
  public void addBubble(Bubble bubble){
    //bubbles.add(bubble); 
    //numberOfBubbles++;
    //if(bubbles.size() == MAX_NUMBER_OF_BUBBLES){
    //  removeFirstBubble(); 
    //}
    
    //print("Number of bubbles = " + numberOfBubbles); 
    //print("MAX_NUMBER_OF_BUBBLES = " + MAX_NUMBER_OF_BUBBLES); 
    
    if(numberOfBubbles < MAX_NUMBER_OF_BUBBLES){
      bubbles.add(bubble); 
      numberOfBubbles++; 
    } else {
      removeFirstBubble(); 
    }
  }
  
  private void checkCollision(Bubble bubble){
    for(Bubble otherBubble : bubbles){
      bubble.checkCollision(otherBubble); 
    }
  }
  
  public void draw(){
    for(Bubble bubble : bubbles){ //<>//
      bubble.update();  //<>//
      bubble.display();  //<>// //<>//
      bubble.checkBoundaryCollision(maxHeightForBubbles); 
      checkCollision(bubble); 
    }
  } 

}
