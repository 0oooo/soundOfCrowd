import java.util.Map;


ArrayList<String> modes = new ArrayList<String>(); 
String selectedMode = ""; 
int state = 0; 
String errorText = "";

void initMode(){
  modes.add("debug"); 
  modes.add("kinect"); 
  modes.add("play"); 
  modes.add("bubble"); 
}

void resetSelectedMode(){
  selectedMode = ""; 
}

boolean isInListOfModes(String selectedMode){
  selectedMode = selectedMode.toLowerCase(); 
  for(String mode : modes){
    if(mode.equals(selectedMode)){
      return true; 
    }
  }
  return false; 
}
