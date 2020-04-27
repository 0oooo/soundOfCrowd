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
int DETECTION_FREQUENCY_THRESHOLD = 20;

MelodyVisualisation melodyVisualisation;
BubbleManager bubbleManager;
PeopleDetector detector;

boolean hasKinect; 

int[] peopleToBeat;
int[] lastPeopleDetected; 
int[] peopleDetectionFrequency;

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

void showKinectVideo(){
   // Draw the raw image
   if(hasKinect){
     image(kinect.getDepthImage(), 0, 0);
   }else{
     print("No kinect detected, kinect mode invalid"); 
   }
}

//------------------------------------------------------------
//---------------------PEOPLE DETECTION-----------------------
//------------------------------------------------------------

void setupDefaultPeople(){
  println("Setting up the default array of people."); 
  int[] defaultPeople = {0, 4, 5, 2, 7, 1, 8, 2};
  peopleToBeat = defaultPeople;
}

synchronized void detectPeople(){
   if (hasKinect){
     detector.draw(false);
     if(frameCount % 480 == 0){
       print("New frame to be used"); 
        // keep track of the last people detected for the bubble generator
       lastPeopleDetected = peopleToBeat; 
       peopleToBeat = detector.getMainDepth(); // todo fix me :)
       print("peopleToBeat = ");
       detector.printDepth();
     }
   }
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

void makeMelody(){
   melodyVisualisation.updateListOfPeople(peopleToBeat); 
   melodyVisualisation.draw();
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

synchronized void peopleDectectionFrequencyGenerator(){
  for(int i = 0; i < peopleToBeat.length; i++){
    if(peopleToBeat[i] == lastPeopleDetected[i]){
      peopleDetectionFrequency[i]++; 
    }else{
      peopleDetectionFrequency[i] = 0;
    }
  }
}

synchronized void bubbleGenerator(){
    for(int i = 0; i < peopleDetectionFrequency.length; i++){
      if(peopleDetectionFrequency[i] >= DETECTION_FREQUENCY_THRESHOLD){
          randomBubbleGenerator();
      }
    }
}

synchronized void makeBubble(){
   peopleDectectionFrequencyGenerator();
   bubbleGenerator();
   bubbleManager.draw();
}

//------------------------------------------------------------
//----------------------MESSAGE FUNCTIONS---------------------
//------------------------------------------------------------

synchronized void displayModeSelection(){
    fill(255, 2, 2);
    text(errorText, 10, 363); 
    fill(0); 
    text ("Please choose a mode between \"debug\", \"kinect\" (to see what the kinect sees), and  \"play\".\n"+selectedMode, 10, 333); 
}


synchronized void sendErrorMessage(){
    println("Unexpected error: the mode selected is unknown."); 
    fill(255, 2, 2);
    text ("An unexpected error happened. An unknown mode has been selected. Please restart the program. ", 10, 333); 
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

void setDebugOn(){
   bubbleManager.setDebugOn();
   melodyVisualisation.setDebugOn(); 
   if(hasKinect){
     detector.setDebugOn();
   }else{
     println("No kinect so no detector initialized. To debug the detector, plug a kinect"); 
   }
}

//------------------------------------------------------------
//-------------------------TOTAL SETUP-----------------------
//------------------------------------------------------------

void setup() {
  size(640, 700);
  initMode();
  
  peopleToBeat = new int[NUMBER_OF_BEATS];
  lastPeopleDetected = new int[NUMBER_OF_BEATS];
  peopleDetectionFrequency = new int[NUMBER_OF_BEATS];
  setupMelodyVisualisation();
  setupBubbles();
  setupKinectDetection(); 
}


//------------------------------------------------------------
//-------------------------MAIN FUNCTIONS---------------------
//------------------------------------------------------------

synchronized void setupDrawing(){
  background(255);
  strokeWeight(1);
  stroke(126);
  line(0, BUBBLE_PROJECTION_HEIGHT, 640, BUBBLE_PROJECTION_HEIGHT);
}

synchronized void draw() {
  setupDrawing();

  switch (state) {
  case 0:
    displayModeSelection();
    break;
  
  case 1:
     // If selected mode is debug, it will print info about each modules 
     if(selectedMode.equals("debug")){
       setDebugOn(); 
     }
     
     // If selected mode is kinect, it will show what the kinect is seeing (video stream of depth value)
     if(selectedMode.equals("kinect")){
       showKinectVideo();
     }
      
     if(selectedMode.equals("play")){
       // Detect the people through the kinect
       detectPeople(); 
      
       // Create the visualisation of the detected people
       makeMelody(); 
       
       
       // Create the visualisation of the full participation
       //if (frameCount % 480 == 0) { //NB kinect = 60? frames per seconds
       //   thread("randomBubbleGenerator");
       //}
        makeBubble(); 
     
     // If the mode selected was none of the above and was not catch earlier = unexpected error. 
     }else{
       sendErrorMessage();
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
        errorText = "Selected mode does not exist: "+selectedMode + ".\nSelect \"debug\" OR \"kinect\" OR \"play\".\n NB: capitals letters are badly dealt with in Processing.";
        resetSelectedMode(); 
      }
    } else{
      selectedMode = selectedMode + key;
    }
  }
}
