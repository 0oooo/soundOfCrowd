import ddf.minim.*; //<>//
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import g4p_controls.*;


//------------------------------------------------------------
//-------------------------SETUP-----------------------
//------------------------------------------------------------

void setup() {
  size(640, 480);
  initMode();
  initVariables(); 
  setupTools(); 
}


//------------------------------------------------------------
//-------------------------MAIN WIDNDOW---------------------
//------------------------------------------------------------

synchronized void draw() {
  setupMainDrawing();

  switch (state) {
  case 0:
    displayModeSelection();
    
    if(!hasKinect){
      setupDefaultPeople();
      fill(255, 2, 2);
      text("No kinect so no detector initialized. \nUsing default list of people to use or debug the other functionalities. ", 10, (HEIGHT_START_WINDOW / 3)); 
    }
    break;
  
  case 1:
  
     if(selectedMode.equals("play") || selectedMode.equals("debug")){
       
       // If selected mode is debug, it will print info about each modules 
       if(selectedMode.equals("debug")){
         setDebugOn();
       }
       
       // Detect the people through the kinect
       detectPeople();
       
       // Start the visualisation in the other window
       startVisualisation = true; 
              
       // Create the visualisation of the full participation       
       runBubbleFactory(); 
     }
     
     // If selected mode is kinect, it will show what the kinect is seeing (video stream of depth value)
     if(selectedMode.equals("kinect")){
       showKinectVideo();
     }
      
     break; 
     
   default: 
     sendErrorMessage();
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
