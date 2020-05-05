/**
* Class that takes the current list of people detected and play a melody out of it. 
* The depth determines the pitch. 
* This is a 8-bit loop. minim class. 
*/


class SoundPlayer{
  
  final private String[] NOTE_SCALE = {"C","C#","D","D#","E","F","F#","G","G#", "A","A#","B"};
  final private String[] C_MINOR_NATURAL_SCALE = {"C3", "D"};//, "D#", "F", "G", "G#", "B", "C4"};
  final private int DEFAULT_PLAYER_BUFFER = 512; 
  private String path = "data/";
  private String extension = ".wav"; 
  private AudioSample[] players;
  private boolean played; 
  
  public SoundPlayer(){
    players = new AudioSample[C_MINOR_NATURAL_SCALE.length];
    loadAllSample(); 
    played = false; 
 
    //player = minim.loadSample("data/c.wav", 512);
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
  
  public void testLoading(){ 
    if(!played){
      for(AudioSample note : players){
        note.trigger(); 
      }
      played = true; 
    }
  }

}
