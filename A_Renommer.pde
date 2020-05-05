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
     fill(255, 2, 2);
     text("No kinect detected, kinect mode invalid", 10, (HEIGHT_START_WINDOW / 3));
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
     if(frameCount % FRAME_COUNT_FOR_8_SECONDS == 0){
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
//-------------------PEOPLE PLAYER---------------------------
//------------------------------------------------------------

void setupPeopleVisualisation(){
  int widthPeopleVisualisation = TOTAL_WIDTH;
  float speed = MUSIC_SPEED; 
  peopleVisualisation = new PeopleVisualisation(0, MELODY_VISUALISATION_HEIHGT, widthPeopleVisualisation, speed);
  peopleVisualisation.updateListOfPeople(peopleToBeat);
}

void makeMelody(PApplet app){
   peopleVisualisation.updateListOfPeople(peopleToBeat); 
   peopleVisualisation.draw(app);
}

void setupMelodyPlayer(){
  minim = new Minim(this);
  melodyPlayer = new MelodyPlayer(); 
}

//------------------------------------------------------------
//-------------------------BUBBLES----------------------------
//------------------------------------------------------------

void setupBubbles(){
  bubbleManager = new BubbleManager(HEIGHT_BUBBLE_WINDOW);
}

void runBubbleFactory(){
  bubbleManager.run(); 
  bubbleManager.draw();
}
