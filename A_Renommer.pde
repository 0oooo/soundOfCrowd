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
}

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
  lastPeopleDetected = peopleToBeat; 
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
  int widthMelodyVisualisation = TOTAL_WIDTH;
  float speed = MUSIC_SPEED; 
  melodyVisualisation = new MelodyVisualisation(0, MELODY_VISUALISATION_HEIHGT, widthMelodyVisualisation, speed);
  melodyVisualisation.updateListOfPeople(peopleToBeat);
}

void makeMelody(PApplet app){
   melodyVisualisation.updateListOfPeople(peopleToBeat); 
   melodyVisualisation.draw(app);
}

//------------------------------------------------------------
//-------------------------BUBBLES SETUP-----------------------
//------------------------------------------------------------

void setupBubbles(){
  bubbleManager = new BubbleManager(HEIGHT_BUBBLE_WINDOW);
}

//TODO delete
int id = 0;

synchronized void randomBubbleGenerator(){
  print(" Adding a new bubble "); 
  int first = (int)(Math.random() * 120 + 100); // 120 = max and 100 = min
  int second = (int)(Math.random() * 400 + 100);
  int third = (int)(Math.random() * 30 + 20);
  bubbleManager.addBubble(new Bubble(first, second, third, id));
  id++;
}

synchronized void peopleDectectionFrequencyGenerator(){
  for(int i = 0; i < peopleToBeat.length; i++){
    if(peopleToBeat[i] == lastPeopleDetected[i] && peopleToBeat[i] > 0){
      peopleDetectionFrequency[i]++; 
    }else{
      peopleDetectionFrequency[i] = 0;
    }
  }
}

synchronized void bubbleGenerator(){
  print("DETECTION_FREQUENCY_THRESHOLD = ", DETECTION_FREQUENCY_THRESHOLD); 
  print("Detected: "); 
    for(int i = 0; i < peopleDetectionFrequency.length; i++){
       print(peopleDetectionFrequency[i] + " "); 
      if(peopleDetectionFrequency[i] >= DETECTION_FREQUENCY_THRESHOLD){ 
          randomBubbleGenerator(); 
          peopleDetectionFrequency[i] = 0; 
      }
    }
    print("\n");
}

synchronized void makeBubble(){
   if (frameCount % 480 == 0) { //NB kinect = 60? frames per seconds
      thread("peopleDectectionFrequencyGenerator");
      thread("bubbleGenerator"); 
   }
   bubbleManager.draw();
}

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

void setDebugOn(){
   bubbleManager.setDebugOn();
   melodyVisualisation.setDebugOn(); 
   if(hasKinect){
     detector.setDebugOn();
   }else{
     println("No kinect so no detector initialized. To debug the detector, plug a kinect"); 
   }
}
