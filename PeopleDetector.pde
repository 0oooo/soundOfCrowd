/**
* Kinect class that detects depth, 
* Reduces it to a list of 8 depths
* Send the list of detection to the PeopleInstrumentManager
* Resolution kinect = 640 x 480 
*/


Kinect kinect;

// Depth image TODO DELETE
PImage depthImg;

class PeopleDetector{
  
  private int[] depthPerPixel; 
  private final int THRESHOLD_DEPTH_DETECTION_MAX = 900;
  private final int THRESHOLD_DEPTH_DETECTION_MIN = 100;
  private final int NUMBER_OF_PIXELS = 640 * 480;
  
  // We'll use a lookup table so that we don't have to repeat the math over and over
  int[] depth = new int[NUMBER_OF_PIXELS];
  
  public PeopleDetector(){
    depthPerPixel = new int[NUMBER_OF_PIXELS];
   
  }
  
  private void cutInEight(){
    int[] eighthOfImage = new int[NUMBER_OF_PIXELS/8];
    int indexOfNewImage = 0; 
    int numberOfFullPixels = 0;
    print("[");
    for (int i=0; i < depth.length; i+=8) {
      for(int j = i; j < i + 8; j++){
        numberOfFullPixels = 0; 
        if(depth[j] == 1){
          numberOfFullPixels++;
        }
      }
      if(numberOfFullPixels >= 6){
        eighthOfImage[indexOfNewImage] = 1; 
      }else{
        eighthOfImage[indexOfNewImage] = 0; 
      }
      print(eighthOfImage[indexOfNewImage]);
      indexOfNewImage++;
    }
    print("]\n\n");
  }

  public void draw() {
      // Draw the raw image TODO DELETE
  image(kinect.getDepthImage(), 0, 0); 

  // Get the raw depth as array of integers
  depth = kinect.getRawDepth();
  
   for (int i=0; i < depth.length; i++) {
      if (depth[i] >= THRESHOLD_DEPTH_DETECTION_MIN && depth[i] <= THRESHOLD_DEPTH_DETECTION_MAX) {
        depthPerPixel[i] = 1;
        depthImg.pixels[i] = color(255);
      } else {
        depthPerPixel[i] = 0; 
        depthImg.pixels[i] = color(0);
      }
    }
    
    cutInEight();
    
    //TODO DELETE
    depthImg.updatePixels();
  image(depthImg, kinect.width, 0);

  fill(0);
  }

}
