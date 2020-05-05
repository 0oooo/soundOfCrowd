

class BubbleFactory {
  
  private void randomBubbleGenerator(){
    print(" Adding a new bubble "); 
    int first = (int)(Math.random() * 120 + 100); // 120 = max and 100 = min
    int second = (int)(Math.random() * 400 + 100);
    int third = (int)(Math.random() * 30 + 20);
    bubbleManager.addBubble(new Bubble(first, second, third, bubbleId));
  }
  
  public void createBubble(){
      print("DETECTION_FREQUENCY_THRESHOLD =", DETECTION_FREQUENCY_THRESHOLD); 
      print("\nDetected: "); 
        for(int i = 0; i < peopleDetectionFrequency.length; i++){
           print(peopleDetectionFrequency[i] + " "); 
          if(peopleDetectionFrequency[i] >= DETECTION_FREQUENCY_THRESHOLD){ 
              randomBubbleGenerator(); 
              bubbleId++;
              peopleDetectionFrequency[i] = 0; 
          }
        }
        print("\n"); 
  }
  
  
}