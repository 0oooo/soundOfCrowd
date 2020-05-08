/**
* Takes a list of bubbles and their positions. 
* Every half seconds check if some are touching and if yes, generates a sound
*/


class BubbleSoundGenerator{
  
  final private String[] C_MINOR_NATURAL_SCALE = {"C3", "D", "D#", "F", "G", "G#", "B", "C4"};
  final private int DEFAULT_PLAYER_BUFFER = 512; 
  private String path = "data/";
  private String extension = ".wav"; 
  private AudioSample[] players;
  private boolean played; 
  
  public BubbleSoundGenerator(){
    players = new AudioSample[C_MINOR_NATURAL_SCALE.length];
    loadAllSample(); 
    played = false; 
  }
  
  private void loadAllSample(){
    int playersIndex = 0; 
    for(String note : C_MINOR_NATURAL_SCALE){
      String notePath = path + note + extension;  
      AudioSample noteSound = minim.loadSample(notePath, DEFAULT_PLAYER_BUFFER); 
      players[playersIndex] = noteSound; 
      playersIndex++; 
    }
  }
  
  public void playNote (int notePosition){
    AudioSample note = players[notePosition];
    println("Note played is" + C_MINOR_NATURAL_SCALE[notePosition] );
    note.trigger(); 
  }
}
