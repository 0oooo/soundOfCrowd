
class PeopleInstrument {
  private int horizontalPosition; 
  private int depthPosition; 
  private int persistanceInTime; 
  
  public PeopleInstrument(){
    depthPosition = 0; 
    persistanceInTime = 0; 
  }
  
  public PeopleInstrument(int horizontalPosition, int depthPosition){
    this.horizontalPosition = horizontalPosition; 
    this.depthPosition = depthPosition;
    this.persistanceInTime = 1; 
  }
  
  public int getPosition(){
    return horizontalPosition; 
  }
  
  public int getDepth(){
    return depthPosition; 
  }
  
  public int getPersistance() {
    return persistanceInTime; 
  }
  
  public void increasePersistance(){
    persistanceInTime++;
  }
  
  public void updateDepth(int newDepth){
    if(depthPosition != newDepth){
      depthPosition = newDepth; 
    }
  }
}
