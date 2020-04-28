final int HEIGHT_START_WINDOW = 480;
final int TOTAL_WIDTH = 640;
final int HEIGHT_BUBBLE_WINDOW = HEIGHT_START_WINDOW;
final int MELODY_VISUALISATION_HEIHGT = 200;
final int NUMBER_OF_BEATS = 8;
final int DETECTION_FREQUENCY_THRESHOLD = 3;
final float MUSIC_SPEED = 0.6; // todo: find a formula to calculate that (something like width of the screen divided by the time I want the line to move through it)
final int FRAME_COUNT_FOR_8_SECONDS = 424; 

MelodyVisualisation melodyVisualisation;
BubbleManager bubbleManager;
PeopleDetector detector;

boolean hasKinect; 
boolean debugOn = false; 
boolean startVisualisation = false; 

int[] peopleToBeat;
int[] lastPeopleDetected; 
int[] peopleDetectionFrequency;

GWindow musicWindow;

Kinect kinect;

PImage depthImg;

int startTime;
