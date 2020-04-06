/** //<>// //<>//
 * Kinect class that detects depth, 
 * Reduces it to a list of 8 depths
 * Send the list of detection to the PeopleInstrumentManager
 * Resolution kinect = 640 x 480 
 */


Kinect kinect;

// Depth image TODO DELETE
PImage depthImg;

class PeopleDetector {

  private final int THRESHOLD_DEPTH_DETECTION_MAX = 1000;
  private final int THRESHOLD_DEPTH_DETECTION_MIN = 0;
  private final double THRESHOLD_PIXELS_NOT_IN_DETECTED_ZONE = 0.3; 
  private final int numberOfPixels;

  private int numberOfBeats; 

  private int[] rawDepth;              // depth captured by the kinect
  private int[] scaledDepthPerPixel;   // depth transformed following the threshold
  private int[] depthAsListOfBeats;    // depth transformed into a list of X beats   

  public PeopleDetector(int numberOfBeats) {
    numberOfPixels = kinect.width * kinect.height;
    rawDepth = new int[numberOfPixels];
    scaledDepthPerPixel = new int[numberOfPixels];

    this.numberOfBeats = numberOfBeats; 
    depthAsListOfBeats = new int[numberOfBeats];
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
    return meanOfDepth;   //todo replae the 1 by mean of depth
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
    
    printDepth();
    
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
    //todo replace by map : round(map(currentDepth, THRESHOLD_DEPTH_DETECTION_MIN, THRESHOLD_DEPTH_DETECTION_MAX, 1, 8))
    return Math.round((currentDepthMinusMin * maxScaledDepth) / maxMinusMin); 
  }

  public void draw(boolean showVideo) {
    // Get the raw depth as array of integers
    rawDepth = kinect.getRawDepth();

    for (int i=0; i < rawDepth.length; i++) {
      if (rawDepth[i] >= THRESHOLD_DEPTH_DETECTION_MIN && rawDepth[i] <= THRESHOLD_DEPTH_DETECTION_MAX) {
        //scaledDepthPerPixel[i] = 1; // to do = replace that by the depth
        scaledDepthPerPixel[i] = getDepthScaled(rawDepth[i]);
        depthImg.pixels[i] = color(255);
      } else {
        scaledDepthPerPixel[i] = 0; 
        depthImg.pixels[i] = color(0);
      }
    }

    if (showVideo) {
      drawVideo();
    }
  }


  //------------------------------------------------------------------
  //-------------------------DEBUG FUNCTIONS--------------------------
  //------------------------------------------------------------------

  public void drawVideo() {
    // Draw the raw image
    image(kinect.getDepthImage(), 0, 0); 

    depthImg.updatePixels();
    image(depthImg, kinect.width, 0);
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
