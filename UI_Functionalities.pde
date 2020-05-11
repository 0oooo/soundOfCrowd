//------------------------------------------------------------
//----------------------MESSAGE FUNCTIONS---------------------
//------------------------------------------------------------

synchronized void displayModeSelection(){
    fill(255, 2, 2);    
    text(errorText, 10, (HEIGHT_START_WINDOW / 2) + 40); 
    fill(0); 
    text ("Please choose a mode between \"debug\", \"kinect\" (to see what the kinect sees), and  \"play\".\n"+selectedMode, 10, HEIGHT_START_WINDOW / 2); 
}


synchronized void sendErrorMessage(){
    println("Unexpected error: the mode selected is unknown."); 
    fill(255, 2, 2);
    text ("An unexpected error happened. An unknown mode has been selected. Please restart the program. ", 10, HEIGHT_START_WINDOW / 2); 
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

//------------------------------------------------------------
//----------------------DEBUG FUNCTIONS---------------------
//------------------------------------------------------------

void setDebugOn(){
   if(hasKinect){
     detector.setDebugOn();
   }
   bubbleManager.setDebugOn();
   peopleVisualisation.setDebugOn(); 
}

//------------------------------------------------------------
//-------------------------SECOND WIDNDOW---------------------
//------------------------------------------------------------


void secondWinSetup(){
  musicWindow = GWindow.getWindow(this, "Music Visualisation", 320, 650, 640, 200, JAVA2D);
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
