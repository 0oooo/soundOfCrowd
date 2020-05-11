class MelodyMaster{

  private SoundPlayer soundPlayer; 
  
  public MelodyMaster(){
    soundPlayer = new SoundPlayer(); 
  }
  
  public void setDebugOn(){
     soundPlayer.setDebugOn();
  }
  
  public void update(int noteIndex){
    soundPlayer.playNote(noteIndex); 
  }

}
