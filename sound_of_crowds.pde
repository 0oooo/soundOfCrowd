import org.openkinect.freenect.*;
import org.openkinect.processing.*;

int TOTAL_HEIGHT = 700;
int TOTAL_WIDTH = 640;
int PROJECTION_HEIGHT = TOTAL_HEIGHT;
float PERCENTAGE_BUBBLE_PROJECTION = 0.7;
int BUBBLE_PROJECTION_HEIGHT = round(PROJECTION_HEIGHT * PERCENTAGE_BUBBLE_PROJECTION);
int GREY_AREA = 10;
int MELODY_VISUALISATION_HEIHGT = PROJECTION_HEIGHT - (GREY_AREA + BUBBLE_PROJECTION_HEIGHT);

MelodyVisualisation melodyVisualisation;
BubbleManager bubbleManager;
PeopleDetector detector; 



//TODO delete
//int[] fakePeopleList = { 1, 4, 3, 0, 0, 4, 1, 8};
int[] fakePeopleList = { 8, 1, 2, 3, 4, 5, 6, 7};

void setupMelodyVisualisation(){
  int startMelodyVisualisation = PROJECTION_HEIGHT - MELODY_VISUALISATION_HEIHGT - GREY_AREA;
  int endMelodyVisualisation = TOTAL_HEIGHT;
  int widthMelodyVisualisation = TOTAL_WIDTH;
  melodyVisualisation = new MelodyVisualisation(startMelodyVisualisation, endMelodyVisualisation, widthMelodyVisualisation);
  melodyVisualisation.updateListOfPeople(fakePeopleList); 
}

void setupBubbles(){
  bubbleManager = new BubbleManager(BUBBLE_PROJECTION_HEIGHT);
}

void setupDetector(){
  detector = new PeopleDetector(); 
  kinect = new Kinect(this);
  kinect.initDepth();
        // Blank image
  depthImg = new PImage(kinect.width, kinect.height);
}

//TODO delete
int id = 0;

synchronized void randomBubbleGenerator(){
  int first = (int)(Math.random() * 120 + 100); // 120 = max and 100 = min
  int second = (int)(Math.random() * 400 + 100);
  int third = (int)(Math.random() * 30 + 20);
  bubbleManager.addBubble(new Bubble(first, second, third, id));
  id++;
}


void setup() {
  size(640, 700);
  setupMelodyVisualisation();
  setupBubbles();
  setupDetector(); 
  

}

synchronized void draw() {
  //background(255);
  //strokeWeight(1);
  //stroke(126);
  //line(0, BUBBLE_PROJECTION_HEIGHT, 640, BUBBLE_PROJECTION_HEIGHT);

  ////melodyVisualisation.draw();

  //if (frameCount % 480 == 0) { //NB kinect = 60? frames per seconds
  //   thread("randomBubbleGenerator");
  //   bubbleManager.draw();
  //}

  //bubbleManager.draw();
  detector.draw(); 
}
