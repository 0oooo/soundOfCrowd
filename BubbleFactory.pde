

class BubbleFactory {
  
  private boolean debugOn; 
  
  public BubbleFactory(){
    debugOn = false; 
  }
  
  private void randomBubbleGenerator(){
    if(debugOn)
      print(" Adding a new bubble ");
    
    float first = random (0, TOTAL_WIDTH + 1); // 120 = max and 100 = min
    float second = random (0, HEIGHT_START_WINDOW + 1);
    float third = random (5, 15);
    bubbleManager.addBubble(new Bubble(first, second, third, bubbleId, debugOn));
  }
  
  public void createBubble(){
    if(debugOn){
        print("DETECTION_FREQUENCY_THRESHOLD =", DETECTION_FREQUENCY_THRESHOLD); 
        print("\nDetected: ");
    }
        for(int i = 0; i < peopleDetectionFrequency.length; i++){
          if(debugOn)
             print(peopleDetectionFrequency[i] + " "); 
          if(peopleDetectionFrequency[i] >= DETECTION_FREQUENCY_THRESHOLD){ 
              randomBubbleGenerator(); // add on a different thread?
              bubbleId++;
              peopleDetectionFrequency[i] = 0; 
          }
        }
        if(debugOn)
          print("\n"); 
  }
  
  public void setDebugOn(){
    debugOn = true; 
  }
  
}
