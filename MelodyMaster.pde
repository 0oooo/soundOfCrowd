class MelodyMaster{

  private SoundPlayer soundPlayer; 
  
  public MelodyMaster(){
    soundPlayer = new SoundPlayer(); 
  }
  
  public void update(int noteIndex){
    soundPlayer.playNote(noteIndex); 
  }

}
