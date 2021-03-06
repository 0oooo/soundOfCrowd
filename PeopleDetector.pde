/** //<>// //<>//
 * Kinect class that detects depth, 
 * Reduces it to a list of 8 depths
 * Send the list of detection to the PeopleInstrumentManager
 * Resolution kinect = 640 x 480 
 */

class PeopleDetector {

  private final int THRESHOLD_DEPTH_DETECTION_MAX = 900;
  private final int THRESHOLD_DEPTH_DETECTION_MIN = 700;
  private final double THRESHOLD_PIXELS_NOT_IN_DETECTED_ZONE = 0.3; 
  private final int numberOfPixels;

  private int numberOfBeats; 

  private int[] rawDepth;              // depth captured by the kinect
  private int[] scaledDepthPerPixel;   // depth transformed following the threshold
  private int[] depthAsListOfBeats;    // depth transformed into a list of X beats   
  
  private boolean debugOn; 
  private boolean printedDebugMode; 

  public PeopleDetector(int numberOfBeats) {
    numberOfPixels = kinect.width * kinect.height;
    rawDepth = new int[numberOfPixels];
    scaledDepthPerPixel = new int[numberOfPixels];

    this.numberOfBeats = numberOfBeats; 
    depthAsListOfBeats = new int[numberOfBeats];
    
    debugOn = false;
    printedDebugMode = false; 
  }
  
  public void setDebugOn(){
    if(printedDebugMode == false){
      print("People Detector, debug mode on");
      printedDebugMode = true; 
    }
    this.debugOn = true; 
  }
  
  public void setDebugOff(){
    this.debugOn = false;
  }

  public int getMainDepthPerZone(int startColumnIndex, int endColumnIndex, int totalPixelsToExplore, int[][] snapOfDepthImage) {
    int maxNumberOfPixelsOutZone = (int) Math.round(totalPixelsToExplore * THRESHOLD_PIXELS_NOT_IN_DETECTED_ZONE);
    int numberOfPixelOutZone = 0; 
    int pixelsWithADepth = 0; 
    int totalDepthOfPixelWithADepth = 0; 
    for (int i = startColumnIndex; i < endColumnIndex; i++) {
      for (int j = 0; j < snapOfDepthImage.length; j++)
        if (snapOfDepthImage[j][i] == 0) {
          numberOfPixelOutZone++;
        }else{
          totalDepthOfPixelWithADepth += snapOfDepthImage[j][i];
          pixelsWithADepth++; 
        }
      if (numberOfPixelOutZone > maxNumberOfPixelsOutZone) {
        return 0;
      }
    }
    int meanOfDepth = Math.round(totalDepthOfPixelWithADepth / pixelsWithADepth); 
    return meanOfDepth;  
  }

  //todo : add a "mirror" mode to chose if we want the original list or the reverse one? 
  private void reverseList(){
    int[] reverseList = new int[depthAsListOfBeats.length];
    
    for(int i = 0, j = depthAsListOfBeats.length -1; i < reverseList.length && j >= 0; i++, j--){
      reverseList[i] = depthAsListOfBeats[j];
    }
    depthAsListOfBeats = reverseList; 
  }
  
  public int[] getMainDepth() {
    int[][] imageMatrix = make2dArrayDepth();

    int totalWidth = kinect.width; 
    int totalHeight = kinect.height; 
    int areaWidth = totalWidth / numberOfBeats; 
    int totalPixelToExplore = areaWidth * totalHeight;

    for (int x = 0, i = 0; x < totalWidth && i < numberOfBeats; x += areaWidth, i++) {  
      depthAsListOfBeats[i] = getMainDepthPerZone(x, x + areaWidth, totalPixelToExplore, imageMatrix);
    }
    if(debugOn){
      printDepth();
    }
    reverseList();
    return depthAsListOfBeats;
  }

  private int[][] make2dArrayDepth() {
    int numOfColumns = kinect.width; 
    int numOfRows = kinect.height;
    int[][] depth2dArray = new int[numOfRows][numOfColumns];
    int[] snapOfDepthImage = scaledDepthPerPixel; 

    for (int i = 0; i < numOfColumns; i++) {
      for (int j = 0; j < numOfRows; j++) {
        depth2dArray[j][i] = snapOfDepthImage[j*numOfColumns + i];
      }
    }

    return depth2dArray;
  }
  
  private int getDepthScaled(int currentDepth){
    int maxScaledDepth = numberOfBeats; 
    int maxMinusMin = THRESHOLD_DEPTH_DETECTION_MAX - THRESHOLD_DEPTH_DETECTION_MIN; 
    int currentDepthMinusMin = currentDepth - THRESHOLD_DEPTH_DETECTION_MIN;
    //todo replace by map : round(map(currentDepth, THRESHOLD_DEPTH_DETECTION_MIN, THRESHOLD_DEPTH_DETECTION_MAX, 1, 7))
    //return Math.round((currentDepthMinusMin * maxScaledDepth) / maxMinusMin);
    return (int) map(currentDepth, THRESHOLD_DEPTH_DETECTION_MIN, THRESHOLD_DEPTH_DETECTION_MAX, 1, 7);
  }

  synchronized public void draw(boolean showVideo) {
    // Get the raw depth as array of integers
    rawDepth = kinect.getRawDepth();

    for (int i=0; i < rawDepth.length; i++) {
      if (rawDepth[i] >= THRESHOLD_DEPTH_DETECTION_MIN && rawDepth[i] <= THRESHOLD_DEPTH_DETECTION_MAX) {
        scaledDepthPerPixel[i] = getDepthScaled(rawDepth[i]);
        depthImg.pixels[i] = color(130, 168, 222);
      } else {
        scaledDepthPerPixel[i] = 0; 
        depthImg.pixels[i] = color(0);
      }
    }

    if (showVideo) {
      depthImg.updatePixels();
      image(depthImg,0, 0);
      fill(0);
    }
  }


  //------------------------------------------------------------------
  //-------------------------DEBUG FUNCTIONS--------------------------
  //------------------------------------------------------------------

  public void drawVideo() {
    // Draw the raw image
    //image(kinect.getDepthImage(), 0, 0); 

    depthImg.updatePixels();
    image(depthImg,0, 0);
    fill(0);
  }


  public void printDepth() {
    System.out.println("");
    for (int d : depthAsListOfBeats) {
      System.out.print(d + " ");
    }
    System.out.println("");
  }

  public void printRawDepth() {
    System.out.println("");
    for (int d : rawDepth) {
      System.out.print(d + " ");
    }
    System.out.println("");
  }
  
  public void printDepthPerPixel(){
    System.out.println("");
    for (int d : scaledDepthPerPixel) {
      System.out.print(d + " ");
    }
    System.out.println("");
  }

  private void print2DArray(int[][] arrayToPrint) {
    for (int i = 0; i < arrayToPrint.length; i++) {
      System.out.println("");
      for (int j = 0; j < arrayToPrint[i].length; j++) {
        System.out.print(arrayToPrint[i][j]);
      }
    }
  }
}
