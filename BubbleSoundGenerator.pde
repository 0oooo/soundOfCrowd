/**
* Takes a list of bubbles and their positions. 
* Every half seconds check if some are touching and if yes, generates a sound
*/


class BubbleSoundGenerator{
  
  final private String[] C_SCALE = {"a", "a#","b", "c","c#", "d","d#","e","f", "f#","g", "g#"};
  final private int DEFAULT_PLAYER_BUFFER = 512; 
  private String path = "data/bubbles/bubble-sample-";
  private String extension = ".wav"; 
  private AudioSample[] players; 
  private boolean debugOn; 
  
  public BubbleSoundGenerator(boolean debugOn){
    players = new AudioSample[C_SCALE.length];
    loadAllSample(); 
    this.debugOn = debugOn; 
  }
  
  private void loadAllSample(){
    int playersIndex = 0; 
    for(String note : C_SCALE){
      String notePath = path + note + extension;  
      AudioSample noteSound = minim.loadSample(notePath, DEFAULT_PLAYER_BUFFER); 
      players[playersIndex] = noteSound; 
      playersIndex++; 
    }
  }
  
  public void playNote (int notePosition){
    AudioSample note = players[notePosition];
    if(debugOn){
      println("Note played is" + C_SCALE[notePosition] );
    }
    note.trigger(); 
  }
}
