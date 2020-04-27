import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import g4p_controls.*;

 //<>//
//------------------------------------------------------------
//-------------------------SETUP-----------------------
//------------------------------------------------------------

void init() {
  initMode();
  peopleToBeat = new int[NUMBER_OF_BEATS];
  lastPeopleDetected = new int[NUMBER_OF_BEATS];
  peopleDetectionFrequency = new int[NUMBER_OF_BEATS];
  setupMelodyVisualisation();
  setupBubbles();
  setupKinectDetection(); 
}

void secondWinSetup(){
  musicWindow = GWindow.getWindow(this, "Music Visualisation", 100, 50, 640, 210, JAVA2D);
  musicWindow.addDrawHandler(this, "makeMusicWindow");
}

void makeMusicWindow(PApplet app, GWinData windata){
  app.background(255);
  app.strokeWeight(1);
  app.stroke(126);
  app.fill(0); 
  if(startVisualisation){
    makeMelody(app);
  }
}

void setup() {
  size(640, 490);
  init(); 
  secondWinSetup();
}

synchronized void setupDrawingAreas(){
  background(255);
  strokeWeight(1);
  stroke(126);
}


//------------------------------------------------------------
//-------------------------MAIN FUNCTIONS---------------------
//------------------------------------------------------------

synchronized void draw() {
  setupDrawingAreas();

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
       
       startVisualisation = true; 
              
       // Create the visualisation of the full participation       
       makeBubble(); 
     
     // If the mode selected was none of the above and was not catch earlier = unexpected error. 
     }else{
       sendErrorMessage();
     }
     break; 
     
   default: 
     displayModeSelection();
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
