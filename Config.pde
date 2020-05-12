final int HEIGHT_START_WINDOW = 480;
final int TOTAL_WIDTH = 640;
final int HEIGHT_BUBBLE_WINDOW = HEIGHT_START_WINDOW;
final int MELODY_VISUALISATION_HEIHGT = 200;
final int NUMBER_OF_BEATS = 8;
final int DETECTION_FREQUENCY_THRESHOLD = 3;
final float MUSIC_SPEED = 0.85; // todo: find a formula to calculate that (something like width of the screen divided by the time I want the line to move through it)
final int FRAME_COUNT_FOR_8_SECONDS = 424; 

PeopleVisualisation peopleVisualisation;
BubbleManager bubbleManager;
PeopleDetector detector;
GWindow musicWindow;
Kinect kinect;
PImage depthImg;
Minim minim; 


boolean hasKinect; 
boolean debugOn; 
boolean startVisualisation; 

int[] peopleToBeat;
int[] lastPeopleDetected; 
int[] peopleDetectionFrequency;

int startTime;
int bubbleId;
