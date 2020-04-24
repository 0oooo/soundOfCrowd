import org.openkinect.freenect.*;
import org.openkinect.processing.*;

boolean debugOn = false; 

int TOTAL_HEIGHT = 700;
int TOTAL_WIDTH = 640;
int PROJECTION_HEIGHT = TOTAL_HEIGHT;
float PERCENTAGE_BUBBLE_PROJECTION = 0.7;
int BUBBLE_PROJECTION_HEIGHT = round(PROJECTION_HEIGHT * PERCENTAGE_BUBBLE_PROJECTION);
int GREY_AREA = 10;
int MELODY_VISUALISATION_HEIHGT = PROJECTION_HEIGHT - (GREY_AREA + BUBBLE_PROJECTION_HEIGHT);
int NUMBER_OF_BEATS = 8;

MelodyVisualisation melodyVisualisation;
BubbleManager bubbleManager;
PeopleDetector detector;

boolean hasKinect; 

int[] peopleToBeat;

//------------------------------------------------------------
//-------------------------KINECT SETUP-----------------------
//------------------------------------------------------------

void setupKinectDetection(){
   println("Looking for a kinect"); 
   kinect = new Kinect(this);
   
   if(kinect.numDevices() > 0){ 
     println("Setting up the kinect detection");
     hasKinect = true; 
     kinect.initDepth();
     // Blank image
     depthImg = new PImage(kinect.width, kinect.height);
     detector = new PeopleDetector(NUMBER_OF_BEATS);
   }else{
     println("No kinect has been found"); 
     setupDefaultPeople();
   } 
} //<>//

void setupDefaultPeople(){
  println("Setting up the default array of people."); 
  int[] defaultPeople = {0, 4, 5, 2, 7, 1, 8, 2};
  peopleToBeat = defaultPeople;
}

//------------------------------------------------------------
//-------------------PEOPLE PLAYER SETUP----------------------
//------------------------------------------------------------

void setupMelodyVisualisation(){
  int startMelodyVisualisation = PROJECTION_HEIGHT - MELODY_VISUALISATION_HEIHGT - GREY_AREA;
  int endMelodyVisualisation = TOTAL_HEIGHT;
  int widthMelodyVisualisation = TOTAL_WIDTH;
  melodyVisualisation = new MelodyVisualisation(startMelodyVisualisation, endMelodyVisualisation, widthMelodyVisualisation);
  melodyVisualisation.updateListOfPeople(peopleToBeat);
}

//------------------------------------------------------------
//-------------------------BUBBLES SETUP-----------------------
//------------------------------------------------------------

void setupBubbles(){
  bubbleManager = new BubbleManager(BUBBLE_PROJECTION_HEIGHT);
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


//------------------------------------------------------------
//-------------------------TOTAL SETUP-----------------------
//------------------------------------------------------------

void setup() {
  size(640, 700);
  initMode();
  
  peopleToBeat = new int[NUMBER_OF_BEATS];
  setupMelodyVisualisation();
  setupBubbles();
  setupKinectDetection(); 
}

//------------------------------------------------------------
//-------------------------MAIN FUNCTION-----------------------
//------------------------------------------------------------

void setDebugOn(){
   bubbleManager.setDebugOn();
   melodyVisualisation.setDebugOn(); 
   if(hasKinect){
     detector.setDebugOn();
   }else{
     println("No kinect so no detector initialized. To debug the detector, plug a kinect"); 
   }
}

synchronized void displayModeSelection(){
    fill(255, 2, 2);
    text(errorText, 10, 363); 
    fill(0); 
    text ("Please choose a mode between \"debug\", \"kinect\" (to see what the kinect sees),  \"play\" and \"bubble\".\n"+selectedMode, 10, 333); 
}

synchronized void deleteLastLetter(){
      if(selectedMode.length() <= 1){
        selectedMode = ""; 
      }else{     
        String newWord = selectedMode.substring(0, selectedMode.length() - 1);
        selectedMode = ""; 
        selectedMode = newWord;
        //println("length = ", selectedMode.length() );
      }
      //println(selectedMode);
}

synchronized void draw() {
  background(255);
  strokeWeight(1);
  stroke(126);
  line(0, BUBBLE_PROJECTION_HEIGHT, 640, BUBBLE_PROJECTION_HEIGHT);

  switch (state) {
  case 0:
    displayModeSelection();
    break;
  
  case 1:
   if (selectedMode.equals("bubble")){
      bubbleManager.setDebugOn();
      if (frameCount % 480 == 0) { //NB kinect = 60? frames per seconds
        thread("randomBubbleGenerator");
         //bubbleManager.draw();
      }
      bubbleManager.draw();
   }
   else {  
     if(selectedMode.equals("debug")){
       setDebugOn(); 
     }else if(selectedMode.equals("kinect")){
       // Draw the raw image
       image(kinect.getDepthImage(), 0, 0);
     }
      
     if (hasKinect){
       detector.draw(false);
       if(frameCount % 480 == 0){
         print("New frame to be used"); 
         peopleToBeat = detector.getMainDepth(); // todo fix me :)
         print("peopleToBeat = ");
         detector.printDepth();
       }
     }
    
     melodyVisualisation.updateListOfPeople(peopleToBeat); 
     melodyVisualisation.draw();
     
     
     if (frameCount % 480 == 0) { //NB kinect = 60? frames per seconds
        thread("randomBubbleGenerator");
         //bubbleManager.draw();
      }
      bubbleManager.draw();
   }  
  }
 
}

void keyPressed() {
  if (key != CODED) {
    if(key==BACKSPACE){
       deleteLastLetter();
    }
    if (key==ENTER||key==RETURN) { 
      if(isInListOfModes(selectedMode)){
        state++;
      }else{
        errorText = "Selected mode does not exist: "+selectedMode + ".\nSelect \"debug\" OR \"kinect\" OR \"play\" OR \"BUBBLE\".\n NB: capitals letters are badly dealt with in Processing.";
        resetSelectedMode(); 
      }
    } else{
      selectedMode = selectedMode + key;
    }
  }
}
