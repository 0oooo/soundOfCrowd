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
  
  private int numberOfBeats; 
  private int[] depthList; 
  
  int[] depth = new int[NUMBER_OF_PIXELS];
  
  public PeopleDetector(int numberOfBeats){
    depthPerPixel = new int[NUMBER_OF_PIXELS];
   
   this.numberOfBeats = numberOfBeats; 
   depthList = new int[numberOfBeats];
  }
  
  public int[] getDepthList(){
    return depthList;
  }

  public void reduceQuality(){
  
     
  
  }
  
  public void drawVideo(){
        // Draw the raw image TODO DELETE
  image(kinect.getDepthImage(), 0, 0); 
      //TODO DELETE
    depthImg.updatePixels();
    image(depthImg, kinect.width, 0);
    fill(0);
  }

  public void draw(boolean showVideo) {
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
    
    if(showVideo){
      drawVideo();
    }

  }

}
