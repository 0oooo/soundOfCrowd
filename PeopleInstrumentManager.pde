/**
* Keep a list of all the people detected. 
* If someone has moved, remove it from the list
* If someone is still there, increase its persistance
* Notify the Background event when the threshold of persistance has been reached
* => ex. if someone has been in the same place for 3 times, becomes a bubble 
*/

class PeopleInstrumentManager {

  private final int PERSISTANCE_THRESHOLD = 5; 
  private PeopleInstrument[] listOfPeople;
  private boolean hasNewElementForBackground; 
  
  public PeopleInstrumentManager(){
    listOfPeople = new PeopleInstrument[8];
    hasNewElementForBackground = false; 
  }
  
  private boolean isSomeoneIn(int depth){
    return (depth > 0); 
  }
  
  //TODO FIX THIS
  private boolean isAlreadyInList(int position){
    return (listOfPeople[position - 1].getDepth() > 0); 
  }
  
  /**
  * Each 8 seconds, we receive a list of detectedPeople
  * There are 8 slots in the bars, so we detect 8 people at a time max
  * Each detected people is made of 2 int: its x-position and its depth
  */
  public void updateListOfPeople(int[][] detectedPeople){
    for(int[] currentPeople : detectedPeople){
      int position = currentPeople[0]; 
      int depth = currentPeople[1];
      if(isSomeoneIn(depth)){
         if(isAlreadyInList(position)){
           //updateDepth
         }else{
         
         }
      }
    }
  }
}
