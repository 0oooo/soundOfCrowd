/**
* Class that takes the current list of people detected and play a melody out of it. 
* The depth determines the pitch. 
* This is a 8-bit loop. minim class. 
*/


class MelodyPlayer{
  
  float baseFrequency; 

String[] noteScale = {"C","C#","D","D#","E","F","F#","G","G#", "A","A#","B"};
String[] noteScaleInversed = {"B", "A#","A","G#","G","F#","F","E","D#","D","C#","C"};
String noteUsed; 
  
  
  float[] noteToFrequency(String[] notes, String octave){
  
  float[] baseNotes = new float[12];
  
  for( int i = 0; i < notes.length; i++){
    String noteAndOctave = notes[i] + octave; 
    float freq = Frequency.ofPitch(noteAndOctave).asHz(); 
    baseNotes[i] = freq; 
  }
    return baseNotes;
}
  

}
