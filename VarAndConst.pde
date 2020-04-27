int HEIGHT_START_WINDOW = 500;
int TOTAL_WIDTH = 640;
int HEIGHT_BUBBLE_WINDOW = HEIGHT_START_WINDOW;
int MELODY_VISUALISATION_HEIHGT = 200;
int NUMBER_OF_BEATS = 8;
int DETECTION_FREQUENCY_THRESHOLD = 3;
float MUSIC_SPEED = 1.50; // todo: find a formula to calculate that (something like width of the screen divided by the time I want the line to move through it)

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
